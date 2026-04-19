from fastapi import FastAPI, Request, Query, HTTPException, Form
from fastapi.templating import Jinja2Templates
from fastapi.responses import HTMLResponse, RedirectResponse
from psycopg.errors import UniqueViolation
import os
from .db import get_conn
import paho.mqtt.client as mqtt
from .models import DeviceCreate, AssignmentCreate, AssignmentReturn
import datetime

app = FastAPI(title="Inventar Starter", version="0.1.0")
templates = Jinja2Templates(directory=os.path.join(os.path.dirname(__file__), "templates"))

MQTT_HOST = os.getenv("MQTT_HOST", "mqtt")
MQTT_PORT = int(os.getenv("MQTT_PORT", "1883"))

def mqtt_client():
    c = mqtt.Client()
    c.connect(MQTT_HOST, MQTT_PORT, keepalive=30)
    return c

@app.get("/health")
async def health():
    db_state = "ok"
    mqtt_state = "ok"
    try:
        with get_conn() as conn, conn.cursor() as cur:
            cur.execute("select 1")
            cur.fetchone()
    except Exception as ex:
        db_state = f"error:{type(ex).__name__}"

    try:
        c = mqtt_client()
        c.disconnect()
    except Exception as ex:
        mqtt_state = f"degraded:{type(ex).__name__}"

    return {"status": "ok" if db_state == "ok" else "degraded", "db": db_state, "mqtt": mqtt_state}

@app.get("/", response_class=HTMLResponse)
async def index(request: Request):
    return templates.TemplateResponse("index.html", {"request": request, "title": "Inventar Starter"})

@app.get("/inventory", response_class=HTMLResponse)
async def inventory_page(request: Request):
    with get_conn() as conn, conn.cursor() as cur:
        cur.execute(
            """
            select device.model, device_type.device_type_name, location.location_name,
            case when assignment.returned_at is null AND assignment.issued_at is not null then 'ausgeliehen'
            else 'frei'
            end as status
            from device
            join device_type on device.device_type_id = device_type.id
            join location on device.location_id = location.id
            left join assignment on device.id = assignment.device_id
            """
        )
        devices = list(cur.fetchall())
        print(len(devices))
        return templates.TemplateResponse("inventory.html", {"request": request, "title": "Inventar Starter", "devices": devices})

@app.post("/mqtt/publish")
async def mqtt_publish(topic: str = Query(...), payload: str = Query(...)):
    c = mqtt_client()
    c.publish(topic, payload, qos=0, retain=False)
    c.disconnect()
    return {"ok": True, "topic": topic, "payload": payload}

@app.get("/devices")
async def get_devices():
    with get_conn() as conn, conn.cursor() as cur:
        cur.execute(
        "select * from device"
        )
        devices = list(cur.fetchall())
        return devices

@app.post("/devices")
async def post_devices(serial_number = Form(...), device_type_id = Form(...), location_id = Form(...)):
    data = DeviceCreate(serial_number=serial_number,device_type_id=device_type_id, location_id=location_id)
    try:
        with get_conn() as conn, conn.cursor() as cur:
            cur.execute(
                """
                insert into device (serial_number, device_type_id, location_id) values (%s, %s, %s)
                returning (id, serial_number, device_type_id, location_id)
                """,
                (data.serial_number, data.device_type_id, data.location_id)
            )
            device = cur.fetchone()
            return RedirectResponse("/inventory", status_code=303)
    except UniqueViolation:
        raise HTTPException(status_code=409, detail="Serial number nicht unique")

@app.post("/assignments")
async def post_assignments(person_id, device_id, issued_at: str | None = None, returned_at: str | None = None):
    data = AssignmentCreate(person_id=person_id, device_id=device_id, issued_at=issued_at, returned_at=returned_at)
    if data.issued_at and data.returned_at:
        date_issued_at = datetime.datetime.strptime(data.issued_at, "%d-%m-%Y")
        date_returned_at = datetime.datetime.strptime(data.returned_at, "%d-%m-%Y")
        if (date_returned_at < date_issued_at):
            raise HTTPException(status_code=422, detail="time logic wrong")

    
    
    with get_conn() as conn, conn.cursor() as cur:
        cur.execute(
            """
            select * from assignment where device_id = %s and returned_at is null and issued_at is not null
            """,
            (data.device_id,)
        )
        assignments = list(cur.fetchall())
        if len(assignments) > 0:
            raise HTTPException(status_code=409, detail="Conflict bei zweiter aktiver Ausleihe")

        cur.execute(
            """
            insert into assignment (person_id, device_id, issued_at, returned_at) values (%s, %s, %s, %s)
            returning (id, person_id, device_id, issued_at, returned_at)
            """,
            (data.person_id, data.device_id, data.issued_at, data.returned_at)
        )
        assignment = cur.fetchone()
        return assignment

@app.get("/assignments/active")
async def get_assignments_active():
    with get_conn() as conn, conn.cursor() as cur:
        cur.execute(
        "select * from assignment where assignment.returned_at is null"
        )
        assignments = list(cur.fetchall())
        return assignments

@app.post("/assignments/{id}/return")
async def post_assignments_return(id):
    now = str(datetime.datetime.now())
    data = AssignmentReturn(returned_at=now)
    with get_conn() as conn, conn.cursor() as cur:
        cur.execute(
            """
            update assignment set returned_at = %s where id = %s
            returning (id, person_id, device_id, issued_at, returned_at)
            """,
            (data.returned_at, id)
        )
        assignment = cur.fetchone()
        return assignment


