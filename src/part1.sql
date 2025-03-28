--
-- Задание 1
--
SELECT LS.Номер as "Номер", ROUND(SUM(NS.[Сумма]), 2) as "Сумма",
    CASE 
        WHEN O.ИНН = '3444259579' THEN 'КТ'
        WHEN O.ИНН = '3460019060' THEN 'КВ'
    END AS 'Наименование'
FROM [НСальдо] NS
JOIN [Лицевые счета] LS ON LS.ROW_ID = NS.[Счет]
JOIN [Организации] O ON O.ROW_ID = NS.Поставщик
WHERE NS.[Месяц расчета] = '2024-10-01' AND NS.[Месяц долга] = '2024-10-01' and NS.[Сумма] > 0
AND O.ИНН ='3444259579'
GROUP BY LS.Номер, O.ИНН
ORDER BY LS.Номер
--
-- Задание 2
-- 
SELECT LS.Номер as "Номер", ROUND(SUM(NS.[Сумма]), 2) as "Сумма", O.Наименование
FROM [НСальдо] NS
JOIN [Лицевые счета] LS ON LS.ROW_ID = NS.[Счет]
JOIN [Организации] O ON O.ROW_ID = NS.Поставщик
WHERE NS.[Месяц расчета] = '2024-10-01' AND NS.[Месяц долга] = '2024-10-01' and NS.[Сумма] > 0
AND O.ИНН ='3444259579' AND O.ROW_ID IN (SELECT KO.[Категории-Организация] FROM [Категории организаций] KO WHERE KO.[Категории организаций] = 7036)
GROUP BY LS.Номер, O.Наименование
ORDER BY LS.Номер
--
-- Задание 3
--
SELECT ROUND(SUM(NS.[Сумма]), 2) as "Сумма", LS.Номер, KR.[Счет-Наниматель], NS.[Месяц долга], O.Наименование, O.ROW_ID, KR.ФИО, KR.[Дата рождения], KR.[Дата смерти]
FROM [НСальдо] NS
JOIN [Лицевые счета] LS ON LS.ROW_ID = NS.[Счет]
JOIN [Организации] O ON O.ROW_ID = NS.Поставщик
JOIN [Карточки регистрации] KR ON KR.ROW_ID = LS.[Счет-Наниматель]
WHERE NS.[Месяц расчета] = '2024-10-01' AND NS.[Месяц долга] >= '2024-10-01' and NS.[Сумма] > 0
AND O.ИНН ='3444259579' 
AND O.ROW_ID IN (SELECT KO.[Категории-Организация] FROM [Категории организаций] KO WHERE KO.[Категории организаций] IN (7036, 7034))
GROUP BY LS.Номер, KR.[Счет-Наниматель], NS.[Месяц долга], O.Наименование, O.ROW_ID, KR.ФИО, KR.[Дата рождения], KR.[Дата смерти]
-- -- КТ
-- -- Остальное
SELECT * FROM [Категории организаций] KO
WHERE KO.[Категории организаций] = 7036
-- -- КТ
-- -- Цессии
SELECT * FROM [Категории организаций] KO
WHERE KO.[Категории организаций] = 7034
-- -- КВ
-- -- Остальное
SELECT * FROM [Категории организаций] KO
WHERE KO.[Категории организаций] = 7015
-- -- КВ
-- -- Цессии
SELECT * FROM [Категории организаций] KO
WHERE KO.[Категории организаций] = 7013
--
-- Задание 4
--
SELECT VZ.ROW_ID as 'ROW_ID_Взыскания', VZ.Номер, CONCAT(VF.Название, ' ', SF.Имя) as 'Фаза + Состояние', VZ.[Счет-Взыскания], VZ.ДатНачДолга, VZ.ДатКнцДолга
FROM [Взыскание задолженности] VZ
JOIN [Состояние документа] SD ON SD.[Документ-Состояние] = VZ.ROW_ID
JOIN [Виды фаз] VF ON VF.ROW_ID = SD.[Фаза-Состояние]
LEFT JOIN [Состояния фаз] SF ON SF.[Состояние-Фаза] = VF.ROW_ID
JOIN [Держатели долга] DD ON DD.ROW_ID = VZ.[Держатели долга-Взыскания]
JOIN [Организации] O ON O.ROW_ID = DD.[Держатели-Организация]
WHERE  O.ИНН ='3444259579'
AND O.ROW_ID IN (SELECT KO.[Категории-Организация] FROM [Категории организаций] KO WHERE KO.[Категории организаций] IN (7036, 7034))
GROUP BY VZ.ROW_ID, VZ.Номер, VF.Название, SF.Имя,  VZ.[Счет-Взыскания], VZ.ДатНачДолга, VZ.ДатКнцДолга
--
-- Задание 5
--
-- 1 способ объединения
--
drop table if EXISTS #temp
SELECT DF.*, VZ.ROW_ID as 'ROW_ID_Взыскания', VZ.Номер, CONCAT(VF.Название, ' ', SF.Имя) as 'Фаза + Состояние' 
into #temp
FROM [Взыскание задолженности] VZ
JOIN [Состояние документа] SD ON SD.[Документ-Состояние] = VZ.ROW_ID
JOIN [Виды фаз] VF ON VF.ROW_ID = SD.[Фаза-Состояние]
LEFT JOIN [Состояния фаз] SF ON SF.[Состояние-Фаза] = VF.ROW_ID
JOIN [Держатели долга] DD ON DD.ROW_ID = VZ.[Держатели долга-Взыскания]
JOIN [Организации] O ON O.ROW_ID = DD.[Держатели-Организация]
JOIN (SELECT ROUND(SUM(NS.[Сумма]), 2) as "Сумма", LS.Номер as 'Номер ЛЦ', KR.[Счет-Наниматель], NS.[Месяц долга], O.Наименование, O.ROW_ID as 'ROW_ID_Организации', KR.ФИО, KR.[Дата рождения], KR.[Дата смерти]
    FROM [НСальдо] NS
    JOIN [Лицевые счета] LS ON LS.ROW_ID = NS.[Счет]
    JOIN [Организации] O ON O.ROW_ID = NS.Поставщик
    JOIN [Карточки регистрации] KR ON KR.ROW_ID = LS.[Счет-Наниматель]
    WHERE NS.[Месяц расчета] = '2024-10-01' AND NS.[Месяц долга] >= '2024-10-01' and NS.[Сумма] > 0
    AND O.ИНН ='3444259579'
    AND O.ROW_ID IN (SELECT KO.[Категории Организаций] FROM [Категории организаций] KO WHERE KO.[Категории организаций] = 7034)
    GROUP BY LS.Номер, KR.[Счет-Наниматель], NS.[Месяц долга], O.Наименование, O.ROW_ID, KR.ФИО, KR.[Дата рождения], KR.[Дата смерти]) AS DF ON DF.[Счет-Наниматель] = VZ.[Счет-Взыскания]
