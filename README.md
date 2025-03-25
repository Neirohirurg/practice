# **Тема: Создание ежемесячного отчета КТ**

### *Проект автоматизирует построение ежемесячного отчета КТ в сфере досудебного взыскания задолженностей.*

## **Детальное описание исследования**  

**1. Постановка вопросов:**  
- Как можно эффективно выявлять должников с использованием sql-запросов?   
- Как можно автоматизировать процесс построения ежемесячного отчета КТ?
  
**2. Основные цели:**  
- Разработать эффективные SQL-запросы для анализа задолженностей.  
- Подготовить аналитический результирующий отчёт по всем должникам.  

### **Мотивация исследования**  

*Полученные знания и методы можно использовать для оптимизации процессов построения других видов отчетов, повышения эффективности в работе с sql-запросами.*

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

3. Перейдите в проект
   
   ```bash
   cd pratice
   
4. Создайте окружение из файла environment.yml, если он есть:
   
   ```bash
   conda env create -f environment.yml
   ```
   
   Иначе:
   
   ```bash   
   conda create --name pp python=3.x pandas openpyxl matplotlib
   
5. Активируйте окружение:
   
   ```bash
   conda activate pp
   
6. Запустите проект: 
   ```bash
   python src/main.py
   
7. При обновлении зависимостей выполните:
 
   ```bash
   conda env export > environment.yml
   
## Запуск проекта
```bash
    python src/main.py
```   
#### *main.py загружает данные из CSV, обрабатывает их и формирует отчет в формате Excel.*

## Результаты
*В процессе анализа был составлен ежемясечный отчет по всем должникам, представленный в виде таблицы Excel. (Картинка отчета или файл Excel в src)*

## Данные
*Исходные данные хранятся в формате .csv, расположены в папке data/документация/. Предварительная обработка выполняется скриптом main.py.*

## Благодарности

*Благодарен своему наставнику по практике Мухину А.О. - https://github.com/pinbooll за поддержку и терпение.*

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


