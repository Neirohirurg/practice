-- Задание 7
--
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
-- AND O.ROW_ID IN (SELECT KO.[Категории-Организация] FROM [Категории организаций] KO WHERE KO.[Категории организаций] IN (7036, 7034))
GROUP BY LS.Номер, NS.Счет, NS.[Месяц долга], O.Наименование, O.ROW_ID, KR.ФИО, KR.[Дата рождения], KR.[Дата смерти]


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
WHERE  O.ИНН ='3444259579' and SD.НомерДокумента = '2-89-703/2022'
-- AND O.ROW_ID IN (SELECT KO.[Категории-Организация] FROM [Категории организаций] KO WHERE KO.[Категории организаций] IN (7036, 7034))
GROUP BY VZ.Номер, VZ.[Счет-Взыскания],  SD.ГосПошлина, Sd.Сумма2, VZ.ДатНачДолга, VZ.ДатКнцДолга, VF.Название, SF.Имя, SD.НомерДокумента, SD.ROW_ID, VZ.ОплатаПени, VZ.ОплатаГоспошлины

drop table if EXISTS #tempSP

SELECT VZ.Номер, VZ.Фаза, VZ.НомерДокумента, NS.Счет, ROUND(SUM(NS.Сумма), 2) as 'Сумма', 
    CASE VZ.Фаза WHEN 'Подача' THEN ROUND(VZ.Пени - VZ.ОплатаПени, 2) ELSE ROUND(VZ.Пени, 2) END as 'Пени', 
    CASE VZ.Фаза WHEN 'Подача' THEN ROUND(VZ.ГосПошлина - VZ.ОплатаГоспошлины, 2) ELSE ROUND(VZ.ГосПошлина, 2) END as 'ГосПошлина', VZ.ОплатаПени, VZ.ОплатаГоспошлины
into #tempSP
FROM #tempVZ VZ
LEFT JOIN #tempNS NS ON NS.Счет = VZ.[Счет-Взыскания] --and [Месяц долга] BETWEEN ДатНачДолга AND ДатКнцДолга
-- WHERE VZ.НомерДокумента = '2-89-254/2023'
GROUP BY VZ.Номер, VZ.НомерДокумента, VZ.Фаза, VZ.[ROW_ID_Состояния], VZ.Пени, VZ.ГосПошлина, VZ.ОплатаПени, VZ.ОплатаГоспошлины, NS.Счет
ORDER BY VZ.Номер


SELECT SP.НомерДокумента as 'Номер ИД', SP.Номер, Sp.Счет, SP.Сумма, SP.Пени, SP.ГосПошлина
FROM #tempSP SP
WHERE SP.НомерДокумента != '' --and SP.НомерДокумента = '2-88-3397/2022'
ORDER BY SP.НомерДокумента