WHERE O.ИНН ='3444259579'
AND O.ROW_ID IN (SELECT KO.[Категории Организаций] FROM [Категории организаций] KO WHERE KO.[Категории организаций] IN (7034))
AND VF.Название = 'Рассмотрение (абонентский отдел)'
--
-- 2 способ
--
WITH DF AS (
    SELECT ROUND(SUM(NS.[Сумма]), 2) as "Сумма", LS.Номер, KR.[Счет-Наниматель], NS.[Месяц долга], O.Наименование, O.ROW_ID as "Код организации", KR.ФИО, KR.[Дата рождения], KR.[Дата смерти]
    FROM [НСальдо] NS
    JOIN [Лицевые счета] LS ON LS.ROW_ID = NS.[Счет]
    JOIN [Организации] O ON O.ROW_ID = NS.Поставщик
    JOIN [Карточки регистрации] KR ON KR.ROW_ID = LS.[Счет-Наниматель]
    WHERE NS.[Месяц расчета] = '2024-10-01' AND NS.[Месяц долга] >= '2024-10-01' and NS.[Сумма] > 0
    AND O.ИНН ='3444259579'
    AND O.ROW_ID IN (SELECT KO.[Категории-Организация] FROM [Категории организаций] KO WHERE KO.[Категории организаций] IN (7036, 7034))
    GROUP BY LS.Номер, KR.[Счет-Наниматель], NS.[Месяц долга], O.Наименование, O.ROW_ID, KR.ФИО, KR.[Дата рождения], KR.[Дата смерти]
)

