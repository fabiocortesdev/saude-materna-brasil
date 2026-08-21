import pandas as pd
from pysus import sinasc
from google.cloud import bigquery
import gc

# ---------------------------------------------------------------------
# CONFIGURATION
# ---------------------------------------------------------------------
PROJECT_ID = "silver-impulse-314915"
DATASET_ID = "saude_materno_infantil"
TABLE_ID = "nascidos_vivos"
 
# Start small (1 state, 1 year), validate, then widen to 27 states / 5 years.
STATES = ["PR", "RS", "SC",]
YEARS = [2017,2018,2019,2020,2021]

# ---------------------------------------------------------------------
# LOOKUP TABLE: state code -> Brazilian region
# ---------------------------------------------------------------------
UF_TO_REGION = {
    "AC": "North", "AP": "North", "AM": "North", "PA": "North", "RO": "North", "RR": "North", "TO": "North",
    "AL": "Northeast", "BA": "Northeast", "CE": "Northeast", "MA": "Northeast", "PB": "Northeast",
    "PE": "Northeast", "PI": "Northeast", "RN": "Northeast", "SE": "Northeast",
    "DF": "Midwest", "GO": "Midwest", "MT": "Midwest", "MS": "Midwest",
    "ES": "Southeast", "MG": "Southeast", "RJ": "Southeast", "SP": "Southeast",
    "PR": "South", "RS": "South", "SC": "South",
}

# ---------------------------------------------------------------------
# COLUMNS OF INTEREST
# ---------------------------------------------------------------------
COLUMNS_OF_INTEREST = [
    "IDADEMAE", "ESCMAE2010", "CONSULTAS", "GESTACAO",
    "PARTO", "PESO", "SEXO", "DTNASC", "APGAR5",
    "QTDFILVIVO", "ESTCIVMAE", "IDADEPAI", "CODMUNRES",
]

# ---------------------------------------------------------------------
# FUNCTION: download and prepare one state/year
# ---------------------------------------------------------------------
def download_state_year(uf: str, year: int) -> pd.DataFrame | None:
    """Downloads SINASC for ONE state and ONE year, already reduced to the
    columns of interest (UF, YEAR and REGION). Returns None if
    no data is available for that state/year."""

    print(f"Downloading SINASC for {uf}/{year} ...")
    df = sinasc(state=uf, year=year, as_dataframe=True)

    if df.empty:
        print(f"  -> No data available for {uf}/{year}, skipping.")
        return None

    existing_columns = [c for c in COLUMNS_OF_INTEREST if c in df.columns]
    df = df[existing_columns].copy()

    df["UF"] = uf
    df["YEAR"] = year
    df["REGION"] = UF_TO_REGION[uf]

    return df


# ---------------------------------------------------------------------
# MAIN: download everything and load into BigQuery
# ---------------------------------------------------------------------
def main():
    client = bigquery.Client(project=PROJECT_ID)
    target_table = f"{PROJECT_ID}.{DATASET_ID}.{TABLE_ID}"

    total_rows = 0
    for i, uf in enumerate(STATES):
        state_parts = [download_state_year(uf, year) for year in YEARS]
        state_parts = [p for p in state_parts if p is not None]

        if not state_parts:
            print(f"No data at all for {uf}, skipping state.")
            continue

        df_state = pd.concat(state_parts, ignore_index=True)

        job_config = bigquery.LoadJobConfig(
            write_disposition=bigquery.WriteDisposition.WRITE_APPEND,
            autodetect=True,
        )
        job = client.load_table_from_dataframe(df_state, target_table, job_config=job_config)
        job.result()

        total_rows += len(df_state)
        print(f"  -> {uf}: {len(df_state):,} rows loaded "
              f"(table total so far: {client.get_table(target_table).num_rows:,})")

        del state_parts, df_state
        gc.collect()

    print(f"Done. Total rows downloaded across all states: {total_rows:,}")


if __name__ == "__main__":
    main()