import pandas as pd


dfe = pd.read_excel('../data/документация/КТ_Кировский.xlsx')
dfc = pd.read_csv('../data/документация/sp.csv')

dfec = dfe.copy(deep=True)
dfcc = dfc.copy(deep=True)

dfcc['Сумма'] = dfcc['Сумма'].replace(',', '.', regex=True).astype(float)
dfcc['Пени'] = dfcc['Пени'].replace(',', '.', regex=True).astype(float)
dfcc['ГосПошлина'] = dfcc['ГосПошлина'].replace(',', '.', regex=True).astype(float)

dfcc['Номер ИД'] = dfcc['Номер ИД'].str.split(r',\s*')
dfcc = dfcc.explode('Номер ИД')

merged_df = pd.merge(dfec, dfcc[['Номер ИД', 'Сумма', 'Пени', 'ГосПошлина']], how='left').drop_duplicates()

merged_df['Общий долг'] = merged_df[['Сумма', 'Пени', 'ГосПошлина']].sum(axis=1)

print(f"Null - {merged_df[merged_df['Общий долг'].isna()].shape}, All - {merged_df.shape}")

merged_df.to_excel('../data/документация/КТ_Кировский_ОбщийДолг.xlsx')