SELECT DF.*, VZ.ROW_ID, VZ.Номер, CONCAT(VF.Название, ' ', SF.Имя) as 'Фаза + Состояние' FROM [Взыскание задолженности] VZ
JOIN [Состояние документа] SD ON SD.[Документ-Состояние] = VZ.ROW_ID
JOIN [Виды фаз] VF ON VF.ROW_ID = SD.[Фаза-Состояние]
LEFT JOIN [Состояния фаз] SF ON SF.[Состояние-Фаза] = VF.ROW_ID
JOIN [Держатели долга] DD ON DD.ROW_ID = VZ.[Держатели долга-Взыскания]
JOIN [Организации] O ON O.ROW_ID = DD.[Держатели-Организация]
JOIN DF ON DF.[Счет-Наниматель] = VZ.[Счет-Взыскания]
WHERE O.ИНН ='3444259579'
AND O.ROW_ID IN (SELECT KO.[Категории-Организация] FROM [Категории организаций] KO WHERE KO.[Категории организаций] IN (7036, 7034))
AND VF.Название = 'Рассмотрение (абонентский отдел)'
--
-- 3 способ
--
SELECT ROUND(SUM(NS.[Сумма]), 2) as "Сумма", LS.Номер as 'Номер ЛЦ', KR.[Счет-Наниматель], NS.[Месяц долга], O.Наименование, O.ROW_ID as 'ROW_ID_Организации', KR.ФИО, KR.[Дата рождения], KR.[Дата смерти]
FROM [НСальдо] NS
JOIN [Лицевые счета] LS ON LS.ROW_ID = NS.[Счет]
JOIN [Организации] O ON O.ROW_ID = NS.Поставщик
JOIN [Карточки регистрации] KR ON KR.ROW_ID = LS.[Счет-Наниматель]
LEFT JOIN (
    SELECT VZ.ROW_ID as 'ROW_ID_Взыскания', VZ.Номер, CONCAT(VF.Название, ' ', SF.Имя) as 'Фаза + Состояние', VZ.[Счет-Взыскания]
    FROM [Взыскание задолженности] VZ
    JOIN [Состояние документа] SD ON SD.[Документ-Состояние] = VZ.ROW_ID
    JOIN [Виды фаз] VF ON VF.ROW_ID = SD.[Фаза-Состояние]
    LEFT JOIN [Состояния фаз] SF ON SF.[Состояние-Фаза] = VF.ROW_ID
    JOIN [Держатели долга] DD ON DD.ROW_ID = VZ.[Держатели долга-Взыскания]
    JOIN [Организации] O ON O.ROW_ID = DD.[Держатели-Организация]
    WHERE O.ИНН ='3444259579'
    AND O.ROW_ID IN (SELECT KO.[Категории-Организация] FROM [Категории организаций] KO WHERE KO.[Категории организаций] IN (7036, 7034))
) VZ ON Счет = VZ.[Счет-Взыскания]
WHERE NS.[Месяц расчета] = '2024-10-01' AND NS.[Месяц долга] >= '2024-10-01' and NS.[Сумма] > 0
AND O.ИНН ='3444259579'
AND O.ROW_ID IN (SELECT KO.[Категории-Организация] FROM [Категории организаций] KO WHERE KO.[Категории организаций] IN (7036, 7034))
GROUP BY LS.Номер, KR.[Счет-Наниматель], NS.[Месяц долга], O.Наименование, O.ROW_ID, KR.ФИО, KR.[Дата рождения], KR.[Дата смерти]


drop table if EXISTS #tempNS

