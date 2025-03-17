import pandas as pd


dfe = pd.read_excel('../data/документация/КТ_Кировский.xlsx')
dfc = pd.read_csv('../data/документация/sp.csv')

dfec = dfe.copy(deep=True)
dfcc = dfc.copy(deep=True)

dfcc.columns = ['Номер ИД', 'Номер', 'Счет', 'Сумма', 'Пени', 'ГосПошлина']

dfcc['Сумма'] = dfcc['Сумма'].replace(',', '.', regex=True).astype(float)
dfcc['Пени'] = dfcc['Пени'].replace(',', '.', regex=True).astype(float)
dfcc['ГосПошлина'] = dfcc['ГосПошлина'].replace(',', '.', regex=True).astype(float)
dfcc['Общий долг'] = dfcc[['Сумма', 'Пени', 'ГосПошлина']].sum(axis=1)

merged_df = pd.merge(dfec, dfcc[['Номер ИД', 'Сумма', 'Пени', 'ГосПошлина', 'Общий долг']], how='inner')
merged_df.to_excel('../data/документация/КТ_Кировский_Обновленный.xlsx')