import csv
import random
from datetime import datetime, timedelta
from faker import Faker

fake = Faker('ru_RU')

NUM_RECORDS = 1000

def generate_cells():
    with open('cells.csv', mode='w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow(['id_камеры', 'вместимость', 'наличие_видеонаблюдения', 'количество_охранников', 'тип_режима'])
        for i in range(1, NUM_RECORDS + 1):
            capacity = random.randint(2, 20)
            video = random.choice([True, False])
            guards = random.randint(1, 4)
            mode = random.choice(['Общий', 'Строгий'])
            writer.writerow([i, capacity, video, guards, mode])

def generate_fractions():
    factions_names = ['Воры в законе', 'Арийское братство', 'Мексиканская мафия', 'Нуэстра Фамилия', 'Техасский синдикат', 'Чёрная партизанская семья', 'Нацистские бунтари', 'Бладс']
    with open('fractions.csv', mode='w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow(['id_группировки', 'название_группировки', 'влияние', 'количество_камер', 'главная_плюшка'])
        for i in range(1, NUM_RECORDS + 1):
            name = f"{random.choice(factions_names)}-{i}" if i > len(factions_names) else factions_names[i-1]
            influence = random.randint(1, 10)
            cell_count = random.randint(1, 50)
            perk = random.choice(['Доступ к связи', 'Защита', 'Лучшая еда', 'Контроль общака', 'Связи на воле', 'Сигареты без лимита'])
            writer.writerow([i, name, influence, cell_count, perk])

import csv
import random

def generate_random_item_name():
    adjectives = [
        'Лысый','Кривой', 
        'Бешеный', 'Голодный', 'Вонючий', 'Пушистый',
        'Скользкий', 'Липкий', 'Мохнатый', 'Дырявый', 'Ржавый',
        'Пластиковый', 'Картонный', 'Резиновый', 'Магнитный', 'Светящийся',
        'Икающий', 'Чихающий',
        'Ленивый', 'Подозрительный', 'Сомнительный', 'Б/У', 'Просроченный', 'Домашний',
        'Квашеный', 'Сушёный', 'Копчёный', 'Маринованный', 'Замороженный'
    ]
    
    nouns = [
        'Пельмень', 'Борщ', 'Шаурма', 'Пицца', 'Огурец',
        'Батон', 'Сыр', 'Кефир', 'Майонез', 'Сгущёнка',
        'Чипсы', 'Сухарик', 'Леденец', 'Пряник', 'Вареник',
        'Помидор', 'Кабачок', 'Арбуз', 'Банан', 'Сухарь',
        'Кот', 'Хомяк', 'Пингвин', 'Ёжик', 'Крот',
        'Улитка', 'Жаба', 'Курица', 'Гусь', 'Баран',
        'Скунс', 'Осьминог', 'Муравей', 'Комар', 'Таракан',
        'Хорёк', 'Сурок', 'Бобёр', 'Енот', 'Слон',
        'Носок', 'Тапок', 'Веник', 'Утюг', 'Горшок',
        'Чайник', 'Ножницы', 'Пуговица', 'Валенок', 'Кирпич',
        'Швабра', 'Тряпка', 'Батарейка', 'Лампочка', 'Гвоздь',
        'Кастрюля', 'Сковорода', 'Термос', 'Фонарик', 'Бубен',
        'Борода', 'Лысина', 'Храп', 'Пузырь', 'Танец',
        'Смех', 'Взгляд', 'Шёпот', 'Сон', 'Прыжок',
        'Бублик', 'Сундук', 'Кактус', 'Барабан', 'Самовар'
    ]
    
    actions = [
        'который храпит',
        'который поёт',
        'который танцует',
        'который икает',
        'который чихает',
        'который смеётся',
        'который плачет',
        'который спит',
        'который прыгает',
        'который летает',
        'который кусается',
        'который липнет',
        'который воняет',
        'который светится',
        'который исчезает'
    ]
    
    style = random.choice([
        'adj_noun', 'adj_noun', 'adj_noun',
        'adj_noun_conn', 'adj_noun_conn',
        'noun_action', 'noun_action',
        'noun_only'
    ])
    
    if style == 'adj_noun':
        name = f"{random.choice(adjectives)} {random.choice(nouns)}"
    elif style == 'adj_noun_conn':
        name = (f"{random.choice(adjectives)} {random.choice(nouns)} ")
    elif style == 'noun_action':
        name = f"{random.choice(nouns)}, {random.choice(actions)}"
    else:
        name = random.choice(nouns)
    
    return name


def generate_items():
    with open('items.csv', mode='w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow(['id_предмета', 'название', 'стоимость', 'редкость', 'степень_риска'])
        for i in range(1, NUM_RECORDS + 1):
            item_name = generate_random_item_name()
            price = random.randint(500, 50000)
            rarity = random.choice(['Обычная', 'Редкая', 'Уникальная', 'Легендарная'])
            risk = random.choice(['Низкая', 'Средняя', 'Высокая', 'Критическая'])
            writer.writerow([i, item_name, price, rarity, risk])

def generate_guards():
    with open('guards.csv', mode='w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow(['id_охранника', 'имя_охранника', 'склонность_к_сделкам', 'внимательность', 'смена'])
        for i in range(1, NUM_RECORDS + 1):
            name = fake.name_male()
            corruption = random.randint(1, 10) 
            attention = random.randint(1, 10)
            shift = random.choice(['Дневная', 'Ночная', 'Сутки через трое', 'Вечерняя'])
            writer.writerow([i, name, corruption, attention, shift])

def generate_prisoners():
    with open('prisoners.csv', mode='w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow(['id_заключенного', 'имя_заключенного', 'статья_ук', 'статус', 'срок', 'id_камеры', 'id_группировки', 'id_босса'])
        for i in range(1, NUM_RECORDS + 1):
            gender = random.choice(['male', 'female'])
            if gender == 'male':
                name = f"{fake.last_name_male()} {fake.first_name_male()} {fake.middle_name_male()}"
            else:
                name = f"{fake.last_name_female()} {fake.first_name_female()} {fake.middle_name_female()}"
            article = f"УК РФ Ст. {random.randint(105, 300)}"
            status = random.choice(['Отбывает срок', 'Ожидает суда', 'В карцере', 'Готовится к УДО'])
            term = random.randint(1, 25)
            cell_id = random.randint(1, NUM_RECORDS)
            faction_id = random.randint(1, NUM_RECORDS) if random.random() > 0.3 else ''
            boss_id = random.randint(1, i - 1) if i > 1 and random.random() > 0.5 else ''
            writer.writerow([i, name, article, status, term, cell_id, faction_id, boss_id])

def generate_deals():
    with open('deals.csv', mode='w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow(['id_сделки', 'id_заключенного', 'id_предмета', 'id_охранника', 'дата_и_время', 'объем_сделки', 'статус_сделки'])
        for i in range(1, NUM_RECORDS + 500): 
            prisoner_id = random.randint(1, NUM_RECORDS)
            item_id = random.randint(1, NUM_RECORDS)
            guard_id = random.randint(1, NUM_RECORDS)
            
            start_date = datetime.now() - timedelta(days=365)
            random_date = start_date + timedelta(days=random.randint(0, 365), minutes=random.randint(0, 1440))
            dt_str = random_date.strftime("%Y-%m-%d %H:%M:%S")
            
            volume = random.randint(1, 10)
            status = random.choice(['Успешно', 'Сорвалась', 'В процессе', 'Раскрыта начальством'])
            
            writer.writerow([i, prisoner_id, item_id, guard_id, dt_str, volume, status]) 

def generate_data():
    print("Генерация данных...")

    print("1/6 Генерация камер...")
    generate_cells()

    print("2/6 Генерация группировок...")
    generate_fractions()

    print("3/6 Генерация предметов контрабанды...")
    generate_items()

    print("4/6 Генерация охранников...")
    generate_guards()

    print("5/6 Генерация заключенных...")
    generate_prisoners()

    print("6/6 Генерация сделок...")
    generate_deals()

    print("Генерация данных завершена!")


if __name__ == '__main__':
    generate_data()