SELECT ROUND(SUM(NS.[Сумма]), 2) as "Сумма", LS.Номер as 'Номер ЛЦ', KR.[Счет-Наниматель], NS.[Месяц долга], O.Наименование, O.ROW_ID as 'ROW_ID_Организации', KR.ФИО, KR.[Дата рождения], KR.[Дата смерти]
into #tempNS
FROM [НСальдо] NS
JOIN [Лицевые счета] LS ON LS.ROW_ID = NS.[Счет]
JOIN [Организации] O ON O.ROW_ID = NS.Поставщик
JOIN [Карточки регистрации] KR ON KR.ROW_ID = LS.[Счет-Наниматель]
LEFT JOIN (
    SELECT VZ.ROW_ID as 'ROW_ID_Взыскания', VZ.Номер, CONCAT(VF.Название, ' ', SF.Имя) as 'Фаза + Состояние', VZ.[Счет-Взыскания]
    FROM [Взыскание задолженности] VZ
    JOIN [Состояние документа] SD ON SD.[Документ-Состояние] = VZ.ROW_ID
    JOIN [Виды фаз] VF ON VF.ROW_ID = SD.[Фаза-Состояние]
    LEFT JOIN [Состояния фаз] SF ON SF.[Состояние-Фаза] = VF.ROW_ID
    JOIN [Держатели долга] DD ON DD.ROW_ID = VZ.[Держатели долга-Взыскания]
    JOIN [Организации] O ON O.ROW_ID = DD.[Держатели-Организация]
    WHERE O.ИНН ='3444259579'
    AND O.ROW_ID IN (SELECT KO.[Категории-Организация] FROM [Категории организаций] KO WHERE KO.[Категории организаций] IN (7036, 7034))
) vz ON Счет = VZ.[Счет-Взыскания]
WHERE NS.[Месяц расчета] = '2024-10-01' AND NS.[Месяц долга] >= '2024-10-01' and NS.[Сумма] > 0
AND O.ИНН ='3444259579'
AND O.ROW_ID IN (SELECT KO.[Категории-Организация] FROM [Категории организаций] KO WHERE KO.[Категории организаций] IN (7036, 7034))
GROUP BY LS.Номер, KR.[Счет-Наниматель], NS.[Месяц долга], O.Наименование, O.ROW_ID, KR.ФИО, KR.[Дата рождения], KR.[Дата смерти]


drop table if EXISTS #temp

SELECT ROUND(SUM(NS.[Сумма]), 2) as "Сумма", LS.Номер as 'Номер ЛЦ', KR.[Счет-Наниматель], NS.[Месяц долга],
        O.Наименование, O.ROW_ID as 'ROW_ID_Организации', KR.ФИО, KR.[Дата рождения],
        KR.[Дата смерти], FZ.ROW_ID_Взыскания, FZ.Фаза, FZ.[Дата постановки на фазу], FZ.ДатНачДолга, FZ.ДатКнцДолга, FZ.НомерДела
into #temp
FROM НСальдо NS
JOIN [Лицевые счета] LS ON LS.ROW_ID = NS.[Счет]
JOIN [Организации] O ON NS.Поставщик = O.ROW_ID
LEFT JOIN [Карточки регистрации] KR ON KR.ROW_ID = LS.[Счет-Наниматель]
LEFT JOIN (
    SELECT VZ.ROW_ID as 'ROW_ID_Взыскания', VZ.Номер AS НомерДела, (VF.Название + ' ' + ISNULL(SF.Имя, '')) as 'Фаза',
        VZ.[Счет-Взыскания], VZ.ДатНачДолга, VZ.ДатКнцДолга,
        SD.ДатНач AS [Дата постановки на фазу]
    FROM [Взыскание задолженности] VZ
    JOIN [Держатели долга] DD ON VZ.[Держатели долга-Взыскания] = DD.ROW_ID
    JOIN [Организации] O ON DD.[Держатели-Организация] = O.ROW_ID
    JOIN [Состояние документа] SD ON VZ.[Документ-Фаза] = SD.ROW_ID
    JOIN [Виды фаз] VF ON SD.[Фаза-Состояние] = VF.ROW_ID
    JOIN [Категории организаций] KO ON KO.[Категории-Организация] = O.ROW_ID
    LEFT JOIN [Состояния фаз] SF ON SD.[ПодФаза-Состояние] = SF.ROW_ID
    WHERE 
        O.ИНН ='3444259579'
        AND KO.[Категории организаций] IN (7036, 7034)
) FZ ON NS.Счет = FZ.[Счет-Взыскания] AND NS.[Месяц долга] BETWEEN FZ.ДатНачДолга AND FZ.ДатКнцДолга
WHERE 
    NS.[Месяц расчета] = '2025-02-01' 
    AND NS.[Месяц долга] < '2025-02-01' and NS.[Сумма] > 0
    AND O.ИНН ='3444259579'
    AND O.ROW_ID IN (SELECT KO.[Категории-Организация] FROM [Категории организаций] KO WHERE KO.[Категории организаций] IN (7036, 7034))
