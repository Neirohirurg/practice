-- Задание 7
--
drop table if EXISTS #tempVZ

SELECT VZ.Номер, VZ.[Счет-Взыскания], Sd.Сумма2 as 'Пени', SD.ГосПошлина, VZ.ДатНачДолга, VZ.ДатКнцДолга
into #tempVZ
FROM [Взыскание задолженности] VZ
JOIN [Состояние документа] SD ON SD.[ROW_ID] = VZ.[Документ-Фаза]
JOIN [Виды фаз] VF ON VF.ROW_ID = SD.[Фаза-Состояние]
LEFT JOIN [Состояния фаз] SF ON SD.[ПодФаза-Состояние] = SF.ROW_ID
JOIN [Держатели долга] DD ON DD.ROW_ID = VZ.[Держатели долга-Взыскания]
JOIN [Организации] O ON O.ROW_ID = DD.[Держатели-Организация]
WHERE  O.ИНН ='3444259579'
AND O.ROW_ID IN (SELECT KO.[Категории-Организация] FROM [Категории организаций] KO WHERE KO.[Категории организаций] IN (7036, 7034))
GROUP BY VZ.Номер, VZ.[Счет-Взыскания],  SD.ГосПошлина, Sd.Сумма2, VZ.ДатНачДолга, VZ.ДатКнцДолга


drop table if EXISTS #tempNS

SELECT ROUND(SUM(NS.[Сумма]), 2) as "Сумма", LS.Номер as 'Номер ЛЦ', NS.Счет, NS.[Месяц долга], O.Наименование, O.ROW_ID as 'ROW_ID_Организации', 
KR.ФИО, KR.[Дата рождения], KR.[Дата смерти]
into #tempNS
FROM [НСальдо] NS
JOIN [Лицевые счета] LS ON LS.ROW_ID = NS.[Счет]
JOIN [Организации] O ON O.ROW_ID = NS.Поставщик
JOIN [Карточки регистрации] KR ON KR.ROW_ID = NS.Счет
WHERE NS.[Месяц расчета] = '2025-02-01' AND NS.[Месяц долга] < '2025-02-01' and NS.[Сумма] > 0
AND O.ИНН ='3444259579'
AND O.ROW_ID IN (SELECT KO.[Категории-Организация] FROM [Категории организаций] KO WHERE KO.[Категории организаций] IN (7036, 7034))
GROUP BY LS.Номер, NS.Счет, NS.[Месяц долга], O.Наименование, O.ROW_ID, KR.ФИО, KR.[Дата рождения], KR.[Дата смерти]

SELECT VZ.Номер, NS.Счет, NS.Сумма, VZ.Пени, VZ.ГосПошлина, [Месяц долга] FROM #tempVZ VZ
Right JOIN #tempNS NS ON NS.Счет = VZ.[Счет-Взыскания] 
WHERE [Месяц долга] BETWEEN Vz.ДатНачДолга AND VZ.ДатКнцДолга
ORDER BY NS.Счет, VZ.Номер












drop table if EXISTS #tempNS

SELECT ROUND(SUM(NS.[Сумма]), 2) as "Сумма", LS.Номер as 'Номер ЛЦ', NS.Счет, NS.[Месяц долга], O.Наименование, O.ROW_ID as 'ROW_ID_Организации', 
KR.ФИО, KR.[Дата рождения], KR.[Дата смерти]
into #tempNS
FROM [НСальдо] NS
JOIN [Лицевые счета] LS ON LS.ROW_ID = NS.[Счет]
JOIN [Организации] O ON O.ROW_ID = NS.Поставщик
JOIN [Карточки регистрации] KR ON KR.ROW_ID = NS.Счет
WHERE NS.[Месяц расчета] = '2025-02-01' AND NS.[Месяц долга] < '2025-02-01' and NS.[Сумма] > 0
AND O.ИНН ='3444259579'
AND O.ROW_ID IN (SELECT KO.[Категории-Организация] FROM [Категории организаций] KO WHERE KO.[Категории организаций] IN (7036, 7034))
GROUP BY LS.Номер, NS.Счет, NS.[Месяц долга], O.Наименование, O.ROW_ID, KR.ФИО, KR.[Дата рождения], KR.[Дата смерти]

drop table if EXISTS #tempVZ

SELECT VZ.Номер, VZ.[Счет-Взыскания], Sd.Сумма2 as 'Пени', SD.ГосПошлина, VZ.ДатНачДолга, VZ.ДатКнцДолга,
 CONCAT(VF.Название, ' ', SF.Имя) as 'Фаза + Состояние', SD.НомерДокумента, SD.ROW_ID as 'ROW_ID_Состояния'
