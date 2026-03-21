import pandas as pd 
path = "./Praxisnachbereitung.xlsx"
df = pd.read_excel(path, sheet_name="Gesamt")
print(df)