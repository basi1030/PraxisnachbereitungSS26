import pandas as pd
import os
path = os.path.abspath("python/Praxisnachbereitung.xlsx")
df = pd.read_excel(path, sheet_name="Gesamt")
print(df)