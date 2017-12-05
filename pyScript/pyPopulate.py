import psycopg2
import datetime
from itertools import groupby
from random import randint
from faker import Factory
fake = Factory.create()

conn = psycopg2.connect(
  "dbname=pbd user=postgres password=postgres"
)
conn.autocommit = True
cur = conn.cursor()
cur.execute("""DELETE FROM conferencedays""")
print(cur.statusmessage)
cur.execute("""DELETE FROM conferences""")
print(cur.statusmessage)

def create_conferences():
    conferences = []
    days=[]
    it_date = datetime.date(2003, 1,1)
    while it_date < datetime.date(2006, 1, 1):
        it_date += datetime.timedelta(randint(10, 20))
        conferences.append({
            "date": it_date,
            "len": randint(2, 3),
            "name": fake.sentence(nb_words=4),
            "discount_for_students": randint(0, 90),
            "description": fake.sentence(nb_words=10)
        })
    return conferences


def add_days_to_conferences(conferences):
    days=[]
    for c in conferences:
        for d in range(c["len"]):
            days.append({
                "conference_id": c["id"],
                "number_of_participants": randint(100, 300),
                "date": c["date"] + datetime.timedelta(d)
            })
    return days


def create_private_clients():
    private_clients=[]
    for i in range(100):
        private_clients.append({
          "first_name": fake.first_name(),
          "last_name": fake.last_name(),
          "email": fake.email(),
          "phone": fake.phone_number(),
          "address": fake.address(),
          "client_id": i,
          "id": i
        })
    return private_clients


def create_company_clients():
    company_clients = []
    for i in range(100):
        company_clients.append({
            "name": fake.sentence(nb_words=3),
            "email": fake.email(),
            "phone": fake.phone_number(),
            "address": fake.address(),
            "id": i,
            "client_id": i + 100
        })
    return company_clients


def add_indexes(arr):
    for i in range(len(arr)):
        arr[i]["id"] = i


confs = create_conferences()
add_indexes(confs)
days = add_days_to_conferences(confs)
add_indexes(days)
p_clients = create_private_clients()
c_clients = create_company_clients()


# inserting
for c in confs:
    cur.execute(f"insert into conferences (conferenceid, name, "
                f"discountforstudents, description) values ({c['id']}, '{c['name']}', "
                f"{c['discount_for_students']}, '{c['description']}')")

for d in days:
    cur.execute(f"insert into conferencedays (conferencedayid, conferences_conferenceid, date, numberofparticipants) "
                f"values ({d['id']}, {d['conference_id']}, '{d['date']}', {d['number_of_participants']})")





