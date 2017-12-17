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

cur.execute("DELETE FROM workshopparticipants")
cur.execute("DELETE FROM dayparticipants")
cur.execute("DELETE FROM participants")
cur.execute("DELETE FROM payments")
cur.execute("DELETE FROM workshopbook")
cur.execute("DELETE FROM conferencedaybook")
cur.execute("DELETE FROM workshops")
cur.execute("DELETE FROM conferencecosts")
cur.execute("DELETE FROM conferencebooks")
cur.execute("DELETE FROM conferencedays")
cur.execute("DELETE FROM conferences")
cur.execute("DELETE FROM companyclients")
cur.execute("DELETE FROM privateclients")
cur.execute("DELETE FROM clients")


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
            "discount": randint(0, 90),
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
          "client_id": i
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
            "client_id": i
        })
    return company_clients


def add_conference_books(confs):
    books = []
    for c in confs:
        no_books=randint(80, 120)
        for _ in range(no_books):
            book = {
                "booktime": c["date"]-datetime.timedelta(randint(10, 30)),
                "conference_id": c["id"],
                "client_id": randint(0, 199)
            }
            books.append(book)
    return books


def add_conference_costs(confs):
    costs = []
    for c in confs:
        no_costs = randint(1, 3)
        days = [randint(100, 150)]
        for _ in range(no_costs-1):
            days.append(randint(20, 40))
        days.append(0)
        for d in range(len(days)-1):
            cost = {
                "from": c["date"] - datetime.timedelta(days[d]-1),
                "to": c["date"] - datetime.timedelta(days[d+1]),
                "conference_id": c["id"],
                "cost": randint(10000*d, 10000+10000*d)/100
            }
            costs.append(cost)
    return costs


def add_day_conference_books(books, days):
    # print(books)
    d_books = []
    for d in days:
        con = d["conference_id"]
        act_books = list(filter(lambda i: i["conference_id"] == con, books))
        param = d["number_of_participants"]
        for b in act_books:
            participants = randint(0, min(5, param))
            param -= participants
            if participants != 0:
                students = randint(0, participants)
                participants -= students
                d_book={
                    "conference_day_id": d["id"],
                    "book_id": b["id"],
                    "participants": participants,
                    "student_participants": students
                }
                d_books.append(d_book)
    return d_books


def add_workshop_books():
    books =[]
    for w in workshops:
        con_day = w["conference_day_id"]
        act_day_books = list(filter(lambda i: i["conference_day_id"] == con_day, d_books))
        param = w["number_of_participants"]
        for b in act_day_books:
            participants = randint(0, min(4, param, b["participants"]+b["student_participants"]))
            param -= participants
            if participants != 0:
                book = {
                    "workshop_id": w["id"],
                    "day_book_id": b["id"],
                    "participants": participants,
                }
                books.append(book)
    return books


def create_workshops():
    wsps =[]
    for d in days:
        no_wsps = randint(3, 10)
        price = randint(0, 1)
        if price == 1:
            price = randint(100, 10000)/100
        time = datetime.time(randint(8, 16), randint(0, 5)*10)
        for _ in range(no_wsps):
            wsp = {
                "conference_day_id": d["id"],
                "name": fake.sentence(nb_words=2),
                "start_time": time,
                "end_time": (datetime.datetime.combine(datetime.date.today(), time) + datetime.timedelta(minutes=randint(3, 20)*10)).time(),
                "cost": price,
                "number_of_participants": randint(5, 30)
            }
            wsps.append(wsp)
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
    for b in books:
        value = 0
        con = list(filter(lambda i: i["id"] == b["conference_id"], confs))[0]
        day_books = list(filter(lambda i: i["book_id"] == b["id"], d_books))
        c_costs = list(filter(lambda i: i["conference_id"] == con["id"], costs))
        cost = c_costs[randint(0,len(c_costs)-1)]
        for d in day_books:
            w_books = list(filter(lambda i: i["day_book_id"] == d["id"], workshop_books))
            value += d["participants"]*cost["cost"]+d["student_participants"]*cost["cost"]*(con["discount"]/100)
            for wb in w_books:
                work = list(filter(lambda i: i["id"] == wb["workshop_id"], workshops))[0]
                value += work["cost"] * wb["participants"]
        payment = {
            "book_id": b["id"],
            "value": value,
            "pay_time": b["booktime"]+datetime.timedelta(randint(0, 7))
            }
        payments.append(payment)
    return payments



