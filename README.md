# **Производственная практика**

#### Производственная практика посвящена анализу данных в сфере досудебного взыскания задолженностей. 
#### Цель исследования — выявить закономерности и разработать аналитические инструменты для повышения эффективности возврата долгов.

## **Детальное описание исследования**  

**1. Постановка вопросов:**  
- Как можно эффективно выявлять должников с использованием запросов к базе данных?  
- Какие критерии сегментации позволяют структурировать задолженности наиболее эффективно?  
- Как анализ данных может помочь в прогнозировании вероятности возврата задолженности?  
- Какие закономерности можно обнаружить в данных о задолженностях?  

**2. Проверяемые гипотезы:**  
- Автоматизированная сегментация должников по ключевым параметрам (срок просрочки, сумма долга, платежеспособность) позволяет повысить точность аналитики.  
- Использование структурированных данных даёт возможность выявить скрытые паттерны и предсказать вероятность погашения долга.  
- Глубокий анализ задолженностей помогает оптимизировать стратегии досудебного взыскания.  

**3. Основные цели:**  
- Разработать эффективные SQL-запросы для анализа задолженностей.  
- Оптимизировать процесс сегментации должников для улучшения работы с данными.  
- Выявить ключевые закономерности, которые влияют на возврат задолженности.  
- Подготовить аналитические отчёты для поддержки решений по взысканию долгов.  

### **Мотивация исследования**  

Данное исследование имеет важное значение как с точки зрения обучения, так и для практического применения.  

- **Научная значимость:** Процесс анализа данных о задолженностях позволяет глубже изучить методы работы с базами данных, сегментации и предиктивного анализа. Это способствует развитию навыков работы с большими массивами данных и поиску закономерностей в финансовой сфере.  
- **Практическое применение:** Полученные знания и методы можно использовать для оптимизации процессов досудебного взыскания, повышения точности прогнозирования и улучшения стратегий работы с должниками.  
- **Вклад в развитие области:** Развитие навыков аналитики данных открывает возможности для дальнейшего совершенствования методов анализа, внедрения автоматизированных решений и повышения эффективности работы с задолженностями. Это не только способствует личному профессиональному росту, но и может внести вклад в улучшение процессов управления задолженностями в реальной практике.

## Установка

### Предварительные требования

- Python 3.x (или другой язык/среда)
- Необходимые библиотеки
    - pandas (обработка и анализ данных)
    - openpyxl (работа с Excel-файлами)
    - matplotlib (для визуализации данных)

### Инструкция по установке

1. Установите Miniconda: https://docs.conda.io/en/latest/miniconda.html
2. Склонируйте репозиторий:
   
    ```bash
    
    git clone https://github.com/Neirohirurg/pratice.git
    
4. Создайте окружение из файла environment.yml, если он есть:
   
   ```bash   
   conda env create -f environment.yml
   Иначе:
   conda create --name name
   
5. Активируйте окружение:
   
   ```bash
   conda activate pp
   
7. Запустите проект: 
   ```bash
   
   python src/main.py
8. При обновлении зависимостей выполните:
 
   ```bash
   conda env export --from-history > environment.yml   
   ```
## Использование

```bash
    python main.py --config config.yaml
```   
Или

```bash
    import project_module
    project_module.run_experiment()
```

## Результаты
В процессе анализа были выявлены ключевые закономерности, представленные в виде таблиц и диаграмм. Полный отчёт доступен по ссылке: 

## Данные
Исходные данные хранятся в формате .csv, расположены в папке data/документация/. Предварительная обработка выполняется скриптом main.py.

## Благодарности
Отметьте всех, кто оказал помощь или предоставил ресурсы для реализации проекта. Можно указать:

- Научных руководителей
- Сотрудников лаборатории
- Сообщество open-source

### Полезные ссылки на практику
- Диаграммы: https://app.diagrams.net/
- Виртуальная среда разработки: https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html
- Менеджер пакетов: https://pypi.org/project/pip/
- Библиотека для работы с табличными структурами данных: https://pandas.pydata.org/docs/
- Среда разработки: https://code.visualstudio.com/
- SQL простым языком: https://metanit.com/sql/sqlserver/4.2.php
- Умный переводчик: https://www.deepl.com/ru/translator
- Язык программирования: https://docs.python.org/3/
- Практика SQL/Pandas/Python: https://leetcode.com/
Нейросети:
- Без VPN: https://www.deepseek.com/
- С VPN: https://chatgpt.com/
- С VPN: https://x.ai/