into #tempVZ
FROM [Взыскание задолженности] VZ
JOIN [Состояние документа] SD ON SD.[Документ-Состояние] = VZ.[ROW_ID]
JOIN [Виды фаз] VF ON VF.ROW_ID = SD.[Фаза-Состояние]
LEFT JOIN [Состояния фаз] SF ON SD.[ПодФаза-Состояние] = SF.ROW_ID
JOIN [Держатели долга] DD ON DD.ROW_ID = VZ.[Держатели долга-Взыскания]
JOIN [Организации] O ON O.ROW_ID = DD.[Держатели-Организация]
JOIN Производство P ON P.[Производство-Дело] = VZ.ROW_ID
WHERE  O.ИНН ='3444259579'
AND O.ROW_ID IN (SELECT KO.[Категории-Организация] FROM [Категории организаций] KO WHERE KO.[Категории организаций] IN (7036, 7034))
GROUP BY VZ.Номер, VZ.[Счет-Взыскания],  SD.ГосПошлина, Sd.Сумма2, VZ.ДатНачДолга, VZ.ДатКнцДолга, VF.Название, SF.Имя, SD.НомерДокумента, SD.ROW_ID


SELECT VZ.Номер, VZ.[Фаза + Состояние], VZ.НомерДокумента, ROUND(SUM(NS.Сумма), 2) as 'Сумма', VZ.Пени, VZ.ГосПошлина
FROM #tempVZ VZ
JOIN #tempNS NS ON NS.Счет = VZ.[Счет-Взыскания]
WHERE [Месяц долга] BETWEEN Vz.ДатНачДолга AND VZ.ДатКнцДолга AND VZ.Номер = 2148408561
GROUP BY VZ.Номер, VZ.НомерДокумента, VZ.[Фаза + Состояние], VZ.[ROW_ID_Состояния], VZ.Пени, VZ.ГосПошлина
ORDER BY VZ.Номер





drop table if EXISTS #tempVZ

SELECT VZ.Номер, VZ.[Счет-Взыскания], Sd.Сумма2 as 'Пени', SD.ГосПошлина, VZ.ДатНачДолга, VZ.ДатКнцДолга,
 SF.Имя as 'Фаза', SD.НомерДокумента, SD.ROW_ID as 'ROW_ID_Состояния', VZ.ОплатаПени, VZ.ОплатаГоспошлины
into #tempVZ
FROM [Взыскание задолженности] VZ
JOIN [Состояние документа] SD ON SD.[Документ-Состояние] = VZ.[ROW_ID]
JOIN [Виды фаз] VF ON VF.ROW_ID = SD.[Фаза-Состояние]
LEFT JOIN [Состояния фаз] SF ON SD.[ПодФаза-Состояние] = SF.ROW_ID
JOIN [Держатели долга] DD ON DD.ROW_ID = VZ.[Держатели долга-Взыскания]
JOIN [Организации] O ON O.ROW_ID = DD.[Держатели-Организация]
JOIN Производство P ON P.[Производство-Дело] = VZ.ROW_ID
WHERE  O.ИНН ='3444259579'
AND O.ROW_ID IN (SELECT KO.[Категории-Организация] FROM [Категории организаций] KO WHERE KO.[Категории организаций] IN (7036, 7034))
GROUP BY VZ.Номер, VZ.[Счет-Взыскания],  SD.ГосПошлина, Sd.Сумма2, VZ.ДатНачДолга, VZ.ДатКнцДолга, VF.Название, SF.Имя, SD.НомерДокумента, SD.ROW_ID, VZ.ОплатаПени, VZ.ОплатаГоспошлины

drop table if EXISTS #tempSP

SELECT VZ.Номер, VZ.Фаза, VZ.НомерДокумента, NS.Счет, ROUND(SUM(NS.Сумма), 2) as 'Сумма', 
    CASE VZ.Фаза WHEN 'Подача' THEN ROUND(VZ.Пени - VZ.ОплатаПени, 2) ELSE ROUND(VZ.Пени, 2) END as 'Пени', 
    CASE VZ.Фаза WHEN 'Подача' THEN ROUND(VZ.ГосПошлина - VZ.ОплатаГоспошлины, 2) ELSE ROUND(VZ.ГосПошлина, 2) END as 'ГосПошлина', VZ.ОплатаПени, VZ.ОплатаГоспошлины
into #tempSP
FROM #tempVZ VZ
JOIN #tempNS NS ON NS.Счет = VZ.[Счет-Взыскания]
WHERE [Месяц долга] BETWEEN Vz.ДатНачДолга AND VZ.ДатКнцДолга 
GROUP BY VZ.Номер, VZ.НомерДокумента, VZ.Фаза, VZ.[ROW_ID_Состояния], VZ.Пени, VZ.ГосПошлина, VZ.ОплатаПени, VZ.ОплатаГоспошлины, NS.Счет
ORDER BY VZ.Номер

SELECT distinct SP.НомерДокумента, SP.Номер, Sp.Счет, SP.Сумма, SP.Пени, SP.ГосПошлина
FROM #tempSP SP
WHERE SP.НомерДокумента != ''
ORDER BY SP.НомерДокумента