GROUP BY LS.Номер, KR.[Счет-Наниматель], NS.[Месяц долга], O.Наименование, O.ROW_ID, KR.ФИО, KR.[Дата рождения],
    KR.[Дата смерти], FZ.ROW_ID_Взыскания, FZ.Фаза, FZ.[Дата постановки на фазу], FZ.ДатНачДолга, FZ.ДатКнцДолга, FZ.НомерДела
--
-- Мунжилье 
--
SELECT T.* 
FROM #temp T
JOIN [Категории организаций] KO ON KO.[Категории-Организация] = T.ROW_ID_Организации
JOIN Реестры R ON T.[Номер ЛЦ] = R.[Реестры_состав-Лицевой]
WHERE 
    KO.[Категории организаций] = 7036
    AND R.Папки = 35700042;
--
-- Цессии
--
SELECT T.* 
FROM #temp T
JOIN [Категории организаций] KO ON KO.[Категории-Организация] = T.ROW_ID_Организации
WHERE 
    KO.[Категории организаций] = 7034
--
-- Остальное 
--
SELECT T.* 
FROM #temp T
JOIN [Категории организаций] KO ON KO.[Категории-Организация] = T.ROW_ID_Организации
WHERE 
    KO.[Категории организаций] = 7036
    AND T.[Счет-Наниматель] NOT IN (
        SELECT R.[Реестры_состав-Лицевой] 
        FROM Реестры R 
        WHERE R.Папки = 35700042);

--Взыскание задолжености
SELECT TOP 100 * FROM [Взыскание задолженности]

-- Виды фаз
SELECT TOP 100 * FROM [Виды фаз]
SELECT distinct VF.Название FROM [Виды фаз] VF 

SELECT distinct VF.Название FROM [Виды фаз] VF 
JOIN [Состояния фаз] SF ON SF.[Состояние-Фаза] = VF.ROW_ID

--Состояние фаз
SELECT TOP 100 * FROM [Состояния фаз]
SELECT distinct Имя FROM [Состояния фаз] 
--
-- Результат
--
drop table if EXISTS #tempNS

SELECT 
   ROUND(SUM(NS.[Сумма]), 2) as "Сумма",
   LS.Номер as 'Номер ЛЦ', 
   NS.Счет,
   NS.[Месяц долга],
   O.Наименование, O.ROW_ID as 'ROW_ID_Организации', 
   KR.ФИО, 
   KR.[Дата рождения],
   KR.[Дата смерти]
INTO #tempNS
FROM [НСальдо] NS
JOIN [Лицевые счета] LS ON LS.ROW_ID = NS.[Счет]
JOIN [Организации] O ON O.ROW_ID = NS.Поставщик
JOIN [Карточки регистрации] KR ON KR.ROW_ID = NS.Счет
WHERE 
   NS.[Месяц расчета] = '2025-02-01' 
   AND NS.[Месяц долга] < '2025-02-01' 
   AND NS.[Сумма] > 0
   AND O.ИНН ='3444259579'
   AND O.ROW_ID IN (
      SELECT 
         KO.[Категории-Организация] 
      FROM [Категории организаций] KO 
      WHERE 
         KO.[Категории организаций] IN (7036, 7034)
   )