# supportive function indexing
def add_indexes(arr):
    for i in range(len(arr)):
        arr[i]["id"] = i


confs = create_conferences()
add_indexes(confs)
days = add_days_to_conferences(confs)
add_indexes(days)
p_clients = create_private_clients()
c_clients = create_company_clients()
books = add_conference_books(confs)
add_indexes(books)
costs = add_conference_costs(confs)
add_indexes(costs)
workshops = create_workshops()
add_indexes(workshops)
d_books = add_day_conference_books(books, days)
add_indexes(d_books)
workshop_books = add_workshop_books()
add_indexes(workshop_books)
book_payment = add_payments()
add_indexes(book_payment)


# inserting
for c in confs:
    cur.execute(f"insert into conferences (conferenceid, name, "
                f"discountforstudents, description) values ({c['id']}, '{c['name']}', "
                f"{c['discount']}, '{c['description']}')")

for d in days:
    cur.execute(f"insert into conferencedays (conferencedayid, conferences_conferenceid, date, numberofparticipants) "
                f"values ({d['id']}, {d['conference_id']}, '{d['date']}', {d['number_of_participants']})")

for i in range(200):
    cur.execute(f"INSERT INTO clients (clientid) VALUES ({i})")


for c in c_clients:
    cur.execute(f"INSERT INTO companyclients (companyclientid, clients_clientid, name, email, phone, address)" 
                f"VALUES ({c['client_id']+100}, {c['client_id']}, '{c['name']}', '{c['email']}', '{c['phone']}', '{c['address']}')")

for c in p_clients:
    cur.execute(f"INSERT INTO privateclients (privateclientid, clients_clientid, firstname, lastname, email, phone, address) "
                f"VALUES ({c['client_id']}, {c['client_id']}, '{c['first_name']}', '{c['last_name']}', '{c['email']}', '{c['phone']}', '{c['address']}')")
for b in books:
    cur.execute(f"INSERT INTO conferencebooks (conferencebookid, conferences_conferenceid, clients_clientid, booktime) VALUES "
                f"('{b['id']}', '{b['conference_id']}', '{b['client_id']}', '{b['booktime']}')")

for c in costs:
    cur.execute(f"INSERT INTO conferencecosts (conferencecostid, conferences_conferenceid, cost, dataform, datato) VALUES "
                f"('{c['id']}', '{c['conference_id']}', '{c['cost']}', '{c['from']}', '{c['to']}')")

for w in workshops:
    cur.execute(f"INSERT INTO workshops (workshopid, conferencedays_conferencedaysid, name, timestart, timeend, cost, numberofparticipants) VALUES "
                f"('{w['id']}', '{w['conference_day_id']}', '{w['name']}', '{w['start_time']}', '{w['end_time']}', '{w['cost']}', '{w['number_of_participants']}')")

for d in d_books:
    cur.execute(f"INSERT INTO conferencedaybook (conferencedaybookid, conferencedays_conferencedaysid, conferencebookid_conferencebookid, participantsnumber, studentparticipantsnumber) VALUES "
                f"('{d['id']}', '{d['conference_day_id']}', '{d['book_id']}', '{d['participants']}', '{d['student_participants']}')")

for w in workshop_books:
    cur.execute(f"INSERT INTO workshopbook (WorkshopBookID, Workshops_WorkshopID, ConferenceDayBook_ConferenceDayBookID, ParticipantNumber) VALUES "
                f"('{w['id']}', '{w['workshop_id']}', '{w['day_book_id']}', '{w['participants']}')")

for p in book_payment:
    cur.execute(f"INSERT INTO payments (paymentid, conferencebookid_conferencebookid, value, paytime) VALUES "
                f"('{p['id']}', '{p['book_id']}', '{p['value']}', '{p['pay_time']}')")

