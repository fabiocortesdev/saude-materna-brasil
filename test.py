import pandas as pd
from pysus import sinasc

 
# Small test 
STATES = ["RJ"]
YEARS = [2022]


# --- TEST EXPLORATION ---
df_teste = sinasc(state=STATES[0], year=YEARS[0], as_dataframe=True)

print(f"Testando download de SINASC para {STATES[0]}/{YEARS[0]} ...")
print("Formato (linhas, colunas):", df_teste.shape)
print("\nColunas disponíveis:")
print(df_teste.columns.tolist())
print("\nPrimeiras linhas:")
print(df_teste.head())