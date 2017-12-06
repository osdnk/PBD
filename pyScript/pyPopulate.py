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
cur.execute("""DELETE FROM workshops""")
cur.execute("""DELETE FROM conferencedays""")
cur.execute("""DELETE FROM conferences""")
cur.execute("""DELETE FROM companyclients""")
cur.execute("""DELETE FROM privateclients""")
cur.execute("""DELETE FROM clients""")
cur.execute("""ALTER SEQUENCE clients_clientid_seq RESTART""")
cur.execute("""ALTER SEQUENCE conferencedays_conferencedayid_seq RESTART""")

def create_conferences():
    conferences = []
    days=[]
    it_date = datetime.date(2003, 1,1)
    while it_date < datetime.date(2006, 1, 1):
        it_date += datetime.timedelta(randint(10, 20))
        conferences.append({
            "date": it_date,
            "len": randint(2, 3),
            "name": fake.sentence(nb_words=3),
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
        })
    return private_clients


def create_company_clients():
    company_clients = []
    for i in range(100):
        company_clients.append({
            "name": fake.sentence(nb_words=1),
            "email": fake.email(),
            "phone": fake.phone_number(),
            "address": fake.address(),
        })
    return company_clients


def add_conference_books():
    books =[]
    # todo


def add_day_conference_books():
    books =[]
    # todo


def add_workshop_books():
    books =[]
    # todo


def create_workshops(days):
    wsps =[]
    for d in days:
        for i in range(randint(0, 10)):
            wsps.append({
                "conference_day_id": d["id"],
                "name": fake.sentence(nb_words=3),
                "time": fake.time(pattern="%H:%M", end_datetime=None),
                "cost": randint(10, 20),
                "number_of_participants": randint(5, 25),
            })
    return wsps


def create_participants():
    pas =[]
    # todo


def add_day_participants():
    participants = []
    # todo


def add_workshop_participants():
    participants = []
    # todo


def add_payments():
    payments =[]
    # todo


# supportive function indexing
def add_indexes(arr):
    for i in range(len(arr)):
        arr[i]["id"] = i


confs = create_conferences()
add_indexes(confs)
days = add_days_to_conferences(confs)
add_indexes(days)
wsps = create_workshops(days)
add_indexes(wsps)
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

for w in wsps:
    cur.execute(f"insert into workshops (workshopid, conferencedays_conferencedaysid, name, time, cost, numberofparticipants) "
                f"values ({w['id']}, {w['conference_day_id']}, '{w['name']}', '{w['time']}', '{w['cost']}', {w['number_of_participants']})")


for c in c_clients:
    cur.execute(f"""INSERT INTO clients DEFAULT VALUES RETURNING clientid""")
    ind = cur.fetchone()[0]
    cur.execute(f"""INSERT INTO companyclients (clients_clientid, name, email, phone, address)""" 
                f"""VALUES ({ind}, '{c['name']}', '{c['email']}', '{c['phone']}', '{c['address']}')""")


for c in p_clients:
    cur.execute(f"""INSERT INTO clients DEFAULT VALUES RETURNING clientid""")
    ind = cur.fetchone()[0]
    cur.execute(f"""INSERT INTO privateclients (clients_clientid, firstname, lastname, email, phone, address)
                VALUES ({ind}, '{c['first_name']}', '{c['last_name']}',
                '{c['email']}', '{c['phone']}', '{c['address']}')""")
#
# for i in range(200):
#     cur.execute(f"""INSERT INTO clients (clientid) VALUES ({i})""")