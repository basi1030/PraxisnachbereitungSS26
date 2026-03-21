import pandas as pd 
path = "/home/casa/Desktop/HKA/Semester5/Parallel Computing/Projekt/code/Praxisnachbereitung.xlsx"
df = pd.read_excel(path, sheet_name="Gesamt")
print(df)