GROUP BY 
   LS.Номер,
   NS.Счет,
   NS.[Месяц долга], 
   O.Наименование, 
   O.ROW_ID, 
   KR.ФИО, 
   KR.[Дата рождения], 
   KR.[Дата смерти]


drop table if EXISTS #tempVZ

SELECT 
   VZ.Номер, 
   VZ.[Счет-Взыскания], 
   Sd.Сумма2 as 'Пени', 
   SD.ГосПошлина, 
   VZ.ДатНачДолга, 
   VZ.ДатКнцДолга,
   SF.Имя as 'Фаза', 
   SD.НомерДокумента, 
   SD.ROW_ID as 'ROW_ID_Состояния', 
   VZ.ОплатаПени,
   VZ.ОплатаГоспошлины
INTO #tempVZ
FROM [Взыскание задолженности] VZ
JOIN [Состояние документа] SD ON SD.[Документ-Состояние] = VZ.[ROW_ID]
JOIN [Виды фаз] VF ON VF.ROW_ID = SD.[Фаза-Состояние]
LEFT JOIN [Состояния фаз] SF ON SD.[ПодФаза-Состояние] = SF.ROW_ID
JOIN [Держатели долга] DD ON DD.ROW_ID = VZ.[Держатели долга-Взыскания]
JOIN [Организации] O ON O.ROW_ID = DD.[Держатели-Организация]
WHERE  
   O.ИНН ='3444259579' 
   AND O.ROW_ID IN (
      SELECT 
         KO.[Категории-Организация] 
      FROM [Категории организаций] KO 
      WHERE 
         KO.[Категории организаций] IN (7036, 7034)
   )
GROUP BY 
   VZ.Номер, 
   VZ.[Счет-Взыскания],  
   SD.ГосПошлина, 
   Sd.Сумма2,
   VZ.ДатНачДолга,
   VZ.ДатКнцДолга, 
   VF.Название, 
   SF.Имя, 
   SD.НомерДокумента, 
   SD.ROW_ID, 
   VZ.ОплатаПени, 
   VZ.ОплатаГоспошлины

drop table if EXISTS #tempSP

SELECT 
   VZ.Номер, 
   VZ.Фаза, 
   VZ.НомерДокумента,
   NS.Счет,
   ROUND(SUM(NS.Сумма), 2) as 'Сумма', 
   CASE VZ.Фаза 
      WHEN 'Подача' 
      THEN ROUND(VZ.Пени - VZ.ОплатаПени, 2) 
      ELSE ROUND(VZ.Пени, 2) END as 'Пени', 
   CASE VZ.Фаза 
      WHEN 'Подача' 
      THEN ROUND(VZ.ГосПошлина - VZ.ОплатаГоспошлины, 2) 
      ELSE ROUND(VZ.ГосПошлина, 2) 
   END as 'ГосПошлина', 
   VZ.ОплатаПени, 
   VZ.ОплатаГоспошлины
INTO #tempSP
FROM #tempVZ VZ
LEFT JOIN #tempNS NS ON 
   NS.Счет = VZ.[Счет-Взыскания] 
   AND [Месяц долга] BETWEEN ДатНачДолга AND ДатКнцДолга
GROUP BY 
   VZ.Номер, 
   VZ.НомерДокумента, 
   VZ.Фаза, 
   VZ.[ROW_ID_Состояния], 
   VZ.Пени, 
   VZ.ГосПошлина, 
   VZ.ОплатаПени,
   VZ.ОплатаГоспошлины, 
   NS.Счет
ORDER BY 
   VZ.Номер

SELECT 
   SP.НомерДокумента as 'Номер ИД',
   SP.Номер, 
   Sp.Счет,
   SP.Сумма, 
   SP.Пени, 
   SP.ГосПошлина
FROM #tempSP SP
WHERE 
   SP.НомерДокумента != ''
ORDER BY 
   SP.НомерДокумента
