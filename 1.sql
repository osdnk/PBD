--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: clients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE clients (
    clientid integer NOT NULL
);


ALTER TABLE clients OWNER TO postgres;

--
-- Name: clients_clientid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE clients_clientid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clients_clientid_seq OWNER TO postgres;

--
-- Name: clients_clientid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE clients_clientid_seq OWNED BY clients.clientid;


--
-- Name: companyclients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE companyclients (
    companyclientid integer NOT NULL,
    clients_clientid integer NOT NULL,
    name character varying(20) NOT NULL,
    email character varying(40) NOT NULL,
    phone character varying(20) NOT NULL,
    address character varying(100) NOT NULL,
    CONSTRAINT properemail CHECK (((email)::text ~ '^\S+[@]\S+[.]\S+$'::text))
);


ALTER TABLE companyclients OWNER TO postgres;

--
-- Name: companyclients_companyclientid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE companyclients_companyclientid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE companyclients_companyclientid_seq OWNER TO postgres;

--
-- Name: companyclients_companyclientid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE companyclients_companyclientid_seq OWNED BY companyclients.companyclientid;


--
-- Name: conferencebooks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE conferencebooks (
    conferencebookid integer NOT NULL,
    conferences_conferenceid integer NOT NULL,
    booktime date DEFAULT CURRENT_DATE NOT NULL,
    clients_clientid integer NOT NULL
);


ALTER TABLE conferencebooks OWNER TO postgres;

--
-- Name: conferencebooks_conferencebookid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE conferencebooks_conferencebookid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE conferencebooks_conferencebookid_seq OWNER TO postgres;

--
-- Name: conferencebooks_conferencebookid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE conferencebooks_conferencebookid_seq OWNED BY conferencebooks.conferencebookid;


--
-- Name: conferencecosts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE conferencecosts (
    conferencecostid integer NOT NULL,
    conferences_conferenceid integer NOT NULL,
    cost numeric(18,2) NOT NULL,
    datafrom date NOT NULL,
    datato date NOT NULL,
    CONSTRAINT nonnegativecost CHECK ((cost >= (0)::numeric)),
    CONSTRAINT properdaydifferance CHECK ((datafrom <= datato))
);


ALTER TABLE conferencecosts OWNER TO postgres;

--
-- Name: conferencecosts_conferencecostid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE conferencecosts_conferencecostid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE conferencecosts_conferencecostid_seq OWNER TO postgres;

--
-- Name: conferencecosts_conferencecostid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE conferencecosts_conferencecostid_seq OWNED BY conferencecosts.conferencecostid;


--
-- Name: conferencedaybook; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE conferencedaybook (
    conferencedaybookid integer NOT NULL,
    conferencedays_conferencedaysid integer NOT NULL,
    conferencebookid_conferencebookid integer NOT NULL,
    participantsnumber integer NOT NULL,
    studentparticipantsnumber integer DEFAULT 0 NOT NULL,
    CONSTRAINT nonnegativenumberofstudents CHECK ((studentparticipantsnumber >= 0)),
    CONSTRAINT positiveparticipantsnumber CHECK ((participantsnumber > 0)),
    CONSTRAINT propernumberofstudents CHECK ((participantsnumber >= studentparticipantsnumber))
);


ALTER TABLE conferencedaybook OWNER TO postgres;

--
-- Name: conferencedaybook_conferencedaybookid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE conferencedaybook_conferencedaybookid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE conferencedaybook_conferencedaybookid_seq OWNER TO postgres;

--
-- Name: conferencedaybook_conferencedaybookid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE conferencedaybook_conferencedaybookid_seq OWNED BY conferencedaybook.conferencedaybookid;


--
-- Name: conferencedays; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE conferencedays (
    conferencedayid integer NOT NULL,
    conferences_conferenceid integer NOT NULL,
    date date NOT NULL,
    numberofparticipants integer NOT NULL,
    CONSTRAINT positivenumberofconferenceparticipants CHECK ((numberofparticipants > 0))
);


ALTER TABLE conferencedays OWNER TO postgres;

--
-- Name: conferencedays_conferencedayid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE conferencedays_conferencedayid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE conferencedays_conferencedayid_seq OWNER TO postgres;

--
-- Name: conferencedays_conferencedayid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE conferencedays_conferencedayid_seq OWNED BY conferencedays.conferencedayid;


--
-- Name: conferences; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE conferences (
    conferenceid integer NOT NULL,
    name character varying(50) NOT NULL,
    discountforstudents double precision DEFAULT 0 NOT NULL,
    description character varying(200) NOT NULL,
    CONSTRAINT properdescription CHECK ((length((description)::text) > 5)),
    CONSTRAINT properdiscount CHECK (((discountforstudents >= (0)::double precision) AND (discountforstudents <= (100)::double precision)))
);


ALTER TABLE conferences OWNER TO postgres;

--
-- Name: conferences_conferenceid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE conferences_conferenceid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE conferences_conferenceid_seq OWNER TO postgres;

--
-- Name: conferences_conferenceid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE conferences_conferenceid_seq OWNED BY conferences.conferenceid;


--
-- Name: dayparticipants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE dayparticipants (
    dayparticipantid integer NOT NULL,
    conferencedaybook_conferencedaybookid integer NOT NULL,
    participants_participantid integer NOT NULL,
    studentid character varying(50) DEFAULT NULL::character varying,
    CONSTRAINT properstudentid CHECK ((((studentid)::text ~ '^\d{6}$'::text) OR (studentid IS NULL)))
);


ALTER TABLE dayparticipants OWNER TO postgres;

--
-- Name: dayparticipants_dayparticipantid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE dayparticipants_dayparticipantid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dayparticipants_dayparticipantid_seq OWNER TO postgres;

--
-- Name: dayparticipants_dayparticipantid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE dayparticipants_dayparticipantid_seq OWNED BY dayparticipants.dayparticipantid;


--
-- Name: participants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE participants (
    participantid integer NOT NULL,
    firstname character varying(50) NOT NULL,
    lastname character varying(50) NOT NULL,
    email character varying(40) NOT NULL,
    CONSTRAINT properemail CHECK (((email)::text ~ '^\S+[@]\S+[.]\S+$'::text))
);


ALTER TABLE participants OWNER TO postgres;

--
-- Name: participants_participantid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE participants_participantid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE participants_participantid_seq OWNER TO postgres;

--
-- Name: participants_participantid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE participants_participantid_seq OWNED BY participants.participantid;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE payments (
    paymentid integer NOT NULL,
    conferencebookid_conferencebookid integer NOT NULL,
    amount numeric(18,2) NOT NULL,
    paytime date DEFAULT CURRENT_DATE NOT NULL,
    CONSTRAINT positivevalue CHECK ((amount > (0)::numeric))
);


ALTER TABLE payments OWNER TO postgres;

--
-- Name: payments_paymentid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE payments_paymentid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE payments_paymentid_seq OWNER TO postgres;

--
-- Name: payments_paymentid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE payments_paymentid_seq OWNED BY payments.paymentid;


--
-- Name: privateclients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE privateclients (
    privateclientid integer NOT NULL,
    clients_clientid integer NOT NULL,
    firstname character varying(20) NOT NULL,
    lastname character varying(20) NOT NULL,
    email character varying(40) NOT NULL,
    phone character varying(20) NOT NULL,
    address character varying(100) NOT NULL,
    CONSTRAINT properemail CHECK (((email)::text ~ '^\S+[@]\S+[.]\S+$'::text))
);


ALTER TABLE privateclients OWNER TO postgres;

--
-- Name: privateclients_privateclientid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE privateclients_privateclientid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE privateclients_privateclientid_seq OWNER TO postgres;

--
-- Name: privateclients_privateclientid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE privateclients_privateclientid_seq OWNED BY privateclients.privateclientid;


--
-- Name: workshopbook; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE workshopbook (
    workshopbookid integer NOT NULL,
    workshops_workshopid integer NOT NULL,
    conferencedaybook_conferencedaybookid integer NOT NULL,
    participantnumber integer NOT NULL,
    CONSTRAINT positiveworkshopparticipantsnumber CHECK ((participantnumber > 0))
);


ALTER TABLE workshopbook OWNER TO postgres;

--
-- Name: workshopbook_workshopbookid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE workshopbook_workshopbookid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE workshopbook_workshopbookid_seq OWNER TO postgres;

--
-- Name: workshopbook_workshopbookid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE workshopbook_workshopbookid_seq OWNED BY workshopbook.workshopbookid;


--
-- Name: workshopparticipants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE workshopparticipants (
    workshopparticipantid integer NOT NULL,
    workshopbook_workshopbookid integer NOT NULL,
    dayparticipants_dayparticipantid integer NOT NULL
);


ALTER TABLE workshopparticipants OWNER TO postgres;

--
-- Name: workshopparticipants_workshopparticipantid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE workshopparticipants_workshopparticipantid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE workshopparticipants_workshopparticipantid_seq OWNER TO postgres;

--
-- Name: workshopparticipants_workshopparticipantid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE workshopparticipants_workshopparticipantid_seq OWNED BY workshopparticipants.workshopparticipantid;


--
-- Name: workshops; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE workshops (
    workshopid integer NOT NULL,
    conferencedays_conferencedaysid integer NOT NULL,
    name character varying(50) NOT NULL,
    timestart time without time zone NOT NULL,
    timeend time without time zone NOT NULL,
    cost numeric(18,2) DEFAULT 0 NOT NULL,
    numberofparticipants integer DEFAULT 30 NOT NULL,
    CONSTRAINT nonnegativecost CHECK ((cost >= (0)::numeric)),
    CONSTRAINT posiviteworkshopparticipants CHECK ((numberofparticipants > 0)),
    CONSTRAINT propertimedifferance CHECK ((timestart < timeend))
);


ALTER TABLE workshops OWNER TO postgres;

--
-- Name: workshops_workshopid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE workshops_workshopid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE workshops_workshopid_seq OWNER TO postgres;

--
-- Name: workshops_workshopid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE workshops_workshopid_seq OWNED BY workshops.workshopid;


--
-- Name: clients clientid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY clients ALTER COLUMN clientid SET DEFAULT nextval('clients_clientid_seq'::regclass);


--
-- Name: companyclients companyclientid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY companyclients ALTER COLUMN companyclientid SET DEFAULT nextval('companyclients_companyclientid_seq'::regclass);


--
-- Name: conferencebooks conferencebookid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY conferencebooks ALTER COLUMN conferencebookid SET DEFAULT nextval('conferencebooks_conferencebookid_seq'::regclass);


--
-- Name: conferencecosts conferencecostid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY conferencecosts ALTER COLUMN conferencecostid SET DEFAULT nextval('conferencecosts_conferencecostid_seq'::regclass);


--
-- Name: conferencedaybook conferencedaybookid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY conferencedaybook ALTER COLUMN conferencedaybookid SET DEFAULT nextval('conferencedaybook_conferencedaybookid_seq'::regclass);


--
-- Name: conferencedays conferencedayid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY conferencedays ALTER COLUMN conferencedayid SET DEFAULT nextval('conferencedays_conferencedayid_seq'::regclass);


--
-- Name: conferences conferenceid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY conferences ALTER COLUMN conferenceid SET DEFAULT nextval('conferences_conferenceid_seq'::regclass);


--
-- Name: dayparticipants dayparticipantid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dayparticipants ALTER COLUMN dayparticipantid SET DEFAULT nextval('dayparticipants_dayparticipantid_seq'::regclass);


--
-- Name: participants participantid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY participants ALTER COLUMN participantid SET DEFAULT nextval('participants_participantid_seq'::regclass);


--
-- Name: payments paymentid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY payments ALTER COLUMN paymentid SET DEFAULT nextval('payments_paymentid_seq'::regclass);


--
-- Name: privateclients privateclientid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY privateclients ALTER COLUMN privateclientid SET DEFAULT nextval('privateclients_privateclientid_seq'::regclass);


--
-- Name: workshopbook workshopbookid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY workshopbook ALTER COLUMN workshopbookid SET DEFAULT nextval('workshopbook_workshopbookid_seq'::regclass);


--
-- Name: workshopparticipants workshopparticipantid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY workshopparticipants ALTER COLUMN workshopparticipantid SET DEFAULT nextval('workshopparticipants_workshopparticipantid_seq'::regclass);


--
-- Name: workshops workshopid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY workshops ALTER COLUMN workshopid SET DEFAULT nextval('workshops_workshopid_seq'::regclass);


--
-- Data for Name: clients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY clients (clientid) FROM stdin;
0
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
46
47
48
49
50
51
52
53
54
55
56
57
58
59
60
61
62
63
64
65
66
67
68
69
70
71
72
73
74
75
76
77
78
79
80
81
82
83
84
85
86
87
88
89
90
91
92
93
94
95
96
97
98
99
100
101
102
103
104
105
106
107
108
109
110
111
112
113
114
115
116
117
118
119
120
121
122
123
124
125
126
127
128
129
130
131
132
133
134
135
136
137
138
139
140
141
142
143
144
145
146
147
148
149
150
151
152
153
154
155
156
157
158
159
160
161
162
163
164
165
166
167
168
169
170
171
172
173
174
175
176
177
178
179
180
181
182
183
184
185
186
187
188
189
190
191
192
193
194
195
196
197
198
199
\.


--
-- Data for Name: companyclients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY companyclients (companyclientid, clients_clientid, name, email, phone, address) FROM stdin;
100	0	Modi.	andrewgolden@mann.com	912-243-4644x8248	Unit 6348 Box 3111\nDPO AE 63056
101	1	Veniam.	sanchezashley@yahoo.com	(047)988-3993	794 Patel Green Apt. 858\nPort Jeffery, SC 39386
102	2	Aliquam.	michaelphillips@yahoo.com	1-848-509-5265	512 Long Lodge Apt. 161\nSouth Kimberly, AL 25044
103	3	Consequuntur.	darrell09@hotmail.com	1-605-705-0680	5497 Emily Hollow Suite 566\nEast Bryanberg, CO 67982
104	4	In.	jmartin@wilson.org	250-679-4633x8359	6723 Garner Junction Apt. 765\nJasonchester, NJ 85795
105	5	Totam.	nicholashawkins@brandt-jones.com	1-861-206-3447x41014	0323 Meredith Fort Suite 702\nPort Ashley, UT 78828
106	6	Itaque.	donald59@williams.com	1-141-835-0984	72296 Jessica Courts\nPort Danielle, NE 08413-5823
107	7	Corporis.	christopherross@washington.com	(113)219-4984	607 Sandra Haven Apt. 762\nMarquezshire, OH 61160
108	8	Corrupti.	hmccoy@brown.com	(584)151-4314	7900 Hunt Circles Suite 353\nErikside, NC 31355
109	9	Vel.	bryan59@jordan.org	(203)150-2390x46658	USS Alvarez\nFPO AA 53911-7030
110	10	Voluptatem.	heather64@yahoo.com	340.808.7195x28768	6687 Ryan Spring\nBartonmouth, OH 57776-9272
111	11	In.	jpalmer@andrade-walters.com	953.032.7968	59188 Watson Fork Suite 912\nBernardshire, UT 66308-7941
112	12	Consequatur.	derekjohnson@gmail.com	230.773.4314x8755	181 Collins Square Suite 260\nHoside, SD 25390
113	13	Blanditiis.	csanchez@hotmail.com	487-092-5993x50695	5170 Ashley Cove\nNorth Frankmouth, NE 46015-0673
114	14	Vero.	esanders@gordon.com	330-732-4690	32897 Cortez Course Apt. 812\nCareyview, OH 28563
115	15	Quibusdam.	ythornton@kim.info	01678183465	0016 Adams Glens\nLake Amyton, AR 88079
116	16	Ab.	sarahchase@miller-jordan.info	(765)642-7825	801 Traci Centers Suite 851\nLake Allen, DC 86910-7277
117	17	Exercitationem.	ygreene@foster-hardy.com	(226)201-1122	0336 Johnston Branch\nNorth John, LA 28305
118	18	Ex.	brookemcknight@yahoo.com	1-471-883-6843x047	57919 Aguirre Stravenue Apt. 358\nWest Curtis, HI 82174
119	19	Impedit.	johnsonjulian@ferguson.com	261-598-4162x791	3447 Michael Inlet\nWest Lauren, VA 58816
120	20	Suscipit.	michael60@gmail.com	1-707-339-2022x433	055 Mccarthy Ford Suite 676\nLake Noah, IL 09369-1153
121	21	Sit.	kimberly08@hotmail.com	895-155-4253x679	893 Williams Pines\nRamirezview, PW 43747
122	22	Quibusdam.	millerjuan@mack.net	629.107.5205x3260	7145 Ball Radial\nCynthiaborough, NV 23238
123	23	Quos.	simpsonamy@hotmail.com	1-271-333-4669x713	359 Jesus Station Apt. 710\nChristinaberg, MD 62466
124	24	Reiciendis.	jmiller@gmail.com	(142)481-5563x4670	09838 Barbara Ports Suite 063\nNew Kimberlyville, AS 44546
125	25	Aperiam.	idrake@williams.org	+69(5)9596030455	0419 Collier Way\nSouth Kimfurt, NC 62541-6385
126	26	Sit.	charris@hotmail.com	1-751-932-4262x1874	975 Mary Landing Apt. 403\nWest Josephhaven, NJ 80920-4042
127	27	Reprehenderit.	ruiztimothy@gmail.com	+54(4)4870179670	653 Johnson View\nNorth Andre, MS 69715-2293
128	28	Ab.	thomas79@yahoo.com	142.315.2762x07407	689 Lee Motorway Suite 704\nNorth Mark, UT 27852-1880
129	29	Ex.	pamela07@hotmail.com	1-130-056-4006x6656	0160 Melissa Walk Apt. 423\nRickybury, AZ 28746-9011
130	30	Reprehenderit.	johnaguilar@hotmail.com	08963638735	3764 Johnson Plaza Suite 464\nNew Charlesberg, VA 57222-1045
131	31	Cupiditate.	brownmichelle@hotmail.com	520.252.8345x40115	4488 Ford Crossroad\nMatthewview, IL 31276-8421
132	32	Facere.	kaylee51@gmail.com	1-533-312-5368x949	399 Maxwell Springs\nKatelynburgh, IA 61790-1654
133	33	Asperiores.	danielmorrow@yahoo.com	1-618-804-8700x7762	21965 Webster Dale\nHurleyberg, MD 65414
134	34	Quisquam.	adamsanthony@morgan.com	(305)915-9733x55654	2250 Welch Trace Suite 756\nSouth Nathan, TN 15986-3714
135	35	Adipisci.	johnjones@gmail.com	485.760.4818	PSC 6885, Box 3325\nAPO AP 85881
136	36	Dicta.	schneiderstephen@dean.com	(999)955-8837x3132	PSC 9905, Box 5311\nAPO AA 39110-3636
137	37	Iure.	taylorfernandez@johnson-williams.com	952-819-0819x11632	1780 Dunn Bypass\nGrayton, WY 39512
138	38	Tempora.	brandy14@yahoo.com	(666)988-8623x1023	446 Peters Springs Apt. 768\nArnoldview, HI 59789-7854
139	39	Tempore.	ruben51@allen.com	126.823.4594x664	6517 Silva Centers\nWaltersmouth, MO 01685-1587
140	40	Iusto.	brooke51@gmail.com	+31(7)3018415375	Unit 1316 Box 1879\nDPO AA 64580-6837
141	41	Quisquam.	ashley49@tran-sexton.com	1-849-282-8570	3587 Morales Extension Apt. 057\nWalkerborough, MT 44984
142	42	Esse.	bowenbrittany@anderson-newman.com	881-635-5340	876 Carl Haven Suite 480\nCaseyfurt, VA 32967-8765
143	43	Autem.	wpaul@bradford.net	+61(9)1531388122	510 Kimberly Track Apt. 935\nPort Jerry, MS 86887-9324
144	44	Aliquam.	thomaslambert@sanchez.com	1-406-590-4656x03208	8753 Nicole Plain\nWhitemouth, AS 06892-2871
145	45	Est.	qrivera@klein-franklin.org	07073794652	61678 Brenda Harbor Apt. 398\nJosephton, KS 02453
146	46	Incidunt.	lisa66@scott.org	1-558-490-3482x98703	5307 Salas Harbors Apt. 789\nNorth Terryville, ND 08728
147	47	Sint.	medinacharles@yahoo.com	689-299-7131	0636 Christina Village\nWest Tylerchester, MH 35506-3920
148	48	Tempora.	wmorales@flores.info	573.938.0045x468	213 Shawn Bridge Suite 746\nAngieland, ID 26034
149	49	Dolor.	sandrastevenson@pham-west.com	584-617-3143	15260 Tammie Turnpike\nPort Ericside, AL 45385
150	50	Consequuntur.	smithbrenda@anderson.info	806-429-0595x7895	8713 Campbell Ford\nNew Sandraborough, ME 20450-2172
151	51	Vel.	christina75@williams-thompson.com	(531)337-0142x608	99962 Morrow Passage Apt. 006\nWest Debrachester, MH 61251
152	52	Error.	mwu@figueroa.com	(133)404-4810	74182 Peter Place\nJulieville, OH 38949-6534
153	53	Vitae.	devon48@long.org	1-992-343-1363x501	2983 Choi Cove Suite 129\nNew Donald, AZ 71946-5953
154	54	Nobis.	hmoore@lucas-clark.net	972-858-0582	Unit 8825 Box 4197\nDPO AE 70426
155	55	Velit.	yyu@smith.org	562.369.0814x2292	402 Karen Estates\nEdwardsmouth, GA 49740
156	56	Amet.	jeffery22@hotmail.com	02705907827	69546 Holland Ramp\nMarkton, VT 33193-8899
157	57	At.	johnsonbelinda@howard-coleman.com	(668)858-9037x6608	964 Thomas Rapids Apt. 030\nLake Taraberg, MT 00351-2730
158	58	Voluptatibus.	maciasfrank@carroll.net	238-729-6959x9901	1420 Jessica Vista\nLake Samuel, ME 69578-0389
159	59	Nemo.	lopezrebecca@sullivan.com	00829589803	52693 Mark Key Suite 543\nEast Sarahmouth, GU 63324
160	60	Quisquam.	qholland@bailey.com	(771)641-2268	359 James Mount Apt. 565\nSarabury, VA 33828
161	61	Molestias.	larry19@gmail.com	858.936.8047x6237	30769 Ebony Forest Suite 186\nWest Juan, TX 74087
162	62	Deleniti.	pam71@gmail.com	(063)701-1883x538	2376 Miller Forge Apt. 372\nPort Andrewborough, NE 25294-5840
163	63	Laudantium.	tnorton@gmail.com	103.269.0232x824	Unit 4459 Box 0485\nDPO AA 45614
164	64	Dolores.	lnicholson@morales.net	929-988-6961x61265	181 Ronald Lodge\nNorth Christopherside, IN 70702-8223
165	65	Eius.	omurphy@gmail.com	(137)830-9448	836 Smith Walks\nEast Brian, OR 11157
166	66	Recusandae.	matthew81@myers.com	1-566-568-5235x048	43640 Hayley Burgs\nPort Alexander, FL 35242-5606
167	67	Quae.	curtisbradshaw@gmail.com	960-544-3425	905 Brown Ranch Suite 362\nAmytown, MI 77957-3362
168	68	Voluptatibus.	ysmith@gmail.com	1-540-890-1914	90330 Donald Knoll\nShawnabury, DE 45018
169	69	Earum.	jonathonerickson@yahoo.com	(741)420-3316x1290	79615 Erika Rest\nWest Marc, MH 12822
170	70	In.	james27@reilly.com	826.384.8074x91471	366 Berry Stream Suite 772\nMichaelfort, RI 50258-7051
171	71	Dolore.	beankent@gmail.com	828-386-9843x691	Unit 8735 Box 0717\nDPO AA 17094-8267
172	72	Placeat.	josephdouglas@terry.biz	(655)182-1572x4185	937 Amber Pine\nGarciatown, OH 52598
173	73	Magni.	whutchinson@yahoo.com	822.362.5726x3006	265 Davis Bypass Suite 119\nWest Angela, CT 96838-8470
174	74	Eius.	michaelwhite@garcia.com	1-452-382-6506	USCGC Mcdonald\nFPO AP 99292
175	75	Impedit.	goodwinzachary@gmail.com	494.371.0664x73629	2324 Mary Summit\nEast Eric, KS 09169-1265
176	76	Illum.	richard83@yahoo.com	(240)113-4206x948	233 Hall Manor Suite 415\nKellychester, FM 74459
177	77	Omnis.	buchananscott@yahoo.com	129-620-0837	7648 Rodriguez Ridges\nMillermouth, AL 33702-0845
178	78	Velit.	hendersonmelissa@hotmail.com	326.874.7299x859	714 Moore Rapid Apt. 975\nEast Patrick, RI 29223
179	79	Minima.	daniel00@taylor.com	429.741.0159x107	1244 Perry Expressway Apt. 379\nBrownfurt, IL 01641-7021
180	80	Vitae.	ramirezjeffrey@gmail.com	1-713-458-0542	7051 Cox Cliffs\nPort Jonathanhaven, LA 48005
181	81	Unde.	jasonwalker@gmail.com	(196)484-7144	62832 Kristopher Island\nSouth Markburgh, FL 62035-8595
182	82	Non.	bakerthomas@hotmail.com	1-063-922-2989x336	653 Crystal Corner Suite 762\nLake Kathrynmouth, PA 30505-2088
183	83	Nemo.	gdavis@yahoo.com	(250)794-1194x7902	50104 Miller Green\nGarrettberg, MP 30281-2523
184	84	Ad.	tara39@hotmail.com	1-518-219-5685x6686	81049 Carroll Row Apt. 953\nPort Michael, AK 66403-7915
185	85	Voluptatum.	wendy76@watts.com	690-887-8531	62923 Molly Lane Apt. 191\nEast Ryanmouth, WA 89906-2810
186	86	Alias.	thomasdavid@yahoo.com	1-119-587-6895x816	USS Stokes\nFPO AP 10943
187	87	Suscipit.	johnstonedward@hotmail.com	(850)628-6408	805 George Knolls Suite 968\nBullockland, NC 73209-0506
188	88	Nulla.	mark16@gmail.com	628.557.5765	731 Jordan Vista Suite 100\nSouth Matthewberg, AZ 29732
189	89	Praesentium.	kara24@crawford.info	860-104-8844x81593	41061 Smith Parkway Suite 652\nJamesburgh, PR 94836
190	90	Commodi.	nguyenbrenda@sullivan-ho.net	571-432-3135	61341 Mccarty Corner\nKelliechester, WI 89632
191	91	Reprehenderit.	bautistabrandon@weber.org	262.146.0652x516	74377 Kelley Points\nNew Rebecca, VT 68311-1176
192	92	Optio.	alexabaldwin@ramirez-nelson.com	(620)429-4264x5021	3755 Eric Prairie\nLake Shannon, MH 41339-0091
193	93	Dolorum.	hawkinsdaniel@yahoo.com	706-140-8437x37748	80875 Carrillo Freeway\nCoreyburgh, UT 54130-1696
194	94	Tempore.	njackson@hotmail.com	(909)759-7896	311 Shepard Overpass Suite 831\nWhitemouth, NH 47326
195	95	Possimus.	bmcdowell@king-reynolds.com	(271)202-8668x0039	2823 Ali Mission Apt. 460\nNew Annaview, MN 41155-9527
196	96	Maiores.	christopherbuchanan@mays.net	(406)856-2826	45057 Leslie Squares\nChelseachester, OR 56011
197	97	Esse.	frankharris@hotmail.com	(819)311-1499x6327	474 Castro Cove\nWest Oliviaport, VI 60798
198	98	Voluptas.	dgomez@gonzales-robertson.com	+05(4)8181665219	831 Jennifer Circle Apt. 543\nNew Michelle, DC 90522-2788
199	99	Eius.	derekpatel@clark.net	477.419.3103x758	USNS Pollard\nFPO AA 36997
\.


--
-- Data for Name: conferencebooks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY conferencebooks (conferencebookid, conferences_conferenceid, booktime, clients_clientid) FROM stdin;
0	0	2002-12-25	32
1	0	2002-12-28	84
2	0	2002-12-17	90
3	0	2003-01-02	8
4	0	2002-12-15	199
5	0	2002-12-19	70
6	0	2002-12-27	16
7	0	2002-12-30	106
8	0	2002-12-31	67
9	0	2002-12-29	137
10	0	2002-12-15	53
11	0	2002-12-14	45
12	0	2003-01-02	15
13	0	2002-12-18	0
14	0	2002-12-18	122
15	0	2003-01-02	128
16	0	2002-12-14	99
17	0	2002-12-23	60
18	0	2002-12-19	167
19	0	2002-12-14	51
20	0	2002-12-24	86
21	0	2002-12-23	146
22	0	2003-01-02	37
23	0	2002-12-26	187
24	0	2002-12-30	21
25	0	2002-12-21	10
26	0	2002-12-31	167
27	0	2003-01-02	86
28	0	2002-12-26	32
29	0	2003-01-03	147
30	0	2002-12-15	118
31	0	2002-12-26	2
32	0	2002-12-25	168
33	0	2003-01-03	56
34	0	2002-12-22	38
35	0	2002-12-28	77
36	0	2002-12-28	117
37	0	2002-12-19	135
38	0	2002-12-19	181
39	0	2002-12-26	153
40	0	2002-12-21	121
41	0	2002-12-28	133
42	0	2003-01-03	39
43	0	2002-12-17	137
44	0	2002-12-29	70
45	0	2002-12-18	106
46	0	2002-12-19	18
47	0	2002-12-28	28
48	0	2002-12-24	94
49	0	2003-01-02	192
50	0	2002-12-26	18
51	0	2002-12-18	137
52	0	2002-12-24	85
53	0	2002-12-24	121
54	0	2003-01-02	92
55	0	2002-12-18	36
56	0	2002-12-14	6
57	0	2002-12-21	105
58	0	2002-12-17	129
59	0	2002-12-19	53
60	0	2003-01-01	45
61	0	2002-12-25	133
62	0	2003-01-02	50
63	0	2002-12-23	109
64	0	2002-12-25	99
65	0	2002-12-16	30
66	0	2002-12-17	55
67	0	2002-12-24	76
68	0	2002-12-27	103
69	0	2003-01-02	112
70	0	2002-12-24	94
71	0	2003-01-01	170
72	0	2002-12-17	182
73	0	2002-12-26	80
74	0	2002-12-16	22
75	0	2002-12-30	185
76	0	2002-12-28	117
77	0	2003-01-01	100
78	0	2002-12-21	149
79	0	2002-12-22	170
80	0	2002-12-14	101
81	0	2002-12-29	140
82	0	2002-12-15	95
83	0	2003-01-02	40
84	0	2002-12-23	171
85	0	2002-12-20	163
86	0	2002-12-27	104
87	0	2002-12-17	126
88	0	2003-01-01	95
89	0	2002-12-19	79
90	0	2002-12-31	124
91	0	2002-12-25	21
92	0	2002-12-30	89
93	0	2002-12-19	69
94	0	2002-12-23	147
95	0	2002-12-21	198
96	0	2002-12-15	131
97	0	2002-12-18	158
98	0	2002-12-29	4
99	0	2002-12-29	61
100	0	2002-12-19	13
101	0	2002-12-20	19
102	0	2002-12-17	90
103	0	2002-12-22	144
104	0	2002-12-24	160
105	0	2003-01-02	158
106	0	2002-12-21	16
107	0	2003-01-01	29
108	0	2002-12-28	83
109	0	2002-12-28	102
110	0	2002-12-20	20
111	0	2002-12-17	148
112	1	2003-01-01	123
113	1	2003-01-06	83
114	1	2003-01-02	150
115	1	2003-01-04	41
116	1	2003-01-15	71
117	1	2002-12-30	39
118	1	2002-12-31	155
119	1	2003-01-05	97
120	1	2003-01-15	117
121	1	2003-01-05	104
122	1	2003-01-15	62
123	1	2002-12-31	181
124	1	2003-01-14	141
125	1	2002-12-29	141
126	1	2003-01-14	69
127	1	2003-01-10	144
128	1	2003-01-11	56
129	1	2003-01-01	34
130	1	2003-01-06	121
131	1	2003-01-15	79
132	1	2003-01-08	18
133	1	2003-01-13	135
134	1	2003-01-12	63
135	1	2002-12-28	110
136	1	2003-01-01	117
137	1	2003-01-15	0
138	1	2003-01-09	41
139	1	2003-01-08	158
140	1	2002-12-30	36
141	1	2003-01-02	79
142	1	2002-12-29	10
143	1	2002-12-31	143
144	1	2003-01-13	19
145	1	2003-01-15	139
146	1	2003-01-16	67
147	1	2003-01-05	122
148	1	2003-01-12	50
149	1	2003-01-06	180
150	1	2003-01-11	66
151	1	2003-01-06	168
152	1	2003-01-14	34
153	1	2003-01-14	17
154	1	2003-01-14	62
155	1	2002-12-29	145
156	1	2002-12-27	26
157	1	2003-01-04	185
158	1	2003-01-14	57
159	1	2003-01-16	34
160	1	2003-01-09	198
161	1	2003-01-15	177
162	1	2003-01-05	67
163	1	2003-01-12	146
164	1	2003-01-14	101
165	1	2003-01-15	7
166	1	2003-01-02	109
167	1	2003-01-02	40
168	1	2002-12-30	13
169	1	2003-01-09	168
170	1	2002-12-30	25
171	1	2003-01-16	149
172	1	2003-01-09	84
173	1	2003-01-05	60
174	1	2003-01-01	178
175	1	2003-01-16	126
176	1	2003-01-10	147
177	1	2003-01-08	167
178	1	2003-01-12	1
179	1	2002-12-29	177
180	1	2003-01-02	138
181	1	2003-01-02	132
182	1	2003-01-04	38
183	1	2002-12-27	49
184	1	2003-01-08	76
185	1	2003-01-11	156
186	1	2003-01-10	40
187	1	2003-01-10	27
188	1	2002-12-31	111
189	1	2003-01-12	39
190	1	2002-12-29	72
191	1	2003-01-12	52
192	1	2003-01-16	147
193	1	2002-12-31	156
194	1	2003-01-03	141
195	1	2002-12-27	52
196	1	2003-01-10	98
197	1	2003-01-03	152
198	1	2003-01-04	39
199	1	2003-01-05	195
200	1	2002-12-28	184
201	1	2003-01-06	114
202	1	2003-01-13	149
203	1	2003-01-08	187
204	1	2003-01-05	57
205	1	2003-01-01	46
206	1	2003-01-14	118
207	1	2003-01-13	37
208	1	2003-01-10	45
209	1	2002-12-27	164
210	1	2002-12-27	183
211	1	2003-01-10	177
212	1	2002-12-27	10
213	1	2002-12-31	93
214	1	2002-12-27	161
215	1	2003-01-14	96
216	1	2003-01-11	0
217	1	2003-01-11	146
218	1	2002-12-27	153
219	1	2003-01-08	41
220	1	2003-01-11	48
221	1	2002-12-28	136
222	1	2003-01-10	105
223	2	2003-01-22	165
224	2	2003-01-16	77
225	2	2003-01-29	53
226	2	2003-01-26	105
227	2	2003-01-30	21
228	2	2003-01-17	18
229	2	2003-01-30	164
230	2	2003-01-31	1
231	2	2003-01-18	179
232	2	2003-01-19	196
233	2	2003-01-24	21
234	2	2003-01-16	185
235	2	2003-01-28	176
236	2	2003-01-20	129
237	2	2003-01-27	72
238	2	2003-01-24	29
239	2	2003-01-23	47
240	2	2003-02-02	175
241	2	2003-01-15	54
242	2	2003-01-19	78
243	2	2003-01-18	84
244	2	2003-01-17	72
245	2	2003-01-14	29
246	2	2003-01-20	83
247	2	2003-01-20	113
248	2	2003-01-28	64
249	2	2003-01-25	35
250	2	2003-01-28	75
251	2	2003-01-19	101
252	2	2003-01-21	60
253	2	2003-01-16	16
254	2	2003-01-16	99
255	2	2003-01-20	150
256	2	2003-01-15	64
257	2	2003-01-18	99
258	2	2003-01-26	6
259	2	2003-02-01	49
260	2	2003-01-24	184
261	2	2003-01-17	159
262	2	2003-01-17	2
263	2	2003-01-30	113
264	2	2003-01-15	68
265	2	2003-01-28	101
266	2	2003-01-31	20
267	2	2003-01-15	179
268	2	2003-01-21	174
269	2	2003-01-27	176
270	2	2003-01-18	165
271	2	2003-01-28	8
272	2	2003-01-19	33
273	2	2003-01-31	61
274	2	2003-01-29	145
275	2	2003-01-20	178
276	2	2003-01-21	28
277	2	2003-01-30	157
278	2	2003-01-18	59
279	2	2003-01-23	99
280	2	2003-01-25	97
281	2	2003-01-28	90
282	2	2003-01-24	189
283	2	2003-02-01	157
284	2	2003-01-17	72
285	2	2003-01-27	128
286	2	2003-01-25	143
287	2	2003-01-31	130
288	2	2003-01-31	34
289	2	2003-01-16	185
290	2	2003-01-16	178
291	2	2003-01-15	89
292	2	2003-01-30	150
293	2	2003-01-23	102
294	2	2003-01-14	151
295	2	2003-01-21	69
296	2	2003-01-23	191
297	2	2003-01-31	66
298	2	2003-01-25	120
299	2	2003-01-22	12
300	2	2003-01-17	131
301	2	2003-01-17	161
302	2	2003-01-17	91
303	2	2003-01-18	10
304	2	2003-02-03	10
305	2	2003-01-27	67
306	2	2003-02-01	67
307	2	2003-01-30	69
308	2	2003-01-17	30
309	2	2003-02-01	197
310	2	2003-01-28	10
311	2	2003-01-27	91
312	2	2003-01-30	18
313	2	2003-01-17	58
314	2	2003-01-28	33
315	2	2003-02-01	34
316	2	2003-01-25	52
317	2	2003-01-14	25
318	2	2003-01-31	142
319	2	2003-01-17	127
320	2	2003-01-16	68
321	2	2003-01-26	112
322	2	2003-01-30	14
323	2	2003-01-20	175
324	2	2003-02-02	161
325	2	2003-01-24	4
326	2	2003-01-18	116
327	2	2003-01-18	49
328	2	2003-01-26	36
329	2	2003-01-23	120
330	2	2003-01-17	66
331	2	2003-01-25	123
332	2	2003-02-02	44
333	2	2003-01-18	174
334	2	2003-02-01	172
335	3	2003-02-15	174
336	3	2003-02-11	85
337	3	2003-02-19	170
338	3	2003-02-05	62
339	3	2003-02-12	21
340	3	2003-02-04	18
341	3	2003-02-07	171
342	3	2003-02-17	30
343	3	2003-02-05	107
344	3	2003-02-05	117
345	3	2003-02-05	180
346	3	2003-02-17	152
347	3	2003-02-11	39
348	3	2003-02-03	114
349	3	2003-02-22	17
350	3	2003-02-04	140
351	3	2003-02-07	63
352	3	2003-02-11	139
353	3	2003-02-12	41
354	3	2003-02-17	57
355	3	2003-02-07	43
356	3	2003-02-11	73
357	3	2003-02-12	95
358	3	2003-02-05	184
359	3	2003-02-07	53
360	3	2003-02-21	160
361	3	2003-02-07	180
362	3	2003-02-13	43
363	3	2003-02-13	84
364	3	2003-02-10	87
365	3	2003-02-13	35
366	3	2003-02-23	124
367	3	2003-02-09	69
368	3	2003-02-07	110
369	3	2003-02-14	87
370	3	2003-02-20	123
371	3	2003-02-19	112
372	3	2003-02-09	170
373	3	2003-02-19	75
374	3	2003-02-06	118
375	3	2003-02-14	77
376	3	2003-02-07	34
377	3	2003-02-08	172
378	3	2003-02-23	19
379	3	2003-02-16	50
380	3	2003-02-04	87
381	3	2003-02-21	137
382	3	2003-02-11	41
383	3	2003-02-12	177
384	3	2003-02-20	120
385	3	2003-02-15	104
386	3	2003-02-22	85
387	3	2003-02-22	63
388	3	2003-02-13	16
389	3	2003-02-05	80
390	3	2003-02-12	36
391	3	2003-02-16	162
392	3	2003-02-19	81
393	3	2003-02-07	145
394	3	2003-02-11	119
395	3	2003-02-21	19
396	3	2003-02-23	182
397	3	2003-02-22	192
398	3	2003-02-09	111
399	3	2003-02-06	192
400	3	2003-02-08	110
401	3	2003-02-17	71
402	3	2003-02-22	146
403	3	2003-02-14	131
404	3	2003-02-19	190
405	3	2003-02-20	7
406	3	2003-02-10	133
407	3	2003-02-05	177
408	3	2003-02-11	160
409	3	2003-02-22	59
410	3	2003-02-21	141
411	3	2003-02-05	63
412	3	2003-02-21	196
413	3	2003-02-04	156
414	3	2003-02-19	46
415	3	2003-02-11	132
416	3	2003-02-12	49
417	3	2003-02-10	39
418	3	2003-02-17	154
419	3	2003-02-04	60
420	3	2003-02-20	136
421	3	2003-02-15	37
422	3	2003-02-13	47
423	3	2003-02-07	46
424	3	2003-02-05	160
425	3	2003-02-22	172
426	3	2003-02-16	58
427	3	2003-02-15	172
428	4	2003-03-06	120
429	4	2003-03-12	132
430	4	2003-02-24	72
431	4	2003-03-11	56
432	4	2003-03-13	32
433	4	2003-02-27	34
434	4	2003-02-23	12
435	4	2003-02-26	125
436	4	2003-03-15	112
437	4	2003-02-23	182
438	4	2003-03-04	135
439	4	2003-03-04	48
440	4	2003-03-12	72
441	4	2003-03-10	175
442	4	2003-03-03	59
443	4	2003-03-05	115
444	4	2003-03-11	55
445	4	2003-03-10	51
446	4	2003-03-05	26
447	4	2003-02-25	154
448	4	2003-03-03	102
449	4	2003-03-08	49
450	4	2003-03-15	131
451	4	2003-03-05	180
452	4	2003-03-15	18
453	4	2003-03-06	135
454	4	2003-03-08	50
455	4	2003-02-24	42
456	4	2003-03-05	179
457	4	2003-02-27	128
458	4	2003-03-14	118
459	4	2003-02-25	57
460	4	2003-02-27	159
461	4	2003-03-02	38
462	4	2003-03-03	37
463	4	2003-03-10	69
464	4	2003-03-04	162
465	4	2003-03-08	80
466	4	2003-03-15	112
467	4	2003-03-04	197
468	4	2003-02-23	95
469	4	2003-03-06	51
470	4	2003-03-13	109
471	4	2003-03-09	6
472	4	2003-02-26	63
473	4	2003-03-15	168
474	4	2003-02-27	51
475	4	2003-03-06	196
476	4	2003-03-03	79
477	4	2003-03-14	182
478	4	2003-03-14	139
479	4	2003-03-04	51
480	4	2003-03-04	78
481	4	2003-03-08	92
482	4	2003-03-09	34
483	4	2003-02-25	66
484	4	2003-03-03	26
485	4	2003-02-25	34
486	4	2003-03-03	72
487	4	2003-03-14	50
488	4	2003-02-24	145
489	4	2003-03-05	5
490	4	2003-03-05	18
491	4	2003-03-15	149
492	4	2003-02-28	164
493	4	2003-03-06	141
494	4	2003-03-14	34
495	4	2003-03-06	42
496	4	2003-03-13	118
497	4	2003-03-06	125
498	4	2003-03-13	85
499	4	2003-03-05	167
500	4	2003-02-28	108
501	4	2003-03-15	180
502	4	2003-02-23	169
503	4	2003-02-26	48
504	4	2003-03-01	27
505	4	2003-03-07	167
506	4	2003-02-26	3
507	4	2003-02-28	9
508	4	2003-02-23	111
509	4	2003-03-02	148
510	4	2003-02-24	108
511	4	2003-02-23	116
512	4	2003-03-13	80
513	4	2003-03-03	68
514	4	2003-02-27	130
515	4	2003-02-23	54
516	4	2003-03-01	116
517	4	2003-03-11	80
518	4	2003-02-25	54
519	4	2003-02-26	144
520	4	2003-02-27	6
521	4	2003-03-01	163
522	4	2003-03-09	57
523	4	2003-02-26	179
524	4	2003-03-03	65
525	4	2003-03-02	37
526	4	2003-03-13	153
527	4	2003-03-08	16
528	4	2003-03-08	79
529	4	2003-03-01	149
530	4	2003-02-26	107
531	4	2003-03-07	58
532	4	2003-03-14	43
533	4	2003-03-04	99
534	4	2003-03-02	132
535	4	2003-03-03	83
536	4	2003-03-02	188
537	4	2003-03-01	95
538	4	2003-03-04	124
539	4	2003-02-25	189
540	4	2003-03-12	5
541	4	2003-03-02	21
542	5	2003-03-13	50
543	5	2003-03-23	55
544	5	2003-03-14	145
545	5	2003-03-08	125
546	5	2003-03-21	54
547	5	2003-03-12	105
548	5	2003-03-09	86
549	5	2003-03-15	51
550	5	2003-03-13	49
551	5	2003-03-10	14
552	5	2003-03-23	36
553	5	2003-03-26	139
554	5	2003-03-18	13
555	5	2003-03-16	173
556	5	2003-03-17	92
557	5	2003-03-11	40
558	5	2003-03-11	174
559	5	2003-03-14	121
560	5	2003-03-08	92
561	5	2003-03-15	103
562	5	2003-03-25	186
563	5	2003-03-11	102
564	5	2003-03-22	120
565	5	2003-03-18	116
566	5	2003-03-15	177
567	5	2003-03-14	169
568	5	2003-03-22	98
569	5	2003-03-19	192
570	5	2003-03-24	176
571	5	2003-03-13	153
572	5	2003-03-28	87
573	5	2003-03-13	151
574	5	2003-03-19	69
575	5	2003-03-20	84
576	5	2003-03-14	183
577	5	2003-03-21	38
578	5	2003-03-22	13
579	5	2003-03-17	165
580	5	2003-03-16	75
581	5	2003-03-18	41
582	5	2003-03-14	4
583	5	2003-03-26	74
584	5	2003-03-23	115
585	5	2003-03-27	52
586	5	2003-03-13	89
587	5	2003-03-10	62
588	5	2003-03-08	37
589	5	2003-03-28	47
590	5	2003-03-19	183
591	5	2003-03-15	167
592	5	2003-03-14	167
593	5	2003-03-25	137
594	5	2003-03-24	172
595	5	2003-03-17	101
596	5	2003-03-20	80
597	5	2003-03-08	85
598	5	2003-03-25	167
599	5	2003-03-15	153
600	5	2003-03-22	149
601	5	2003-03-11	91
602	5	2003-03-15	82
603	5	2003-03-21	138
604	5	2003-03-18	158
605	5	2003-03-19	74
606	5	2003-03-15	193
607	5	2003-03-08	185
608	5	2003-03-18	78
609	5	2003-03-24	175
610	5	2003-03-12	165
611	5	2003-03-23	122
612	5	2003-03-13	75
613	5	2003-03-15	61
614	5	2003-03-09	80
615	5	2003-03-15	107
616	5	2003-03-20	25
617	5	2003-03-15	150
618	5	2003-03-16	10
619	5	2003-03-19	6
620	5	2003-03-23	20
621	5	2003-03-27	153
622	5	2003-03-19	110
623	5	2003-03-11	150
624	5	2003-03-17	36
625	5	2003-03-23	10
626	5	2003-03-25	194
627	5	2003-03-27	15
628	5	2003-03-13	10
629	5	2003-03-17	45
630	5	2003-03-20	36
631	5	2003-03-19	25
632	5	2003-03-21	108
633	5	2003-03-22	98
634	5	2003-03-23	154
635	6	2003-03-23	36
636	6	2003-04-08	27
637	6	2003-04-09	62
638	6	2003-04-08	10
639	6	2003-04-10	143
640	6	2003-04-10	8
641	6	2003-04-02	58
642	6	2003-04-06	16
643	6	2003-04-05	142
644	6	2003-03-30	127
645	6	2003-04-01	62
646	6	2003-04-01	53
647	6	2003-04-01	68
648	6	2003-04-09	157
649	6	2003-03-23	103
650	6	2003-03-28	114
651	6	2003-04-08	57
652	6	2003-04-07	84
653	6	2003-04-09	77
654	6	2003-04-03	45
655	6	2003-03-26	128
656	6	2003-03-30	7
657	6	2003-04-10	90
658	6	2003-04-01	66
659	6	2003-03-24	150
660	6	2003-03-28	48
661	6	2003-03-21	34
662	6	2003-04-08	128
663	6	2003-03-29	44
664	6	2003-03-28	129
665	6	2003-03-22	133
666	6	2003-03-30	53
667	6	2003-03-27	150
668	6	2003-03-23	71
669	6	2003-04-02	150
670	6	2003-04-08	159
671	6	2003-03-30	74
672	6	2003-03-22	66
673	6	2003-03-28	13
674	6	2003-04-02	41
675	6	2003-04-09	68
676	6	2003-04-10	115
677	6	2003-04-07	174
678	6	2003-03-31	115
679	6	2003-04-06	35
680	6	2003-03-23	47
681	6	2003-03-30	199
682	6	2003-04-04	51
683	6	2003-04-01	44
684	6	2003-03-26	129
685	6	2003-03-31	172
686	6	2003-03-28	112
687	6	2003-04-10	120
688	6	2003-04-05	100
689	6	2003-03-30	52
690	6	2003-04-09	40
691	6	2003-04-04	100
692	6	2003-03-30	168
693	6	2003-04-06	45
694	6	2003-04-09	192
695	6	2003-03-22	98
696	6	2003-03-22	46
697	6	2003-03-31	168
698	6	2003-03-22	78
699	6	2003-03-21	83
700	6	2003-03-22	175
701	6	2003-04-07	111
702	6	2003-04-06	193
703	6	2003-03-26	53
704	6	2003-03-28	28
705	6	2003-03-28	141
706	6	2003-04-02	2
707	6	2003-04-10	183
708	6	2003-04-02	60
709	6	2003-04-06	9
710	6	2003-04-10	51
711	6	2003-04-06	110
712	6	2003-03-31	135
713	6	2003-04-09	81
714	6	2003-03-23	112
715	6	2003-04-02	199
716	7	2003-04-08	111
717	7	2003-04-08	112
718	7	2003-04-18	36
719	7	2003-04-05	105
720	7	2003-04-15	87
721	7	2003-04-05	17
722	7	2003-04-16	160
723	7	2003-04-06	131
724	7	2003-04-20	120
725	7	2003-04-08	199
726	7	2003-04-12	6
727	7	2003-04-09	194
728	7	2003-04-16	153
729	7	2003-04-09	108
730	7	2003-04-08	155
731	7	2003-04-02	78
732	7	2003-04-17	98
733	7	2003-04-09	182
734	7	2003-04-09	156
735	7	2003-04-05	18
736	7	2003-04-02	183
737	7	2003-04-06	136
738	7	2003-04-06	11
739	7	2003-04-09	165
740	7	2003-04-01	57
741	7	2003-04-17	195
742	7	2003-04-19	164
743	7	2003-04-17	81
744	7	2003-04-10	162
745	7	2003-04-07	14
746	7	2003-04-02	5
747	7	2003-04-14	195
748	7	2003-04-11	119
749	7	2003-04-05	181
750	7	2003-04-10	112
751	7	2003-04-18	57
752	7	2003-04-03	122
753	7	2003-04-18	77
754	7	2003-04-06	123
755	7	2003-04-17	180
756	7	2003-04-01	118
757	7	2003-04-03	179
758	7	2003-04-03	118
759	7	2003-04-16	6
760	7	2003-04-09	198
761	7	2003-04-21	146
762	7	2003-04-02	167
763	7	2003-04-15	159
764	7	2003-04-21	26
765	7	2003-04-02	56
766	7	2003-04-19	24
767	7	2003-04-15	178
768	7	2003-04-20	157
769	7	2003-04-18	188
770	7	2003-04-01	58
771	7	2003-04-16	150
772	7	2003-04-02	64
773	7	2003-04-14	174
774	7	2003-04-13	136
775	7	2003-04-03	186
776	7	2003-04-17	138
777	7	2003-04-16	106
778	7	2003-04-20	146
779	7	2003-04-08	153
780	7	2003-04-15	168
781	7	2003-04-02	117
782	7	2003-04-04	167
783	7	2003-04-09	166
784	7	2003-04-17	173
785	7	2003-04-07	174
786	7	2003-04-18	9
787	7	2003-04-21	133
788	7	2003-04-18	195
789	7	2003-04-18	10
790	7	2003-04-10	196
791	7	2003-04-03	15
792	7	2003-04-18	189
793	7	2003-04-13	143
794	7	2003-04-01	38
795	7	2003-04-14	48
796	7	2003-04-17	100
797	7	2003-04-01	109
798	7	2003-04-02	41
799	7	2003-04-02	88
800	7	2003-04-12	149
801	7	2003-04-12	169
802	7	2003-04-05	128
803	7	2003-04-06	136
804	7	2003-04-10	106
805	7	2003-04-09	151
806	7	2003-04-03	182
807	7	2003-04-09	186
808	7	2003-04-19	88
809	7	2003-04-11	21
810	7	2003-04-09	116
811	7	2003-04-06	184
812	7	2003-04-15	134
813	7	2003-04-12	46
814	7	2003-04-08	113
815	7	2003-04-08	152
816	7	2003-04-07	46
817	7	2003-04-07	134
818	7	2003-04-07	55
819	7	2003-04-14	59
820	7	2003-04-07	199
821	7	2003-04-07	65
822	7	2003-04-12	108
823	8	2003-04-28	191
824	8	2003-04-27	98
825	8	2003-05-01	176
826	8	2003-04-26	75
827	8	2003-04-22	162
828	8	2003-04-25	74
829	8	2003-05-08	9
830	8	2003-04-21	71
831	8	2003-04-19	161
832	8	2003-04-26	13
833	8	2003-05-07	65
834	8	2003-04-25	120
835	8	2003-04-25	158
836	8	2003-04-26	105
837	8	2003-05-05	169
838	8	2003-04-24	50
839	8	2003-05-08	2
840	8	2003-05-01	57
841	8	2003-05-08	25
842	8	2003-05-05	75
843	8	2003-04-21	49
844	8	2003-04-28	38
845	8	2003-05-01	122
846	8	2003-05-08	40
847	8	2003-04-22	173
848	8	2003-05-04	111
849	8	2003-04-20	100
850	8	2003-05-02	28
851	8	2003-04-26	67
852	8	2003-04-20	155
853	8	2003-04-29	187
854	8	2003-04-19	35
855	8	2003-05-03	173
856	8	2003-05-03	157
857	8	2003-05-05	92
858	8	2003-05-08	38
859	8	2003-05-04	57
860	8	2003-04-19	143
861	8	2003-05-08	60
862	8	2003-05-07	154
863	8	2003-05-01	0
864	8	2003-05-07	180
865	8	2003-05-02	179
866	8	2003-04-21	162
867	8	2003-04-27	171
868	8	2003-04-21	59
869	8	2003-05-05	114
870	8	2003-04-30	117
871	8	2003-05-05	170
872	8	2003-05-09	22
873	8	2003-05-04	199
874	8	2003-04-24	79
875	8	2003-04-25	38
876	8	2003-04-28	86
877	8	2003-04-28	55
878	8	2003-04-20	155
879	8	2003-04-29	51
880	8	2003-04-25	160
881	8	2003-05-02	52
882	8	2003-05-04	2
883	8	2003-04-23	5
884	8	2003-04-21	137
885	8	2003-04-29	96
886	8	2003-05-03	171
887	8	2003-04-25	47
888	8	2003-04-23	162
889	8	2003-05-09	176
890	8	2003-05-08	160
891	8	2003-04-20	59
892	8	2003-05-04	116
893	8	2003-04-29	106
894	8	2003-04-25	55
895	8	2003-04-26	55
896	8	2003-05-01	147
897	8	2003-04-28	173
898	8	2003-04-27	34
899	8	2003-04-23	195
900	8	2003-05-03	102
901	8	2003-05-02	117
902	8	2003-05-04	16
903	8	2003-04-23	28
904	8	2003-04-19	167
905	8	2003-04-23	112
906	8	2003-05-09	82
907	8	2003-04-26	76
908	8	2003-04-21	154
909	8	2003-05-02	37
910	8	2003-05-03	70
911	8	2003-04-30	95
912	9	2003-05-12	195
913	9	2003-05-21	41
914	9	2003-05-18	58
915	9	2003-05-04	122
916	9	2003-05-19	134
917	9	2003-05-15	126
918	9	2003-05-10	184
919	9	2003-05-16	132
920	9	2003-05-23	199
921	9	2003-05-09	94
922	9	2003-05-08	192
923	9	2003-05-09	3
924	9	2003-05-21	18
925	9	2003-05-13	118
926	9	2003-05-21	162
927	9	2003-05-24	120
928	9	2003-05-12	183
929	9	2003-05-22	126
930	9	2003-05-16	69
931	9	2003-05-04	5
932	9	2003-05-17	175
933	9	2003-05-18	32
934	9	2003-05-12	134
935	9	2003-05-18	48
936	9	2003-05-19	72
937	9	2003-05-11	91
938	9	2003-05-08	77
939	9	2003-05-07	133
940	9	2003-05-09	56
941	9	2003-05-21	82
942	9	2003-05-15	62
943	9	2003-05-23	79
944	9	2003-05-12	175
945	9	2003-05-18	60
946	9	2003-05-08	37
947	9	2003-05-23	156
948	9	2003-05-10	172
949	9	2003-05-19	40
950	9	2003-05-05	130
951	9	2003-05-18	159
952	9	2003-05-24	111
953	9	2003-05-14	191
954	9	2003-05-17	62
955	9	2003-05-18	132
956	9	2003-05-10	133
957	9	2003-05-04	38
958	9	2003-05-08	36
959	9	2003-05-09	91
960	9	2003-05-12	89
961	9	2003-05-10	143
962	9	2003-05-19	41
963	9	2003-05-04	160
964	9	2003-05-04	49
965	9	2003-05-18	11
966	9	2003-05-08	34
967	9	2003-05-12	62
968	9	2003-05-05	194
969	9	2003-05-18	194
970	9	2003-05-24	190
971	9	2003-05-24	192
972	9	2003-05-15	43
973	9	2003-05-12	32
974	9	2003-05-11	116
975	9	2003-05-24	118
976	9	2003-05-10	184
977	9	2003-05-17	152
978	9	2003-05-24	102
979	9	2003-05-19	62
980	9	2003-05-06	13
981	9	2003-05-17	68
982	9	2003-05-06	103
983	9	2003-05-08	102
984	9	2003-05-06	179
985	9	2003-05-14	30
986	9	2003-05-22	18
987	9	2003-05-06	111
988	9	2003-05-14	115
989	9	2003-05-04	72
990	9	2003-05-20	139
991	9	2003-05-06	156
992	9	2003-05-22	91
993	9	2003-05-21	133
994	9	2003-05-20	127
995	9	2003-05-21	64
996	9	2003-05-22	39
997	9	2003-05-05	196
998	9	2003-05-13	111
999	9	2003-05-11	198
1000	9	2003-05-13	166
1001	9	2003-05-23	8
1002	9	2003-05-17	108
1003	9	2003-05-09	155
1004	9	2003-05-12	98
1005	9	2003-05-13	143
1006	10	2003-05-31	23
1007	10	2003-05-25	194
1008	10	2003-06-02	146
1009	10	2003-05-24	164
1010	10	2003-05-31	29
1011	10	2003-05-21	195
1012	10	2003-06-02	141
1013	10	2003-05-14	169
1014	10	2003-05-30	107
1015	10	2003-05-22	87
1016	10	2003-05-30	159
1017	10	2003-05-27	121
1018	10	2003-05-18	144
1019	10	2003-05-20	13
1020	10	2003-06-03	178
1021	10	2003-05-30	45
1022	10	2003-05-26	104
1023	10	2003-05-18	20
1024	10	2003-05-17	162
1025	10	2003-05-25	93
1026	10	2003-05-14	51
1027	10	2003-05-14	112
1028	10	2003-05-19	32
1029	10	2003-05-31	107
1030	10	2003-05-30	39
1031	10	2003-05-19	69
1032	10	2003-05-26	136
1033	10	2003-05-23	104
1034	10	2003-05-18	199
1035	10	2003-05-26	169
1036	10	2003-05-17	113
1037	10	2003-06-01	99
1038	10	2003-05-30	179
1039	10	2003-05-21	38
1040	10	2003-05-23	1
1041	10	2003-05-23	167
1042	10	2003-06-02	112
1043	10	2003-05-22	178
1044	10	2003-05-27	66
1045	10	2003-05-17	180
1046	10	2003-05-18	52
1047	10	2003-05-21	67
1048	10	2003-05-22	195
1049	10	2003-05-24	118
1050	10	2003-06-03	60
1051	10	2003-05-29	196
1052	10	2003-05-29	149
1053	10	2003-05-19	26
1054	10	2003-05-21	117
1055	10	2003-05-30	1
1056	10	2003-05-28	109
1057	10	2003-05-28	127
1058	10	2003-05-25	37
1059	10	2003-05-14	180
1060	10	2003-06-02	71
1061	10	2003-05-14	199
1062	10	2003-05-21	58
1063	10	2003-05-23	31
1064	10	2003-05-17	24
1065	10	2003-05-21	157
1066	10	2003-05-14	147
1067	10	2003-05-19	95
1068	10	2003-05-14	180
1069	10	2003-05-24	138
1070	10	2003-05-29	42
1071	10	2003-05-22	192
1072	10	2003-05-17	26
1073	10	2003-06-02	86
1074	10	2003-05-17	88
1075	10	2003-05-19	100
1076	10	2003-05-17	57
1077	10	2003-05-25	74
1078	10	2003-05-29	192
1079	10	2003-05-24	135
1080	10	2003-05-20	57
1081	10	2003-05-24	113
1082	10	2003-06-02	56
1083	10	2003-05-20	68
1084	10	2003-05-24	198
1085	10	2003-06-03	163
1086	10	2003-05-24	73
1087	10	2003-05-22	76
1088	10	2003-05-23	18
1089	10	2003-05-23	126
1090	10	2003-05-15	96
1091	10	2003-05-28	96
1092	10	2003-05-29	70
1093	10	2003-06-03	56
1094	10	2003-05-29	162
1095	10	2003-05-18	152
1096	10	2003-05-19	28
1097	10	2003-05-24	161
1098	10	2003-05-28	137
1099	10	2003-05-21	11
1100	10	2003-05-29	139
1101	10	2003-05-19	71
1102	10	2003-05-27	10
1103	10	2003-05-22	107
1104	10	2003-05-29	182
1105	10	2003-05-16	175
1106	10	2003-05-26	65
1107	10	2003-05-29	1
1108	10	2003-05-21	35
1109	10	2003-05-29	171
1110	10	2003-05-28	25
1111	10	2003-05-15	51
1112	10	2003-05-27	38
1113	10	2003-05-29	29
1114	10	2003-05-23	95
1115	10	2003-06-01	23
1116	10	2003-05-25	35
1117	10	2003-05-27	40
1118	10	2003-06-02	53
1119	10	2003-05-21	171
1120	10	2003-05-18	167
1121	10	2003-05-27	42
1122	10	2003-06-01	25
1123	10	2003-05-20	156
1124	10	2003-05-23	96
1125	11	2003-06-05	94
1126	11	2003-06-14	174
1127	11	2003-06-13	179
1128	11	2003-06-19	76
1129	11	2003-06-07	89
1130	11	2003-06-21	150
1131	11	2003-06-07	25
1132	11	2003-06-20	116
1133	11	2003-06-10	57
1134	11	2003-06-17	175
1135	11	2003-06-13	124
1136	11	2003-06-03	106
1137	11	2003-06-15	103
1138	11	2003-06-19	167
1139	11	2003-06-17	59
1140	11	2003-06-22	167
1141	11	2003-06-11	166
1142	11	2003-06-13	156
1143	11	2003-06-19	162
1144	11	2003-06-04	88
1145	11	2003-06-03	68
1146	11	2003-06-22	42
1147	11	2003-06-08	64
1148	11	2003-06-16	48
1149	11	2003-06-10	4
1150	11	2003-06-14	163
1151	11	2003-06-19	118
1152	11	2003-06-14	190
1153	11	2003-06-21	149
1154	11	2003-06-07	137
1155	11	2003-06-07	167
1156	11	2003-06-11	85
1157	11	2003-06-16	70
1158	11	2003-06-15	58
1159	11	2003-06-10	86
1160	11	2003-06-06	66
1161	11	2003-06-04	91
1162	11	2003-06-15	14
1163	11	2003-06-19	149
1164	11	2003-06-14	38
1165	11	2003-06-22	155
1166	11	2003-06-05	91
1167	11	2003-06-22	199
1168	11	2003-06-10	109
1169	11	2003-06-13	192
1170	11	2003-06-16	112
1171	11	2003-06-17	141
1172	11	2003-06-09	139
1173	11	2003-06-10	113
1174	11	2003-06-20	94
1175	11	2003-06-07	68
1176	11	2003-06-04	174
1177	11	2003-06-07	197
1178	11	2003-06-09	26
1179	11	2003-06-17	129
1180	11	2003-06-15	51
1181	11	2003-06-08	74
1182	11	2003-06-07	137
1183	11	2003-06-13	189
1184	11	2003-06-03	120
1185	11	2003-06-17	109
1186	11	2003-06-03	56
1187	11	2003-06-18	63
1188	11	2003-06-23	98
1189	11	2003-06-08	89
1190	11	2003-06-07	149
1191	11	2003-06-05	30
1192	11	2003-06-08	164
1193	11	2003-06-06	51
1194	11	2003-06-07	51
1195	11	2003-06-08	54
1196	11	2003-06-16	47
1197	11	2003-06-04	151
1198	11	2003-06-22	39
1199	11	2003-06-17	6
1200	11	2003-06-04	81
1201	11	2003-06-06	56
1202	11	2003-06-06	171
1203	11	2003-06-15	112
1204	11	2003-06-13	46
1205	11	2003-06-23	65
1206	11	2003-06-06	97
1207	11	2003-06-05	168
1208	11	2003-06-17	50
1209	11	2003-06-12	86
1210	11	2003-06-08	90
1211	11	2003-06-09	66
1212	11	2003-06-23	66
1213	11	2003-06-20	13
1214	11	2003-06-05	149
1215	11	2003-06-09	121
1216	11	2003-06-17	53
1217	11	2003-06-23	9
1218	11	2003-06-17	128
1219	11	2003-06-09	56
1220	11	2003-06-04	4
1221	11	2003-06-13	153
1222	11	2003-06-06	27
1223	11	2003-06-16	154
1224	11	2003-06-22	117
1225	12	2003-07-02	15
1226	12	2003-06-25	61
1227	12	2003-07-09	127
1228	12	2003-06-21	12
1229	12	2003-07-03	82
1230	12	2003-07-05	145
1231	12	2003-06-24	182
1232	12	2003-06-21	60
1233	12	2003-07-08	8
1234	12	2003-07-05	63
1235	12	2003-06-22	7
1236	12	2003-06-25	80
1237	12	2003-06-28	7
1238	12	2003-07-02	135
1239	12	2003-07-06	115
1240	12	2003-06-21	17
1241	12	2003-06-25	185
1242	12	2003-06-24	178
1243	12	2003-07-05	12
1244	12	2003-07-01	14
1245	12	2003-06-23	88
1246	12	2003-06-30	30
1247	12	2003-06-30	31
1248	12	2003-07-01	164
1249	12	2003-07-05	21
1250	12	2003-07-01	133
1251	12	2003-07-07	12
1252	12	2003-07-04	198
1253	12	2003-06-24	195
1254	12	2003-07-02	120
1255	12	2003-06-27	6
1256	12	2003-07-03	94
1257	12	2003-06-29	146
1258	12	2003-07-01	115
1259	12	2003-07-09	60
1260	12	2003-06-26	41
1261	12	2003-06-29	167
1262	12	2003-06-27	180
1263	12	2003-07-01	174
1264	12	2003-07-03	171
1265	12	2003-06-24	73
1266	12	2003-07-01	36
1267	12	2003-07-04	84
1268	12	2003-06-24	187
1269	12	2003-07-08	160
1270	12	2003-07-04	176
1271	12	2003-06-25	136
1272	12	2003-06-23	138
1273	12	2003-07-08	22
1274	12	2003-06-25	118
1275	12	2003-06-26	72
1276	12	2003-07-05	179
1277	12	2003-07-11	15
1278	12	2003-07-02	136
1279	12	2003-07-08	173
1280	12	2003-07-07	18
1281	12	2003-07-05	0
1282	12	2003-06-29	175
1283	12	2003-07-06	121
1284	12	2003-07-11	152
1285	12	2003-07-07	167
1286	12	2003-06-25	93
1287	12	2003-06-22	189
1288	12	2003-07-10	21
1289	12	2003-07-08	102
1290	12	2003-06-29	172
1291	12	2003-06-29	49
1292	12	2003-06-23	123
1293	12	2003-07-09	99
1294	12	2003-07-03	162
1295	12	2003-07-02	198
1296	12	2003-06-30	135
1297	12	2003-07-11	80
1298	12	2003-06-21	183
1299	12	2003-07-03	0
1300	12	2003-06-27	156
1301	12	2003-06-24	90
1302	12	2003-06-26	85
1303	12	2003-07-02	51
1304	12	2003-07-04	138
1305	12	2003-07-08	173
1306	12	2003-07-05	61
1307	12	2003-06-27	9
1308	12	2003-07-10	104
1309	12	2003-06-27	162
1310	12	2003-07-07	132
1311	12	2003-07-07	38
1312	12	2003-06-21	19
1313	12	2003-07-04	41
1314	12	2003-06-27	166
1315	12	2003-06-24	28
1316	12	2003-07-08	94
1317	12	2003-06-22	12
1318	12	2003-07-04	60
1319	12	2003-06-28	171
1320	12	2003-06-25	45
1321	12	2003-06-28	122
1322	12	2003-07-10	82
1323	12	2003-07-02	165
1324	12	2003-07-08	108
1325	12	2003-07-03	98
1326	12	2003-06-21	28
1327	12	2003-07-02	174
1328	12	2003-06-24	90
1329	12	2003-07-04	183
1330	12	2003-06-21	50
1331	12	2003-06-22	79
1332	12	2003-06-28	96
1333	13	2003-07-18	7
1334	13	2003-07-19	64
1335	13	2003-07-28	12
1336	13	2003-07-18	109
1337	13	2003-07-15	92
1338	13	2003-07-13	10
1339	13	2003-07-24	72
1340	13	2003-07-17	117
1341	13	2003-07-19	40
1342	13	2003-07-11	158
1343	13	2003-07-13	108
1344	13	2003-07-17	109
1345	13	2003-07-12	179
1346	13	2003-07-20	166
1347	13	2003-07-25	61
1348	13	2003-07-27	80
1349	13	2003-07-13	48
1350	13	2003-07-09	60
1351	13	2003-07-14	2
1352	13	2003-07-21	120
1353	13	2003-07-29	9
1354	13	2003-07-09	148
1355	13	2003-07-26	179
1356	13	2003-07-22	105
1357	13	2003-07-11	128
1358	13	2003-07-12	171
1359	13	2003-07-19	85
1360	13	2003-07-15	40
1361	13	2003-07-21	62
1362	13	2003-07-22	184
1363	13	2003-07-17	40
1364	13	2003-07-21	71
1365	13	2003-07-20	75
1366	13	2003-07-10	13
1367	13	2003-07-13	86
1368	13	2003-07-18	68
1369	13	2003-07-14	75
1370	13	2003-07-27	139
1371	13	2003-07-17	108
1372	13	2003-07-11	25
1373	13	2003-07-21	97
1374	13	2003-07-14	149
1375	13	2003-07-24	83
1376	13	2003-07-22	195
1377	13	2003-07-15	72
1378	13	2003-07-29	93
1379	13	2003-07-24	57
1380	13	2003-07-22	48
1381	13	2003-07-20	150
1382	13	2003-07-17	163
1383	13	2003-07-24	7
1384	13	2003-07-15	79
1385	13	2003-07-22	62
1386	13	2003-07-20	17
1387	13	2003-07-22	199
1388	13	2003-07-09	155
1389	13	2003-07-15	29
1390	13	2003-07-26	189
1391	13	2003-07-12	158
1392	13	2003-07-26	29
1393	13	2003-07-26	39
1394	13	2003-07-22	37
1395	13	2003-07-15	56
1396	13	2003-07-22	38
1397	13	2003-07-24	120
1398	13	2003-07-18	111
1399	13	2003-07-27	6
1400	13	2003-07-22	144
1401	13	2003-07-17	119
1402	13	2003-07-27	43
1403	13	2003-07-14	112
1404	13	2003-07-25	149
1405	13	2003-07-25	181
1406	13	2003-07-16	26
1407	13	2003-07-19	173
1408	13	2003-07-27	172
1409	13	2003-07-10	128
1410	13	2003-07-21	160
1411	13	2003-07-13	104
1412	13	2003-07-15	73
1413	13	2003-07-09	131
1414	13	2003-07-24	4
1415	13	2003-07-15	64
1416	13	2003-07-22	167
1417	13	2003-07-16	97
1418	13	2003-07-20	4
1419	13	2003-07-28	39
1420	13	2003-07-27	48
1421	13	2003-07-18	149
1422	13	2003-07-26	124
1423	13	2003-07-10	90
1424	13	2003-07-10	191
1425	13	2003-07-14	105
1426	13	2003-07-21	44
1427	13	2003-07-24	30
1428	13	2003-07-29	197
1429	13	2003-07-27	170
1430	13	2003-07-26	142
1431	13	2003-07-16	29
1432	13	2003-07-18	66
1433	13	2003-07-19	40
1434	13	2003-07-16	106
1435	13	2003-07-11	36
1436	13	2003-07-13	84
1437	13	2003-07-14	130
1438	13	2003-07-16	26
1439	13	2003-07-23	93
1440	13	2003-07-13	35
1441	13	2003-07-18	105
1442	13	2003-07-19	172
1443	14	2003-08-09	67
1444	14	2003-08-08	115
1445	14	2003-07-23	23
1446	14	2003-08-05	20
1447	14	2003-07-29	81
1448	14	2003-07-24	41
1449	14	2003-08-04	9
1450	14	2003-08-04	154
1451	14	2003-07-25	194
1452	14	2003-07-28	151
1453	14	2003-07-24	8
1454	14	2003-08-11	152
1455	14	2003-07-23	155
1456	14	2003-07-25	194
1457	14	2003-08-02	62
1458	14	2003-07-23	9
1459	14	2003-07-28	71
1460	14	2003-08-04	19
1461	14	2003-08-03	59
1462	14	2003-07-25	65
1463	14	2003-07-26	72
1464	14	2003-07-22	59
1465	14	2003-07-22	1
1466	14	2003-08-06	94
1467	14	2003-07-26	140
1468	14	2003-07-25	127
1469	14	2003-07-25	66
1470	14	2003-07-26	50
1471	14	2003-07-23	136
1472	14	2003-08-08	172
1473	14	2003-08-11	83
1474	14	2003-07-31	161
1475	14	2003-07-27	62
1476	14	2003-08-11	14
1477	14	2003-07-31	84
1478	14	2003-08-03	116
1479	14	2003-07-31	18
1480	14	2003-07-26	154
1481	14	2003-07-22	73
1482	14	2003-08-05	161
1483	14	2003-08-10	176
1484	14	2003-07-22	79
1485	14	2003-07-28	190
1486	14	2003-08-11	51
1487	14	2003-07-31	82
1488	14	2003-08-11	42
1489	14	2003-08-09	69
1490	14	2003-07-25	135
1491	14	2003-08-11	26
1492	14	2003-07-29	132
1493	14	2003-08-11	179
1494	14	2003-07-22	35
1495	14	2003-08-08	126
1496	14	2003-07-22	4
1497	14	2003-07-23	22
1498	14	2003-07-23	153
1499	14	2003-08-02	142
1500	14	2003-07-30	89
1501	14	2003-07-29	5
1502	14	2003-08-06	133
1503	14	2003-08-11	63
1504	14	2003-07-24	21
1505	14	2003-08-01	70
1506	14	2003-07-28	115
1507	14	2003-07-24	97
1508	14	2003-08-07	140
1509	14	2003-08-08	135
1510	14	2003-08-03	20
1511	14	2003-08-05	2
1512	14	2003-08-05	137
1513	14	2003-08-06	93
1514	14	2003-07-22	74
1515	14	2003-07-31	186
1516	14	2003-08-04	135
1517	14	2003-07-24	183
1518	14	2003-08-07	144
1519	14	2003-07-26	142
1520	14	2003-08-03	13
1521	14	2003-08-10	142
1522	14	2003-07-27	171
1523	14	2003-07-30	14
1524	14	2003-07-28	112
1525	14	2003-07-31	107
1526	14	2003-07-31	95
1527	14	2003-07-23	136
1528	14	2003-07-22	2
1529	14	2003-07-30	37
1530	14	2003-08-05	173
1531	14	2003-08-03	133
1532	14	2003-07-30	80
1533	14	2003-07-22	86
1534	14	2003-08-11	96
1535	14	2003-08-10	138
1536	14	2003-08-05	8
1537	14	2003-08-05	34
1538	14	2003-07-27	5
1539	14	2003-07-25	111
1540	14	2003-08-07	128
1541	14	2003-08-10	88
1542	14	2003-07-30	21
1543	14	2003-08-05	93
1544	14	2003-08-06	187
1545	15	2003-08-05	97
1546	15	2003-08-04	54
1547	15	2003-08-21	72
1548	15	2003-08-02	14
1549	15	2003-08-21	160
1550	15	2003-08-02	158
1551	15	2003-08-21	162
1552	15	2003-08-19	178
1553	15	2003-08-10	152
1554	15	2003-08-21	111
1555	15	2003-08-08	177
1556	15	2003-08-17	165
1557	15	2003-08-10	128
1558	15	2003-08-08	123
1559	15	2003-08-18	80
1560	15	2003-08-16	9
1561	15	2003-08-16	44
1562	15	2003-08-18	39
1563	15	2003-08-12	82
1564	15	2003-08-14	152
1565	15	2003-08-06	110
1566	15	2003-08-02	110
1567	15	2003-08-17	97
1568	15	2003-08-18	82
1569	15	2003-08-19	116
1570	15	2003-08-21	76
1571	15	2003-08-20	70
1572	15	2003-08-21	4
1573	15	2003-08-06	185
1574	15	2003-08-10	99
1575	15	2003-08-13	162
1576	15	2003-08-17	64
1577	15	2003-08-08	30
1578	15	2003-08-04	175
1579	15	2003-08-06	84
1580	15	2003-08-02	56
1581	15	2003-08-10	58
1582	15	2003-08-13	39
1583	15	2003-08-16	112
1584	15	2003-08-17	199
1585	15	2003-08-17	197
1586	15	2003-08-06	160
1587	15	2003-08-17	160
1588	15	2003-08-06	67
1589	15	2003-08-01	13
1590	15	2003-08-17	101
1591	15	2003-08-10	101
1592	15	2003-08-06	36
1593	15	2003-08-16	84
1594	15	2003-08-21	118
1595	15	2003-08-02	102
1596	15	2003-08-05	102
1597	15	2003-08-04	54
1598	15	2003-08-01	7
1599	15	2003-08-04	29
1600	15	2003-08-09	96
1601	15	2003-08-10	20
1602	15	2003-08-19	151
1603	15	2003-08-04	142
1604	15	2003-08-05	45
1605	15	2003-08-10	118
1606	15	2003-08-11	39
1607	15	2003-08-09	112
1608	15	2003-08-20	116
1609	15	2003-08-19	177
1610	15	2003-08-12	128
1611	15	2003-08-06	135
1612	15	2003-08-11	174
1613	15	2003-08-21	161
1614	15	2003-08-21	33
1615	15	2003-08-07	113
1616	15	2003-08-21	196
1617	15	2003-08-19	116
1618	15	2003-08-07	27
1619	15	2003-08-13	112
1620	15	2003-08-02	174
1621	15	2003-08-09	18
1622	15	2003-08-20	6
1623	15	2003-08-08	176
1624	15	2003-08-17	126
1625	15	2003-08-17	135
1626	15	2003-08-10	11
1627	15	2003-08-12	53
1628	15	2003-08-15	16
1629	15	2003-08-14	61
1630	15	2003-08-09	37
1631	15	2003-08-17	170
1632	15	2003-08-19	115
1633	15	2003-08-05	148
1634	15	2003-08-18	197
1635	15	2003-08-16	155
1636	15	2003-08-21	163
1637	15	2003-08-14	93
1638	15	2003-08-11	159
1639	15	2003-08-07	192
1640	15	2003-08-03	70
1641	15	2003-08-10	168
1642	15	2003-08-17	109
1643	15	2003-08-14	82
1644	15	2003-08-19	21
1645	15	2003-08-13	111
1646	15	2003-08-09	162
1647	15	2003-08-19	37
1648	15	2003-08-13	17
1649	15	2003-08-18	191
1650	15	2003-08-21	191
1651	15	2003-08-20	176
1652	15	2003-08-19	126
1653	15	2003-08-07	129
1654	15	2003-08-17	32
1655	15	2003-08-15	175
1656	15	2003-08-12	66
1657	16	2003-08-20	21
1658	16	2003-08-25	107
1659	16	2003-09-07	135
1660	16	2003-09-02	54
1661	16	2003-08-31	136
1662	16	2003-08-24	182
1663	16	2003-09-04	23
1664	16	2003-08-21	62
1665	16	2003-08-29	25
1666	16	2003-09-03	195
1667	16	2003-08-20	193
1668	16	2003-09-07	25
1669	16	2003-08-30	195
1670	16	2003-08-20	63
1671	16	2003-08-23	188
1672	16	2003-08-20	78
1673	16	2003-08-18	65
1674	16	2003-08-18	84
1675	16	2003-08-26	66
1676	16	2003-09-07	21
1677	16	2003-09-04	171
1678	16	2003-08-26	92
1679	16	2003-09-05	108
1680	16	2003-09-01	36
1681	16	2003-09-04	76
1682	16	2003-09-05	60
1683	16	2003-08-25	16
1684	16	2003-08-26	88
1685	16	2003-09-01	11
1686	16	2003-09-04	98
1687	16	2003-09-02	158
1688	16	2003-08-22	73
1689	16	2003-08-30	48
1690	16	2003-08-20	199
1691	16	2003-08-30	29
1692	16	2003-08-19	45
1693	16	2003-08-22	159
1694	16	2003-08-29	12
1695	16	2003-09-03	140
1696	16	2003-08-19	37
1697	16	2003-08-24	119
1698	16	2003-08-28	129
1699	16	2003-09-05	112
1700	16	2003-08-26	186
1701	16	2003-09-05	21
1702	16	2003-08-30	198
1703	16	2003-08-19	103
1704	16	2003-09-06	71
1705	16	2003-08-31	109
1706	16	2003-08-31	84
1707	16	2003-09-03	76
1708	16	2003-08-30	182
1709	16	2003-08-19	52
1710	16	2003-08-29	7
1711	16	2003-08-26	3
1712	16	2003-09-05	130
1713	16	2003-08-22	170
1714	16	2003-09-03	152
1715	16	2003-08-22	92
1716	16	2003-08-18	170
1717	16	2003-08-19	165
1718	16	2003-09-02	191
1719	16	2003-09-04	27
1720	16	2003-08-29	178
1721	16	2003-08-29	52
1722	16	2003-08-27	187
1723	16	2003-08-31	60
1724	16	2003-09-01	82
1725	16	2003-08-31	194
1726	16	2003-08-31	65
1727	16	2003-08-23	149
1728	16	2003-08-26	194
1729	16	2003-08-20	153
1730	16	2003-09-05	74
1731	16	2003-09-05	129
1732	16	2003-08-21	107
1733	16	2003-09-05	196
1734	16	2003-08-27	172
1735	16	2003-09-02	127
1736	16	2003-09-04	164
1737	16	2003-08-31	125
1738	16	2003-09-06	39
1739	16	2003-08-20	109
1740	16	2003-08-26	91
1741	16	2003-08-27	48
1742	16	2003-08-21	160
1743	16	2003-08-22	166
1744	16	2003-08-20	124
1745	16	2003-08-23	3
1746	16	2003-08-22	113
1747	16	2003-08-30	29
1748	16	2003-08-27	146
1749	16	2003-08-25	172
1750	16	2003-08-24	190
1751	16	2003-08-23	14
1752	16	2003-08-24	199
1753	16	2003-08-26	141
1754	16	2003-08-21	197
1755	16	2003-08-20	76
1756	16	2003-08-30	174
1757	16	2003-09-01	68
1758	16	2003-08-21	133
1759	16	2003-08-23	17
1760	16	2003-08-25	188
1761	17	2003-09-08	102
1762	17	2003-09-23	138
1763	17	2003-09-18	4
1764	17	2003-09-19	117
1765	17	2003-09-15	9
1766	17	2003-09-19	118
1767	17	2003-09-05	126
1768	17	2003-09-04	195
1769	17	2003-09-05	44
1770	17	2003-09-06	58
1771	17	2003-09-11	70
1772	17	2003-09-21	159
1773	17	2003-09-21	109
1774	17	2003-09-06	70
1775	17	2003-09-14	101
1776	17	2003-09-20	193
1777	17	2003-09-20	39
1778	17	2003-09-06	101
1779	17	2003-09-19	94
1780	17	2003-09-10	111
1781	17	2003-09-09	142
1782	17	2003-09-10	15
1783	17	2003-09-05	30
1784	17	2003-09-08	125
1785	17	2003-09-03	140
1786	17	2003-09-10	174
1787	17	2003-09-17	69
1788	17	2003-09-21	166
1789	17	2003-09-16	170
1790	17	2003-09-15	26
1791	17	2003-09-10	55
1792	17	2003-09-12	77
1793	17	2003-09-22	137
1794	17	2003-09-05	39
1795	17	2003-09-05	35
1796	17	2003-09-13	41
1797	17	2003-09-13	159
1798	17	2003-09-22	93
1799	17	2003-09-11	127
1800	17	2003-09-05	158
1801	17	2003-09-05	86
1802	17	2003-09-09	131
1803	17	2003-09-11	134
1804	17	2003-09-19	177
1805	17	2003-09-23	120
1806	17	2003-09-20	136
1807	17	2003-09-17	14
1808	17	2003-09-10	159
1809	17	2003-09-12	141
1810	17	2003-09-20	178
1811	17	2003-09-17	0
1812	17	2003-09-03	139
1813	17	2003-09-07	77
1814	17	2003-09-10	187
1815	17	2003-09-06	166
1816	17	2003-09-20	42
1817	17	2003-09-20	136
1818	17	2003-09-17	67
1819	17	2003-09-08	74
1820	17	2003-09-20	2
1821	17	2003-09-06	49
1822	17	2003-09-18	179
1823	17	2003-09-11	156
1824	17	2003-09-21	91
1825	17	2003-09-17	136
1826	17	2003-09-10	74
1827	17	2003-09-03	159
1828	17	2003-09-06	81
1829	17	2003-09-09	115
1830	17	2003-09-08	175
1831	17	2003-09-15	146
1832	17	2003-09-09	94
1833	17	2003-09-13	16
1834	17	2003-09-18	196
1835	17	2003-09-23	73
1836	17	2003-09-12	141
1837	17	2003-09-12	8
1838	17	2003-09-20	47
1839	17	2003-09-04	180
1840	17	2003-09-16	51
1841	17	2003-09-08	153
1842	17	2003-09-20	59
1843	17	2003-09-21	83
1844	18	2003-09-15	183
1845	18	2003-09-27	8
1846	18	2003-09-13	105
1847	18	2003-09-21	100
1848	18	2003-09-15	154
1849	18	2003-09-14	137
1850	18	2003-09-13	94
1851	18	2003-09-28	4
1852	18	2003-09-23	11
1853	18	2003-09-17	3
1854	18	2003-09-25	172
1855	18	2003-09-21	132
1856	18	2003-09-25	81
1857	18	2003-09-21	87
1858	18	2003-09-17	52
1859	18	2003-09-26	121
1860	18	2003-09-27	114
1861	18	2003-09-14	88
1862	18	2003-09-21	125
1863	18	2003-09-27	106
1864	18	2003-10-03	185
1865	18	2003-09-20	190
1866	18	2003-09-22	59
1867	18	2003-10-03	123
1868	18	2003-09-23	43
1869	18	2003-10-03	89
1870	18	2003-09-30	157
1871	18	2003-10-02	82
1872	18	2003-09-29	56
1873	18	2003-09-18	178
1874	18	2003-09-26	103
1875	18	2003-09-27	88
1876	18	2003-10-03	4
1877	18	2003-09-21	139
1878	18	2003-09-14	164
1879	18	2003-09-20	81
1880	18	2003-09-18	26
1881	18	2003-09-21	96
1882	18	2003-10-03	126
1883	18	2003-09-20	128
1884	18	2003-09-20	123
1885	18	2003-09-26	16
1886	18	2003-09-16	101
1887	18	2003-09-29	104
1888	18	2003-09-30	161
1889	18	2003-09-24	152
1890	18	2003-09-18	155
1891	18	2003-09-27	15
1892	18	2003-10-01	56
1893	18	2003-09-23	183
1894	18	2003-09-22	159
1895	18	2003-09-26	190
1896	18	2003-09-17	20
1897	18	2003-09-29	2
1898	18	2003-10-01	18
1899	18	2003-09-18	31
1900	18	2003-09-13	72
1901	18	2003-09-25	142
1902	18	2003-09-29	135
1903	18	2003-09-21	72
1904	18	2003-09-17	3
1905	18	2003-09-14	145
1906	18	2003-09-13	29
1907	18	2003-09-19	186
1908	18	2003-09-19	130
1909	18	2003-09-23	196
1910	18	2003-10-01	179
1911	18	2003-10-02	124
1912	18	2003-09-13	55
1913	18	2003-09-15	4
1914	18	2003-10-03	78
1915	18	2003-09-28	124
1916	18	2003-09-18	124
1917	18	2003-09-25	105
1918	18	2003-09-27	68
1919	18	2003-10-02	61
1920	18	2003-09-22	71
1921	18	2003-09-14	45
1922	18	2003-09-30	12
1923	18	2003-09-24	170
1924	18	2003-09-29	66
1925	18	2003-09-21	8
1926	18	2003-09-18	94
1927	18	2003-09-29	68
1928	18	2003-09-22	123
1929	18	2003-09-28	46
1930	18	2003-09-17	196
1931	18	2003-09-16	169
1932	18	2003-09-14	175
1933	18	2003-09-28	75
1934	18	2003-09-21	36
1935	18	2003-10-01	182
1936	18	2003-09-19	188
1937	18	2003-09-26	146
1938	18	2003-09-16	57
1939	18	2003-10-03	115
1940	18	2003-09-21	130
1941	18	2003-10-01	138
1942	18	2003-09-25	99
1943	18	2003-09-20	96
1944	18	2003-09-26	99
1945	18	2003-09-28	155
1946	18	2003-09-15	196
1947	18	2003-09-26	196
1948	18	2003-09-15	92
1949	18	2003-09-18	111
1950	18	2003-09-24	74
1951	18	2003-09-18	21
1952	19	2003-10-10	5
1953	19	2003-10-06	113
1954	19	2003-10-23	120
1955	19	2003-10-03	46
1956	19	2003-10-22	35
1957	19	2003-10-11	198
1958	19	2003-10-07	76
1959	19	2003-10-11	95
1960	19	2003-10-18	44
1961	19	2003-10-23	178
1962	19	2003-10-21	144
1963	19	2003-10-20	193
1964	19	2003-10-23	184
1965	19	2003-10-16	89
1966	19	2003-10-12	16
1967	19	2003-10-14	178
1968	19	2003-10-17	37
1969	19	2003-10-10	136
1970	19	2003-10-12	111
1971	19	2003-10-10	86
1972	19	2003-10-21	71
1973	19	2003-10-17	14
1974	19	2003-10-14	147
1975	19	2003-10-07	127
1976	19	2003-10-03	184
1977	19	2003-10-12	164
1978	19	2003-10-21	112
1979	19	2003-10-07	154
1980	19	2003-10-12	110
1981	19	2003-10-18	112
1982	19	2003-10-12	152
1983	19	2003-10-22	131
1984	19	2003-10-23	0
1985	19	2003-10-09	59
1986	19	2003-10-16	193
1987	19	2003-10-12	56
1988	19	2003-10-08	0
1989	19	2003-10-23	31
1990	19	2003-10-05	20
1991	19	2003-10-06	71
1992	19	2003-10-15	71
1993	19	2003-10-03	46
1994	19	2003-10-08	103
1995	19	2003-10-20	151
1996	19	2003-10-20	161
1997	19	2003-10-11	24
1998	19	2003-10-12	174
1999	19	2003-10-09	108
2000	19	2003-10-10	168
2001	19	2003-10-20	183
2002	19	2003-10-07	93
2003	19	2003-10-11	191
2004	19	2003-10-05	159
2005	19	2003-10-22	43
2006	19	2003-10-14	23
2007	19	2003-10-05	54
2008	19	2003-10-20	138
2009	19	2003-10-18	126
2010	19	2003-10-09	171
2011	19	2003-10-12	29
2012	19	2003-10-13	186
2013	19	2003-10-23	91
2014	19	2003-10-06	25
2015	19	2003-10-19	172
2016	19	2003-10-10	67
2017	19	2003-10-10	44
2018	19	2003-10-06	187
2019	19	2003-10-10	93
2020	19	2003-10-10	111
2021	19	2003-10-11	167
2022	19	2003-10-19	14
2023	19	2003-10-13	120
2024	19	2003-10-21	109
2025	19	2003-10-14	94
2026	19	2003-10-17	84
2027	19	2003-10-09	120
2028	19	2003-10-03	37
2029	19	2003-10-09	68
2030	19	2003-10-06	169
2031	19	2003-10-21	172
2032	19	2003-10-03	143
2033	19	2003-10-05	115
2034	19	2003-10-05	34
2035	19	2003-10-17	61
2036	19	2003-10-20	81
2037	19	2003-10-22	130
2038	19	2003-10-08	68
2039	19	2003-10-14	113
2040	19	2003-10-21	117
2041	19	2003-10-18	126
2042	19	2003-10-04	51
2043	20	2003-10-26	72
2044	20	2003-10-24	100
2045	20	2003-10-30	149
2046	20	2003-11-08	154
2047	20	2003-11-07	142
2048	20	2003-10-22	167
2049	20	2003-10-19	106
2050	20	2003-10-19	74
2051	20	2003-11-08	24
2052	20	2003-10-31	34
2053	20	2003-10-28	132
2054	20	2003-10-27	29
2055	20	2003-11-06	144
2056	20	2003-10-23	76
2057	20	2003-10-28	56
2058	20	2003-10-31	188
2059	20	2003-10-22	158
2060	20	2003-10-30	179
2061	20	2003-10-19	28
2062	20	2003-10-24	17
2063	20	2003-10-30	52
2064	20	2003-10-20	171
2065	20	2003-10-23	65
2066	20	2003-11-07	188
2067	20	2003-11-01	46
2068	20	2003-11-07	153
2069	20	2003-10-23	21
2070	20	2003-11-05	75
2071	20	2003-11-03	52
2072	20	2003-10-20	150
2073	20	2003-10-24	32
2074	20	2003-10-30	2
2075	20	2003-10-31	13
2076	20	2003-11-07	148
2077	20	2003-11-02	87
2078	20	2003-10-26	188
2079	20	2003-10-27	50
2080	20	2003-10-21	45
2081	20	2003-11-02	0
2082	20	2003-10-29	45
2083	20	2003-10-21	85
2084	20	2003-10-25	101
2085	20	2003-10-25	195
2086	20	2003-10-31	9
2087	20	2003-10-20	69
2088	20	2003-10-30	118
2089	20	2003-10-23	45
2090	20	2003-10-24	3
2091	20	2003-10-29	5
2092	20	2003-10-28	199
2093	20	2003-10-27	122
2094	20	2003-10-22	71
2095	20	2003-10-20	190
2096	20	2003-10-26	48
2097	20	2003-11-07	155
2098	20	2003-10-19	53
2099	20	2003-10-31	104
2100	20	2003-11-05	41
2101	20	2003-10-28	147
2102	20	2003-10-29	186
2103	20	2003-11-06	167
2104	20	2003-11-08	23
2105	20	2003-11-01	25
2106	20	2003-10-31	154
2107	20	2003-11-07	33
2108	20	2003-10-27	185
2109	20	2003-10-23	34
2110	20	2003-11-03	6
2111	20	2003-11-02	78
2112	20	2003-10-19	100
2113	20	2003-10-22	70
2114	20	2003-11-05	40
2115	20	2003-11-05	172
2116	20	2003-10-31	158
2117	20	2003-10-30	80
2118	20	2003-11-03	152
2119	20	2003-11-02	116
2120	20	2003-10-20	55
2121	20	2003-11-07	47
2122	20	2003-11-05	83
2123	20	2003-11-08	6
2124	20	2003-10-30	166
2125	20	2003-10-22	129
2126	20	2003-11-04	168
2127	20	2003-10-22	15
2128	20	2003-10-21	15
2129	20	2003-10-27	101
2130	20	2003-10-31	140
2131	20	2003-11-08	138
2132	20	2003-10-20	163
2133	20	2003-10-22	119
2134	20	2003-10-24	95
2135	20	2003-10-27	106
2136	20	2003-10-24	78
2137	20	2003-11-07	198
2138	20	2003-10-30	12
2139	20	2003-11-05	87
2140	20	2003-10-29	104
2141	20	2003-11-02	120
2142	20	2003-10-24	155
2143	20	2003-10-25	85
2144	20	2003-11-01	67
2145	20	2003-10-30	28
2146	20	2003-10-25	132
2147	20	2003-10-27	170
2148	20	2003-10-24	199
2149	20	2003-10-30	22
2150	20	2003-10-20	70
2151	20	2003-10-24	52
2152	20	2003-10-30	190
2153	20	2003-10-30	121
2154	20	2003-10-24	42
2155	20	2003-10-22	0
2156	20	2003-11-03	78
2157	20	2003-10-22	139
2158	21	2003-11-04	164
2159	21	2003-11-16	118
2160	21	2003-11-05	107
2161	21	2003-11-17	20
2162	21	2003-11-12	12
2163	21	2003-11-21	109
2164	21	2003-11-23	103
2165	21	2003-11-18	53
2166	21	2003-11-12	34
2167	21	2003-11-05	66
2168	21	2003-11-04	2
2169	21	2003-11-22	93
2170	21	2003-11-09	194
2171	21	2003-11-14	91
2172	21	2003-11-04	88
2173	21	2003-11-18	57
2174	21	2003-11-14	171
2175	21	2003-11-06	117
2176	21	2003-11-03	38
2177	21	2003-11-07	198
2178	21	2003-11-08	75
2179	21	2003-11-10	18
2180	21	2003-11-22	189
2181	21	2003-11-11	18
2182	21	2003-11-22	89
2183	21	2003-11-04	180
2184	21	2003-11-08	198
2185	21	2003-11-14	26
2186	21	2003-11-09	147
2187	21	2003-11-08	10
2188	21	2003-11-08	172
2189	21	2003-11-07	91
2190	21	2003-11-11	187
2191	21	2003-11-14	108
2192	21	2003-11-13	116
2193	21	2003-11-22	14
2194	21	2003-11-09	136
2195	21	2003-11-07	198
2196	21	2003-11-15	161
2197	21	2003-11-20	54
2198	21	2003-11-18	107
2199	21	2003-11-21	74
2200	21	2003-11-16	182
2201	21	2003-11-03	147
2202	21	2003-11-08	119
2203	21	2003-11-14	181
2204	21	2003-11-19	99
2205	21	2003-11-22	117
2206	21	2003-11-23	66
2207	21	2003-11-11	100
2208	21	2003-11-17	33
2209	21	2003-11-11	0
2210	21	2003-11-11	117
2211	21	2003-11-11	167
2212	21	2003-11-16	166
2213	21	2003-11-20	147
2214	21	2003-11-17	112
2215	21	2003-11-15	122
2216	21	2003-11-18	100
2217	21	2003-11-15	122
2218	21	2003-11-10	89
2219	21	2003-11-05	64
2220	21	2003-11-06	138
2221	21	2003-11-07	1
2222	21	2003-11-14	178
2223	21	2003-11-16	108
2224	21	2003-11-08	14
2225	21	2003-11-18	131
2226	21	2003-11-19	2
2227	21	2003-11-07	10
2228	21	2003-11-23	11
2229	21	2003-11-07	140
2230	21	2003-11-09	83
2231	21	2003-11-21	119
2232	21	2003-11-06	41
2233	21	2003-11-12	88
2234	21	2003-11-18	145
2235	21	2003-11-06	8
2236	21	2003-11-22	79
2237	21	2003-11-04	38
2238	21	2003-11-16	118
2239	21	2003-11-06	80
2240	21	2003-11-11	46
2241	21	2003-11-09	199
2242	21	2003-11-18	187
2243	21	2003-11-04	175
2244	21	2003-11-10	119
2245	21	2003-11-07	111
2246	21	2003-11-04	176
2247	21	2003-11-19	176
2248	21	2003-11-21	98
2249	21	2003-11-22	184
2250	21	2003-11-22	4
2251	21	2003-11-06	11
2252	21	2003-11-17	133
2253	21	2003-11-21	138
2254	21	2003-11-12	145
2255	21	2003-11-23	41
2256	21	2003-11-17	114
2257	21	2003-11-12	141
2258	21	2003-11-15	9
2259	21	2003-11-22	40
2260	21	2003-11-13	90
2261	21	2003-11-12	125
2262	21	2003-11-16	154
2263	21	2003-11-07	47
2264	21	2003-11-06	187
2265	21	2003-11-10	13
2266	21	2003-11-09	155
2267	21	2003-11-05	48
2268	21	2003-11-17	42
2269	21	2003-11-14	122
2270	21	2003-11-03	42
2271	21	2003-11-08	96
2272	22	2003-11-29	106
2273	22	2003-11-24	26
2274	22	2003-12-03	105
2275	22	2003-11-18	71
2276	22	2003-12-03	94
2277	22	2003-11-24	180
2278	22	2003-11-23	40
2279	22	2003-11-30	178
2280	22	2003-12-04	188
2281	22	2003-12-06	145
2282	22	2003-11-29	131
2283	22	2003-11-19	138
2284	22	2003-11-17	152
2285	22	2003-11-29	67
2286	22	2003-11-23	69
2287	22	2003-11-23	54
2288	22	2003-11-18	121
2289	22	2003-12-02	147
2290	22	2003-12-02	47
2291	22	2003-11-19	133
2292	22	2003-11-28	42
2293	22	2003-11-28	107
2294	22	2003-12-03	131
2295	22	2003-12-07	121
2296	22	2003-11-17	22
2297	22	2003-12-04	31
2298	22	2003-11-18	168
2299	22	2003-11-22	171
2300	22	2003-11-30	151
2301	22	2003-11-17	65
2302	22	2003-12-06	58
2303	22	2003-12-06	71
2304	22	2003-11-20	66
2305	22	2003-12-02	196
2306	22	2003-11-20	60
2307	22	2003-12-03	67
2308	22	2003-12-06	49
2309	22	2003-11-25	132
2310	22	2003-11-27	13
2311	22	2003-11-19	0
2312	22	2003-11-26	54
2313	22	2003-11-25	22
2314	22	2003-11-22	69
2315	22	2003-12-06	37
2316	22	2003-11-21	108
2317	22	2003-11-23	192
2318	22	2003-11-23	57
2319	22	2003-12-06	73
2320	22	2003-12-04	2
2321	22	2003-12-05	70
2322	22	2003-11-19	81
2323	22	2003-11-20	176
2324	22	2003-11-20	41
2325	22	2003-11-29	45
2326	22	2003-11-22	148
2327	22	2003-11-22	73
2328	22	2003-11-20	34
2329	22	2003-11-22	164
2330	22	2003-12-01	169
2331	22	2003-11-24	152
2332	22	2003-11-29	93
2333	22	2003-11-27	104
2334	22	2003-11-21	194
2335	22	2003-11-26	135
2336	22	2003-11-26	11
2337	22	2003-11-17	43
2338	22	2003-11-19	71
2339	22	2003-11-23	162
2340	22	2003-11-27	120
2341	22	2003-11-23	82
2342	22	2003-11-20	61
2343	22	2003-12-04	111
2344	22	2003-11-28	129
2345	22	2003-11-21	155
2346	22	2003-12-04	90
2347	22	2003-12-02	160
2348	22	2003-11-23	88
2349	22	2003-11-20	188
2350	22	2003-11-27	108
2351	22	2003-11-23	14
2352	22	2003-12-01	91
2353	22	2003-11-26	62
2354	22	2003-12-05	9
2355	22	2003-11-20	181
2356	22	2003-11-19	123
2357	22	2003-11-24	80
2358	22	2003-12-07	5
2359	22	2003-12-02	51
2360	22	2003-11-21	187
2361	22	2003-11-23	81
2362	22	2003-12-02	122
2363	22	2003-11-26	178
2364	22	2003-11-28	132
2365	22	2003-11-23	129
2366	22	2003-11-24	53
2367	23	2003-12-02	191
2368	23	2003-12-18	141
2369	23	2003-12-09	178
2370	23	2003-12-10	134
2371	23	2003-12-11	157
2372	23	2003-12-16	150
2373	23	2003-12-17	133
2374	23	2003-12-14	168
2375	23	2003-11-30	183
2376	23	2003-12-05	142
2377	23	2003-12-03	50
2378	23	2003-12-04	43
2379	23	2003-12-12	126
2380	23	2003-12-05	197
2381	23	2003-12-09	96
2382	23	2003-11-30	20
2383	23	2003-12-13	179
2384	23	2003-11-30	100
2385	23	2003-12-15	58
2386	23	2003-12-19	154
2387	23	2003-12-18	62
2388	23	2003-12-10	100
2389	23	2003-12-19	161
2390	23	2003-12-18	38
2391	23	2003-12-17	65
2392	23	2003-12-19	61
2393	23	2003-12-07	56
2394	23	2003-12-02	35
2395	23	2003-12-14	133
2396	23	2003-12-02	39
2397	23	2003-12-14	43
2398	23	2003-12-01	142
2399	23	2003-12-01	170
2400	23	2003-12-05	167
2401	23	2003-12-10	88
2402	23	2003-12-16	73
2403	23	2003-11-29	165
2404	23	2003-12-07	192
2405	23	2003-12-05	15
2406	23	2003-12-02	63
2407	23	2003-12-13	23
2408	23	2003-12-14	42
2409	23	2003-12-07	56
2410	23	2003-11-29	113
2411	23	2003-12-10	96
2412	23	2003-12-04	48
2413	23	2003-12-11	134
2414	23	2003-12-03	148
2415	23	2003-12-06	146
2416	23	2003-12-14	147
2417	23	2003-12-02	115
2418	23	2003-12-13	65
2419	23	2003-12-12	127
2420	23	2003-12-15	38
2421	23	2003-12-14	3
2422	23	2003-12-15	27
2423	23	2003-12-09	0
2424	23	2003-12-19	59
2425	23	2003-12-02	3
2426	23	2003-12-10	81
2427	23	2003-12-09	41
2428	23	2003-12-14	2
2429	23	2003-12-16	194
2430	23	2003-12-10	123
2431	23	2003-12-15	76
2432	23	2003-12-11	53
2433	23	2003-12-12	195
2434	23	2003-12-02	173
2435	23	2003-12-06	53
2436	23	2003-12-07	93
2437	23	2003-12-01	187
2438	23	2003-12-16	197
2439	23	2003-12-19	4
2440	23	2003-12-12	114
2441	23	2003-12-08	86
2442	23	2003-12-11	182
2443	23	2003-12-05	195
2444	23	2003-12-08	195
2445	23	2003-12-07	159
2446	23	2003-12-11	109
2447	23	2003-12-02	159
2448	23	2003-12-14	69
2449	23	2003-12-06	54
2450	23	2003-12-05	102
2451	23	2003-12-07	10
2452	23	2003-12-14	158
2453	23	2003-12-01	106
2454	23	2003-12-12	152
2455	23	2003-12-08	55
2456	23	2003-12-10	168
2457	23	2003-12-05	126
2458	23	2003-12-14	59
2459	24	2004-01-02	52
2460	24	2003-12-21	10
2461	24	2004-01-05	66
2462	24	2003-12-20	68
2463	24	2004-01-05	5
2464	24	2004-01-06	97
2465	24	2004-01-05	136
2466	24	2003-12-25	103
2467	24	2004-01-02	103
2468	24	2003-12-23	84
2469	24	2004-01-07	77
2470	24	2003-12-28	120
2471	24	2003-12-29	100
2472	24	2004-01-05	158
2473	24	2003-12-30	136
2474	24	2003-12-29	103
2475	24	2003-12-29	111
2476	24	2004-01-02	51
2477	24	2003-12-19	196
2478	24	2003-12-22	21
2479	24	2003-12-26	140
2480	24	2003-12-21	184
2481	24	2004-01-01	85
2482	24	2003-12-31	76
2483	24	2003-12-21	121
2484	24	2004-01-02	95
2485	24	2004-01-06	148
2486	24	2003-12-26	108
2487	24	2003-12-29	78
2488	24	2003-12-27	50
2489	24	2003-12-26	62
2490	24	2004-01-01	143
2491	24	2003-12-29	187
2492	24	2004-01-05	46
2493	24	2004-01-07	112
2494	24	2004-01-06	108
2495	24	2003-12-23	100
2496	24	2004-01-02	54
2497	24	2004-01-07	73
2498	24	2004-01-04	68
2499	24	2004-01-05	139
2500	24	2003-12-18	106
2501	24	2003-12-22	9
2502	24	2003-12-18	178
2503	24	2003-12-25	42
2504	24	2004-01-02	78
2505	24	2004-01-05	100
2506	24	2003-12-28	132
2507	24	2003-12-26	176
2508	24	2003-12-23	33
2509	24	2004-01-07	119
2510	24	2004-01-03	22
2511	24	2003-12-26	23
2512	24	2003-12-30	76
2513	24	2003-12-28	21
2514	24	2003-12-27	109
2515	24	2004-01-04	56
2516	24	2004-01-01	61
2517	24	2003-12-25	17
2518	24	2003-12-19	21
2519	24	2003-12-18	54
2520	24	2003-12-24	169
2521	24	2003-12-20	113
2522	24	2003-12-23	11
2523	24	2004-01-06	67
2524	24	2004-01-04	52
2525	24	2004-01-07	189
2526	24	2004-01-05	20
2527	24	2003-12-29	118
2528	24	2003-12-20	152
2529	24	2003-12-18	108
2530	24	2003-12-18	180
2531	24	2003-12-28	161
2532	24	2003-12-19	160
2533	24	2004-01-01	64
2534	24	2003-12-19	160
2535	24	2003-12-25	104
2536	24	2003-12-22	26
2537	24	2003-12-28	174
2538	24	2003-12-30	187
2539	24	2003-12-19	119
2540	24	2003-12-27	62
2541	24	2003-12-28	11
2542	24	2003-12-29	99
2543	24	2003-12-26	194
2544	24	2003-12-30	43
2545	24	2004-01-01	82
2546	24	2003-12-26	188
2547	24	2004-01-04	167
2548	24	2003-12-21	179
2549	24	2003-12-19	121
2550	24	2004-01-04	182
2551	24	2004-01-05	41
2552	24	2003-12-22	102
2553	24	2004-01-01	122
2554	24	2003-12-21	9
2555	25	2004-01-06	4
2556	25	2004-01-06	190
2557	25	2004-01-18	136
2558	25	2004-01-18	163
2559	25	2004-01-06	105
2560	25	2004-01-17	8
2561	25	2004-01-13	29
2562	25	2004-01-16	12
2563	25	2004-01-08	171
2564	25	2004-01-16	182
2565	25	2003-12-30	13
2566	25	2004-01-12	30
2567	25	2004-01-17	183
2568	25	2004-01-08	172
2569	25	2004-01-09	110
2570	25	2004-01-12	161
2571	25	2004-01-10	76
2572	25	2004-01-10	187
2573	25	2004-01-11	182
2574	25	2004-01-01	10
2575	25	2004-01-09	191
2576	25	2004-01-08	55
2577	25	2004-01-08	16
2578	25	2004-01-03	87
2579	25	2004-01-18	144
2580	25	2004-01-17	191
2581	25	2004-01-02	153
2582	25	2004-01-12	45
2583	25	2004-01-06	105
2584	25	2004-01-05	137
2585	25	2004-01-16	56
2586	25	2004-01-13	85
2587	25	2004-01-08	68
2588	25	2004-01-11	37
2589	25	2004-01-19	93
2590	25	2004-01-19	188
2591	25	2004-01-04	5
2592	25	2004-01-11	151
2593	25	2004-01-06	99
2594	25	2004-01-08	139
2595	25	2004-01-08	53
2596	25	2004-01-06	47
2597	25	2004-01-17	94
2598	25	2004-01-04	30
2599	25	2004-01-02	174
2600	25	2004-01-12	164
2601	25	2004-01-15	139
2602	25	2004-01-18	26
2603	25	2004-01-02	46
2604	25	2004-01-16	50
2605	25	2004-01-01	176
2606	25	2004-01-10	189
2607	25	2004-01-17	61
2608	25	2004-01-08	6
2609	25	2004-01-08	21
2610	25	2003-12-31	186
2611	25	2004-01-02	124
2612	25	2004-01-13	161
2613	25	2004-01-05	154
2614	25	2004-01-14	117
2615	25	2004-01-14	12
2616	25	2004-01-05	173
2617	25	2004-01-11	46
2618	25	2004-01-10	15
2619	25	2003-12-30	54
2620	25	2004-01-05	128
2621	25	2004-01-02	165
2622	25	2003-12-30	189
2623	25	2004-01-10	90
2624	25	2004-01-03	114
2625	25	2004-01-11	167
2626	25	2004-01-01	124
2627	25	2004-01-15	188
2628	25	2004-01-01	141
2629	25	2003-12-31	133
2630	25	2004-01-15	176
2631	25	2004-01-12	189
2632	25	2004-01-01	44
2633	25	2004-01-18	117
2634	25	2004-01-08	105
2635	25	2004-01-14	150
2636	25	2003-12-31	64
2637	25	2004-01-12	130
2638	25	2004-01-11	72
2639	25	2004-01-09	8
2640	25	2004-01-06	38
2641	25	2004-01-01	100
2642	25	2004-01-11	76
2643	25	2004-01-08	115
2644	25	2004-01-14	174
2645	25	2004-01-08	85
2646	25	2004-01-04	5
2647	25	2004-01-05	163
2648	25	2004-01-14	103
2649	25	2004-01-08	133
2650	25	2004-01-09	148
2651	25	2004-01-14	58
2652	25	2004-01-15	197
2653	25	2004-01-01	167
2654	25	2004-01-09	1
2655	25	2004-01-19	167
2656	25	2004-01-18	13
2657	25	2004-01-06	169
2658	25	2004-01-19	45
2659	25	2004-01-14	66
2660	25	2004-01-10	141
2661	25	2004-01-06	69
2662	25	2004-01-05	190
2663	25	2003-12-31	56
2664	25	2004-01-10	3
2665	25	2003-12-30	184
2666	25	2003-12-30	144
2667	25	2004-01-09	40
2668	25	2004-01-03	134
2669	25	2004-01-17	65
2670	25	2004-01-06	42
2671	25	2004-01-08	148
2672	25	2004-01-07	86
2673	26	2004-01-24	147
2674	26	2004-02-04	197
2675	26	2004-02-01	1
2676	26	2004-01-30	72
2677	26	2004-01-25	182
2678	26	2004-01-27	56
2679	26	2004-01-28	107
2680	26	2004-01-26	37
2681	26	2004-02-02	73
2682	26	2004-01-16	189
2683	26	2004-01-31	8
2684	26	2004-01-24	117
2685	26	2004-01-16	158
2686	26	2004-01-29	141
2687	26	2004-02-04	184
2688	26	2004-02-03	94
2689	26	2004-02-02	87
2690	26	2004-01-30	10
2691	26	2004-01-15	177
2692	26	2004-01-22	57
2693	26	2004-01-22	119
2694	26	2004-01-21	138
2695	26	2004-02-01	4
2696	26	2004-01-15	113
2697	26	2004-01-31	13
2698	26	2004-01-18	75
2699	26	2004-01-25	36
2700	26	2004-02-02	55
2701	26	2004-01-22	198
2702	26	2004-01-25	150
2703	26	2004-02-04	40
2704	26	2004-01-20	133
2705	26	2004-01-27	80
2706	26	2004-01-26	193
2707	26	2004-01-17	103
2708	26	2004-02-01	77
2709	26	2004-01-16	168
2710	26	2004-02-01	169
2711	26	2004-01-16	165
2712	26	2004-01-26	102
2713	26	2004-01-23	46
2714	26	2004-01-21	111
2715	26	2004-02-04	148
2716	26	2004-01-25	195
2717	26	2004-01-20	136
2718	26	2004-01-23	139
2719	26	2004-01-20	184
2720	26	2004-01-17	184
2721	26	2004-02-04	128
2722	26	2004-01-30	32
2723	26	2004-01-31	121
2724	26	2004-01-22	163
2725	26	2004-01-22	94
2726	26	2004-01-24	162
2727	26	2004-01-20	78
2728	26	2004-01-23	78
2729	26	2004-01-29	91
2730	26	2004-01-26	51
2731	26	2004-01-26	30
2732	26	2004-01-15	60
2733	26	2004-01-16	17
2734	26	2004-01-17	30
2735	26	2004-02-03	40
2736	26	2004-01-27	55
2737	26	2004-02-01	72
2738	26	2004-01-29	165
2739	26	2004-01-24	130
2740	26	2004-02-04	88
2741	26	2004-01-27	45
2742	26	2004-01-18	36
2743	26	2004-01-31	72
2744	26	2004-01-25	100
2745	26	2004-01-20	55
2746	26	2004-02-02	180
2747	26	2004-01-16	33
2748	26	2004-02-01	149
2749	26	2004-02-02	63
2750	26	2004-01-21	150
2751	26	2004-01-28	180
2752	26	2004-02-03	7
2753	26	2004-01-25	138
2754	26	2004-01-27	158
2755	26	2004-01-24	56
2756	27	2004-02-02	124
2757	27	2004-01-30	109
2758	27	2004-01-28	72
2759	27	2004-02-01	4
2760	27	2004-02-06	119
2761	27	2004-02-17	183
2762	27	2004-02-10	107
2763	27	2004-02-05	143
2764	27	2004-02-01	134
2765	27	2004-02-06	164
2766	27	2004-02-13	142
2767	27	2004-02-06	69
2768	27	2004-01-30	124
2769	27	2004-01-31	183
2770	27	2004-02-12	144
2771	27	2004-01-30	112
2772	27	2004-01-28	67
2773	27	2004-02-01	183
2774	27	2004-02-04	126
2775	27	2004-01-31	60
2776	27	2004-02-04	11
2777	27	2004-02-15	178
2778	27	2004-02-04	92
2779	27	2004-02-09	119
2780	27	2004-02-11	78
2781	27	2004-01-28	135
2782	27	2004-01-30	77
2783	27	2004-02-04	129
2784	27	2004-02-06	98
2785	27	2004-02-16	87
2786	27	2004-02-02	72
2787	27	2004-02-16	46
2788	27	2004-02-14	167
2789	27	2004-02-15	78
2790	27	2004-02-01	196
2791	27	2004-01-30	82
2792	27	2004-02-04	53
2793	27	2004-02-09	170
2794	27	2004-01-31	159
2795	27	2004-02-11	98
2796	27	2004-02-08	159
2797	27	2004-02-16	162
2798	27	2004-02-10	187
2799	27	2004-01-28	117
2800	27	2004-01-29	115
2801	27	2004-02-17	194
2802	27	2004-02-06	187
2803	27	2004-02-04	167
2804	27	2004-02-10	124
2805	27	2004-02-07	13
2806	27	2004-02-16	195
2807	27	2004-01-28	106
2808	27	2004-01-31	143
2809	27	2004-02-14	121
2810	27	2004-02-06	162
2811	27	2004-02-13	126
2812	27	2004-02-12	16
2813	27	2004-02-17	196
2814	27	2004-02-11	196
2815	27	2004-02-14	178
2816	27	2004-02-14	37
2817	27	2004-02-02	186
2818	27	2004-02-17	64
2819	27	2004-01-30	62
2820	27	2004-02-17	88
2821	27	2004-02-09	187
2822	27	2004-02-06	147
2823	27	2004-02-08	176
2824	27	2004-02-08	50
2825	27	2004-02-01	17
2826	27	2004-02-03	96
2827	27	2004-02-16	182
2828	27	2004-02-05	87
2829	27	2004-02-16	144
2830	27	2004-02-10	149
2831	27	2004-02-10	155
2832	27	2004-02-09	40
2833	27	2004-02-04	66
2834	27	2004-02-06	1
2835	27	2004-02-16	70
2836	28	2004-03-05	55
2837	28	2004-02-25	127
2838	28	2004-03-05	4
2839	28	2004-02-17	113
2840	28	2004-02-28	159
2841	28	2004-02-19	140
2842	28	2004-02-27	79
2843	28	2004-03-01	190
2844	28	2004-02-23	10
2845	28	2004-02-23	3
2846	28	2004-03-03	118
2847	28	2004-02-20	59
2848	28	2004-02-26	35
2849	28	2004-02-29	83
2850	28	2004-02-26	82
2851	28	2004-02-25	34
2852	28	2004-03-05	146
2853	28	2004-02-25	196
2854	28	2004-02-19	87
2855	28	2004-02-29	150
2856	28	2004-02-24	147
2857	28	2004-03-02	161
2858	28	2004-02-17	53
2859	28	2004-03-01	49
2860	28	2004-03-02	2
2861	28	2004-02-26	118
2862	28	2004-02-17	90
2863	28	2004-02-28	189
2864	28	2004-02-20	48
2865	28	2004-03-07	139
2866	28	2004-03-01	92
2867	28	2004-02-24	181
2868	28	2004-03-04	107
2869	28	2004-03-04	163
2870	28	2004-02-26	141
2871	28	2004-02-21	143
2872	28	2004-03-06	110
2873	28	2004-02-18	101
2874	28	2004-02-23	181
2875	28	2004-02-29	199
2876	28	2004-02-23	31
2877	28	2004-02-28	163
2878	28	2004-02-26	69
2879	28	2004-03-02	70
2880	28	2004-03-04	152
2881	28	2004-02-24	116
2882	28	2004-02-26	162
2883	28	2004-02-23	93
2884	28	2004-03-05	70
2885	28	2004-03-06	4
2886	28	2004-03-05	7
2887	28	2004-03-05	178
2888	28	2004-02-24	185
2889	28	2004-02-27	94
2890	28	2004-03-02	74
2891	28	2004-02-27	72
2892	28	2004-02-22	11
2893	28	2004-02-18	50
2894	28	2004-03-05	165
2895	28	2004-02-18	90
2896	28	2004-02-21	30
2897	28	2004-02-27	22
2898	28	2004-03-02	191
2899	28	2004-02-22	184
2900	28	2004-02-28	193
2901	28	2004-02-27	180
2902	28	2004-03-05	127
2903	28	2004-03-04	146
2904	28	2004-03-06	197
2905	28	2004-02-23	153
2906	28	2004-03-02	174
2907	28	2004-02-22	195
2908	28	2004-02-18	34
2909	28	2004-02-27	152
2910	28	2004-03-07	46
2911	28	2004-02-29	134
2912	28	2004-03-02	97
2913	28	2004-02-28	94
2914	28	2004-03-03	63
2915	28	2004-02-22	166
2916	28	2004-03-03	170
2917	28	2004-02-19	57
2918	28	2004-02-17	156
2919	28	2004-02-17	139
2920	28	2004-02-20	76
2921	28	2004-03-08	124
2922	28	2004-03-07	134
2923	28	2004-03-06	110
2924	28	2004-03-02	109
2925	28	2004-02-21	58
2926	28	2004-02-19	33
2927	28	2004-02-18	139
2928	28	2004-02-25	125
2929	28	2004-02-22	3
2930	28	2004-02-25	51
2931	28	2004-02-28	84
2932	28	2004-02-29	88
2933	28	2004-02-17	71
2934	28	2004-02-21	101
2935	28	2004-02-23	25
2936	28	2004-03-05	3
2937	28	2004-02-22	63
2938	28	2004-03-01	128
2939	28	2004-02-26	175
2940	28	2004-03-08	146
2941	28	2004-02-20	23
2942	28	2004-03-07	149
2943	28	2004-02-26	162
2944	28	2004-02-24	194
2945	28	2004-03-01	73
2946	28	2004-03-06	63
2947	28	2004-02-17	60
2948	28	2004-03-08	76
2949	28	2004-02-21	60
2950	28	2004-02-22	119
2951	28	2004-02-29	96
2952	28	2004-02-26	113
2953	28	2004-03-02	74
2954	28	2004-02-20	159
2955	28	2004-02-27	192
2956	29	2004-03-04	195
2957	29	2004-03-11	150
2958	29	2004-03-11	30
2959	29	2004-03-11	57
2960	29	2004-03-11	48
2961	29	2004-03-03	114
2962	29	2004-03-13	180
2963	29	2004-03-11	63
2964	29	2004-03-02	76
2965	29	2004-03-12	72
2966	29	2004-03-18	193
2967	29	2004-03-10	156
2968	29	2004-03-16	63
2969	29	2004-02-28	106
2970	29	2004-03-03	69
2971	29	2004-03-13	111
2972	29	2004-03-17	96
2973	29	2004-03-06	31
2974	29	2004-03-17	43
2975	29	2004-03-05	106
2976	29	2004-03-15	166
2977	29	2004-03-12	191
2978	29	2004-03-18	71
2979	29	2004-03-01	10
2980	29	2004-03-16	119
2981	29	2004-03-03	124
2982	29	2004-03-18	174
2983	29	2004-03-14	113
2984	29	2004-03-12	7
2985	29	2004-03-04	170
2986	29	2004-03-07	86
2987	29	2004-03-13	129
2988	29	2004-03-07	132
2989	29	2004-03-13	93
2990	29	2004-03-12	199
2991	29	2004-03-17	94
2992	29	2004-02-29	71
2993	29	2004-03-01	100
2994	29	2004-03-13	96
2995	29	2004-03-18	11
2996	29	2004-03-15	114
2997	29	2004-02-29	8
2998	29	2004-03-12	20
2999	29	2004-03-04	166
3000	29	2004-03-17	25
3001	29	2004-03-12	82
3002	29	2004-03-15	34
3003	29	2004-03-04	39
3004	29	2004-03-12	165
3005	29	2004-02-28	62
3006	29	2004-03-18	38
3007	29	2004-02-28	182
3008	29	2004-02-29	126
3009	29	2004-03-08	192
3010	29	2004-03-06	57
3011	29	2004-03-01	23
3012	29	2004-02-29	47
3013	29	2004-03-08	189
3014	29	2004-03-16	89
3015	29	2004-03-13	136
3016	29	2004-02-28	108
3017	29	2004-03-18	109
3018	29	2004-02-29	184
3019	29	2004-03-11	189
3020	29	2004-03-01	75
3021	29	2004-03-09	65
3022	29	2004-03-05	145
3023	29	2004-03-16	13
3024	29	2004-03-18	17
3025	29	2004-03-07	52
3026	29	2004-02-27	136
3027	29	2004-03-10	82
3028	29	2004-03-16	64
3029	29	2004-03-02	15
3030	29	2004-03-06	95
3031	29	2004-03-02	13
3032	29	2004-03-13	46
3033	29	2004-02-27	40
3034	29	2004-03-04	102
3035	29	2004-03-07	181
3036	29	2004-03-14	26
3037	29	2004-03-05	14
3038	29	2004-03-15	188
3039	29	2004-03-17	45
3040	29	2004-03-11	191
3041	29	2004-03-01	85
3042	29	2004-03-12	134
3043	29	2004-03-07	9
3044	29	2004-03-10	3
3045	29	2004-03-18	159
3046	29	2004-02-29	96
3047	29	2004-03-16	160
3048	29	2004-03-02	198
3049	29	2004-02-28	7
3050	29	2004-03-08	163
3051	29	2004-03-07	186
3052	29	2004-03-18	89
3053	29	2004-03-02	178
3054	29	2004-02-27	13
3055	29	2004-03-15	167
3056	29	2004-03-16	153
3057	29	2004-03-10	156
3058	29	2004-03-16	162
3059	29	2004-02-29	8
3060	29	2004-03-18	15
3061	29	2004-02-27	111
3062	29	2004-02-27	54
3063	29	2004-03-04	44
3064	29	2004-03-07	163
3065	29	2004-02-29	176
3066	29	2004-03-17	174
3067	29	2004-03-03	41
3068	29	2004-03-16	176
3069	29	2004-03-06	147
3070	29	2004-03-15	141
3071	29	2004-03-08	187
3072	29	2004-03-16	129
3073	30	2004-03-31	151
3074	30	2004-04-01	10
3075	30	2004-03-14	195
3076	30	2004-04-03	183
3077	30	2004-03-19	128
3078	30	2004-04-01	35
3079	30	2004-03-23	124
3080	30	2004-03-30	85
3081	30	2004-03-14	13
3082	30	2004-03-17	190
3083	30	2004-03-23	16
3084	30	2004-03-24	185
3085	30	2004-03-20	11
3086	30	2004-03-17	47
3087	30	2004-03-21	104
3088	30	2004-03-31	152
3089	30	2004-03-23	151
3090	30	2004-03-15	23
3091	30	2004-03-16	134
3092	30	2004-03-27	105
3093	30	2004-03-26	173
3094	30	2004-03-15	154
3095	30	2004-03-24	191
3096	30	2004-03-31	155
3097	30	2004-03-26	58
3098	30	2004-03-30	68
3099	30	2004-03-14	184
3100	30	2004-03-15	146
3101	30	2004-03-26	138
3102	30	2004-03-23	110
3103	30	2004-03-28	35
3104	30	2004-03-24	190
3105	30	2004-03-14	174
3106	30	2004-03-14	193
3107	30	2004-03-27	123
3108	30	2004-03-26	67
3109	30	2004-04-02	122
3110	30	2004-03-21	27
3111	30	2004-03-18	174
3112	30	2004-03-26	65
3113	30	2004-03-27	177
3114	30	2004-03-27	115
3115	30	2004-03-24	29
3116	30	2004-03-30	108
3117	30	2004-03-19	56
3118	30	2004-03-29	104
3119	30	2004-03-27	117
3120	30	2004-03-17	3
3121	30	2004-03-29	14
3122	30	2004-03-14	117
3123	30	2004-04-03	188
3124	30	2004-03-22	158
3125	30	2004-03-23	94
3126	30	2004-03-25	187
3127	30	2004-04-02	173
3128	30	2004-03-26	62
3129	30	2004-04-01	13
3130	30	2004-03-15	180
3131	30	2004-03-20	55
3132	30	2004-04-02	83
3133	30	2004-03-23	167
3134	30	2004-03-19	164
3135	30	2004-03-27	23
3136	30	2004-03-23	190
3137	30	2004-03-31	193
3138	30	2004-03-25	194
3139	30	2004-03-19	190
3140	30	2004-03-24	14
3141	30	2004-03-14	163
3142	30	2004-04-03	19
3143	30	2004-03-15	70
3144	30	2004-04-02	193
3145	30	2004-03-27	17
3146	30	2004-03-24	81
3147	30	2004-04-01	80
3148	30	2004-03-15	191
3149	30	2004-03-20	117
3150	30	2004-03-16	10
3151	30	2004-03-30	14
3152	30	2004-03-31	96
3153	30	2004-03-23	120
3154	30	2004-03-25	182
3155	30	2004-03-25	165
3156	30	2004-03-30	87
3157	30	2004-03-19	95
3158	30	2004-03-29	117
3159	30	2004-03-21	136
3160	30	2004-04-03	187
3161	30	2004-03-25	49
3162	30	2004-03-30	13
3163	30	2004-03-30	15
3164	30	2004-03-16	14
3165	30	2004-03-19	17
3166	30	2004-03-16	197
3167	30	2004-04-02	186
3168	30	2004-03-16	167
3169	30	2004-03-18	69
3170	30	2004-03-30	47
3171	30	2004-04-01	100
3172	30	2004-03-24	26
3173	30	2004-03-26	128
3174	30	2004-04-03	2
3175	30	2004-03-17	197
3176	30	2004-03-25	126
3177	31	2004-04-03	22
3178	31	2004-04-06	4
3179	31	2004-04-14	190
3180	31	2004-04-14	24
3181	31	2004-04-11	27
3182	31	2004-04-12	147
3183	31	2004-03-30	19
3184	31	2004-04-12	53
3185	31	2004-04-19	143
3186	31	2004-04-19	173
3187	31	2004-04-15	187
3188	31	2004-04-06	182
3189	31	2004-04-17	38
3190	31	2004-03-31	21
3191	31	2004-04-16	111
3192	31	2004-04-12	99
3193	31	2004-04-04	143
3194	31	2004-04-02	45
3195	31	2004-04-05	173
3196	31	2004-04-04	195
3197	31	2004-04-18	148
3198	31	2004-04-12	165
3199	31	2004-04-18	194
3200	31	2004-04-02	181
3201	31	2004-04-18	126
3202	31	2004-04-14	123
3203	31	2004-04-04	188
3204	31	2004-04-08	155
3205	31	2004-04-16	154
3206	31	2004-04-02	129
3207	31	2004-04-03	12
3208	31	2004-04-03	181
3209	31	2004-04-12	15
3210	31	2004-04-09	92
3211	31	2004-04-15	32
3212	31	2004-04-19	145
3213	31	2004-04-14	155
3214	31	2004-04-11	69
3215	31	2004-03-31	132
3216	31	2004-04-01	15
3217	31	2004-04-03	132
3218	31	2004-04-05	1
3219	31	2004-04-10	9
3220	31	2004-04-18	48
3221	31	2004-04-19	92
3222	31	2004-04-13	96
3223	31	2004-04-14	151
3224	31	2004-04-07	130
3225	31	2004-04-02	108
3226	31	2004-04-17	95
3227	31	2004-04-12	39
3228	31	2004-04-13	143
3229	31	2004-04-07	69
3230	31	2004-04-12	184
3231	31	2004-04-03	90
3232	31	2004-04-05	87
3233	31	2004-04-03	35
3234	31	2004-04-17	89
3235	31	2004-04-04	115
3236	31	2004-03-30	72
3237	31	2004-04-02	40
3238	31	2004-04-06	49
3239	31	2004-04-02	83
3240	31	2004-04-09	191
3241	31	2004-04-08	152
3242	31	2004-04-14	169
3243	31	2004-04-08	1
3244	31	2004-04-15	1
3245	31	2004-04-17	142
3246	31	2004-04-13	121
3247	31	2004-04-03	17
3248	31	2004-04-14	64
3249	31	2004-04-17	160
3250	31	2004-04-07	69
3251	31	2004-04-14	95
3252	31	2004-03-31	102
3253	31	2004-04-09	188
3254	31	2004-04-14	166
3255	31	2004-04-14	52
3256	31	2004-04-08	55
3257	31	2004-04-04	144
3258	31	2004-04-17	33
3259	31	2004-04-07	151
3260	31	2004-04-15	100
3261	31	2004-03-30	61
3262	31	2004-04-09	64
3263	31	2004-04-01	195
3264	31	2004-04-01	125
3265	31	2004-04-16	64
3266	31	2004-04-14	118
3267	31	2004-04-12	177
3268	31	2004-04-09	50
3269	31	2004-04-06	113
3270	31	2004-04-06	102
3271	31	2004-04-09	119
3272	31	2004-04-14	67
3273	31	2004-04-08	60
3274	31	2004-04-09	38
3275	31	2004-04-11	117
3276	31	2004-04-11	86
3277	31	2004-04-07	198
3278	31	2004-04-09	174
3279	31	2004-04-13	139
3280	31	2004-04-14	76
3281	31	2004-04-18	199
3282	32	2004-04-20	88
3283	32	2004-04-21	13
3284	32	2004-04-25	109
3285	32	2004-04-27	71
3286	32	2004-04-22	35
3287	32	2004-05-02	74
3288	32	2004-04-14	174
3289	32	2004-04-16	126
3290	32	2004-04-18	168
3291	32	2004-04-12	97
3292	32	2004-04-29	91
3293	32	2004-04-14	95
3294	32	2004-04-19	100
3295	32	2004-04-19	148
3296	32	2004-04-21	63
3297	32	2004-04-27	59
3298	32	2004-04-16	115
3299	32	2004-04-19	123
3300	32	2004-04-20	18
3301	32	2004-04-17	86
3302	32	2004-04-17	120
3303	32	2004-04-20	14
3304	32	2004-04-12	51
3305	32	2004-04-28	161
3306	32	2004-04-13	126
3307	32	2004-05-02	194
3308	32	2004-04-28	81
3309	32	2004-05-02	198
3310	32	2004-04-21	34
3311	32	2004-05-02	67
3312	32	2004-04-21	193
3313	32	2004-04-14	68
3314	32	2004-04-21	8
3315	32	2004-04-14	63
3316	32	2004-04-24	2
3317	32	2004-04-19	140
3318	32	2004-04-24	33
3319	32	2004-04-22	69
3320	32	2004-04-28	177
3321	32	2004-04-22	137
3322	32	2004-04-15	167
3323	32	2004-04-14	168
3324	32	2004-04-13	196
3325	32	2004-04-18	154
3326	32	2004-04-24	151
3327	32	2004-04-19	44
3328	32	2004-04-20	46
3329	32	2004-04-13	31
3330	32	2004-04-29	54
3331	32	2004-04-22	32
3332	32	2004-04-16	75
3333	32	2004-04-13	83
3334	32	2004-04-16	10
3335	32	2004-04-13	155
3336	32	2004-04-28	114
3337	32	2004-05-02	148
3338	32	2004-04-26	158
3339	32	2004-04-23	11
3340	32	2004-04-24	48
3341	32	2004-05-02	186
3342	32	2004-04-17	106
3343	32	2004-04-20	32
3344	32	2004-04-20	131
3345	32	2004-04-13	107
3346	32	2004-04-21	86
3347	32	2004-04-25	80
3348	32	2004-04-15	81
3349	32	2004-04-15	117
3350	32	2004-04-18	104
3351	32	2004-04-29	76
3352	32	2004-04-16	121
3353	32	2004-04-28	131
3354	32	2004-04-26	152
3355	32	2004-04-13	124
3356	32	2004-04-25	62
3357	32	2004-05-01	106
3358	32	2004-04-18	160
3359	32	2004-04-28	173
3360	32	2004-04-22	78
3361	32	2004-04-30	187
3362	32	2004-04-15	16
3363	32	2004-04-27	81
3364	32	2004-04-27	169
3365	32	2004-04-29	143
3366	32	2004-04-18	126
3367	32	2004-04-18	39
3368	32	2004-05-02	82
3369	32	2004-04-19	83
3370	32	2004-05-01	31
3371	32	2004-04-28	97
3372	32	2004-04-19	153
3373	32	2004-04-16	131
3374	32	2004-04-26	56
3375	32	2004-04-27	2
3376	33	2004-05-14	162
3377	33	2004-05-06	91
3378	33	2004-05-01	169
3379	33	2004-05-08	4
3380	33	2004-05-15	23
3381	33	2004-05-10	75
3382	33	2004-05-07	18
3383	33	2004-05-03	146
3384	33	2004-05-01	61
3385	33	2004-05-10	37
3386	33	2004-05-12	44
3387	33	2004-05-09	55
3388	33	2004-05-06	30
3389	33	2004-05-01	189
3390	33	2004-04-29	79
3391	33	2004-05-19	46
3392	33	2004-04-29	31
3393	33	2004-05-13	62
3394	33	2004-05-17	49
3395	33	2004-05-10	12
3396	33	2004-05-08	16
3397	33	2004-04-29	42
3398	33	2004-04-30	1
3399	33	2004-05-06	53
3400	33	2004-05-12	161
3401	33	2004-05-14	20
3402	33	2004-05-07	112
3403	33	2004-05-02	29
3404	33	2004-05-03	39
3405	33	2004-05-01	24
3406	33	2004-05-16	123
3407	33	2004-05-04	59
3408	33	2004-05-13	71
3409	33	2004-05-17	189
3410	33	2004-05-15	189
3411	33	2004-05-13	28
3412	33	2004-05-10	134
3413	33	2004-05-18	30
3414	33	2004-05-10	188
3415	33	2004-05-05	32
3416	33	2004-05-11	165
3417	33	2004-05-13	76
3418	33	2004-05-19	49
3419	33	2004-05-17	55
3420	33	2004-05-04	100
3421	33	2004-05-02	41
3422	33	2004-05-05	92
3423	33	2004-05-17	101
3424	33	2004-05-13	57
3425	33	2004-05-01	58
3426	33	2004-04-29	68
3427	33	2004-05-08	11
3428	33	2004-05-12	173
3429	33	2004-05-04	156
3430	33	2004-05-10	154
3431	33	2004-05-13	74
3432	33	2004-05-08	101
3433	33	2004-05-07	136
3434	33	2004-05-19	78
3435	33	2004-05-15	80
3436	33	2004-05-09	117
3437	33	2004-05-08	135
3438	33	2004-05-07	185
3439	33	2004-05-02	69
3440	33	2004-04-29	39
3441	33	2004-05-03	181
3442	33	2004-05-14	50
3443	33	2004-05-13	102
3444	33	2004-05-14	48
3445	33	2004-05-14	140
3446	33	2004-05-12	129
3447	33	2004-05-14	176
3448	33	2004-05-17	194
3449	33	2004-05-10	140
3450	33	2004-05-19	158
3451	33	2004-05-05	0
3452	33	2004-05-19	163
3453	33	2004-05-13	73
3454	33	2004-05-08	67
3455	33	2004-05-12	82
3456	33	2004-05-07	80
3457	33	2004-05-14	162
3458	33	2004-05-01	141
3459	33	2004-05-16	160
3460	33	2004-05-01	22
3461	33	2004-04-29	46
3462	33	2004-05-09	105
3463	34	2004-05-26	65
3464	34	2004-05-11	12
3465	34	2004-05-17	67
3466	34	2004-05-29	142
3467	34	2004-05-18	44
3468	34	2004-05-25	10
3469	34	2004-05-19	59
3470	34	2004-05-19	58
3471	34	2004-05-14	75
3472	34	2004-05-19	127
3473	34	2004-05-12	80
3474	34	2004-05-27	127
3475	34	2004-05-20	174
3476	34	2004-05-27	92
3477	34	2004-05-26	167
3478	34	2004-05-20	115
3479	34	2004-05-29	130
3480	34	2004-05-15	13
3481	34	2004-05-22	3
3482	34	2004-05-16	53
3483	34	2004-05-30	131
3484	34	2004-05-15	8
3485	34	2004-05-24	172
3486	34	2004-05-27	197
3487	34	2004-05-18	15
3488	34	2004-05-18	183
3489	34	2004-05-23	35
3490	34	2004-05-21	188
3491	34	2004-05-28	100
3492	34	2004-05-27	91
3493	34	2004-05-17	166
3494	34	2004-05-16	102
3495	34	2004-05-28	157
3496	34	2004-05-18	143
3497	34	2004-05-11	107
3498	34	2004-05-20	18
3499	34	2004-05-22	168
3500	34	2004-05-27	115
3501	34	2004-05-17	187
3502	34	2004-05-20	187
3503	34	2004-05-24	108
3504	34	2004-05-13	51
3505	34	2004-05-19	129
3506	34	2004-05-13	107
3507	34	2004-05-14	47
3508	34	2004-05-26	97
3509	34	2004-05-22	173
3510	34	2004-05-13	122
3511	34	2004-05-31	12
3512	34	2004-05-21	46
3513	34	2004-05-24	93
3514	34	2004-05-15	130
3515	34	2004-05-22	99
3516	34	2004-05-22	101
3517	34	2004-05-13	69
3518	34	2004-05-30	177
3519	34	2004-05-26	39
3520	34	2004-05-25	28
3521	34	2004-05-13	134
3522	34	2004-05-18	93
3523	34	2004-05-13	104
3524	34	2004-05-16	162
3525	34	2004-05-18	105
3526	34	2004-05-14	180
3527	34	2004-05-25	62
3528	34	2004-05-24	1
3529	34	2004-05-21	182
3530	34	2004-05-31	13
3531	34	2004-05-22	172
3532	34	2004-05-30	69
3533	34	2004-05-23	77
3534	34	2004-05-27	81
3535	34	2004-05-18	37
3536	34	2004-05-12	127
3537	34	2004-05-24	69
3538	34	2004-05-22	11
3539	34	2004-05-27	152
3540	34	2004-05-12	65
3541	34	2004-05-30	80
3542	34	2004-05-31	73
3543	34	2004-05-27	15
3544	34	2004-05-28	67
3545	34	2004-05-14	56
3546	34	2004-05-20	109
3547	34	2004-05-15	21
3548	34	2004-05-26	111
3549	34	2004-05-11	166
3550	34	2004-05-31	54
3551	34	2004-05-23	32
3552	34	2004-05-18	40
3553	34	2004-05-22	101
3554	35	2004-06-19	162
3555	35	2004-06-07	179
3556	35	2004-05-30	133
3557	35	2004-05-30	165
3558	35	2004-06-14	70
3559	35	2004-06-19	49
3560	35	2004-05-30	2
3561	35	2004-06-13	171
3562	35	2004-06-07	138
3563	35	2004-06-18	86
3564	35	2004-06-16	10
3565	35	2004-06-11	56
3566	35	2004-06-07	91
3567	35	2004-06-07	108
3568	35	2004-06-14	91
3569	35	2004-05-31	170
3570	35	2004-06-16	147
3571	35	2004-06-04	119
3572	35	2004-06-03	151
3573	35	2004-06-08	36
3574	35	2004-06-15	4
3575	35	2004-06-16	137
3576	35	2004-06-03	53
3577	35	2004-06-17	174
3578	35	2004-06-08	63
3579	35	2004-06-11	64
3580	35	2004-06-11	166
3581	35	2004-06-12	111
3582	35	2004-06-18	109
3583	35	2004-06-09	54
3584	35	2004-06-13	26
3585	35	2004-06-14	145
3586	35	2004-06-12	168
3587	35	2004-06-16	88
3588	35	2004-05-31	140
3589	35	2004-06-18	179
3590	35	2004-06-10	7
3591	35	2004-06-13	5
3592	35	2004-06-11	89
3593	35	2004-06-03	50
3594	35	2004-06-19	167
3595	35	2004-06-07	60
3596	35	2004-06-01	11
3597	35	2004-06-15	155
3598	35	2004-06-14	156
3599	35	2004-05-30	5
3600	35	2004-06-12	149
3601	35	2004-06-07	142
3602	35	2004-06-18	191
3603	35	2004-06-01	114
3604	35	2004-06-05	86
3605	35	2004-06-10	41
3606	35	2004-06-09	74
3607	35	2004-06-03	179
3608	35	2004-06-02	80
3609	35	2004-06-02	37
3610	35	2004-06-07	124
3611	35	2004-06-11	38
3612	35	2004-06-11	175
3613	35	2004-06-16	86
3614	35	2004-06-16	103
3615	35	2004-06-04	104
3616	35	2004-06-06	51
3617	35	2004-06-04	95
3618	35	2004-06-19	135
3619	35	2004-06-13	188
3620	35	2004-05-30	147
3621	35	2004-06-09	58
3622	35	2004-06-12	162
3623	35	2004-06-16	47
3624	35	2004-06-12	120
3625	35	2004-05-31	92
3626	35	2004-06-05	40
3627	35	2004-06-06	94
3628	35	2004-06-18	47
3629	35	2004-06-08	140
3630	35	2004-06-08	108
3631	35	2004-06-16	144
3632	35	2004-06-05	42
3633	35	2004-06-19	21
3634	35	2004-06-01	79
3635	35	2004-06-02	185
3636	35	2004-06-15	4
3637	35	2004-06-07	9
3638	35	2004-06-05	72
3639	35	2004-06-12	158
3640	35	2004-06-04	15
3641	35	2004-06-14	154
3642	35	2004-06-06	126
3643	35	2004-06-08	104
3644	35	2004-06-11	157
3645	35	2004-06-05	131
3646	35	2004-06-15	99
3647	35	2004-06-08	33
3648	35	2004-06-16	58
3649	35	2004-05-30	114
3650	35	2004-06-18	9
3651	35	2004-06-01	197
3652	35	2004-06-09	186
3653	36	2004-06-23	36
3654	36	2004-06-25	135
3655	36	2004-07-04	23
3656	36	2004-07-05	16
3657	36	2004-07-05	102
3658	36	2004-06-20	145
3659	36	2004-06-29	90
3660	36	2004-06-17	1
3661	36	2004-07-07	16
3662	36	2004-06-18	75
3663	36	2004-06-27	155
3664	36	2004-07-01	12
3665	36	2004-07-01	159
3666	36	2004-06-24	14
3667	36	2004-07-02	91
3668	36	2004-06-20	35
3669	36	2004-06-26	52
3670	36	2004-06-30	2
3671	36	2004-06-21	123
3672	36	2004-06-19	69
3673	36	2004-06-28	32
3674	36	2004-06-30	101
3675	36	2004-06-17	103
3676	36	2004-06-20	169
3677	36	2004-06-19	158
3678	36	2004-07-04	191
3679	36	2004-07-01	57
3680	36	2004-07-04	69
3681	36	2004-06-30	54
3682	36	2004-07-03	86
3683	36	2004-07-03	56
3684	36	2004-06-30	28
3685	36	2004-07-01	121
3686	36	2004-06-24	70
3687	36	2004-07-01	123
3688	36	2004-06-27	77
3689	36	2004-06-29	128
3690	36	2004-06-22	122
3691	36	2004-06-26	166
3692	36	2004-07-02	63
3693	36	2004-07-01	33
3694	36	2004-06-26	40
3695	36	2004-06-28	26
3696	36	2004-06-29	55
3697	36	2004-07-06	184
3698	36	2004-06-26	20
3699	36	2004-06-26	141
3700	36	2004-06-22	32
3701	36	2004-07-04	46
3702	36	2004-06-27	56
3703	36	2004-06-22	97
3704	36	2004-06-28	164
3705	36	2004-06-25	95
3706	36	2004-07-07	76
3707	36	2004-06-30	41
3708	36	2004-06-27	63
3709	36	2004-06-24	159
3710	36	2004-06-28	52
3711	36	2004-06-21	15
3712	36	2004-07-02	30
3713	36	2004-07-07	45
3714	36	2004-06-22	78
3715	36	2004-06-18	73
3716	36	2004-06-25	3
3717	36	2004-06-27	62
3718	36	2004-06-18	80
3719	36	2004-07-05	8
3720	36	2004-06-21	95
3721	36	2004-06-17	88
3722	36	2004-06-19	96
3723	36	2004-06-17	95
3724	36	2004-06-24	176
3725	36	2004-07-01	188
3726	36	2004-06-18	133
3727	36	2004-06-28	74
3728	36	2004-06-21	140
3729	36	2004-07-01	38
3730	36	2004-06-22	26
3731	36	2004-07-02	70
3732	36	2004-07-07	189
3733	36	2004-06-24	64
3734	36	2004-07-01	66
3735	36	2004-06-27	100
3736	36	2004-06-27	124
3737	36	2004-06-20	141
3738	36	2004-06-19	67
3739	36	2004-06-26	184
3740	36	2004-06-20	2
3741	36	2004-07-05	96
3742	36	2004-06-27	10
3743	36	2004-06-29	171
3744	36	2004-07-05	174
3745	36	2004-07-03	156
3746	36	2004-07-07	112
3747	36	2004-06-23	153
3748	36	2004-07-04	165
3749	36	2004-06-27	141
3750	36	2004-06-25	34
3751	36	2004-07-04	2
3752	36	2004-06-27	89
3753	36	2004-06-24	54
3754	36	2004-06-26	127
3755	36	2004-06-19	188
3756	36	2004-06-30	4
3757	36	2004-06-24	4
3758	36	2004-06-22	175
3759	36	2004-06-17	158
3760	36	2004-06-23	10
3761	36	2004-06-27	135
3762	36	2004-06-25	36
3763	36	2004-07-04	28
3764	36	2004-07-06	115
3765	36	2004-06-25	183
3766	36	2004-06-24	34
3767	36	2004-07-03	93
3768	36	2004-06-27	11
3769	36	2004-07-06	2
3770	36	2004-06-30	173
3771	36	2004-06-28	181
3772	37	2004-07-14	2
3773	37	2004-07-02	171
3774	37	2004-07-15	139
3775	37	2004-07-09	7
3776	37	2004-07-07	103
3777	37	2004-07-02	189
3778	37	2004-07-13	69
3779	37	2004-07-07	50
3780	37	2004-07-11	121
3781	37	2004-07-18	9
3782	37	2004-07-09	75
3783	37	2004-07-04	196
3784	37	2004-07-01	118
3785	37	2004-07-10	144
3786	37	2004-07-11	175
3787	37	2004-07-04	8
3788	37	2004-07-20	110
3789	37	2004-06-30	34
3790	37	2004-07-12	115
3791	37	2004-07-14	88
3792	37	2004-07-17	167
3793	37	2004-07-05	51
3794	37	2004-07-11	198
3795	37	2004-07-11	118
3796	37	2004-07-15	170
3797	37	2004-07-20	14
3798	37	2004-07-14	152
3799	37	2004-07-05	131
3800	37	2004-07-05	81
3801	37	2004-07-05	127
3802	37	2004-07-05	116
3803	37	2004-07-11	141
3804	37	2004-07-18	140
3805	37	2004-07-14	89
3806	37	2004-07-20	98
3807	37	2004-07-04	91
3808	37	2004-07-11	73
3809	37	2004-07-02	58
3810	37	2004-07-04	108
3811	37	2004-07-17	4
3812	37	2004-07-10	108
3813	37	2004-07-11	108
3814	37	2004-07-05	89
3815	37	2004-06-30	121
3816	37	2004-07-15	78
3817	37	2004-07-01	118
3818	37	2004-06-30	152
3819	37	2004-07-01	103
3820	37	2004-07-16	41
3821	37	2004-07-17	85
3822	37	2004-07-13	120
3823	37	2004-07-05	59
3824	37	2004-07-10	79
3825	37	2004-07-15	1
3826	37	2004-07-05	197
3827	37	2004-07-05	101
3828	37	2004-07-20	47
3829	37	2004-07-07	131
3830	37	2004-07-11	181
3831	37	2004-07-17	149
3832	37	2004-07-07	126
3833	37	2004-07-13	153
3834	37	2004-07-08	0
3835	37	2004-06-30	109
3836	37	2004-07-14	177
3837	37	2004-07-15	105
3838	37	2004-07-13	24
3839	37	2004-07-19	157
3840	37	2004-07-10	149
3841	37	2004-07-17	99
3842	37	2004-07-19	9
3843	37	2004-07-05	11
3844	37	2004-07-14	40
3845	37	2004-07-18	50
3846	37	2004-07-12	77
3847	37	2004-07-01	186
3848	37	2004-07-19	131
3849	37	2004-07-04	79
3850	37	2004-07-04	199
3851	37	2004-07-15	65
3852	37	2004-07-17	107
3853	38	2004-07-24	35
3854	38	2004-08-01	30
3855	38	2004-07-26	44
3856	38	2004-07-23	4
3857	38	2004-07-23	163
3858	38	2004-07-23	56
3859	38	2004-07-20	94
3860	38	2004-07-19	154
3861	38	2004-08-06	177
3862	38	2004-08-01	169
3863	38	2004-07-30	89
3864	38	2004-07-22	114
3865	38	2004-07-27	156
3866	38	2004-07-23	196
3867	38	2004-08-07	100
3868	38	2004-08-01	169
3869	38	2004-08-06	95
3870	38	2004-07-23	93
3871	38	2004-08-01	16
3872	38	2004-08-08	123
3873	38	2004-07-27	161
3874	38	2004-07-24	93
3875	38	2004-07-28	189
3876	38	2004-07-24	130
3877	38	2004-07-27	92
3878	38	2004-07-19	51
3879	38	2004-07-22	59
3880	38	2004-07-31	79
3881	38	2004-08-08	124
3882	38	2004-07-24	146
3883	38	2004-07-20	142
3884	38	2004-07-30	52
3885	38	2004-07-29	68
3886	38	2004-07-25	8
3887	38	2004-07-26	169
3888	38	2004-08-06	134
3889	38	2004-08-01	95
3890	38	2004-07-31	89
3891	38	2004-07-21	140
3892	38	2004-07-29	188
3893	38	2004-08-03	183
3894	38	2004-07-20	24
3895	38	2004-08-02	84
3896	38	2004-07-30	124
3897	38	2004-08-03	27
3898	38	2004-08-06	142
3899	38	2004-07-30	39
3900	38	2004-07-23	61
3901	38	2004-08-03	96
3902	38	2004-07-29	190
3903	38	2004-07-24	96
3904	38	2004-07-21	171
3905	38	2004-08-05	2
3906	38	2004-08-03	90
3907	38	2004-08-04	68
3908	38	2004-08-01	44
3909	38	2004-07-27	173
3910	38	2004-07-20	162
3911	38	2004-07-30	142
3912	38	2004-07-30	168
3913	38	2004-07-31	106
3914	38	2004-07-22	3
3915	38	2004-07-31	116
3916	38	2004-08-05	72
3917	38	2004-07-27	192
3918	38	2004-08-08	142
3919	38	2004-07-29	67
3920	38	2004-07-23	122
3921	38	2004-07-26	194
3922	38	2004-07-21	122
3923	38	2004-08-04	181
3924	38	2004-07-26	104
3925	38	2004-07-20	93
3926	38	2004-07-26	75
3927	38	2004-08-02	119
3928	38	2004-08-02	55
3929	38	2004-07-22	117
3930	38	2004-07-31	81
3931	38	2004-07-31	131
3932	38	2004-07-26	4
3933	38	2004-07-31	50
3934	38	2004-08-01	98
3935	38	2004-08-04	108
3936	38	2004-07-28	155
3937	38	2004-08-04	138
3938	38	2004-07-25	176
3939	38	2004-07-26	56
3940	38	2004-07-20	111
3941	38	2004-08-02	133
3942	38	2004-07-24	42
3943	38	2004-07-24	169
3944	38	2004-07-19	44
3945	38	2004-07-22	162
3946	38	2004-08-05	105
3947	38	2004-07-31	68
3948	38	2004-08-01	167
3949	38	2004-07-26	190
3950	38	2004-07-19	103
3951	38	2004-07-30	168
3952	38	2004-07-28	104
3953	38	2004-08-07	28
3954	38	2004-07-24	164
3955	38	2004-07-19	174
3956	38	2004-07-27	175
3957	38	2004-07-20	58
3958	38	2004-07-28	107
3959	38	2004-07-22	168
3960	38	2004-07-28	189
3961	39	2004-08-09	163
3962	39	2004-08-13	102
3963	39	2004-08-21	66
3964	39	2004-08-19	87
3965	39	2004-08-15	120
3966	39	2004-08-08	85
3967	39	2004-08-06	109
3968	39	2004-08-14	169
3969	39	2004-08-23	113
3970	39	2004-08-03	59
3971	39	2004-08-21	51
3972	39	2004-08-20	158
3973	39	2004-08-04	195
3974	39	2004-08-11	164
3975	39	2004-08-04	22
3976	39	2004-08-06	112
3977	39	2004-08-07	132
3978	39	2004-08-12	66
3979	39	2004-08-16	63
3980	39	2004-08-11	18
3981	39	2004-08-15	80
3982	39	2004-08-19	177
3983	39	2004-08-08	71
3984	39	2004-08-20	115
3985	39	2004-08-18	155
3986	39	2004-08-05	199
3987	39	2004-08-09	62
3988	39	2004-08-12	132
3989	39	2004-08-16	40
3990	39	2004-08-22	145
3991	39	2004-08-08	44
3992	39	2004-08-06	59
3993	39	2004-08-10	179
3994	39	2004-08-10	96
3995	39	2004-08-10	138
3996	39	2004-08-09	28
3997	39	2004-08-10	93
3998	39	2004-08-14	74
3999	39	2004-08-07	116
4000	39	2004-08-23	126
4001	39	2004-08-23	118
4002	39	2004-08-08	108
4003	39	2004-08-23	56
4004	39	2004-08-11	172
4005	39	2004-08-23	85
4006	39	2004-08-14	166
4007	39	2004-08-23	139
4008	39	2004-08-10	89
4009	39	2004-08-23	69
4010	39	2004-08-08	179
4011	39	2004-08-13	71
4012	39	2004-08-22	195
4013	39	2004-08-16	182
4014	39	2004-08-04	162
4015	39	2004-08-13	198
4016	39	2004-08-10	35
4017	39	2004-08-16	119
4018	39	2004-08-21	111
4019	39	2004-08-10	85
4020	39	2004-08-06	167
4021	39	2004-08-19	178
4022	39	2004-08-04	149
4023	39	2004-08-14	168
4024	39	2004-08-04	63
4025	39	2004-08-09	77
4026	39	2004-08-04	149
4027	39	2004-08-07	121
4028	39	2004-08-04	79
4029	39	2004-08-17	82
4030	39	2004-08-11	130
4031	39	2004-08-17	191
4032	39	2004-08-06	10
4033	39	2004-08-09	170
4034	39	2004-08-07	104
4035	39	2004-08-11	4
4036	39	2004-08-03	123
4037	39	2004-08-04	104
4038	39	2004-08-12	154
4039	39	2004-08-09	149
4040	39	2004-08-06	199
4041	39	2004-08-19	159
4042	39	2004-08-03	70
4043	39	2004-08-18	166
4044	39	2004-08-03	122
4045	39	2004-08-08	131
4046	39	2004-08-22	193
4047	39	2004-08-06	107
4048	39	2004-08-07	60
4049	39	2004-08-05	104
4050	39	2004-08-14	169
4051	39	2004-08-15	113
4052	39	2004-08-06	169
4053	39	2004-08-03	128
4054	39	2004-08-17	91
4055	39	2004-08-18	134
4056	39	2004-08-19	158
4057	39	2004-08-22	160
4058	39	2004-08-07	37
4059	39	2004-08-05	7
4060	39	2004-08-23	114
4061	39	2004-08-20	89
4062	39	2004-08-20	169
4063	39	2004-08-09	27
4064	39	2004-08-14	135
4065	39	2004-08-11	125
4066	39	2004-08-11	0
4067	39	2004-08-03	190
4068	39	2004-08-09	176
4069	40	2004-09-03	64
4070	40	2004-09-01	31
4071	40	2004-09-06	142
4072	40	2004-09-09	67
4073	40	2004-08-25	147
4074	40	2004-08-29	73
4075	40	2004-08-30	166
4076	40	2004-09-10	76
4077	40	2004-09-10	124
4078	40	2004-08-29	154
4079	40	2004-08-27	68
4080	40	2004-09-01	52
4081	40	2004-08-24	79
4082	40	2004-09-04	21
4083	40	2004-09-06	184
4084	40	2004-09-11	31
4085	40	2004-09-07	63
4086	40	2004-09-05	55
4087	40	2004-09-01	84
4088	40	2004-08-29	148
4089	40	2004-08-25	143
4090	40	2004-09-06	39
4091	40	2004-08-28	95
4092	40	2004-08-26	142
4093	40	2004-09-09	116
4094	40	2004-09-08	179
4095	40	2004-09-10	53
4096	40	2004-09-10	161
4097	40	2004-09-05	134
4098	40	2004-09-09	74
4099	40	2004-08-23	84
4100	40	2004-09-03	120
4101	40	2004-08-29	95
4102	40	2004-09-04	133
4103	40	2004-09-07	23
4104	40	2004-08-28	175
4105	40	2004-09-03	194
4106	40	2004-08-29	31
4107	40	2004-09-08	185
4108	40	2004-08-25	146
4109	40	2004-09-04	138
4110	40	2004-08-24	177
4111	40	2004-09-09	154
4112	40	2004-08-31	109
4113	40	2004-08-24	178
4114	40	2004-08-26	151
4115	40	2004-08-30	121
4116	40	2004-08-24	38
4117	40	2004-08-25	191
4118	40	2004-09-07	55
4119	40	2004-09-07	54
4120	40	2004-08-29	56
4121	40	2004-08-23	47
4122	40	2004-09-01	41
4123	40	2004-09-05	83
4124	40	2004-08-23	59
4125	40	2004-09-11	35
4126	40	2004-08-27	6
4127	40	2004-09-11	84
4128	40	2004-08-31	73
4129	40	2004-09-06	184
4130	40	2004-08-31	69
4131	40	2004-09-06	174
4132	40	2004-09-03	168
4133	40	2004-09-10	22
4134	40	2004-09-12	84
4135	40	2004-09-09	150
4136	40	2004-08-29	82
4137	40	2004-09-10	134
4138	40	2004-08-27	76
4139	40	2004-09-05	72
4140	40	2004-09-05	135
4141	40	2004-09-12	26
4142	40	2004-09-04	0
4143	40	2004-09-05	108
4144	40	2004-09-03	111
4145	40	2004-09-05	162
4146	40	2004-08-28	1
4147	40	2004-08-26	23
4148	40	2004-08-23	189
4149	40	2004-08-30	36
4150	40	2004-09-06	64
4151	40	2004-08-25	141
4152	40	2004-08-28	55
4153	40	2004-09-04	138
4154	40	2004-09-12	132
4155	40	2004-09-04	130
4156	40	2004-08-29	65
4157	40	2004-08-28	37
4158	40	2004-08-28	14
4159	40	2004-08-27	157
4160	40	2004-08-24	49
4161	40	2004-09-12	186
4162	40	2004-09-12	5
4163	40	2004-09-06	54
4164	40	2004-08-27	75
4165	40	2004-08-30	137
4166	40	2004-09-05	173
4167	40	2004-08-25	138
4168	40	2004-09-05	129
4169	40	2004-09-06	101
4170	40	2004-08-29	161
4171	40	2004-09-10	188
4172	40	2004-09-01	107
4173	40	2004-09-01	189
4174	40	2004-08-30	96
4175	40	2004-08-25	192
4176	40	2004-09-09	170
4177	40	2004-09-09	92
4178	40	2004-08-29	124
4179	40	2004-09-10	83
4180	40	2004-08-24	133
4181	40	2004-09-11	117
4182	40	2004-08-24	103
4183	40	2004-08-24	71
4184	40	2004-09-10	192
4185	40	2004-09-03	194
4186	40	2004-09-09	113
4187	40	2004-09-06	6
4188	40	2004-09-03	47
4189	41	2004-09-11	66
4190	41	2004-09-09	191
4191	41	2004-09-17	75
4192	41	2004-09-10	155
4193	41	2004-09-05	49
4194	41	2004-09-17	112
4195	41	2004-09-14	196
4196	41	2004-09-10	171
4197	41	2004-09-15	187
4198	41	2004-09-13	28
4199	41	2004-09-12	55
4200	41	2004-09-17	46
4201	41	2004-09-14	154
4202	41	2004-09-13	65
4203	41	2004-09-18	82
4204	41	2004-09-09	164
4205	41	2004-09-12	46
4206	41	2004-09-17	121
4207	41	2004-09-03	123
4208	41	2004-09-11	117
4209	41	2004-09-22	21
4210	41	2004-09-22	173
4211	41	2004-09-18	43
4212	41	2004-09-16	178
4213	41	2004-09-22	79
4214	41	2004-09-22	88
4215	41	2004-09-16	40
4216	41	2004-09-23	133
4217	41	2004-09-09	97
4218	41	2004-09-11	37
4219	41	2004-09-13	97
4220	41	2004-09-19	140
4221	41	2004-09-16	115
4222	41	2004-09-22	138
4223	41	2004-09-08	26
4224	41	2004-09-19	184
4225	41	2004-09-15	91
4226	41	2004-09-14	176
4227	41	2004-09-19	77
4228	41	2004-09-12	127
4229	41	2004-09-17	155
4230	41	2004-09-12	173
4231	41	2004-09-15	148
4232	41	2004-09-18	62
4233	41	2004-09-13	21
4234	41	2004-09-06	158
4235	41	2004-09-11	128
4236	41	2004-09-15	63
4237	41	2004-09-16	78
4238	41	2004-09-07	24
4239	41	2004-09-21	140
4240	41	2004-09-10	136
4241	41	2004-09-18	130
4242	41	2004-09-18	41
4243	41	2004-09-03	169
4244	41	2004-09-05	166
4245	41	2004-09-21	72
4246	41	2004-09-20	137
4247	41	2004-09-03	3
4248	41	2004-09-16	186
4249	41	2004-09-20	51
4250	41	2004-09-20	88
4251	41	2004-09-10	106
4252	41	2004-09-16	4
4253	41	2004-09-06	191
4254	41	2004-09-22	53
4255	41	2004-09-03	154
4256	41	2004-09-11	137
4257	41	2004-09-07	25
4258	41	2004-09-20	153
4259	41	2004-09-07	91
4260	41	2004-09-14	64
4261	41	2004-09-23	5
4262	41	2004-09-18	64
4263	41	2004-09-14	38
4264	41	2004-09-18	2
4265	41	2004-09-15	52
4266	41	2004-09-11	60
4267	41	2004-09-12	48
4268	41	2004-09-04	49
4269	41	2004-09-21	154
4270	41	2004-09-11	17
4271	41	2004-09-19	31
4272	41	2004-09-21	127
4273	41	2004-09-21	66
4274	41	2004-09-20	158
4275	41	2004-09-03	106
4276	41	2004-09-10	194
4277	41	2004-09-10	24
4278	41	2004-09-21	61
4279	41	2004-09-21	177
4280	41	2004-09-19	16
4281	41	2004-09-19	156
4282	41	2004-09-20	148
4283	41	2004-09-15	110
4284	41	2004-09-04	113
4285	41	2004-09-20	85
4286	41	2004-09-20	129
4287	41	2004-09-20	108
4288	41	2004-09-04	62
4289	41	2004-09-03	28
4290	41	2004-09-12	6
4291	41	2004-09-07	2
4292	41	2004-09-04	61
4293	41	2004-09-14	67
4294	41	2004-09-22	53
4295	41	2004-09-14	37
4296	41	2004-09-23	97
4297	41	2004-09-18	143
4298	41	2004-09-17	33
4299	41	2004-09-03	174
4300	41	2004-09-16	43
4301	41	2004-09-04	180
4302	42	2004-10-08	4
4303	42	2004-09-28	61
4304	42	2004-10-03	170
4305	42	2004-09-26	34
4306	42	2004-10-01	113
4307	42	2004-10-02	44
4308	42	2004-10-11	67
4309	42	2004-10-06	0
4310	42	2004-10-10	187
4311	42	2004-10-05	15
4312	42	2004-10-10	46
4313	42	2004-10-06	10
4314	42	2004-10-08	56
4315	42	2004-09-24	23
4316	42	2004-09-29	106
4317	42	2004-10-10	11
4318	42	2004-10-08	5
4319	42	2004-10-09	172
4320	42	2004-10-01	164
4321	42	2004-09-24	124
4322	42	2004-10-01	180
4323	42	2004-09-24	12
4324	42	2004-10-05	141
4325	42	2004-10-02	188
4326	42	2004-10-04	30
4327	42	2004-09-23	97
4328	42	2004-09-23	20
4329	42	2004-10-02	170
4330	42	2004-09-30	41
4331	42	2004-10-12	56
4332	42	2004-10-06	52
4333	42	2004-09-24	181
4334	42	2004-10-01	110
4335	42	2004-10-06	185
4336	42	2004-10-11	68
4337	42	2004-09-26	98
4338	42	2004-09-29	199
4339	42	2004-10-02	37
4340	42	2004-10-01	69
4341	42	2004-10-08	111
4342	42	2004-09-25	37
4343	42	2004-10-10	75
4344	42	2004-10-04	179
4345	42	2004-10-09	78
4346	42	2004-10-08	56
4347	42	2004-10-12	148
4348	42	2004-10-03	169
4349	42	2004-10-11	114
4350	42	2004-09-30	161
4351	42	2004-09-30	167
4352	42	2004-10-11	180
4353	42	2004-10-01	30
4354	42	2004-10-12	20
4355	42	2004-10-01	112
4356	42	2004-10-03	160
4357	42	2004-10-12	4
4358	42	2004-09-27	100
4359	42	2004-10-04	170
4360	42	2004-10-12	54
4361	42	2004-10-02	119
4362	42	2004-09-25	100
4363	42	2004-09-28	159
4364	42	2004-10-11	59
4365	42	2004-10-10	129
4366	42	2004-10-03	62
4367	42	2004-09-29	80
4368	42	2004-10-12	75
4369	42	2004-10-04	51
4370	42	2004-10-05	86
4371	42	2004-09-28	83
4372	42	2004-10-05	34
4373	42	2004-09-24	29
4374	42	2004-10-04	178
4375	42	2004-10-03	138
4376	42	2004-09-29	134
4377	42	2004-09-23	55
4378	42	2004-09-23	115
4379	42	2004-10-11	188
4380	42	2004-10-13	192
4381	42	2004-10-04	1
4382	42	2004-10-05	72
4383	42	2004-10-04	17
4384	42	2004-10-10	49
4385	42	2004-10-01	30
4386	42	2004-09-23	53
4387	42	2004-09-24	158
4388	42	2004-09-24	89
4389	42	2004-10-12	48
4390	42	2004-09-26	12
4391	42	2004-10-07	165
4392	42	2004-10-07	199
4393	42	2004-09-29	139
4394	42	2004-10-12	154
4395	42	2004-09-28	173
4396	42	2004-10-06	30
4397	42	2004-10-10	198
4398	42	2004-10-04	85
4399	42	2004-10-01	49
4400	42	2004-10-11	47
4401	42	2004-10-03	125
4402	42	2004-10-11	17
4403	42	2004-10-10	74
4404	42	2004-10-12	182
4405	42	2004-10-03	160
4406	42	2004-10-13	132
4407	43	2004-10-29	188
4408	43	2004-10-20	59
4409	43	2004-10-18	49
4410	43	2004-10-17	89
4411	43	2004-10-14	114
4412	43	2004-10-22	99
4413	43	2004-10-19	182
4414	43	2004-10-10	108
4415	43	2004-10-14	70
4416	43	2004-10-25	76
4417	43	2004-10-28	125
4418	43	2004-10-11	150
4419	43	2004-10-14	120
4420	43	2004-10-16	9
4421	43	2004-10-14	79
4422	43	2004-10-22	30
4423	43	2004-10-22	0
4424	43	2004-10-11	62
4425	43	2004-10-15	61
4426	43	2004-10-19	154
4427	43	2004-10-26	78
4428	43	2004-10-26	66
4429	43	2004-10-26	81
4430	43	2004-10-26	120
4431	43	2004-10-26	51
4432	43	2004-10-29	190
4433	43	2004-10-12	41
4434	43	2004-10-21	114
4435	43	2004-10-09	63
4436	43	2004-10-26	41
4437	43	2004-10-28	5
4438	43	2004-10-26	5
4439	43	2004-10-29	185
4440	43	2004-10-13	149
4441	43	2004-10-24	148
4442	43	2004-10-17	17
4443	43	2004-10-18	130
4444	43	2004-10-13	80
4445	43	2004-10-23	173
4446	43	2004-10-17	86
4447	43	2004-10-09	98
4448	43	2004-10-29	32
4449	43	2004-10-10	195
4450	43	2004-10-12	109
4451	43	2004-10-19	36
4452	43	2004-10-28	138
4453	43	2004-10-27	138
4454	43	2004-10-13	100
4455	43	2004-10-14	178
4456	43	2004-10-15	184
4457	43	2004-10-25	186
4458	43	2004-10-09	104
4459	43	2004-10-18	156
4460	43	2004-10-29	137
4461	43	2004-10-12	48
4462	43	2004-10-21	37
4463	43	2004-10-09	60
4464	43	2004-10-12	155
4465	43	2004-10-09	100
4466	43	2004-10-15	68
4467	43	2004-10-11	133
4468	43	2004-10-26	1
4469	43	2004-10-13	121
4470	43	2004-10-13	158
4471	43	2004-10-11	94
4472	43	2004-10-17	33
4473	43	2004-10-16	74
4474	43	2004-10-18	15
4475	43	2004-10-22	132
4476	43	2004-10-11	97
4477	43	2004-10-09	142
4478	43	2004-10-15	190
4479	43	2004-10-18	42
4480	43	2004-10-29	149
4481	43	2004-10-16	196
4482	43	2004-10-12	67
4483	43	2004-10-12	60
4484	43	2004-10-29	78
4485	43	2004-10-28	192
4486	43	2004-10-10	131
4487	43	2004-10-23	105
4488	43	2004-10-27	43
4489	43	2004-10-11	34
4490	43	2004-10-11	82
4491	43	2004-10-12	164
4492	43	2004-10-10	135
4493	43	2004-10-15	102
4494	44	2004-11-05	24
4495	44	2004-11-03	152
4496	44	2004-10-27	49
4497	44	2004-10-24	71
4498	44	2004-10-31	36
4499	44	2004-10-27	156
4500	44	2004-10-25	74
4501	44	2004-10-24	155
4502	44	2004-10-31	18
4503	44	2004-10-25	6
4504	44	2004-11-09	184
4505	44	2004-10-24	98
4506	44	2004-10-24	142
4507	44	2004-10-31	59
4508	44	2004-10-27	120
4509	44	2004-10-23	142
4510	44	2004-10-21	157
4511	44	2004-10-27	96
4512	44	2004-10-20	118
4513	44	2004-10-23	64
4514	44	2004-10-29	190
4515	44	2004-10-23	21
4516	44	2004-10-24	84
4517	44	2004-10-28	25
4518	44	2004-10-27	94
4519	44	2004-10-30	148
4520	44	2004-10-22	172
4521	44	2004-10-24	71
4522	44	2004-10-30	24
4523	44	2004-11-01	13
4524	44	2004-11-04	15
4525	44	2004-10-22	15
4526	44	2004-10-25	166
4527	44	2004-11-03	24
4528	44	2004-10-25	29
4529	44	2004-11-07	139
4530	44	2004-10-23	96
4531	44	2004-11-01	45
4532	44	2004-10-24	125
4533	44	2004-10-29	14
4534	44	2004-10-21	53
4535	44	2004-10-24	52
4536	44	2004-10-25	112
4537	44	2004-10-27	198
4538	44	2004-10-26	176
4539	44	2004-10-24	189
4540	44	2004-11-01	34
4541	44	2004-10-28	100
4542	44	2004-11-01	93
4543	44	2004-10-23	188
4544	44	2004-11-07	182
4545	44	2004-11-04	146
4546	44	2004-11-08	46
4547	44	2004-10-25	36
4548	44	2004-11-01	101
4549	44	2004-11-07	68
4550	44	2004-10-31	193
4551	44	2004-11-01	126
4552	44	2004-10-20	140
4553	44	2004-10-22	45
4554	44	2004-11-08	85
4555	44	2004-10-27	28
4556	44	2004-11-01	118
4557	44	2004-11-08	128
4558	44	2004-10-30	127
4559	44	2004-10-21	196
4560	44	2004-11-06	178
4561	44	2004-10-30	152
4562	44	2004-11-06	159
4563	44	2004-11-02	20
4564	44	2004-10-22	82
4565	44	2004-10-20	83
4566	44	2004-10-25	14
4567	44	2004-11-01	75
4568	44	2004-10-31	147
4569	44	2004-11-06	111
4570	44	2004-10-25	76
4571	44	2004-11-05	143
4572	44	2004-10-26	154
4573	44	2004-10-27	189
4574	44	2004-10-22	165
4575	44	2004-11-02	177
4576	44	2004-10-27	57
4577	44	2004-11-02	73
4578	44	2004-11-02	185
4579	44	2004-10-28	173
4580	44	2004-10-29	169
4581	44	2004-10-30	9
4582	44	2004-11-03	48
4583	44	2004-10-26	29
4584	44	2004-10-27	72
4585	44	2004-10-24	35
4586	44	2004-10-31	16
4587	44	2004-11-09	72
4588	44	2004-10-28	191
4589	44	2004-11-04	116
4590	44	2004-10-29	110
4591	44	2004-11-01	3
4592	44	2004-10-30	52
4593	44	2004-11-07	159
4594	44	2004-11-07	8
4595	44	2004-10-23	107
4596	44	2004-10-25	153
4597	44	2004-10-31	12
4598	44	2004-10-22	26
4599	44	2004-10-27	195
4600	44	2004-10-27	147
4601	44	2004-10-26	56
4602	45	2004-10-31	106
4603	45	2004-11-10	57
4604	45	2004-11-03	72
4605	45	2004-11-17	189
4606	45	2004-11-04	68
4607	45	2004-11-01	102
4608	45	2004-11-01	107
4609	45	2004-11-13	13
4610	45	2004-11-11	154
4611	45	2004-11-06	15
4612	45	2004-11-09	158
4613	45	2004-11-03	25
4614	45	2004-11-16	13
4615	45	2004-11-12	83
4616	45	2004-11-17	57
4617	45	2004-11-11	156
4618	45	2004-11-06	49
4619	45	2004-11-02	32
4620	45	2004-11-12	95
4621	45	2004-11-05	21
4622	45	2004-11-19	17
4623	45	2004-11-11	105
4624	45	2004-11-06	43
4625	45	2004-10-31	110
4626	45	2004-11-20	171
4627	45	2004-11-17	106
4628	45	2004-11-07	76
4629	45	2004-11-13	119
4630	45	2004-11-12	13
4631	45	2004-11-18	194
4632	45	2004-10-31	139
4633	45	2004-11-15	58
4634	45	2004-10-31	79
4635	45	2004-11-18	91
4636	45	2004-11-17	136
4637	45	2004-11-10	124
4638	45	2004-11-02	9
4639	45	2004-11-11	164
4640	45	2004-11-19	100
4641	45	2004-11-12	187
4642	45	2004-11-19	158
4643	45	2004-11-09	48
4644	45	2004-11-05	68
4645	45	2004-11-10	11
4646	45	2004-11-06	166
4647	45	2004-11-13	149
4648	45	2004-11-12	177
4649	45	2004-10-31	65
4650	45	2004-11-16	170
4651	45	2004-11-18	120
4652	45	2004-11-01	26
4653	45	2004-11-20	107
4654	45	2004-11-11	178
4655	45	2004-11-17	2
4656	45	2004-11-02	178
4657	45	2004-11-06	198
4658	45	2004-11-04	64
4659	45	2004-11-04	88
4660	45	2004-10-31	189
4661	45	2004-11-02	93
4662	45	2004-11-06	8
4663	45	2004-11-05	144
4664	45	2004-11-02	124
4665	45	2004-11-02	63
4666	45	2004-11-19	52
4667	45	2004-11-02	110
4668	45	2004-11-02	79
4669	45	2004-11-19	147
4670	45	2004-11-20	0
4671	45	2004-11-04	79
4672	45	2004-11-08	189
4673	45	2004-11-14	166
4674	45	2004-11-01	159
4675	45	2004-11-14	135
4676	45	2004-11-11	57
4677	45	2004-11-03	129
4678	45	2004-11-12	152
4679	45	2004-10-31	98
4680	45	2004-11-14	60
4681	45	2004-11-02	57
4682	45	2004-11-19	129
4683	45	2004-11-04	198
4684	45	2004-11-11	163
4685	45	2004-11-06	139
4686	45	2004-11-10	11
4687	45	2004-11-10	143
4688	45	2004-11-05	130
4689	45	2004-11-17	85
4690	45	2004-11-05	155
4691	45	2004-10-31	3
4692	45	2004-11-17	160
4693	45	2004-10-31	104
4694	45	2004-11-10	92
4695	45	2004-11-09	173
4696	45	2004-11-17	20
4697	45	2004-11-14	156
4698	45	2004-11-07	39
4699	45	2004-11-04	36
4700	45	2004-11-01	67
4701	45	2004-11-17	183
4702	45	2004-11-13	128
4703	45	2004-11-03	76
4704	45	2004-11-16	137
4705	45	2004-11-20	46
4706	45	2004-11-07	2
4707	46	2004-11-15	110
4708	46	2004-12-03	130
4709	46	2004-11-21	67
4710	46	2004-11-18	183
4711	46	2004-11-20	163
4712	46	2004-11-21	13
4713	46	2004-11-21	46
4714	46	2004-11-30	154
4715	46	2004-11-21	48
4716	46	2004-11-18	33
4717	46	2004-11-17	83
4718	46	2004-11-29	61
4719	46	2004-12-02	66
4720	46	2004-11-22	125
4721	46	2004-11-26	62
4722	46	2004-11-26	161
4723	46	2004-11-22	7
4724	46	2004-11-21	151
4725	46	2004-12-03	122
4726	46	2004-11-29	0
4727	46	2004-11-28	26
4728	46	2004-11-24	171
4729	46	2004-11-26	120
4730	46	2004-12-01	0
4731	46	2004-11-26	66
4732	46	2004-11-18	70
4733	46	2004-11-16	29
4734	46	2004-11-20	107
4735	46	2004-12-01	8
4736	46	2004-11-22	34
4737	46	2004-12-03	192
4738	46	2004-11-15	134
4739	46	2004-11-22	11
4740	46	2004-11-14	108
4741	46	2004-11-23	101
4742	46	2004-11-29	178
4743	46	2004-12-03	61
4744	46	2004-11-26	29
4745	46	2004-11-24	79
4746	46	2004-11-15	64
4747	46	2004-12-02	159
4748	46	2004-12-04	50
4749	46	2004-11-25	99
4750	46	2004-11-18	171
4751	46	2004-12-04	193
4752	46	2004-11-23	29
4753	46	2004-12-02	186
4754	46	2004-11-18	106
4755	46	2004-11-27	18
4756	46	2004-11-15	186
4757	46	2004-11-24	111
4758	46	2004-11-22	172
4759	46	2004-11-29	99
4760	46	2004-11-16	192
4761	46	2004-11-24	71
4762	46	2004-11-16	64
4763	46	2004-11-19	119
4764	46	2004-12-01	125
4765	46	2004-11-24	134
4766	46	2004-11-21	32
4767	46	2004-11-14	42
4768	46	2004-11-25	103
4769	46	2004-11-22	89
4770	46	2004-11-15	41
4771	46	2004-12-03	159
4772	46	2004-12-03	117
4773	46	2004-11-25	136
4774	46	2004-11-22	127
4775	46	2004-11-27	5
4776	46	2004-11-30	135
4777	46	2004-11-15	44
4778	46	2004-12-02	114
4779	46	2004-11-16	63
4780	46	2004-11-25	174
4781	46	2004-11-30	173
4782	46	2004-11-21	187
4783	46	2004-11-22	185
4784	46	2004-12-01	168
4785	46	2004-11-16	157
4786	46	2004-11-23	89
4787	46	2004-11-25	150
4788	46	2004-12-03	96
4789	46	2004-11-28	168
4790	46	2004-11-30	15
4791	46	2004-11-30	106
4792	46	2004-11-23	157
4793	46	2004-12-03	56
4794	46	2004-11-19	33
4795	46	2004-12-03	0
4796	46	2004-12-04	65
4797	46	2004-11-16	77
4798	46	2004-11-20	83
4799	46	2004-11-18	120
4800	46	2004-11-29	27
4801	46	2004-11-17	152
4802	46	2004-11-14	47
4803	46	2004-11-25	178
4804	46	2004-11-18	3
4805	46	2004-11-22	101
4806	46	2004-11-19	99
4807	47	2004-12-16	63
4808	47	2004-12-14	98
4809	47	2004-12-15	60
4810	47	2004-12-04	167
4811	47	2004-12-14	52
4812	47	2004-12-06	14
4813	47	2004-12-15	55
4814	47	2004-12-04	170
4815	47	2004-12-15	15
4816	47	2004-11-28	0
4817	47	2004-12-14	83
4818	47	2004-12-12	63
4819	47	2004-12-13	117
4820	47	2004-12-18	52
4821	47	2004-12-09	53
4822	47	2004-12-17	165
4823	47	2004-12-16	74
4824	47	2004-12-04	68
4825	47	2004-12-13	126
4826	47	2004-12-09	43
4827	47	2004-11-28	183
4828	47	2004-12-16	92
4829	47	2004-12-06	160
4830	47	2004-12-03	199
4831	47	2004-12-14	186
4832	47	2004-12-16	93
4833	47	2004-11-30	189
4834	47	2004-11-29	51
4835	47	2004-12-08	37
4836	47	2004-12-17	35
4837	47	2004-12-06	153
4838	47	2004-12-11	135
4839	47	2004-12-09	41
4840	47	2004-11-30	188
4841	47	2004-11-29	7
4842	47	2004-12-12	72
4843	47	2004-12-06	77
4844	47	2004-12-08	156
4845	47	2004-12-13	118
4846	47	2004-12-14	28
4847	47	2004-12-11	152
4848	47	2004-12-08	195
4849	47	2004-12-07	146
4850	47	2004-12-13	87
4851	47	2004-12-04	12
4852	47	2004-12-07	110
4853	47	2004-12-09	125
4854	47	2004-12-15	124
4855	47	2004-11-29	33
4856	47	2004-12-13	11
4857	47	2004-12-13	178
4858	47	2004-12-14	85
4859	47	2004-12-03	142
4860	47	2004-12-10	5
4861	47	2004-12-16	13
4862	47	2004-12-10	194
4863	47	2004-12-04	104
4864	47	2004-12-02	136
4865	47	2004-12-13	114
4866	47	2004-12-18	104
4867	47	2004-12-08	139
4868	47	2004-11-28	77
4869	47	2004-12-03	84
4870	47	2004-11-28	186
4871	47	2004-11-28	190
4872	47	2004-12-10	148
4873	47	2004-11-29	60
4874	47	2004-12-17	13
4875	47	2004-12-12	80
4876	47	2004-12-16	27
4877	47	2004-12-16	96
4878	47	2004-11-29	80
4879	47	2004-12-05	64
4880	47	2004-12-06	67
4881	47	2004-11-29	111
4882	47	2004-12-10	56
4883	47	2004-12-05	44
4884	47	2004-11-29	54
4885	47	2004-12-18	165
4886	47	2004-12-04	122
4887	47	2004-12-17	105
4888	47	2004-12-16	81
4889	47	2004-12-17	6
4890	47	2004-12-15	68
4891	47	2004-12-10	133
4892	47	2004-12-11	71
4893	47	2004-12-16	103
4894	47	2004-12-10	118
4895	47	2004-12-14	22
4896	47	2004-12-03	57
4897	47	2004-12-05	176
4898	47	2004-12-10	105
4899	47	2004-12-04	149
4900	47	2004-12-09	88
4901	47	2004-12-02	82
4902	47	2004-12-14	53
4903	47	2004-12-06	184
4904	47	2004-12-09	197
4905	47	2004-12-14	158
4906	47	2004-12-18	100
4907	47	2004-12-11	103
4908	47	2004-12-13	36
4909	47	2004-12-03	49
4910	47	2004-12-01	8
4911	47	2004-11-30	140
4912	47	2004-12-11	28
4913	47	2004-12-14	154
4914	47	2004-12-16	37
4915	47	2004-12-15	97
4916	47	2004-12-13	170
4917	47	2004-12-05	4
4918	47	2004-12-18	119
4919	47	2004-11-28	193
4920	47	2004-12-06	143
4921	47	2004-12-11	0
4922	47	2004-12-05	157
4923	47	2004-12-17	76
4924	48	2004-12-22	19
4925	48	2004-12-23	188
4926	48	2004-12-21	20
4927	48	2004-12-23	41
4928	48	2004-12-29	61
4929	48	2004-12-29	91
4930	48	2004-12-31	34
4931	48	2004-12-31	127
4932	48	2004-12-14	176
4933	48	2004-12-19	94
4934	48	2004-12-28	153
4935	48	2004-12-20	124
4936	48	2004-12-21	34
4937	48	2004-12-24	178
4938	48	2004-12-15	112
4939	48	2004-12-24	136
4940	48	2004-12-26	44
4941	48	2004-12-20	32
4942	48	2004-12-20	93
4943	48	2004-12-28	194
4944	48	2004-12-19	51
4945	48	2004-12-12	166
4946	48	2004-12-24	34
4947	48	2004-12-17	45
4948	48	2004-12-31	57
4949	48	2004-12-20	199
4950	48	2004-12-24	90
4951	48	2004-12-14	199
4952	48	2004-12-16	110
4953	48	2004-12-22	107
4954	48	2004-12-29	170
4955	48	2004-12-12	31
4956	48	2004-12-18	154
4957	48	2004-12-17	68
4958	48	2004-12-21	31
4959	48	2005-01-01	108
4960	48	2005-01-01	10
4961	48	2004-12-29	181
4962	48	2004-12-30	41
4963	48	2004-12-16	56
4964	48	2004-12-14	38
4965	48	2004-12-18	23
4966	48	2004-12-13	90
4967	48	2004-12-18	126
4968	48	2004-12-30	143
4969	48	2004-12-20	22
4970	48	2004-12-13	14
4971	48	2004-12-16	189
4972	48	2004-12-24	30
4973	48	2004-12-31	5
4974	48	2004-12-13	101
4975	48	2004-12-15	166
4976	48	2004-12-27	17
4977	48	2004-12-16	55
4978	48	2004-12-15	41
4979	48	2004-12-20	182
4980	48	2004-12-27	69
4981	48	2004-12-14	149
4982	48	2004-12-12	116
4983	48	2004-12-22	120
4984	48	2004-12-12	149
4985	48	2004-12-16	88
4986	48	2004-12-19	106
4987	48	2005-01-01	38
4988	48	2004-12-19	198
4989	48	2004-12-13	63
4990	48	2004-12-12	90
4991	48	2004-12-25	48
4992	48	2004-12-31	176
4993	48	2004-12-17	85
4994	48	2004-12-14	72
4995	48	2004-12-29	15
4996	48	2004-12-23	141
4997	48	2004-12-25	117
4998	48	2004-12-28	87
4999	48	2004-12-27	115
5000	48	2004-12-17	3
5001	48	2004-12-27	148
5002	48	2004-12-14	122
5003	48	2004-12-16	195
5004	48	2004-12-13	43
5005	48	2004-12-26	104
5006	48	2004-12-31	112
5007	48	2004-12-22	43
5008	48	2004-12-17	24
5009	48	2004-12-20	150
5010	48	2004-12-15	73
5011	48	2004-12-16	128
5012	48	2004-12-16	99
5013	48	2004-12-25	20
5014	48	2004-12-24	139
5015	48	2004-12-28	67
5016	48	2004-12-21	179
5017	48	2004-12-28	140
5018	48	2004-12-13	61
5019	48	2004-12-23	102
5020	48	2004-12-17	20
5021	49	2005-01-07	77
5022	49	2005-01-08	186
5023	49	2004-12-28	49
5024	49	2005-01-07	12
5025	49	2005-01-03	121
5026	49	2005-01-11	25
5027	49	2005-01-03	100
5028	49	2004-12-30	135
5029	49	2004-12-27	54
5030	49	2005-01-05	49
5031	49	2004-12-31	93
5032	49	2005-01-02	37
5033	49	2004-12-31	54
5034	49	2005-01-04	149
5035	49	2005-01-05	88
5036	49	2005-01-05	16
5037	49	2005-01-11	6
5038	49	2005-01-07	112
5039	49	2005-01-10	100
5040	49	2005-01-12	112
5041	49	2005-01-05	133
5042	49	2004-12-26	54
5043	49	2005-01-14	91
5044	49	2005-01-02	160
5045	49	2005-01-06	189
5046	49	2004-12-30	110
5047	49	2005-01-04	113
5048	49	2004-12-27	24
5049	49	2005-01-06	102
5050	49	2005-01-04	55
5051	49	2004-12-30	20
5052	49	2004-12-28	96
5053	49	2004-12-31	122
5054	49	2005-01-07	71
5055	49	2005-01-08	70
5056	49	2005-01-03	116
5057	49	2004-12-31	62
5058	49	2005-01-01	169
5059	49	2005-01-01	171
5060	49	2005-01-10	17
5061	49	2005-01-11	23
5062	49	2005-01-15	142
5063	49	2005-01-13	115
5064	49	2005-01-02	129
5065	49	2004-12-28	32
5066	49	2005-01-12	120
5067	49	2004-12-26	91
5068	49	2005-01-05	161
5069	49	2005-01-05	93
5070	49	2005-01-07	45
5071	49	2005-01-06	25
5072	49	2005-01-08	157
5073	49	2005-01-04	91
5074	49	2004-12-27	14
5075	49	2005-01-08	3
5076	49	2005-01-02	16
5077	49	2005-01-12	39
5078	49	2004-12-30	195
5079	49	2005-01-08	158
5080	49	2005-01-02	6
5081	49	2005-01-12	129
5082	49	2004-12-27	198
5083	49	2004-12-31	47
5084	49	2005-01-09	68
5085	49	2004-12-28	63
5086	49	2004-12-27	64
5087	49	2004-12-31	62
5088	49	2005-01-09	3
5089	49	2005-01-07	1
5090	49	2005-01-07	23
5091	49	2005-01-07	141
5092	49	2004-12-28	51
5093	49	2004-12-30	90
5094	49	2005-01-12	103
5095	49	2004-12-31	136
5096	49	2005-01-06	91
5097	49	2005-01-10	124
5098	49	2004-12-30	159
5099	49	2005-01-02	100
5100	49	2005-01-01	41
5101	49	2005-01-06	117
5102	49	2005-01-08	181
5103	49	2005-01-08	121
5104	49	2004-12-30	130
5105	49	2005-01-15	190
5106	49	2005-01-15	173
5107	49	2005-01-12	144
5108	49	2004-12-28	159
5109	49	2005-01-10	102
5110	49	2005-01-13	71
5111	49	2005-01-11	160
5112	49	2005-01-03	194
5113	49	2005-01-12	143
5114	49	2005-01-11	12
5115	49	2005-01-11	158
5116	49	2005-01-10	187
5117	49	2004-12-30	13
5118	49	2005-01-11	150
5119	50	2005-01-09	48
5120	50	2005-01-26	145
5121	50	2005-01-11	169
5122	50	2005-01-17	148
5123	50	2005-01-11	140
5124	50	2005-01-23	125
5125	50	2005-01-19	165
5126	50	2005-01-21	92
5127	50	2005-01-12	176
5128	50	2005-01-08	114
5129	50	2005-01-14	106
5130	50	2005-01-13	178
5131	50	2005-01-20	24
5132	50	2005-01-16	82
5133	50	2005-01-13	169
5134	50	2005-01-27	199
5135	50	2005-01-07	80
5136	50	2005-01-13	38
5137	50	2005-01-18	167
5138	50	2005-01-18	141
5139	50	2005-01-27	170
5140	50	2005-01-22	94
5141	50	2005-01-25	32
5142	50	2005-01-09	8
5143	50	2005-01-20	55
5144	50	2005-01-21	125
5145	50	2005-01-25	120
5146	50	2005-01-21	144
5147	50	2005-01-24	63
5148	50	2005-01-09	100
5149	50	2005-01-16	2
5150	50	2005-01-22	67
5151	50	2005-01-23	74
5152	50	2005-01-24	49
5153	50	2005-01-17	7
5154	50	2005-01-23	28
5155	50	2005-01-11	197
5156	50	2005-01-24	156
5157	50	2005-01-15	41
5158	50	2005-01-07	34
5159	50	2005-01-24	3
5160	50	2005-01-22	21
5161	50	2005-01-22	15
5162	50	2005-01-24	169
5163	50	2005-01-07	155
5164	50	2005-01-26	99
5165	50	2005-01-27	155
5166	50	2005-01-26	148
5167	50	2005-01-12	26
5168	50	2005-01-19	187
5169	50	2005-01-24	8
5170	50	2005-01-14	1
5171	50	2005-01-17	139
5172	50	2005-01-22	194
5173	50	2005-01-25	139
5174	50	2005-01-12	122
5175	50	2005-01-12	117
5176	50	2005-01-16	33
5177	50	2005-01-08	199
5178	50	2005-01-11	113
5179	50	2005-01-19	195
5180	50	2005-01-19	82
5181	50	2005-01-07	114
5182	50	2005-01-20	118
5183	50	2005-01-26	152
5184	50	2005-01-24	40
5185	50	2005-01-11	85
5186	50	2005-01-23	73
5187	50	2005-01-11	141
5188	50	2005-01-07	132
5189	50	2005-01-23	170
5190	50	2005-01-08	31
5191	50	2005-01-14	61
5192	50	2005-01-08	8
5193	50	2005-01-07	155
5194	50	2005-01-17	145
5195	50	2005-01-27	0
5196	50	2005-01-17	108
5197	50	2005-01-13	128
5198	50	2005-01-26	80
5199	50	2005-01-18	37
5200	50	2005-01-18	8
5201	50	2005-01-07	41
5202	50	2005-01-18	156
5203	50	2005-01-25	190
5204	50	2005-01-13	156
5205	50	2005-01-16	165
5206	50	2005-01-15	106
5207	50	2005-01-24	188
5208	50	2005-01-22	141
5209	50	2005-01-27	181
5210	50	2005-01-08	192
5211	50	2005-01-27	62
5212	50	2005-01-07	183
5213	50	2005-01-14	40
5214	50	2005-01-22	73
5215	50	2005-01-14	159
5216	50	2005-01-23	117
5217	50	2005-01-25	153
5218	50	2005-01-26	73
5219	50	2005-01-22	127
5220	50	2005-01-14	102
5221	50	2005-01-26	182
5222	50	2005-01-21	183
5223	50	2005-01-16	19
5224	50	2005-01-14	9
5225	50	2005-01-08	16
5226	50	2005-01-18	113
5227	50	2005-01-27	35
5228	50	2005-01-16	131
5229	50	2005-01-16	97
5230	50	2005-01-24	123
5231	50	2005-01-19	0
5232	50	2005-01-10	1
5233	50	2005-01-26	98
5234	50	2005-01-21	156
5235	50	2005-01-13	134
5236	50	2005-01-15	88
5237	51	2005-02-02	100
5238	51	2005-01-26	159
5239	51	2005-01-29	125
5240	51	2005-02-07	20
5241	51	2005-01-26	42
5242	51	2005-01-27	148
5243	51	2005-02-03	113
5244	51	2005-01-26	127
5245	51	2005-01-22	176
5246	51	2005-02-06	67
5247	51	2005-01-29	119
5248	51	2005-02-02	129
5249	51	2005-01-22	161
5250	51	2005-02-09	141
5251	51	2005-02-05	30
5252	51	2005-01-29	59
5253	51	2005-02-03	161
5254	51	2005-02-10	180
5255	51	2005-01-25	125
5256	51	2005-02-11	176
5257	51	2005-02-07	153
5258	51	2005-02-06	97
5259	51	2005-02-07	13
5260	51	2005-01-23	85
5261	51	2005-01-28	74
5262	51	2005-02-02	15
5263	51	2005-02-09	154
5264	51	2005-02-06	174
5265	51	2005-02-10	35
5266	51	2005-01-29	130
5267	51	2005-01-30	56
5268	51	2005-02-10	168
5269	51	2005-01-25	65
5270	51	2005-01-23	108
5271	51	2005-01-30	101
5272	51	2005-02-09	145
5273	51	2005-01-29	176
5274	51	2005-01-26	194
5275	51	2005-01-29	134
5276	51	2005-01-30	75
5277	51	2005-02-02	166
5278	51	2005-02-10	105
5279	51	2005-01-26	163
5280	51	2005-02-09	168
5281	51	2005-02-02	188
5282	51	2005-01-28	5
5283	51	2005-02-01	90
5284	51	2005-01-28	107
5285	51	2005-02-05	113
5286	51	2005-01-28	161
5287	51	2005-01-28	169
5288	51	2005-01-31	189
5289	51	2005-02-06	21
5290	51	2005-01-22	54
5291	51	2005-01-24	85
5292	51	2005-01-27	196
5293	51	2005-02-06	159
5294	51	2005-01-29	183
5295	51	2005-01-29	35
5296	51	2005-02-06	22
5297	51	2005-01-30	96
5298	51	2005-02-09	102
5299	51	2005-02-06	49
5300	51	2005-02-04	3
5301	51	2005-02-08	171
5302	51	2005-01-30	104
5303	51	2005-02-05	29
5304	51	2005-02-06	45
5305	51	2005-02-02	123
5306	51	2005-02-07	62
5307	51	2005-01-28	75
5308	51	2005-02-07	146
5309	51	2005-01-31	161
5310	51	2005-01-24	174
5311	51	2005-02-05	152
5312	51	2005-02-07	136
5313	51	2005-01-29	118
5314	51	2005-01-23	80
5315	51	2005-01-28	27
5316	51	2005-02-05	84
5317	51	2005-01-25	195
5318	51	2005-02-09	150
5319	51	2005-02-06	160
5320	51	2005-01-22	41
5321	51	2005-02-06	27
5322	51	2005-02-07	50
5323	51	2005-02-04	118
5324	51	2005-01-30	197
5325	51	2005-02-03	104
5326	51	2005-01-27	84
5327	51	2005-02-10	182
5328	51	2005-02-06	173
5329	51	2005-01-28	78
5330	51	2005-01-24	162
5331	51	2005-01-25	13
5332	51	2005-02-06	118
5333	51	2005-01-22	18
5334	51	2005-01-29	24
5335	51	2005-01-22	7
5336	51	2005-02-01	192
5337	51	2005-01-31	84
5338	51	2005-02-07	34
5339	51	2005-01-25	55
5340	51	2005-02-04	113
5341	51	2005-02-03	89
5342	52	2005-02-23	62
5343	52	2005-02-11	130
5344	52	2005-02-24	45
5345	52	2005-02-18	128
5346	52	2005-02-12	66
5347	52	2005-02-05	95
5348	52	2005-02-16	159
5349	52	2005-02-22	106
5350	52	2005-02-08	183
5351	52	2005-02-11	42
5352	52	2005-02-08	66
5353	52	2005-02-21	44
5354	52	2005-02-07	196
5355	52	2005-02-16	145
5356	52	2005-02-05	167
5357	52	2005-02-12	76
5358	52	2005-02-20	106
5359	52	2005-02-14	50
5360	52	2005-02-14	192
5361	52	2005-02-22	89
5362	52	2005-02-15	59
5363	52	2005-02-17	189
5364	52	2005-02-11	55
5365	52	2005-02-08	157
5366	52	2005-02-08	96
5367	52	2005-02-10	107
5368	52	2005-02-13	14
5369	52	2005-02-17	157
5370	52	2005-02-07	87
5371	52	2005-02-17	40
5372	52	2005-02-24	33
5373	52	2005-02-16	192
5374	52	2005-02-08	127
5375	52	2005-02-12	101
5376	52	2005-02-12	61
5377	52	2005-02-07	190
5378	52	2005-02-11	171
5379	52	2005-02-12	76
5380	52	2005-02-21	125
5381	52	2005-02-20	8
5382	52	2005-02-21	109
5383	52	2005-02-13	90
5384	52	2005-02-20	31
5385	52	2005-02-21	173
5386	52	2005-02-20	163
5387	52	2005-02-09	124
5388	52	2005-02-18	58
5389	52	2005-02-09	3
5390	52	2005-02-15	105
5391	52	2005-02-09	125
5392	52	2005-02-19	175
5393	52	2005-02-07	104
5394	52	2005-02-07	153
5395	52	2005-02-09	115
5396	52	2005-02-16	123
5397	52	2005-02-06	13
5398	52	2005-02-06	1
5399	52	2005-02-17	151
5400	52	2005-02-22	109
5401	52	2005-02-07	33
5402	52	2005-02-21	77
5403	52	2005-02-05	59
5404	52	2005-02-12	198
5405	52	2005-02-11	42
5406	52	2005-02-20	153
5407	52	2005-02-18	108
5408	52	2005-02-25	43
5409	52	2005-02-12	174
5410	52	2005-02-16	4
5411	52	2005-02-17	107
5412	52	2005-02-14	150
5413	52	2005-02-14	93
5414	52	2005-02-15	67
5415	52	2005-02-12	176
5416	52	2005-02-16	59
5417	52	2005-02-12	159
5418	52	2005-02-05	123
5419	52	2005-02-23	191
5420	52	2005-02-14	44
5421	52	2005-02-21	45
5422	52	2005-02-10	102
5423	52	2005-02-08	99
5424	52	2005-02-14	0
5425	52	2005-02-12	171
5426	52	2005-02-10	67
5427	52	2005-02-25	72
5428	52	2005-02-07	74
5429	52	2005-02-23	128
5430	52	2005-02-17	133
5431	52	2005-02-21	13
5432	52	2005-02-10	46
5433	52	2005-02-24	72
5434	52	2005-02-17	177
5435	52	2005-02-20	116
5436	52	2005-02-11	175
5437	52	2005-02-10	146
5438	52	2005-02-07	174
5439	52	2005-02-12	10
5440	52	2005-02-11	184
5441	52	2005-02-23	122
5442	52	2005-02-05	91
5443	52	2005-02-19	135
5444	52	2005-02-21	159
5445	52	2005-02-19	127
5446	52	2005-02-10	197
5447	52	2005-02-06	127
5448	52	2005-02-14	20
5449	52	2005-02-15	48
5450	52	2005-02-24	13
5451	52	2005-02-08	152
5452	52	2005-02-19	153
5453	52	2005-02-20	85
5454	53	2005-03-07	33
5455	53	2005-03-12	75
5456	53	2005-02-28	4
5457	53	2005-02-23	3
5458	53	2005-03-03	135
5459	53	2005-03-11	20
5460	53	2005-03-04	144
5461	53	2005-03-02	185
5462	53	2005-03-08	37
5463	53	2005-03-05	4
5464	53	2005-02-20	94
5465	53	2005-03-04	1
5466	53	2005-02-21	9
5467	53	2005-02-24	136
5468	53	2005-02-24	20
5469	53	2005-02-23	79
5470	53	2005-02-28	79
5471	53	2005-02-23	170
5472	53	2005-03-06	93
5473	53	2005-03-09	67
5474	53	2005-03-12	35
5475	53	2005-03-08	185
5476	53	2005-03-08	6
5477	53	2005-03-09	73
5478	53	2005-03-12	145
5479	53	2005-02-23	158
5480	53	2005-03-06	109
5481	53	2005-03-12	3
5482	53	2005-03-03	60
5483	53	2005-03-03	78
5484	53	2005-02-20	75
5485	53	2005-03-04	132
5486	53	2005-03-03	39
5487	53	2005-02-20	113
5488	53	2005-03-02	77
5489	53	2005-03-03	31
5490	53	2005-03-03	32
5491	53	2005-02-24	107
5492	53	2005-03-05	130
5493	53	2005-02-28	52
5494	53	2005-03-03	77
5495	53	2005-03-06	104
5496	53	2005-03-01	104
5497	53	2005-02-20	5
5498	53	2005-03-01	135
5499	53	2005-03-10	85
5500	53	2005-02-25	127
5501	53	2005-03-10	90
5502	53	2005-03-10	15
5503	53	2005-02-27	53
5504	53	2005-03-10	83
5505	53	2005-03-09	120
5506	53	2005-03-03	173
5507	53	2005-03-07	10
5508	53	2005-02-26	41
5509	53	2005-02-22	31
5510	53	2005-03-09	176
5511	53	2005-03-08	107
5512	53	2005-02-22	83
5513	53	2005-02-24	158
5514	53	2005-02-22	64
5515	53	2005-02-28	46
5516	53	2005-02-27	150
5517	53	2005-02-26	109
5518	53	2005-02-27	160
5519	53	2005-02-22	113
5520	53	2005-03-01	43
5521	53	2005-02-21	197
5522	53	2005-02-28	6
5523	53	2005-03-02	25
5524	53	2005-03-01	6
5525	53	2005-02-22	149
5526	53	2005-02-27	146
5527	53	2005-02-22	54
5528	53	2005-03-10	160
5529	53	2005-03-11	70
5530	53	2005-03-07	1
5531	53	2005-02-23	59
5532	53	2005-02-20	185
5533	53	2005-02-27	90
5534	53	2005-02-20	46
5535	53	2005-03-04	52
5536	53	2005-02-25	82
5537	53	2005-02-25	59
5538	53	2005-03-01	21
5539	53	2005-02-26	157
5540	53	2005-03-01	22
5541	53	2005-02-22	120
5542	53	2005-02-21	18
5543	53	2005-03-03	125
5544	53	2005-02-26	33
5545	53	2005-03-01	21
5546	53	2005-02-23	77
5547	53	2005-03-07	148
5548	53	2005-02-27	165
5549	53	2005-02-26	167
5550	53	2005-02-25	7
5551	53	2005-02-21	22
5552	53	2005-03-05	56
5553	53	2005-02-26	184
5554	53	2005-02-23	172
5555	53	2005-02-28	180
5556	53	2005-02-20	79
5557	53	2005-02-22	97
5558	53	2005-03-09	103
5559	53	2005-02-27	140
5560	53	2005-03-01	87
5561	54	2005-03-18	1
5562	54	2005-03-18	115
5563	54	2005-03-21	145
5564	54	2005-03-26	50
5565	54	2005-03-20	158
5566	54	2005-03-22	178
5567	54	2005-03-06	167
5568	54	2005-03-16	20
5569	54	2005-03-07	131
5570	54	2005-03-09	174
5571	54	2005-03-14	136
5572	54	2005-03-10	84
5573	54	2005-03-13	110
5574	54	2005-03-26	187
5575	54	2005-03-22	37
5576	54	2005-03-17	98
5577	54	2005-03-11	145
5578	54	2005-03-10	32
5579	54	2005-03-20	100
5580	54	2005-03-15	87
5581	54	2005-03-19	14
5582	54	2005-03-16	108
5583	54	2005-03-11	30
5584	54	2005-03-22	79
5585	54	2005-03-23	62
5586	54	2005-03-21	99
5587	54	2005-03-17	122
5588	54	2005-03-24	141
5589	54	2005-03-10	95
5590	54	2005-03-21	92
5591	54	2005-03-12	176
5592	54	2005-03-08	194
5593	54	2005-03-10	92
5594	54	2005-03-18	76
5595	54	2005-03-20	110
5596	54	2005-03-12	6
5597	54	2005-03-23	177
5598	54	2005-03-19	66
5599	54	2005-03-24	74
5600	54	2005-03-20	138
5601	54	2005-03-20	81
5602	54	2005-03-13	142
5603	54	2005-03-18	25
5604	54	2005-03-10	76
5605	54	2005-03-06	138
5606	54	2005-03-19	19
5607	54	2005-03-06	187
5608	54	2005-03-23	12
5609	54	2005-03-25	132
5610	54	2005-03-18	183
5611	54	2005-03-23	159
5612	54	2005-03-07	57
5613	54	2005-03-26	140
5614	54	2005-03-13	11
5615	54	2005-03-26	176
5616	54	2005-03-21	66
5617	54	2005-03-18	64
5618	54	2005-03-07	59
5619	54	2005-03-24	11
5620	54	2005-03-20	123
5621	54	2005-03-07	25
5622	54	2005-03-11	4
5623	54	2005-03-11	72
5624	54	2005-03-06	187
5625	54	2005-03-24	193
5626	54	2005-03-26	96
5627	54	2005-03-18	128
5628	54	2005-03-07	53
5629	54	2005-03-12	129
5630	54	2005-03-16	159
5631	54	2005-03-15	22
5632	54	2005-03-08	49
5633	54	2005-03-07	24
5634	54	2005-03-07	190
5635	54	2005-03-24	130
5636	54	2005-03-10	116
5637	54	2005-03-15	189
5638	54	2005-03-24	33
5639	54	2005-03-08	140
5640	54	2005-03-17	5
5641	54	2005-03-12	154
5642	54	2005-03-10	41
5643	54	2005-03-26	163
5644	54	2005-03-09	82
5645	54	2005-03-23	155
5646	54	2005-03-16	71
5647	54	2005-03-13	181
5648	54	2005-03-26	0
5649	54	2005-03-16	153
5650	54	2005-03-18	167
5651	54	2005-03-19	86
5652	54	2005-03-07	175
5653	54	2005-03-20	49
5654	54	2005-03-25	91
5655	54	2005-03-06	166
5656	54	2005-03-10	39
5657	54	2005-03-17	197
5658	54	2005-03-07	101
5659	54	2005-03-19	123
5660	54	2005-03-06	194
5661	54	2005-03-09	71
5662	54	2005-03-24	20
5663	54	2005-03-24	141
5664	54	2005-03-09	36
5665	54	2005-03-24	122
5666	54	2005-03-14	160
5667	54	2005-03-17	6
5668	54	2005-03-17	177
5669	54	2005-03-12	45
5670	54	2005-03-12	153
5671	54	2005-03-13	98
5672	54	2005-03-21	174
5673	54	2005-03-21	181
5674	55	2005-04-09	25
5675	55	2005-04-04	59
5676	55	2005-04-03	170
5677	55	2005-03-25	187
5678	55	2005-04-03	115
5679	55	2005-03-28	88
5680	55	2005-04-08	12
5681	55	2005-04-11	13
5682	55	2005-04-12	148
5683	55	2005-03-25	149
5684	55	2005-03-26	63
5685	55	2005-03-30	119
5686	55	2005-04-11	56
5687	55	2005-03-26	12
5688	55	2005-03-31	108
5689	55	2005-04-06	136
5690	55	2005-03-31	24
5691	55	2005-04-04	104
5692	55	2005-04-06	78
5693	55	2005-04-05	12
5694	55	2005-04-01	101
5695	55	2005-04-08	66
5696	55	2005-04-08	26
5697	55	2005-04-09	30
5698	55	2005-04-12	15
5699	55	2005-03-30	7
5700	55	2005-04-01	19
5701	55	2005-04-02	39
5702	55	2005-04-07	66
5703	55	2005-04-14	76
5704	55	2005-04-13	64
5705	55	2005-04-12	58
5706	55	2005-04-05	46
5707	55	2005-03-26	77
5708	55	2005-03-27	179
5709	55	2005-03-28	90
5710	55	2005-03-26	194
5711	55	2005-04-13	104
5712	55	2005-04-03	186
5713	55	2005-03-25	175
5714	55	2005-04-07	32
5715	55	2005-04-05	157
5716	55	2005-04-12	109
5717	55	2005-04-02	72
5718	55	2005-04-02	98
5719	55	2005-04-13	171
5720	55	2005-03-28	110
5721	55	2005-04-08	53
5722	55	2005-04-11	29
5723	55	2005-04-02	173
5724	55	2005-03-28	35
5725	55	2005-04-01	82
5726	55	2005-04-03	21
5727	55	2005-04-13	53
5728	55	2005-03-27	149
5729	55	2005-04-07	122
5730	55	2005-03-30	54
5731	55	2005-03-27	163
5732	55	2005-04-08	125
5733	55	2005-04-01	174
5734	55	2005-04-10	148
5735	55	2005-03-29	54
5736	55	2005-04-13	7
5737	55	2005-04-12	123
5738	55	2005-04-06	179
5739	55	2005-03-28	176
5740	55	2005-04-02	49
5741	55	2005-04-03	18
5742	55	2005-04-04	172
5743	55	2005-03-28	72
5744	55	2005-03-26	159
5745	55	2005-03-31	120
5746	55	2005-04-11	194
5747	55	2005-04-04	105
5748	55	2005-03-27	47
5749	55	2005-03-26	14
5750	55	2005-03-27	143
5751	55	2005-03-28	90
5752	55	2005-04-01	103
5753	55	2005-04-06	112
5754	55	2005-03-29	95
5755	55	2005-04-07	178
5756	55	2005-04-12	132
5757	55	2005-03-30	26
5758	55	2005-03-29	126
5759	55	2005-04-06	133
5760	55	2005-03-29	6
5761	55	2005-03-31	10
5762	55	2005-03-31	143
5763	55	2005-04-10	116
5764	55	2005-04-11	164
5765	55	2005-04-04	24
5766	55	2005-03-28	84
5767	55	2005-03-30	8
5768	55	2005-04-12	14
5769	55	2005-03-25	182
5770	55	2005-03-25	171
5771	55	2005-04-11	135
5772	55	2005-03-26	52
5773	56	2005-04-29	153
5774	56	2005-04-30	195
5775	56	2005-04-11	92
5776	56	2005-04-25	199
5777	56	2005-04-12	0
5778	56	2005-04-21	154
5779	56	2005-04-29	2
5780	56	2005-04-23	95
5781	56	2005-04-30	151
5782	56	2005-04-29	168
5783	56	2005-04-14	42
5784	56	2005-04-29	170
5785	56	2005-04-17	185
5786	56	2005-04-15	7
5787	56	2005-04-12	19
5788	56	2005-04-25	159
5789	56	2005-05-01	180
5790	56	2005-04-17	126
5791	56	2005-04-26	104
5792	56	2005-04-19	193
5793	56	2005-04-12	71
5794	56	2005-04-28	21
5795	56	2005-04-13	42
5796	56	2005-04-25	139
5797	56	2005-04-21	43
5798	56	2005-04-16	64
5799	56	2005-04-29	135
5800	56	2005-04-12	190
5801	56	2005-04-25	51
5802	56	2005-04-18	112
5803	56	2005-04-26	153
5804	56	2005-04-12	11
5805	56	2005-04-13	35
5806	56	2005-04-30	46
5807	56	2005-04-25	9
5808	56	2005-04-11	158
5809	56	2005-05-01	84
5810	56	2005-04-21	30
5811	56	2005-04-12	18
5812	56	2005-04-25	102
5813	56	2005-04-18	99
5814	56	2005-04-23	1
5815	56	2005-04-23	103
5816	56	2005-04-30	44
5817	56	2005-04-18	169
5818	56	2005-04-20	72
5819	56	2005-04-28	132
5820	56	2005-04-12	127
5821	56	2005-04-22	42
5822	56	2005-04-14	84
5823	56	2005-04-20	132
5824	56	2005-04-14	198
5825	56	2005-05-01	65
5826	56	2005-04-22	195
5827	56	2005-04-23	199
5828	56	2005-04-25	123
5829	56	2005-04-28	118
5830	56	2005-04-25	58
5831	56	2005-04-26	2
5832	56	2005-04-19	165
5833	56	2005-04-13	130
5834	56	2005-04-11	26
5835	56	2005-04-26	36
5836	56	2005-04-26	75
5837	56	2005-04-18	159
5838	56	2005-04-21	150
5839	56	2005-04-22	23
5840	56	2005-04-19	105
5841	56	2005-04-24	119
5842	56	2005-04-15	6
5843	56	2005-04-23	66
5844	56	2005-04-15	79
5845	56	2005-04-20	129
5846	56	2005-04-14	89
5847	56	2005-04-21	5
5848	56	2005-04-20	80
5849	56	2005-04-12	2
5850	56	2005-04-25	185
5851	56	2005-04-20	144
5852	56	2005-04-28	113
5853	56	2005-04-30	1
5854	56	2005-04-30	67
5855	56	2005-04-15	195
5856	56	2005-04-19	148
5857	56	2005-05-01	163
5858	56	2005-04-19	6
5859	56	2005-04-14	97
5860	57	2005-05-15	59
5861	57	2005-05-15	120
5862	57	2005-05-13	138
5863	57	2005-04-27	113
5864	57	2005-05-09	61
5865	57	2005-04-30	143
5866	57	2005-05-07	79
5867	57	2005-05-07	135
5868	57	2005-05-06	67
5869	57	2005-05-13	79
5870	57	2005-05-09	179
5871	57	2005-05-13	21
5872	57	2005-05-13	162
5873	57	2005-05-03	143
5874	57	2005-05-09	137
5875	57	2005-04-25	181
5876	57	2005-04-30	138
5877	57	2005-05-13	103
5878	57	2005-04-29	74
5879	57	2005-04-30	6
5880	57	2005-05-04	34
5881	57	2005-05-08	157
5882	57	2005-04-27	47
5883	57	2005-04-25	99
5884	57	2005-04-30	141
5885	57	2005-05-10	182
5886	57	2005-05-04	127
5887	57	2005-04-29	2
5888	57	2005-05-06	161
5889	57	2005-05-10	133
5890	57	2005-05-12	197
5891	57	2005-05-12	151
5892	57	2005-04-30	127
5893	57	2005-05-13	32
5894	57	2005-05-04	126
5895	57	2005-05-13	28
5896	57	2005-05-05	66
5897	57	2005-05-15	52
5898	57	2005-05-07	136
5899	57	2005-04-28	87
5900	57	2005-05-11	28
5901	57	2005-05-04	97
5902	57	2005-05-10	145
5903	57	2005-05-14	32
5904	57	2005-05-08	196
5905	57	2005-05-15	98
5906	57	2005-05-09	129
5907	57	2005-05-06	150
5908	57	2005-05-01	181
5909	57	2005-04-27	9
5910	57	2005-04-28	39
5911	57	2005-05-05	11
5912	57	2005-05-05	194
5913	57	2005-04-25	30
5914	57	2005-05-09	7
5915	57	2005-05-10	184
5916	57	2005-04-25	129
5917	57	2005-05-12	160
5918	57	2005-05-01	92
5919	57	2005-04-25	58
5920	57	2005-04-25	65
5921	57	2005-04-30	163
5922	57	2005-04-25	166
5923	57	2005-05-12	84
5924	57	2005-05-09	137
5925	57	2005-04-25	97
5926	57	2005-05-14	107
5927	57	2005-05-09	107
5928	57	2005-05-09	199
5929	57	2005-05-03	67
5930	57	2005-04-28	172
5931	57	2005-05-03	119
5932	57	2005-05-14	167
5933	57	2005-05-01	43
5934	57	2005-05-15	14
5935	57	2005-05-14	178
5936	57	2005-04-30	118
5937	57	2005-05-12	30
5938	57	2005-05-13	96
5939	57	2005-05-12	165
5940	57	2005-04-27	138
5941	57	2005-05-04	143
5942	57	2005-05-01	197
5943	57	2005-04-28	189
5944	57	2005-05-13	199
5945	57	2005-04-29	68
5946	57	2005-05-10	36
5947	57	2005-04-30	28
5948	57	2005-04-26	69
5949	57	2005-05-14	158
5950	57	2005-05-05	61
5951	57	2005-05-02	98
5952	57	2005-05-02	128
5953	57	2005-05-10	129
5954	57	2005-05-11	11
5955	57	2005-05-05	194
5956	57	2005-05-04	60
5957	57	2005-05-15	15
5958	57	2005-04-29	179
5959	57	2005-05-14	113
5960	57	2005-04-27	58
5961	57	2005-05-05	57
5962	57	2005-05-11	29
5963	57	2005-05-10	178
5964	57	2005-04-27	100
5965	57	2005-05-11	141
5966	57	2005-05-06	184
5967	57	2005-05-14	62
5968	57	2005-05-05	75
5969	58	2005-05-12	97
5970	58	2005-05-26	7
5971	58	2005-05-12	150
5972	58	2005-05-18	185
5973	58	2005-05-27	17
5974	58	2005-05-12	184
5975	58	2005-05-25	139
5976	58	2005-05-11	62
5977	58	2005-05-15	99
5978	58	2005-05-25	186
5979	58	2005-05-18	161
5980	58	2005-05-12	49
5981	58	2005-05-21	77
5982	58	2005-05-19	156
5983	58	2005-05-13	138
5984	58	2005-05-20	170
5985	58	2005-05-11	98
5986	58	2005-05-11	142
5987	58	2005-05-21	114
5988	58	2005-05-11	85
5989	58	2005-05-17	188
5990	58	2005-05-30	43
5991	58	2005-05-14	57
5992	58	2005-05-16	157
5993	58	2005-05-25	80
5994	58	2005-05-26	173
5995	58	2005-05-25	23
5996	58	2005-05-11	86
5997	58	2005-05-21	97
5998	58	2005-05-20	30
5999	58	2005-05-23	190
6000	58	2005-05-17	30
6001	58	2005-05-31	174
6002	58	2005-05-18	35
6003	58	2005-05-14	51
6004	58	2005-05-20	85
6005	58	2005-05-12	13
6006	58	2005-05-19	150
6007	58	2005-05-20	32
6008	58	2005-05-16	199
6009	58	2005-05-15	53
6010	58	2005-05-28	127
6011	58	2005-05-29	125
6012	58	2005-05-18	109
6013	58	2005-05-15	7
6014	58	2005-05-13	106
6015	58	2005-05-21	179
6016	58	2005-05-16	20
6017	58	2005-05-20	5
6018	58	2005-05-15	156
6019	58	2005-05-14	20
6020	58	2005-05-24	50
6021	58	2005-05-26	45
6022	58	2005-05-29	148
6023	58	2005-05-20	149
6024	58	2005-05-30	99
6025	58	2005-05-30	47
6026	58	2005-05-12	183
6027	58	2005-05-27	145
6028	58	2005-05-17	23
6029	58	2005-05-31	67
6030	58	2005-05-28	144
6031	58	2005-05-25	96
6032	58	2005-05-12	153
6033	58	2005-05-29	111
6034	58	2005-05-16	39
6035	58	2005-05-24	59
6036	58	2005-05-13	135
6037	58	2005-05-11	172
6038	58	2005-05-27	116
6039	58	2005-05-11	69
6040	58	2005-05-11	51
6041	58	2005-05-12	53
6042	58	2005-05-11	53
6043	58	2005-05-30	159
6044	58	2005-05-18	118
6045	58	2005-05-20	69
6046	58	2005-05-17	154
6047	58	2005-05-31	143
6048	58	2005-05-30	170
6049	58	2005-05-31	198
6050	58	2005-05-17	183
6051	58	2005-05-28	184
6052	58	2005-05-29	126
6053	58	2005-05-27	41
6054	58	2005-05-24	167
6055	58	2005-05-15	173
6056	58	2005-05-21	65
6057	58	2005-05-27	155
6058	58	2005-05-28	100
6059	58	2005-05-16	45
6060	58	2005-05-31	152
6061	58	2005-05-13	110
6062	58	2005-05-26	130
6063	58	2005-05-20	146
6064	59	2005-06-08	167
6065	59	2005-06-09	124
6066	59	2005-06-07	26
6067	59	2005-06-02	142
6068	59	2005-06-05	107
6069	59	2005-06-17	182
6070	59	2005-06-09	0
6071	59	2005-06-03	7
6072	59	2005-06-17	166
6073	59	2005-06-05	101
6074	59	2005-06-06	152
6075	59	2005-06-06	104
6076	59	2005-06-20	199
6077	59	2005-06-09	179
6078	59	2005-06-04	60
6079	59	2005-05-31	11
6080	59	2005-06-10	75
6081	59	2005-06-12	104
6082	59	2005-05-31	57
6083	59	2005-06-05	172
6084	59	2005-06-07	93
6085	59	2005-06-03	132
6086	59	2005-06-06	31
6087	59	2005-06-17	159
6088	59	2005-06-20	115
6089	59	2005-06-19	56
6090	59	2005-06-18	77
6091	59	2005-06-11	50
6092	59	2005-06-13	107
6093	59	2005-06-15	82
6094	59	2005-06-05	173
6095	59	2005-06-05	188
6096	59	2005-06-07	75
6097	59	2005-06-11	72
6098	59	2005-06-10	63
6099	59	2005-06-03	195
6100	59	2005-06-03	44
6101	59	2005-06-05	99
6102	59	2005-06-02	68
6103	59	2005-06-05	65
6104	59	2005-06-15	82
6105	59	2005-06-11	141
6106	59	2005-06-19	188
6107	59	2005-06-09	88
6108	59	2005-06-16	163
6109	59	2005-06-09	68
6110	59	2005-06-12	58
6111	59	2005-06-15	28
6112	59	2005-06-20	67
6113	59	2005-06-09	171
6114	59	2005-06-01	11
6115	59	2005-06-06	54
6116	59	2005-06-17	36
6117	59	2005-06-11	11
6118	59	2005-06-19	185
6119	59	2005-06-18	18
6120	59	2005-06-11	129
6121	59	2005-06-11	86
6122	59	2005-06-02	99
6123	59	2005-06-16	53
6124	59	2005-06-08	197
6125	59	2005-06-06	79
6126	59	2005-06-19	170
6127	59	2005-06-04	57
6128	59	2005-06-15	182
6129	59	2005-06-06	109
6130	59	2005-06-09	4
6131	59	2005-06-19	146
6132	59	2005-05-31	12
6133	59	2005-06-06	32
6134	59	2005-06-04	127
6135	59	2005-06-18	32
6136	59	2005-05-31	146
6137	59	2005-06-10	130
6138	59	2005-06-08	92
6139	59	2005-06-17	189
6140	59	2005-06-13	84
6141	59	2005-05-31	160
6142	59	2005-06-11	67
6143	59	2005-06-15	28
6144	59	2005-06-08	96
6145	59	2005-06-09	191
6146	59	2005-06-02	20
6147	59	2005-06-06	122
6148	59	2005-06-16	38
6149	59	2005-06-11	181
6150	59	2005-06-12	156
6151	59	2005-06-06	98
6152	59	2005-06-03	105
6153	59	2005-06-04	38
6154	59	2005-06-09	47
6155	59	2005-06-18	137
6156	59	2005-06-12	135
6157	59	2005-06-12	172
6158	59	2005-06-14	59
6159	59	2005-06-09	41
6160	59	2005-06-13	150
6161	59	2005-06-15	128
6162	59	2005-06-20	198
6163	59	2005-06-11	49
6164	59	2005-06-16	133
6165	59	2005-06-14	194
6166	59	2005-06-09	47
6167	59	2005-06-17	98
6168	59	2005-06-11	51
6169	59	2005-06-02	149
6170	59	2005-06-03	185
6171	59	2005-06-02	193
6172	59	2005-06-11	137
6173	59	2005-06-12	120
6174	59	2005-05-31	123
6175	59	2005-06-08	9
6176	59	2005-06-08	52
6177	60	2005-06-12	190
6178	60	2005-07-01	19
6179	60	2005-06-27	56
6180	60	2005-06-20	15
6181	60	2005-06-15	82
6182	60	2005-06-21	181
6183	60	2005-06-26	177
6184	60	2005-06-11	60
6185	60	2005-06-24	21
6186	60	2005-06-13	103
6187	60	2005-07-01	139
6188	60	2005-06-23	173
6189	60	2005-06-15	0
6190	60	2005-06-23	156
6191	60	2005-06-23	172
6192	60	2005-06-11	35
6193	60	2005-06-20	5
6194	60	2005-06-29	37
6195	60	2005-06-13	159
6196	60	2005-06-18	134
6197	60	2005-06-30	193
6198	60	2005-06-25	79
6199	60	2005-06-27	184
6200	60	2005-06-13	184
6201	60	2005-06-15	81
6202	60	2005-06-24	153
6203	60	2005-06-27	163
6204	60	2005-06-28	11
6205	60	2005-06-26	65
6206	60	2005-06-12	20
6207	60	2005-06-15	15
6208	60	2005-06-28	194
6209	60	2005-06-18	187
6210	60	2005-06-15	101
6211	60	2005-06-24	163
6212	60	2005-06-21	127
6213	60	2005-06-20	82
6214	60	2005-06-25	48
6215	60	2005-06-22	41
6216	60	2005-06-13	145
6217	60	2005-06-19	39
6218	60	2005-06-14	21
6219	60	2005-06-14	188
6220	60	2005-06-27	152
6221	60	2005-06-26	189
6222	60	2005-06-30	34
6223	60	2005-06-20	40
6224	60	2005-06-30	161
6225	60	2005-06-23	177
6226	60	2005-06-21	104
6227	60	2005-06-11	40
6228	60	2005-06-28	62
6229	60	2005-06-15	29
6230	60	2005-06-27	26
6231	60	2005-06-19	157
6232	60	2005-06-16	142
6233	60	2005-06-18	6
6234	60	2005-06-19	72
6235	60	2005-06-23	86
6236	60	2005-07-01	42
6237	60	2005-06-29	178
6238	60	2005-06-27	21
6239	60	2005-06-25	0
6240	60	2005-06-15	89
6241	60	2005-06-14	108
6242	60	2005-06-14	30
6243	60	2005-06-24	15
6244	60	2005-06-12	146
6245	60	2005-06-17	142
6246	60	2005-06-22	34
6247	60	2005-06-23	164
6248	60	2005-06-20	37
6249	60	2005-06-24	151
6250	60	2005-06-27	121
6251	60	2005-06-30	75
6252	60	2005-06-13	22
6253	60	2005-06-21	113
6254	60	2005-06-25	100
6255	60	2005-06-24	63
6256	60	2005-06-16	130
6257	60	2005-06-11	199
6258	60	2005-06-15	157
6259	60	2005-06-27	142
6260	60	2005-06-21	157
6261	60	2005-06-12	11
6262	60	2005-06-27	59
6263	61	2005-07-07	155
6264	61	2005-07-08	94
6265	61	2005-07-08	161
6266	61	2005-07-14	67
6267	61	2005-07-09	150
6268	61	2005-07-05	156
6269	61	2005-06-29	133
6270	61	2005-07-10	77
6271	61	2005-07-06	198
6272	61	2005-06-29	156
6273	61	2005-07-04	84
6274	61	2005-07-13	111
6275	61	2005-07-03	179
6276	61	2005-07-09	75
6277	61	2005-07-07	154
6278	61	2005-07-09	52
6279	61	2005-06-29	74
6280	61	2005-07-02	105
6281	61	2005-06-28	191
6282	61	2005-07-15	59
6283	61	2005-07-15	57
6284	61	2005-06-30	171
6285	61	2005-07-12	33
6286	61	2005-07-15	18
6287	61	2005-07-10	164
6288	61	2005-06-27	109
6289	61	2005-07-09	199
6290	61	2005-07-09	118
6291	61	2005-07-14	61
6292	61	2005-07-05	139
6293	61	2005-07-12	198
6294	61	2005-07-15	54
6295	61	2005-07-09	105
6296	61	2005-07-01	173
6297	61	2005-06-28	193
6298	61	2005-07-16	161
6299	61	2005-06-27	18
6300	61	2005-07-04	33
6301	61	2005-07-02	107
6302	61	2005-06-29	0
6303	61	2005-07-15	144
6304	61	2005-07-01	157
6305	61	2005-07-13	31
6306	61	2005-07-07	153
6307	61	2005-06-30	96
6308	61	2005-07-10	9
6309	61	2005-07-13	116
6310	61	2005-07-03	34
6311	61	2005-06-28	170
6312	61	2005-06-26	79
6313	61	2005-06-29	161
6314	61	2005-07-13	47
6315	61	2005-07-08	169
6316	61	2005-07-05	153
6317	61	2005-07-02	8
6318	61	2005-07-15	44
6319	61	2005-07-15	182
6320	61	2005-07-05	123
6321	61	2005-07-14	134
6322	61	2005-07-13	176
6323	61	2005-07-02	14
6324	61	2005-07-06	28
6325	61	2005-07-01	80
6326	61	2005-07-13	130
6327	61	2005-07-10	72
6328	61	2005-07-07	18
6329	61	2005-07-07	155
6330	61	2005-06-26	146
6331	61	2005-07-09	103
6332	61	2005-07-10	50
6333	61	2005-07-02	192
6334	61	2005-06-30	74
6335	61	2005-07-11	61
6336	61	2005-06-26	156
6337	61	2005-07-05	107
6338	61	2005-07-10	160
6339	61	2005-07-10	5
6340	61	2005-07-06	146
6341	61	2005-07-04	94
6342	61	2005-07-10	184
6343	61	2005-07-13	145
6344	61	2005-06-26	125
6345	61	2005-07-06	190
6346	61	2005-07-13	117
6347	61	2005-07-01	153
6348	61	2005-07-06	122
6349	61	2005-07-05	102
6350	61	2005-07-01	89
6351	61	2005-06-27	8
6352	61	2005-07-13	192
6353	61	2005-07-10	80
6354	61	2005-07-12	123
6355	61	2005-07-13	198
6356	61	2005-07-12	23
6357	61	2005-07-03	1
6358	61	2005-07-08	140
6359	61	2005-07-08	107
6360	61	2005-07-10	71
6361	61	2005-06-26	36
6362	61	2005-07-03	109
6363	61	2005-07-10	104
6364	61	2005-07-03	102
6365	61	2005-06-28	117
6366	61	2005-07-06	125
6367	61	2005-07-13	104
6368	61	2005-07-06	65
6369	61	2005-07-09	17
6370	61	2005-07-16	165
6371	61	2005-06-29	142
6372	61	2005-07-06	103
6373	61	2005-07-13	170
6374	61	2005-07-01	168
6375	61	2005-07-12	156
6376	61	2005-07-07	152
6377	61	2005-07-05	71
6378	62	2005-07-11	144
6379	62	2005-07-18	55
6380	62	2005-07-11	157
6381	62	2005-07-26	30
6382	62	2005-07-23	134
6383	62	2005-07-24	23
6384	62	2005-07-06	117
6385	62	2005-07-17	74
6386	62	2005-07-17	125
6387	62	2005-07-17	116
6388	62	2005-07-10	94
6389	62	2005-07-08	29
6390	62	2005-07-10	79
6391	62	2005-07-21	8
6392	62	2005-07-13	123
6393	62	2005-07-15	131
6394	62	2005-07-23	14
6395	62	2005-07-15	13
6396	62	2005-07-08	12
6397	62	2005-07-18	140
6398	62	2005-07-16	188
6399	62	2005-07-08	157
6400	62	2005-07-25	11
6401	62	2005-07-09	109
6402	62	2005-07-24	97
6403	62	2005-07-18	60
6404	62	2005-07-17	91
6405	62	2005-07-09	165
6406	62	2005-07-12	31
6407	62	2005-07-06	91
6408	62	2005-07-24	94
6409	62	2005-07-19	107
6410	62	2005-07-20	187
6411	62	2005-07-19	132
6412	62	2005-07-07	27
6413	62	2005-07-20	162
6414	62	2005-07-07	117
6415	62	2005-07-10	166
6416	62	2005-07-07	20
6417	62	2005-07-19	173
6418	62	2005-07-06	4
6419	62	2005-07-09	122
6420	62	2005-07-20	183
6421	62	2005-07-06	7
6422	62	2005-07-22	187
6423	62	2005-07-16	155
6424	62	2005-07-15	96
6425	62	2005-07-25	21
6426	62	2005-07-20	72
6427	62	2005-07-21	145
6428	62	2005-07-12	7
6429	62	2005-07-10	152
6430	62	2005-07-09	44
6431	62	2005-07-09	32
6432	62	2005-07-07	64
6433	62	2005-07-16	42
6434	62	2005-07-23	199
6435	62	2005-07-22	95
6436	62	2005-07-16	133
6437	62	2005-07-08	30
6438	62	2005-07-09	161
6439	62	2005-07-21	190
6440	62	2005-07-25	194
6441	62	2005-07-14	166
6442	62	2005-07-06	167
6443	62	2005-07-11	34
6444	62	2005-07-09	45
6445	62	2005-07-20	150
6446	62	2005-07-06	172
6447	62	2005-07-06	148
6448	62	2005-07-08	167
6449	62	2005-07-25	175
6450	62	2005-07-20	89
6451	62	2005-07-08	72
6452	62	2005-07-18	142
6453	62	2005-07-21	6
6454	62	2005-07-20	80
6455	62	2005-07-26	38
6456	62	2005-07-13	88
6457	62	2005-07-08	95
6458	62	2005-07-25	39
6459	62	2005-07-17	100
6460	62	2005-07-26	97
6461	62	2005-07-17	194
6462	62	2005-07-17	129
6463	62	2005-07-15	148
6464	62	2005-07-21	29
6465	62	2005-07-17	47
6466	62	2005-07-13	128
6467	62	2005-07-20	187
6468	62	2005-07-17	77
6469	62	2005-07-23	158
6470	62	2005-07-25	2
6471	62	2005-07-10	177
6472	62	2005-07-09	119
6473	62	2005-07-10	42
6474	62	2005-07-14	26
6475	63	2005-07-18	101
6476	63	2005-07-23	196
6477	63	2005-08-03	96
6478	63	2005-07-24	92
6479	63	2005-08-03	138
6480	63	2005-07-22	158
6481	63	2005-08-06	99
6482	63	2005-07-21	94
6483	63	2005-07-25	178
6484	63	2005-07-24	119
6485	63	2005-07-24	116
6486	63	2005-07-30	5
6487	63	2005-07-28	164
6488	63	2005-07-20	183
6489	63	2005-07-22	27
6490	63	2005-07-24	83
6491	63	2005-07-17	71
6492	63	2005-08-06	58
6493	63	2005-07-21	95
6494	63	2005-08-01	46
6495	63	2005-07-29	49
6496	63	2005-07-17	93
6497	63	2005-07-21	199
6498	63	2005-07-23	194
6499	63	2005-08-01	106
6500	63	2005-07-24	154
6501	63	2005-07-21	21
6502	63	2005-07-24	130
6503	63	2005-07-20	5
6504	63	2005-08-04	69
6505	63	2005-07-18	169
6506	63	2005-08-04	59
6507	63	2005-07-31	46
6508	63	2005-08-04	52
6509	63	2005-07-21	162
6510	63	2005-07-18	58
6511	63	2005-07-17	128
6512	63	2005-07-26	31
6513	63	2005-07-22	9
6514	63	2005-07-30	114
6515	63	2005-07-27	85
6516	63	2005-07-30	66
6517	63	2005-08-04	155
6518	63	2005-07-18	49
6519	63	2005-07-21	85
6520	63	2005-08-02	61
6521	63	2005-07-28	10
6522	63	2005-07-25	191
6523	63	2005-08-04	169
6524	63	2005-07-27	57
6525	63	2005-07-20	21
6526	63	2005-07-20	128
6527	63	2005-08-03	177
6528	63	2005-07-29	66
6529	63	2005-07-23	109
6530	63	2005-07-17	45
6531	63	2005-08-01	185
6532	63	2005-08-01	157
6533	63	2005-07-25	109
6534	63	2005-07-19	51
6535	63	2005-07-17	41
6536	63	2005-07-20	169
6537	63	2005-07-25	71
6538	63	2005-07-27	182
6539	63	2005-07-24	175
6540	63	2005-07-26	113
6541	63	2005-08-01	85
6542	63	2005-07-17	154
6543	63	2005-08-04	143
6544	63	2005-07-27	7
6545	63	2005-07-23	175
6546	63	2005-07-20	33
6547	63	2005-07-25	176
6548	63	2005-07-28	186
6549	63	2005-07-28	127
6550	63	2005-08-01	24
6551	63	2005-07-20	158
6552	63	2005-07-21	87
6553	63	2005-07-19	17
6554	63	2005-07-30	94
6555	63	2005-07-23	169
6556	63	2005-08-02	76
6557	63	2005-07-29	23
6558	63	2005-08-01	93
6559	63	2005-07-25	153
6560	63	2005-07-27	101
6561	63	2005-07-17	84
6562	63	2005-07-28	141
6563	63	2005-07-30	13
6564	63	2005-08-02	4
6565	63	2005-07-28	34
6566	63	2005-07-19	110
6567	63	2005-07-28	174
6568	63	2005-08-03	191
6569	63	2005-07-31	75
6570	63	2005-08-06	67
6571	63	2005-07-31	100
6572	63	2005-07-21	121
6573	63	2005-07-25	7
6574	63	2005-08-02	32
6575	63	2005-07-26	174
6576	63	2005-08-04	116
6577	63	2005-08-01	141
6578	63	2005-08-02	125
6579	63	2005-07-19	51
6580	63	2005-08-03	76
6581	64	2005-08-21	140
6582	64	2005-08-07	171
6583	64	2005-08-11	91
6584	64	2005-08-15	146
6585	64	2005-08-16	167
6586	64	2005-08-21	16
6587	64	2005-08-11	113
6588	64	2005-08-19	197
6589	64	2005-08-15	89
6590	64	2005-08-13	16
6591	64	2005-08-19	4
6592	64	2005-08-10	162
6593	64	2005-08-13	172
6594	64	2005-08-17	98
6595	64	2005-08-13	152
6596	64	2005-08-03	29
6597	64	2005-08-18	164
6598	64	2005-08-12	43
6599	64	2005-08-21	151
6600	64	2005-08-09	133
6601	64	2005-08-21	9
6602	64	2005-08-03	167
6603	64	2005-08-16	101
6604	64	2005-08-14	53
6605	64	2005-08-21	171
6606	64	2005-08-12	115
6607	64	2005-08-16	197
6608	64	2005-08-07	9
6609	64	2005-08-17	53
6610	64	2005-08-01	138
6611	64	2005-08-15	93
6612	64	2005-08-05	37
6613	64	2005-08-12	197
6614	64	2005-08-09	74
6615	64	2005-08-19	159
6616	64	2005-08-20	20
6617	64	2005-08-06	190
6618	64	2005-08-12	103
6619	64	2005-08-01	140
6620	64	2005-08-01	142
6621	64	2005-08-16	104
6622	64	2005-08-10	134
6623	64	2005-08-12	143
6624	64	2005-08-01	102
6625	64	2005-08-07	95
6626	64	2005-08-20	29
6627	64	2005-08-21	76
6628	64	2005-08-04	114
6629	64	2005-08-13	111
6630	64	2005-08-05	161
6631	64	2005-08-14	114
6632	64	2005-08-01	74
6633	64	2005-08-05	149
6634	64	2005-08-21	128
6635	64	2005-08-13	28
6636	64	2005-08-10	99
6637	64	2005-08-08	71
6638	64	2005-08-02	124
6639	64	2005-08-07	197
6640	64	2005-08-08	0
6641	64	2005-08-01	157
6642	64	2005-08-21	13
6643	64	2005-08-20	100
6644	64	2005-08-16	24
6645	64	2005-08-19	29
6646	64	2005-08-17	49
6647	64	2005-08-11	40
6648	64	2005-08-14	96
6649	64	2005-08-17	171
6650	64	2005-08-15	184
6651	64	2005-08-10	65
6652	64	2005-08-12	96
6653	64	2005-08-01	26
6654	64	2005-08-05	64
6655	64	2005-08-13	127
6656	64	2005-08-04	56
6657	64	2005-08-15	151
6658	64	2005-08-20	82
6659	64	2005-08-06	5
6660	64	2005-08-05	21
6661	64	2005-08-17	92
6662	64	2005-08-01	164
6663	64	2005-08-04	108
6664	64	2005-08-17	171
6665	64	2005-08-11	175
6666	64	2005-08-13	40
6667	64	2005-08-11	198
6668	65	2005-09-01	106
6669	65	2005-09-05	148
6670	65	2005-08-27	63
6671	65	2005-09-08	31
6672	65	2005-09-05	67
6673	65	2005-08-26	50
6674	65	2005-08-25	147
6675	65	2005-08-28	114
6676	65	2005-09-07	45
6677	65	2005-08-29	169
6678	65	2005-08-28	83
6679	65	2005-08-24	33
6680	65	2005-08-30	184
6681	65	2005-09-09	6
6682	65	2005-08-20	148
6683	65	2005-09-01	105
6684	65	2005-08-26	137
6685	65	2005-08-28	134
6686	65	2005-08-25	102
6687	65	2005-08-21	151
6688	65	2005-09-04	140
6689	65	2005-09-02	82
6690	65	2005-09-01	1
6691	65	2005-08-26	146
6692	65	2005-09-02	85
6693	65	2005-08-21	107
6694	65	2005-08-30	195
6695	65	2005-09-05	36
6696	65	2005-08-31	160
6697	65	2005-09-05	67
6698	65	2005-09-01	100
6699	65	2005-08-21	143
6700	65	2005-08-29	143
6701	65	2005-09-04	103
6702	65	2005-09-09	138
6703	65	2005-08-21	57
6704	65	2005-08-20	60
6705	65	2005-08-26	4
6706	65	2005-09-09	3
6707	65	2005-08-29	196
6708	65	2005-08-27	54
6709	65	2005-09-09	53
6710	65	2005-08-23	190
6711	65	2005-08-23	110
6712	65	2005-08-21	181
6713	65	2005-09-09	103
6714	65	2005-09-04	141
6715	65	2005-09-03	79
6716	65	2005-09-05	148
6717	65	2005-08-27	38
6718	65	2005-08-28	146
6719	65	2005-08-28	55
6720	65	2005-08-30	175
6721	65	2005-08-25	46
6722	65	2005-08-30	36
6723	65	2005-09-01	29
6724	65	2005-08-23	169
6725	65	2005-08-29	119
6726	65	2005-08-27	143
6727	65	2005-08-21	170
6728	65	2005-08-28	107
6729	65	2005-08-28	48
6730	65	2005-08-30	10
6731	65	2005-08-30	193
6732	65	2005-08-23	192
6733	65	2005-09-09	56
6734	65	2005-08-28	159
6735	65	2005-08-20	169
6736	65	2005-08-21	114
6737	65	2005-08-29	180
6738	65	2005-08-29	7
6739	65	2005-08-23	133
6740	65	2005-08-25	12
6741	65	2005-08-30	114
6742	65	2005-09-05	180
6743	65	2005-08-30	114
6744	65	2005-09-01	90
6745	65	2005-09-06	163
6746	65	2005-09-09	87
6747	65	2005-08-28	139
6748	65	2005-08-31	83
6749	65	2005-09-02	0
6750	65	2005-08-30	56
6751	65	2005-09-07	135
6752	65	2005-08-25	62
6753	65	2005-08-24	154
6754	65	2005-08-21	44
6755	65	2005-08-31	118
6756	65	2005-09-07	24
6757	65	2005-09-04	130
6758	65	2005-09-07	65
6759	65	2005-08-27	13
6760	65	2005-09-01	50
6761	65	2005-09-08	123
6762	65	2005-09-05	94
6763	65	2005-08-23	82
6764	65	2005-08-24	100
6765	65	2005-09-09	140
6766	65	2005-08-28	52
6767	65	2005-09-06	14
6768	65	2005-09-03	9
6769	66	2005-09-06	115
6770	66	2005-09-05	112
6771	66	2005-09-14	187
6772	66	2005-09-13	199
6773	66	2005-09-13	183
6774	66	2005-09-14	48
6775	66	2005-09-09	179
6776	66	2005-09-24	55
6777	66	2005-09-23	87
6778	66	2005-09-07	93
6779	66	2005-09-19	57
6780	66	2005-09-21	172
6781	66	2005-09-22	107
6782	66	2005-09-18	37
6783	66	2005-09-24	38
6784	66	2005-09-15	12
6785	66	2005-09-20	111
6786	66	2005-09-16	4
6787	66	2005-09-22	196
6788	66	2005-09-06	144
6789	66	2005-09-17	116
6790	66	2005-09-07	64
6791	66	2005-09-20	140
6792	66	2005-09-09	87
6793	66	2005-09-23	191
6794	66	2005-09-24	50
6795	66	2005-09-23	190
6796	66	2005-09-08	62
6797	66	2005-09-11	9
6798	66	2005-09-20	13
6799	66	2005-09-08	47
6800	66	2005-09-19	29
6801	66	2005-09-20	75
6802	66	2005-09-25	145
6803	66	2005-09-16	79
6804	66	2005-09-24	117
6805	66	2005-09-22	126
6806	66	2005-09-10	115
6807	66	2005-09-10	112
6808	66	2005-09-06	134
6809	66	2005-09-10	110
6810	66	2005-09-14	171
6811	66	2005-09-21	168
6812	66	2005-09-08	185
6813	66	2005-09-25	41
6814	66	2005-09-07	64
6815	66	2005-09-14	18
6816	66	2005-09-24	42
6817	66	2005-09-21	111
6818	66	2005-09-23	48
6819	66	2005-09-14	36
6820	66	2005-09-23	136
6821	66	2005-09-19	129
6822	66	2005-09-14	45
6823	66	2005-09-24	120
6824	66	2005-09-20	168
6825	66	2005-09-15	3
6826	66	2005-09-21	151
6827	66	2005-09-11	138
6828	66	2005-09-06	193
6829	66	2005-09-12	192
6830	66	2005-09-10	30
6831	66	2005-09-10	185
6832	66	2005-09-06	102
6833	66	2005-09-06	92
6834	66	2005-09-11	170
6835	66	2005-09-17	14
6836	66	2005-09-12	9
6837	66	2005-09-17	181
6838	66	2005-09-12	31
6839	66	2005-09-13	72
6840	66	2005-09-08	39
6841	66	2005-09-24	148
6842	66	2005-09-20	161
6843	66	2005-09-11	135
6844	66	2005-09-18	146
6845	66	2005-09-17	123
6846	66	2005-09-06	152
6847	66	2005-09-15	138
6848	66	2005-09-17	107
6849	66	2005-09-07	166
6850	66	2005-09-21	12
6851	66	2005-09-23	83
6852	66	2005-09-25	170
6853	66	2005-09-19	72
6854	66	2005-09-10	59
6855	66	2005-09-18	91
6856	66	2005-09-06	89
6857	66	2005-09-07	130
6858	66	2005-09-16	120
6859	66	2005-09-25	42
6860	66	2005-09-21	115
6861	66	2005-09-25	184
6862	66	2005-09-19	166
6863	66	2005-09-17	134
6864	66	2005-09-18	11
6865	66	2005-09-17	127
6866	66	2005-09-18	83
6867	66	2005-09-17	62
6868	67	2005-09-30	136
6869	67	2005-09-29	162
6870	67	2005-09-30	80
6871	67	2005-09-18	4
6872	67	2005-09-30	171
6873	67	2005-09-17	159
6874	67	2005-09-15	143
6875	67	2005-09-15	37
6876	67	2005-09-20	147
6877	67	2005-09-28	3
6878	67	2005-09-22	67
6879	67	2005-09-20	77
6880	67	2005-09-19	108
6881	67	2005-09-27	145
6882	67	2005-09-29	108
6883	67	2005-09-21	183
6884	67	2005-10-04	75
6885	67	2005-10-02	118
6886	67	2005-09-23	22
6887	67	2005-10-05	96
6888	67	2005-10-05	68
6889	67	2005-09-21	103
6890	67	2005-10-04	16
6891	67	2005-09-16	98
6892	67	2005-09-18	3
6893	67	2005-09-24	140
6894	67	2005-10-01	94
6895	67	2005-09-23	114
6896	67	2005-09-25	59
6897	67	2005-09-29	173
6898	67	2005-09-17	64
6899	67	2005-09-15	91
6900	67	2005-09-22	122
6901	67	2005-10-04	122
6902	67	2005-10-02	35
6903	67	2005-09-15	198
6904	67	2005-10-04	49
6905	67	2005-09-26	48
6906	67	2005-09-21	109
6907	67	2005-09-27	178
6908	67	2005-09-18	198
6909	67	2005-09-15	148
6910	67	2005-09-19	48
6911	67	2005-10-05	112
6912	67	2005-10-02	104
6913	67	2005-09-18	155
6914	67	2005-09-26	197
6915	67	2005-09-30	199
6916	67	2005-10-02	19
6917	67	2005-09-27	9
6918	67	2005-10-05	186
6919	67	2005-09-20	47
6920	67	2005-09-30	165
6921	67	2005-09-19	187
6922	67	2005-09-28	187
6923	67	2005-09-23	173
6924	67	2005-10-04	88
6925	67	2005-09-17	174
6926	67	2005-10-04	135
6927	67	2005-09-20	5
6928	67	2005-09-26	14
6929	67	2005-09-28	101
6930	67	2005-09-29	32
6931	67	2005-09-27	7
6932	67	2005-10-01	139
6933	67	2005-09-23	168
6934	67	2005-09-23	62
6935	67	2005-09-17	165
6936	67	2005-10-01	165
6937	67	2005-09-26	162
6938	67	2005-09-28	80
6939	67	2005-09-16	98
6940	67	2005-09-27	129
6941	67	2005-09-17	16
6942	67	2005-09-27	58
6943	67	2005-10-03	18
6944	67	2005-09-21	152
6945	67	2005-09-28	1
6946	67	2005-09-22	60
6947	67	2005-09-22	153
6948	67	2005-10-01	2
6949	67	2005-09-29	134
6950	67	2005-09-24	46
6951	67	2005-09-18	88
6952	67	2005-09-23	136
6953	67	2005-09-24	106
6954	67	2005-10-02	177
6955	67	2005-09-28	45
6956	67	2005-09-21	49
6957	67	2005-09-17	25
6958	67	2005-09-17	21
6959	67	2005-09-16	131
6960	67	2005-09-23	46
6961	67	2005-09-24	113
6962	67	2005-09-29	26
6963	67	2005-09-23	96
6964	67	2005-09-17	72
6965	68	2005-10-18	158
6966	68	2005-10-15	4
6967	68	2005-10-01	103
6968	68	2005-10-08	184
6969	68	2005-10-13	37
6970	68	2005-10-09	25
6971	68	2005-09-28	9
6972	68	2005-10-03	128
6973	68	2005-09-28	26
6974	68	2005-10-11	131
6975	68	2005-10-04	62
6976	68	2005-10-15	79
6977	68	2005-10-03	107
6978	68	2005-09-30	142
6979	68	2005-10-13	82
6980	68	2005-10-15	101
6981	68	2005-10-16	138
6982	68	2005-10-02	62
6983	68	2005-10-15	156
6984	68	2005-10-12	62
6985	68	2005-10-08	20
6986	68	2005-10-05	151
6987	68	2005-10-13	14
6988	68	2005-09-30	123
6989	68	2005-10-08	63
6990	68	2005-10-14	163
6991	68	2005-10-10	7
6992	68	2005-10-07	48
6993	68	2005-09-29	93
6994	68	2005-10-07	129
6995	68	2005-10-11	50
6996	68	2005-10-09	183
6997	68	2005-10-04	65
6998	68	2005-10-12	79
6999	68	2005-10-05	55
7000	68	2005-09-29	36
7001	68	2005-10-05	161
7002	68	2005-10-16	59
7003	68	2005-10-17	122
7004	68	2005-10-09	8
7005	68	2005-10-03	139
7006	68	2005-10-04	116
7007	68	2005-10-17	146
7008	68	2005-10-02	41
7009	68	2005-09-30	12
7010	68	2005-10-12	53
7011	68	2005-10-11	87
7012	68	2005-10-12	152
7013	68	2005-10-02	161
7014	68	2005-10-09	107
7015	68	2005-09-28	77
7016	68	2005-10-02	181
7017	68	2005-10-12	52
7018	68	2005-10-03	151
7019	68	2005-10-13	108
7020	68	2005-10-09	62
7021	68	2005-10-03	111
7022	68	2005-09-30	168
7023	68	2005-10-17	130
7024	68	2005-10-09	114
7025	68	2005-10-04	9
7026	68	2005-10-03	192
7027	68	2005-10-16	59
7028	68	2005-10-10	67
7029	68	2005-10-16	52
7030	68	2005-10-11	29
7031	68	2005-10-12	149
7032	68	2005-10-13	106
7033	68	2005-10-15	123
7034	68	2005-10-08	123
7035	68	2005-10-13	74
7036	68	2005-10-15	157
7037	68	2005-10-15	163
7038	68	2005-10-07	186
7039	68	2005-10-12	54
7040	68	2005-10-16	39
7041	68	2005-10-10	182
7042	68	2005-10-01	19
7043	68	2005-10-08	187
7044	68	2005-10-01	9
7045	68	2005-10-18	183
7046	68	2005-10-03	6
7047	68	2005-10-09	181
7048	68	2005-10-02	28
7049	68	2005-10-16	11
7050	68	2005-10-09	3
7051	68	2005-10-03	126
7052	68	2005-10-08	67
7053	68	2005-10-01	178
7054	68	2005-10-04	64
7055	68	2005-10-03	135
7056	68	2005-10-12	57
7057	68	2005-10-17	50
7058	68	2005-10-18	80
7059	68	2005-09-28	53
7060	69	2005-10-19	148
7061	69	2005-10-30	186
7062	69	2005-11-07	20
7063	69	2005-10-28	148
7064	69	2005-11-04	36
7065	69	2005-10-20	83
7066	69	2005-10-18	75
7067	69	2005-10-26	58
7068	69	2005-11-02	133
7069	69	2005-10-30	179
7070	69	2005-10-24	124
7071	69	2005-10-25	62
7072	69	2005-10-28	38
7073	69	2005-11-03	127
7074	69	2005-11-02	175
7075	69	2005-11-07	146
7076	69	2005-10-18	29
7077	69	2005-10-20	43
7078	69	2005-11-04	19
7079	69	2005-10-28	80
7080	69	2005-10-30	99
7081	69	2005-10-27	197
7082	69	2005-10-21	30
7083	69	2005-10-22	136
7084	69	2005-10-26	20
7085	69	2005-10-19	29
7086	69	2005-11-04	14
7087	69	2005-10-27	188
7088	69	2005-11-01	49
7089	69	2005-10-20	116
7090	69	2005-10-30	72
7091	69	2005-10-26	11
7092	69	2005-10-31	15
7093	69	2005-10-24	131
7094	69	2005-10-28	108
7095	69	2005-11-02	125
7096	69	2005-11-06	164
7097	69	2005-10-21	14
7098	69	2005-11-05	129
7099	69	2005-11-02	30
7100	69	2005-10-19	16
7101	69	2005-11-05	96
7102	69	2005-10-26	18
7103	69	2005-10-27	192
7104	69	2005-10-31	20
7105	69	2005-10-25	64
7106	69	2005-11-07	194
7107	69	2005-11-06	128
7108	69	2005-10-27	170
7109	69	2005-10-30	73
7110	69	2005-11-04	64
7111	69	2005-10-28	35
7112	69	2005-10-22	194
7113	69	2005-10-27	27
7114	69	2005-11-04	182
7115	69	2005-10-25	197
7116	69	2005-10-23	197
7117	69	2005-11-03	25
7118	69	2005-10-27	51
7119	69	2005-11-05	69
7120	69	2005-10-28	8
7121	69	2005-10-21	10
7122	69	2005-11-03	45
7123	69	2005-10-20	90
7124	69	2005-10-18	8
7125	69	2005-11-04	34
7126	69	2005-11-06	145
7127	69	2005-10-22	42
7128	69	2005-11-06	4
7129	69	2005-10-22	50
7130	69	2005-11-02	143
7131	69	2005-10-22	30
7132	69	2005-11-03	82
7133	69	2005-10-27	66
7134	69	2005-10-20	84
7135	69	2005-10-27	129
7136	69	2005-10-19	62
7137	69	2005-10-20	5
7138	69	2005-10-21	157
7139	69	2005-10-19	91
7140	69	2005-11-03	159
7141	69	2005-10-22	159
7142	69	2005-11-05	199
7143	69	2005-10-28	160
7144	69	2005-10-26	100
7145	69	2005-10-25	192
7146	69	2005-10-24	170
7147	69	2005-10-24	156
7148	69	2005-10-23	29
7149	69	2005-11-05	141
7150	70	2005-11-05	73
7151	70	2005-11-19	88
7152	70	2005-11-07	178
7153	70	2005-11-13	189
7154	70	2005-11-08	6
7155	70	2005-11-03	128
7156	70	2005-11-12	124
7157	70	2005-11-06	26
7158	70	2005-11-23	99
7159	70	2005-11-10	74
7160	70	2005-11-13	39
7161	70	2005-11-03	17
7162	70	2005-11-17	13
7163	70	2005-11-14	148
7164	70	2005-11-13	177
7165	70	2005-11-07	104
7166	70	2005-11-18	142
7167	70	2005-11-11	150
7168	70	2005-11-11	82
7169	70	2005-11-21	47
7170	70	2005-11-11	172
7171	70	2005-11-14	15
7172	70	2005-11-06	50
7173	70	2005-11-10	56
7174	70	2005-11-09	122
7175	70	2005-11-19	81
7176	70	2005-11-21	136
7177	70	2005-11-22	101
7178	70	2005-11-21	126
7179	70	2005-11-23	122
7180	70	2005-11-22	89
7181	70	2005-11-16	42
7182	70	2005-11-04	53
7183	70	2005-11-06	38
7184	70	2005-11-08	122
7185	70	2005-11-21	82
7186	70	2005-11-10	43
7187	70	2005-11-22	17
7188	70	2005-11-06	189
7189	70	2005-11-14	149
7190	70	2005-11-13	88
7191	70	2005-11-07	18
7192	70	2005-11-07	25
7193	70	2005-11-11	34
7194	70	2005-11-05	113
7195	70	2005-11-11	74
7196	70	2005-11-13	124
7197	70	2005-11-15	192
7198	70	2005-11-21	51
7199	70	2005-11-20	70
7200	70	2005-11-19	41
7201	70	2005-11-03	140
7202	70	2005-11-09	191
7203	70	2005-11-08	33
7204	70	2005-11-13	70
7205	70	2005-11-12	113
7206	70	2005-11-21	100
7207	70	2005-11-16	8
7208	70	2005-11-09	191
7209	70	2005-11-20	145
7210	70	2005-11-11	170
7211	70	2005-11-12	146
7212	70	2005-11-15	99
7213	70	2005-11-18	31
7214	70	2005-11-10	79
7215	70	2005-11-08	102
7216	70	2005-11-18	37
7217	70	2005-11-12	191
7218	70	2005-11-07	41
7219	70	2005-11-19	113
7220	70	2005-11-21	168
7221	70	2005-11-03	129
7222	70	2005-11-15	193
7223	70	2005-11-06	180
7224	70	2005-11-14	62
7225	70	2005-11-08	12
7226	70	2005-11-13	100
7227	70	2005-11-15	199
7228	70	2005-11-17	47
7229	70	2005-11-05	98
7230	70	2005-11-04	139
7231	70	2005-11-19	176
7232	70	2005-11-12	196
7233	70	2005-11-11	51
7234	70	2005-11-11	48
7235	70	2005-11-15	101
7236	70	2005-11-08	120
7237	70	2005-11-13	124
7238	70	2005-11-07	16
7239	70	2005-11-16	33
7240	70	2005-11-10	4
7241	70	2005-11-05	96
7242	70	2005-11-22	186
7243	70	2005-11-22	86
7244	70	2005-11-20	132
7245	70	2005-11-09	75
7246	70	2005-11-21	40
7247	70	2005-11-04	111
7248	70	2005-11-20	95
7249	70	2005-11-20	74
7250	71	2005-11-29	0
7251	71	2005-12-05	30
7252	71	2005-11-25	145
7253	71	2005-12-02	167
7254	71	2005-12-05	34
7255	71	2005-11-26	130
7256	71	2005-11-26	20
7257	71	2005-12-01	120
7258	71	2005-11-22	0
7259	71	2005-11-27	71
7260	71	2005-11-22	12
7261	71	2005-11-25	144
7262	71	2005-11-21	171
7263	71	2005-12-08	97
7264	71	2005-11-21	15
7265	71	2005-11-29	165
7266	71	2005-12-05	146
7267	71	2005-11-23	13
7268	71	2005-11-26	11
7269	71	2005-12-07	71
7270	71	2005-12-01	154
7271	71	2005-12-06	21
7272	71	2005-12-02	123
7273	71	2005-12-07	64
7274	71	2005-11-22	99
7275	71	2005-12-01	103
7276	71	2005-12-08	91
7277	71	2005-12-01	92
7278	71	2005-11-27	89
7279	71	2005-12-09	26
7280	71	2005-11-30	83
7281	71	2005-11-27	62
7282	71	2005-11-20	29
7283	71	2005-11-29	111
7284	71	2005-12-07	124
7285	71	2005-11-30	16
7286	71	2005-11-25	105
7287	71	2005-11-24	43
7288	71	2005-11-23	13
7289	71	2005-12-06	129
7290	71	2005-11-20	81
7291	71	2005-11-26	101
7292	71	2005-11-23	67
7293	71	2005-12-04	194
7294	71	2005-12-08	145
7295	71	2005-11-27	80
7296	71	2005-12-07	105
7297	71	2005-12-09	162
7298	71	2005-12-09	156
7299	71	2005-12-05	23
7300	71	2005-11-30	165
7301	71	2005-11-22	8
7302	71	2005-12-03	17
7303	71	2005-12-05	109
7304	71	2005-11-22	156
7305	71	2005-11-23	102
7306	71	2005-11-24	169
7307	71	2005-11-30	138
7308	71	2005-12-02	19
7309	71	2005-12-04	107
7310	71	2005-12-06	49
7311	71	2005-12-02	188
7312	71	2005-11-27	88
7313	71	2005-11-21	82
7314	71	2005-11-29	100
7315	71	2005-11-28	9
7316	71	2005-11-25	50
7317	71	2005-11-27	135
7318	71	2005-11-25	71
7319	71	2005-12-07	47
7320	71	2005-11-28	116
7321	71	2005-11-30	152
7322	71	2005-12-06	32
7323	71	2005-12-02	178
7324	71	2005-12-02	192
7325	71	2005-12-08	107
7326	71	2005-11-30	105
7327	71	2005-12-03	130
7328	71	2005-12-05	167
7329	71	2005-11-22	11
7330	71	2005-11-29	197
7331	71	2005-11-23	97
7332	72	2005-12-07	155
7333	72	2005-12-07	107
7334	72	2005-12-06	80
7335	72	2005-12-15	126
7336	72	2005-12-04	87
7337	72	2005-12-06	153
7338	72	2005-12-15	81
7339	72	2005-12-18	123
7340	72	2005-12-11	138
7341	72	2005-12-03	197
7342	72	2005-12-04	76
7343	72	2005-12-01	151
7344	72	2005-11-29	43
7345	72	2005-11-29	59
7346	72	2005-12-11	70
7347	72	2005-12-07	160
7348	72	2005-11-30	80
7349	72	2005-12-13	8
7350	72	2005-12-08	128
7351	72	2005-12-03	103
7352	72	2005-12-13	59
7353	72	2005-12-06	80
7354	72	2005-12-14	91
7355	72	2005-12-16	148
7356	72	2005-12-13	70
7357	72	2005-12-03	129
7358	72	2005-12-03	11
7359	72	2005-12-08	163
7360	72	2005-12-17	71
7361	72	2005-12-03	184
7362	72	2005-12-10	35
7363	72	2005-12-15	112
7364	72	2005-12-11	3
7365	72	2005-12-04	70
7366	72	2005-12-08	96
7367	72	2005-12-08	73
7368	72	2005-12-05	92
7369	72	2005-12-18	141
7370	72	2005-12-01	133
7371	72	2005-12-04	34
7372	72	2005-12-09	143
7373	72	2005-12-18	182
7374	72	2005-12-08	72
7375	72	2005-12-08	3
7376	72	2005-12-06	18
7377	72	2005-12-03	45
7378	72	2005-12-08	192
7379	72	2005-12-01	33
7380	72	2005-12-05	189
7381	72	2005-12-05	150
7382	72	2005-12-08	40
7383	72	2005-12-19	14
7384	72	2005-12-16	134
7385	72	2005-12-16	78
7386	72	2005-12-08	57
7387	72	2005-12-16	23
7388	72	2005-12-11	164
7389	72	2005-12-02	119
7390	72	2005-12-16	101
7391	72	2005-12-04	15
7392	72	2005-12-08	51
7393	72	2005-11-29	22
7394	72	2005-11-29	95
7395	72	2005-12-12	63
7396	72	2005-12-19	136
7397	72	2005-11-30	66
7398	72	2005-12-17	5
7399	72	2005-11-30	185
7400	72	2005-12-18	70
7401	72	2005-12-17	166
7402	72	2005-11-30	164
7403	72	2005-12-12	79
7404	72	2005-12-09	139
7405	72	2005-12-11	135
7406	72	2005-12-15	162
7407	72	2005-12-12	65
7408	72	2005-12-14	3
7409	72	2005-12-05	105
7410	72	2005-11-29	170
7411	72	2005-12-01	57
7412	72	2005-12-11	66
7413	72	2005-12-11	159
7414	72	2005-12-15	139
7415	72	2005-12-01	105
7416	72	2005-12-03	16
7417	72	2005-12-08	38
7418	72	2005-12-18	186
7419	72	2005-12-18	52
7420	72	2005-12-16	179
7421	72	2005-12-12	14
7422	72	2005-12-05	57
7423	72	2005-12-13	32
7424	72	2005-12-04	158
7425	72	2005-11-30	154
7426	72	2005-12-11	171
7427	72	2005-11-30	170
7428	72	2005-12-08	64
7429	72	2005-12-19	93
7430	72	2005-12-02	90
7431	72	2005-11-29	123
7432	72	2005-12-18	43
7433	72	2005-12-04	28
7434	72	2005-12-01	164
7435	72	2005-12-10	179
7436	72	2005-12-14	120
7437	72	2005-11-29	122
7438	72	2005-12-08	37
7439	72	2005-12-15	5
7440	72	2005-11-30	123
7441	72	2005-12-16	71
7442	72	2005-12-06	86
7443	72	2005-12-17	111
7444	72	2005-12-13	14
7445	72	2005-12-12	190
7446	72	2005-12-02	62
7447	73	2006-01-05	11
7448	73	2005-12-21	166
7449	73	2005-12-26	31
7450	73	2005-12-20	146
7451	73	2005-12-31	63
7452	73	2005-12-19	135
7453	73	2005-12-31	146
7454	73	2005-12-23	35
7455	73	2005-12-19	79
7456	73	2006-01-01	44
7457	73	2005-12-27	33
7458	73	2005-12-23	48
7459	73	2005-12-21	17
7460	73	2006-01-07	186
7461	73	2005-12-19	14
7462	73	2005-12-22	82
7463	73	2005-12-23	29
7464	73	2005-12-30	30
7465	73	2005-12-26	66
7466	73	2005-12-28	28
7467	73	2005-12-22	11
7468	73	2005-12-27	119
7469	73	2006-01-03	51
7470	73	2006-01-07	25
7471	73	2005-12-21	137
7472	73	2006-01-06	74
7473	73	2006-01-04	27
7474	73	2005-12-21	155
7475	73	2006-01-03	157
7476	73	2005-12-30	120
7477	73	2005-12-24	160
7478	73	2006-01-04	72
7479	73	2005-12-29	115
7480	73	2005-12-28	99
7481	73	2006-01-01	189
7482	73	2005-12-31	151
7483	73	2005-12-19	108
7484	73	2005-12-24	58
7485	73	2005-12-30	169
7486	73	2006-01-03	76
7487	73	2005-12-30	88
7488	73	2005-12-23	77
7489	73	2006-01-05	110
7490	73	2005-12-19	157
7491	73	2005-12-31	108
7492	73	2005-12-21	137
7493	73	2006-01-02	31
7494	73	2005-12-30	122
7495	73	2006-01-06	1
7496	73	2005-12-26	199
7497	73	2005-12-31	100
7498	73	2005-12-21	162
7499	73	2005-12-25	0
7500	73	2005-12-18	193
7501	73	2005-12-28	173
7502	73	2005-12-20	150
7503	73	2005-12-26	130
7504	73	2006-01-01	183
7505	73	2005-12-19	116
7506	73	2005-12-26	89
7507	73	2006-01-03	93
7508	73	2006-01-01	9
7509	73	2006-01-01	46
7510	73	2005-12-30	85
7511	73	2005-12-28	9
7512	73	2005-12-24	55
7513	73	2005-12-21	130
7514	73	2005-12-31	22
7515	73	2005-12-26	34
7516	73	2005-12-30	7
7517	73	2006-01-03	170
7518	73	2006-01-06	54
7519	73	2006-01-01	191
7520	73	2006-01-03	9
7521	73	2005-12-22	58
7522	73	2005-12-23	181
7523	73	2005-12-30	26
7524	73	2005-12-30	106
7525	73	2005-12-30	110
7526	73	2005-12-29	152
7527	73	2005-12-29	12
7528	73	2005-12-25	190
7529	73	2005-12-27	112
7530	73	2005-12-31	178
7531	73	2005-12-20	65
7532	73	2005-12-27	22
7533	73	2005-12-30	16
7534	73	2006-01-05	124
7535	73	2005-12-26	80
7536	73	2006-01-02	186
7537	73	2006-01-01	99
7538	73	2005-12-22	193
7539	73	2006-01-04	162
7540	73	2005-12-18	178
7541	73	2005-12-19	6
7542	73	2005-12-28	31
7543	73	2006-01-01	76
7544	73	2005-12-23	193
7545	73	2006-01-02	148
7546	73	2005-12-30	96
7547	73	2006-01-05	79
7548	73	2006-01-01	14
7549	73	2006-01-02	194
7550	73	2006-01-07	148
7551	73	2006-01-02	163
7552	73	2006-01-01	75
7553	73	2005-12-22	130
7554	73	2005-12-25	19
7555	73	2006-01-07	169
7556	73	2005-12-20	138
\.


--
-- Data for Name: conferencecosts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY conferencecosts (conferencecostid, conferences_conferenceid, cost, datafrom, datato) FROM stdin;
0	0	76.41	2002-10-06	2003-01-13
1	1	55.36	2002-09-23	2003-01-02
2	1	129.52	2003-01-03	2003-01-26
3	2	81.32	2002-11-03	2003-01-17
4	2	125.03	2003-01-18	2003-02-13
5	3	2.72	2002-10-27	2003-03-05
6	4	86.46	2002-12-12	2003-02-06
7	4	113.78	2003-02-07	2003-02-26
8	4	257.17	2003-02-27	2003-03-25
9	5	41.44	2002-12-19	2003-02-06
10	5	178.51	2003-02-07	2003-03-12
11	5	246.86	2003-03-13	2003-04-07
12	6	3.35	2003-01-10	2003-03-15
13	6	192.60	2003-03-16	2003-04-20
14	7	4.97	2003-01-12	2003-02-26
15	7	135.85	2003-02-27	2003-04-05
16	7	252.67	2003-04-06	2003-05-01
17	8	57.66	2002-12-30	2003-05-19
18	9	67.87	2003-02-23	2003-03-31
19	9	143.45	2003-04-01	2003-05-04
20	9	241.40	2003-05-05	2003-06-03
21	10	68.53	2003-02-17	2003-04-10
22	10	170.25	2003-04-11	2003-05-13
23	10	254.13	2003-05-14	2003-06-13
24	11	36.55	2003-02-23	2003-05-04
25	11	191.12	2003-05-05	2003-05-26
26	11	285.38	2003-05-27	2003-07-03
27	12	54.24	2003-02-25	2003-07-21
28	13	81.85	2003-04-06	2003-08-08
29	14	55.92	2003-05-14	2003-07-03
30	14	117.45	2003-07-04	2003-07-25
31	14	266.06	2003-07-26	2003-08-21
32	15	39.33	2003-05-01	2003-07-11
33	15	143.35	2003-07-12	2003-08-04
34	15	275.60	2003-08-05	2003-08-31
35	16	70.32	2003-04-28	2003-07-21
36	16	175.73	2003-07-22	2003-08-21
37	16	229.29	2003-08-22	2003-09-17
38	17	46.46	2003-06-11	2003-08-03
39	17	147.29	2003-08-04	2003-09-11
40	17	261.63	2003-09-12	2003-10-03
41	18	9.87	2003-06-13	2003-10-13
42	19	21.37	2003-06-29	2003-09-23
43	19	180.92	2003-09-24	2003-11-02
44	20	59.71	2003-07-03	2003-10-12
45	20	100.80	2003-10-13	2003-11-18
46	21	53.00	2003-07-12	2003-12-03
47	22	76.71	2003-09-09	2003-10-04
48	22	168.20	2003-10-05	2003-11-13
49	22	296.40	2003-11-14	2003-12-17
50	23	67.28	2003-09-10	2003-12-05
51	23	196.44	2003-12-06	2003-12-29
52	24	23.04	2003-09-06	2004-01-17
53	25	7.02	2003-09-12	2003-12-20
54	25	187.85	2003-12-21	2004-01-29
55	26	78.41	2003-10-18	2004-02-14
56	27	22.22	2003-10-29	2004-02-02
57	27	106.13	2004-02-03	2004-02-27
58	28	23.17	2003-11-01	2004-02-25
59	28	119.18	2004-02-26	2004-03-18
60	29	19.10	2003-12-20	2004-01-30
61	29	177.81	2004-01-31	2004-02-19
62	29	213.06	2004-02-20	2004-03-28
63	30	21.60	2003-12-13	2004-04-13
64	31	17.47	2004-01-18	2004-04-29
65	32	92.22	2003-12-21	2004-03-17
66	32	179.13	2004-03-18	2004-04-08
67	32	297.84	2004-04-09	2004-05-12
68	33	48.94	2004-01-30	2004-05-29
69	34	29.95	2004-02-19	2004-05-20
70	34	186.21	2004-05-21	2004-06-10
71	35	86.51	2004-02-12	2004-04-24
72	35	123.27	2004-04-25	2004-06-01
73	35	218.99	2004-06-02	2004-06-29
74	36	70.73	2004-03-02	2004-05-10
75	36	122.95	2004-05-11	2004-06-12
76	36	277.97	2004-06-13	2004-07-17
77	37	68.81	2004-04-22	2004-07-09
78	37	123.78	2004-07-10	2004-07-30
79	38	40.99	2004-04-21	2004-08-18
80	39	29.70	2004-05-07	2004-09-02
81	40	56.79	2004-06-15	2004-08-18
82	40	123.09	2004-08-19	2004-09-22
83	41	74.01	2004-06-20	2004-10-03
84	42	70.60	2004-06-15	2004-09-24
85	42	110.49	2004-09-25	2004-10-23
86	43	39.86	2004-06-26	2004-11-08
87	44	48.54	2004-08-01	2004-09-12
88	44	162.38	2004-09-13	2004-10-21
89	44	286.93	2004-10-22	2004-11-19
90	45	13.03	2004-07-27	2004-09-21
91	45	184.17	2004-09-22	2004-10-25
92	45	246.62	2004-10-26	2004-11-30
93	46	27.24	2004-08-03	2004-12-14
94	47	8.31	2004-08-02	2004-10-31
95	47	141.03	2004-11-01	2004-12-05
96	47	274.65	2004-12-06	2004-12-28
97	48	16.15	2004-09-24	2004-11-10
98	48	149.84	2004-11-11	2004-12-14
99	48	219.51	2004-12-15	2005-01-11
100	49	56.77	2004-09-06	2004-11-15
101	49	188.26	2004-11-16	2004-12-17
102	49	299.82	2004-12-18	2005-01-25
103	50	57.89	2004-10-16	2004-12-29
104	50	129.61	2004-12-30	2005-02-06
105	51	45.00	2004-11-10	2005-02-21
106	52	26.57	2004-11-11	2005-03-07
107	53	45.73	2004-11-06	2005-02-28
108	53	142.53	2005-03-01	2005-03-22
109	54	87.21	2004-12-02	2005-02-26
110	54	131.15	2005-02-27	2005-04-05
111	55	9.40	2005-01-06	2005-02-17
112	55	107.78	2005-02-18	2005-03-18
113	55	266.57	2005-03-19	2005-04-24
114	56	61.35	2004-12-24	2005-03-08
115	56	153.56	2005-03-09	2005-04-03
116	56	291.75	2005-04-04	2005-05-11
117	57	60.69	2005-01-31	2005-04-28
118	57	108.83	2005-04-29	2005-05-25
119	58	10.59	2005-02-05	2005-04-16
120	58	171.75	2005-04-17	2005-05-13
121	58	238.59	2005-05-14	2005-06-10
122	59	93.55	2005-03-12	2005-06-30
123	60	32.70	2005-03-14	2005-06-07
124	60	132.99	2005-06-08	2005-07-11
125	61	82.48	2005-04-06	2005-06-22
126	61	170.85	2005-06-23	2005-07-26
127	62	71.73	2005-04-13	2005-05-24
128	62	183.99	2005-05-25	2005-06-29
129	62	256.67	2005-06-30	2005-08-05
130	63	37.24	2005-04-15	2005-07-14
131	63	135.04	2005-07-15	2005-08-16
132	64	83.60	2005-04-11	2005-08-02
133	64	114.66	2005-08-03	2005-08-31
134	65	79.16	2005-04-28	2005-08-29
135	65	150.75	2005-08-30	2005-09-19
136	66	55.90	2005-06-19	2005-09-01
137	66	161.65	2005-09-02	2005-10-05
138	67	87.78	2005-07-08	2005-09-24
139	67	111.98	2005-09-25	2005-10-15
140	68	19.35	2005-06-06	2005-10-28
141	69	71.36	2005-06-27	2005-10-22
142	69	117.35	2005-10-23	2005-11-17
143	70	19.48	2005-07-08	2005-12-03
144	71	68.01	2005-08-25	2005-12-19
145	72	88.31	2005-09-01	2005-11-12
146	72	198.53	2005-11-13	2005-12-09
147	72	276.59	2005-12-10	2005-12-29
148	73	1.41	2005-09-19	2006-01-17
\.


--
-- Data for Name: conferencedaybook; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY conferencedaybook (conferencedaybookid, conferencedays_conferencedaysid, conferencebookid_conferencebookid, participantsnumber, studentparticipantsnumber) FROM stdin;
0	0	0	2	0
1	0	1	4	1
2	0	3	1	0
3	0	6	3	0
4	0	7	3	1
5	0	9	5	4
6	0	10	4	2
7	0	11	2	1
8	0	12	4	3
9	0	13	5	5
10	0	14	1	1
11	0	16	5	3
12	0	17	1	0
13	0	18	2	0
14	0	20	5	1
15	0	22	1	0
16	0	25	1	0
17	0	26	3	2
18	0	27	3	2
19	0	29	5	5
20	0	30	4	2
21	0	32	2	0
22	0	33	5	4
23	0	34	3	3
24	0	35	5	0
25	0	36	3	0
26	0	37	4	2
27	0	38	5	0
28	0	39	1	1
29	0	41	1	1
30	0	42	4	1
31	0	43	1	1
32	0	44	5	3
33	0	45	3	0
34	0	46	2	0
35	0	47	4	3
36	0	50	3	3
37	0	51	1	1
38	0	52	4	3
39	0	53	4	0
40	0	54	4	1
41	0	56	4	1
42	0	57	5	1
43	0	58	4	2
44	0	59	1	0
45	0	60	2	2
46	0	63	2	1
47	0	64	5	3
48	0	65	4	3
49	0	66	2	2
50	0	67	5	4
51	0	68	5	4
52	0	69	1	1
53	0	70	4	2
54	0	71	2	1
55	0	72	5	0
56	0	73	3	0
57	0	74	5	3
58	0	75	2	1
59	0	76	4	2
60	0	77	2	2
61	0	78	2	2
62	0	79	3	0
63	0	82	4	2
64	0	84	3	0
65	0	85	1	0
66	0	86	4	2
67	0	88	4	0
68	0	89	1	0
69	0	90	5	5
70	0	91	1	1
71	0	93	1	1
72	0	94	1	0
73	0	95	2	1
74	0	97	2	2
75	0	98	2	0
76	0	99	2	2
77	0	100	4	4
78	0	101	5	5
79	1	0	4	3
80	1	1	5	4
81	1	2	3	2
82	1	3	2	0
83	1	5	1	1
84	1	6	4	4
85	1	8	5	1
86	1	9	5	3
87	1	10	2	2
88	1	11	2	2
89	1	12	2	0
90	1	13	2	0
91	1	14	4	0
92	1	15	4	2
93	1	16	1	1
94	1	17	4	4
95	1	18	4	3
96	1	20	3	1
97	1	21	3	3
98	1	22	2	2
99	1	23	2	1
100	1	25	1	1
101	1	26	4	2
102	1	27	3	1
103	1	28	4	0
104	1	29	4	2
105	1	30	3	1
106	1	32	5	4
107	1	33	2	0
108	1	34	1	1
109	1	35	1	0
110	1	37	3	2
111	1	38	1	0
112	1	39	3	3
113	1	40	2	0
114	1	41	3	0
115	1	42	2	2
116	1	44	1	1
117	1	45	3	2
118	1	46	1	0
119	1	47	3	0
120	1	48	4	0
121	1	49	2	0
122	1	50	2	2
123	1	51	3	3
124	1	52	1	0
125	1	53	1	1
126	1	54	5	5
127	1	55	1	0
128	1	57	1	0
129	1	59	4	0
130	1	61	5	0
131	1	62	2	0
132	1	65	2	2
133	1	67	2	0
134	1	68	1	1
135	1	69	2	2
136	1	70	2	1
137	1	72	3	1
138	1	73	5	4
139	1	76	1	0
140	1	77	1	1
141	1	78	1	0
142	2	0	1	0
143	2	1	5	0
144	2	2	3	3
145	2	3	2	1
146	2	4	1	0
147	2	6	3	3
148	2	7	1	0
149	2	8	1	1
150	2	9	4	4
151	2	10	5	2
152	2	11	2	0
153	2	12	1	0
154	2	13	5	5
155	2	15	5	1
156	2	17	5	5
157	2	18	3	2
158	2	19	4	3
159	2	20	5	1
160	2	21	5	2
161	2	22	4	1
162	2	23	1	0
163	2	24	5	1
164	2	26	4	1
165	2	27	4	1
166	2	28	1	0
167	2	29	5	5
168	2	30	2	0
169	2	32	3	0
170	2	33	5	4
171	2	34	5	4
172	2	35	4	3
173	2	36	3	0
174	2	37	2	0
175	2	38	4	3
176	2	40	4	3
177	2	41	5	2
178	2	42	2	0
179	2	43	1	1
180	2	44	2	2
181	2	45	4	2
182	2	47	5	2
183	2	48	2	1
184	2	50	3	2
185	2	54	2	0
186	2	55	5	4
187	2	56	2	0
188	2	57	3	3
189	2	58	3	0
190	2	60	1	1
191	2	61	4	2
192	2	62	2	2
193	2	63	3	1
194	2	65	2	1
195	2	66	2	1
196	2	68	4	1
197	2	69	2	1
198	2	70	3	2
199	2	71	1	0
200	2	72	1	1
201	2	74	5	0
202	2	75	5	5
203	2	76	3	0
204	2	77	1	0
205	2	79	5	1
206	2	80	4	4
207	2	81	4	3
208	2	82	3	0
209	2	83	5	4
210	2	84	2	0
211	2	85	2	1
212	2	87	3	1
213	2	88	4	2
214	2	89	2	2
215	2	90	3	1
216	2	92	3	0
217	2	93	2	2
218	2	94	3	2
219	3	112	3	3
220	3	115	2	0
221	3	116	5	2
222	3	117	5	3
223	3	120	3	0
224	3	121	2	2
225	3	122	1	1
226	3	123	5	2
227	3	124	1	0
228	3	125	5	2
229	3	127	1	1
230	3	128	1	0
231	3	129	4	0
232	3	130	1	0
233	3	131	3	2
234	3	132	2	2
235	3	133	2	0
236	3	134	1	0
237	3	135	5	5
238	3	136	1	0
239	3	138	5	4
240	3	139	2	1
241	3	140	5	5
242	3	142	3	2
243	3	144	3	3
244	3	147	1	0
245	3	148	3	0
246	3	150	4	3
247	3	151	2	2
248	3	152	5	0
249	3	153	4	3
250	3	154	1	1
251	3	155	4	1
252	3	156	1	0
253	3	158	2	0
254	3	159	4	1
255	3	160	1	1
256	3	161	1	0
257	3	162	2	1
258	3	164	3	2
259	3	165	5	4
260	3	166	4	3
261	3	167	4	2
262	3	169	5	5
263	3	171	5	3
264	3	172	2	0
265	3	173	3	1
266	3	174	1	1
267	3	175	5	5
268	3	176	3	0
269	3	177	5	1
270	3	178	2	2
271	3	179	2	0
272	3	180	1	1
273	3	181	1	0
274	3	182	3	3
275	3	183	3	3
276	3	184	5	3
277	3	186	4	1
278	3	187	3	3
279	3	188	5	0
280	3	189	5	3
281	3	190	4	3
282	3	191	3	1
283	3	192	1	1
284	3	193	1	0
285	3	194	2	2
286	3	196	3	0
287	3	197	4	4
288	3	198	3	3
289	3	200	4	4
290	3	202	1	0
291	3	203	1	1
292	3	204	3	2
293	3	205	2	0
294	3	206	3	1
295	3	207	3	0
296	3	208	3	0
297	3	209	1	1
298	3	210	2	1
299	3	211	1	1
300	3	212	1	1
301	3	213	5	3
302	3	214	1	1
303	4	112	3	2
304	4	113	2	0
305	4	114	2	2
306	4	115	5	3
307	4	116	1	0
308	4	117	5	0
309	4	118	2	0
310	4	119	5	3
311	4	121	1	1
312	4	122	3	0
313	4	124	1	0
314	4	125	4	1
315	4	126	4	3
316	4	127	1	1
317	4	128	5	1
318	4	129	2	1
319	4	130	4	4
320	4	131	3	1
321	4	132	5	4
322	4	133	5	2
323	4	134	2	2
324	4	135	1	0
325	4	136	3	0
326	4	137	5	0
327	4	140	3	0
328	4	142	3	0
329	4	143	4	2
330	4	144	3	1
331	4	145	4	2
332	4	148	5	2
333	4	151	5	1
334	4	152	4	1
335	4	153	5	2
336	4	155	1	0
337	4	156	1	1
338	4	157	3	3
339	4	158	2	1
340	4	159	4	4
341	4	160	2	0
342	4	161	2	2
343	4	162	1	1
344	4	163	3	1
345	4	164	4	3
346	4	165	4	0
347	4	166	4	0
348	4	167	3	3
349	4	168	1	0
350	4	169	5	4
351	4	170	2	1
352	4	173	3	3
353	4	174	5	1
354	4	175	5	3
355	4	177	1	1
356	4	178	4	2
357	4	179	2	0
358	4	181	3	3
359	4	183	2	1
360	4	184	5	2
361	4	185	5	0
362	4	186	5	4
363	4	187	4	4
364	4	188	5	5
365	4	189	1	1
366	4	190	4	2
367	4	191	2	0
368	5	223	3	0
369	5	225	4	4
370	5	227	5	0
371	5	228	4	1
372	5	229	3	0
373	5	230	5	5
374	5	232	3	0
375	5	233	4	3
376	5	234	5	1
377	5	235	5	4
378	5	236	2	2
379	5	237	5	3
380	5	238	2	2
381	5	241	3	2
382	5	242	5	0
383	5	243	3	2
384	5	244	2	2
385	5	245	4	2
386	5	246	3	0
387	5	248	3	1
388	5	249	2	1
389	5	250	3	3
390	5	251	3	0
391	5	252	3	2
392	5	255	2	0
393	5	256	4	2
394	5	258	5	5
395	5	259	3	2
396	5	260	4	3
397	5	262	4	0
398	5	263	3	3
399	5	264	2	1
400	6	223	3	1
401	6	224	3	2
402	6	225	4	2
403	6	226	1	0
404	6	227	2	0
405	6	228	5	5
406	6	229	4	1
407	6	230	5	0
408	6	231	2	2
409	6	232	5	1
410	6	233	2	2
411	6	234	1	0
412	6	236	4	1
413	6	238	4	3
414	6	239	2	0
415	6	242	4	3
416	6	243	2	1
417	6	244	1	0
418	6	246	2	1
419	6	247	3	3
420	6	248	1	1
421	6	250	2	2
422	6	251	3	3
423	6	252	4	0
424	6	253	2	0
425	6	254	1	1
426	6	255	4	4
427	6	257	5	5
428	6	259	1	0
429	6	260	3	1
430	6	261	4	0
431	6	262	3	2
432	6	263	5	2
433	6	264	1	0
434	6	266	2	1
435	6	267	3	0
436	6	268	5	4
437	6	269	3	0
438	6	270	1	0
439	6	271	5	1
440	6	272	2	1
441	6	273	3	0
442	6	274	2	0
443	6	275	1	1
444	6	276	1	0
445	6	277	4	2
446	6	278	3	2
447	6	279	4	0
448	6	280	4	4
449	6	281	3	3
450	6	283	4	1
451	6	284	2	0
452	6	286	1	0
453	6	288	2	2
454	6	289	2	0
455	6	290	5	5
456	6	291	5	3
457	6	292	5	4
458	6	294	3	0
459	6	295	3	3
460	6	296	2	0
461	6	297	3	3
462	6	298	2	2
463	6	299	1	0
464	6	300	5	3
465	6	301	4	0
466	6	302	1	0
467	6	303	4	1
468	6	304	5	3
469	6	305	3	2
470	6	306	1	0
471	6	307	3	3
472	6	308	1	1
473	6	309	2	0
474	6	311	2	0
475	6	313	5	1
476	6	314	5	0
477	6	315	4	1
478	6	318	4	0
479	6	319	5	1
480	6	320	3	2
481	6	322	5	2
482	6	323	1	0
483	6	324	5	3
484	6	325	5	4
485	6	326	4	0
486	6	327	1	1
487	6	328	4	4
488	6	331	2	1
489	6	332	1	0
490	6	333	1	1
491	6	334	2	1
492	7	335	4	4
493	7	336	2	2
494	7	337	3	2
495	7	339	4	2
496	7	340	3	3
497	7	341	3	2
498	7	342	3	3
499	7	343	5	1
500	7	344	3	2
501	7	345	2	2
502	7	346	2	2
503	7	348	1	0
504	7	349	4	3
505	7	350	1	0
506	7	351	2	2
507	7	352	1	0
508	7	356	3	0
509	7	357	3	3
510	7	358	4	4
511	7	359	4	0
512	7	361	2	2
513	7	362	3	0
514	7	363	1	0
515	7	364	3	3
516	7	365	4	1
517	7	366	3	3
518	7	367	1	1
519	7	368	5	1
520	7	369	4	0
521	7	370	3	1
522	7	372	3	1
523	7	373	2	2
524	7	374	1	1
525	7	375	1	1
526	7	376	5	0
527	7	380	2	2
528	7	381	1	1
529	7	382	3	1
530	7	383	5	3
531	7	385	5	2
532	7	386	4	0
533	7	388	1	0
534	7	389	4	0
535	7	390	5	5
536	7	392	2	1
537	7	394	3	1
538	7	395	5	5
539	7	396	2	2
540	7	397	5	1
541	7	398	4	3
542	7	400	1	0
543	7	401	3	3
544	7	403	1	1
545	7	404	3	2
546	7	405	5	0
547	7	406	1	0
548	7	407	5	3
549	7	409	3	0
550	7	410	3	1
551	7	411	3	2
552	7	412	4	2
553	7	413	5	2
554	7	414	5	3
555	7	415	3	1
556	7	416	4	3
557	7	417	2	0
558	7	418	2	2
559	7	419	1	1
560	7	420	1	0
561	7	421	2	1
562	7	422	2	0
563	7	423	5	3
564	7	424	5	0
565	7	425	4	3
566	7	427	3	0
567	8	335	1	1
568	8	336	3	2
569	8	337	5	0
570	8	338	5	3
571	8	340	1	1
572	8	341	2	0
573	8	342	5	0
574	8	343	4	0
575	8	344	4	4
576	8	345	5	4
577	8	347	4	1
578	8	348	3	3
579	8	351	4	4
580	8	352	4	2
581	8	353	2	2
582	8	355	3	2
583	8	356	5	0
584	8	357	1	1
585	8	358	2	1
586	8	359	2	1
587	8	360	1	1
588	8	364	5	1
589	8	365	1	1
590	8	366	2	0
591	8	367	5	5
592	8	368	4	4
593	8	369	4	3
594	8	370	5	4
595	8	371	5	4
596	8	372	4	3
597	8	373	1	1
598	8	374	3	2
599	8	375	4	3
600	8	376	4	4
601	8	378	3	0
602	8	379	3	0
603	8	380	2	2
604	8	381	4	2
605	8	382	1	1
606	8	383	5	1
607	8	384	1	0
608	8	385	1	0
609	8	386	1	1
610	8	387	3	3
611	8	388	4	4
612	8	389	4	4
613	8	390	3	2
614	8	391	5	2
615	8	393	3	2
616	8	395	2	0
617	8	396	2	2
618	8	397	4	0
619	8	398	2	2
620	8	399	4	1
621	8	400	1	0
622	8	401	4	0
623	8	402	4	1
624	8	403	3	2
625	8	404	1	1
626	8	405	1	1
627	8	406	2	2
628	8	407	3	0
629	8	408	1	1
630	8	409	3	1
631	8	411	1	1
632	8	412	2	0
633	8	413	2	0
634	8	414	5	1
635	8	416	4	4
636	8	417	5	5
637	8	418	5	3
638	8	419	5	5
639	8	420	2	2
640	8	423	3	2
641	8	424	2	0
642	8	425	2	2
643	9	429	5	3
644	9	431	2	2
645	9	432	1	1
646	9	433	2	2
647	9	434	1	0
648	9	435	2	2
649	9	436	5	0
650	9	437	5	3
651	9	440	2	2
652	9	441	2	0
653	9	442	5	3
654	9	443	2	0
655	9	444	1	1
656	9	445	2	1
657	9	446	4	1
658	9	447	3	0
659	9	448	4	0
660	9	451	5	2
661	9	452	4	4
662	9	453	4	2
663	9	454	3	1
664	9	456	2	0
665	9	457	5	0
666	9	458	4	0
667	9	459	3	3
668	9	460	2	2
669	9	461	4	2
670	9	464	2	1
671	9	465	4	2
672	9	466	4	3
673	9	467	1	1
674	9	468	2	0
675	9	469	1	1
676	9	470	2	1
677	9	472	1	0
678	9	473	4	3
679	9	475	5	2
680	9	476	3	0
681	9	477	2	0
682	9	478	4	1
683	9	479	5	0
684	9	480	3	2
685	9	482	4	2
686	9	483	3	0
687	9	484	4	1
688	9	485	3	1
689	9	486	5	2
690	9	488	3	0
691	9	490	4	0
692	9	491	1	1
693	9	492	3	1
694	9	493	5	5
695	9	494	4	0
696	9	495	1	0
697	9	496	5	2
698	9	497	5	0
699	9	499	4	1
700	9	500	4	4
701	9	501	1	1
702	9	502	1	1
703	9	504	2	0
704	9	505	4	1
705	9	506	2	0
706	9	507	4	1
707	9	508	3	1
708	9	509	5	4
709	9	510	5	2
710	9	511	3	3
711	9	512	5	4
712	9	513	2	2
713	9	514	1	1
714	9	516	5	4
715	9	517	2	2
716	9	518	1	0
717	9	519	3	2
718	9	520	5	5
719	9	521	4	4
720	9	522	2	1
721	9	523	5	2
722	9	526	4	2
723	9	527	5	4
724	9	528	1	0
725	9	529	4	0
726	9	530	3	1
727	9	531	5	5
728	9	533	5	2
729	9	537	1	0
730	10	428	2	1
731	10	429	4	2
732	10	430	1	1
733	10	432	5	3
734	10	433	3	1
735	10	434	3	2
736	10	436	3	2
737	10	437	4	3
738	10	438	1	0
739	10	439	1	0
740	10	440	5	2
741	10	441	2	0
742	10	442	3	0
743	10	443	5	2
744	10	444	3	0
745	10	445	4	3
746	10	447	3	3
747	10	448	3	1
748	10	449	2	0
749	10	450	4	1
750	10	451	1	1
751	10	452	3	3
752	10	453	4	1
753	10	454	4	2
754	10	455	3	0
755	10	456	4	1
756	10	457	3	1
757	10	458	5	4
758	10	459	5	3
759	10	460	5	0
760	10	461	3	0
761	10	462	3	0
762	10	464	2	0
763	10	465	5	1
764	10	467	1	0
765	10	468	1	0
766	10	469	2	0
767	10	470	2	0
768	10	471	3	0
769	10	472	4	2
770	10	473	3	0
771	10	474	2	2
772	10	475	3	0
773	10	477	5	1
774	10	478	4	0
775	10	480	5	2
776	10	481	5	0
777	10	482	1	0
778	10	483	3	3
779	10	484	1	0
780	10	486	5	1
781	10	488	4	0
782	10	489	3	2
783	10	491	5	0
784	10	493	4	3
785	10	494	2	1
786	10	497	3	3
787	10	498	5	5
788	10	500	1	1
789	10	501	5	1
790	10	502	1	1
791	10	503	4	4
792	10	504	2	1
793	10	505	3	0
794	10	506	4	4
795	10	507	3	1
796	10	508	4	1
797	10	509	1	1
798	10	510	2	2
799	10	511	1	0
800	10	512	1	1
801	10	513	1	0
802	10	514	2	2
803	10	515	2	1
804	10	516	1	0
805	10	517	3	1
806	10	521	5	4
807	10	522	4	1
808	10	523	3	1
809	10	525	2	0
810	10	526	4	4
811	10	527	4	2
812	10	528	4	0
813	10	529	2	1
814	10	530	2	1
815	10	531	3	1
816	10	532	1	0
817	10	533	4	0
818	10	534	4	3
819	10	536	4	1
820	10	537	3	0
821	10	538	5	1
822	10	539	2	2
823	10	540	5	0
824	10	541	1	1
825	11	428	2	1
826	11	429	3	1
827	11	430	2	2
828	11	431	3	1
829	11	432	5	4
830	11	433	5	5
831	11	434	4	0
832	11	435	2	1
833	11	436	4	0
834	11	437	4	3
835	11	438	5	1
836	11	439	2	1
837	11	440	2	1
838	11	441	1	1
839	11	442	2	2
840	11	444	3	2
841	11	445	4	2
842	11	446	5	5
843	11	447	4	3
844	11	448	3	2
845	11	449	3	2
846	11	450	1	0
847	11	451	1	0
848	11	452	5	2
849	11	453	5	3
850	11	454	5	0
851	11	455	4	3
852	11	456	4	3
853	11	457	2	0
854	11	458	5	1
855	11	459	5	3
856	11	460	1	1
857	11	461	3	3
858	11	462	5	3
859	11	463	3	1
860	11	464	1	0
861	11	465	5	1
862	11	467	3	3
863	11	469	3	2
864	11	470	4	0
865	11	471	1	1
866	11	473	4	1
867	11	474	5	2
868	11	475	2	2
869	11	476	5	2
870	11	477	2	2
871	11	478	1	0
872	11	479	1	0
873	11	480	5	1
874	11	481	1	0
875	11	482	1	0
876	11	483	4	1
877	11	484	4	4
878	11	485	3	0
879	11	486	5	2
880	11	487	4	1
881	11	489	5	3
882	11	490	4	2
883	11	491	3	3
884	11	492	4	0
885	11	493	2	0
886	11	494	5	5
887	11	497	1	1
888	11	499	1	1
889	11	500	4	1
890	11	501	3	2
891	11	502	3	2
892	11	503	1	1
893	11	504	1	0
894	11	505	3	2
895	11	506	3	0
896	11	507	5	3
897	11	509	3	3
898	11	510	2	1
899	11	511	4	0
900	11	512	3	3
901	11	514	5	0
902	11	515	2	1
903	11	516	3	2
904	11	517	5	5
905	11	518	1	0
906	11	519	5	1
907	11	521	4	1
908	11	523	2	1
909	11	526	5	1
910	11	527	5	4
911	11	528	3	0
912	12	542	3	1
913	12	543	4	0
914	12	545	4	1
915	12	546	3	0
916	12	548	5	4
917	12	549	2	1
918	12	552	2	1
919	12	553	1	0
920	12	554	1	1
921	12	555	4	2
922	12	556	1	0
923	12	557	1	1
924	12	558	4	4
925	12	559	2	0
926	12	561	4	0
927	12	562	3	3
928	12	563	4	0
929	12	564	2	2
930	12	565	5	5
931	12	566	4	1
932	12	567	2	0
933	12	568	1	0
934	12	569	3	0
935	12	570	5	5
936	12	572	4	2
937	12	573	1	0
938	12	574	4	1
939	12	575	1	0
940	12	576	5	0
941	12	578	4	1
942	12	579	5	1
943	12	582	4	1
944	12	584	5	5
945	12	585	3	0
946	12	586	4	4
947	12	587	1	1
948	12	588	1	1
949	12	589	2	2
950	12	590	2	2
951	12	591	3	2
952	12	592	3	3
953	12	593	3	2
954	12	595	3	1
955	12	596	3	2
956	12	597	3	2
957	12	598	4	1
958	12	599	5	5
959	12	600	4	3
960	12	602	3	2
961	12	603	5	0
962	12	605	2	1
963	12	606	3	3
964	12	607	1	1
965	12	608	1	0
966	12	609	1	1
967	12	610	5	5
968	12	611	4	2
969	12	612	2	0
970	12	616	2	0
971	12	617	4	2
972	13	542	1	0
973	13	543	1	0
974	13	544	1	0
975	13	545	4	1
976	13	546	2	1
977	13	547	5	5
978	13	548	2	2
979	13	549	1	1
980	13	551	2	1
981	13	552	4	3
982	13	553	1	0
983	13	554	4	1
984	13	555	1	1
985	13	556	3	0
986	13	557	4	3
987	13	558	5	3
988	13	559	5	5
989	13	562	2	2
990	13	563	3	1
991	13	564	4	0
992	13	565	3	3
993	13	567	1	1
994	13	568	2	1
995	13	569	3	0
996	13	571	4	2
997	13	572	1	1
998	13	573	5	0
999	13	574	3	1
1000	13	575	1	1
1001	13	576	2	0
1002	13	577	3	3
1003	13	578	5	5
1004	13	579	3	3
1005	13	580	5	3
1006	13	581	2	2
1007	13	582	5	1
1008	13	583	3	2
1009	13	585	1	1
1010	13	586	5	2
1011	13	587	4	4
1012	13	588	2	1
1013	14	544	5	4
1014	14	545	2	2
1015	14	546	1	0
1016	14	547	5	1
1017	14	548	1	0
1018	14	549	3	3
1019	14	550	2	1
1020	14	551	5	5
1021	14	554	1	0
1022	14	555	5	0
1023	14	556	1	1
1024	14	557	2	0
1025	14	558	4	1
1026	14	559	1	0
1027	14	560	1	1
1028	14	561	3	1
1029	14	562	3	1
1030	14	563	4	0
1031	14	564	1	1
1032	14	565	2	2
1033	14	566	3	1
1034	14	567	3	1
1035	14	568	2	1
1036	14	569	3	0
1037	14	570	2	1
1038	14	571	2	2
1039	14	573	3	3
1040	14	575	2	2
1041	14	576	2	2
1042	14	577	2	1
1043	14	578	5	4
1044	14	579	5	1
1045	14	581	4	4
1046	14	583	3	0
1047	14	585	3	3
1048	14	586	4	0
1049	14	588	5	1
1050	14	589	4	4
1051	14	590	1	0
1052	14	591	1	1
1053	14	592	2	1
1054	14	594	3	2
1055	14	595	5	4
1056	14	599	3	2
1057	14	600	1	0
1058	14	601	2	0
1059	14	602	2	0
1060	14	603	5	3
1061	14	606	4	0
1062	14	607	4	3
1063	14	609	2	1
1064	14	610	4	0
1065	14	611	1	1
1066	14	613	5	2
1067	14	614	1	1
1068	14	615	5	5
1069	14	616	2	1
1070	14	617	2	2
1071	14	619	1	0
1072	14	620	5	1
1073	14	622	1	0
1074	14	623	3	1
1075	14	624	2	0
1076	14	625	1	0
1077	14	626	2	2
1078	14	627	5	2
1079	14	628	2	2
1080	14	629	5	3
1081	14	631	4	1
1082	14	632	1	0
1083	14	633	3	1
1084	15	635	1	1
1085	15	637	2	0
1086	15	638	2	1
1087	15	639	1	0
1088	15	640	3	0
1089	15	641	5	1
1090	15	642	3	0
1091	15	643	4	0
1092	15	644	4	0
1093	15	646	4	0
1094	15	648	4	1
1095	15	649	5	5
1096	15	650	2	2
1097	15	652	2	1
1098	15	653	4	4
1099	15	654	5	0
1100	15	655	1	1
1101	15	656	3	1
1102	15	657	4	1
1103	15	659	1	1
1104	15	660	1	0
1105	15	661	1	1
1106	15	662	2	1
1107	15	663	5	2
1108	15	664	2	1
1109	15	665	2	2
1110	15	666	1	0
1111	15	667	2	1
1112	15	668	5	5
1113	15	669	3	1
1114	15	670	4	0
1115	15	671	5	5
1116	15	672	4	0
1117	15	673	3	3
1118	15	674	3	1
1119	15	675	1	0
1120	15	676	2	1
1121	15	677	1	1
1122	15	679	2	1
1123	15	680	3	2
1124	15	681	5	3
1125	15	682	5	4
1126	15	683	1	1
1127	15	684	2	0
1128	15	685	5	1
1129	15	686	2	2
1130	15	688	2	1
1131	15	689	3	3
1132	15	690	3	1
1133	15	691	1	1
1134	15	692	5	1
1135	15	693	3	1
1136	15	695	2	0
1137	15	696	1	0
1138	15	697	3	0
1139	15	699	2	0
1140	15	701	4	2
1141	15	703	2	2
1142	15	704	5	3
1143	15	705	3	2
1144	15	707	1	0
1145	15	708	2	2
1146	15	709	1	1
1147	15	710	3	1
1148	15	711	5	2
1149	15	712	1	1
1150	15	715	1	0
1151	16	635	3	2
1152	16	636	3	3
1153	16	637	3	2
1154	16	638	4	4
1155	16	639	5	1
1156	16	641	2	2
1157	16	642	5	0
1158	16	643	3	2
1159	16	644	4	1
1160	16	645	2	2
1161	16	646	3	2
1162	16	647	3	1
1163	16	648	2	0
1164	16	649	2	1
1165	16	650	1	0
1166	16	651	3	2
1167	16	652	4	0
1168	16	653	3	0
1169	16	654	4	2
1170	16	655	5	4
1171	16	656	1	0
1172	16	657	1	0
1173	16	658	1	1
1174	16	659	4	4
1175	16	661	3	1
1176	16	662	3	2
1177	16	663	1	1
1178	16	665	4	3
1179	16	666	5	0
1180	16	667	2	0
1181	16	669	5	3
1182	16	670	3	0
1183	16	671	5	0
1184	16	672	1	1
1185	16	673	1	0
1186	16	674	4	3
1187	16	675	3	2
1188	16	676	2	2
1189	17	716	4	4
1190	17	717	4	1
1191	17	718	2	2
1192	17	719	3	3
1193	17	720	5	1
1194	17	721	1	1
1195	17	722	1	0
1196	17	723	5	1
1197	17	724	3	0
1198	17	725	5	3
1199	17	726	3	2
1200	17	727	1	1
1201	17	728	5	1
1202	17	729	2	1
1203	17	730	4	1
1204	17	731	5	0
1205	17	732	1	1
1206	17	733	4	3
1207	17	734	3	3
1208	17	736	3	1
1209	17	737	3	0
1210	17	739	3	1
1211	17	740	5	2
1212	17	741	1	1
1213	17	742	1	1
1214	17	743	3	0
1215	17	744	4	4
1216	17	746	3	2
1217	17	748	3	2
1218	17	749	2	1
1219	17	750	1	0
1220	17	751	1	0
1221	17	753	2	2
1222	17	755	1	1
1223	17	757	2	2
1224	17	758	2	2
1225	17	759	2	1
1226	17	761	3	3
1227	17	762	2	2
1228	17	766	1	1
1229	17	767	2	2
1230	17	768	5	2
1231	17	769	1	1
1232	17	770	1	0
1233	17	772	1	0
1234	17	773	4	0
1235	17	776	5	4
1236	17	777	3	1
1237	17	778	1	1
1238	17	779	2	1
1239	17	780	2	2
1240	17	781	1	0
1241	17	782	3	2
1242	17	784	3	1
1243	17	785	2	2
1244	17	786	5	5
1245	17	787	1	0
1246	18	716	4	1
1247	18	717	2	2
1248	18	718	2	2
1249	18	719	5	4
1250	18	720	4	1
1251	18	721	1	1
1252	18	722	2	2
1253	18	723	3	2
1254	18	724	1	1
1255	18	725	3	3
1256	18	728	4	2
1257	18	729	4	4
1258	18	730	4	0
1259	18	731	2	0
1260	18	732	5	1
1261	18	733	3	3
1262	18	734	5	4
1263	18	736	3	3
1264	18	737	4	0
1265	18	738	3	2
1266	18	739	4	0
1267	18	740	3	2
1268	18	741	5	3
1269	18	742	3	3
1270	18	743	4	0
1271	18	744	1	1
1272	18	745	1	1
1273	18	746	1	0
1274	18	747	4	3
1275	18	748	3	1
1276	18	749	2	1
1277	18	750	5	2
1278	18	751	2	0
1279	18	752	4	2
1280	18	753	4	2
1281	18	754	2	0
1282	18	756	4	3
1283	18	758	1	0
1284	18	759	2	2
1285	18	761	4	1
1286	18	762	2	1
1287	18	763	3	3
1288	18	764	1	1
1289	18	765	4	3
1290	18	766	3	1
1291	18	769	4	4
1292	18	770	5	5
1293	18	771	1	0
1294	18	772	4	2
1295	18	773	4	1
1296	18	774	3	2
1297	18	775	3	2
1298	18	776	3	3
1299	18	777	4	2
1300	18	780	4	4
1301	18	781	5	2
1302	18	782	1	1
1303	18	783	3	0
1304	18	784	4	4
1305	18	785	5	4
1306	18	786	4	0
1307	18	787	3	3
1308	18	788	2	1
1309	18	789	4	2
1310	18	791	2	1
1311	18	793	5	2
1312	18	794	5	5
1313	18	795	5	5
1314	18	796	1	0
1315	18	798	4	0
1316	18	799	2	0
1317	18	800	2	0
1318	18	801	3	3
1319	18	803	2	1
1320	18	804	2	1
1321	18	805	3	2
1322	18	810	1	0
1323	19	823	2	1
1324	19	824	1	0
1325	19	825	2	1
1326	19	826	4	4
1327	19	827	1	1
1328	19	828	4	3
1329	19	829	1	0
1330	19	831	5	5
1331	19	832	1	0
1332	19	833	1	0
1333	19	835	5	4
1334	19	836	2	1
1335	19	838	3	0
1336	19	839	3	2
1337	19	840	2	1
1338	19	841	3	2
1339	19	842	4	3
1340	19	843	5	4
1341	19	844	4	3
1342	19	845	4	4
1343	19	846	1	0
1344	19	847	3	2
1345	19	848	1	0
1346	19	849	1	1
1347	19	852	1	1
1348	19	853	5	3
1349	19	854	5	1
1350	19	855	4	0
1351	19	856	4	1
1352	19	857	2	2
1353	19	858	3	2
1354	19	859	1	1
1355	19	860	5	3
1356	19	861	5	5
1357	19	862	1	1
1358	19	863	3	2
1359	19	864	1	1
1360	19	865	5	1
1361	19	866	1	1
1362	19	867	1	0
1363	19	868	2	1
1364	19	869	3	2
1365	19	870	3	0
1366	19	871	3	1
1367	19	874	4	1
1368	19	875	3	0
1369	19	877	5	3
1370	19	878	4	4
1371	19	879	5	5
1372	19	881	3	2
1373	19	882	3	3
1374	19	883	2	1
1375	19	884	1	1
1376	19	885	4	3
1377	19	886	3	2
1378	19	887	5	4
1379	19	888	4	3
1380	19	890	3	0
1381	19	892	1	1
1382	20	823	3	3
1383	20	824	4	1
1384	20	826	1	1
1385	20	827	5	0
1386	20	828	1	1
1387	20	829	4	4
1388	20	830	4	3
1389	20	831	2	1
1390	20	832	5	1
1391	20	833	4	0
1392	20	834	5	3
1393	20	835	1	0
1394	20	836	3	0
1395	20	837	4	0
1396	20	838	1	1
1397	20	839	4	0
1398	20	840	4	3
1399	20	841	3	0
1400	20	842	2	1
1401	20	843	2	2
1402	20	844	5	0
1403	20	845	4	1
1404	20	846	5	0
1405	20	847	1	1
1406	20	848	5	3
1407	20	849	5	1
1408	20	850	5	1
1409	20	851	2	2
1410	20	852	4	0
1411	20	854	4	1
1412	20	855	4	3
1413	20	856	5	2
1414	20	857	2	0
1415	20	858	5	4
1416	20	859	1	0
1417	20	860	1	1
1418	20	861	4	4
1419	20	862	5	4
1420	20	863	4	2
1421	20	864	4	1
1422	20	865	4	3
1423	20	866	5	1
1424	20	867	3	3
1425	20	868	2	0
1426	20	869	1	1
1427	20	870	1	0
1428	20	871	1	1
1429	20	872	5	3
1430	20	873	4	2
1431	20	876	1	1
1432	20	877	1	0
1433	21	912	3	0
1434	21	913	2	2
1435	21	914	2	0
1436	21	915	2	2
1437	21	916	2	0
1438	21	917	5	2
1439	21	918	1	1
1440	21	919	4	3
1441	21	920	2	2
1442	21	922	5	4
1443	21	923	2	1
1444	21	924	3	2
1445	21	925	5	4
1446	21	926	3	0
1447	21	927	1	1
1448	21	930	5	1
1449	21	931	1	0
1450	21	932	5	1
1451	21	935	4	3
1452	21	936	1	0
1453	21	937	1	0
1454	21	939	4	0
1455	21	940	3	0
1456	21	941	2	0
1457	21	942	5	5
1458	21	943	5	0
1459	21	944	4	2
1460	21	945	4	1
1461	21	946	4	1
1462	21	948	2	0
1463	21	949	4	4
1464	21	950	2	1
1465	21	951	2	1
1466	21	952	5	2
1467	21	953	1	1
1468	21	954	3	1
1469	21	955	5	3
1470	21	957	2	1
1471	21	958	1	1
1472	22	912	1	0
1473	22	913	5	3
1474	22	915	4	0
1475	22	916	3	1
1476	22	917	3	2
1477	22	918	2	0
1478	22	919	2	1
1479	22	920	5	0
1480	22	921	4	2
1481	22	922	5	2
1482	22	923	3	0
1483	22	924	2	1
1484	22	925	2	1
1485	22	926	4	3
1486	22	928	2	1
1487	22	929	1	1
1488	22	934	1	0
1489	22	935	4	2
1490	22	937	2	0
1491	22	939	3	0
1492	22	940	1	1
1493	22	941	2	1
1494	22	942	1	1
1495	22	944	4	1
1496	22	945	4	4
1497	22	946	2	1
1498	22	947	1	1
1499	22	948	1	1
1500	22	950	5	3
1501	22	951	5	5
1502	22	952	5	5
1503	22	953	5	4
1504	22	954	3	2
1505	22	955	2	1
1506	22	956	5	3
1507	22	957	4	0
1508	22	958	2	1
1509	22	959	5	4
1510	22	960	2	2
1511	22	961	3	3
1512	22	963	4	2
1513	22	964	3	3
1514	22	965	1	1
1515	22	966	2	1
1516	22	967	3	1
1517	22	968	5	4
1518	22	970	2	2
1519	22	971	3	3
1520	22	972	5	3
1521	22	974	3	1
1522	22	976	2	2
1523	22	977	1	0
1524	22	979	4	1
1525	22	980	3	1
1526	22	981	1	0
1527	22	982	2	0
1528	22	983	3	3
1529	22	984	1	1
1530	23	1006	4	1
1531	23	1007	4	4
1532	23	1008	2	2
1533	23	1009	4	1
1534	23	1010	1	1
1535	23	1012	4	1
1536	23	1013	2	2
1537	23	1014	1	0
1538	23	1015	4	3
1539	23	1016	4	2
1540	23	1017	3	0
1541	23	1018	2	1
1542	23	1019	4	1
1543	23	1020	2	0
1544	23	1022	4	4
1545	23	1023	5	2
1546	23	1024	2	0
1547	23	1025	4	1
1548	23	1026	4	2
1549	23	1027	3	2
1550	23	1028	5	2
1551	23	1029	4	4
1552	23	1030	3	2
1553	23	1032	2	0
1554	23	1033	4	3
1555	23	1034	2	0
1556	23	1035	1	1
1557	23	1036	2	0
1558	23	1037	5	0
1559	23	1038	2	1
1560	23	1039	2	1
1561	23	1042	2	0
1562	23	1044	5	5
1563	23	1045	4	2
1564	23	1046	4	3
1565	23	1047	1	1
1566	23	1048	2	2
1567	23	1049	4	4
1568	23	1050	5	1
1569	23	1051	1	0
1570	23	1052	4	2
1571	23	1053	5	4
1572	24	1006	3	1
1573	24	1007	3	1
1574	24	1008	3	1
1575	24	1009	4	2
1576	24	1010	3	0
1577	24	1011	2	1
1578	24	1012	2	0
1579	24	1013	4	1
1580	24	1014	5	1
1581	24	1016	4	1
1582	24	1017	5	0
1583	24	1018	3	3
1584	24	1019	2	2
1585	24	1022	2	1
1586	24	1024	1	0
1587	24	1025	3	3
1588	24	1026	4	1
1589	24	1027	4	2
1590	24	1031	5	2
1591	24	1033	1	1
1592	24	1035	4	1
1593	24	1036	1	0
1594	24	1039	3	3
1595	24	1040	5	0
1596	24	1042	1	0
1597	24	1044	2	0
1598	24	1045	4	1
1599	24	1046	1	0
1600	24	1047	2	0
1601	24	1048	4	0
1602	24	1049	4	3
1603	24	1050	2	1
1604	24	1051	5	3
1605	24	1052	5	5
1606	24	1053	4	2
1607	24	1054	3	3
1608	24	1055	4	4
1609	24	1056	5	4
1610	24	1057	4	2
1611	24	1058	1	1
1612	24	1059	1	0
1613	24	1060	5	2
1614	24	1061	5	1
1615	24	1062	2	1
1616	24	1063	4	2
1617	24	1064	3	0
1618	24	1065	5	3
1619	24	1066	5	0
1620	24	1067	1	1
1621	24	1068	5	2
1622	24	1070	3	2
1623	24	1071	5	2
1624	24	1072	2	1
1625	24	1074	2	1
1626	24	1075	4	1
1627	24	1076	4	3
1628	24	1077	4	1
1629	24	1079	4	1
1630	24	1081	3	1
1631	24	1082	1	0
1632	24	1083	2	0
1633	24	1084	5	5
1634	24	1085	5	4
1635	24	1086	3	3
1636	24	1087	4	1
1637	24	1088	3	2
1638	24	1089	4	0
1639	24	1090	4	2
1640	24	1091	5	0
1641	24	1092	5	0
1642	24	1093	5	4
1643	24	1094	4	4
1644	24	1096	5	0
1645	24	1097	4	2
1646	24	1098	3	0
1647	24	1099	1	0
1648	24	1100	3	3
1649	24	1101	3	2
1650	24	1102	1	0
1651	24	1103	3	1
1652	24	1105	5	2
1653	24	1106	3	3
1654	24	1107	3	1
1655	24	1108	2	2
1656	25	1006	4	2
1657	25	1007	1	1
1658	25	1008	3	3
1659	25	1009	1	0
1660	25	1011	1	0
1661	25	1012	3	3
1662	25	1013	5	5
1663	25	1014	2	2
1664	25	1016	3	1
1665	25	1017	1	0
1666	25	1018	3	0
1667	25	1019	3	1
1668	25	1020	2	2
1669	25	1021	3	2
1670	25	1022	3	2
1671	25	1024	1	1
1672	25	1025	2	2
1673	25	1026	1	0
1674	25	1027	3	3
1675	25	1028	3	3
1676	25	1029	4	0
1677	25	1030	5	5
1678	25	1031	5	2
1679	25	1032	4	4
1680	25	1033	1	1
1681	25	1034	1	0
1682	25	1035	5	3
1683	25	1036	4	4
1684	25	1037	5	4
1685	25	1038	2	0
1686	25	1039	2	2
1687	25	1041	3	1
1688	25	1042	3	3
1689	25	1044	4	1
1690	25	1045	4	0
1691	26	1125	1	1
1692	26	1126	5	1
1693	26	1127	5	4
1694	26	1128	1	0
1695	26	1129	5	5
1696	26	1131	4	3
1697	26	1133	3	2
1698	26	1135	5	2
1699	26	1136	2	0
1700	26	1137	1	1
1701	26	1138	2	0
1702	26	1140	3	1
1703	26	1141	5	5
1704	26	1142	1	1
1705	26	1143	4	4
1706	26	1144	5	4
1707	26	1145	1	1
1708	26	1149	4	2
1709	26	1150	2	0
1710	26	1152	2	2
1711	26	1153	5	2
1712	26	1154	4	1
1713	26	1155	4	0
1714	26	1156	1	0
1715	26	1157	2	1
1716	26	1158	4	4
1717	26	1160	1	1
1718	26	1161	3	0
1719	26	1162	1	0
1720	26	1163	4	3
1721	26	1165	5	4
1722	26	1166	4	0
1723	26	1168	1	1
1724	26	1169	5	0
1725	26	1171	4	1
1726	26	1172	2	1
1727	26	1173	4	1
1728	26	1174	1	0
1729	26	1175	4	0
1730	26	1176	3	2
1731	26	1178	3	1
1732	26	1179	3	2
1733	26	1180	4	0
1734	26	1181	2	2
1735	26	1183	2	0
1736	26	1184	1	1
1737	26	1185	4	3
1738	26	1187	1	1
1739	26	1188	3	1
1740	26	1189	1	1
1741	26	1190	2	0
1742	26	1192	5	5
1743	26	1194	3	2
1744	26	1195	2	0
1745	26	1196	3	0
1746	26	1198	5	2
1747	26	1199	1	1
1748	26	1200	4	2
1749	26	1201	5	5
1750	26	1202	2	0
1751	26	1203	4	3
1752	26	1204	5	3
1753	26	1205	1	0
1754	26	1206	1	0
1755	26	1207	4	2
1756	26	1208	1	0
1757	26	1209	2	2
1758	26	1211	1	0
1759	26	1212	4	1
1760	26	1213	1	0
1761	26	1214	1	1
1762	26	1215	2	0
1763	26	1216	1	0
1764	26	1217	1	1
1765	26	1218	4	0
1766	26	1219	4	3
1767	26	1220	2	1
1768	26	1221	1	0
1769	26	1222	5	5
1770	27	1125	4	1
1771	27	1126	5	1
1772	27	1130	5	5
1773	27	1131	5	5
1774	27	1132	2	0
1775	27	1134	5	4
1776	27	1135	3	1
1777	27	1136	2	0
1778	27	1137	1	1
1779	27	1138	3	0
1780	27	1139	3	1
1781	27	1140	5	3
1782	27	1141	2	2
1783	27	1143	2	1
1784	27	1144	1	0
1785	27	1146	5	4
1786	27	1147	2	0
1787	27	1148	4	3
1788	27	1149	5	5
1789	27	1150	4	0
1790	27	1151	3	2
1791	27	1152	4	1
1792	27	1153	3	2
1793	27	1155	1	0
1794	27	1157	2	0
1795	27	1158	5	4
1796	27	1160	4	4
1797	27	1161	3	0
1798	27	1162	5	3
1799	27	1163	3	0
1800	27	1164	3	0
1801	27	1165	3	1
1802	27	1166	4	4
1803	27	1167	5	5
1804	27	1169	3	1
1805	27	1170	2	2
1806	27	1171	1	1
1807	27	1172	2	2
1808	27	1175	1	0
1809	27	1176	3	3
1810	27	1177	2	2
1811	27	1178	1	1
1812	27	1179	1	1
1813	27	1181	5	3
1814	27	1184	4	3
1815	27	1185	3	1
1816	27	1186	5	0
1817	27	1188	1	0
1818	27	1189	4	2
1819	27	1192	5	0
1820	27	1193	5	0
1821	27	1194	4	0
1822	27	1196	5	1
1823	27	1197	1	1
1824	27	1199	4	4
1825	27	1200	1	1
1826	27	1201	2	1
1827	27	1204	4	3
1828	27	1205	4	2
1829	27	1206	1	1
1830	27	1207	5	2
1831	27	1209	5	5
1832	27	1210	5	5
1833	27	1213	2	0
1834	27	1214	5	4
1835	27	1216	1	1
1836	27	1217	3	3
1837	27	1218	1	1
1838	27	1219	2	1
1839	27	1220	4	2
1840	27	1221	2	2
1841	27	1222	1	0
1842	27	1223	2	2
1843	27	1224	5	5
1844	28	1125	2	2
1845	28	1126	3	2
1846	28	1127	2	0
1847	28	1128	1	1
1848	28	1129	5	4
1849	28	1130	1	0
1850	28	1134	4	3
1851	28	1135	4	4
1852	28	1137	3	2
1853	28	1138	5	1
1854	28	1139	1	1
1855	28	1140	5	0
1856	28	1141	4	4
1857	28	1142	1	0
1858	28	1143	3	0
1859	28	1144	4	2
1860	28	1145	2	1
1861	28	1146	2	2
1862	28	1147	2	1
1863	28	1148	4	3
1864	28	1149	4	2
1865	28	1150	5	2
1866	28	1152	5	3
1867	28	1153	4	1
1868	28	1154	3	1
1869	28	1155	5	5
1870	28	1156	5	0
1871	28	1157	4	0
1872	28	1158	3	1
1873	28	1159	4	4
1874	28	1160	2	0
1875	28	1161	2	2
1876	28	1162	2	0
1877	28	1163	1	1
1878	28	1164	3	1
1879	28	1165	1	0
1880	28	1166	3	3
1881	28	1167	2	2
1882	28	1168	3	2
1883	28	1169	5	1
1884	28	1170	1	0
1885	28	1171	3	0
1886	28	1172	4	2
1887	28	1173	1	0
1888	28	1174	2	2
1889	28	1175	2	2
1890	28	1176	5	4
1891	28	1177	4	2
1892	28	1178	3	3
1893	28	1180	3	2
1894	28	1181	4	1
1895	28	1182	1	1
1896	28	1183	1	1
1897	28	1184	4	0
1898	28	1185	2	2
1899	28	1186	3	2
1900	28	1187	3	3
1901	28	1188	2	0
1902	28	1189	1	0
1903	28	1190	5	1
1904	28	1191	2	0
1905	28	1192	5	5
1906	28	1194	3	3
1907	28	1195	2	2
1908	28	1196	1	0
1909	28	1197	5	3
1910	28	1198	1	1
1911	28	1199	5	2
1912	28	1200	2	2
1913	28	1201	3	3
1914	28	1202	1	1
1915	28	1203	4	4
1916	28	1204	4	4
1917	28	1205	5	0
1918	28	1206	2	0
1919	28	1207	4	0
1920	28	1208	4	2
1921	28	1209	2	0
1922	28	1210	5	4
1923	28	1211	4	3
1924	28	1212	5	1
1925	28	1213	2	2
1926	28	1214	5	2
1927	28	1216	4	3
1928	28	1217	2	2
1929	28	1218	1	1
1930	28	1219	3	2
1931	28	1220	4	0
1932	28	1222	1	0
1933	29	1226	2	0
1934	29	1227	5	1
1935	29	1228	3	1
1936	29	1229	4	0
1937	29	1230	2	0
1938	29	1231	2	1
1939	29	1232	1	0
1940	29	1233	5	5
1941	29	1234	1	0
1942	29	1236	5	1
1943	29	1238	4	1
1944	29	1239	4	2
1945	29	1241	5	4
1946	29	1242	1	1
1947	29	1244	2	0
1948	29	1245	3	3
1949	29	1246	3	0
1950	29	1248	1	1
1951	29	1249	5	5
1952	29	1251	3	2
1953	29	1252	5	2
1954	29	1253	4	3
1955	29	1254	3	2
1956	29	1255	5	5
1957	29	1257	2	2
1958	29	1258	3	1
1959	29	1259	5	1
1960	29	1261	1	1
1961	29	1262	3	0
1962	29	1263	2	2
1963	29	1264	2	1
1964	29	1265	4	4
1965	29	1266	5	4
1966	29	1268	1	0
1967	30	1225	1	1
1968	30	1226	4	3
1969	30	1227	4	3
1970	30	1228	3	1
1971	30	1229	2	2
1972	30	1230	4	0
1973	30	1231	2	2
1974	30	1232	3	2
1975	30	1233	1	1
1976	30	1234	4	1
1977	30	1235	5	3
1978	30	1236	2	2
1979	30	1237	1	1
1980	30	1238	1	0
1981	30	1239	2	1
1982	30	1241	5	5
1983	30	1242	4	2
1984	30	1243	3	2
1985	30	1244	5	1
1986	30	1245	2	0
1987	30	1246	2	0
1988	30	1247	2	0
1989	30	1248	2	2
1990	30	1249	1	1
1991	30	1250	3	1
1992	30	1251	5	4
1993	30	1252	5	5
1994	30	1253	3	0
1995	30	1254	3	3
1996	30	1256	5	5
1997	30	1257	2	1
1998	30	1258	4	4
1999	30	1259	5	5
2000	30	1260	3	3
2001	30	1261	5	2
2002	30	1262	5	4
2003	30	1263	3	3
2004	30	1264	4	4
2005	30	1266	3	1
2006	30	1267	5	4
2007	30	1268	5	1
2008	30	1269	2	2
2009	30	1270	5	4
2010	30	1271	3	2
2011	30	1272	4	4
2012	30	1273	4	2
2013	30	1274	3	0
2014	30	1275	3	0
2015	30	1276	1	0
2016	30	1277	1	1
2017	30	1278	3	0
2018	30	1279	2	0
2019	30	1280	3	1
2020	30	1281	2	0
2021	30	1282	2	1
2022	30	1283	5	5
2023	30	1284	1	1
2024	30	1286	5	3
2025	30	1287	1	0
2026	30	1288	1	1
2027	30	1289	4	1
2028	30	1290	2	1
2029	30	1291	1	1
2030	30	1292	4	0
2031	30	1293	2	2
2032	30	1295	4	4
2033	30	1296	2	2
2034	30	1297	4	1
2035	30	1298	3	2
2036	30	1299	3	1
2037	30	1300	1	0
2038	30	1301	1	1
2039	30	1303	2	2
2040	30	1304	2	2
2041	30	1306	3	1
2042	30	1308	1	1
2043	30	1310	2	0
2044	30	1311	3	0
2045	30	1312	2	0
2046	30	1313	1	1
2047	30	1314	5	1
2048	30	1315	3	3
2049	30	1316	5	5
2050	30	1317	5	1
2051	30	1318	5	3
2052	30	1319	2	0
2053	30	1320	3	1
2054	30	1323	1	1
2055	31	1333	4	2
2056	31	1334	5	2
2057	31	1335	2	0
2058	31	1336	5	4
2059	31	1338	1	1
2060	31	1339	5	0
2061	31	1340	3	3
2062	31	1341	4	2
2063	31	1342	3	0
2064	31	1343	3	0
2065	31	1344	5	0
2066	31	1345	3	2
2067	31	1346	1	0
2068	31	1347	5	5
2069	31	1349	3	2
2070	31	1350	1	1
2071	31	1351	2	0
2072	31	1353	3	2
2073	31	1354	2	0
2074	31	1357	3	3
2075	31	1359	3	3
2076	31	1360	5	1
2077	31	1361	5	1
2078	31	1362	3	2
2079	31	1363	5	1
2080	31	1365	3	1
2081	31	1366	2	2
2082	31	1370	1	1
2083	31	1371	4	0
2084	31	1372	4	4
2085	31	1374	1	0
2086	31	1375	3	3
2087	31	1376	5	3
2088	31	1377	3	3
2089	31	1378	2	0
2090	31	1379	2	2
2091	31	1380	4	2
2092	31	1381	3	2
2093	31	1382	1	1
2094	31	1383	3	2
2095	31	1384	3	1
2096	31	1385	2	2
2097	31	1386	3	2
2098	31	1388	1	0
2099	31	1389	5	3
2100	31	1390	2	1
2101	31	1391	5	5
2102	31	1392	3	3
2103	31	1393	5	5
2104	31	1394	1	1
2105	31	1395	3	3
2106	31	1396	5	0
2107	31	1397	1	0
2108	31	1399	1	0
2109	31	1400	4	1
2110	31	1402	4	2
2111	31	1403	1	1
2112	31	1404	2	0
2113	31	1405	2	2
2114	31	1406	2	1
2115	31	1407	1	0
2116	31	1408	4	3
2117	31	1409	1	1
2118	31	1410	4	3
2119	31	1411	2	0
2120	31	1412	1	0
2121	31	1413	3	2
2122	31	1414	4	2
2123	31	1415	5	1
2124	31	1417	1	1
2125	31	1420	4	3
2126	31	1421	3	0
2127	31	1422	1	0
2128	31	1424	2	2
2129	31	1425	3	2
2130	31	1426	2	0
2131	31	1427	2	0
2132	31	1428	1	1
2133	31	1429	4	2
2134	31	1430	1	1
2135	31	1431	2	0
2136	31	1432	3	2
2137	31	1433	3	1
2138	31	1434	2	1
2139	31	1435	3	3
2140	31	1436	5	5
2141	31	1437	1	1
2142	32	1333	1	1
2143	32	1335	1	0
2144	32	1336	3	0
2145	32	1337	1	1
2146	32	1338	2	0
2147	32	1339	2	2
2148	32	1341	5	3
2149	32	1342	1	1
2150	32	1343	3	3
2151	32	1344	5	0
2152	32	1346	4	1
2153	32	1347	2	2
2154	32	1348	4	0
2155	32	1349	4	1
2156	32	1350	4	2
2157	32	1351	1	1
2158	32	1353	4	1
2159	32	1354	5	2
2160	32	1355	4	4
2161	32	1356	4	4
2162	32	1357	4	4
2163	32	1358	5	3
2164	32	1359	2	1
2165	32	1361	3	2
2166	32	1362	3	0
2167	32	1363	3	2
2168	32	1364	4	2
2169	32	1365	5	2
2170	32	1366	3	0
2171	32	1367	5	5
2172	32	1368	3	3
2173	32	1369	5	3
2174	32	1370	2	2
2175	32	1371	4	2
2176	32	1372	4	4
2177	32	1373	5	3
2178	32	1374	1	0
2179	32	1375	1	0
2180	32	1376	5	5
2181	32	1377	3	0
2182	32	1378	3	2
2183	32	1379	3	3
2184	32	1381	1	1
2185	32	1384	2	1
2186	32	1385	2	1
2187	33	1443	1	1
2188	33	1444	5	2
2189	33	1445	1	0
2190	33	1446	5	3
2191	33	1447	4	2
2192	33	1449	4	3
2193	33	1450	4	4
2194	33	1452	4	3
2195	33	1453	5	0
2196	33	1454	2	0
2197	33	1455	4	3
2198	33	1456	1	0
2199	33	1457	4	3
2200	33	1458	4	0
2201	33	1459	3	0
2202	33	1460	1	1
2203	33	1461	4	4
2204	33	1462	5	4
2205	33	1463	2	0
2206	33	1464	2	0
2207	33	1465	2	1
2208	33	1466	2	1
2209	33	1467	3	3
2210	33	1469	3	1
2211	33	1471	3	1
2212	33	1474	4	3
2213	33	1475	3	0
2214	33	1476	4	4
2215	33	1477	5	4
2216	33	1478	5	3
2217	33	1479	5	0
2218	33	1481	3	0
2219	33	1482	3	2
2220	33	1483	2	0
2221	33	1485	1	0
2222	33	1486	3	0
2223	33	1487	3	2
2224	33	1488	5	0
2225	33	1491	3	1
2226	33	1492	2	1
2227	33	1493	5	1
2228	33	1494	2	0
2229	33	1495	1	0
2230	33	1496	3	2
2231	33	1497	1	0
2232	33	1498	1	1
2233	33	1499	4	3
2234	33	1500	2	2
2235	33	1501	3	1
2236	33	1502	3	1
2237	33	1503	4	2
2238	33	1504	1	1
2239	33	1505	4	1
2240	33	1506	4	0
2241	33	1507	3	2
2242	33	1508	5	4
2243	33	1509	3	0
2244	33	1510	5	0
2245	33	1511	5	2
2246	33	1512	3	1
2247	33	1513	5	5
2248	33	1514	2	1
2249	33	1515	3	1
2250	33	1516	3	0
2251	33	1517	3	0
2252	33	1518	4	4
2253	33	1519	5	5
2254	33	1520	2	1
2255	33	1521	2	2
2256	33	1522	2	1
2257	33	1524	2	1
2258	34	1443	1	0
2259	34	1445	5	1
2260	34	1446	2	1
2261	34	1447	4	0
2262	34	1448	4	1
2263	34	1449	3	0
2264	34	1450	2	1
2265	34	1451	5	1
2266	34	1452	3	0
2267	34	1453	4	1
2268	34	1454	5	5
2269	34	1455	1	1
2270	34	1456	4	4
2271	34	1457	3	3
2272	34	1458	5	3
2273	34	1459	2	2
2274	34	1460	3	0
2275	34	1461	1	1
2276	34	1462	4	1
2277	34	1463	3	0
2278	34	1464	4	3
2279	34	1465	2	2
2280	34	1466	4	3
2281	34	1467	3	3
2282	34	1470	2	1
2283	34	1471	5	0
2284	34	1472	5	1
2285	34	1473	3	1
2286	34	1474	2	0
2287	34	1475	5	4
2288	34	1476	5	2
2289	34	1477	4	2
2290	34	1478	5	5
2291	34	1479	5	1
2292	34	1480	4	3
2293	34	1481	4	3
2294	34	1482	1	0
2295	34	1483	1	1
2296	34	1484	4	4
2297	34	1485	3	1
2298	34	1486	5	3
2299	34	1487	2	1
2300	34	1489	3	3
2301	34	1490	1	1
2302	34	1491	4	0
2303	34	1492	5	3
2304	34	1493	3	1
2305	34	1494	5	3
2306	34	1495	4	3
2307	34	1496	1	0
2308	34	1498	3	2
2309	34	1499	3	1
2310	34	1500	3	1
2311	34	1501	4	0
2312	34	1502	1	1
2313	34	1503	5	0
2314	34	1504	3	2
2315	34	1505	4	4
2316	34	1506	4	1
2317	34	1508	1	0
2318	34	1509	5	2
2319	34	1511	5	3
2320	34	1512	4	3
2321	34	1513	5	0
2322	34	1514	1	1
2323	34	1515	5	2
2324	34	1517	1	1
2325	34	1518	5	0
2326	34	1519	1	1
2327	34	1521	4	3
2328	34	1522	1	0
2329	34	1523	4	4
2330	34	1524	4	4
2331	34	1525	1	1
2332	34	1526	3	3
2333	34	1527	3	3
2334	34	1528	1	0
2335	34	1529	4	4
2336	34	1530	1	1
2337	34	1531	3	0
2338	34	1532	5	0
2339	34	1533	1	0
2340	34	1534	2	2
2341	34	1535	2	0
2342	34	1536	2	2
2343	34	1538	1	1
2344	34	1540	1	0
2345	35	1443	4	0
2346	35	1445	2	2
2347	35	1446	3	0
2348	35	1447	4	0
2349	35	1448	3	2
2350	35	1449	5	5
2351	35	1450	2	1
2352	35	1451	5	1
2353	35	1452	2	1
2354	35	1453	3	0
2355	35	1455	3	2
2356	35	1457	4	0
2357	35	1458	2	2
2358	35	1460	4	2
2359	35	1461	1	0
2360	35	1462	4	3
2361	35	1464	2	0
2362	35	1465	1	0
2363	35	1466	1	1
2364	35	1467	5	1
2365	35	1468	5	5
2366	35	1469	1	1
2367	35	1470	3	0
2368	35	1472	2	0
2369	35	1473	4	1
2370	35	1474	2	2
2371	35	1475	5	3
2372	35	1476	1	0
2373	35	1477	5	3
2374	35	1478	4	3
2375	35	1479	3	3
2376	35	1480	5	5
2377	35	1481	3	3
2378	35	1482	5	5
2379	35	1483	3	0
2380	35	1486	1	0
2381	35	1488	1	0
2382	35	1490	1	1
2383	36	1545	5	2
2384	36	1547	3	1
2385	36	1548	3	1
2386	36	1549	5	0
2387	36	1550	5	4
2388	36	1551	4	1
2389	36	1552	2	2
2390	36	1553	1	1
2391	36	1555	4	2
2392	36	1556	2	1
2393	36	1557	2	1
2394	36	1558	1	0
2395	36	1560	3	3
2396	36	1561	1	0
2397	36	1562	4	1
2398	36	1563	3	0
2399	36	1564	5	1
2400	36	1565	5	4
2401	36	1567	2	0
2402	36	1568	2	2
2403	36	1569	5	4
2404	36	1570	3	2
2405	36	1571	4	4
2406	36	1572	5	3
2407	36	1573	3	2
2408	36	1574	4	1
2409	36	1575	5	4
2410	36	1576	4	2
2411	36	1577	2	2
2412	36	1578	2	0
2413	36	1579	3	3
2414	36	1580	4	2
2415	36	1581	1	1
2416	36	1582	5	2
2417	36	1583	2	0
2418	36	1584	1	0
2419	36	1586	2	0
2420	36	1588	1	0
2421	36	1589	1	1
2422	36	1590	2	0
2423	36	1591	2	0
2424	36	1592	5	2
2425	36	1593	5	3
2426	36	1594	2	2
2427	36	1595	4	4
2428	37	1545	2	0
2429	37	1546	3	0
2430	37	1547	3	3
2431	37	1548	2	1
2432	37	1549	3	2
2433	37	1550	5	2
2434	37	1551	2	2
2435	37	1554	4	0
2436	37	1555	5	1
2437	37	1556	1	1
2438	37	1557	4	0
2439	37	1558	2	2
2440	37	1559	1	1
2441	37	1560	4	0
2442	37	1562	5	1
2443	37	1563	5	4
2444	37	1565	2	0
2445	37	1567	3	0
2446	37	1569	1	0
2447	37	1570	1	0
2448	37	1571	2	1
2449	37	1572	4	2
2450	37	1573	3	2
2451	37	1574	1	1
2452	37	1575	3	3
2453	37	1576	5	4
2454	37	1578	5	4
2455	37	1580	4	2
2456	37	1582	4	3
2457	37	1583	4	4
2458	37	1585	2	0
2459	37	1587	3	1
2460	37	1588	4	1
2461	37	1590	5	2
2462	37	1591	1	1
2463	37	1593	5	1
2464	37	1594	3	3
2465	37	1595	5	1
2466	37	1596	1	0
2467	37	1597	4	0
2468	37	1598	1	0
2469	37	1599	5	2
2470	37	1602	3	3
2471	37	1603	2	1
2472	37	1604	1	0
2473	38	1657	2	0
2474	38	1659	4	0
2475	38	1662	4	4
2476	38	1663	5	0
2477	38	1664	1	0
2478	38	1666	2	2
2479	38	1668	4	0
2480	38	1669	5	4
2481	38	1670	2	0
2482	38	1671	2	1
2483	38	1672	1	1
2484	38	1673	1	1
2485	38	1675	3	0
2486	38	1676	2	2
2487	38	1677	1	1
2488	38	1680	4	3
2489	38	1682	3	2
2490	38	1683	2	1
2491	38	1684	4	4
2492	38	1685	5	1
2493	38	1686	3	1
2494	38	1688	5	3
2495	38	1689	1	0
2496	38	1690	4	4
2497	38	1692	2	0
2498	38	1693	3	0
2499	38	1694	1	0
2500	38	1695	3	3
2501	38	1696	3	1
2502	38	1697	5	1
2503	38	1698	4	1
2504	38	1699	3	0
2505	38	1700	2	2
2506	38	1703	3	3
2507	38	1704	1	0
2508	38	1705	4	0
2509	38	1706	3	0
2510	38	1707	3	3
2511	38	1709	3	0
2512	38	1710	4	3
2513	38	1711	3	0
2514	38	1712	1	1
2515	38	1713	2	2
2516	38	1714	3	2
2517	38	1715	5	4
2518	38	1716	1	0
2519	38	1717	1	1
2520	38	1718	5	5
2521	38	1719	5	1
2522	38	1721	2	0
2523	38	1722	3	1
2524	38	1723	5	3
2525	38	1724	3	3
2526	38	1725	1	0
2527	38	1726	5	4
2528	38	1727	1	1
2529	38	1728	2	1
2530	38	1729	3	1
2531	38	1730	3	3
2532	38	1731	4	3
2533	38	1732	4	3
2534	38	1733	3	1
2535	38	1739	1	1
2536	38	1740	5	1
2537	38	1741	1	1
2538	38	1742	4	3
2539	38	1744	2	2
2540	38	1745	2	1
2541	38	1747	4	4
2542	38	1748	4	2
2543	38	1749	4	2
2544	38	1750	1	0
2545	38	1752	3	3
2546	38	1753	2	1
2547	38	1754	3	3
2548	38	1755	1	0
2549	38	1756	1	1
2550	38	1757	1	0
2551	38	1758	3	3
2552	38	1760	2	0
2553	39	1657	2	1
2554	39	1659	2	1
2555	39	1660	3	0
2556	39	1661	4	2
2557	39	1662	4	3
2558	39	1663	4	2
2559	39	1665	5	1
2560	39	1666	2	0
2561	39	1668	1	1
2562	39	1669	5	4
2563	39	1670	1	1
2564	39	1672	1	1
2565	39	1674	1	0
2566	39	1675	2	1
2567	39	1677	5	5
2568	39	1678	2	1
2569	39	1679	1	1
2570	39	1680	2	2
2571	39	1682	2	1
2572	39	1683	5	3
2573	39	1684	5	1
2574	39	1685	4	3
2575	39	1687	3	1
2576	39	1688	3	2
2577	39	1689	1	0
2578	39	1692	2	1
2579	39	1693	1	0
2580	39	1694	3	0
2581	39	1695	1	1
2582	39	1696	2	1
2583	39	1697	5	0
2584	39	1699	1	1
2585	39	1700	2	0
2586	39	1701	4	3
2587	39	1702	1	0
2588	39	1703	3	1
2589	39	1704	3	3
2590	39	1705	5	5
2591	39	1706	5	3
2592	39	1707	3	1
2593	39	1708	3	2
2594	39	1709	5	4
2595	39	1710	3	1
2596	39	1711	5	5
2597	39	1712	5	3
2598	39	1713	3	2
2599	39	1715	3	2
2600	39	1716	3	3
2601	39	1718	4	2
2602	39	1719	2	0
2603	39	1720	3	2
2604	39	1721	5	5
2605	39	1722	1	1
2606	39	1723	4	4
2607	39	1724	2	1
2608	39	1725	1	1
2609	39	1726	5	1
2610	39	1727	2	2
2611	39	1728	4	1
2612	39	1729	4	1
2613	39	1730	1	0
2614	39	1731	5	3
2615	39	1732	4	3
2616	39	1733	4	1
2617	39	1734	1	1
2618	39	1736	1	1
2619	39	1737	2	0
2620	39	1738	1	0
2621	39	1739	1	1
2622	39	1740	5	0
2623	39	1741	2	1
2624	39	1742	3	0
2625	39	1743	1	0
2626	39	1745	4	0
2627	39	1747	3	1
2628	39	1748	1	1
2629	39	1749	1	1
2630	39	1750	2	2
2631	39	1751	1	1
2632	39	1752	5	3
2633	39	1753	3	3
2634	39	1754	4	1
2635	39	1755	4	0
2636	39	1757	1	1
2637	39	1758	2	1
2638	39	1759	3	0
2639	39	1760	1	1
2640	40	1761	5	4
2641	40	1762	2	2
2642	40	1763	1	1
2643	40	1764	4	0
2644	40	1766	2	2
2645	40	1767	2	0
2646	40	1768	5	4
2647	40	1769	3	0
2648	40	1770	5	3
2649	40	1771	4	2
2650	40	1772	3	2
2651	40	1773	3	0
2652	40	1774	4	1
2653	40	1775	1	1
2654	40	1776	4	2
2655	40	1777	1	0
2656	40	1778	3	3
2657	40	1779	3	3
2658	40	1780	4	0
2659	40	1781	2	2
2660	40	1785	1	1
2661	40	1786	3	1
2662	40	1787	5	3
2663	40	1788	3	0
2664	40	1790	1	0
2665	40	1791	1	0
2666	40	1792	5	4
2667	40	1793	5	5
2668	40	1794	1	1
2669	40	1795	4	3
2670	40	1796	5	2
2671	40	1797	2	2
2672	40	1798	1	1
2673	40	1799	3	3
2674	40	1801	2	1
2675	40	1802	3	0
2676	40	1803	5	5
2677	40	1804	5	2
2678	41	1761	5	4
2679	41	1762	1	1
2680	41	1763	3	0
2681	41	1764	5	5
2682	41	1765	4	3
2683	41	1766	5	0
2684	41	1767	3	1
2685	41	1768	5	4
2686	41	1769	2	1
2687	41	1770	4	4
2688	41	1772	5	1
2689	41	1773	1	0
2690	41	1774	2	0
2691	41	1775	5	0
2692	41	1776	3	0
2693	41	1777	5	5
2694	41	1778	5	1
2695	41	1779	2	2
2696	41	1780	1	1
2697	41	1781	1	1
2698	41	1782	4	4
2699	41	1783	4	1
2700	41	1784	2	2
2701	41	1785	5	1
2702	41	1786	5	5
2703	41	1788	4	1
2704	41	1789	1	1
2705	41	1790	2	0
2706	41	1791	5	1
2707	41	1792	4	0
2708	41	1793	2	0
2709	41	1795	2	0
2710	42	1761	4	4
2711	42	1762	3	1
2712	42	1763	3	3
2713	42	1765	1	1
2714	42	1766	1	0
2715	42	1767	4	3
2716	42	1769	4	4
2717	42	1770	1	0
2718	42	1771	4	1
2719	42	1772	4	2
2720	42	1773	4	3
2721	42	1774	4	0
2722	42	1775	3	0
2723	42	1776	2	1
2724	42	1777	3	2
2725	42	1778	2	1
2726	42	1779	1	1
2727	42	1781	2	0
2728	42	1782	1	1
2729	42	1783	3	0
2730	42	1784	3	2
2731	42	1785	1	1
2732	42	1786	5	0
2733	42	1787	4	1
2734	42	1788	5	2
2735	42	1789	5	3
2736	42	1790	1	1
2737	42	1791	3	3
2738	42	1792	1	0
2739	42	1793	2	1
2740	42	1794	5	4
2741	42	1796	4	1
2742	42	1797	3	3
2743	42	1799	4	4
2744	42	1800	5	2
2745	42	1801	1	1
2746	42	1803	2	0
2747	42	1804	5	4
2748	42	1805	4	2
2749	42	1806	1	1
2750	42	1807	3	3
2751	42	1808	5	4
2752	42	1809	3	3
2753	42	1810	4	1
2754	42	1811	5	3
2755	42	1815	5	1
2756	42	1816	3	0
2757	42	1818	2	1
2758	42	1819	4	4
2759	42	1820	1	0
2760	42	1821	2	0
2761	42	1822	1	1
2762	42	1823	3	1
2763	42	1824	1	0
2764	42	1826	4	4
2765	42	1827	5	4
2766	42	1828	2	1
2767	42	1831	2	2
2768	42	1832	2	2
2769	42	1833	3	0
2770	42	1834	2	1
2771	42	1835	2	1
2772	42	1836	2	1
2773	42	1837	3	0
2774	42	1838	5	0
2775	42	1839	5	3
2776	42	1840	4	0
2777	42	1841	5	5
2778	42	1842	3	0
2779	43	1844	3	1
2780	43	1845	2	1
2781	43	1846	2	2
2782	43	1847	3	2
2783	43	1848	5	3
2784	43	1849	2	0
2785	43	1850	2	0
2786	43	1851	2	2
2787	43	1852	2	2
2788	43	1853	1	0
2789	43	1854	4	4
2790	43	1855	5	3
2791	43	1857	1	0
2792	43	1858	1	0
2793	43	1859	1	1
2794	43	1860	2	2
2795	43	1861	3	0
2796	43	1862	2	0
2797	43	1863	5	2
2798	43	1866	5	1
2799	43	1868	1	1
2800	43	1870	5	5
2801	43	1871	3	3
2802	43	1872	3	3
2803	43	1873	4	0
2804	43	1874	1	0
2805	43	1875	5	2
2806	43	1876	2	2
2807	43	1877	5	5
2808	43	1878	3	3
2809	43	1879	1	0
2810	43	1880	5	0
2811	43	1881	5	0
2812	43	1882	3	2
2813	43	1883	2	2
2814	43	1884	4	4
2815	43	1885	1	1
2816	43	1886	3	2
2817	43	1887	3	1
2818	43	1888	2	0
2819	43	1889	3	2
2820	43	1890	2	2
2821	43	1891	3	0
2822	43	1892	1	0
2823	43	1893	5	0
2824	43	1895	5	3
2825	43	1896	2	0
2826	43	1897	4	2
2827	43	1899	2	1
2828	43	1900	4	1
2829	43	1901	4	3
2830	43	1902	2	1
2831	43	1903	3	0
2832	43	1904	3	3
2833	43	1905	5	2
2834	43	1906	4	3
2835	43	1907	4	1
2836	43	1908	1	1
2837	43	1911	4	1
2838	43	1912	1	0
2839	43	1916	2	0
2840	43	1918	5	5
2841	43	1919	4	0
2842	43	1920	3	0
2843	43	1921	5	5
2844	43	1922	3	2
2845	43	1924	2	0
2846	43	1925	2	2
2847	43	1926	2	1
2848	43	1927	5	0
2849	43	1928	4	2
2850	43	1929	1	0
2851	43	1930	4	1
2852	43	1931	3	2
2853	43	1932	2	2
2854	43	1933	2	2
2855	43	1934	2	1
2856	43	1935	3	3
2857	43	1936	2	0
2858	43	1937	5	5
2859	43	1938	5	0
2860	43	1939	2	2
2861	43	1940	1	0
2862	43	1942	5	3
2863	43	1944	2	2
2864	43	1945	5	4
2865	43	1946	4	1
2866	43	1947	4	4
2867	43	1948	1	0
2868	43	1950	2	1
2869	44	1845	3	1
2870	44	1846	2	1
2871	44	1847	5	3
2872	44	1848	1	0
2873	44	1849	4	1
2874	44	1850	1	0
2875	44	1852	1	1
2876	44	1853	2	1
2877	44	1855	2	2
2878	44	1856	2	1
2879	44	1858	5	4
2880	44	1859	2	0
2881	44	1860	4	1
2882	44	1862	2	2
2883	44	1863	5	0
2884	44	1864	5	1
2885	44	1865	1	0
2886	44	1866	5	4
2887	44	1867	5	1
2888	44	1868	5	5
2889	44	1869	5	4
2890	44	1870	2	2
2891	44	1871	2	1
2892	44	1872	2	0
2893	44	1873	4	4
2894	44	1875	1	1
2895	44	1876	5	1
2896	44	1878	4	4
2897	44	1879	4	0
2898	44	1880	3	1
2899	44	1881	3	3
2900	44	1882	4	1
2901	44	1883	1	1
2902	44	1884	4	0
2903	44	1885	5	0
2904	44	1886	4	4
2905	44	1887	2	2
2906	44	1888	3	3
2907	44	1890	3	0
2908	44	1891	2	2
2909	44	1892	4	3
2910	44	1893	1	1
2911	44	1894	3	3
2912	44	1895	4	0
2913	44	1896	5	0
2914	44	1897	4	0
2915	44	1899	2	2
2916	44	1901	5	0
2917	44	1902	1	0
2918	44	1903	5	0
2919	44	1904	2	1
2920	44	1905	4	0
2921	44	1907	1	0
2922	44	1908	1	1
2923	44	1909	5	5
2924	44	1911	3	3
2925	44	1912	5	5
2926	44	1913	2	2
2927	44	1916	1	0
2928	44	1917	3	3
2929	44	1918	5	0
2930	44	1919	4	0
2931	44	1920	3	2
2932	44	1921	2	1
2933	44	1922	1	1
2934	44	1923	1	0
2935	44	1924	2	1
2936	44	1926	2	0
2937	44	1928	4	2
2938	44	1930	4	2
2939	44	1931	4	3
2940	44	1933	3	3
2941	44	1934	1	1
2942	44	1935	5	2
2943	44	1936	2	1
2944	44	1937	2	0
2945	44	1938	3	3
2946	44	1940	4	4
2947	44	1942	3	1
2948	44	1944	5	5
2949	44	1945	4	0
2950	44	1946	5	4
2951	44	1947	4	2
2952	44	1948	4	3
2953	44	1949	4	3
2954	44	1950	4	1
2955	44	1951	1	1
2956	45	1953	5	5
2957	45	1954	3	0
2958	45	1955	3	2
2959	45	1956	5	2
2960	45	1957	2	2
2961	45	1958	1	0
2962	45	1959	3	0
2963	45	1961	1	0
2964	45	1962	5	5
2965	45	1963	4	3
2966	45	1964	1	0
2967	45	1965	1	0
2968	45	1968	3	3
2969	45	1969	1	0
2970	45	1970	4	1
2971	45	1971	4	1
2972	45	1972	2	1
2973	45	1973	5	4
2974	45	1974	2	0
2975	45	1976	3	3
2976	45	1977	4	1
2977	45	1978	2	1
2978	45	1979	4	0
2979	45	1981	5	2
2980	45	1982	1	0
2981	45	1985	4	2
2982	45	1986	3	3
2983	45	1987	3	1
2984	45	1988	4	2
2985	45	1989	5	5
2986	45	1990	5	2
2987	45	1992	5	2
2988	45	1994	5	3
2989	45	1995	5	4
2990	45	1996	2	1
2991	45	1997	1	0
2992	45	1998	5	0
2993	45	1999	5	4
2994	45	2000	4	3
2995	45	2001	1	0
2996	45	2002	5	3
2997	45	2003	5	1
2998	45	2004	4	4
2999	45	2006	5	3
3000	45	2007	5	1
3001	45	2008	2	2
3002	45	2009	5	5
3003	45	2010	5	5
3004	45	2012	4	4
3005	45	2013	2	1
3006	45	2018	5	1
3007	45	2019	3	3
3008	45	2020	3	1
3009	45	2023	4	0
3010	45	2024	3	2
3011	45	2025	4	2
3012	45	2026	3	0
3013	45	2028	2	2
3014	45	2029	2	2
3015	45	2030	5	2
3016	45	2031	1	0
3017	45	2032	5	1
3018	45	2033	2	0
3019	45	2034	4	3
3020	45	2035	5	0
3021	45	2036	2	0
3022	45	2037	3	1
3023	45	2038	5	4
3024	45	2040	5	5
3025	45	2041	2	0
3026	45	2042	5	5
3027	46	1952	4	3
3028	46	1953	4	2
3029	46	1955	1	1
3030	46	1956	1	0
3031	46	1959	4	3
3032	46	1960	3	2
3033	46	1961	1	1
3034	46	1962	4	4
3035	46	1964	3	0
3036	46	1965	4	0
3037	46	1967	3	3
3038	46	1968	5	1
3039	46	1970	5	2
3040	46	1971	4	2
3041	46	1972	3	1
3042	46	1973	3	0
3043	46	1974	2	1
3044	46	1975	1	1
3045	46	1976	3	3
3046	46	1977	4	1
3047	46	1978	4	3
3048	46	1979	1	0
3049	46	1980	4	3
3050	46	1981	1	1
3051	46	1982	4	4
3052	46	1984	5	2
3053	46	1986	3	0
3054	46	1988	4	1
3055	46	1989	1	1
3056	46	1992	2	0
3057	46	1993	1	0
3058	46	1994	1	1
3059	46	1995	4	0
3060	46	1996	1	1
3061	46	1997	3	1
3062	46	1998	4	0
3063	46	1999	1	1
3064	46	2000	3	2
3065	46	2001	5	5
3066	46	2002	5	2
3067	46	2003	3	1
3068	46	2004	1	0
3069	46	2005	1	0
3070	46	2006	3	2
3071	46	2007	4	1
3072	46	2008	4	1
3073	46	2009	5	1
3074	46	2010	3	0
3075	46	2011	3	0
3076	46	2012	5	3
3077	46	2015	1	1
3078	46	2016	5	1
3079	46	2017	4	1
3080	46	2018	5	4
3081	46	2019	4	3
3082	46	2020	2	2
3083	46	2021	5	3
3084	46	2022	2	0
3085	46	2023	2	0
3086	46	2024	3	1
3087	46	2025	3	0
3088	46	2026	5	3
3089	46	2027	1	1
3090	46	2028	5	5
3091	46	2029	4	0
3092	46	2030	1	0
3093	46	2032	5	3
3094	46	2033	2	0
3095	46	2034	2	0
3096	46	2035	1	0
3097	46	2036	2	2
3098	46	2037	3	3
3099	46	2038	2	1
3100	46	2039	1	1
3101	46	2040	2	2
3102	46	2041	5	0
3103	46	2042	4	1
3104	47	1952	5	3
3105	47	1953	5	2
3106	47	1954	5	1
3107	47	1955	4	3
3108	47	1956	5	0
3109	47	1957	1	1
3110	47	1959	1	0
3111	47	1960	2	1
3112	47	1961	3	2
3113	47	1962	1	1
3114	47	1963	4	4
3115	47	1965	2	2
3116	47	1966	2	2
3117	47	1967	3	0
3118	47	1968	4	0
3119	47	1969	4	2
3120	47	1971	1	0
3121	47	1972	3	1
3122	47	1973	3	2
3123	47	1974	3	0
3124	47	1975	2	1
3125	47	1976	2	2
3126	47	1977	2	2
3127	47	1978	3	0
3128	47	1979	3	3
3129	47	1981	2	0
3130	47	1982	5	1
3131	47	1983	4	2
3132	47	1986	3	1
3133	47	1988	1	0
3134	47	1989	2	0
3135	47	1990	2	2
3136	47	1991	3	3
3137	47	1993	3	3
3138	47	1994	2	1
3139	47	1995	2	0
3140	47	1997	1	1
3141	48	2043	4	0
3142	48	2044	5	5
3143	48	2045	2	0
3144	48	2046	4	3
3145	48	2047	1	0
3146	48	2048	3	1
3147	48	2050	3	3
3148	48	2051	2	0
3149	48	2052	2	2
3150	48	2053	4	2
3151	48	2054	5	1
3152	48	2056	5	5
3153	48	2058	1	1
3154	48	2059	4	0
3155	48	2061	3	2
3156	48	2062	5	3
3157	48	2063	3	3
3158	48	2064	3	2
3159	48	2065	2	1
3160	48	2066	1	1
3161	48	2067	5	2
3162	48	2068	2	0
3163	48	2070	2	2
3164	48	2071	3	3
3165	48	2073	2	0
3166	48	2074	2	0
3167	48	2075	2	1
3168	48	2076	3	0
3169	48	2077	3	0
3170	48	2078	3	3
3171	48	2079	4	2
3172	48	2081	4	3
3173	48	2082	4	4
3174	48	2083	1	1
3175	48	2084	2	1
3176	48	2085	4	4
3177	48	2087	5	1
3178	48	2088	1	0
3179	48	2090	2	1
3180	48	2091	2	2
3181	48	2092	1	0
3182	48	2093	3	1
3183	48	2094	1	0
3184	48	2095	2	2
3185	48	2096	5	1
3186	48	2097	1	1
3187	48	2098	5	0
3188	48	2099	4	0
3189	48	2100	5	4
3190	48	2101	2	0
3191	48	2102	5	3
3192	48	2104	1	0
3193	48	2105	3	0
3194	48	2106	5	5
3195	48	2107	1	1
3196	48	2108	5	0
3197	48	2109	1	1
3198	48	2110	1	1
3199	48	2111	4	3
3200	48	2112	2	0
3201	48	2113	3	3
3202	48	2114	4	0
3203	48	2115	1	1
3204	48	2116	4	1
3205	48	2117	3	1
3206	48	2118	2	2
3207	48	2119	1	1
3208	48	2120	4	4
3209	48	2121	2	1
3210	48	2123	1	0
3211	48	2124	5	3
3212	48	2125	1	1
3213	48	2126	5	2
3214	48	2127	1	1
3215	49	2043	3	1
3216	49	2045	4	1
3217	49	2047	5	1
3218	49	2049	3	2
3219	49	2050	5	2
3220	49	2052	3	1
3221	49	2053	3	0
3222	49	2054	4	4
3223	49	2055	4	2
3224	49	2056	3	0
3225	49	2057	4	0
3226	49	2058	1	1
3227	49	2059	5	4
3228	49	2060	5	4
3229	49	2061	1	0
3230	49	2063	5	2
3231	49	2064	3	1
3232	49	2065	1	1
3233	49	2066	5	1
3234	49	2068	4	3
3235	49	2069	2	0
3236	49	2070	5	3
3237	49	2071	2	2
3238	49	2072	3	2
3239	49	2073	5	3
3240	49	2074	1	0
3241	49	2075	4	0
3242	49	2076	1	0
3243	49	2077	1	0
3244	49	2078	3	1
3245	49	2079	3	2
3246	49	2080	4	0
3247	49	2081	3	3
3248	49	2082	3	3
3249	49	2083	2	0
3250	49	2084	1	1
3251	49	2085	2	0
3252	49	2086	1	1
3253	49	2088	4	3
3254	49	2090	5	1
3255	49	2092	2	1
3256	49	2093	4	0
3257	49	2094	4	1
3258	49	2095	1	0
3259	49	2096	3	0
3260	49	2097	1	0
3261	49	2098	1	0
3262	49	2100	4	2
3263	49	2101	5	3
3264	49	2102	1	0
3265	49	2104	3	1
3266	49	2105	3	2
3267	49	2106	3	1
3268	49	2107	4	4
3269	49	2108	3	2
3270	49	2109	3	1
3271	49	2110	1	0
3272	49	2111	5	4
3273	49	2112	1	0
3274	49	2113	5	3
3275	49	2114	1	0
3276	49	2115	2	2
3277	49	2117	3	3
3278	49	2118	4	4
3279	49	2119	1	1
3280	49	2120	3	0
3281	49	2121	2	1
3282	49	2122	3	3
3283	49	2123	3	2
3284	49	2124	2	1
3285	49	2126	1	0
3286	49	2127	3	3
3287	49	2128	5	3
3288	49	2131	4	3
3289	49	2132	3	2
3290	49	2133	5	4
3291	49	2134	5	5
3292	49	2135	1	0
3293	49	2136	5	3
3294	49	2137	1	1
3295	49	2138	2	2
3296	49	2140	3	2
3297	49	2142	2	2
3298	49	2143	2	1
3299	49	2144	4	4
3300	49	2145	3	0
3301	49	2146	3	1
3302	49	2148	5	4
3303	50	2043	3	1
3304	50	2044	4	4
3305	50	2045	1	0
3306	50	2046	2	0
3307	50	2047	5	1
3308	50	2048	4	1
3309	50	2049	4	4
3310	50	2050	5	5
3311	50	2051	5	1
3312	50	2052	3	3
3313	50	2053	3	3
3314	50	2054	1	1
3315	50	2055	2	0
3316	50	2056	3	1
3317	50	2057	2	1
3318	50	2058	1	1
3319	50	2059	2	0
3320	50	2061	3	0
3321	50	2063	5	1
3322	50	2064	4	2
3323	50	2065	3	3
3324	50	2066	3	0
3325	50	2067	5	3
3326	50	2069	5	4
3327	50	2070	5	4
3328	50	2071	2	0
3329	50	2072	3	1
3330	50	2073	1	1
3331	50	2074	2	2
3332	50	2076	2	2
3333	50	2078	4	0
3334	50	2079	5	5
3335	50	2080	1	0
3336	50	2082	1	0
3337	50	2083	1	0
3338	50	2085	3	2
3339	50	2086	5	2
3340	50	2088	4	2
3341	50	2089	4	3
3342	50	2090	5	0
3343	50	2091	4	2
3344	50	2092	2	1
3345	50	2093	1	1
3346	50	2094	2	1
3347	50	2095	5	1
3348	50	2096	1	0
3349	50	2097	4	2
3350	50	2098	1	0
3351	50	2099	3	2
3352	50	2100	1	0
3353	50	2101	1	1
3354	50	2102	1	1
3355	50	2103	4	0
3356	50	2104	5	4
3357	50	2105	4	1
3358	50	2106	4	3
3359	50	2107	5	0
3360	50	2108	1	0
3361	50	2109	1	0
3362	50	2111	1	0
3363	50	2112	5	5
3364	50	2114	4	2
3365	50	2115	4	0
3366	50	2116	5	0
3367	50	2117	3	2
3368	50	2118	3	2
3369	50	2119	3	3
3370	50	2120	5	2
3371	50	2121	1	1
3372	50	2122	5	4
3373	50	2123	1	1
3374	50	2124	1	1
3375	50	2125	1	1
3376	50	2126	3	3
3377	50	2127	3	2
3378	50	2128	2	2
3379	50	2129	2	0
3380	50	2130	1	0
3381	50	2131	3	2
3382	50	2132	2	1
3383	50	2133	4	4
3384	50	2135	4	1
3385	50	2136	3	2
3386	50	2137	3	1
3387	50	2138	4	1
3388	50	2139	5	2
3389	50	2140	1	0
3390	50	2141	1	0
3391	50	2142	5	0
3392	50	2143	4	4
3393	50	2144	2	2
3394	50	2146	1	0
3395	50	2147	2	0
3396	50	2148	1	0
3397	50	2149	2	1
3398	51	2158	1	0
3399	51	2159	1	0
3400	51	2160	1	1
3401	51	2161	5	5
3402	51	2162	2	0
3403	51	2163	1	1
3404	51	2164	2	0
3405	51	2165	5	4
3406	51	2166	1	1
3407	51	2167	3	2
3408	51	2168	5	0
3409	51	2169	2	0
3410	51	2170	2	0
3411	51	2171	1	0
3412	51	2173	5	3
3413	51	2174	2	0
3414	51	2175	5	1
3415	51	2176	1	0
3416	51	2178	1	1
3417	51	2179	4	3
3418	51	2180	2	1
3419	51	2181	3	0
3420	51	2182	5	0
3421	51	2186	2	0
3422	51	2187	5	4
3423	51	2188	5	5
3424	51	2189	5	0
3425	51	2190	2	0
3426	51	2191	3	2
3427	51	2192	1	0
3428	51	2193	1	1
3429	51	2194	5	4
3430	51	2195	5	1
3431	51	2196	3	1
3432	51	2197	4	2
3433	51	2198	1	1
3434	51	2199	3	3
3435	51	2200	5	3
3436	51	2201	2	2
3437	51	2202	4	1
3438	51	2204	2	0
3439	51	2205	2	1
3440	51	2206	5	1
3441	51	2207	4	2
3442	51	2209	4	2
3443	51	2210	4	2
3444	51	2211	4	1
3445	51	2212	1	1
3446	51	2214	2	2
3447	51	2215	1	0
3448	51	2216	4	0
3449	51	2217	3	3
3450	51	2218	2	1
3451	52	2158	5	2
3452	52	2159	5	0
3453	52	2160	1	1
3454	52	2161	2	2
3455	52	2162	5	0
3456	52	2164	5	5
3457	52	2165	1	0
3458	52	2166	1	1
3459	52	2167	5	2
3460	52	2168	4	0
3461	52	2169	1	0
3462	52	2170	4	0
3463	52	2171	2	0
3464	52	2172	2	2
3465	52	2173	2	2
3466	52	2174	4	2
3467	52	2175	4	4
3468	52	2176	3	0
3469	52	2177	1	0
3470	52	2179	4	4
3471	52	2180	5	3
3472	52	2181	3	0
3473	52	2182	3	3
3474	52	2183	5	1
3475	52	2184	5	3
3476	52	2185	2	1
3477	52	2186	3	2
3478	52	2187	3	0
3479	52	2188	3	2
3480	52	2189	1	0
3481	52	2190	4	2
3482	52	2192	3	1
3483	52	2193	4	1
3484	52	2194	4	4
3485	52	2195	5	1
3486	52	2196	5	3
3487	52	2197	4	2
3488	53	2158	4	3
3489	53	2160	1	1
3490	53	2161	3	3
3491	53	2162	3	0
3492	53	2163	4	2
3493	53	2164	3	0
3494	53	2165	4	1
3495	53	2166	1	0
3496	53	2168	4	3
3497	53	2169	2	0
3498	53	2170	1	1
3499	53	2171	3	2
3500	53	2172	4	0
3501	53	2173	1	0
3502	53	2174	1	0
3503	53	2175	1	0
3504	53	2176	2	2
3505	53	2177	5	1
3506	53	2179	1	0
3507	53	2180	4	3
3508	53	2182	3	3
3509	53	2183	3	3
3510	53	2185	2	2
3511	53	2186	2	1
3512	53	2187	3	2
3513	53	2189	5	0
3514	53	2190	3	0
3515	53	2191	1	1
3516	53	2192	4	1
3517	53	2193	1	0
3518	53	2195	1	1
3519	53	2196	2	0
3520	53	2197	3	0
3521	53	2199	1	0
3522	53	2200	2	0
3523	53	2201	5	4
3524	53	2202	2	2
3525	53	2203	3	2
3526	53	2204	5	4
3527	53	2205	2	1
3528	53	2206	5	2
3529	53	2207	2	0
3530	53	2208	4	2
3531	53	2210	3	0
3532	53	2212	1	1
3533	53	2214	5	3
3534	53	2215	5	5
3535	53	2216	5	5
3536	53	2217	4	3
3537	53	2218	2	2
3538	53	2219	1	1
3539	53	2220	2	0
3540	53	2221	5	2
3541	53	2222	1	1
3542	53	2223	4	2
3543	53	2224	2	0
3544	53	2226	5	5
3545	53	2227	1	0
3546	53	2229	3	1
3547	53	2230	3	3
3548	53	2231	5	2
3549	53	2232	2	0
3550	53	2233	1	0
3551	53	2235	2	0
3552	53	2236	1	1
3553	53	2237	2	1
3554	53	2238	1	0
3555	53	2239	4	3
3556	53	2240	3	3
3557	54	2272	4	1
3558	54	2274	4	2
3559	54	2276	5	4
3560	54	2277	1	0
3561	54	2278	4	0
3562	54	2279	1	0
3563	54	2280	5	0
3564	54	2281	2	1
3565	54	2282	3	0
3566	54	2283	2	1
3567	54	2284	5	4
3568	54	2285	1	0
3569	54	2286	4	1
3570	54	2287	5	4
3571	54	2288	1	0
3572	54	2289	5	0
3573	54	2290	5	0
3574	54	2291	5	2
3575	54	2292	2	2
3576	54	2294	1	0
3577	54	2295	3	3
3578	54	2296	3	0
3579	54	2297	5	4
3580	54	2298	1	0
3581	54	2300	4	0
3582	54	2301	2	2
3583	54	2302	1	1
3584	54	2303	2	1
3585	54	2304	3	3
3586	54	2305	1	1
3587	54	2306	4	3
3588	54	2307	4	1
3589	54	2308	4	0
3590	54	2309	2	1
3591	54	2310	5	1
3592	54	2311	3	0
3593	54	2313	5	2
3594	54	2315	5	5
3595	54	2317	3	2
3596	54	2318	5	3
3597	54	2320	4	3
3598	54	2321	4	1
3599	54	2322	3	2
3600	54	2323	3	2
3601	54	2324	5	5
3602	54	2325	4	2
3603	54	2326	5	2
3604	54	2328	1	1
3605	54	2329	3	3
3606	54	2330	2	0
3607	54	2332	1	0
3608	54	2333	4	2
3609	54	2334	3	3
3610	54	2335	4	0
3611	54	2336	5	2
3612	54	2337	2	2
3613	54	2338	5	0
3614	54	2339	4	1
3615	54	2340	1	1
3616	54	2341	3	2
3617	54	2342	2	1
3618	54	2344	1	1
3619	54	2345	1	1
3620	54	2346	4	4
3621	54	2348	4	2
3622	54	2349	1	1
3623	54	2350	3	1
3624	54	2351	5	2
3625	54	2352	1	1
3626	54	2353	1	0
3627	54	2354	5	0
3628	54	2356	3	1
3629	54	2357	3	2
3630	54	2359	4	0
3631	54	2360	3	0
3632	54	2362	4	2
3633	54	2364	5	3
3634	54	2365	1	1
3635	54	2366	5	1
3636	55	2272	4	0
3637	55	2273	1	1
3638	55	2274	5	4
3639	55	2275	3	3
3640	55	2276	5	0
3641	55	2277	3	0
3642	55	2278	3	0
3643	55	2279	2	0
3644	55	2280	1	0
3645	55	2281	3	3
3646	55	2282	4	1
3647	55	2284	2	0
3648	55	2285	3	3
3649	55	2286	5	0
3650	55	2287	3	1
3651	55	2288	3	0
3652	55	2289	4	3
3653	55	2290	4	4
3654	55	2292	3	2
3655	55	2293	1	0
3656	55	2294	4	1
3657	55	2295	4	0
3658	55	2296	5	0
3659	55	2297	2	1
3660	55	2299	2	2
3661	55	2300	1	1
3662	55	2302	1	1
3663	55	2303	1	0
3664	55	2304	4	4
3665	55	2305	1	0
3666	55	2307	3	1
3667	55	2308	4	4
3668	55	2309	3	2
3669	55	2311	1	1
3670	55	2312	3	3
3671	55	2313	4	3
3672	55	2314	5	5
3673	55	2316	4	4
3674	55	2317	1	1
3675	55	2318	4	4
3676	55	2320	5	1
3677	55	2321	3	0
3678	55	2323	1	1
3679	55	2326	5	1
3680	55	2328	2	2
3681	55	2329	3	1
3682	55	2331	3	1
3683	55	2333	4	2
3684	55	2334	5	4
3685	55	2336	5	4
3686	55	2339	1	0
3687	55	2340	1	1
3688	55	2341	1	1
3689	56	2368	2	0
3690	56	2369	5	4
3691	56	2370	1	0
3692	56	2371	2	1
3693	56	2372	3	2
3694	56	2374	2	1
3695	56	2376	5	1
3696	56	2377	3	1
3697	56	2378	2	2
3698	56	2382	4	4
3699	56	2383	4	2
3700	56	2384	4	2
3701	56	2385	2	0
3702	56	2386	3	1
3703	56	2387	2	2
3704	56	2388	3	0
3705	56	2389	3	3
3706	56	2391	2	0
3707	56	2392	3	1
3708	56	2394	1	1
3709	56	2395	2	2
3710	56	2396	2	0
3711	56	2397	2	2
3712	56	2398	4	0
3713	56	2399	2	1
3714	56	2400	3	0
3715	56	2401	4	2
3716	56	2402	5	0
3717	56	2403	5	4
3718	56	2405	4	4
3719	56	2406	1	1
3720	56	2407	2	1
3721	56	2409	5	1
3722	56	2410	1	0
3723	56	2411	4	1
3724	56	2412	3	1
3725	56	2413	5	1
3726	56	2414	4	3
3727	56	2415	5	5
3728	56	2418	3	3
3729	56	2419	4	4
3730	56	2420	5	1
3731	56	2421	1	0
3732	56	2422	4	2
3733	56	2423	1	0
3734	56	2424	3	1
3735	56	2425	4	0
3736	56	2426	3	0
3737	56	2428	2	0
3738	56	2429	3	3
3739	56	2430	2	1
3740	56	2432	5	2
3741	56	2433	5	0
3742	56	2434	2	1
3743	56	2435	3	0
3744	56	2436	5	3
3745	56	2437	4	0
3746	56	2438	1	0
3747	56	2439	1	0
3748	56	2440	3	0
3749	56	2441	1	0
3750	56	2442	4	4
3751	56	2443	1	0
3752	56	2444	1	0
3753	56	2446	2	1
3754	56	2447	5	1
3755	56	2449	3	3
3756	56	2450	3	2
3757	56	2451	1	0
3758	56	2452	3	3
3759	56	2453	1	1
3760	56	2454	2	2
3761	56	2455	4	3
3762	56	2456	1	0
3763	56	2457	1	1
3764	57	2367	1	0
3765	57	2368	1	0
3766	57	2369	3	0
3767	57	2370	5	3
3768	57	2371	1	0
3769	57	2372	1	0
3770	57	2373	1	0
3771	57	2374	5	2
3772	57	2375	2	2
3773	57	2376	3	1
3774	57	2377	3	1
3775	57	2378	3	2
3776	57	2380	5	0
3777	57	2381	1	0
3778	57	2382	4	1
3779	57	2383	2	0
3780	57	2384	5	5
3781	57	2386	3	1
3782	57	2387	3	2
3783	57	2389	2	2
3784	57	2391	2	0
3785	57	2392	2	2
3786	57	2393	1	1
3787	57	2394	1	1
3788	57	2395	4	4
3789	57	2396	1	0
3790	57	2397	4	3
3791	57	2398	2	1
3792	57	2399	3	1
3793	57	2400	5	4
3794	57	2401	5	3
3795	57	2402	2	0
3796	57	2403	4	3
3797	57	2407	1	1
3798	57	2408	1	0
3799	57	2409	2	0
3800	57	2410	1	0
3801	57	2411	1	1
3802	57	2412	3	1
3803	57	2413	5	2
3804	57	2414	2	2
3805	57	2416	4	2
3806	57	2417	5	1
3807	57	2419	4	3
3808	57	2420	3	0
3809	57	2421	4	4
3810	57	2422	2	2
3811	57	2423	4	3
3812	57	2424	1	0
3813	57	2425	4	0
3814	57	2426	1	0
3815	57	2427	5	2
3816	57	2428	1	1
3817	57	2430	5	3
3818	57	2431	3	2
3819	57	2432	5	0
3820	57	2433	1	1
3821	57	2434	2	0
3822	57	2436	1	0
3823	57	2438	1	0
3824	57	2439	4	0
3825	57	2440	3	0
3826	57	2441	5	3
3827	57	2442	3	1
3828	57	2443	1	1
3829	57	2445	2	0
3830	57	2446	1	0
3831	57	2447	1	0
3832	57	2449	3	3
3833	57	2450	3	3
3834	57	2451	5	4
3835	57	2452	2	1
3836	57	2453	4	0
3837	57	2455	5	2
3838	57	2456	3	0
3839	57	2457	5	3
3840	57	2458	2	0
3841	58	2368	2	0
3842	58	2369	2	2
3843	58	2370	3	0
3844	58	2371	1	1
3845	58	2372	5	4
3846	58	2373	1	1
3847	58	2374	3	2
3848	58	2375	1	0
3849	58	2376	5	5
3850	58	2377	5	2
3851	58	2378	2	1
3852	58	2379	4	3
3853	58	2381	2	1
3854	58	2382	3	3
3855	58	2383	2	2
3856	58	2384	3	2
3857	58	2386	5	4
3858	58	2387	1	1
3859	58	2388	3	2
3860	58	2389	1	1
3861	58	2390	3	3
3862	58	2391	5	2
3863	58	2392	3	2
3864	58	2393	4	2
3865	58	2394	4	3
3866	58	2395	5	0
3867	58	2396	1	0
3868	58	2399	4	4
3869	58	2401	2	1
3870	58	2402	3	1
3871	58	2404	2	1
3872	58	2405	5	1
3873	58	2406	4	3
3874	58	2407	1	0
3875	58	2408	4	4
3876	58	2409	5	0
3877	58	2410	2	1
3878	58	2411	4	1
3879	58	2412	3	0
3880	58	2413	1	1
3881	58	2414	4	4
3882	58	2419	1	1
3883	59	2460	1	1
3884	59	2464	2	0
3885	59	2465	3	0
3886	59	2466	4	2
3887	59	2467	1	1
3888	59	2469	1	0
3889	59	2470	4	0
3890	59	2471	4	4
3891	59	2472	2	1
3892	59	2473	2	1
3893	59	2475	4	0
3894	59	2476	1	1
3895	59	2477	1	0
3896	59	2478	2	1
3897	59	2479	1	1
3898	59	2480	2	0
3899	59	2481	5	2
3900	59	2483	3	1
3901	59	2484	5	2
3902	59	2485	4	4
3903	59	2486	3	0
3904	59	2487	1	1
3905	59	2490	5	2
3906	59	2491	1	1
3907	59	2492	4	0
3908	59	2494	2	2
3909	59	2496	1	0
3910	59	2497	4	2
3911	59	2499	5	1
3912	59	2501	4	3
3913	59	2503	1	1
3914	59	2505	2	2
3915	59	2508	5	4
3916	59	2510	2	0
3917	59	2512	2	1
3918	59	2513	5	5
3919	59	2514	1	0
3920	59	2515	1	1
3921	59	2517	5	3
3922	59	2518	5	0
3923	59	2519	2	0
3924	59	2520	5	4
3925	59	2521	2	1
3926	59	2523	1	1
3927	59	2524	1	0
3928	59	2526	4	4
3929	59	2527	4	0
3930	59	2528	2	1
3931	59	2529	4	0
3932	59	2531	5	2
3933	59	2532	2	1
3934	59	2533	4	1
3935	59	2534	5	5
3936	59	2536	2	1
3937	59	2537	2	1
3938	59	2538	4	2
3939	59	2540	4	4
3940	59	2541	2	1
3941	59	2542	5	0
3942	59	2543	4	4
3943	59	2545	4	1
3944	59	2547	4	2
3945	59	2548	2	0
3946	59	2549	5	4
3947	59	2550	2	2
3948	59	2554	3	0
3949	60	2459	1	0
3950	60	2460	5	5
3951	60	2462	5	4
3952	60	2463	1	1
3953	60	2464	3	2
3954	60	2465	1	1
3955	60	2466	5	4
3956	60	2467	3	0
3957	60	2468	3	0
3958	60	2470	2	2
3959	60	2471	5	2
3960	60	2472	4	1
3961	60	2473	2	2
3962	60	2474	3	1
3963	60	2475	5	3
3964	60	2476	3	1
3965	60	2477	1	0
3966	60	2478	2	2
3967	60	2480	4	0
3968	60	2481	3	1
3969	60	2483	3	3
3970	60	2484	3	2
3971	60	2485	2	1
3972	60	2486	3	0
3973	60	2487	5	5
3974	60	2489	5	2
3975	60	2492	2	1
3976	60	2493	4	3
3977	60	2494	3	3
3978	60	2496	3	0
3979	60	2497	2	0
3980	60	2498	5	3
3981	60	2499	2	0
3982	60	2500	2	0
3983	60	2501	5	5
3984	60	2502	4	0
3985	60	2503	1	1
3986	60	2504	4	1
3987	60	2506	2	2
3988	60	2507	4	3
3989	60	2508	5	0
3990	60	2509	5	5
3991	60	2510	2	2
3992	60	2511	3	0
3993	60	2512	5	4
3994	60	2513	1	1
3995	60	2515	1	1
3996	60	2516	4	3
3997	60	2517	5	2
3998	60	2518	2	2
3999	60	2520	3	0
4000	60	2524	1	1
4001	60	2526	4	2
4002	60	2527	1	0
4003	60	2528	3	0
4004	60	2530	5	5
4005	60	2531	4	0
4006	60	2532	4	4
4007	60	2533	2	1
4008	60	2534	3	1
4009	60	2535	5	0
4010	60	2536	5	1
4011	60	2538	4	1
4012	60	2539	5	2
4013	60	2540	1	1
4014	60	2541	1	1
4015	60	2542	2	0
4016	60	2543	1	0
4017	60	2546	1	0
4018	61	2555	4	3
4019	61	2556	5	0
4020	61	2557	1	0
4021	61	2558	1	1
4022	61	2559	3	1
4023	61	2561	1	0
4024	61	2562	5	5
4025	61	2563	2	1
4026	61	2564	3	1
4027	61	2565	4	1
4028	61	2566	5	0
4029	61	2568	4	0
4030	61	2569	2	1
4031	61	2570	1	0
4032	61	2571	1	0
4033	61	2572	5	0
4034	61	2574	2	0
4035	61	2576	2	2
4036	61	2577	1	1
4037	61	2578	4	1
4038	61	2580	1	0
4039	61	2581	2	1
4040	61	2582	3	0
4041	61	2583	2	2
4042	61	2584	4	3
4043	61	2585	3	1
4044	61	2586	2	0
4045	61	2587	4	3
4046	61	2590	3	2
4047	61	2591	1	0
4048	61	2592	2	1
4049	61	2593	2	2
4050	61	2595	5	5
4051	61	2596	1	1
4052	61	2597	3	1
4053	61	2598	5	1
4054	61	2599	2	1
4055	61	2600	3	2
4056	61	2601	4	0
4057	61	2602	4	2
4058	61	2603	4	2
4059	61	2604	3	2
4060	61	2605	3	1
4061	61	2606	2	2
4062	61	2607	1	0
4063	61	2608	5	0
4064	61	2610	5	0
4065	61	2611	1	0
4066	61	2612	4	3
4067	61	2613	2	1
4068	61	2616	4	1
4069	61	2618	1	1
4070	61	2619	5	3
4071	61	2620	2	0
4072	61	2621	2	1
4073	61	2622	2	1
4074	61	2623	4	4
4075	61	2624	4	4
4076	61	2625	4	4
4077	61	2627	1	1
4078	61	2628	4	1
4079	61	2629	3	1
4080	61	2630	2	0
4081	61	2632	3	3
4082	61	2633	4	1
4083	61	2634	1	0
4084	61	2635	1	0
4085	61	2636	3	0
4086	61	2638	3	0
4087	61	2639	5	3
4088	61	2640	4	0
4089	61	2641	5	5
4090	61	2642	4	0
4091	61	2643	5	4
4092	61	2644	4	4
4093	61	2645	3	0
4094	61	2646	2	2
4095	61	2647	5	2
4096	61	2649	3	0
4097	61	2650	5	0
4098	61	2654	1	0
4099	62	2556	5	0
4100	62	2557	3	3
4101	62	2558	2	2
4102	62	2559	3	1
4103	62	2560	1	0
4104	62	2561	4	2
4105	62	2562	4	1
4106	62	2563	4	4
4107	62	2564	1	1
4108	62	2565	3	3
4109	62	2566	4	3
4110	62	2567	5	1
4111	62	2568	5	4
4112	62	2569	3	3
4113	62	2570	2	2
4114	62	2571	4	2
4115	62	2572	2	0
4116	62	2573	3	2
4117	62	2574	4	2
4118	62	2575	3	2
4119	62	2577	4	1
4120	62	2578	1	0
4121	62	2579	5	5
4122	62	2580	2	0
4123	62	2582	3	0
4124	62	2583	5	1
4125	62	2584	5	2
4126	62	2585	1	0
4127	62	2586	3	3
4128	62	2588	1	1
4129	62	2589	3	0
4130	62	2591	5	2
4131	62	2592	1	1
4132	62	2593	3	3
4133	62	2594	1	0
4134	62	2595	5	3
4135	62	2596	3	2
4136	62	2597	1	1
4137	62	2598	3	2
4138	62	2599	5	3
4139	62	2600	1	1
4140	62	2601	2	0
4141	62	2602	3	2
4142	62	2605	2	2
4143	62	2606	5	4
4144	62	2607	4	3
4145	62	2608	3	3
4146	62	2609	2	1
4147	62	2610	4	0
4148	62	2611	4	1
4149	62	2612	4	1
4150	62	2614	3	1
4151	62	2615	4	2
4152	62	2617	3	1
4153	62	2618	1	1
4154	62	2619	4	3
4155	62	2621	3	1
4156	62	2622	3	2
4157	62	2623	4	0
4158	62	2624	1	0
4159	62	2625	2	1
4160	62	2626	5	2
4161	62	2627	1	0
4162	62	2629	4	3
4163	62	2630	2	2
4164	62	2636	1	0
4165	63	2556	3	0
4166	63	2557	1	0
4167	63	2558	1	1
4168	63	2559	5	2
4169	63	2560	3	2
4170	63	2561	3	3
4171	63	2563	2	2
4172	63	2564	3	2
4173	63	2565	4	4
4174	63	2566	4	0
4175	63	2567	3	2
4176	63	2568	1	0
4177	63	2569	4	1
4178	63	2571	4	4
4179	63	2572	4	4
4180	63	2573	3	1
4181	63	2574	5	1
4182	63	2575	5	2
4183	63	2576	1	0
4184	63	2577	4	2
4185	63	2578	4	2
4186	63	2579	4	3
4187	63	2581	1	0
4188	63	2582	2	2
4189	63	2583	3	0
4190	63	2584	5	0
4191	63	2586	2	0
4192	63	2587	3	3
4193	63	2588	4	4
4194	63	2589	2	2
4195	63	2590	5	5
4196	63	2591	3	2
4197	63	2592	5	2
4198	63	2594	3	3
4199	63	2595	2	2
4200	63	2596	5	5
4201	63	2597	1	0
4202	63	2598	5	2
4203	63	2599	2	0
4204	63	2601	4	1
4205	63	2603	5	1
4206	63	2604	2	2
4207	63	2605	1	0
4208	63	2606	4	0
4209	63	2608	2	1
4210	63	2609	4	3
4211	63	2611	3	3
4212	63	2612	5	3
4213	63	2613	3	2
4214	63	2614	1	0
4215	63	2615	4	0
4216	63	2616	4	0
4217	63	2617	1	1
4218	63	2618	2	2
4219	63	2619	3	1
4220	63	2620	1	1
4221	63	2621	3	3
4222	63	2622	2	0
4223	63	2623	4	4
4224	63	2624	4	2
4225	63	2625	4	3
4226	63	2626	4	2
4227	63	2627	4	0
4228	63	2628	3	3
4229	63	2630	2	2
4230	63	2632	2	1
4231	63	2633	3	0
4232	63	2634	5	3
4233	63	2635	4	3
4234	63	2637	2	1
4235	63	2638	3	3
4236	63	2640	5	4
4237	63	2641	3	0
4238	63	2642	4	2
4239	63	2643	5	4
4240	63	2644	3	2
4241	63	2645	1	0
4242	63	2646	3	1
4243	63	2647	2	2
4244	63	2648	2	2
4245	63	2649	5	1
4246	63	2650	4	2
4247	63	2651	1	0
4248	63	2653	5	2
4249	63	2654	3	0
4250	63	2655	2	0
4251	63	2656	5	4
4252	63	2657	5	1
4253	63	2658	4	0
4254	63	2660	1	0
4255	63	2665	1	1
4256	64	2674	1	1
4257	64	2675	3	1
4258	64	2676	4	1
4259	64	2677	4	2
4260	64	2679	4	3
4261	64	2680	1	0
4262	64	2683	5	2
4263	64	2684	3	0
4264	64	2686	1	0
4265	64	2688	2	0
4266	64	2689	1	0
4267	64	2691	2	0
4268	64	2692	5	5
4269	64	2693	5	3
4270	64	2694	1	1
4271	64	2695	5	3
4272	64	2696	3	0
4273	64	2699	3	3
4274	64	2700	5	5
4275	64	2701	4	3
4276	64	2702	1	0
4277	64	2703	4	1
4278	64	2704	2	0
4279	64	2705	3	3
4280	64	2706	4	3
4281	64	2707	2	2
4282	64	2708	2	2
4283	64	2709	1	0
4284	64	2710	1	1
4285	64	2711	2	1
4286	64	2712	4	4
4287	64	2713	5	5
4288	64	2714	2	2
4289	64	2715	2	0
4290	64	2716	4	2
4291	64	2717	4	2
4292	64	2718	3	2
4293	64	2719	5	5
4294	64	2720	1	1
4295	64	2721	1	1
4296	64	2722	4	0
4297	64	2723	3	3
4298	64	2724	1	1
4299	64	2725	4	0
4300	64	2726	5	2
4301	64	2727	5	2
4302	64	2728	1	0
4303	64	2729	1	1
4304	64	2731	2	1
4305	64	2732	2	0
4306	64	2734	1	1
4307	64	2735	1	1
4308	64	2736	3	2
4309	64	2737	3	3
4310	64	2738	3	0
4311	64	2739	4	2
4312	64	2740	4	3
4313	64	2741	1	0
4314	64	2743	1	0
4315	64	2744	4	0
4316	64	2745	4	0
4317	64	2746	5	3
4318	64	2747	4	2
4319	64	2748	2	0
4320	64	2749	3	0
4321	64	2752	5	1
4322	64	2754	3	0
4323	64	2755	2	1
4324	65	2673	5	1
4325	65	2674	1	1
4326	65	2675	1	1
4327	65	2676	3	0
4328	65	2677	2	1
4329	65	2678	5	5
4330	65	2681	2	2
4331	65	2682	2	2
4332	65	2683	3	2
4333	65	2684	2	0
4334	65	2685	3	0
4335	65	2687	3	1
4336	65	2688	2	0
4337	65	2689	5	0
4338	65	2690	4	4
4339	65	2691	2	0
4340	65	2692	1	0
4341	65	2693	5	5
4342	65	2694	2	1
4343	65	2695	3	0
4344	65	2696	2	0
4345	65	2697	2	0
4346	65	2698	3	0
4347	65	2699	5	4
4348	65	2700	2	0
4349	65	2701	3	0
4350	65	2703	4	3
4351	65	2704	4	2
4352	65	2705	3	3
4353	65	2706	2	1
4354	65	2707	4	1
4355	65	2708	4	2
4356	65	2709	1	0
4357	65	2711	1	1
4358	65	2712	5	3
4359	65	2714	4	4
4360	65	2715	1	1
4361	65	2716	4	2
4362	65	2718	5	0
4363	65	2719	4	2
4364	65	2721	5	1
4365	65	2722	2	0
4366	65	2723	3	0
4367	65	2724	4	4
4368	65	2725	1	0
4369	65	2726	2	0
4370	66	2673	4	4
4371	66	2674	2	1
4372	66	2675	4	1
4373	66	2676	1	1
4374	66	2677	1	1
4375	66	2678	2	2
4376	66	2679	1	0
4377	66	2680	1	0
4378	66	2681	2	0
4379	66	2682	5	3
4380	66	2685	5	4
4381	66	2686	1	1
4382	66	2687	2	2
4383	66	2688	1	0
4384	66	2690	1	1
4385	66	2692	2	1
4386	66	2693	5	2
4387	66	2694	2	0
4388	66	2695	4	0
4389	66	2696	3	3
4390	66	2697	4	3
4391	66	2698	3	1
4392	66	2699	5	4
4393	66	2700	5	2
4394	66	2701	2	2
4395	66	2704	3	1
4396	66	2705	3	3
4397	66	2706	1	0
4398	66	2707	3	2
4399	66	2708	4	0
4400	66	2709	1	0
4401	66	2710	5	4
4402	66	2711	2	0
4403	66	2712	5	5
4404	66	2713	5	2
4405	66	2714	4	3
4406	66	2715	1	1
4407	66	2716	5	0
4408	66	2718	2	1
4409	66	2719	1	0
4410	66	2720	4	1
4411	66	2721	5	1
4412	66	2722	3	3
4413	66	2725	3	0
4414	66	2726	1	1
4415	66	2728	1	0
4416	66	2729	1	1
4417	66	2730	5	4
4418	66	2731	1	0
4419	66	2733	5	3
4420	66	2735	4	3
4421	66	2736	3	0
4422	66	2738	2	1
4423	66	2739	4	1
4424	66	2741	2	2
4425	66	2742	3	0
4426	66	2743	2	0
4427	66	2745	1	1
4428	66	2746	3	1
4429	66	2748	4	4
4430	66	2749	4	0
4431	66	2750	4	2
4432	66	2751	2	0
4433	66	2753	1	0
4434	67	2757	5	1
4435	67	2758	3	2
4436	67	2759	1	1
4437	67	2760	2	1
4438	67	2762	1	0
4439	67	2763	3	1
4440	67	2764	4	4
4441	67	2765	2	2
4442	67	2766	4	3
4443	67	2767	1	1
4444	67	2768	5	1
4445	67	2769	1	1
4446	67	2771	3	1
4447	67	2772	4	4
4448	67	2773	4	1
4449	67	2775	4	0
4450	67	2776	1	1
4451	67	2777	4	1
4452	67	2779	3	1
4453	67	2780	4	2
4454	67	2781	3	0
4455	67	2782	3	0
4456	67	2783	5	2
4457	67	2784	4	0
4458	67	2786	5	1
4459	67	2787	3	1
4460	67	2788	3	1
4461	67	2790	1	1
4462	67	2791	4	4
4463	67	2792	5	3
4464	67	2793	2	1
4465	67	2794	1	0
4466	67	2795	5	1
4467	67	2796	5	0
4468	67	2797	5	5
4469	67	2798	3	3
4470	67	2799	3	2
4471	67	2800	1	1
4472	67	2801	4	1
4473	67	2802	4	4
4474	67	2804	5	2
4475	67	2806	3	1
4476	67	2809	4	1
4477	67	2811	5	4
4478	67	2812	2	0
4479	67	2813	1	0
4480	67	2814	3	3
4481	67	2815	5	3
4482	67	2817	4	3
4483	67	2818	3	2
4484	67	2819	4	2
4485	67	2820	5	0
4486	67	2823	2	0
4487	67	2824	5	5
4488	67	2825	2	1
4489	67	2826	4	4
4490	67	2828	2	0
4491	67	2829	3	0
4492	67	2830	4	0
4493	67	2831	5	1
4494	67	2832	4	4
4495	67	2833	1	0
4496	67	2835	5	2
4497	68	2757	2	2
4498	68	2758	5	4
4499	68	2759	5	5
4500	68	2760	4	0
4501	68	2761	5	5
4502	68	2762	1	0
4503	68	2764	1	1
4504	68	2765	5	1
4505	68	2766	5	5
4506	68	2767	5	2
4507	68	2768	2	1
4508	68	2770	1	0
4509	68	2772	3	1
4510	68	2773	2	0
4511	68	2774	2	0
4512	68	2775	3	3
4513	68	2776	3	2
4514	68	2777	5	4
4515	68	2778	2	2
4516	68	2779	5	0
4517	68	2780	3	0
4518	68	2781	1	0
4519	68	2782	2	0
4520	68	2783	2	2
4521	68	2785	1	1
4522	68	2786	5	4
4523	68	2787	5	0
4524	68	2788	2	2
4525	68	2790	1	1
4526	68	2791	3	2
4527	68	2792	4	0
4528	68	2794	1	0
4529	68	2796	2	2
4530	68	2797	1	1
4531	68	2798	4	1
4532	68	2800	1	1
4533	68	2801	2	2
4534	68	2802	1	1
4535	68	2803	4	4
4536	68	2804	5	1
4537	68	2805	4	1
4538	68	2806	1	0
4539	68	2807	3	3
4540	68	2808	1	0
4541	68	2810	5	3
4542	68	2811	4	4
4543	68	2813	5	2
4544	68	2814	3	3
4545	68	2815	2	1
4546	68	2817	3	3
4547	68	2819	3	0
4548	68	2820	2	2
4549	68	2821	5	2
4550	68	2822	4	3
4551	68	2823	3	3
4552	68	2824	3	0
4553	68	2825	5	2
4554	68	2826	2	1
4555	68	2827	3	3
4556	68	2828	5	2
4557	68	2829	5	3
4558	68	2830	1	1
4559	69	2836	5	3
4560	69	2837	3	2
4561	69	2838	1	1
4562	69	2840	3	0
4563	69	2842	5	1
4564	69	2843	4	0
4565	69	2844	3	2
4566	69	2846	1	1
4567	69	2847	2	2
4568	69	2848	4	0
4569	69	2849	1	1
4570	69	2850	4	1
4571	69	2851	5	5
4572	69	2852	3	3
4573	69	2853	4	0
4574	69	2854	2	2
4575	69	2855	1	0
4576	69	2856	5	5
4577	69	2858	2	2
4578	69	2859	3	1
4579	69	2860	4	0
4580	69	2862	5	3
4581	69	2863	3	2
4582	69	2864	1	0
4583	69	2865	5	0
4584	69	2866	5	5
4585	69	2868	2	0
4586	69	2871	2	1
4587	69	2872	5	4
4588	69	2873	4	3
4589	69	2874	5	4
4590	69	2875	3	3
4591	69	2876	5	1
4592	69	2877	4	1
4593	69	2878	4	0
4594	69	2879	2	1
4595	69	2881	1	1
4596	69	2882	5	2
4597	69	2884	4	4
4598	69	2885	1	0
4599	69	2886	4	0
4600	69	2887	3	3
4601	69	2888	3	3
4602	69	2889	3	2
4603	69	2890	1	1
4604	69	2891	3	0
4605	69	2894	3	3
4606	69	2895	1	0
4607	69	2896	2	1
4608	69	2897	2	0
4609	69	2898	4	4
4610	69	2899	3	3
4611	69	2900	3	1
4612	69	2902	1	0
4613	69	2903	2	0
4614	69	2904	4	4
4615	69	2906	4	2
4616	69	2907	2	0
4617	70	2836	4	3
4618	70	2837	3	1
4619	70	2839	2	1
4620	70	2841	5	5
4621	70	2843	4	1
4622	70	2844	2	1
4623	70	2845	2	1
4624	70	2846	4	3
4625	70	2847	2	0
4626	70	2848	3	3
4627	70	2849	5	2
4628	70	2850	2	0
4629	70	2852	2	2
4630	70	2853	5	1
4631	70	2854	3	0
4632	70	2855	3	0
4633	70	2856	2	2
4634	70	2857	2	1
4635	70	2858	1	1
4636	70	2859	4	4
4637	70	2861	3	2
4638	70	2864	5	5
4639	70	2865	3	2
4640	70	2866	2	1
4641	70	2867	1	1
4642	70	2870	2	1
4643	70	2871	2	1
4644	70	2873	2	2
4645	70	2874	1	1
4646	70	2875	4	1
4647	70	2876	2	2
4648	70	2877	2	2
4649	70	2878	1	0
4650	70	2879	4	3
4651	70	2881	4	4
4652	70	2883	5	5
4653	70	2884	3	3
4654	70	2886	1	1
4655	70	2887	4	2
4656	70	2888	4	0
4657	70	2889	2	1
4658	70	2890	5	1
4659	70	2892	5	5
4660	70	2894	1	0
4661	70	2895	4	3
4662	70	2897	3	3
4663	70	2898	2	1
4664	70	2899	5	1
4665	70	2900	2	0
4666	70	2901	4	4
4667	70	2902	1	1
4668	70	2903	3	0
4669	70	2904	5	3
4670	70	2905	3	1
4671	70	2906	1	0
4672	70	2907	5	4
4673	70	2908	1	0
4674	70	2909	3	0
4675	70	2911	2	0
4676	70	2912	4	1
4677	70	2913	2	0
4678	70	2914	5	0
4679	70	2915	3	0
4680	70	2916	4	3
4681	70	2917	3	0
4682	70	2918	5	1
4683	70	2919	3	2
4684	70	2920	2	2
4685	70	2921	4	3
4686	70	2922	2	0
4687	70	2923	3	0
4688	70	2924	1	0
4689	70	2926	3	1
4690	70	2927	2	2
4691	70	2928	1	0
4692	71	2956	1	1
4693	71	2957	1	0
4694	71	2958	1	1
4695	71	2959	1	0
4696	71	2961	3	3
4697	71	2962	5	3
4698	71	2963	3	0
4699	71	2964	3	1
4700	71	2965	1	1
4701	71	2966	2	0
4702	71	2967	2	2
4703	71	2968	5	0
4704	71	2969	1	0
4705	71	2970	3	0
4706	71	2971	3	0
4707	71	2972	2	2
4708	71	2974	5	3
4709	71	2976	5	0
4710	71	2977	1	1
4711	71	2978	3	0
4712	71	2979	4	1
4713	71	2980	1	1
4714	71	2981	3	1
4715	71	2983	1	0
4716	71	2984	1	0
4717	71	2986	4	3
4718	71	2987	1	1
4719	71	2988	3	2
4720	71	2989	4	3
4721	71	2990	1	1
4722	71	2991	5	3
4723	71	2992	4	2
4724	71	2993	1	0
4725	71	2995	2	0
4726	71	2996	5	2
4727	71	2997	5	0
4728	71	2998	1	1
4729	71	3000	1	0
4730	71	3001	5	5
4731	71	3004	1	1
4732	72	2956	5	5
4733	72	2957	5	1
4734	72	2958	1	0
4735	72	2959	3	0
4736	72	2960	2	1
4737	72	2961	5	5
4738	72	2962	1	1
4739	72	2963	4	4
4740	72	2965	1	1
4741	72	2966	4	4
4742	72	2967	1	0
4743	72	2968	4	1
4744	72	2969	2	1
4745	72	2970	4	3
4746	72	2971	4	0
4747	72	2972	1	0
4748	72	2973	1	1
4749	72	2974	2	0
4750	72	2975	4	2
4751	72	2976	4	2
4752	72	2977	2	1
4753	72	2979	5	1
4754	72	2981	4	2
4755	72	2982	4	2
4756	72	2983	2	2
4757	72	2984	3	0
4758	72	2985	4	3
4759	72	2986	3	0
4760	72	2987	4	2
4761	72	2990	3	0
4762	72	2991	5	4
4763	72	2992	1	1
4764	72	2993	5	3
4765	72	2995	2	2
4766	72	2996	3	1
4767	72	2997	5	2
4768	72	2999	1	1
4769	72	3000	4	3
4770	72	3003	4	1
4771	72	3005	5	3
4772	72	3006	4	0
4773	72	3007	1	1
4774	72	3008	4	1
4775	72	3009	1	1
4776	72	3010	1	0
4777	72	3011	1	0
4778	72	3012	2	1
4779	72	3013	5	0
4780	72	3014	3	3
4781	72	3015	1	1
4782	72	3016	4	3
4783	72	3017	1	1
4784	72	3018	5	0
4785	72	3019	2	1
4786	72	3020	1	1
4787	72	3021	3	0
4788	72	3022	1	0
4789	72	3023	4	3
4790	72	3024	5	3
4791	72	3025	1	0
4792	72	3026	2	0
4793	72	3027	1	1
4794	72	3028	3	0
4795	72	3029	3	2
4796	72	3030	3	3
4797	72	3031	5	4
4798	72	3032	5	4
4799	72	3033	4	2
4800	72	3034	1	1
4801	73	3074	5	1
4802	73	3077	3	2
4803	73	3078	3	3
4804	73	3079	5	4
4805	73	3080	1	1
4806	73	3081	1	0
4807	73	3082	1	1
4808	73	3083	4	2
4809	73	3084	1	0
4810	73	3085	3	2
4811	73	3086	5	5
4812	73	3087	5	0
4813	73	3088	4	1
4814	73	3090	1	0
4815	73	3091	3	3
4816	73	3093	5	5
4817	73	3094	5	1
4818	73	3096	1	1
4819	73	3097	3	0
4820	73	3098	2	1
4821	73	3100	1	0
4822	73	3101	3	0
4823	73	3102	3	3
4824	73	3103	1	1
4825	73	3104	3	3
4826	73	3107	1	0
4827	73	3108	1	1
4828	73	3109	5	2
4829	73	3111	5	1
4830	73	3112	3	0
4831	73	3113	1	1
4832	73	3114	5	3
4833	73	3115	3	3
4834	73	3116	1	1
4835	73	3117	1	0
4836	73	3118	1	1
4837	73	3119	1	0
4838	73	3120	4	1
4839	73	3121	2	1
4840	73	3122	4	4
4841	73	3123	5	2
4842	73	3124	1	0
4843	73	3126	2	2
4844	73	3127	1	1
4845	73	3128	3	1
4846	73	3129	2	0
4847	73	3131	5	2
4848	73	3133	4	3
4849	73	3134	3	0
4850	73	3135	4	0
4851	73	3136	4	1
4852	73	3138	1	0
4853	73	3139	2	0
4854	73	3140	5	3
4855	73	3141	5	2
4856	73	3142	5	1
4857	73	3143	1	1
4858	73	3146	5	3
4859	73	3147	4	2
4860	73	3148	5	5
4861	73	3149	5	4
4862	73	3150	1	0
4863	73	3151	1	1
4864	73	3152	5	3
4865	73	3153	1	1
4866	73	3154	5	3
4867	73	3155	5	2
4868	73	3156	4	0
4869	73	3157	2	2
4870	73	3159	3	2
4871	73	3160	3	1
4872	73	3161	5	4
4873	73	3162	1	0
4874	73	3164	1	1
4875	73	3165	4	4
4876	73	3166	4	4
4877	73	3167	2	2
4878	73	3168	5	4
4879	73	3169	3	0
4880	73	3170	2	2
4881	73	3171	3	0
4882	73	3172	4	3
4883	73	3173	2	1
4884	73	3174	3	1
4885	73	3175	1	1
4886	73	3176	4	1
4887	74	3073	3	0
4888	74	3074	2	1
4889	74	3075	3	3
4890	74	3076	1	1
4891	74	3078	2	1
4892	74	3079	3	3
4893	74	3080	4	4
4894	74	3081	2	1
4895	74	3083	3	2
4896	74	3084	2	0
4897	74	3085	4	1
4898	74	3086	4	1
4899	74	3088	5	1
4900	74	3089	1	0
4901	74	3090	5	5
4902	74	3091	1	0
4903	74	3092	1	0
4904	74	3093	1	0
4905	74	3094	4	0
4906	74	3097	1	0
4907	74	3098	4	3
4908	74	3099	5	1
4909	74	3100	4	1
4910	74	3101	1	1
4911	74	3102	2	2
4912	74	3103	5	3
4913	74	3104	1	1
4914	74	3105	5	5
4915	74	3106	4	2
4916	74	3108	4	1
4917	74	3109	5	2
4918	74	3110	4	2
4919	74	3111	1	0
4920	74	3112	4	2
4921	74	3114	2	0
4922	74	3115	1	0
4923	74	3116	3	1
4924	74	3118	4	3
4925	74	3119	4	0
4926	74	3120	4	3
4927	74	3121	4	4
4928	74	3122	3	1
4929	74	3124	5	3
4930	74	3125	5	3
4931	74	3126	3	2
4932	74	3128	3	1
4933	74	3133	4	3
4934	74	3134	5	1
4935	74	3135	3	3
4936	74	3136	5	2
4937	74	3137	3	2
4938	74	3138	3	2
4939	74	3139	2	1
4940	74	3140	2	2
4941	74	3144	3	3
4942	74	3146	2	0
4943	74	3147	3	1
4944	74	3148	3	2
4945	74	3149	4	4
4946	74	3150	1	1
4947	74	3151	5	0
4948	74	3152	4	0
4949	74	3153	2	2
4950	74	3154	5	0
4951	74	3155	4	2
4952	74	3156	1	1
4953	74	3157	1	0
4954	75	3073	2	0
4955	75	3074	1	0
4956	75	3077	4	0
4957	75	3080	5	5
4958	75	3082	5	0
4959	75	3084	1	0
4960	75	3085	1	0
4961	75	3086	3	2
4962	75	3087	4	0
4963	75	3088	4	3
4964	75	3089	1	0
4965	75	3090	3	3
4966	75	3091	3	0
4967	75	3092	2	2
4968	75	3093	1	1
4969	75	3095	3	1
4970	75	3096	5	5
4971	75	3097	2	2
4972	75	3098	3	2
4973	75	3099	4	4
4974	75	3101	1	0
4975	75	3102	4	0
4976	75	3103	1	1
4977	75	3105	1	0
4978	75	3106	3	3
4979	75	3107	5	0
4980	75	3108	5	3
4981	75	3109	5	3
4982	75	3110	3	3
4983	75	3111	3	2
4984	75	3112	1	1
4985	75	3114	3	2
4986	75	3115	1	1
4987	75	3116	1	0
4988	75	3117	2	2
4989	75	3119	4	0
4990	75	3120	5	3
4991	75	3121	4	0
4992	75	3123	3	3
4993	75	3124	4	1
4994	75	3125	3	1
4995	75	3126	5	2
4996	75	3127	5	2
4997	75	3128	4	4
4998	75	3129	5	0
4999	75	3130	3	1
5000	75	3131	2	2
5001	75	3132	3	3
5002	75	3133	3	0
5003	75	3134	1	1
5004	75	3136	2	0
5005	75	3137	2	0
5006	75	3138	2	1
5007	75	3139	3	1
5008	75	3140	3	1
5009	75	3141	2	0
5010	75	3142	3	2
5011	75	3143	1	1
5012	75	3144	3	0
5013	75	3145	1	0
5014	75	3146	3	1
5015	75	3147	4	1
5016	75	3149	3	3
5017	75	3150	3	1
5018	75	3151	5	1
5019	75	3152	4	2
5020	75	3153	3	2
5021	76	3178	1	1
5022	76	3181	3	1
5023	76	3182	3	3
5024	76	3183	5	3
5025	76	3184	1	1
5026	76	3186	4	0
5027	76	3187	5	3
5028	76	3188	5	5
5029	76	3189	1	0
5030	76	3190	4	0
5031	76	3191	5	4
5032	76	3192	5	3
5033	76	3193	3	0
5034	76	3195	2	0
5035	76	3196	2	1
5036	76	3197	2	2
5037	76	3198	3	2
5038	76	3199	5	1
5039	76	3200	4	3
5040	76	3201	5	1
5041	76	3202	5	5
5042	76	3204	3	1
5043	76	3206	1	1
5044	76	3207	3	1
5045	76	3210	4	2
5046	76	3211	2	0
5047	76	3212	5	2
5048	76	3213	3	2
5049	76	3214	5	1
5050	76	3215	3	1
5051	76	3217	2	2
5052	76	3219	5	4
5053	76	3220	1	0
5054	76	3221	1	0
5055	76	3222	2	0
5056	76	3223	5	4
5057	76	3224	1	1
5058	76	3225	5	5
5059	76	3226	3	1
5060	76	3227	5	1
5061	76	3228	2	0
5062	76	3231	4	1
5063	76	3232	5	0
5064	76	3233	2	0
5065	76	3234	2	1
5066	76	3235	1	1
5067	76	3236	2	1
5068	76	3237	1	1
5069	76	3238	3	1
5070	76	3239	2	2
5071	76	3240	3	3
5072	76	3241	2	1
5073	76	3242	1	0
5074	76	3244	4	3
5075	76	3245	4	2
5076	76	3246	4	4
5077	76	3247	2	2
5078	76	3248	5	3
5079	76	3249	1	1
5080	76	3250	4	3
5081	76	3251	2	1
5082	76	3253	2	0
5083	76	3254	1	1
5084	76	3255	4	0
5085	76	3256	4	3
5086	76	3257	1	0
5087	76	3258	2	0
5088	76	3259	3	3
5089	76	3260	4	0
5090	76	3261	4	4
5091	76	3262	2	2
5092	76	3263	3	1
5093	76	3264	3	2
5094	76	3265	2	0
5095	76	3266	4	1
5096	76	3267	2	0
5097	76	3269	4	0
5098	76	3271	4	1
5099	76	3272	1	0
5100	76	3273	1	0
5101	76	3274	5	0
5102	76	3276	1	0
5103	77	3177	3	0
5104	77	3180	2	2
5105	77	3181	5	1
5106	77	3182	1	1
5107	77	3183	3	1
5108	77	3185	1	1
5109	77	3186	2	1
5110	77	3187	1	0
5111	77	3189	1	0
5112	77	3190	4	3
5113	77	3191	2	0
5114	77	3192	4	3
5115	77	3193	4	4
5116	77	3194	3	0
5117	77	3195	1	0
5118	77	3196	3	2
5119	77	3198	1	1
5120	77	3199	3	0
5121	77	3200	1	0
5122	77	3201	2	1
5123	77	3202	3	2
5124	77	3205	1	1
5125	77	3209	3	0
5126	77	3210	5	1
5127	77	3213	1	0
5128	77	3214	1	1
5129	77	3215	3	0
5130	77	3216	3	0
5131	77	3218	3	2
5132	77	3219	3	0
5133	77	3220	2	0
5134	77	3221	2	2
5135	77	3222	4	0
5136	77	3223	4	1
5137	77	3224	3	3
5138	77	3225	2	0
5139	77	3226	4	3
5140	77	3227	3	0
5141	77	3228	1	1
5142	77	3229	4	3
5143	77	3230	4	3
5144	77	3231	2	0
5145	77	3232	1	1
5146	77	3233	1	1
5147	77	3235	4	3
5148	77	3236	5	5
5149	77	3237	1	0
5150	77	3238	1	1
5151	77	3239	4	1
5152	77	3240	1	1
5153	77	3241	1	0
5154	77	3242	2	0
5155	77	3243	3	3
5156	77	3245	2	0
5157	77	3246	2	1
5158	77	3248	3	1
5159	77	3249	3	3
5160	77	3250	5	3
5161	77	3252	5	4
5162	77	3253	3	3
5163	77	3254	4	4
5164	77	3255	2	2
5165	77	3256	5	1
5166	77	3257	5	2
5167	77	3259	3	3
5168	77	3260	4	1
5169	77	3261	1	0
5170	77	3262	5	5
5171	77	3263	2	1
5172	77	3264	2	1
5173	77	3265	2	2
5174	77	3266	3	2
5175	77	3269	1	0
5176	77	3270	3	0
5177	77	3272	3	1
5178	77	3273	4	2
5179	77	3274	2	1
5180	77	3276	1	1
5181	78	3178	2	1
5182	78	3179	1	0
5183	78	3180	4	1
5184	78	3181	2	0
5185	78	3183	3	1
5186	78	3184	1	1
5187	78	3185	4	1
5188	78	3186	2	0
5189	78	3187	3	1
5190	78	3188	5	3
5191	78	3189	2	0
5192	78	3190	1	1
5193	78	3193	4	1
5194	78	3194	2	1
5195	78	3195	5	4
5196	78	3196	1	1
5197	78	3197	5	0
5198	78	3198	2	0
5199	78	3199	3	3
5200	78	3200	1	1
5201	78	3201	3	0
5202	78	3202	1	1
5203	78	3203	3	0
5204	78	3204	1	1
5205	78	3205	5	3
5206	78	3206	3	0
5207	78	3207	5	1
5208	78	3208	5	2
5209	78	3209	1	0
5210	78	3211	3	0
5211	78	3213	5	0
5212	78	3214	1	1
5213	78	3215	5	5
5214	78	3216	2	2
5215	78	3217	1	0
5216	78	3218	3	0
5217	78	3220	5	3
5218	78	3221	1	0
5219	78	3223	1	1
5220	78	3225	1	1
5221	78	3228	2	1
5222	78	3230	1	0
5223	78	3231	2	1
5224	78	3232	2	0
5225	78	3233	5	5
5226	78	3236	4	3
5227	78	3237	3	2
5228	78	3238	1	0
5229	78	3239	2	1
5230	78	3240	3	2
5231	78	3241	1	0
5232	78	3242	4	1
5233	78	3243	2	2
5234	78	3244	1	0
5235	78	3245	4	0
5236	78	3246	3	3
5237	78	3247	3	2
5238	78	3248	3	1
5239	78	3249	2	1
5240	78	3250	5	2
5241	78	3251	5	2
5242	78	3252	1	0
5243	78	3256	3	1
5244	78	3257	5	5
5245	78	3258	1	1
5246	78	3259	2	0
5247	78	3260	5	3
5248	78	3261	2	2
5249	78	3262	2	2
5250	78	3263	1	1
5251	78	3264	5	5
5252	78	3265	4	0
5253	78	3267	4	1
5254	78	3269	5	0
5255	78	3270	4	3
5256	78	3271	2	0
5257	78	3273	5	4
5258	78	3274	2	1
5259	78	3275	2	2
5260	78	3277	5	4
5261	78	3278	3	1
5262	78	3279	5	5
5263	78	3280	2	0
5264	78	3281	5	4
5265	79	3282	2	2
5266	79	3283	5	4
5267	79	3285	1	0
5268	79	3286	3	0
5269	79	3287	4	2
5270	79	3288	1	1
5271	79	3289	3	1
5272	79	3290	1	0
5273	79	3291	5	0
5274	79	3292	3	0
5275	79	3293	2	0
5276	79	3294	4	0
5277	79	3295	2	1
5278	79	3296	1	1
5279	79	3297	2	0
5280	79	3298	4	4
5281	79	3299	3	0
5282	79	3300	4	1
5283	79	3301	4	4
5284	79	3302	1	1
5285	79	3303	1	1
5286	79	3304	5	3
5287	79	3305	1	1
5288	79	3306	5	5
5289	79	3307	5	2
5290	79	3309	2	0
5291	79	3310	2	1
5292	79	3312	3	0
5293	79	3313	1	1
5294	79	3314	5	4
5295	79	3315	3	0
5296	79	3316	3	0
5297	79	3317	4	2
5298	79	3318	5	1
5299	79	3320	4	4
5300	79	3321	1	1
5301	79	3322	5	0
5302	79	3323	1	1
5303	79	3324	1	0
5304	79	3325	4	2
5305	79	3326	4	0
5306	79	3327	3	0
5307	79	3328	4	0
5308	79	3329	2	2
5309	79	3330	1	0
5310	79	3332	1	1
5311	79	3333	2	1
5312	80	3282	4	4
5313	80	3283	3	0
5314	80	3284	3	1
5315	80	3285	2	0
5316	80	3286	1	0
5317	80	3287	5	4
5318	80	3288	5	5
5319	80	3289	4	3
5320	80	3290	1	1
5321	80	3292	2	0
5322	80	3294	2	0
5323	80	3295	4	0
5324	80	3296	4	4
5325	80	3297	1	1
5326	80	3298	2	1
5327	80	3299	3	0
5328	80	3300	4	2
5329	80	3301	3	2
5330	80	3302	2	0
5331	80	3303	4	0
5332	80	3304	2	0
5333	80	3305	2	2
5334	80	3306	5	2
5335	80	3307	3	0
5336	80	3308	5	0
5337	80	3310	4	2
5338	80	3311	1	1
5339	80	3312	5	3
5340	80	3314	1	0
5341	80	3315	2	1
5342	80	3316	5	3
5343	80	3317	1	0
5344	80	3318	2	0
5345	80	3319	4	0
5346	80	3320	2	1
5347	80	3322	1	0
5348	80	3325	4	0
5349	80	3326	5	5
5350	80	3327	2	1
5351	80	3328	2	2
5352	80	3329	4	0
5353	80	3330	3	0
5354	80	3331	4	1
5355	80	3332	2	2
5356	80	3333	1	0
5357	80	3335	4	0
5358	80	3337	2	1
5359	80	3338	1	1
5360	80	3339	3	0
5361	80	3340	1	0
5362	80	3342	3	1
5363	80	3343	3	3
5364	80	3344	2	2
5365	80	3345	3	1
5366	80	3347	3	0
5367	80	3348	2	0
5368	80	3349	3	1
5369	80	3350	3	2
5370	80	3351	5	1
5371	80	3353	4	2
5372	80	3354	1	1
5373	80	3355	5	4
5374	80	3357	4	4
5375	80	3358	2	2
5376	80	3359	1	1
5377	80	3361	1	1
5378	80	3362	3	3
5379	80	3363	4	0
5380	80	3364	2	2
5381	80	3365	1	1
5382	80	3366	3	0
5383	80	3367	5	3
5384	80	3369	2	2
5385	80	3370	3	0
5386	80	3371	5	0
5387	80	3372	3	1
5388	80	3373	2	0
5389	80	3374	1	1
5390	81	3376	5	3
5391	81	3378	3	0
5392	81	3379	2	0
5393	81	3381	2	2
5394	81	3382	3	2
5395	81	3383	3	0
5396	81	3384	4	4
5397	81	3385	4	4
5398	81	3386	2	1
5399	81	3387	2	2
5400	81	3388	4	0
5401	81	3389	5	2
5402	81	3390	4	2
5403	81	3391	2	0
5404	81	3392	5	3
5405	81	3393	1	0
5406	81	3394	1	0
5407	81	3395	4	3
5408	81	3396	2	1
5409	81	3397	3	1
5410	81	3398	5	0
5411	81	3399	1	1
5412	81	3400	4	0
5413	81	3401	5	3
5414	81	3403	2	2
5415	81	3404	2	2
5416	81	3405	2	1
5417	81	3406	4	0
5418	81	3407	2	2
5419	81	3408	1	0
5420	81	3409	3	1
5421	81	3410	2	1
5422	81	3411	3	3
5423	81	3413	3	3
5424	81	3414	2	2
5425	81	3415	3	0
5426	81	3416	4	0
5427	81	3417	5	3
5428	81	3418	4	2
5429	81	3420	4	0
5430	81	3421	1	0
5431	81	3422	2	1
5432	81	3424	4	3
5433	81	3426	3	0
5434	81	3427	1	1
5435	81	3428	1	1
5436	81	3429	5	2
5437	81	3431	2	1
5438	81	3432	3	1
5439	81	3433	3	2
5440	81	3434	3	3
5441	81	3436	2	2
5442	81	3437	1	0
5443	81	3438	3	1
5444	81	3439	3	1
5445	81	3441	1	0
5446	81	3442	1	0
5447	81	3443	4	0
5448	81	3444	3	0
5449	81	3445	2	1
5450	81	3446	3	3
5451	81	3448	3	0
5452	81	3449	4	1
5453	81	3450	2	1
5454	81	3451	2	1
5455	81	3452	1	1
5456	81	3453	4	1
5457	81	3454	5	5
5458	81	3455	4	2
5459	81	3456	3	2
5460	81	3457	1	1
5461	81	3458	4	4
5462	81	3460	2	2
5463	81	3461	5	0
5464	81	3462	1	1
5465	82	3376	2	2
5466	82	3377	5	4
5467	82	3379	4	2
5468	82	3380	4	2
5469	82	3382	5	1
5470	82	3383	5	4
5471	82	3384	2	0
5472	82	3385	5	1
5473	82	3387	3	1
5474	82	3388	2	2
5475	82	3389	4	1
5476	82	3390	2	2
5477	82	3391	2	2
5478	82	3392	5	0
5479	82	3395	2	2
5480	82	3396	2	0
5481	82	3397	4	4
5482	82	3398	2	2
5483	82	3399	4	2
5484	82	3400	2	0
5485	82	3401	1	1
5486	82	3402	3	0
5487	82	3403	4	2
5488	82	3404	3	1
5489	82	3405	5	5
5490	82	3406	4	2
5491	82	3407	2	1
5492	82	3408	3	3
5493	82	3409	3	0
5494	82	3410	3	2
5495	82	3412	5	0
5496	82	3413	4	3
5497	82	3414	3	2
5498	82	3415	2	0
5499	83	3376	5	3
5500	83	3377	4	3
5501	83	3378	4	3
5502	83	3379	1	0
5503	83	3381	1	1
5504	83	3382	1	0
5505	83	3383	2	2
5506	83	3384	3	0
5507	83	3385	3	3
5508	83	3386	2	1
5509	83	3387	4	0
5510	83	3388	3	1
5511	83	3389	5	1
5512	83	3391	5	1
5513	83	3392	4	1
5514	83	3393	3	1
5515	83	3394	1	1
5516	83	3395	5	2
5517	83	3396	4	3
5518	83	3398	2	1
5519	83	3399	1	1
5520	83	3400	2	0
5521	83	3401	1	1
5522	83	3402	1	1
5523	83	3403	3	0
5524	83	3405	4	0
5525	83	3406	5	0
5526	83	3408	2	1
5527	83	3409	2	0
5528	83	3410	1	1
5529	83	3411	5	0
5530	83	3412	5	1
5531	83	3413	1	1
5532	83	3414	5	0
5533	83	3416	5	5
5534	83	3417	2	1
5535	83	3418	1	1
5536	83	3419	5	4
5537	83	3420	4	1
5538	83	3421	3	3
5539	83	3422	3	3
5540	83	3423	3	2
5541	83	3424	4	4
5542	83	3426	3	0
5543	83	3427	4	4
5544	83	3428	3	3
5545	83	3429	5	1
5546	83	3430	1	1
5547	83	3431	3	1
5548	83	3432	1	1
5549	83	3433	2	0
5550	83	3434	1	0
5551	83	3435	1	1
5552	83	3436	5	4
5553	83	3437	3	0
5554	83	3438	4	1
5555	83	3439	3	1
5556	83	3440	5	0
5557	83	3441	2	0
5558	83	3442	2	0
5559	83	3445	1	0
5560	83	3446	2	2
5561	83	3447	3	0
5562	83	3448	5	1
5563	83	3450	2	2
5564	83	3451	2	2
5565	83	3453	1	1
5566	83	3454	3	0
5567	83	3455	2	2
5568	83	3457	2	2
5569	83	3458	1	1
5570	84	3463	4	4
5571	84	3464	1	0
5572	84	3465	1	1
5573	84	3466	2	0
5574	84	3467	5	1
5575	84	3468	3	1
5576	84	3469	1	1
5577	84	3470	2	2
5578	84	3472	4	2
5579	84	3475	2	2
5580	84	3476	5	1
5581	84	3477	2	0
5582	84	3479	2	2
5583	84	3482	3	0
5584	84	3483	1	0
5585	84	3484	5	5
5586	84	3485	4	2
5587	84	3486	3	1
5588	84	3487	1	0
5589	84	3489	2	1
5590	84	3490	3	3
5591	84	3491	2	0
5592	84	3492	1	1
5593	84	3493	4	1
5594	84	3494	1	1
5595	84	3495	1	0
5596	84	3496	2	0
5597	84	3497	3	3
5598	84	3498	3	2
5599	84	3499	4	2
5600	84	3500	2	0
5601	84	3502	4	0
5602	84	3503	4	1
5603	84	3504	5	3
5604	84	3505	2	1
5605	84	3506	2	1
5606	84	3507	2	1
5607	84	3508	2	2
5608	84	3510	2	0
5609	84	3511	1	1
5610	84	3512	4	4
5611	84	3513	4	2
5612	84	3515	4	0
5613	84	3519	1	0
5614	84	3520	4	2
5615	84	3521	1	0
5616	84	3522	5	2
5617	84	3523	2	1
5618	84	3524	3	2
5619	84	3527	1	1
5620	84	3528	2	0
5621	84	3529	5	4
5622	84	3531	2	2
5623	84	3532	5	0
5624	84	3533	4	0
5625	84	3536	4	4
5626	84	3537	4	1
5627	84	3538	2	1
5628	84	3539	5	3
5629	84	3540	3	2
5630	84	3541	5	4
5631	84	3542	3	3
5632	84	3543	2	1
5633	84	3544	1	1
5634	84	3545	4	0
5635	84	3546	2	0
5636	84	3547	2	1
5637	84	3548	5	5
5638	84	3549	3	0
5639	84	3550	3	3
5640	84	3551	2	1
5641	84	3552	5	0
5642	84	3553	4	1
5643	85	3463	2	0
5644	85	3464	2	1
5645	85	3466	5	1
5646	85	3467	5	4
5647	85	3468	1	1
5648	85	3469	2	0
5649	85	3470	3	1
5650	85	3471	2	1
5651	85	3473	1	1
5652	85	3474	3	1
5653	85	3475	4	1
5654	85	3476	2	2
5655	85	3477	2	0
5656	85	3478	5	1
5657	85	3479	5	2
5658	85	3480	1	0
5659	85	3481	5	4
5660	85	3482	1	1
5661	85	3485	5	1
5662	85	3486	2	2
5663	85	3487	2	0
5664	85	3488	5	5
5665	85	3489	1	0
5666	85	3490	4	1
5667	85	3492	3	3
5668	85	3493	3	3
5669	85	3494	2	0
5670	85	3495	2	0
5671	85	3496	2	1
5672	85	3497	2	1
5673	85	3500	5	1
5674	85	3501	1	0
5675	85	3503	4	3
5676	85	3504	1	0
5677	85	3505	2	0
5678	85	3506	3	0
5679	85	3508	3	0
5680	85	3509	2	1
5681	85	3510	4	3
5682	85	3511	1	0
5683	85	3512	3	3
5684	85	3513	5	0
5685	85	3514	5	0
5686	85	3515	1	1
5687	85	3516	2	1
5688	85	3517	1	1
5689	85	3518	5	1
5690	85	3519	3	3
5691	85	3520	1	1
5692	85	3521	3	0
5693	85	3522	3	2
5694	85	3523	5	2
5695	85	3524	3	3
5696	85	3525	4	2
5697	85	3526	5	2
5698	85	3527	2	0
5699	85	3528	4	0
5700	85	3529	1	0
5701	85	3530	1	1
5702	85	3531	5	3
5703	85	3532	1	1
5704	85	3533	5	3
5705	85	3534	1	0
5706	85	3535	3	1
5707	85	3536	1	1
5708	85	3537	2	2
5709	85	3538	5	4
5710	85	3539	3	2
5711	85	3540	5	3
5712	85	3542	4	2
5713	85	3543	3	0
5714	85	3544	2	0
5715	85	3545	4	1
5716	85	3546	1	0
5717	85	3547	1	1
5718	85	3548	3	3
5719	85	3549	1	1
5720	85	3551	5	0
5721	85	3552	4	3
5722	85	3553	4	2
5723	86	3554	2	2
5724	86	3555	4	1
5725	86	3556	4	1
5726	86	3557	5	0
5727	86	3559	5	1
5728	86	3560	3	1
5729	86	3561	4	2
5730	86	3562	3	3
5731	86	3563	1	1
5732	86	3564	3	2
5733	86	3565	2	0
5734	86	3566	1	1
5735	86	3567	4	0
5736	86	3568	1	0
5737	86	3569	4	0
5738	86	3570	5	0
5739	86	3571	4	0
5740	86	3572	4	1
5741	86	3573	4	4
5742	86	3574	5	5
5743	86	3575	4	1
5744	86	3577	1	0
5745	86	3578	2	0
5746	86	3581	1	1
5747	86	3582	1	0
5748	86	3584	2	1
5749	86	3586	5	0
5750	86	3587	1	1
5751	86	3588	1	1
5752	86	3589	3	1
5753	86	3590	3	2
5754	86	3591	4	4
5755	86	3592	2	0
5756	86	3594	5	4
5757	86	3595	3	2
5758	86	3598	1	1
5759	86	3599	1	1
5760	86	3600	1	0
5761	86	3603	5	3
5762	86	3604	4	4
5763	86	3606	2	0
5764	86	3607	3	3
5765	86	3608	3	0
5766	86	3609	3	3
5767	86	3610	2	2
5768	86	3612	3	3
5769	86	3613	2	2
5770	86	3615	4	4
5771	86	3616	1	0
5772	86	3617	2	0
5773	86	3618	1	1
5774	86	3620	2	2
5775	86	3621	4	1
5776	86	3622	4	4
5777	86	3623	1	1
5778	86	3624	4	3
5779	86	3626	5	5
5780	86	3627	5	4
5781	86	3628	2	2
5782	86	3629	1	0
5783	86	3630	4	1
5784	86	3631	1	1
5785	86	3632	1	1
5786	86	3633	2	0
5787	86	3634	5	1
5788	86	3635	2	0
5789	86	3636	3	3
5790	86	3637	1	1
5791	86	3638	2	1
5792	86	3639	3	0
5793	86	3640	3	3
5794	86	3641	3	2
5795	86	3642	5	5
5796	86	3643	5	4
5797	86	3644	1	1
5798	86	3645	5	5
5799	86	3646	4	0
5800	86	3647	3	3
5801	86	3648	5	4
5802	86	3650	2	2
5803	86	3651	5	0
5804	86	3652	5	0
5805	87	3555	3	1
5806	87	3556	5	0
5807	87	3557	2	0
5808	87	3558	3	3
5809	87	3559	1	1
5810	87	3560	3	2
5811	87	3561	3	0
5812	87	3563	2	2
5813	87	3564	1	1
5814	87	3565	1	0
5815	87	3567	2	0
5816	87	3568	3	0
5817	87	3569	5	3
5818	87	3570	4	0
5819	87	3571	4	4
5820	87	3572	3	0
5821	87	3573	2	1
5822	87	3574	4	2
5823	87	3575	1	0
5824	87	3577	4	2
5825	87	3579	2	0
5826	87	3580	3	3
5827	87	3581	2	2
5828	87	3582	4	2
5829	87	3583	2	2
5830	87	3584	1	1
5831	87	3585	3	3
5832	87	3586	3	0
5833	87	3588	1	0
5834	87	3590	3	1
5835	87	3591	2	1
5836	87	3592	2	2
5837	87	3593	2	1
5838	87	3594	1	1
5839	87	3595	5	0
5840	87	3596	1	0
5841	87	3597	3	2
5842	87	3598	1	0
5843	87	3599	4	3
5844	87	3600	2	1
5845	87	3601	4	3
5846	87	3602	2	0
5847	87	3605	5	1
5848	87	3606	5	3
5849	87	3607	1	0
5850	87	3609	5	5
5851	87	3610	5	3
5852	87	3611	5	2
5853	87	3613	4	3
5854	87	3614	4	4
5855	87	3615	2	1
5856	87	3616	1	0
5857	87	3617	2	0
5858	87	3618	5	4
5859	87	3619	5	2
5860	87	3620	4	3
5861	87	3621	3	0
5862	87	3622	5	5
5863	87	3623	3	0
5864	87	3624	1	1
5865	87	3625	1	1
5866	87	3626	3	3
5867	87	3627	2	0
5868	87	3628	5	4
5869	87	3629	2	0
5870	87	3630	3	2
5871	87	3631	3	3
5872	87	3633	1	1
5873	87	3634	4	1
5874	87	3635	3	1
5875	88	3554	2	2
5876	88	3555	3	1
5877	88	3556	4	0
5878	88	3557	4	0
5879	88	3560	2	2
5880	88	3561	3	0
5881	88	3562	3	2
5882	88	3565	5	3
5883	88	3566	3	1
5884	88	3567	1	0
5885	88	3568	4	1
5886	88	3569	5	4
5887	88	3571	1	1
5888	88	3572	2	2
5889	88	3573	1	0
5890	88	3574	2	0
5891	88	3575	2	2
5892	88	3576	5	3
5893	88	3578	5	0
5894	88	3579	5	3
5895	88	3581	4	1
5896	88	3582	4	4
5897	88	3583	1	1
5898	88	3584	1	1
5899	88	3585	4	0
5900	88	3586	1	0
5901	88	3587	3	0
5902	88	3588	3	1
5903	88	3589	1	0
5904	88	3590	1	0
5905	88	3591	1	0
5906	88	3592	3	1
5907	88	3593	3	2
5908	88	3594	4	1
5909	88	3596	2	2
5910	88	3597	5	5
5911	88	3598	2	0
5912	88	3599	4	0
5913	88	3600	3	2
5914	88	3601	3	1
5915	88	3602	5	3
5916	88	3603	2	0
5917	88	3604	5	3
5918	88	3606	4	4
5919	88	3607	1	0
5920	88	3608	2	0
5921	88	3609	5	1
5922	88	3610	3	2
5923	88	3611	5	4
5924	88	3612	1	0
5925	88	3613	3	2
5926	88	3615	5	5
5927	88	3617	3	1
5928	88	3618	3	3
5929	88	3619	2	1
5930	88	3620	1	1
5931	88	3621	2	1
5932	88	3623	5	0
5933	88	3624	2	2
5934	88	3625	1	1
5935	88	3626	3	1
5936	88	3627	2	0
5937	88	3628	3	3
5938	88	3629	4	0
5939	88	3630	2	2
5940	88	3631	4	2
5941	88	3633	4	1
5942	88	3634	3	3
5943	88	3635	2	1
5944	88	3636	4	4
5945	88	3638	1	1
5946	88	3639	1	1
5947	88	3640	1	1
5948	88	3641	1	0
5949	88	3642	4	2
5950	88	3643	1	1
5951	88	3644	5	2
5952	88	3645	5	0
5953	88	3647	2	1
5954	88	3648	3	1
5955	88	3649	3	2
5956	88	3650	4	1
5957	88	3651	5	5
5958	88	3652	3	2
5959	89	3653	2	0
5960	89	3654	5	2
5961	89	3655	4	2
5962	89	3656	3	1
5963	89	3657	3	0
5964	89	3658	1	1
5965	89	3659	1	1
5966	89	3662	4	4
5967	89	3664	3	3
5968	89	3666	4	0
5969	89	3667	5	2
5970	89	3668	2	1
5971	89	3670	2	1
5972	89	3671	4	1
5973	89	3672	2	2
5974	89	3674	4	2
5975	89	3675	5	2
5976	89	3676	5	0
5977	89	3677	5	3
5978	89	3678	3	1
5979	89	3679	4	4
5980	89	3680	1	1
5981	89	3681	1	1
5982	89	3682	2	1
5983	89	3683	2	1
5984	89	3684	2	0
5985	89	3685	3	0
5986	89	3686	5	5
5987	89	3687	2	1
5988	89	3688	1	0
5989	89	3689	5	2
5990	89	3690	4	4
5991	89	3692	5	4
5992	89	3693	1	0
5993	89	3694	2	1
5994	89	3695	2	1
5995	89	3696	5	0
5996	89	3698	1	0
5997	89	3699	2	0
5998	89	3700	3	1
5999	89	3701	1	0
6000	89	3702	1	1
6001	89	3704	4	2
6002	89	3705	4	3
6003	89	3706	2	0
6004	89	3708	3	3
6005	89	3709	2	0
6006	89	3711	1	0
6007	89	3712	5	2
6008	89	3713	3	0
6009	89	3714	1	0
6010	89	3715	3	0
6011	89	3716	5	2
6012	89	3717	1	1
6013	89	3719	5	1
6014	89	3720	2	2
6015	89	3721	5	3
6016	89	3722	3	0
6017	89	3723	1	1
6018	89	3724	3	0
6019	89	3726	4	1
6020	89	3729	2	0
6021	89	3730	5	3
6022	90	3653	2	1
6023	90	3654	3	0
6024	90	3655	5	2
6025	90	3656	3	3
6026	90	3657	1	1
6027	90	3659	4	2
6028	90	3660	1	1
6029	90	3661	2	1
6030	90	3662	5	3
6031	90	3663	1	1
6032	90	3664	3	2
6033	90	3665	2	2
6034	90	3666	1	0
6035	90	3668	5	0
6036	90	3669	5	2
6037	90	3670	3	0
6038	90	3671	2	0
6039	90	3672	1	1
6040	90	3673	3	0
6041	90	3675	3	1
6042	90	3676	1	1
6043	90	3677	5	1
6044	90	3678	1	1
6045	90	3681	4	0
6046	90	3682	4	1
6047	90	3683	1	0
6048	90	3684	4	1
6049	90	3686	5	4
6050	90	3687	1	0
6051	90	3689	3	0
6052	90	3690	5	2
6053	90	3691	5	5
6054	90	3692	1	0
6055	90	3693	5	5
6056	90	3695	2	0
6057	90	3696	2	2
6058	90	3697	2	0
6059	90	3699	2	1
6060	90	3700	2	1
6061	90	3702	4	0
6062	90	3703	3	3
6063	90	3704	5	0
6064	90	3705	3	2
6065	90	3706	4	4
6066	90	3707	5	3
6067	90	3708	3	0
6068	90	3709	3	0
6069	90	3710	1	0
6070	90	3711	1	0
6071	90	3712	5	1
6072	90	3714	3	2
6073	90	3715	3	2
6074	90	3717	2	0
6075	90	3718	2	1
6076	91	3772	1	1
6077	91	3773	1	0
6078	91	3774	5	2
6079	91	3775	4	0
6080	91	3776	2	1
6081	91	3777	5	4
6082	91	3778	1	0
6083	91	3780	5	1
6084	91	3781	2	2
6085	91	3782	4	4
6086	91	3784	1	0
6087	91	3785	5	0
6088	91	3786	2	0
6089	91	3787	3	1
6090	91	3788	1	1
6091	91	3789	5	5
6092	91	3790	1	1
6093	91	3791	4	2
6094	91	3792	4	4
6095	91	3793	2	2
6096	91	3794	3	3
6097	91	3797	2	2
6098	91	3798	2	2
6099	91	3799	1	1
6100	91	3800	1	1
6101	91	3801	4	4
6102	91	3803	3	3
6103	91	3804	2	2
6104	91	3805	5	1
6105	91	3806	3	2
6106	91	3807	2	0
6107	91	3808	4	2
6108	91	3809	1	1
6109	91	3810	4	1
6110	91	3811	2	0
6111	91	3812	1	1
6112	91	3813	4	4
6113	91	3814	3	2
6114	91	3815	4	1
6115	91	3816	3	0
6116	91	3817	5	2
6117	91	3818	1	1
6118	91	3819	2	0
6119	91	3820	1	1
6120	91	3821	2	2
6121	91	3822	2	2
6122	91	3823	1	0
6123	91	3824	4	0
6124	91	3825	3	1
6125	91	3826	5	1
6126	91	3827	5	3
6127	91	3828	1	1
6128	91	3829	2	1
6129	91	3830	3	2
6130	91	3831	5	2
6131	91	3832	3	2
6132	91	3833	4	1
6133	91	3835	1	0
6134	91	3836	2	2
6135	91	3837	4	3
6136	91	3838	2	1
6137	91	3840	1	1
6138	91	3841	2	0
6139	91	3842	5	5
6140	91	3843	5	2
6141	91	3845	1	0
6142	91	3846	3	0
6143	91	3847	5	1
6144	91	3848	1	0
6145	91	3849	1	1
6146	91	3850	3	2
6147	91	3851	4	3
6148	91	3852	3	2
6149	92	3772	5	3
6150	92	3773	4	2
6151	92	3774	5	4
6152	92	3775	2	0
6153	92	3776	1	1
6154	92	3777	2	2
6155	92	3778	5	5
6156	92	3779	5	2
6157	92	3780	5	3
6158	92	3781	1	1
6159	92	3782	5	0
6160	92	3783	3	2
6161	92	3784	4	4
6162	92	3785	4	1
6163	92	3786	1	0
6164	92	3787	3	2
6165	92	3788	5	4
6166	92	3789	1	0
6167	92	3790	1	1
6168	92	3791	4	4
6169	92	3792	1	0
6170	92	3793	5	2
6171	92	3794	3	0
6172	92	3795	4	4
6173	92	3796	2	2
6174	92	3797	3	0
6175	92	3798	2	2
6176	92	3800	1	1
6177	92	3801	2	0
6178	92	3802	1	0
6179	92	3804	4	3
6180	92	3805	2	2
6181	92	3806	3	3
6182	92	3807	2	2
6183	92	3808	1	1
6184	92	3809	2	2
6185	92	3810	4	3
6186	92	3811	3	3
6187	92	3812	2	0
6188	92	3813	5	3
6189	92	3814	5	1
6190	92	3816	4	1
6191	92	3817	4	4
6192	92	3818	3	1
6193	92	3819	3	1
6194	92	3820	5	4
6195	92	3821	1	1
6196	92	3822	3	0
6197	92	3823	1	0
6198	92	3825	1	0
6199	92	3828	1	0
6200	92	3829	2	2
6201	92	3830	3	1
6202	92	3831	5	0
6203	92	3832	4	1
6204	92	3833	4	2
6205	92	3834	1	0
6206	92	3835	2	1
6207	92	3836	5	2
6208	92	3837	1	1
6209	92	3838	4	3
6210	92	3839	2	1
6211	92	3840	2	0
6212	92	3841	5	0
6213	92	3842	3	0
6214	92	3843	4	3
6215	92	3844	4	3
6216	92	3845	4	3
6217	92	3846	5	3
6218	92	3847	5	4
6219	92	3848	3	3
6220	92	3849	5	5
6221	92	3850	5	3
6222	92	3851	1	1
6223	92	3852	2	2
6224	93	3772	2	1
6225	93	3774	3	2
6226	93	3775	1	1
6227	93	3776	1	1
6228	93	3777	4	1
6229	93	3778	1	1
6230	93	3779	4	1
6231	93	3780	3	2
6232	93	3781	2	0
6233	93	3782	4	3
6234	93	3785	1	0
6235	93	3786	3	1
6236	93	3787	3	0
6237	93	3788	4	3
6238	93	3789	2	2
6239	93	3790	1	1
6240	93	3791	1	0
6241	93	3792	2	0
6242	93	3793	1	1
6243	93	3794	1	1
6244	93	3795	3	2
6245	93	3796	4	0
6246	93	3797	4	2
6247	93	3798	4	3
6248	93	3800	2	0
6249	93	3801	1	1
6250	93	3802	4	1
6251	93	3803	3	3
6252	93	3804	1	1
6253	93	3806	2	2
6254	93	3807	2	0
6255	93	3808	2	0
6256	93	3809	5	1
6257	93	3810	5	0
6258	93	3811	3	0
6259	93	3812	2	2
6260	93	3814	1	1
6261	93	3815	1	0
6262	93	3816	5	5
6263	93	3817	1	0
6264	93	3818	2	2
6265	93	3819	3	2
6266	93	3821	5	2
6267	93	3822	5	5
6268	93	3823	3	2
6269	93	3824	4	3
6270	93	3825	4	3
6271	93	3826	4	2
6272	93	3827	3	2
6273	93	3828	1	1
6274	93	3829	2	1
6275	93	3830	4	1
6276	93	3831	4	3
6277	93	3832	3	1
6278	93	3833	2	0
6279	93	3834	2	2
6280	93	3835	1	0
6281	93	3836	5	3
6282	93	3837	1	1
6283	93	3838	3	3
6284	93	3840	5	5
6285	93	3841	3	0
6286	93	3842	5	2
6287	93	3843	3	1
6288	93	3844	4	0
6289	93	3845	4	4
6290	93	3846	3	0
6291	93	3847	5	0
6292	93	3848	1	1
6293	93	3849	3	1
6294	93	3850	4	4
6295	94	3853	2	1
6296	94	3854	4	3
6297	94	3855	1	1
6298	94	3856	5	1
6299	94	3857	1	0
6300	94	3858	2	1
6301	94	3859	2	2
6302	94	3860	4	0
6303	94	3862	5	1
6304	94	3863	3	2
6305	94	3864	2	0
6306	94	3865	2	0
6307	94	3866	4	2
6308	94	3867	2	1
6309	94	3868	2	2
6310	94	3869	2	2
6311	94	3870	3	2
6312	94	3871	2	1
6313	94	3872	4	1
6314	94	3873	2	2
6315	94	3875	5	5
6316	94	3876	2	0
6317	94	3877	3	3
6318	94	3878	2	1
6319	94	3879	5	3
6320	94	3880	4	0
6321	94	3881	1	0
6322	94	3882	2	1
6323	94	3883	3	3
6324	94	3884	5	5
6325	94	3885	2	1
6326	94	3886	4	3
6327	94	3887	1	1
6328	94	3888	1	1
6329	94	3889	1	0
6330	94	3890	2	0
6331	94	3892	4	4
6332	94	3893	2	1
6333	95	3853	3	0
6334	95	3854	1	0
6335	95	3856	4	4
6336	95	3857	1	0
6337	95	3858	3	2
6338	95	3859	3	0
6339	95	3860	3	3
6340	95	3861	5	3
6341	95	3863	3	2
6342	95	3864	1	0
6343	95	3865	2	1
6344	95	3866	4	0
6345	95	3868	4	3
6346	95	3869	4	2
6347	95	3870	3	1
6348	95	3871	2	2
6349	95	3872	2	2
6350	95	3873	3	2
6351	95	3875	2	1
6352	95	3876	5	4
6353	95	3878	5	1
6354	95	3879	2	2
6355	95	3880	2	1
6356	95	3881	3	2
6357	95	3882	3	1
6358	95	3883	1	0
6359	95	3884	5	1
6360	95	3885	2	2
6361	95	3886	1	1
6362	95	3887	3	3
6363	95	3888	1	1
6364	95	3890	1	1
6365	95	3893	3	1
6366	95	3894	4	4
6367	95	3895	4	3
6368	95	3897	2	2
6369	95	3898	2	0
6370	95	3899	5	1
6371	95	3900	5	2
6372	95	3901	4	2
6373	95	3902	4	0
6374	95	3903	2	2
6375	95	3904	3	2
6376	95	3906	1	1
6377	95	3907	5	4
6378	95	3908	1	0
6379	95	3911	2	1
6380	95	3912	4	2
6381	95	3913	1	0
6382	95	3914	5	3
6383	95	3915	4	0
6384	95	3916	5	2
6385	95	3917	4	1
6386	95	3918	5	3
6387	95	3919	2	1
6388	95	3920	2	2
6389	95	3922	5	1
6390	95	3924	4	1
6391	95	3925	5	4
6392	95	3926	2	2
6393	95	3927	1	0
6394	95	3929	2	2
6395	96	3962	3	1
6396	96	3964	5	4
6397	96	3965	3	3
6398	96	3966	3	2
6399	96	3967	2	2
6400	96	3969	1	0
6401	96	3972	5	2
6402	96	3973	2	1
6403	96	3974	4	4
6404	96	3975	5	2
6405	96	3976	2	2
6406	96	3977	4	1
6407	96	3978	2	2
6408	96	3979	2	2
6409	96	3980	5	2
6410	96	3981	5	1
6411	96	3982	2	2
6412	96	3983	5	1
6413	96	3984	2	0
6414	96	3985	3	1
6415	96	3986	5	1
6416	96	3987	5	0
6417	96	3988	2	0
6418	96	3989	4	3
6419	96	3990	2	1
6420	96	3991	1	0
6421	96	3992	5	3
6422	96	3993	1	0
6423	96	3994	4	3
6424	96	3995	3	0
6425	96	3996	5	3
6426	96	3997	5	4
6427	96	3998	2	1
6428	96	3999	2	1
6429	96	4000	2	0
6430	96	4002	2	0
6431	96	4003	5	3
6432	96	4004	2	1
6433	96	4005	4	4
6434	96	4006	3	0
6435	96	4007	2	2
6436	96	4008	2	0
6437	96	4009	1	1
6438	96	4010	5	3
6439	96	4011	1	1
6440	96	4012	3	1
6441	96	4013	5	3
6442	96	4014	5	5
6443	96	4015	4	2
6444	96	4016	3	3
6445	96	4017	2	2
6446	96	4018	5	2
6447	96	4019	2	2
6448	96	4021	1	0
6449	97	3961	2	1
6450	97	3962	5	0
6451	97	3963	4	1
6452	97	3964	3	3
6453	97	3965	4	4
6454	97	3966	1	1
6455	97	3967	3	1
6456	97	3968	1	0
6457	97	3969	1	1
6458	97	3970	1	1
6459	97	3971	5	2
6460	97	3972	5	1
6461	97	3973	4	0
6462	97	3974	5	4
6463	97	3975	1	1
6464	97	3976	5	3
6465	97	3977	5	4
6466	97	3978	5	1
6467	97	3979	4	3
6468	97	3980	5	4
6469	97	3982	2	0
6470	97	3983	2	0
6471	97	3984	1	1
6472	97	3985	3	0
6473	97	3986	4	0
6474	97	3987	5	0
6475	97	3988	3	3
6476	97	3989	1	0
6477	97	3990	3	0
6478	97	3991	5	1
6479	97	3995	3	2
6480	97	3996	2	2
6481	97	3997	1	1
6482	97	3998	2	2
6483	97	4000	1	0
6484	97	4002	4	2
6485	97	4003	4	3
6486	97	4004	1	0
6487	97	4005	2	1
6488	97	4006	2	2
6489	97	4007	1	0
6490	97	4008	5	1
6491	97	4009	4	4
6492	97	4010	5	5
6493	97	4011	5	5
6494	97	4012	2	0
6495	97	4013	3	0
6496	97	4015	5	5
6497	97	4019	1	0
6498	97	4020	3	2
6499	97	4021	5	1
6500	97	4023	1	1
6501	97	4024	1	1
6502	97	4025	3	0
6503	97	4026	1	1
6504	97	4027	1	0
6505	97	4028	2	1
6506	97	4029	4	0
6507	97	4030	2	0
6508	97	4031	4	3
6509	97	4033	3	0
6510	97	4034	5	2
6511	97	4035	1	1
6512	97	4036	1	1
6513	97	4039	3	1
6514	97	4043	1	1
6515	97	4044	2	0
6516	97	4045	4	0
6517	97	4046	5	2
6518	97	4047	1	0
6519	97	4048	3	2
6520	97	4049	2	1
6521	97	4053	2	0
6522	97	4054	4	0
6523	98	4069	1	0
6524	98	4070	3	3
6525	98	4071	3	1
6526	98	4073	4	2
6527	98	4074	2	1
6528	98	4075	5	3
6529	98	4076	5	5
6530	98	4077	3	0
6531	98	4079	5	4
6532	98	4080	5	3
6533	98	4081	2	0
6534	98	4082	1	0
6535	98	4084	5	3
6536	98	4085	2	0
6537	98	4086	2	1
6538	98	4087	2	0
6539	98	4088	1	0
6540	98	4089	4	1
6541	98	4090	1	0
6542	98	4091	1	1
6543	98	4092	1	1
6544	98	4094	5	4
6545	98	4096	4	4
6546	98	4097	4	1
6547	98	4098	5	5
6548	98	4099	5	3
6549	98	4101	4	1
6550	98	4103	5	5
6551	98	4104	5	1
6552	98	4105	3	2
6553	98	4106	3	2
6554	98	4107	3	1
6555	98	4108	5	3
6556	98	4109	2	0
6557	98	4110	5	4
6558	98	4111	4	2
6559	98	4112	4	2
6560	98	4113	2	2
6561	98	4114	1	0
6562	98	4115	3	2
6563	98	4116	1	0
6564	98	4117	2	2
6565	98	4118	1	1
6566	98	4119	4	2
6567	98	4120	4	0
6568	98	4121	4	1
6569	98	4128	1	1
6570	99	4070	1	1
6571	99	4072	4	2
6572	99	4073	5	5
6573	99	4074	3	3
6574	99	4075	3	1
6575	99	4076	4	3
6576	99	4078	4	4
6577	99	4079	1	0
6578	99	4080	3	0
6579	99	4081	4	2
6580	99	4083	2	0
6581	99	4084	4	1
6582	99	4085	1	1
6583	99	4086	3	1
6584	99	4087	5	0
6585	99	4088	4	0
6586	99	4090	5	4
6587	99	4091	1	0
6588	99	4092	2	2
6589	99	4093	3	1
6590	99	4094	5	1
6591	99	4096	4	1
6592	99	4099	5	4
6593	99	4103	1	0
6594	99	4104	4	3
6595	99	4105	2	0
6596	99	4106	2	2
6597	99	4108	4	4
6598	99	4109	1	1
6599	99	4110	4	1
6600	99	4111	1	1
6601	99	4112	1	1
6602	99	4113	5	5
6603	99	4114	1	1
6604	99	4115	3	1
6605	99	4117	1	1
6606	99	4118	4	3
6607	99	4119	4	3
6608	99	4120	2	2
6609	99	4121	1	0
6610	99	4122	2	2
6611	100	4189	1	0
6612	100	4190	4	2
6613	100	4191	5	4
6614	100	4192	1	1
6615	100	4193	4	1
6616	100	4194	5	1
6617	100	4195	2	2
6618	100	4196	3	3
6619	100	4197	2	2
6620	100	4198	1	0
6621	100	4199	1	1
6622	100	4201	4	2
6623	100	4203	4	4
6624	100	4204	4	3
6625	100	4205	5	1
6626	100	4206	1	1
6627	100	4207	1	0
6628	100	4208	1	1
6629	100	4209	5	5
6630	100	4210	5	1
6631	100	4213	3	2
6632	100	4214	4	0
6633	100	4215	2	0
6634	100	4216	4	2
6635	100	4217	5	2
6636	100	4218	1	1
6637	100	4219	1	0
6638	100	4221	2	1
6639	100	4222	1	0
6640	100	4223	3	0
6641	100	4225	3	0
6642	100	4226	2	1
6643	100	4227	1	0
6644	100	4229	4	3
6645	100	4231	2	1
6646	100	4232	5	5
6647	100	4233	1	1
6648	100	4234	2	2
6649	100	4235	5	0
6650	100	4236	2	1
6651	100	4237	1	1
6652	100	4238	2	2
6653	100	4239	3	0
6654	100	4240	5	2
6655	100	4241	5	3
6656	100	4242	2	2
6657	100	4243	3	1
6658	100	4245	2	2
6659	100	4246	1	1
6660	100	4247	5	1
6661	100	4248	3	2
6662	100	4249	1	1
6663	100	4250	5	3
6664	100	4251	2	0
6665	100	4252	5	4
6666	100	4253	1	1
6667	100	4254	5	5
6668	100	4257	2	0
6669	100	4258	1	1
6670	100	4260	3	0
6671	100	4261	3	1
6672	100	4262	1	1
6673	100	4263	1	1
6674	100	4264	1	1
6675	100	4265	2	0
6676	100	4266	2	2
6677	100	4267	1	0
6678	100	4268	5	3
6679	100	4269	2	1
6680	100	4270	3	0
6681	100	4271	1	1
6682	100	4272	1	0
6683	100	4273	5	5
6684	100	4274	3	3
6685	100	4275	5	1
6686	100	4276	1	1
6687	100	4277	2	2
6688	100	4278	3	3
6689	100	4279	4	4
6690	100	4280	4	0
6691	100	4281	5	5
6692	100	4283	3	2
6693	100	4284	5	2
6694	100	4285	3	0
6695	100	4286	3	1
6696	100	4287	2	1
6697	100	4289	5	2
6698	100	4290	3	2
6699	100	4298	1	0
6700	101	4189	3	1
6701	101	4190	1	1
6702	101	4191	4	3
6703	101	4192	5	0
6704	101	4193	2	0
6705	101	4194	2	1
6706	101	4195	2	0
6707	101	4196	5	0
6708	101	4198	1	1
6709	101	4200	1	1
6710	101	4201	5	5
6711	101	4202	2	2
6712	101	4204	3	3
6713	101	4206	5	2
6714	101	4207	1	0
6715	101	4208	4	4
6716	101	4210	2	0
6717	101	4211	1	0
6718	101	4212	4	1
6719	101	4213	1	0
6720	101	4214	2	0
6721	101	4215	2	2
6722	101	4216	5	1
6723	101	4218	4	2
6724	101	4219	4	0
6725	101	4220	4	0
6726	101	4221	1	1
6727	101	4222	5	5
6728	101	4223	4	4
6729	101	4225	2	2
6730	101	4226	3	0
6731	101	4228	5	3
6732	101	4229	2	1
6733	101	4230	5	1
6734	101	4231	1	0
6735	101	4233	5	5
6736	101	4234	5	0
6737	101	4235	3	2
6738	101	4237	4	4
6739	101	4238	5	0
6740	101	4240	5	5
6741	101	4241	3	2
6742	101	4242	2	0
6743	101	4243	2	2
6744	101	4244	3	1
6745	101	4245	4	0
6746	101	4249	1	1
6747	101	4250	1	1
6748	101	4251	1	0
6749	101	4252	5	0
6750	101	4253	2	2
6751	101	4254	1	0
6752	101	4255	1	0
6753	101	4256	1	1
6754	101	4258	3	3
6755	101	4259	1	0
6756	101	4260	4	3
6757	101	4261	4	3
6758	101	4262	2	1
6759	101	4263	5	1
6760	101	4264	3	0
6761	101	4265	5	4
6762	101	4266	1	0
6763	101	4268	2	2
6764	101	4269	2	2
6765	101	4271	3	1
6766	101	4272	2	0
6767	101	4275	5	0
6768	101	4276	5	3
6769	101	4277	2	1
6770	101	4278	5	2
6771	101	4279	3	1
6772	101	4280	3	2
6773	101	4281	1	1
6774	101	4282	3	1
6775	101	4283	3	1
6776	101	4284	5	5
6777	101	4285	3	2
6778	101	4286	1	1
6779	101	4287	3	0
6780	101	4288	5	2
6781	101	4290	1	1
6782	101	4291	3	3
6783	101	4292	5	1
6784	101	4293	2	2
6785	101	4294	1	0
6786	101	4295	2	0
6787	101	4296	4	2
6788	101	4297	4	2
6789	101	4298	3	2
6790	101	4299	1	1
6791	101	4300	4	1
6792	102	4302	5	2
6793	102	4303	2	1
6794	102	4304	2	2
6795	102	4305	1	0
6796	102	4306	1	0
6797	102	4308	5	2
6798	102	4309	5	3
6799	102	4310	3	0
6800	102	4311	5	0
6801	102	4312	4	4
6802	102	4313	3	1
6803	102	4314	5	1
6804	102	4315	5	0
6805	102	4316	2	1
6806	102	4317	2	1
6807	102	4318	4	2
6808	102	4319	1	0
6809	102	4321	3	0
6810	102	4322	5	2
6811	102	4323	4	2
6812	102	4325	4	3
6813	102	4326	5	4
6814	102	4328	3	3
6815	102	4329	4	1
6816	102	4330	2	0
6817	102	4331	4	4
6818	102	4332	2	0
6819	102	4335	2	1
6820	102	4336	4	0
6821	102	4338	1	0
6822	102	4339	4	4
6823	102	4340	1	1
6824	102	4342	4	2
6825	102	4343	2	0
6826	102	4344	1	0
6827	102	4345	3	1
6828	102	4346	4	0
6829	102	4347	3	3
6830	102	4348	3	3
6831	102	4350	4	2
6832	102	4351	4	2
6833	102	4352	4	1
6834	102	4355	4	4
6835	102	4356	5	0
6836	102	4357	2	0
6837	102	4358	4	1
6838	102	4359	2	0
6839	102	4360	3	3
6840	102	4361	5	5
6841	102	4362	2	2
6842	102	4363	2	2
6843	102	4364	4	4
6844	102	4366	4	1
6845	102	4367	5	4
6846	102	4369	3	1
6847	102	4370	3	2
6848	102	4371	3	2
6849	102	4372	3	0
6850	102	4373	4	0
6851	102	4374	2	1
6852	102	4375	1	1
6853	103	4302	2	0
6854	103	4303	3	3
6855	103	4304	2	0
6856	103	4305	3	0
6857	103	4306	3	3
6858	103	4307	5	2
6859	103	4308	3	0
6860	103	4309	1	0
6861	103	4310	5	4
6862	103	4311	1	0
6863	103	4312	2	0
6864	103	4313	3	2
6865	103	4314	3	3
6866	103	4315	5	1
6867	103	4316	5	1
6868	103	4318	3	0
6869	103	4319	5	5
6870	103	4320	4	1
6871	103	4322	4	0
6872	103	4323	3	2
6873	103	4325	2	2
6874	103	4326	4	4
6875	103	4327	4	0
6876	103	4328	4	2
6877	103	4329	1	0
6878	103	4330	1	1
6879	103	4332	3	0
6880	103	4333	2	2
6881	103	4335	2	0
6882	103	4336	3	3
6883	103	4337	5	5
6884	103	4338	2	2
6885	103	4339	1	0
6886	103	4340	1	0
6887	103	4342	1	1
6888	103	4343	3	0
6889	103	4344	4	3
6890	103	4345	5	0
6891	103	4346	3	1
6892	103	4347	1	1
6893	103	4348	2	2
6894	103	4349	1	1
6895	103	4350	5	1
6896	103	4351	4	4
6897	103	4352	5	0
6898	103	4353	5	3
6899	103	4354	1	1
6900	103	4356	3	1
6901	103	4357	3	1
6902	103	4358	2	1
6903	103	4359	1	1
6904	103	4360	3	1
6905	103	4361	2	0
6906	103	4362	1	1
6907	103	4363	3	2
6908	103	4364	3	1
6909	103	4365	1	0
6910	103	4366	4	3
6911	103	4368	2	0
6912	103	4369	2	1
6913	103	4371	2	2
6914	103	4372	3	2
6915	103	4374	5	3
6916	103	4375	3	0
6917	103	4376	5	4
6918	103	4377	2	0
6919	103	4378	4	3
6920	103	4379	5	0
6921	103	4380	5	3
6922	103	4381	2	2
6923	103	4382	5	3
6924	103	4383	4	3
6925	103	4384	2	2
6926	103	4385	4	4
6927	103	4386	1	0
6928	103	4387	2	1
6929	103	4389	5	0
6930	103	4390	5	4
6931	103	4391	4	0
6932	103	4394	1	1
6933	104	4407	5	2
6934	104	4408	3	3
6935	104	4409	1	1
6936	104	4410	3	1
6937	104	4411	1	1
6938	104	4412	4	1
6939	104	4413	4	0
6940	104	4414	4	2
6941	104	4415	2	2
6942	104	4416	2	2
6943	104	4417	3	0
6944	104	4418	4	1
6945	104	4419	3	1
6946	104	4420	2	2
6947	104	4421	5	1
6948	104	4422	3	0
6949	104	4423	4	4
6950	104	4425	1	0
6951	104	4426	2	1
6952	104	4427	5	3
6953	104	4428	4	1
6954	104	4429	4	3
6955	104	4430	1	0
6956	104	4431	1	1
6957	104	4432	4	1
6958	104	4433	3	0
6959	104	4434	3	0
6960	104	4435	5	5
6961	104	4436	1	0
6962	104	4437	4	1
6963	104	4438	1	1
6964	104	4439	1	1
6965	104	4440	5	5
6966	104	4442	3	0
6967	104	4443	3	1
6968	104	4444	2	1
6969	104	4445	1	0
6970	104	4446	1	0
6971	104	4448	3	2
6972	104	4449	3	0
6973	104	4450	2	2
6974	104	4451	1	1
6975	104	4452	3	1
6976	104	4453	1	0
6977	104	4454	2	0
6978	104	4455	3	1
6979	104	4456	4	3
6980	104	4457	1	1
6981	104	4458	1	1
6982	104	4459	4	4
6983	104	4460	5	4
6984	104	4461	4	2
6985	104	4462	1	1
6986	104	4465	4	2
6987	104	4466	2	2
6988	104	4467	2	1
6989	105	4407	1	1
6990	105	4408	1	0
6991	105	4409	2	2
6992	105	4410	3	1
6993	105	4411	3	0
6994	105	4412	5	0
6995	105	4413	4	1
6996	105	4415	3	1
6997	105	4416	4	4
6998	105	4417	2	2
6999	105	4418	5	0
7000	105	4419	1	0
7001	105	4420	2	1
7002	105	4421	1	1
7003	105	4422	2	2
7004	105	4424	1	0
7005	105	4425	5	0
7006	105	4426	3	3
7007	105	4427	2	0
7008	105	4428	1	0
7009	105	4429	5	4
7010	105	4430	2	1
7011	105	4431	2	0
7012	105	4432	3	1
7013	105	4433	2	2
7014	105	4435	1	0
7015	105	4436	3	3
7016	105	4437	3	0
7017	105	4438	5	5
7018	105	4439	2	0
7019	105	4440	2	1
7020	105	4441	5	4
7021	105	4442	2	2
7022	105	4443	5	3
7023	105	4444	4	1
7024	105	4445	1	0
7025	105	4446	4	2
7026	105	4447	3	3
7027	105	4448	4	1
7028	105	4450	2	0
7029	105	4452	1	1
7030	105	4453	5	3
7031	105	4456	1	0
7032	106	4494	2	1
7033	106	4495	3	3
7034	106	4496	5	1
7035	106	4497	2	2
7036	106	4499	1	0
7037	106	4500	1	0
7038	106	4502	5	0
7039	106	4503	2	1
7040	106	4504	3	3
7041	106	4505	2	2
7042	106	4506	5	3
7043	106	4507	1	0
7044	106	4508	1	1
7045	106	4509	3	1
7046	106	4510	1	0
7047	106	4511	5	5
7048	106	4512	4	3
7049	106	4513	2	2
7050	106	4515	5	4
7051	106	4516	4	0
7052	106	4517	4	0
7053	106	4518	4	0
7054	106	4519	3	1
7055	106	4520	4	1
7056	106	4521	1	0
7057	106	4523	5	5
7058	106	4526	2	1
7059	106	4527	5	5
7060	106	4530	4	1
7061	106	4531	1	1
7062	106	4532	5	2
7063	106	4533	3	2
7064	106	4534	2	1
7065	106	4535	1	0
7066	106	4536	3	0
7067	106	4537	1	1
7068	106	4538	1	0
7069	106	4539	2	2
7070	106	4540	3	3
7071	106	4541	5	0
7072	106	4542	3	1
7073	106	4543	2	2
7074	106	4544	4	0
7075	106	4546	3	3
7076	106	4547	5	4
7077	106	4549	1	0
7078	106	4550	3	2
7079	106	4552	1	0
7080	106	4553	1	1
7081	106	4555	2	0
7082	106	4556	2	0
7083	106	4557	4	3
7084	106	4558	1	1
7085	106	4559	5	4
7086	106	4561	4	4
7087	106	4562	5	5
7088	106	4563	5	3
7089	106	4564	3	1
7090	106	4565	5	4
7091	106	4566	2	0
7092	106	4569	2	0
7093	106	4570	3	3
7094	106	4571	4	3
7095	106	4572	2	0
7096	106	4573	1	0
7097	106	4574	1	0
7098	106	4575	1	0
7099	106	4577	2	2
7100	106	4578	5	3
7101	106	4579	1	1
7102	106	4580	3	3
7103	106	4581	1	1
7104	106	4582	4	2
7105	106	4583	1	1
7106	106	4585	2	1
7107	106	4588	2	2
7108	107	4494	4	0
7109	107	4495	3	1
7110	107	4497	4	2
7111	107	4498	5	2
7112	107	4500	4	4
7113	107	4501	5	5
7114	107	4503	2	1
7115	107	4504	4	1
7116	107	4505	5	5
7117	107	4506	1	1
7118	107	4507	4	4
7119	107	4508	1	1
7120	107	4509	3	0
7121	107	4510	5	4
7122	107	4512	2	1
7123	107	4513	1	0
7124	107	4514	3	1
7125	107	4517	4	3
7126	107	4518	3	1
7127	107	4519	2	1
7128	107	4520	1	1
7129	107	4522	2	2
7130	107	4523	1	0
7131	107	4524	1	0
7132	107	4525	4	3
7133	107	4526	5	4
7134	107	4527	2	1
7135	107	4528	2	1
7136	107	4529	1	1
7137	107	4530	5	4
7138	107	4531	2	0
7139	107	4532	3	1
7140	107	4533	3	1
7141	107	4534	5	4
7142	107	4535	2	0
7143	107	4536	5	5
7144	107	4538	5	0
7145	107	4539	1	1
7146	107	4540	5	1
7147	107	4541	1	1
7148	107	4542	2	2
7149	107	4543	5	4
7150	107	4544	1	1
7151	107	4545	3	2
7152	107	4546	4	2
7153	107	4548	3	1
7154	107	4551	4	4
7155	107	4552	4	3
7156	107	4553	3	0
7157	107	4554	3	1
7158	107	4556	4	2
7159	107	4557	4	4
7160	107	4558	2	1
7161	107	4559	5	0
7162	107	4561	3	1
7163	107	4563	2	0
7164	107	4564	2	0
7165	107	4565	4	0
7166	107	4566	1	1
7167	107	4567	2	2
7168	107	4568	5	5
7169	107	4570	1	1
7170	107	4571	4	2
7171	107	4572	5	5
7172	107	4573	3	3
7173	107	4574	5	5
7174	107	4575	3	3
7175	107	4578	4	0
7176	107	4579	2	2
7177	107	4580	2	1
7178	107	4582	1	0
7179	107	4583	3	0
7180	107	4584	1	0
7181	107	4585	1	1
7182	107	4586	5	3
7183	107	4587	1	0
7184	107	4588	4	2
7185	107	4589	4	3
7186	107	4590	3	3
7187	107	4592	4	1
7188	107	4593	3	3
7189	107	4594	3	1
7190	107	4595	3	3
7191	107	4596	5	1
7192	107	4597	2	2
7193	107	4598	1	1
7194	107	4599	1	0
7195	107	4600	3	2
7196	107	4601	3	2
7197	108	4494	2	0
7198	108	4495	1	0
7199	108	4497	3	0
7200	108	4498	2	0
7201	108	4499	3	2
7202	108	4501	5	1
7203	108	4502	4	0
7204	108	4503	1	0
7205	108	4504	1	0
7206	108	4506	5	3
7207	108	4507	2	2
7208	108	4508	5	4
7209	108	4509	1	1
7210	108	4510	1	1
7211	108	4511	3	0
7212	108	4512	3	2
7213	108	4515	1	0
7214	108	4516	4	2
7215	108	4517	5	5
7216	108	4518	1	0
7217	108	4519	2	0
7218	108	4520	1	0
7219	108	4521	5	5
7220	108	4522	1	0
7221	108	4523	1	1
7222	108	4524	5	0
7223	108	4525	1	1
7224	108	4526	1	1
7225	108	4528	2	0
7226	108	4529	4	1
7227	108	4530	2	1
7228	108	4531	1	0
7229	108	4532	1	0
7230	108	4533	5	1
7231	108	4534	4	0
7232	108	4535	2	1
7233	108	4536	1	0
7234	108	4537	4	3
7235	108	4538	4	1
7236	108	4539	5	3
7237	108	4540	3	2
7238	108	4542	1	1
7239	108	4543	3	1
7240	108	4544	4	0
7241	108	4545	2	0
7242	108	4547	3	3
7243	108	4548	5	3
7244	108	4550	2	1
7245	108	4551	2	0
7246	108	4552	1	0
7247	108	4553	3	3
7248	108	4554	1	0
7249	108	4557	4	2
7250	109	4602	2	2
7251	109	4603	2	2
7252	109	4604	3	0
7253	109	4606	4	3
7254	109	4607	5	0
7255	109	4610	2	1
7256	109	4611	1	0
7257	109	4612	1	1
7258	109	4613	1	0
7259	109	4614	2	0
7260	109	4615	4	2
7261	109	4616	1	0
7262	109	4617	4	3
7263	109	4621	4	4
7264	109	4622	5	5
7265	109	4623	1	0
7266	109	4624	3	0
7267	109	4625	4	3
7268	109	4626	5	0
7269	109	4627	2	1
7270	109	4628	1	1
7271	109	4629	2	2
7272	109	4630	3	3
7273	109	4631	2	0
7274	109	4633	3	2
7275	109	4634	5	2
7276	109	4635	3	1
7277	109	4637	3	1
7278	109	4638	4	1
7279	109	4639	4	2
7280	109	4640	3	3
7281	109	4641	1	0
7282	109	4642	2	1
7283	109	4643	4	4
7284	109	4644	1	0
7285	109	4646	4	3
7286	109	4648	4	2
7287	109	4649	2	1
7288	109	4650	3	2
7289	109	4651	2	0
7290	109	4653	1	0
7291	109	4654	1	1
7292	109	4655	3	1
7293	109	4656	2	1
7294	109	4657	3	0
7295	109	4658	2	2
7296	109	4660	5	1
7297	109	4661	2	0
7298	109	4662	1	0
7299	109	4663	5	2
7300	109	4664	5	2
7301	109	4665	1	0
7302	109	4666	2	1
7303	109	4667	4	0
7304	109	4668	2	1
7305	109	4670	1	1
7306	109	4671	3	0
7307	109	4672	2	1
7308	109	4673	4	2
7309	109	4674	1	1
7310	109	4675	4	4
7311	109	4677	4	1
7312	109	4678	3	0
7313	109	4679	3	3
7314	109	4680	4	3
7315	109	4681	4	1
7316	109	4682	5	5
7317	109	4683	4	4
7318	109	4684	4	1
7319	109	4685	1	1
7320	109	4686	5	3
7321	109	4687	5	0
7322	109	4689	4	1
7323	109	4691	5	5
7324	109	4692	5	5
7325	109	4693	1	1
7326	109	4694	3	3
7327	109	4695	3	0
7328	109	4696	1	1
7329	109	4697	5	0
7330	109	4698	2	1
7331	109	4699	3	1
7332	109	4700	2	1
7333	109	4701	3	1
7334	109	4702	5	0
7335	109	4703	2	0
7336	109	4705	3	1
7337	109	4706	1	1
7338	110	4602	2	0
7339	110	4603	1	0
7340	110	4604	2	2
7341	110	4605	3	2
7342	110	4606	3	3
7343	110	4607	3	0
7344	110	4610	2	2
7345	110	4612	2	0
7346	110	4613	4	4
7347	110	4614	4	2
7348	110	4616	5	5
7349	110	4617	4	4
7350	110	4618	1	0
7351	110	4620	4	2
7352	110	4622	4	4
7353	110	4624	5	4
7354	110	4625	5	2
7355	110	4626	2	1
7356	110	4627	1	0
7357	110	4628	1	1
7358	110	4629	3	2
7359	110	4630	1	1
7360	110	4631	3	3
7361	110	4632	1	1
7362	110	4633	4	2
7363	110	4635	4	2
7364	110	4637	1	1
7365	110	4638	2	2
7366	110	4639	4	2
7367	110	4640	3	1
7368	110	4641	2	1
7369	110	4642	5	3
7370	110	4644	3	1
7371	110	4645	5	3
7372	110	4646	2	0
7373	110	4647	5	1
7374	110	4648	3	1
7375	110	4649	2	1
7376	110	4650	2	2
7377	110	4651	1	1
7378	110	4653	4	1
7379	110	4654	4	4
7380	110	4655	1	0
7381	110	4656	2	1
7382	110	4657	2	1
7383	110	4659	4	1
7384	110	4660	5	5
7385	110	4661	3	1
7386	110	4663	1	0
7387	110	4664	4	4
7388	110	4666	1	1
7389	110	4667	1	0
7390	110	4668	3	1
7391	110	4669	3	2
7392	110	4670	5	2
7393	110	4671	4	1
7394	110	4672	2	0
7395	110	4673	4	0
7396	110	4674	4	2
7397	110	4675	5	2
7398	110	4676	2	1
7399	110	4677	4	3
7400	110	4678	1	1
7401	110	4680	1	1
7402	110	4681	2	0
7403	110	4682	5	0
7404	110	4683	4	3
7405	110	4685	5	1
7406	110	4686	3	1
7407	110	4687	2	2
7408	110	4688	1	0
7409	110	4689	1	0
7410	110	4690	4	0
7411	110	4691	1	0
7412	110	4692	1	0
7413	110	4693	1	1
7414	110	4694	2	2
7415	110	4695	1	1
7416	110	4698	1	0
7417	110	4699	2	2
7418	110	4701	1	1
7419	110	4703	4	0
7420	110	4704	5	0
7421	110	4705	2	2
7422	110	4706	1	1
7423	111	4603	2	2
7424	111	4604	5	5
7425	111	4605	5	0
7426	111	4606	3	3
7427	111	4608	2	1
7428	111	4609	2	0
7429	111	4610	1	0
7430	111	4611	1	1
7431	111	4612	2	2
7432	111	4613	1	1
7433	111	4614	1	1
7434	111	4615	1	1
7435	111	4616	5	1
7436	111	4617	1	0
7437	111	4618	3	2
7438	111	4619	1	0
7439	111	4620	2	0
7440	111	4621	5	1
7441	111	4622	1	0
7442	111	4623	3	0
7443	111	4624	2	1
7444	111	4625	3	0
7445	111	4626	2	2
7446	111	4627	1	1
7447	111	4628	3	2
7448	111	4629	2	2
7449	111	4630	5	5
7450	111	4631	3	1
7451	111	4632	3	2
7452	111	4633	3	3
7453	111	4634	1	0
7454	111	4635	4	4
7455	111	4636	3	0
7456	111	4637	5	5
7457	111	4638	5	1
7458	111	4639	3	2
7459	111	4640	1	0
7460	111	4641	3	1
7461	111	4642	1	1
7462	111	4643	3	2
7463	111	4645	1	0
7464	111	4646	4	4
7465	111	4647	2	1
7466	111	4648	1	1
7467	111	4649	1	1
7468	111	4650	4	0
7469	111	4651	1	1
7470	111	4652	4	0
7471	111	4653	3	2
7472	111	4654	2	2
7473	111	4655	3	2
7474	111	4656	4	1
7475	111	4657	3	3
7476	111	4658	4	0
7477	111	4659	5	1
7478	111	4660	3	3
7479	111	4661	5	2
7480	111	4662	3	1
7481	111	4663	5	2
7482	111	4664	4	3
7483	111	4666	2	2
7484	111	4667	2	0
7485	111	4668	4	4
7486	111	4669	3	0
7487	111	4670	5	0
7488	111	4672	5	5
7489	111	4674	1	1
7490	111	4676	3	3
7491	111	4678	3	1
7492	111	4679	5	5
7493	111	4681	2	2
7494	111	4682	4	2
7495	111	4683	3	3
7496	111	4685	5	1
7497	111	4686	5	0
7498	111	4687	1	1
7499	111	4688	3	2
7500	111	4689	3	0
7501	111	4691	3	2
7502	111	4693	4	3
7503	111	4694	2	1
7504	111	4695	4	4
7505	111	4698	1	1
7506	111	4700	1	0
7507	111	4701	2	1
7508	111	4702	2	2
7509	111	4704	5	5
7510	111	4705	5	0
7511	112	4707	2	1
7512	112	4708	4	4
7513	112	4709	5	0
7514	112	4710	2	1
7515	112	4711	2	2
7516	112	4712	5	0
7517	112	4713	2	1
7518	112	4715	3	0
7519	112	4717	5	0
7520	112	4718	2	2
7521	112	4719	1	1
7522	112	4720	1	0
7523	112	4721	2	2
7524	112	4722	3	1
7525	112	4723	2	0
7526	112	4724	2	2
7527	112	4725	2	1
7528	112	4727	1	0
7529	112	4728	3	1
7530	112	4729	4	0
7531	112	4732	4	0
7532	112	4733	3	0
7533	112	4734	5	1
7534	112	4735	2	2
7535	112	4737	3	3
7536	112	4738	3	1
7537	112	4739	4	3
7538	112	4741	1	0
7539	112	4742	1	0
7540	112	4743	3	3
7541	112	4744	2	2
7542	112	4745	1	0
7543	112	4746	4	0
7544	112	4748	3	1
7545	112	4749	2	2
7546	112	4750	4	2
7547	112	4751	3	0
7548	112	4753	2	0
7549	112	4754	5	4
7550	112	4756	4	1
7551	112	4757	1	1
7552	112	4758	5	4
7553	112	4759	1	0
7554	112	4760	4	1
7555	112	4761	2	1
7556	112	4762	4	0
7557	112	4763	3	0
7558	112	4764	3	2
7559	112	4765	1	1
7560	112	4766	1	0
7561	113	4707	2	1
7562	113	4708	4	2
7563	113	4709	1	1
7564	113	4710	1	1
7565	113	4711	1	0
7566	113	4712	1	1
7567	113	4713	3	0
7568	113	4714	2	0
7569	113	4715	4	0
7570	113	4716	5	3
7571	113	4717	1	0
7572	113	4719	2	1
7573	113	4720	1	0
7574	113	4722	3	2
7575	113	4723	5	2
7576	113	4724	1	0
7577	113	4725	3	1
7578	113	4726	5	0
7579	113	4727	2	2
7580	113	4728	2	2
7581	113	4729	2	0
7582	113	4730	4	2
7583	113	4731	1	1
7584	113	4732	5	1
7585	113	4733	2	1
7586	113	4734	2	1
7587	113	4735	1	1
7588	113	4736	5	2
7589	113	4737	2	1
7590	113	4738	1	0
7591	113	4739	4	1
7592	113	4740	1	0
7593	113	4741	5	1
7594	113	4743	2	0
7595	113	4747	2	0
7596	113	4748	2	1
7597	113	4749	1	0
7598	113	4750	2	1
7599	113	4751	1	1
7600	113	4754	5	4
7601	113	4755	5	0
7602	113	4756	3	1
7603	113	4757	3	0
7604	113	4758	5	3
7605	113	4760	3	1
7606	113	4761	3	2
7607	113	4762	5	3
7608	113	4763	4	4
7609	113	4764	2	0
7610	113	4765	4	4
7611	113	4766	4	3
7612	113	4767	2	2
7613	113	4768	2	0
7614	113	4769	2	1
7615	113	4770	1	1
7616	113	4772	5	3
7617	113	4773	1	0
7618	113	4774	3	0
7619	113	4775	5	4
7620	113	4776	4	3
7621	113	4777	3	3
7622	113	4778	5	1
7623	113	4779	3	2
7624	113	4781	4	1
7625	113	4782	3	1
7626	113	4784	2	0
7627	113	4785	1	1
7628	113	4787	5	3
7629	113	4788	3	1
7630	113	4789	1	0
7631	113	4792	5	4
7632	113	4793	1	0
7633	113	4794	4	4
7634	113	4795	4	1
7635	113	4796	5	3
7636	113	4797	4	0
7637	113	4798	2	1
7638	113	4799	2	2
7639	113	4800	3	3
7640	113	4801	1	0
7641	113	4802	4	3
7642	113	4803	2	2
7643	113	4804	1	0
7644	113	4805	4	0
7645	113	4806	3	0
7646	114	4808	3	2
7647	114	4809	5	4
7648	114	4810	5	4
7649	114	4811	4	4
7650	114	4812	3	2
7651	114	4813	2	0
7652	114	4814	1	0
7653	114	4815	2	0
7654	114	4816	4	2
7655	114	4818	3	1
7656	114	4819	3	1
7657	114	4820	5	4
7658	114	4821	1	0
7659	114	4822	5	5
7660	114	4823	1	1
7661	114	4824	4	0
7662	114	4825	1	1
7663	114	4826	2	1
7664	114	4827	1	0
7665	114	4828	3	2
7666	114	4829	1	0
7667	114	4830	4	4
7668	114	4831	5	5
7669	114	4832	2	2
7670	114	4833	5	2
7671	114	4834	4	2
7672	114	4835	4	2
7673	114	4836	5	2
7674	114	4837	1	0
7675	114	4838	1	0
7676	114	4840	4	2
7677	114	4841	5	4
7678	114	4844	5	5
7679	114	4845	1	1
7680	114	4846	1	0
7681	114	4847	3	1
7682	114	4848	3	1
7683	114	4849	3	1
7684	114	4850	5	4
7685	114	4852	1	0
7686	114	4853	4	4
7687	114	4854	3	3
7688	114	4855	1	0
7689	114	4856	3	3
7690	114	4857	3	1
7691	114	4858	4	4
7692	114	4859	2	2
7693	114	4861	3	3
7694	114	4862	4	2
7695	114	4863	5	4
7696	114	4864	3	0
7697	114	4865	1	0
7698	114	4867	3	0
7699	114	4868	4	3
7700	114	4869	4	0
7701	114	4870	3	0
7702	114	4871	1	1
7703	114	4872	1	0
7704	114	4873	2	1
7705	114	4874	2	1
7706	114	4875	1	1
7707	114	4876	4	2
7708	114	4877	4	4
7709	114	4878	4	3
7710	114	4879	1	0
7711	115	4807	2	0
7712	115	4808	5	4
7713	115	4809	4	1
7714	115	4810	5	3
7715	115	4811	1	1
7716	115	4812	1	1
7717	115	4813	5	4
7718	115	4814	3	0
7719	115	4815	5	2
7720	115	4816	3	0
7721	115	4817	2	2
7722	115	4819	1	0
7723	115	4820	5	4
7724	115	4821	5	5
7725	115	4822	2	2
7726	115	4823	2	2
7727	115	4824	2	1
7728	115	4825	3	3
7729	115	4826	5	5
7730	115	4827	3	0
7731	115	4828	5	0
7732	115	4829	3	2
7733	115	4830	2	0
7734	115	4831	2	2
7735	115	4832	1	0
7736	115	4834	1	1
7737	115	4835	1	0
7738	115	4837	4	2
7739	115	4838	1	1
7740	115	4839	5	3
7741	115	4841	5	1
7742	115	4843	3	1
7743	115	4844	3	0
7744	116	4925	5	1
7745	116	4926	2	0
7746	116	4927	4	2
7747	116	4928	5	3
7748	116	4929	1	1
7749	116	4930	2	0
7750	116	4931	2	1
7751	116	4932	3	0
7752	116	4933	1	1
7753	116	4935	3	1
7754	116	4936	3	3
7755	116	4937	2	1
7756	116	4938	5	2
7757	116	4939	2	0
7758	116	4940	5	3
7759	116	4941	3	1
7760	116	4942	2	1
7761	116	4943	3	2
7762	116	4944	3	2
7763	116	4945	5	0
7764	116	4946	5	2
7765	116	4947	4	3
7766	116	4948	1	0
7767	116	4949	3	2
7768	116	4950	4	3
7769	116	4951	2	1
7770	116	4952	1	0
7771	116	4954	1	1
7772	116	4956	2	1
7773	116	4957	2	1
7774	116	4958	3	3
7775	116	4959	4	4
7776	116	4960	5	4
7777	116	4962	4	4
7778	116	4963	1	1
7779	116	4964	5	4
7780	116	4965	3	2
7781	116	4966	2	1
7782	116	4967	1	0
7783	116	4968	1	0
7784	116	4970	1	1
7785	116	4971	3	0
7786	116	4972	5	2
7787	116	4974	4	4
7788	116	4975	2	0
7789	116	4976	3	0
7790	116	4977	4	1
7791	116	4978	1	1
7792	116	4979	2	0
7793	116	4980	2	1
7794	116	4982	3	0
7795	116	4983	2	0
7796	116	4984	3	3
7797	116	4985	4	2
7798	116	4986	3	2
7799	116	4987	5	4
7800	116	4988	2	2
7801	116	4989	5	3
7802	116	4990	4	1
7803	116	4991	3	3
7804	116	4993	3	2
7805	116	4996	3	3
7806	116	4997	2	2
7807	116	4998	2	0
7808	116	4999	5	2
7809	116	5000	3	2
7810	116	5002	1	1
7811	116	5003	1	1
7812	116	5004	3	1
7813	116	5005	2	2
7814	116	5006	1	0
7815	116	5008	1	0
7816	116	5009	3	1
7817	116	5010	2	2
7818	116	5011	2	0
7819	116	5012	3	0
7820	116	5013	3	1
7821	116	5015	3	2
7822	116	5016	3	3
7823	117	4924	2	0
7824	117	4925	1	1
7825	117	4926	1	1
7826	117	4927	3	1
7827	117	4928	3	3
7828	117	4929	5	5
7829	117	4930	5	0
7830	117	4932	4	1
7831	117	4933	5	4
7832	117	4934	2	1
7833	117	4935	5	3
7834	117	4936	4	3
7835	117	4937	3	1
7836	117	4938	1	1
7837	117	4939	3	2
7838	117	4940	1	0
7839	117	4941	4	4
7840	117	4942	2	1
7841	117	4943	5	1
7842	117	4944	3	1
7843	117	4945	5	2
7844	117	4946	3	3
7845	117	4947	4	0
7846	117	4948	4	4
7847	117	4949	3	3
7848	117	4950	4	2
7849	117	4951	1	1
7850	117	4952	2	2
7851	117	4955	3	0
7852	117	4957	1	0
7853	117	4959	5	1
7854	117	4960	3	1
7855	117	4961	4	0
7856	117	4962	3	0
7857	117	4963	3	2
7858	117	4964	1	1
7859	117	4965	3	0
7860	117	4966	5	0
7861	117	4967	3	2
7862	117	4968	4	3
7863	117	4969	1	0
7864	117	4970	1	1
7865	117	4971	3	0
7866	117	4972	2	0
7867	117	4973	1	0
7868	117	4974	3	3
7869	117	4975	3	2
7870	117	4976	4	0
7871	117	4977	1	0
7872	117	4978	5	4
7873	117	4979	2	2
7874	117	4981	5	3
7875	117	4983	4	1
7876	117	4984	3	0
7877	117	4985	2	1
7878	117	4986	1	1
7879	117	4988	2	1
7880	117	4989	2	0
7881	117	4990	5	0
7882	117	4993	1	1
7883	117	4994	1	1
7884	117	4995	5	4
7885	117	4998	5	5
7886	117	5000	4	4
7887	117	5001	4	0
7888	117	5002	2	1
7889	117	5004	3	1
7890	117	5005	3	0
7891	117	5006	5	0
7892	117	5007	1	1
7893	117	5008	3	2
7894	117	5010	3	3
7895	117	5011	1	0
7896	117	5012	5	2
7897	117	5013	2	2
7898	117	5014	1	1
7899	117	5015	1	1
7900	117	5017	2	1
7901	117	5018	4	2
7902	117	5019	5	0
7903	117	5020	1	0
7904	118	4924	3	1
7905	118	4925	2	2
7906	118	4926	4	3
7907	118	4927	4	3
7908	118	4928	1	1
7909	118	4929	3	1
7910	118	4931	1	0
7911	118	4934	2	0
7912	118	4937	3	0
7913	118	4938	3	1
7914	118	4939	4	1
7915	118	4940	4	4
7916	118	4941	4	0
7917	118	4942	3	1
7918	118	4943	3	1
7919	118	4945	3	1
7920	118	4947	3	3
7921	118	4948	3	2
7922	118	4949	3	3
7923	118	4950	5	2
7924	118	4951	1	1
7925	118	4952	2	2
7926	118	4954	3	3
7927	118	4955	2	0
7928	118	4957	4	0
7929	118	4958	1	0
7930	118	4959	2	0
7931	118	4960	1	0
7932	118	4961	5	0
7933	118	4962	5	2
7934	118	4963	2	1
7935	118	4965	2	2
7936	118	4966	2	1
7937	118	4967	2	0
7938	118	4968	1	1
7939	118	4970	4	0
7940	118	4971	3	3
7941	118	4972	1	0
7942	118	4973	4	3
7943	118	4974	1	0
7944	118	4975	2	1
7945	118	4976	2	2
7946	118	4977	4	4
7947	118	4978	4	3
7948	118	4979	3	1
7949	118	4980	5	1
7950	118	4982	2	2
7951	118	4984	3	1
7952	118	4985	3	2
7953	118	4986	1	0
7954	118	4987	1	0
7955	118	4988	4	2
7956	118	4989	1	1
7957	118	4990	2	2
7958	118	4991	5	0
7959	118	4992	3	3
7960	118	4993	2	2
7961	118	4994	5	1
7962	118	4995	2	2
7963	118	4997	2	2
7964	119	5021	2	2
7965	119	5022	3	2
7966	119	5023	1	1
7967	119	5025	2	0
7968	119	5029	5	5
7969	119	5030	3	3
7970	119	5031	5	2
7971	119	5032	2	2
7972	119	5033	3	0
7973	119	5034	3	0
7974	119	5035	5	2
7975	119	5036	4	2
7976	119	5037	1	1
7977	119	5038	3	3
7978	119	5040	5	0
7979	119	5042	1	1
7980	119	5043	3	0
7981	119	5044	3	0
7982	119	5045	2	1
7983	119	5046	4	2
7984	119	5047	3	0
7985	119	5048	3	1
7986	119	5049	5	4
7987	119	5051	3	2
7988	119	5052	5	1
7989	119	5053	1	0
7990	119	5054	4	0
7991	119	5055	2	1
7992	119	5056	1	1
7993	119	5057	1	0
7994	119	5058	5	3
7995	119	5059	1	1
7996	119	5062	3	1
7997	119	5063	2	1
7998	119	5064	1	0
7999	119	5066	5	0
8000	119	5067	2	2
8001	119	5068	3	3
8002	119	5069	3	2
8003	119	5070	5	0
8004	119	5071	2	2
8005	119	5072	2	2
8006	119	5073	5	3
8007	119	5074	3	3
8008	119	5075	4	1
8009	119	5076	2	2
8010	119	5077	2	2
8011	119	5078	5	5
8012	119	5079	1	0
8013	119	5080	5	3
8014	119	5082	3	0
8015	119	5084	2	2
8016	119	5085	3	2
8017	119	5086	4	4
8018	119	5087	5	5
8019	119	5088	4	1
8020	119	5089	3	2
8021	119	5090	2	2
8022	119	5092	3	2
8023	119	5093	4	1
8024	119	5094	3	1
8025	119	5095	3	0
8026	119	5096	2	2
8027	119	5097	1	1
8028	119	5098	1	1
8029	119	5100	2	0
8030	120	5021	2	2
8031	120	5022	5	4
8032	120	5023	5	0
8033	120	5024	1	1
8034	120	5025	2	0
8035	120	5026	1	1
8036	120	5027	3	1
8037	120	5028	2	1
8038	120	5031	5	4
8039	120	5032	5	3
8040	120	5033	5	2
8041	120	5034	2	2
8042	120	5035	2	1
8043	120	5036	2	2
8044	120	5037	4	2
8045	120	5038	2	2
8046	120	5040	3	1
8047	120	5041	4	4
8048	120	5042	4	2
8049	120	5043	4	3
8050	120	5044	3	3
8051	120	5045	1	1
8052	120	5046	3	1
8053	120	5047	1	0
8054	120	5048	1	0
8055	120	5049	5	1
8056	120	5050	4	0
8057	120	5051	4	2
8058	120	5052	3	1
8059	120	5053	4	3
8060	120	5054	1	0
8061	120	5055	3	3
8062	120	5056	1	1
8063	120	5057	5	2
8064	120	5059	4	2
8065	120	5061	3	2
8066	120	5062	1	0
8067	120	5063	4	2
8068	120	5064	3	0
8069	120	5065	1	1
8070	120	5066	4	4
8071	120	5067	5	0
8072	120	5068	4	4
8073	120	5069	5	0
8074	120	5070	5	4
8075	120	5071	1	0
8076	120	5072	4	1
8077	120	5073	2	2
8078	120	5075	1	1
8079	120	5076	2	0
8080	120	5077	4	4
8081	120	5078	2	1
8082	120	5080	1	0
8083	120	5083	1	0
8084	121	5021	4	4
8085	121	5022	3	2
8086	121	5024	3	0
8087	121	5025	2	1
8088	121	5026	3	1
8089	121	5027	3	2
8090	121	5028	2	0
8091	121	5029	2	2
8092	121	5030	1	1
8093	121	5031	3	0
8094	121	5032	3	2
8095	121	5033	1	0
8096	121	5034	5	5
8097	121	5035	1	1
8098	121	5036	1	0
8099	121	5037	4	1
8100	121	5038	4	0
8101	121	5040	3	2
8102	121	5041	4	3
8103	121	5042	4	3
8104	121	5044	5	3
8105	121	5045	5	2
8106	121	5046	2	2
8107	121	5047	5	3
8108	121	5048	5	1
8109	121	5049	1	0
8110	121	5050	2	2
8111	121	5051	5	0
8112	121	5052	4	0
8113	121	5054	3	1
8114	121	5055	2	0
8115	121	5056	1	0
8116	121	5057	3	2
8117	121	5059	4	2
8118	121	5060	2	0
8119	121	5063	2	1
8120	121	5064	1	1
8121	122	5119	3	2
8122	122	5121	3	3
8123	122	5122	2	1
8124	122	5123	5	5
8125	122	5124	3	2
8126	122	5125	4	4
8127	122	5126	5	1
8128	122	5127	1	1
8129	122	5128	3	2
8130	122	5129	3	2
8131	122	5130	5	2
8132	122	5131	3	0
8133	122	5132	5	5
8134	122	5133	2	0
8135	122	5134	2	2
8136	122	5135	2	2
8137	122	5136	5	1
8138	122	5137	1	1
8139	122	5138	2	0
8140	122	5139	4	4
8141	122	5140	2	0
8142	122	5141	5	5
8143	122	5142	4	0
8144	122	5144	3	0
8145	122	5145	2	0
8146	122	5146	4	4
8147	122	5147	5	3
8148	122	5148	4	2
8149	122	5149	4	3
8150	122	5150	5	1
8151	122	5151	2	0
8152	122	5153	5	1
8153	122	5154	4	4
8154	122	5155	1	1
8155	122	5156	1	0
8156	122	5158	2	1
8157	122	5159	2	1
8158	122	5161	5	0
8159	122	5162	3	3
8160	122	5163	4	0
8161	122	5164	2	1
8162	122	5165	3	3
8163	122	5166	4	4
8164	122	5167	3	3
8165	122	5168	3	2
8166	122	5169	5	2
8167	122	5170	3	1
8168	122	5173	2	2
8169	122	5174	4	1
8170	122	5175	5	2
8171	122	5176	2	0
8172	122	5177	3	3
8173	122	5178	5	1
8174	122	5179	5	5
8175	122	5180	2	0
8176	122	5181	1	1
8177	122	5183	1	0
8178	122	5184	3	3
8179	122	5185	2	0
8180	122	5186	1	1
8181	122	5187	3	0
8182	122	5188	5	5
8183	122	5189	3	0
8184	122	5190	4	3
8185	122	5191	1	1
8186	122	5193	1	1
8187	122	5194	2	0
8188	122	5195	3	3
8189	122	5196	4	2
8190	122	5197	2	2
8191	122	5199	4	0
8192	122	5200	3	1
8193	123	5119	4	4
8194	123	5120	4	0
8195	123	5121	5	5
8196	123	5124	5	0
8197	123	5125	2	1
8198	123	5128	1	0
8199	123	5129	3	2
8200	123	5130	4	1
8201	123	5131	4	4
8202	123	5133	2	1
8203	123	5134	2	2
8204	123	5135	2	0
8205	123	5136	3	2
8206	123	5138	2	1
8207	123	5139	4	2
8208	123	5140	1	0
8209	123	5142	2	0
8210	123	5143	2	2
8211	123	5144	3	0
8212	123	5145	3	3
8213	123	5147	4	0
8214	123	5148	2	2
8215	123	5149	2	1
8216	123	5150	3	3
8217	123	5151	4	4
8218	123	5155	2	1
8219	123	5156	3	2
8220	123	5157	5	0
8221	123	5158	2	0
8222	123	5159	5	3
8223	123	5161	4	3
8224	123	5162	4	1
8225	123	5163	1	0
8226	123	5164	5	4
8227	123	5165	2	0
8228	123	5167	1	1
8229	123	5168	5	4
8230	123	5169	1	0
8231	123	5170	1	0
8232	123	5172	4	3
8233	123	5173	2	1
8234	123	5174	1	0
8235	123	5175	3	0
8236	124	5237	3	1
8237	124	5238	2	0
8238	124	5239	4	1
8239	124	5240	4	0
8240	124	5241	5	4
8241	124	5242	3	1
8242	124	5243	2	0
8243	124	5244	3	3
8244	124	5245	4	3
8245	124	5246	4	0
8246	124	5247	3	2
8247	124	5249	5	2
8248	124	5250	5	4
8249	124	5251	3	3
8250	124	5252	4	2
8251	124	5253	5	1
8252	124	5254	2	0
8253	124	5255	2	2
8254	124	5256	5	5
8255	124	5257	4	2
8256	124	5258	1	1
8257	124	5259	2	0
8258	124	5261	3	1
8259	124	5262	3	0
8260	124	5263	1	0
8261	124	5265	2	0
8262	124	5266	3	3
8263	124	5267	2	1
8264	124	5268	1	1
8265	124	5269	2	2
8266	124	5271	2	1
8267	124	5274	2	1
8268	124	5275	1	1
8269	124	5276	1	0
8270	124	5277	5	0
8271	124	5278	1	1
8272	124	5279	1	0
8273	125	5237	5	3
8274	125	5238	1	1
8275	125	5239	5	3
8276	125	5240	4	1
8277	125	5241	2	1
8278	125	5242	5	4
8279	125	5243	4	4
8280	125	5244	5	0
8281	125	5245	4	4
8282	125	5247	1	0
8283	125	5248	1	1
8284	125	5249	3	1
8285	125	5250	4	2
8286	125	5251	4	2
8287	125	5252	1	1
8288	125	5253	2	0
8289	125	5254	2	0
8290	125	5255	5	1
8291	125	5256	1	1
8292	125	5257	1	0
8293	125	5258	4	3
8294	125	5259	3	2
8295	125	5260	5	1
8296	125	5261	2	0
8297	125	5262	2	2
8298	125	5264	3	1
8299	125	5266	5	2
8300	125	5267	2	2
8301	125	5269	3	2
8302	125	5270	4	0
8303	125	5272	5	2
8304	125	5273	2	1
8305	125	5275	2	2
8306	125	5276	3	0
8307	125	5277	2	0
8308	125	5279	4	0
8309	125	5281	1	0
8310	125	5282	1	0
8311	125	5283	5	1
8312	125	5286	5	2
8313	125	5287	4	2
8314	125	5288	3	1
8315	125	5289	3	2
8316	125	5290	2	0
8317	125	5291	3	2
8318	125	5292	3	1
8319	126	5342	5	4
8320	126	5343	5	1
8321	126	5345	2	2
8322	126	5346	4	1
8323	126	5347	4	0
8324	126	5349	2	1
8325	126	5350	1	1
8326	126	5351	5	1
8327	126	5352	3	0
8328	126	5353	4	0
8329	126	5354	1	1
8330	126	5355	4	3
8331	126	5356	3	3
8332	126	5358	2	1
8333	126	5360	4	1
8334	126	5361	2	0
8335	126	5362	4	0
8336	126	5363	3	0
8337	126	5364	3	3
8338	126	5366	3	0
8339	126	5367	4	3
8340	126	5369	3	0
8341	126	5370	2	0
8342	126	5371	5	5
8343	126	5372	1	1
8344	126	5373	3	1
8345	126	5374	2	1
8346	126	5375	5	1
8347	126	5376	3	2
8348	126	5377	2	0
8349	126	5379	1	1
8350	126	5380	3	2
8351	126	5381	3	0
8352	126	5382	3	1
8353	126	5383	1	0
8354	126	5385	4	2
8355	126	5386	2	0
8356	127	5342	4	4
8357	127	5343	3	2
8358	127	5345	5	3
8359	127	5346	5	2
8360	127	5347	2	0
8361	127	5348	5	0
8362	127	5349	2	2
8363	127	5350	4	1
8364	127	5351	3	3
8365	127	5353	5	2
8366	127	5354	1	1
8367	127	5355	4	2
8368	127	5356	2	1
8369	127	5357	3	1
8370	127	5359	5	3
8371	127	5360	1	0
8372	127	5361	1	1
8373	127	5362	5	1
8374	127	5363	4	4
8375	127	5365	1	1
8376	127	5367	1	1
8377	127	5368	5	5
8378	127	5369	1	1
8379	127	5371	2	0
8380	127	5372	2	0
8381	127	5373	1	1
8382	127	5374	4	0
8383	127	5375	3	2
8384	127	5376	3	3
8385	127	5377	3	1
8386	127	5378	1	1
8387	127	5379	4	2
8388	127	5380	4	1
8389	127	5382	2	1
8390	127	5383	3	1
8391	127	5384	4	0
8392	127	5385	2	0
8393	127	5386	1	0
8394	127	5387	3	3
8395	127	5388	4	4
8396	127	5389	5	5
8397	127	5390	5	5
8398	127	5392	1	0
8399	127	5393	4	2
8400	127	5394	1	0
8401	127	5395	3	2
8402	127	5397	2	0
8403	127	5398	2	0
8404	127	5399	1	1
8405	127	5400	1	0
8406	127	5401	3	0
8407	127	5402	1	0
8408	127	5403	2	2
8409	127	5404	2	0
8410	127	5405	5	4
8411	127	5406	5	2
8412	127	5407	1	0
8413	127	5408	4	2
8414	127	5409	5	4
8415	127	5410	5	1
8416	127	5412	4	1
8417	127	5413	3	2
8418	127	5414	5	3
8419	127	5415	5	0
8420	127	5416	5	2
8421	127	5418	1	0
8422	127	5420	2	1
8423	127	5421	5	4
8424	127	5423	4	2
8425	127	5424	4	4
8426	128	5343	3	3
8427	128	5344	3	0
8428	128	5345	2	0
8429	128	5346	5	5
8430	128	5347	1	0
8431	128	5348	5	0
8432	128	5350	4	1
8433	128	5351	2	1
8434	128	5352	4	1
8435	128	5353	2	1
8436	128	5354	1	0
8437	128	5355	4	3
8438	128	5358	4	2
8439	128	5359	4	4
8440	128	5362	2	1
8441	128	5363	1	0
8442	128	5364	1	0
8443	128	5365	4	1
8444	128	5366	5	2
8445	128	5367	3	1
8446	128	5368	2	1
8447	128	5369	5	5
8448	128	5370	1	0
8449	128	5371	5	1
8450	128	5372	2	2
8451	128	5373	3	1
8452	128	5375	2	0
8453	128	5376	5	4
8454	128	5377	2	0
8455	128	5378	2	0
8456	128	5380	3	0
8457	128	5381	2	2
8458	128	5382	2	0
8459	128	5383	2	1
8460	128	5384	4	4
8461	128	5385	3	2
8462	128	5386	2	0
8463	128	5387	2	1
8464	128	5388	3	2
8465	128	5389	3	2
8466	128	5391	3	1
8467	128	5392	4	1
8468	128	5394	5	4
8469	128	5395	1	1
8470	128	5397	3	3
8471	128	5398	2	0
8472	128	5399	2	1
8473	128	5401	2	2
8474	128	5402	1	1
8475	128	5403	3	3
8476	128	5404	1	1
8477	128	5406	4	2
8478	128	5407	1	0
8479	129	5454	1	0
8480	129	5455	2	0
8481	129	5458	5	0
8482	129	5459	1	1
8483	129	5460	5	1
8484	129	5461	4	1
8485	129	5462	4	3
8486	129	5463	1	1
8487	129	5464	4	2
8488	129	5465	5	1
8489	129	5466	4	1
8490	129	5468	2	0
8491	129	5469	3	0
8492	129	5470	5	2
8493	129	5471	5	3
8494	129	5473	3	2
8495	129	5474	1	0
8496	129	5475	3	1
8497	129	5476	3	1
8498	129	5477	1	1
8499	129	5478	2	1
8500	129	5479	4	1
8501	129	5480	1	0
8502	129	5481	2	2
8503	129	5482	4	3
8504	129	5483	3	0
8505	129	5485	1	1
8506	129	5486	1	1
8507	129	5487	1	0
8508	129	5488	1	1
8509	129	5489	2	2
8510	129	5490	2	2
8511	129	5491	4	2
8512	129	5493	4	2
8513	129	5494	2	1
8514	129	5496	3	1
8515	129	5497	5	2
8516	129	5498	1	1
8517	129	5500	4	4
8518	129	5502	2	0
8519	129	5503	2	2
8520	129	5504	5	5
8521	129	5505	1	1
8522	129	5506	1	1
8523	129	5507	4	0
8524	129	5508	2	0
8525	129	5509	1	0
8526	129	5510	1	1
8527	129	5511	1	1
8528	129	5512	2	0
8529	129	5513	5	5
8530	129	5514	1	1
8531	129	5515	1	1
8532	129	5516	2	1
8533	129	5517	3	2
8534	129	5518	2	0
8535	129	5519	4	4
8536	129	5520	1	1
8537	129	5521	1	1
8538	129	5522	5	5
8539	129	5523	1	0
8540	129	5524	5	5
8541	129	5527	5	5
8542	129	5529	2	0
8543	130	5454	5	1
8544	130	5455	2	2
8545	130	5456	4	2
8546	130	5458	4	2
8547	130	5460	1	0
8548	130	5461	4	3
8549	130	5462	1	1
8550	130	5463	5	2
8551	130	5464	2	1
8552	130	5465	3	0
8553	130	5466	5	5
8554	130	5467	4	1
8555	130	5468	4	2
8556	130	5469	4	4
8557	130	5470	4	4
8558	130	5471	3	1
8559	130	5474	1	1
8560	130	5475	3	2
8561	130	5476	5	0
8562	130	5477	4	0
8563	130	5478	5	2
8564	130	5479	2	1
8565	130	5480	2	2
8566	130	5481	5	0
8567	130	5482	4	4
8568	130	5483	2	2
8569	130	5485	2	1
8570	130	5486	1	0
8571	130	5487	4	0
8572	130	5492	2	1
8573	130	5493	2	0
8574	130	5495	5	3
8575	130	5496	4	1
8576	130	5497	3	1
8577	130	5498	4	4
8578	130	5499	2	1
8579	130	5500	1	0
8580	130	5501	1	0
8581	130	5502	4	1
8582	130	5503	5	1
8583	130	5504	1	0
8584	130	5505	1	1
8585	130	5506	2	0
8586	130	5507	1	0
8587	130	5508	5	5
8588	130	5509	4	2
8589	130	5510	2	0
8590	130	5511	1	1
8591	130	5512	4	2
8592	130	5513	5	1
8593	130	5514	3	2
8594	130	5515	5	5
8595	130	5517	1	0
8596	130	5518	1	1
8597	130	5519	3	3
8598	130	5520	5	4
8599	130	5521	4	4
8600	130	5522	4	4
8601	130	5523	2	0
8602	130	5524	5	4
8603	130	5525	4	1
8604	130	5526	3	3
8605	130	5527	5	5
8606	130	5528	3	1
8607	130	5529	2	1
8608	130	5530	4	4
8609	130	5531	2	2
8610	130	5532	3	0
8611	130	5533	3	2
8612	130	5534	5	1
8613	130	5535	1	0
8614	130	5537	1	0
8615	130	5540	1	0
8616	131	5454	3	0
8617	131	5455	4	4
8618	131	5456	3	3
8619	131	5457	1	1
8620	131	5458	3	0
8621	131	5459	5	3
8622	131	5460	5	0
8623	131	5461	2	0
8624	131	5462	4	1
8625	131	5463	2	0
8626	131	5465	3	0
8627	131	5466	1	0
8628	131	5467	5	1
8629	131	5470	3	2
8630	131	5471	1	1
8631	131	5472	5	2
8632	131	5474	4	3
8633	131	5475	1	0
8634	131	5476	4	4
8635	131	5477	2	1
8636	131	5480	1	1
8637	131	5485	5	1
8638	131	5486	1	1
8639	131	5487	2	2
8640	131	5488	3	2
8641	131	5489	2	1
8642	131	5491	4	4
8643	131	5492	5	2
8644	131	5493	5	1
8645	131	5494	3	1
8646	131	5496	4	4
8647	131	5497	2	0
8648	131	5498	2	0
8649	131	5499	5	4
8650	131	5500	2	2
8651	131	5501	5	5
8652	131	5502	2	0
8653	131	5503	5	0
8654	131	5505	3	0
8655	131	5506	1	0
8656	131	5507	3	1
8657	131	5508	1	0
8658	131	5509	1	0
8659	131	5510	3	2
8660	131	5512	1	0
8661	131	5513	5	5
8662	131	5514	5	0
8663	131	5515	5	3
8664	131	5516	4	3
8665	131	5517	2	1
8666	131	5519	1	1
8667	131	5521	1	0
8668	131	5522	4	4
8669	131	5523	5	4
8670	131	5524	2	1
8671	131	5526	1	1
8672	131	5527	3	3
8673	131	5528	5	2
8674	131	5530	2	0
8675	131	5531	5	5
8676	131	5532	4	1
8677	131	5533	3	1
8678	131	5534	5	5
8679	131	5535	5	5
8680	131	5536	4	1
8681	131	5538	3	2
8682	131	5540	2	1
8683	131	5541	1	1
8684	131	5543	3	3
8685	131	5544	5	5
8686	131	5545	5	5
8687	131	5547	3	3
8688	131	5548	2	1
8689	131	5549	4	0
8690	131	5550	3	3
8691	131	5551	1	1
8692	131	5552	5	1
8693	131	5554	3	0
8694	131	5555	5	4
8695	131	5557	5	0
8696	131	5558	3	2
8697	131	5559	1	0
8698	131	5560	1	0
8699	132	5561	3	1
8700	132	5562	1	1
8701	132	5563	4	1
8702	132	5564	3	3
8703	132	5565	4	0
8704	132	5566	2	0
8705	132	5567	3	2
8706	132	5568	1	1
8707	132	5569	2	0
8708	132	5571	2	2
8709	132	5572	5	0
8710	132	5573	2	0
8711	132	5574	3	0
8712	132	5575	4	3
8713	132	5576	2	0
8714	132	5577	5	0
8715	132	5578	1	1
8716	132	5579	2	0
8717	132	5580	5	2
8718	132	5581	5	2
8719	132	5582	4	1
8720	132	5583	1	0
8721	132	5584	5	3
8722	132	5585	3	1
8723	132	5586	5	5
8724	132	5587	5	1
8725	132	5588	3	2
8726	132	5589	1	0
8727	132	5590	3	0
8728	132	5594	2	2
8729	132	5595	5	3
8730	132	5596	4	0
8731	132	5597	4	0
8732	132	5598	3	2
8733	132	5599	3	1
8734	132	5600	2	1
8735	132	5601	2	0
8736	132	5602	1	0
8737	132	5603	4	1
8738	132	5604	2	0
8739	132	5605	3	2
8740	132	5607	5	3
8741	132	5608	2	2
8742	132	5609	4	3
8743	132	5610	4	4
8744	132	5611	4	0
8745	132	5612	3	3
8746	132	5613	3	3
8747	132	5614	2	0
8748	132	5616	1	0
8749	132	5617	5	5
8750	132	5618	1	1
8751	132	5619	2	0
8752	132	5620	2	0
8753	132	5622	1	1
8754	132	5625	5	2
8755	132	5626	2	1
8756	132	5627	4	3
8757	132	5628	4	0
8758	132	5629	4	3
8759	132	5630	1	1
8760	133	5561	2	1
8761	133	5562	5	4
8762	133	5564	2	1
8763	133	5565	2	1
8764	133	5566	3	1
8765	133	5567	5	4
8766	133	5568	3	0
8767	133	5569	2	1
8768	133	5571	1	1
8769	133	5572	5	0
8770	133	5573	4	2
8771	133	5574	1	0
8772	133	5575	3	0
8773	133	5576	3	2
8774	133	5577	2	2
8775	133	5578	5	4
8776	133	5579	5	0
8777	133	5580	1	0
8778	133	5581	4	4
8779	133	5583	1	1
8780	133	5584	3	2
8781	133	5585	1	0
8782	133	5586	3	3
8783	133	5588	1	0
8784	133	5589	5	4
8785	133	5590	2	0
8786	133	5591	3	3
8787	133	5592	5	4
8788	133	5593	4	2
8789	133	5594	2	2
8790	133	5595	3	0
8791	133	5596	4	3
8792	133	5597	1	1
8793	133	5598	5	3
8794	133	5599	5	5
8795	133	5600	2	0
8796	133	5601	5	2
8797	133	5602	5	3
8798	133	5603	5	3
8799	133	5604	3	3
8800	133	5605	4	1
8801	133	5606	1	1
8802	133	5607	4	0
8803	133	5608	5	0
8804	133	5609	4	3
8805	133	5612	3	2
8806	133	5613	5	2
8807	133	5614	4	1
8808	133	5615	2	0
8809	133	5616	1	1
8810	133	5617	5	3
8811	133	5618	1	1
8812	134	5674	4	3
8813	134	5675	4	4
8814	134	5676	4	3
8815	134	5678	1	0
8816	134	5679	5	1
8817	134	5681	5	4
8818	134	5682	2	0
8819	134	5683	4	1
8820	134	5684	4	4
8821	134	5686	5	5
8822	134	5687	4	1
8823	134	5688	4	4
8824	134	5689	4	1
8825	134	5690	5	2
8826	134	5692	5	0
8827	134	5693	2	1
8828	134	5694	1	0
8829	134	5695	2	0
8830	134	5696	1	0
8831	134	5699	1	1
8832	134	5700	3	2
8833	134	5701	3	3
8834	134	5702	2	1
8835	134	5703	3	2
8836	134	5704	1	1
8837	134	5705	3	2
8838	134	5706	2	0
8839	134	5707	2	2
8840	134	5708	1	1
8841	134	5709	2	2
8842	134	5710	4	3
8843	134	5712	4	1
8844	134	5713	1	1
8845	134	5714	5	4
8846	134	5715	1	1
8847	134	5716	5	0
8848	134	5718	4	4
8849	134	5719	1	1
8850	134	5721	2	1
8851	134	5722	5	2
8852	134	5723	5	0
8853	134	5725	1	0
8854	134	5726	2	1
8855	134	5727	5	4
8856	134	5728	2	0
8857	134	5730	2	2
8858	134	5731	1	0
8859	135	5674	1	1
8860	135	5675	4	4
8861	135	5676	1	0
8862	135	5677	3	3
8863	135	5678	3	0
8864	135	5679	5	0
8865	135	5680	2	1
8866	135	5682	1	1
8867	135	5683	1	0
8868	135	5684	5	3
8869	135	5685	3	0
8870	135	5687	4	0
8871	135	5688	5	3
8872	135	5690	2	0
8873	135	5692	5	3
8874	135	5693	1	0
8875	135	5694	1	0
8876	135	5697	5	0
8877	135	5701	5	1
8878	135	5702	3	2
8879	135	5703	4	0
8880	135	5705	4	3
8881	135	5706	5	3
8882	135	5707	4	3
8883	135	5709	1	1
8884	135	5710	4	0
8885	135	5711	2	2
8886	135	5712	5	4
8887	135	5713	3	3
8888	135	5714	5	5
8889	135	5715	2	1
8890	135	5716	5	5
8891	135	5717	2	0
8892	135	5718	3	1
8893	135	5719	1	0
8894	135	5720	1	1
8895	135	5721	2	0
8896	135	5722	2	0
8897	135	5723	5	5
8898	135	5724	3	1
8899	135	5725	4	2
8900	135	5726	1	0
8901	135	5728	3	0
8902	135	5729	3	1
8903	135	5730	2	0
8904	135	5731	5	3
8905	135	5732	4	1
8906	135	5733	2	2
8907	135	5735	4	0
8908	136	5674	1	1
8909	136	5677	1	0
8910	136	5678	5	0
8911	136	5681	4	3
8912	136	5682	1	0
8913	136	5683	2	0
8914	136	5684	2	1
8915	136	5685	5	5
8916	136	5687	2	0
8917	136	5689	1	0
8918	136	5690	2	2
8919	136	5691	1	0
8920	136	5692	3	3
8921	136	5693	4	1
8922	136	5695	3	0
8923	136	5698	4	2
8924	136	5699	1	1
8925	136	5700	4	0
8926	136	5701	3	3
8927	136	5702	5	0
8928	136	5703	3	3
8929	136	5704	2	0
8930	136	5705	5	4
8931	136	5706	4	4
8932	136	5707	3	3
8933	136	5708	3	2
8934	136	5709	3	0
8935	136	5711	5	4
8936	136	5712	2	2
8937	136	5713	2	1
8938	136	5714	5	5
8939	136	5715	1	1
8940	136	5716	4	1
8941	136	5717	1	1
8942	136	5718	3	2
8943	136	5719	5	3
8944	136	5721	5	5
8945	136	5722	1	0
8946	136	5723	2	1
8947	136	5725	4	3
8948	136	5726	5	1
8949	136	5727	5	5
8950	136	5728	1	1
8951	136	5729	3	1
8952	136	5730	1	1
8953	136	5731	5	2
8954	136	5732	1	1
8955	136	5733	4	1
8956	136	5734	2	1
8957	136	5736	1	1
8958	136	5738	3	0
8959	136	5739	3	1
8960	136	5740	3	2
8961	136	5741	3	1
8962	136	5742	1	1
8963	136	5744	2	0
8964	136	5745	3	3
8965	136	5746	4	1
8966	136	5747	2	1
8967	136	5748	3	3
8968	136	5749	2	0
8969	136	5750	5	4
8970	136	5751	1	0
8971	136	5752	4	3
8972	136	5753	5	3
8973	136	5754	5	4
8974	136	5755	3	2
8975	136	5756	1	0
8976	136	5758	1	1
8977	136	5759	4	1
8978	136	5761	1	0
8979	137	5773	3	1
8980	137	5774	3	3
8981	137	5776	5	0
8982	137	5777	1	1
8983	137	5779	3	0
8984	137	5780	2	1
8985	137	5781	2	0
8986	137	5783	4	3
8987	137	5784	3	1
8988	137	5785	4	3
8989	137	5786	2	2
8990	137	5788	1	0
8991	137	5790	2	2
8992	137	5792	5	5
8993	137	5794	4	1
8994	137	5795	3	2
8995	137	5796	3	2
8996	137	5797	2	1
8997	137	5798	3	1
8998	137	5800	4	4
8999	137	5801	5	0
9000	137	5802	2	1
9001	137	5804	3	0
9002	137	5805	4	2
9003	137	5806	4	3
9004	137	5807	2	1
9005	137	5808	2	1
9006	137	5809	4	1
9007	137	5810	5	1
9008	137	5812	4	1
9009	137	5813	1	0
9010	137	5814	2	1
9011	137	5815	5	5
9012	137	5816	2	0
9013	137	5817	4	3
9014	137	5820	5	1
9015	137	5821	4	2
9016	137	5822	4	1
9017	137	5823	1	0
9018	137	5824	4	2
9019	137	5826	3	0
9020	137	5827	4	2
9021	137	5828	1	0
9022	137	5829	3	0
9023	137	5830	2	0
9024	137	5831	1	0
9025	137	5832	4	0
9026	137	5833	1	0
9027	137	5834	5	5
9028	137	5836	3	0
9029	137	5837	1	1
9030	137	5838	4	0
9031	137	5839	1	1
9032	137	5840	1	1
9033	137	5841	2	2
9034	137	5842	1	0
9035	137	5843	3	0
9036	137	5844	1	1
9037	137	5845	5	3
9038	137	5846	2	1
9039	137	5847	5	4
9040	137	5848	2	0
9041	137	5850	4	4
9042	137	5851	5	4
9043	137	5852	2	1
9044	137	5853	3	1
9045	137	5854	4	1
9046	137	5855	3	3
9047	137	5856	1	1
9048	137	5857	2	2
9049	137	5858	5	5
9050	137	5859	2	1
9051	138	5773	1	1
9052	138	5774	3	0
9053	138	5775	1	0
9054	138	5776	4	3
9055	138	5777	2	2
9056	138	5778	4	1
9057	138	5779	4	2
9058	138	5782	4	4
9059	138	5783	3	0
9060	138	5784	5	2
9061	138	5785	3	3
9062	138	5786	1	1
9063	138	5787	1	0
9064	138	5788	1	1
9065	138	5789	1	0
9066	138	5790	5	5
9067	138	5791	1	1
9068	138	5792	2	1
9069	138	5793	3	0
9070	138	5794	3	0
9071	138	5795	3	2
9072	138	5796	4	4
9073	138	5797	2	0
9074	138	5798	5	5
9075	138	5799	2	2
9076	138	5800	4	1
9077	138	5801	5	5
9078	138	5802	4	4
9079	138	5803	1	1
9080	138	5804	4	0
9081	138	5805	3	0
9082	138	5806	2	2
9083	138	5807	2	2
9084	138	5808	4	4
9085	138	5809	3	2
9086	138	5810	5	2
9087	138	5811	5	5
9088	138	5812	1	1
9089	138	5813	5	1
9090	139	5860	2	0
9091	139	5861	5	5
9092	139	5862	2	0
9093	139	5863	2	0
9094	139	5864	4	2
9095	139	5865	3	2
9096	139	5866	2	0
9097	139	5867	1	0
9098	139	5868	1	1
9099	139	5870	2	1
9100	139	5871	2	1
9101	139	5872	1	0
9102	139	5873	2	1
9103	139	5875	1	1
9104	139	5876	2	2
9105	139	5877	2	0
9106	139	5878	2	0
9107	139	5880	3	0
9108	139	5881	1	1
9109	139	5883	2	2
9110	139	5884	4	4
9111	139	5885	5	3
9112	139	5886	2	0
9113	139	5887	2	0
9114	139	5888	4	0
9115	139	5889	1	0
9116	139	5892	1	0
9117	139	5893	2	1
9118	139	5894	2	2
9119	139	5895	5	3
9120	139	5896	3	1
9121	139	5897	1	0
9122	139	5898	5	4
9123	139	5900	2	1
9124	139	5901	5	5
9125	139	5902	5	0
9126	139	5903	4	3
9127	139	5905	1	1
9128	139	5908	4	1
9129	139	5909	4	3
9130	139	5910	5	4
9131	139	5911	2	2
9132	139	5912	3	3
9133	139	5913	1	1
9134	139	5915	5	2
9135	139	5916	5	1
9136	139	5917	1	1
9137	139	5918	4	3
9138	139	5919	3	3
9139	139	5921	1	1
9140	139	5923	2	2
9141	139	5924	3	2
9142	139	5925	5	5
9143	139	5926	1	1
9144	139	5928	2	1
9145	139	5929	4	2
9146	139	5930	1	1
9147	139	5931	4	3
9148	139	5932	5	2
9149	139	5933	1	0
9150	139	5934	1	0
9151	139	5936	2	0
9152	139	5937	4	4
9153	139	5938	3	0
9154	139	5939	5	4
9155	139	5941	3	3
9156	139	5942	3	1
9157	139	5943	3	1
9158	139	5944	3	0
9159	139	5946	4	2
9160	139	5947	2	1
9161	139	5949	5	2
9162	139	5950	2	2
9163	139	5951	4	4
9164	139	5952	2	1
9165	139	5954	5	0
9166	139	5955	5	0
9167	139	5958	1	0
9168	139	5959	4	4
9169	139	5960	2	0
9170	139	5961	3	2
9171	139	5962	1	1
9172	139	5963	4	2
9173	139	5965	2	0
9174	139	5966	2	2
9175	139	5967	3	1
9176	140	5861	5	3
9177	140	5862	4	0
9178	140	5863	5	2
9179	140	5864	1	1
9180	140	5866	2	0
9181	140	5868	1	0
9182	140	5869	1	0
9183	140	5871	1	1
9184	140	5872	5	2
9185	140	5873	2	0
9186	140	5874	1	1
9187	140	5875	3	2
9188	140	5876	5	2
9189	140	5877	5	4
9190	140	5878	5	4
9191	140	5879	5	0
9192	140	5880	2	0
9193	140	5881	2	1
9194	140	5882	2	2
9195	140	5883	1	1
9196	140	5884	1	1
9197	140	5885	1	1
9198	140	5886	1	0
9199	140	5888	4	2
9200	140	5889	3	2
9201	140	5890	3	1
9202	140	5894	4	3
9203	140	5895	1	0
9204	140	5896	3	0
9205	140	5897	2	2
9206	140	5898	2	0
9207	140	5899	5	2
9208	140	5901	1	0
9209	140	5902	4	0
9210	140	5903	1	1
9211	140	5904	2	2
9212	140	5905	3	1
9213	140	5906	3	3
9214	140	5907	4	1
9215	140	5908	2	2
9216	140	5909	2	0
9217	140	5910	1	0
9218	140	5911	3	1
9219	140	5912	4	0
9220	140	5913	3	2
9221	140	5915	4	3
9222	140	5916	2	0
9223	140	5917	5	2
9224	140	5918	1	0
9225	140	5919	1	1
9226	141	5860	4	1
9227	141	5861	2	0
9228	141	5862	1	0
9229	141	5863	3	2
9230	141	5865	4	4
9231	141	5866	2	1
9232	141	5867	5	5
9233	141	5868	2	2
9234	141	5869	3	2
9235	141	5872	1	0
9236	141	5873	1	0
9237	141	5874	1	1
9238	141	5875	1	1
9239	141	5876	3	1
9240	141	5877	3	3
9241	141	5878	1	0
9242	141	5879	1	0
9243	141	5880	5	0
9244	141	5881	5	4
9245	141	5883	2	2
9246	141	5884	3	2
9247	141	5885	4	3
9248	141	5886	1	0
9249	141	5887	3	0
9250	141	5889	3	0
9251	141	5890	2	2
9252	141	5891	3	2
9253	141	5893	4	1
9254	141	5895	1	1
9255	141	5896	1	1
9256	141	5897	5	5
9257	141	5898	1	0
9258	141	5900	4	0
9259	141	5901	2	1
9260	141	5902	4	3
9261	141	5903	3	2
9262	141	5904	3	2
9263	141	5907	2	2
9264	141	5908	1	1
9265	141	5909	5	1
9266	141	5910	2	2
9267	141	5911	5	0
9268	141	5912	3	2
9269	141	5913	3	3
9270	141	5914	2	1
9271	141	5915	2	1
9272	141	5916	5	1
9273	141	5917	2	2
9274	141	5918	4	0
9275	141	5919	4	3
9276	141	5920	4	3
9277	141	5921	4	4
9278	141	5923	1	1
9279	141	5924	4	0
9280	141	5925	2	1
9281	141	5926	3	3
9282	141	5927	5	4
9283	141	5928	2	2
9284	141	5929	3	0
9285	141	5930	4	3
9286	141	5931	5	5
9287	141	5932	2	2
9288	141	5933	5	2
9289	141	5934	3	3
9290	141	5935	2	0
9291	141	5936	1	0
9292	141	5937	4	4
9293	141	5938	1	0
9294	141	5939	5	4
9295	141	5941	5	0
9296	141	5942	1	0
9297	141	5944	2	1
9298	141	5945	3	2
9299	141	5947	2	2
9300	141	5948	3	3
9301	141	5950	2	2
9302	141	5951	5	1
9303	141	5952	3	3
9304	141	5955	1	0
9305	141	5956	1	0
9306	141	5957	3	0
9307	141	5958	5	4
9308	141	5960	5	3
9309	141	5962	4	0
9310	141	5963	4	2
9311	141	5964	4	4
9312	141	5965	4	3
9313	141	5966	2	2
9314	141	5967	5	1
9315	142	5969	2	0
9316	142	5970	1	0
9317	142	5971	1	0
9318	142	5972	5	1
9319	142	5973	1	0
9320	142	5974	5	0
9321	142	5975	1	0
9322	142	5976	4	1
9323	142	5977	4	0
9324	142	5978	4	1
9325	142	5983	1	0
9326	142	5984	2	2
9327	142	5985	2	2
9328	142	5986	5	4
9329	142	5987	4	2
9330	142	5988	4	4
9331	142	5989	3	2
9332	142	5991	3	0
9333	142	5992	1	1
9334	142	5993	2	1
9335	142	5994	1	0
9336	142	5996	4	3
9337	142	5997	2	2
9338	142	5998	1	0
9339	142	5999	3	0
9340	142	6000	5	3
9341	142	6001	3	1
9342	142	6002	2	1
9343	142	6003	4	4
9344	142	6004	2	0
9345	142	6005	2	2
9346	142	6006	5	0
9347	142	6007	1	0
9348	142	6008	1	0
9349	142	6009	1	1
9350	142	6010	1	0
9351	142	6011	1	1
9352	142	6012	3	2
9353	142	6013	2	2
9354	142	6014	3	1
9355	142	6015	4	0
9356	142	6017	3	0
9357	142	6019	3	0
9358	142	6020	4	4
9359	142	6021	4	4
9360	142	6022	2	1
9361	142	6024	5	0
9362	142	6025	5	5
9363	142	6026	4	3
9364	142	6029	5	4
9365	142	6030	2	1
9366	142	6031	5	1
9367	142	6032	5	3
9368	142	6033	1	0
9369	142	6034	1	1
9370	142	6035	1	1
9371	142	6036	1	1
9372	142	6038	4	4
9373	142	6039	2	2
9374	142	6040	5	3
9375	142	6042	2	0
9376	142	6043	3	1
9377	142	6044	5	3
9378	142	6045	5	4
9379	142	6048	4	3
9380	142	6049	4	1
9381	142	6050	1	0
9382	142	6051	4	3
9383	142	6052	2	0
9384	142	6054	1	1
9385	142	6055	4	2
9386	142	6056	1	1
9387	142	6059	5	4
9388	143	5969	2	2
9389	143	5970	5	2
9390	143	5971	2	1
9391	143	5972	4	1
9392	143	5974	3	0
9393	143	5976	1	1
9394	143	5977	4	3
9395	143	5979	2	0
9396	143	5980	5	2
9397	143	5981	2	2
9398	143	5983	3	1
9399	143	5984	2	1
9400	143	5985	2	0
9401	143	5987	1	1
9402	143	5988	4	2
9403	143	5989	5	4
9404	143	5991	4	3
9405	143	5992	5	2
9406	143	5994	2	1
9407	143	5995	3	3
9408	143	5996	1	0
9409	143	5997	5	4
9410	143	5999	2	2
9411	143	6000	5	1
9412	143	6001	2	1
9413	143	6002	4	1
9414	143	6003	3	3
9415	143	6004	5	4
9416	143	6005	2	1
9417	143	6006	4	2
9418	143	6007	2	0
9419	143	6008	5	4
9420	143	6009	5	3
9421	143	6012	2	0
9422	143	6013	5	3
9423	143	6014	3	0
9424	143	6017	2	0
9425	143	6018	1	0
9426	143	6019	3	3
9427	143	6020	5	3
9428	143	6021	1	0
9429	143	6022	3	2
9430	143	6023	3	0
9431	143	6024	3	2
9432	143	6026	5	3
9433	143	6027	2	1
9434	143	6028	1	1
9435	143	6029	5	3
9436	143	6030	3	1
9437	143	6031	1	1
9438	143	6032	3	2
9439	143	6033	4	4
9440	143	6034	3	1
9441	143	6036	4	4
9442	143	6037	4	3
9443	143	6041	1	0
9444	143	6042	4	0
9445	143	6043	5	3
9446	143	6044	1	1
9447	143	6045	1	1
9448	143	6046	1	1
9449	143	6047	2	1
9450	143	6048	4	4
9451	143	6049	1	1
9452	143	6050	4	1
9453	143	6051	3	3
9454	143	6053	3	1
9455	143	6055	4	4
9456	143	6056	3	3
9457	143	6057	1	0
9458	143	6058	2	1
9459	143	6059	5	2
9460	143	6061	4	1
9461	143	6062	4	3
9462	144	6065	5	4
9463	144	6067	2	1
9464	144	6069	3	1
9465	144	6070	3	3
9466	144	6072	4	3
9467	144	6073	3	1
9468	144	6074	5	5
9469	144	6075	4	2
9470	144	6076	1	1
9471	144	6077	1	0
9472	144	6078	4	1
9473	144	6079	3	2
9474	144	6081	2	0
9475	144	6082	3	0
9476	144	6083	4	0
9477	144	6084	4	0
9478	144	6085	1	1
9479	144	6086	1	1
9480	144	6087	4	1
9481	144	6088	2	0
9482	144	6089	2	2
9483	144	6091	5	5
9484	144	6092	2	2
9485	144	6093	3	1
9486	144	6094	5	3
9487	144	6095	4	3
9488	144	6096	3	3
9489	144	6097	5	3
9490	144	6098	2	2
9491	144	6099	4	4
9492	144	6100	2	0
9493	144	6101	4	1
9494	144	6102	1	1
9495	144	6104	2	1
9496	144	6105	3	0
9497	144	6106	1	1
9498	144	6107	5	0
9499	144	6108	5	4
9500	144	6109	3	1
9501	144	6110	2	2
9502	144	6111	3	0
9503	144	6112	1	0
9504	144	6113	5	2
9505	144	6114	4	0
9506	144	6116	2	0
9507	144	6118	1	1
9508	144	6119	4	3
9509	144	6120	4	4
9510	144	6121	2	1
9511	144	6122	5	0
9512	144	6123	5	0
9513	144	6124	4	4
9514	144	6126	2	2
9515	144	6128	5	1
9516	144	6129	1	0
9517	144	6130	1	0
9518	144	6131	1	0
9519	144	6132	5	5
9520	144	6133	2	2
9521	144	6134	2	1
9522	144	6135	5	3
9523	144	6136	4	4
9524	144	6137	2	1
9525	144	6138	2	1
9526	144	6139	3	0
9527	144	6140	1	0
9528	144	6143	1	1
9529	144	6144	4	0
9530	144	6145	2	0
9531	144	6146	1	0
9532	144	6147	1	1
9533	144	6149	2	0
9534	144	6150	5	0
9535	144	6151	4	1
9536	144	6152	1	1
9537	144	6153	3	3
9538	144	6154	3	1
9539	145	6064	5	1
9540	145	6065	1	0
9541	145	6066	2	2
9542	145	6067	3	2
9543	145	6069	4	1
9544	145	6070	4	2
9545	145	6071	2	1
9546	145	6072	3	0
9547	145	6073	5	3
9548	145	6074	1	1
9549	145	6075	3	1
9550	145	6076	3	1
9551	145	6077	5	3
9552	145	6078	4	4
9553	145	6079	4	1
9554	145	6080	2	0
9555	145	6081	2	2
9556	145	6082	3	1
9557	145	6083	4	2
9558	145	6084	2	1
9559	145	6085	4	4
9560	145	6086	5	5
9561	145	6087	3	3
9562	145	6088	3	0
9563	145	6090	2	2
9564	145	6091	5	0
9565	145	6092	2	0
9566	145	6093	5	0
9567	145	6094	3	1
9568	145	6096	5	4
9569	145	6097	5	0
9570	145	6098	2	1
9571	145	6099	3	1
9572	145	6100	3	0
9573	145	6102	5	3
9574	145	6103	1	0
9575	145	6104	1	0
9576	145	6106	4	4
9577	145	6107	4	0
9578	145	6109	2	2
9579	145	6110	4	2
9580	145	6111	5	1
9581	145	6112	2	1
9582	145	6114	5	2
9583	145	6115	3	2
9584	145	6116	3	2
9585	145	6117	4	2
9586	145	6118	2	2
9587	145	6119	5	3
9588	145	6120	5	3
9589	145	6121	4	3
9590	145	6123	1	1
9591	145	6124	1	1
9592	145	6125	5	0
9593	145	6126	1	1
9594	146	6178	5	3
9595	146	6179	3	0
9596	146	6181	4	2
9597	146	6182	4	0
9598	146	6184	5	5
9599	146	6185	3	2
9600	146	6186	5	5
9601	146	6187	2	0
9602	146	6188	5	4
9603	146	6189	4	2
9604	146	6191	1	1
9605	146	6192	1	1
9606	146	6193	4	3
9607	146	6194	1	1
9608	146	6196	2	2
9609	146	6197	3	0
9610	146	6198	5	1
9611	146	6199	1	0
9612	146	6200	5	4
9613	146	6201	1	0
9614	146	6202	2	0
9615	146	6203	5	5
9616	146	6205	3	2
9617	146	6207	1	0
9618	146	6208	2	1
9619	146	6209	4	4
9620	146	6212	2	0
9621	146	6213	1	1
9622	146	6214	4	3
9623	146	6215	4	1
9624	146	6216	4	0
9625	146	6217	4	0
9626	146	6219	5	2
9627	146	6220	5	0
9628	146	6223	3	3
9629	146	6224	3	2
9630	146	6225	5	4
9631	146	6226	5	0
9632	146	6227	5	0
9633	146	6228	2	2
9634	146	6231	3	0
9635	146	6232	1	0
9636	146	6233	4	0
9637	146	6235	5	2
9638	146	6236	4	2
9639	146	6237	5	4
9640	146	6239	5	3
9641	146	6240	3	3
9642	146	6241	4	0
9643	146	6242	4	4
9644	146	6243	5	4
9645	146	6244	3	2
9646	146	6245	1	1
9647	146	6246	5	4
9648	146	6248	5	5
9649	146	6249	3	2
9650	146	6250	1	1
9651	146	6251	3	0
9652	146	6252	3	1
9653	146	6253	5	0
9654	146	6255	2	2
9655	146	6256	1	1
9656	146	6257	5	5
9657	146	6258	5	3
9658	146	6259	3	1
9659	146	6260	5	4
9660	147	6178	1	1
9661	147	6179	1	0
9662	147	6180	3	1
9663	147	6181	4	4
9664	147	6183	5	5
9665	147	6184	1	0
9666	147	6185	2	2
9667	147	6186	1	1
9668	147	6187	4	4
9669	147	6188	1	1
9670	147	6189	3	2
9671	147	6190	2	2
9672	147	6191	2	1
9673	147	6192	5	5
9674	147	6193	5	5
9675	147	6194	3	3
9676	147	6195	2	2
9677	147	6196	5	5
9678	147	6197	5	4
9679	147	6198	3	2
9680	147	6199	4	2
9681	147	6200	2	1
9682	147	6201	5	3
9683	147	6202	1	0
9684	147	6204	3	3
9685	147	6205	3	3
9686	147	6207	1	1
9687	147	6208	2	0
9688	147	6209	2	2
9689	147	6210	3	2
9690	147	6211	2	1
9691	147	6212	5	5
9692	147	6213	1	1
9693	147	6214	4	4
9694	147	6215	2	0
9695	147	6216	3	2
9696	147	6217	1	1
9697	147	6218	2	0
9698	147	6219	1	1
9699	147	6220	3	2
9700	147	6221	1	0
9701	147	6222	4	3
9702	147	6223	5	0
9703	147	6224	1	0
9704	147	6225	1	1
9705	147	6226	1	0
9706	147	6227	3	0
9707	147	6229	5	2
9708	147	6230	5	4
9709	147	6231	4	2
9710	147	6232	5	4
9711	147	6233	5	5
9712	147	6234	2	0
9713	147	6235	5	1
9714	147	6236	2	2
9715	147	6237	4	1
9716	147	6238	1	0
9717	147	6239	3	3
9718	147	6240	2	1
9719	147	6241	1	1
9720	147	6242	1	0
9721	147	6243	4	0
9722	147	6244	3	1
9723	147	6247	2	2
9724	147	6248	4	4
9725	147	6249	1	1
9726	147	6250	2	2
9727	147	6251	1	0
9728	147	6252	4	0
9729	147	6256	1	0
9730	148	6264	4	3
9731	148	6265	1	1
9732	148	6267	4	4
9733	148	6269	1	0
9734	148	6270	3	0
9735	148	6271	1	1
9736	148	6272	5	1
9737	148	6274	2	1
9738	148	6275	5	1
9739	148	6276	4	4
9740	148	6277	3	3
9741	148	6278	5	1
9742	148	6279	5	1
9743	148	6280	4	3
9744	148	6281	4	1
9745	148	6282	1	0
9746	148	6283	1	0
9747	148	6284	2	1
9748	148	6285	2	0
9749	148	6286	4	0
9750	148	6287	3	1
9751	148	6288	4	1
9752	148	6289	5	0
9753	148	6290	3	0
9754	148	6291	3	2
9755	148	6292	3	2
9756	148	6293	4	2
9757	148	6294	3	2
9758	148	6295	1	0
9759	148	6296	2	0
9760	148	6298	1	1
9761	148	6299	4	2
9762	148	6300	3	1
9763	148	6301	1	1
9764	148	6302	2	1
9765	148	6304	4	1
9766	148	6305	5	4
9767	148	6306	1	1
9768	148	6309	5	0
9769	148	6310	5	5
9770	148	6311	3	2
9771	148	6312	1	1
9772	148	6313	2	2
9773	148	6314	1	1
9774	148	6315	1	0
9775	148	6316	1	0
9776	148	6317	4	1
9777	148	6318	1	0
9778	148	6319	3	1
9779	148	6323	1	1
9780	148	6324	2	1
9781	148	6329	1	1
9782	149	6263	3	0
9783	149	6265	1	1
9784	149	6267	4	4
9785	149	6268	2	1
9786	149	6269	3	0
9787	149	6270	1	1
9788	149	6271	5	3
9789	149	6272	3	3
9790	149	6273	2	1
9791	149	6274	4	2
9792	149	6276	3	2
9793	149	6277	5	1
9794	149	6278	5	4
9795	149	6279	1	1
9796	149	6280	5	5
9797	149	6281	4	1
9798	149	6283	2	2
9799	149	6284	2	1
9800	149	6286	4	0
9801	149	6289	2	0
9802	149	6291	1	0
9803	149	6292	3	1
9804	149	6293	2	1
9805	149	6294	1	1
9806	149	6296	1	0
9807	149	6297	3	1
9808	149	6298	1	0
9809	149	6299	5	1
9810	149	6301	3	1
9811	149	6302	4	1
9812	149	6303	5	5
9813	149	6304	5	2
9814	149	6305	3	0
9815	149	6306	3	2
9816	149	6307	3	1
9817	149	6308	1	1
9818	149	6309	3	2
9819	149	6311	2	1
9820	149	6312	4	4
9821	149	6313	5	2
9822	149	6314	3	0
9823	149	6315	4	0
9824	149	6316	3	1
9825	149	6318	5	5
9826	149	6319	4	0
9827	149	6320	3	2
9828	149	6321	3	0
9829	149	6322	4	3
9830	149	6323	2	2
9831	149	6324	3	2
9832	149	6325	1	1
9833	149	6326	4	4
9834	149	6327	1	0
9835	149	6328	1	0
9836	149	6329	2	1
9837	149	6330	4	4
9838	149	6331	3	2
9839	149	6332	3	0
9840	149	6333	4	0
9841	149	6334	4	4
9842	149	6335	3	1
9843	149	6336	1	1
9844	149	6338	5	2
9845	149	6341	1	1
9846	150	6263	4	4
9847	150	6264	4	4
9848	150	6265	3	0
9849	150	6266	2	0
9850	150	6267	5	2
9851	150	6268	1	1
9852	150	6269	3	1
9853	150	6270	3	0
9854	150	6271	5	3
9855	150	6272	5	0
9856	150	6273	2	1
9857	150	6274	4	2
9858	150	6275	5	3
9859	150	6276	2	0
9860	150	6277	4	2
9861	150	6278	3	3
9862	150	6279	2	0
9863	150	6280	4	0
9864	150	6282	5	4
9865	150	6283	3	1
9866	150	6285	3	3
9867	150	6288	3	1
9868	150	6289	3	0
9869	150	6291	2	1
9870	150	6292	3	2
9871	150	6293	5	2
9872	150	6294	1	0
9873	150	6295	1	0
9874	150	6296	5	3
9875	150	6297	1	0
9876	150	6298	4	4
9877	150	6299	4	3
9878	150	6300	3	0
9879	150	6303	2	1
9880	150	6304	2	0
9881	150	6306	1	0
9882	150	6307	4	4
9883	150	6308	1	0
9884	150	6309	1	0
9885	150	6310	3	0
9886	150	6311	4	2
9887	150	6312	5	5
9888	150	6313	5	2
9889	150	6314	4	1
9890	150	6315	3	0
9891	150	6316	4	1
9892	151	6378	1	0
9893	151	6379	3	0
9894	151	6380	1	0
9895	151	6381	1	0
9896	151	6382	2	1
9897	151	6383	4	3
9898	151	6384	5	3
9899	151	6385	2	0
9900	151	6386	1	0
9901	151	6387	5	3
9902	151	6388	3	0
9903	151	6389	5	2
9904	151	6390	3	1
9905	151	6391	3	2
9906	151	6393	2	2
9907	151	6394	3	2
9908	151	6396	2	1
9909	151	6398	2	1
9910	151	6399	1	1
9911	151	6400	1	1
9912	151	6401	1	0
9913	151	6402	2	2
9914	151	6403	3	0
9915	151	6405	2	2
9916	151	6406	1	1
9917	151	6407	3	2
9918	151	6408	1	1
9919	151	6409	3	3
9920	151	6410	3	1
9921	151	6413	1	1
9922	151	6416	1	0
9923	151	6417	3	0
9924	151	6418	2	1
9925	151	6419	3	2
9926	151	6420	1	0
9927	151	6422	4	0
9928	151	6423	4	3
9929	151	6424	4	4
9930	151	6425	2	1
9931	151	6426	3	0
9932	151	6428	2	1
9933	151	6429	3	1
9934	151	6431	3	2
9935	151	6432	5	5
9936	151	6434	1	1
9937	151	6436	1	0
9938	151	6437	5	0
9939	151	6439	2	0
9940	151	6440	5	3
9941	151	6441	1	1
9942	151	6442	4	2
9943	151	6443	5	5
9944	151	6444	5	0
9945	151	6446	3	1
9946	151	6447	5	4
9947	151	6449	3	1
9948	151	6450	2	2
9949	151	6451	5	5
9950	151	6453	3	0
9951	151	6454	2	1
9952	151	6455	1	1
9953	151	6456	5	5
9954	151	6457	5	1
9955	151	6458	5	1
9956	151	6459	3	2
9957	151	6460	3	2
9958	151	6462	5	5
9959	151	6463	3	2
9960	151	6464	1	1
9961	151	6465	1	0
9962	151	6466	2	1
9963	151	6467	4	4
9964	151	6469	5	4
9965	151	6470	5	1
9966	151	6471	3	2
9967	151	6473	5	4
9968	151	6474	5	2
9969	152	6378	1	1
9970	152	6379	2	1
9971	152	6380	3	1
9972	152	6382	1	0
9973	152	6383	1	1
9974	152	6384	5	5
9975	152	6385	1	1
9976	152	6386	2	0
9977	152	6387	4	4
9978	152	6388	1	1
9979	152	6389	1	1
9980	152	6390	1	0
9981	152	6391	4	0
9982	152	6392	4	4
9983	152	6393	5	0
9984	152	6394	5	0
9985	152	6395	5	3
9986	152	6396	4	4
9987	152	6397	2	1
9988	152	6398	5	4
9989	152	6399	3	2
9990	152	6400	3	0
9991	152	6401	1	0
9992	152	6402	3	3
9993	152	6403	3	2
9994	152	6404	2	1
9995	152	6405	2	0
9996	152	6406	1	0
9997	152	6407	4	0
9998	152	6408	2	0
9999	152	6409	5	4
10000	152	6410	1	1
10001	152	6412	5	1
10002	152	6413	3	2
10003	152	6414	1	0
10004	152	6415	2	0
10005	152	6417	3	3
10006	152	6418	5	5
10007	152	6420	5	4
10008	152	6421	1	1
10009	152	6422	5	0
10010	152	6423	2	0
10011	152	6424	3	1
10012	152	6426	1	1
10013	152	6428	2	0
10014	152	6429	4	4
10015	152	6430	3	3
10016	152	6431	5	2
10017	152	6432	3	3
10018	152	6433	5	1
10019	152	6434	5	0
10020	152	6435	3	0
10021	152	6436	2	2
10022	152	6437	1	1
10023	153	6475	1	0
10024	153	6476	1	1
10025	153	6477	2	2
10026	153	6478	2	1
10027	153	6479	1	1
10028	153	6480	3	0
10029	153	6481	4	4
10030	153	6482	4	1
10031	153	6483	2	2
10032	153	6484	1	0
10033	153	6485	4	0
10034	153	6486	3	3
10035	153	6487	3	1
10036	153	6488	5	1
10037	153	6490	5	5
10038	153	6491	5	5
10039	153	6492	5	2
10040	153	6494	4	1
10041	153	6495	3	0
10042	153	6499	2	2
10043	153	6501	3	2
10044	153	6502	3	0
10045	153	6504	5	3
10046	153	6505	5	2
10047	153	6506	2	0
10048	153	6507	4	2
10049	153	6508	2	2
10050	153	6509	5	5
10051	153	6510	1	1
10052	153	6511	2	2
10053	153	6512	5	1
10054	153	6515	4	2
10055	153	6516	3	1
10056	153	6517	5	2
10057	153	6518	2	2
10058	153	6520	5	4
10059	153	6521	1	1
10060	153	6522	2	1
10061	153	6523	4	0
10062	153	6524	3	3
10063	153	6525	5	1
10064	153	6526	2	0
10065	153	6527	1	0
10066	153	6528	3	1
10067	153	6529	5	4
10068	153	6530	2	2
10069	153	6531	3	1
10070	153	6532	3	2
10071	153	6534	5	3
10072	153	6535	1	0
10073	153	6536	5	1
10074	153	6537	1	0
10075	153	6538	2	1
10076	153	6539	5	4
10077	153	6540	3	1
10078	153	6541	1	0
10079	153	6542	2	2
10080	153	6543	1	0
10081	153	6544	4	1
10082	153	6546	5	1
10083	153	6547	1	1
10084	153	6548	1	1
10085	153	6549	2	0
10086	153	6552	4	1
10087	153	6553	3	0
10088	153	6554	1	0
10089	153	6555	3	1
10090	153	6556	4	4
10091	153	6557	2	1
10092	153	6559	4	4
10093	153	6560	2	0
10094	153	6561	1	0
10095	153	6562	3	1
10096	153	6563	2	0
10097	153	6564	5	3
10098	153	6565	3	1
10099	153	6569	4	4
10100	153	6570	4	0
10101	153	6571	2	0
10102	153	6572	1	1
10103	153	6573	5	3
10104	153	6574	3	3
10105	153	6575	4	1
10106	153	6576	3	0
10107	153	6579	1	0
10108	154	6475	3	2
10109	154	6476	3	0
10110	154	6478	4	0
10111	154	6479	4	4
10112	154	6480	1	0
10113	154	6481	1	0
10114	154	6482	4	3
10115	154	6483	2	2
10116	154	6484	5	5
10117	154	6485	1	0
10118	154	6486	3	0
10119	154	6488	1	0
10120	154	6489	5	1
10121	154	6490	2	1
10122	154	6491	4	3
10123	154	6492	1	0
10124	154	6493	5	1
10125	154	6494	3	0
10126	154	6495	5	3
10127	154	6496	4	3
10128	154	6499	5	0
10129	154	6500	5	4
10130	154	6501	2	1
10131	154	6502	1	0
10132	154	6503	2	1
10133	154	6504	2	1
10134	154	6505	2	2
10135	154	6506	4	0
10136	154	6507	4	3
10137	154	6508	2	1
10138	154	6509	2	0
10139	154	6510	4	0
10140	154	6511	1	0
10141	154	6512	4	2
10142	154	6513	4	3
10143	154	6514	2	2
10144	154	6516	5	0
10145	154	6517	2	2
10146	154	6518	3	3
10147	154	6519	3	0
10148	154	6520	1	0
10149	154	6521	5	1
10150	154	6522	3	0
10151	154	6523	2	2
10152	154	6524	3	1
10153	154	6525	1	0
10154	154	6528	4	3
10155	154	6530	3	1
10156	154	6531	5	0
10157	154	6532	1	0
10158	154	6533	3	3
10159	154	6534	2	0
10160	154	6535	3	2
10161	154	6536	1	1
10162	154	6537	1	1
10163	154	6538	5	5
10164	154	6540	4	3
10165	154	6541	5	4
10166	154	6542	2	0
10167	154	6543	3	1
10168	154	6544	4	4
10169	154	6545	2	2
10170	154	6547	5	3
10171	154	6548	1	1
10172	154	6549	4	0
10173	154	6550	1	1
10174	154	6551	2	0
10175	154	6552	1	1
10176	154	6553	5	0
10177	154	6554	2	1
10178	154	6555	5	0
10179	154	6556	3	1
10180	154	6558	1	1
10181	154	6559	3	0
10182	154	6561	5	1
10183	154	6562	5	0
10184	154	6563	4	0
10185	154	6564	4	2
10186	154	6565	2	0
10187	154	6566	1	1
10188	155	6581	4	2
10189	155	6582	3	0
10190	155	6583	2	1
10191	155	6584	4	0
10192	155	6585	2	1
10193	155	6586	5	0
10194	155	6587	1	1
10195	155	6588	3	0
10196	155	6589	4	3
10197	155	6590	5	0
10198	155	6591	5	3
10199	155	6592	2	2
10200	155	6595	2	2
10201	155	6596	1	1
10202	155	6597	1	1
10203	155	6598	4	4
10204	155	6599	5	5
10205	155	6600	1	0
10206	155	6601	3	3
10207	155	6602	1	0
10208	155	6603	3	2
10209	155	6604	4	1
10210	155	6605	3	3
10211	155	6606	4	4
10212	155	6607	5	0
10213	155	6609	1	1
10214	155	6610	2	2
10215	155	6611	4	1
10216	155	6613	2	0
10217	155	6614	1	0
10218	155	6615	3	1
10219	155	6616	3	2
10220	155	6619	3	3
10221	155	6620	3	2
10222	155	6621	5	5
10223	155	6623	3	0
10224	155	6624	1	0
10225	155	6625	5	5
10226	155	6626	4	1
10227	155	6627	3	3
10228	155	6628	4	1
10229	155	6629	3	2
10230	155	6630	5	3
10231	155	6631	4	1
10232	155	6632	1	1
10233	155	6633	4	0
10234	155	6634	4	0
10235	155	6635	2	0
10236	155	6636	3	1
10237	155	6637	1	0
10238	155	6638	1	1
10239	155	6639	2	0
10240	155	6641	4	1
10241	155	6642	2	2
10242	155	6643	1	1
10243	155	6644	4	4
10244	155	6645	3	2
10245	155	6646	4	3
10246	155	6647	5	5
10247	155	6648	4	1
10248	155	6650	3	1
10249	155	6651	3	3
10250	155	6652	5	0
10251	155	6653	4	2
10252	155	6654	1	1
10253	155	6655	2	1
10254	155	6656	5	0
10255	155	6657	2	0
10256	155	6658	3	0
10257	155	6659	5	1
10258	155	6660	2	0
10259	155	6661	1	0
10260	155	6662	1	1
10261	155	6663	3	1
10262	155	6665	3	1
10263	155	6666	4	0
10264	156	6582	3	0
10265	156	6583	2	0
10266	156	6584	5	4
10267	156	6585	5	2
10268	156	6587	2	1
10269	156	6589	3	0
10270	156	6591	3	1
10271	156	6593	3	2
10272	156	6594	3	1
10273	156	6595	5	3
10274	156	6596	5	3
10275	156	6597	3	3
10276	156	6598	2	2
10277	156	6599	5	1
10278	156	6600	3	0
10279	156	6601	5	3
10280	156	6602	4	4
10281	156	6603	5	2
10282	156	6605	4	3
10283	156	6606	4	4
10284	156	6607	5	1
10285	156	6608	1	1
10286	156	6609	4	2
10287	156	6610	4	1
10288	156	6611	5	5
10289	156	6612	2	1
10290	156	6613	1	1
10291	156	6614	4	0
10292	156	6615	2	2
10293	156	6616	1	1
10294	156	6617	5	0
10295	156	6618	2	1
10296	156	6619	3	1
10297	156	6620	1	0
10298	156	6621	1	1
10299	156	6622	2	2
10300	156	6623	5	1
10301	156	6625	3	1
10302	156	6626	1	0
10303	156	6627	1	1
10304	156	6629	1	1
10305	157	6668	2	1
10306	157	6669	5	2
10307	157	6670	3	2
10308	157	6671	4	0
10309	157	6674	5	3
10310	157	6675	1	0
10311	157	6676	1	0
10312	157	6679	2	2
10313	157	6680	4	1
10314	157	6681	4	0
10315	157	6683	2	0
10316	157	6684	4	3
10317	157	6685	1	0
10318	157	6686	1	1
10319	157	6687	2	0
10320	157	6688	4	1
10321	157	6689	4	0
10322	157	6690	5	3
10323	157	6691	2	0
10324	157	6692	3	2
10325	157	6693	2	1
10326	157	6694	3	2
10327	157	6696	4	3
10328	157	6697	1	0
10329	157	6698	3	2
10330	157	6699	4	4
10331	157	6700	5	3
10332	157	6701	3	0
10333	157	6702	2	0
10334	157	6703	3	1
10335	157	6705	1	1
10336	157	6706	2	2
10337	157	6707	1	1
10338	157	6708	2	0
10339	157	6710	4	3
10340	157	6711	3	2
10341	157	6712	1	1
10342	157	6713	5	0
10343	157	6714	1	1
10344	157	6715	5	3
10345	157	6716	3	3
10346	157	6717	4	4
10347	157	6718	3	0
10348	157	6719	1	0
10349	157	6721	4	1
10350	157	6722	3	2
10351	157	6723	2	0
10352	157	6724	3	2
10353	157	6725	2	1
10354	157	6726	2	1
10355	157	6727	3	2
10356	157	6728	2	1
10357	157	6729	1	1
10358	157	6730	1	0
10359	157	6731	5	0
10360	157	6732	4	4
10361	157	6733	4	2
10362	157	6734	1	1
10363	157	6735	1	0
10364	157	6736	4	0
10365	157	6737	5	4
10366	157	6738	2	2
10367	157	6739	1	0
10368	157	6740	3	2
10369	157	6741	2	1
10370	157	6743	2	0
10371	157	6745	1	1
10372	157	6747	2	1
10373	157	6748	3	0
10374	157	6749	5	4
10375	157	6750	1	0
10376	158	6668	2	1
10377	158	6669	4	3
10378	158	6670	5	3
10379	158	6671	2	1
10380	158	6672	2	0
10381	158	6673	1	1
10382	158	6674	4	2
10383	158	6675	4	0
10384	158	6677	3	0
10385	158	6679	2	0
10386	158	6680	1	1
10387	158	6681	2	0
10388	158	6683	1	1
10389	158	6684	3	1
10390	158	6687	1	0
10391	158	6689	4	3
10392	158	6690	3	0
10393	158	6691	1	1
10394	158	6694	3	2
10395	158	6695	1	0
10396	158	6696	2	1
10397	158	6698	5	0
10398	158	6699	5	4
10399	158	6700	5	0
10400	158	6701	2	0
10401	158	6702	5	4
10402	158	6703	4	4
10403	158	6704	3	2
10404	158	6705	1	0
10405	158	6706	3	1
10406	158	6707	3	3
10407	158	6708	5	4
10408	158	6709	5	3
10409	158	6710	2	0
10410	158	6712	2	0
10411	158	6713	1	0
10412	158	6714	4	1
10413	158	6715	3	3
10414	158	6717	5	3
10415	158	6718	1	0
10416	158	6719	2	2
10417	158	6720	3	2
10418	158	6721	1	0
10419	158	6722	2	0
10420	158	6723	1	1
10421	158	6724	1	1
10422	158	6725	2	2
10423	158	6726	4	1
10424	158	6727	4	2
10425	158	6728	2	1
10426	158	6729	5	3
10427	158	6730	5	0
10428	158	6731	4	2
10429	158	6732	2	2
10430	158	6733	2	2
10431	159	6668	1	0
10432	159	6669	2	0
10433	159	6670	3	3
10434	159	6671	4	4
10435	159	6672	2	1
10436	159	6676	4	3
10437	159	6677	2	2
10438	159	6678	4	3
10439	159	6679	4	1
10440	159	6680	5	0
10441	159	6684	3	1
10442	159	6685	1	0
10443	159	6686	3	3
10444	159	6687	5	5
10445	159	6688	1	0
10446	159	6689	2	1
10447	159	6691	3	3
10448	159	6692	4	0
10449	159	6693	5	0
10450	159	6694	2	0
10451	159	6695	2	2
10452	159	6696	4	4
10453	159	6697	4	2
10454	159	6698	4	2
10455	159	6699	5	2
10456	159	6701	1	1
10457	159	6702	4	0
10458	159	6703	1	0
10459	159	6704	1	1
10460	159	6705	2	0
10461	159	6706	1	1
10462	159	6707	3	2
10463	159	6708	2	0
10464	159	6709	2	0
10465	159	6710	4	0
10466	159	6711	2	2
10467	159	6713	3	0
10468	159	6715	1	1
10469	159	6716	1	1
10470	159	6718	4	2
10471	159	6722	5	2
10472	159	6724	1	0
10473	159	6725	3	1
10474	159	6726	5	2
10475	159	6727	1	1
10476	159	6728	5	4
10477	159	6729	4	3
10478	159	6730	4	0
10479	159	6731	4	4
10480	159	6732	4	3
10481	159	6733	4	4
10482	159	6736	5	3
10483	159	6738	2	0
10484	159	6739	4	4
10485	159	6740	5	0
10486	159	6741	2	2
10487	159	6742	4	1
10488	159	6743	4	2
10489	159	6744	2	1
10490	159	6745	2	1
10491	160	6769	2	1
10492	160	6770	5	4
10493	160	6771	1	0
10494	160	6774	3	0
10495	160	6775	4	2
10496	160	6776	1	0
10497	160	6778	1	1
10498	160	6779	1	1
10499	160	6780	3	1
10500	160	6781	1	0
10501	160	6782	2	1
10502	160	6783	5	1
10503	160	6784	4	4
10504	160	6785	1	1
10505	160	6787	2	1
10506	160	6789	1	0
10507	160	6790	1	1
10508	160	6792	3	2
10509	160	6793	5	0
10510	160	6794	3	2
10511	160	6795	4	3
10512	160	6796	2	1
10513	160	6798	5	5
10514	160	6799	4	2
10515	160	6800	5	2
10516	160	6801	3	3
10517	160	6802	4	2
10518	160	6803	1	1
10519	160	6804	2	1
10520	160	6805	3	0
10521	160	6806	5	5
10522	160	6808	2	0
10523	160	6809	3	3
10524	160	6810	1	0
10525	160	6811	4	4
10526	160	6812	4	3
10527	160	6813	5	0
10528	160	6814	5	3
10529	160	6815	4	0
10530	161	6769	4	3
10531	161	6770	1	1
10532	161	6772	1	0
10533	161	6774	2	2
10534	161	6775	4	1
10535	161	6777	4	1
10536	161	6778	4	1
10537	161	6779	3	2
10538	161	6780	1	0
10539	161	6781	4	1
10540	161	6782	1	0
10541	161	6783	1	1
10542	161	6784	4	3
10543	161	6785	3	3
10544	161	6788	5	5
10545	161	6790	2	0
10546	161	6792	1	0
10547	161	6794	1	1
10548	161	6795	2	1
10549	161	6796	3	2
10550	161	6798	3	0
10551	161	6799	2	0
10552	161	6800	3	2
10553	161	6801	1	0
10554	161	6803	2	2
10555	161	6804	2	2
10556	161	6805	3	2
10557	161	6806	1	1
10558	161	6808	5	1
10559	161	6809	4	3
10560	161	6810	5	2
10561	161	6812	1	0
10562	161	6813	1	1
10563	161	6814	5	3
10564	161	6815	3	3
10565	161	6816	5	5
10566	161	6817	4	1
10567	161	6818	2	0
10568	161	6819	1	1
10569	161	6821	2	0
10570	161	6823	4	3
10571	161	6824	5	4
10572	161	6825	4	4
10573	161	6826	1	0
10574	161	6827	5	4
10575	161	6828	1	1
10576	161	6830	1	1
10577	161	6832	5	4
10578	161	6833	1	1
10579	161	6835	1	0
10580	161	6837	5	1
10581	161	6838	5	0
10582	161	6839	4	0
10583	161	6840	5	2
10584	161	6841	1	0
10585	161	6842	3	0
10586	161	6843	1	1
10587	161	6844	2	2
10588	161	6845	5	2
10589	161	6846	1	0
10590	161	6847	3	1
10591	161	6849	3	1
10592	161	6850	5	5
10593	161	6852	1	1
10594	161	6853	2	2
10595	161	6855	3	1
10596	161	6856	1	1
10597	161	6857	2	1
10598	161	6858	3	3
10599	161	6859	5	4
10600	161	6860	3	2
10601	161	6861	5	0
10602	161	6862	3	1
10603	161	6863	4	3
10604	161	6865	5	3
10605	161	6866	3	2
10606	161	6867	5	2
10607	162	6868	3	0
10608	162	6869	5	0
10609	162	6870	2	0
10610	162	6871	2	0
10611	162	6873	1	1
10612	162	6875	1	1
10613	162	6876	2	2
10614	162	6877	1	0
10615	162	6878	4	0
10616	162	6879	5	0
10617	162	6880	5	3
10618	162	6881	5	4
10619	162	6882	3	3
10620	162	6883	3	1
10621	162	6884	4	4
10622	162	6885	3	3
10623	162	6886	2	0
10624	162	6887	2	0
10625	162	6888	3	0
10626	162	6889	5	5
10627	162	6890	5	5
10628	162	6891	4	0
10629	162	6892	5	1
10630	162	6893	5	2
10631	162	6895	5	4
10632	162	6896	3	2
10633	162	6897	3	0
10634	162	6899	1	1
10635	162	6900	1	0
10636	162	6901	3	3
10637	162	6902	4	1
10638	162	6904	3	2
10639	162	6905	2	1
10640	162	6906	3	1
10641	162	6907	1	1
10642	163	6868	4	3
10643	163	6869	2	1
10644	163	6870	2	2
10645	163	6872	4	3
10646	163	6873	1	1
10647	163	6874	5	0
10648	163	6875	4	2
10649	163	6876	2	1
10650	163	6878	4	4
10651	163	6879	5	3
10652	163	6881	3	1
10653	163	6882	5	2
10654	163	6883	5	3
10655	163	6884	2	1
10656	163	6885	3	0
10657	163	6886	2	1
10658	163	6887	4	4
10659	163	6889	2	1
10660	163	6890	5	5
10661	163	6891	4	4
10662	163	6892	2	0
10663	163	6893	1	1
10664	163	6894	4	4
10665	163	6896	4	3
10666	163	6897	4	0
10667	163	6899	1	1
10668	163	6900	5	1
10669	163	6901	4	0
10670	163	6902	2	1
10671	163	6903	4	1
10672	163	6904	2	2
10673	163	6905	4	4
10674	163	6906	5	3
10675	163	6907	1	1
10676	163	6909	4	3
10677	163	6910	1	1
10678	163	6911	3	1
10679	163	6912	5	0
10680	163	6913	3	0
10681	163	6914	5	3
10682	163	6916	5	0
10683	163	6917	1	1
10684	163	6918	1	1
10685	163	6919	5	1
10686	163	6920	1	1
10687	163	6922	3	3
10688	163	6923	1	0
10689	163	6924	3	3
10690	163	6925	2	0
10691	163	6926	2	1
10692	164	6868	2	1
10693	164	6869	2	2
10694	164	6870	1	0
10695	164	6871	4	3
10696	164	6872	1	0
10697	164	6873	2	0
10698	164	6874	2	0
10699	164	6875	4	0
10700	164	6876	1	0
10701	164	6877	2	1
10702	164	6879	3	1
10703	164	6880	2	2
10704	164	6881	1	0
10705	164	6883	2	2
10706	164	6884	4	4
10707	164	6885	3	2
10708	164	6886	2	0
10709	164	6887	4	2
10710	164	6888	3	2
10711	164	6890	5	4
10712	164	6891	2	1
10713	164	6892	5	0
10714	164	6894	4	4
10715	164	6895	1	0
10716	164	6897	4	3
10717	164	6898	2	1
10718	164	6899	1	0
10719	164	6900	1	0
10720	164	6901	1	1
10721	164	6902	2	2
10722	164	6904	5	2
10723	164	6905	3	2
10724	164	6906	5	3
10725	164	6907	4	0
10726	164	6908	5	2
10727	164	6909	4	3
10728	164	6910	1	1
10729	164	6911	2	1
10730	164	6913	4	2
10731	164	6914	5	3
10732	164	6915	3	3
10733	164	6918	1	1
10734	164	6919	3	3
10735	164	6920	1	1
10736	164	6921	3	2
10737	164	6922	3	1
10738	164	6923	4	4
10739	164	6926	2	2
10740	164	6927	4	0
10741	164	6928	2	0
10742	164	6929	2	1
10743	164	6930	2	0
10744	164	6931	3	3
10745	164	6934	1	0
10746	164	6935	1	0
10747	164	6936	2	0
10748	164	6939	5	4
10749	164	6940	1	0
10750	164	6941	2	2
10751	164	6942	5	2
10752	164	6943	3	3
10753	164	6945	3	2
10754	164	6946	5	0
10755	164	6948	4	4
10756	164	6949	2	0
10757	164	6950	4	4
10758	164	6951	5	5
10759	164	6952	2	2
10760	164	6953	4	0
10761	164	6954	3	3
10762	164	6955	1	0
10763	165	6965	4	1
10764	165	6966	3	3
10765	165	6967	3	3
10766	165	6970	3	2
10767	165	6971	2	0
10768	165	6972	2	0
10769	165	6973	1	1
10770	165	6975	3	2
10771	165	6976	5	1
10772	165	6977	1	0
10773	165	6978	1	0
10774	165	6979	5	3
10775	165	6980	5	4
10776	165	6981	2	0
10777	165	6982	3	0
10778	165	6983	4	3
10779	165	6984	1	0
10780	165	6985	3	1
10781	165	6986	5	0
10782	165	6987	5	4
10783	165	6989	4	1
10784	165	6990	5	4
10785	165	6991	3	1
10786	165	6992	2	1
10787	165	6993	1	0
10788	165	6994	2	0
10789	165	6995	4	4
10790	165	6996	3	2
10791	165	6997	1	0
10792	165	6998	1	1
10793	165	6999	4	4
10794	165	7001	4	1
10795	165	7002	2	1
10796	165	7004	4	2
10797	165	7005	2	1
10798	165	7006	3	0
10799	165	7007	5	0
10800	165	7008	1	1
10801	165	7009	5	4
10802	165	7010	5	5
10803	165	7011	5	0
10804	165	7012	4	0
10805	165	7013	2	0
10806	165	7014	4	4
10807	165	7015	3	0
10808	165	7016	2	0
10809	165	7021	2	0
10810	165	7022	5	4
10811	165	7023	1	0
10812	165	7024	3	1
10813	165	7025	2	1
10814	165	7026	1	0
10815	165	7027	2	0
10816	165	7028	4	1
10817	165	7029	3	0
10818	165	7030	4	4
10819	165	7031	5	3
10820	165	7032	3	1
10821	165	7033	3	2
10822	165	7034	3	3
10823	165	7035	1	0
10824	165	7037	5	5
10825	165	7038	4	1
10826	165	7039	3	2
10827	166	6965	2	2
10828	166	6966	3	1
10829	166	6967	4	4
10830	166	6968	5	0
10831	166	6969	4	3
10832	166	6970	2	0
10833	166	6971	3	0
10834	166	6972	1	1
10835	166	6973	3	2
10836	166	6974	5	0
10837	166	6975	3	3
10838	166	6976	4	1
10839	166	6977	3	0
10840	166	6978	2	0
10841	166	6980	2	0
10842	166	6981	4	3
10843	166	6983	2	2
10844	166	6984	2	1
10845	166	6985	5	0
10846	166	6986	5	3
10847	166	6989	2	0
10848	166	6990	4	0
10849	166	6991	2	0
10850	166	6992	4	1
10851	166	6993	4	4
10852	166	6994	5	2
10853	166	6996	1	1
10854	166	6998	2	2
10855	166	6999	4	1
10856	166	7000	4	4
10857	166	7001	3	0
10858	166	7002	2	1
10859	166	7003	2	2
10860	166	7004	4	2
10861	166	7006	1	1
10862	166	7007	2	1
10863	166	7008	1	0
10864	166	7009	4	3
10865	166	7010	5	2
10866	166	7012	3	1
10867	166	7014	4	1
10868	166	7015	3	0
10869	166	7016	4	3
10870	166	7017	3	3
10871	166	7018	3	1
10872	166	7019	4	2
10873	166	7022	2	2
10874	166	7023	4	4
10875	166	7024	1	1
10876	166	7026	3	3
10877	166	7027	1	0
10878	166	7028	1	0
10879	166	7029	3	1
10880	166	7030	3	1
10881	166	7031	2	1
10882	166	7032	2	1
10883	166	7033	4	2
10884	166	7034	4	1
10885	166	7035	4	0
10886	166	7036	3	0
10887	166	7037	4	1
10888	166	7038	2	0
10889	166	7041	5	5
10890	167	7060	3	1
10891	167	7061	3	2
10892	167	7062	2	2
10893	167	7063	5	0
10894	167	7064	2	1
10895	167	7065	3	3
10896	167	7066	4	3
10897	167	7070	1	1
10898	167	7071	4	3
10899	167	7074	5	1
10900	167	7075	3	3
10901	167	7076	4	2
10902	167	7077	2	2
10903	167	7078	1	0
10904	167	7079	3	2
10905	167	7080	1	0
10906	167	7081	2	1
10907	167	7082	3	1
10908	167	7083	4	1
10909	167	7084	1	0
10910	167	7085	3	2
10911	167	7086	3	1
10912	167	7088	1	1
10913	167	7089	5	4
10914	167	7090	3	0
10915	167	7091	3	0
10916	167	7092	1	1
10917	167	7093	5	0
10918	167	7094	5	5
10919	167	7095	1	0
10920	167	7096	4	4
10921	167	7097	4	0
10922	167	7098	3	0
10923	167	7099	4	4
10924	167	7100	3	1
10925	168	7060	2	2
10926	168	7061	1	0
10927	168	7062	3	0
10928	168	7064	5	1
10929	168	7065	1	1
10930	168	7066	4	4
10931	168	7067	2	0
10932	168	7068	4	2
10933	168	7070	3	0
10934	168	7071	3	3
10935	168	7072	3	0
10936	168	7073	5	2
10937	168	7074	3	2
10938	168	7075	2	1
10939	168	7076	1	0
10940	168	7078	1	0
10941	168	7081	5	0
10942	168	7082	5	1
10943	168	7083	3	3
10944	168	7084	1	0
10945	168	7085	2	2
10946	168	7086	3	3
10947	168	7087	2	0
10948	168	7088	2	2
10949	168	7089	3	3
10950	168	7090	3	0
10951	168	7091	4	3
10952	168	7093	3	0
10953	168	7095	5	5
10954	168	7096	1	1
10955	168	7098	3	2
10956	168	7100	5	0
10957	168	7102	5	4
10958	168	7103	5	5
10959	168	7105	1	1
10960	168	7106	2	2
10961	168	7107	1	1
10962	168	7109	4	1
10963	168	7110	1	0
10964	168	7113	1	1
10965	168	7114	5	0
10966	168	7115	1	1
10967	168	7116	4	0
10968	168	7117	5	1
10969	168	7118	1	0
10970	168	7119	4	0
10971	168	7120	3	2
10972	168	7122	1	1
10973	168	7123	2	2
10974	168	7124	5	0
10975	168	7125	2	1
10976	168	7126	4	1
10977	168	7127	2	0
10978	168	7128	2	1
10979	168	7129	2	0
10980	168	7130	1	0
10981	168	7131	3	1
10982	168	7132	1	1
10983	168	7133	2	1
10984	168	7134	2	0
10985	168	7135	1	0
10986	168	7138	2	2
10987	168	7139	1	1
10988	168	7140	3	3
10989	168	7141	3	1
10990	168	7142	4	1
10991	168	7143	4	2
10992	168	7144	5	2
10993	168	7145	3	3
10994	168	7149	1	0
10995	169	7061	2	0
10996	169	7062	1	0
10997	169	7063	3	3
10998	169	7064	1	0
10999	169	7065	2	2
11000	169	7066	1	0
11001	169	7067	1	1
11002	169	7068	5	0
11003	169	7069	3	1
11004	169	7070	4	0
11005	169	7071	5	3
11006	169	7072	5	5
11007	169	7073	1	0
11008	169	7074	3	1
11009	169	7075	4	3
11010	169	7076	4	2
11011	169	7077	1	0
11012	169	7078	5	1
11013	169	7079	5	2
11014	169	7080	1	1
11015	169	7081	2	1
11016	169	7082	1	0
11017	169	7083	5	1
11018	169	7084	3	3
11019	169	7085	3	1
11020	169	7086	3	3
11021	169	7087	4	2
11022	169	7089	1	0
11023	169	7090	5	5
11024	169	7091	2	0
11025	169	7093	5	2
11026	169	7095	3	0
11027	169	7096	2	1
11028	169	7097	1	1
11029	169	7098	5	2
11030	169	7099	3	1
11031	169	7100	1	0
11032	169	7101	3	1
11033	169	7103	4	2
11034	169	7104	2	2
11035	169	7106	1	0
11036	169	7107	2	1
11037	169	7108	3	0
11038	169	7109	1	1
11039	169	7110	3	1
11040	169	7111	5	2
11041	169	7112	1	1
11042	169	7113	4	1
11043	169	7114	5	4
11044	169	7115	3	3
11045	169	7116	2	0
11046	169	7118	5	5
11047	170	7150	4	1
11048	170	7151	1	1
11049	170	7152	1	1
11050	170	7153	2	2
11051	170	7154	5	0
11052	170	7155	1	1
11053	170	7157	4	0
11054	170	7159	2	0
11055	170	7160	2	2
11056	170	7161	4	0
11057	170	7162	5	2
11058	170	7163	5	1
11059	170	7164	1	1
11060	170	7165	2	1
11061	170	7166	5	5
11062	170	7168	5	4
11063	170	7170	2	2
11064	170	7171	5	0
11065	170	7172	2	0
11066	170	7174	3	2
11067	170	7175	2	0
11068	170	7176	1	1
11069	170	7177	2	2
11070	170	7178	1	0
11071	170	7180	2	0
11072	170	7181	4	0
11073	170	7182	4	0
11074	170	7183	3	1
11075	170	7184	2	0
11076	170	7185	3	0
11077	170	7186	1	1
11078	170	7187	2	2
11079	170	7188	4	0
11080	170	7189	4	1
11081	170	7190	3	2
11082	170	7191	5	1
11083	170	7192	5	3
11084	170	7193	5	2
11085	170	7194	4	1
11086	170	7196	2	1
11087	170	7197	4	2
11088	170	7198	2	0
11089	170	7200	4	4
11090	170	7201	3	1
11091	170	7202	3	3
11092	170	7203	3	0
11093	170	7204	2	0
11094	170	7206	2	1
11095	170	7207	5	2
11096	170	7208	1	1
11097	170	7210	1	1
11098	170	7211	1	1
11099	171	7150	1	0
11100	171	7151	5	4
11101	171	7152	2	0
11102	171	7153	2	0
11103	171	7155	1	1
11104	171	7157	3	3
11105	171	7158	5	0
11106	171	7160	5	5
11107	171	7161	4	4
11108	171	7162	4	4
11109	171	7165	5	4
11110	171	7166	1	0
11111	171	7168	3	3
11112	171	7169	1	0
11113	171	7170	4	2
11114	171	7172	5	1
11115	171	7173	3	2
11116	171	7174	4	1
11117	171	7175	2	2
11118	171	7176	4	0
11119	171	7178	3	0
11120	171	7181	1	1
11121	171	7182	5	2
11122	171	7183	1	0
11123	171	7184	2	1
11124	171	7185	3	2
11125	171	7186	2	1
11126	171	7187	2	1
11127	171	7188	1	0
11128	171	7189	1	1
11129	171	7190	4	1
11130	171	7191	4	1
11131	171	7192	1	0
11132	171	7194	3	0
11133	171	7195	5	3
11134	171	7196	4	4
11135	171	7197	1	0
11136	171	7198	5	3
11137	171	7199	5	2
11138	171	7200	4	1
11139	171	7201	1	0
11140	171	7202	5	0
11141	171	7203	4	2
11142	171	7205	2	2
11143	171	7206	1	0
11144	171	7207	3	0
11145	171	7210	5	1
11146	171	7211	2	1
11147	171	7212	2	0
11148	171	7214	3	2
11149	171	7216	3	1
11150	171	7217	1	1
11151	171	7218	4	0
11152	171	7219	5	4
11153	171	7220	4	4
11154	171	7221	2	2
11155	171	7222	5	4
11156	171	7223	5	3
11157	171	7224	3	2
11158	171	7225	2	1
11159	171	7227	3	0
11160	171	7229	2	2
11161	171	7230	3	0
11162	171	7231	1	1
11163	171	7233	5	3
11164	171	7234	2	1
11165	171	7237	1	0
11166	171	7238	1	1
11167	171	7239	1	0
11168	171	7240	2	2
11169	171	7241	1	0
11170	171	7242	2	2
11171	171	7244	1	0
11172	171	7247	3	2
11173	172	7150	4	0
11174	172	7152	2	0
11175	172	7154	4	2
11176	172	7155	5	4
11177	172	7157	1	1
11178	172	7158	5	0
11179	172	7159	2	1
11180	172	7160	5	2
11181	172	7162	3	3
11182	172	7163	3	3
11183	172	7164	4	3
11184	172	7165	1	1
11185	172	7167	4	0
11186	172	7169	1	1
11187	172	7170	3	3
11188	172	7171	2	2
11189	172	7172	4	4
11190	172	7173	5	3
11191	172	7174	1	0
11192	172	7175	4	1
11193	172	7176	1	1
11194	172	7177	3	1
11195	172	7178	4	1
11196	172	7179	2	0
11197	172	7181	2	1
11198	172	7182	1	0
11199	172	7183	2	1
11200	172	7184	1	0
11201	172	7185	1	0
11202	172	7186	5	1
11203	172	7187	1	1
11204	172	7188	3	1
11205	172	7189	4	1
11206	172	7190	4	2
11207	172	7192	3	1
11208	172	7193	5	5
11209	172	7194	4	2
11210	172	7195	3	3
11211	172	7196	4	4
11212	172	7197	4	0
11213	172	7198	1	0
11214	172	7199	1	0
11215	172	7200	3	1
11216	172	7201	3	3
11217	172	7202	5	4
11218	172	7203	5	5
11219	172	7204	1	0
11220	172	7205	2	0
11221	172	7206	1	0
11222	172	7207	3	1
11223	172	7208	5	2
11224	172	7209	4	4
11225	172	7210	3	3
11226	172	7211	4	0
11227	172	7212	5	1
11228	172	7213	1	0
11229	172	7214	4	0
11230	172	7215	3	1
11231	172	7216	2	1
11232	172	7217	1	1
11233	172	7218	5	2
11234	172	7220	3	1
11235	172	7221	2	2
11236	172	7222	3	2
11237	172	7224	4	1
11238	172	7226	1	1
11239	172	7227	5	5
11240	172	7228	4	3
11241	172	7230	2	2
11242	172	7231	3	0
11243	172	7235	5	1
11244	172	7236	1	0
11245	172	7237	5	1
11246	172	7240	4	0
11247	172	7241	4	2
11248	172	7243	3	0
11249	173	7252	2	1
11250	173	7253	4	4
11251	173	7254	3	1
11252	173	7255	5	4
11253	173	7256	3	2
11254	173	7258	1	1
11255	173	7259	5	1
11256	173	7260	4	3
11257	173	7261	2	2
11258	173	7262	3	2
11259	173	7263	2	1
11260	173	7264	4	2
11261	173	7266	2	1
11262	173	7267	2	1
11263	173	7270	5	4
11264	173	7271	4	1
11265	173	7272	1	0
11266	173	7274	5	2
11267	173	7275	3	1
11268	173	7276	5	5
11269	173	7277	4	0
11270	173	7278	3	2
11271	173	7280	2	2
11272	173	7281	4	2
11273	173	7282	4	0
11274	173	7283	3	2
11275	173	7285	3	0
11276	173	7286	2	0
11277	173	7287	5	0
11278	173	7288	4	2
11279	173	7290	4	4
11280	173	7291	2	2
11281	173	7294	1	1
11282	173	7295	2	0
11283	173	7297	3	1
11284	173	7298	4	3
11285	173	7299	1	1
11286	173	7300	1	1
11287	173	7301	1	0
11288	173	7302	4	1
11289	173	7304	5	1
11290	173	7306	2	2
11291	173	7307	4	3
11292	173	7308	2	0
11293	173	7309	3	3
11294	173	7312	1	1
11295	173	7313	4	1
11296	173	7314	4	1
11297	173	7315	3	2
11298	173	7316	1	0
11299	173	7317	5	0
11300	173	7318	1	1
11301	173	7319	5	4
11302	173	7320	2	2
11303	173	7321	4	1
11304	173	7322	2	0
11305	173	7323	4	4
11306	173	7324	1	0
11307	173	7325	5	2
11308	173	7326	3	1
11309	173	7328	4	4
11310	173	7329	4	2
11311	173	7331	3	3
11312	174	7250	1	0
11313	174	7251	1	0
11314	174	7252	1	0
11315	174	7253	1	1
11316	174	7254	1	0
11317	174	7255	2	0
11318	174	7256	3	3
11319	174	7257	2	1
11320	174	7258	3	0
11321	174	7259	1	0
11322	174	7261	5	2
11323	174	7262	5	5
11324	174	7263	5	3
11325	174	7264	2	0
11326	174	7265	3	2
11327	174	7266	2	1
11328	174	7267	4	4
11329	174	7269	5	4
11330	174	7270	5	3
11331	174	7273	2	1
11332	174	7276	4	3
11333	174	7277	5	4
11334	174	7278	4	0
11335	174	7279	3	1
11336	174	7280	1	0
11337	174	7282	5	4
11338	174	7283	3	1
11339	174	7284	2	1
11340	174	7285	5	3
11341	174	7286	4	4
11342	174	7287	2	1
11343	174	7288	2	1
11344	174	7289	1	0
11345	174	7290	4	2
11346	174	7291	5	0
11347	174	7292	4	4
11348	174	7293	4	4
11349	174	7294	1	1
11350	174	7295	5	5
11351	174	7296	5	1
11352	174	7297	2	2
11353	174	7298	4	2
11354	174	7299	2	2
11355	174	7300	1	1
11356	174	7301	4	0
11357	174	7302	1	1
11358	174	7303	4	1
11359	174	7305	4	0
11360	174	7307	5	4
11361	174	7308	5	4
11362	174	7309	4	3
11363	174	7310	1	0
11364	174	7311	3	2
11365	174	7312	4	1
11366	174	7314	5	2
11367	174	7315	2	0
11368	174	7316	4	3
11369	174	7317	2	1
11370	174	7318	4	3
11371	175	7333	4	1
11372	175	7334	4	2
11373	175	7335	4	1
11374	175	7336	2	0
11375	175	7337	4	2
11376	175	7338	3	1
11377	175	7339	3	1
11378	175	7340	5	3
11379	175	7341	3	1
11380	175	7342	2	2
11381	175	7343	5	4
11382	175	7344	4	1
11383	175	7345	4	0
11384	175	7346	5	2
11385	175	7347	3	3
11386	175	7348	4	0
11387	175	7351	2	1
11388	175	7352	5	1
11389	175	7353	1	1
11390	175	7354	1	0
11391	175	7355	5	2
11392	175	7356	3	1
11393	175	7357	5	0
11394	175	7358	2	0
11395	175	7359	2	1
11396	175	7360	4	1
11397	175	7361	2	1
11398	175	7362	3	0
11399	175	7364	2	0
11400	175	7365	2	2
11401	175	7366	1	0
11402	175	7368	4	1
11403	175	7370	1	0
11404	176	7332	4	0
11405	176	7333	5	5
11406	176	7336	5	2
11407	176	7337	4	0
11408	176	7338	2	2
11409	176	7339	2	1
11410	176	7340	1	1
11411	176	7341	3	1
11412	176	7342	4	0
11413	176	7343	2	0
11414	176	7344	4	0
11415	176	7345	2	1
11416	176	7346	4	1
11417	176	7347	5	1
11418	176	7348	5	1
11419	176	7349	4	2
11420	176	7351	4	3
11421	176	7352	1	1
11422	176	7353	3	3
11423	176	7354	5	2
11424	176	7355	5	2
11425	176	7356	2	1
11426	176	7357	4	3
11427	176	7359	1	0
11428	176	7361	3	2
11429	176	7362	1	0
11430	176	7363	2	1
11431	176	7364	1	0
11432	176	7365	5	0
11433	176	7368	2	1
11434	176	7371	2	1
11435	176	7372	2	2
11436	176	7373	1	0
11437	176	7375	5	4
11438	176	7377	2	1
11439	176	7378	4	2
11440	176	7379	5	2
11441	176	7380	2	0
11442	176	7381	3	2
11443	176	7383	2	1
11444	176	7384	4	0
11445	176	7385	1	0
11446	176	7389	1	1
11447	176	7390	1	1
11448	176	7391	4	3
11449	176	7392	4	1
11450	176	7393	2	2
11451	176	7394	5	4
11452	176	7395	4	1
11453	176	7396	3	2
11454	176	7397	4	4
11455	176	7398	3	2
11456	176	7399	3	1
11457	176	7400	2	1
11458	176	7401	5	3
11459	176	7402	4	4
11460	176	7403	5	2
11461	176	7405	3	2
11462	176	7406	3	2
11463	176	7407	5	1
11464	176	7408	1	1
11465	176	7410	1	0
11466	176	7411	1	1
11467	176	7412	1	1
11468	176	7413	1	1
11469	176	7415	4	0
11470	176	7417	3	3
11471	176	7418	3	0
11472	176	7419	5	5
11473	176	7420	2	0
11474	176	7421	4	2
11475	176	7422	1	1
11476	176	7423	4	0
11477	176	7424	3	1
11478	176	7425	4	3
11479	176	7426	1	0
11480	176	7427	1	1
11481	176	7428	1	1
11482	176	7430	3	0
11483	176	7431	1	0
11484	176	7432	5	5
11485	176	7433	1	1
11486	176	7435	2	2
11487	176	7436	5	2
11488	177	7332	1	0
11489	177	7333	1	1
11490	177	7334	5	1
11491	177	7335	5	1
11492	177	7337	3	2
11493	177	7338	5	0
11494	177	7339	2	2
11495	177	7340	4	0
11496	177	7341	1	0
11497	177	7342	1	1
11498	177	7343	1	1
11499	177	7344	4	0
11500	177	7345	1	1
11501	177	7347	2	1
11502	177	7348	3	1
11503	177	7349	2	0
11504	177	7351	3	2
11505	177	7354	4	4
11506	177	7355	2	2
11507	177	7356	2	0
11508	177	7357	2	0
11509	177	7358	5	2
11510	177	7359	5	2
11511	177	7360	5	5
11512	177	7361	1	0
11513	177	7362	3	3
11514	177	7363	2	2
11515	177	7364	2	0
11516	177	7365	4	0
11517	177	7366	3	1
11518	177	7367	1	0
11519	177	7368	4	3
11520	177	7369	3	0
11521	177	7371	2	0
11522	177	7372	1	0
11523	177	7373	1	1
11524	177	7374	4	1
11525	177	7377	5	4
11526	177	7378	4	3
11527	177	7379	3	1
11528	177	7382	1	1
11529	177	7383	4	0
11530	177	7384	3	3
11531	177	7386	4	3
11532	177	7387	5	4
11533	177	7390	4	1
11534	177	7392	5	0
11535	177	7394	1	0
11536	177	7395	4	4
11537	177	7396	3	1
11538	177	7397	1	0
11539	177	7398	3	3
11540	177	7399	4	4
11541	177	7400	5	4
11542	177	7401	5	4
11543	177	7402	2	2
11544	177	7403	5	2
11545	177	7404	5	4
11546	177	7405	1	1
11547	177	7406	4	3
11548	177	7407	2	1
11549	177	7409	4	2
11550	177	7411	1	0
11551	177	7414	2	2
11552	177	7415	1	0
11553	177	7416	3	3
11554	177	7417	5	3
11555	177	7419	1	1
11556	177	7421	4	1
11557	177	7422	1	1
11558	177	7423	3	3
11559	177	7426	4	2
11560	177	7427	5	4
11561	177	7428	5	1
11562	177	7429	2	2
11563	177	7430	3	1
11564	177	7431	1	0
11565	177	7432	1	1
11566	177	7433	2	1
11567	177	7434	3	1
11568	177	7435	5	2
11569	177	7437	5	0
11570	177	7438	3	3
11571	177	7439	4	2
11572	177	7440	1	1
11573	177	7442	5	3
11574	177	7443	5	4
11575	177	7444	4	2
11576	177	7446	3	2
11577	178	7447	4	0
11578	178	7448	1	0
11579	178	7449	2	0
11580	178	7450	1	0
11581	178	7451	4	3
11582	178	7453	4	1
11583	178	7454	3	3
11584	178	7455	1	0
11585	178	7456	3	0
11586	178	7457	2	1
11587	178	7459	5	2
11588	178	7460	5	2
11589	178	7461	1	0
11590	178	7462	1	0
11591	178	7463	4	2
11592	178	7466	2	1
11593	178	7467	1	0
11594	178	7468	2	0
11595	178	7469	4	2
11596	178	7470	4	2
11597	178	7472	3	0
11598	178	7473	2	0
11599	178	7474	5	4
11600	178	7475	4	4
11601	178	7476	5	3
11602	178	7477	1	0
11603	178	7478	2	2
11604	178	7479	5	0
11605	178	7480	5	1
11606	178	7481	2	0
11607	178	7483	3	2
11608	178	7485	1	1
11609	178	7486	5	0
11610	178	7487	4	4
11611	178	7488	3	3
11612	178	7489	1	1
11613	178	7490	2	2
11614	178	7491	5	0
11615	178	7492	4	0
11616	178	7493	4	2
11617	178	7494	3	1
11618	178	7495	1	0
11619	178	7496	1	0
11620	178	7497	1	0
11621	178	7498	4	3
11622	178	7499	1	0
11623	178	7500	2	1
11624	178	7501	5	1
11625	178	7502	4	4
11626	178	7504	3	3
11627	178	7505	2	0
11628	178	7506	5	5
11629	178	7507	1	1
11630	178	7508	2	2
11631	178	7509	2	1
11632	178	7510	2	1
11633	178	7511	5	5
11634	178	7514	4	2
11635	178	7515	2	2
11636	178	7517	4	4
11637	178	7520	1	0
11638	179	7447	1	1
11639	179	7448	2	0
11640	179	7449	5	1
11641	179	7450	3	2
11642	179	7452	1	0
11643	179	7453	4	1
11644	179	7454	5	2
11645	179	7455	3	1
11646	179	7456	3	0
11647	179	7457	2	2
11648	179	7459	3	3
11649	179	7460	4	0
11650	179	7462	4	3
11651	179	7463	4	4
11652	179	7464	2	1
11653	179	7465	1	1
11654	179	7466	4	3
11655	179	7467	4	3
11656	179	7468	2	1
11657	179	7469	4	1
11658	179	7470	2	2
11659	179	7471	1	1
11660	179	7472	2	0
11661	179	7473	4	3
11662	179	7474	5	4
11663	179	7475	3	1
11664	179	7477	5	1
11665	179	7479	2	2
11666	179	7480	1	1
11667	179	7481	2	1
11668	179	7482	2	2
11669	179	7483	5	5
11670	179	7485	1	1
11671	179	7486	3	1
11672	179	7488	4	1
11673	179	7489	2	1
11674	179	7491	1	0
11675	179	7492	1	0
11676	179	7493	1	1
11677	179	7494	4	2
11678	179	7495	1	0
11679	179	7496	4	4
11680	179	7498	2	2
11681	179	7499	5	0
11682	179	7501	4	3
11683	179	7502	1	0
11684	179	7503	2	2
11685	179	7504	3	3
11686	179	7505	3	1
11687	179	7506	5	1
11688	179	7508	3	0
11689	179	7509	5	4
11690	179	7510	4	1
11691	179	7511	1	1
11692	179	7513	4	1
11693	179	7515	4	0
11694	179	7516	5	4
11695	179	7517	4	2
11696	179	7518	3	2
11697	179	7519	2	1
11698	179	7520	2	1
11699	179	7521	3	2
11700	179	7522	1	1
11701	179	7524	1	1
11702	179	7525	4	0
11703	179	7526	4	0
11704	179	7528	4	3
11705	179	7529	3	2
11706	179	7530	2	2
11707	179	7531	2	2
11708	179	7533	4	1
11709	179	7534	5	4
11710	179	7535	2	1
11711	179	7536	2	2
11712	179	7537	4	0
11713	180	7447	5	3
11714	180	7448	1	0
11715	180	7449	5	1
11716	180	7451	5	3
11717	180	7452	2	2
11718	180	7453	4	2
11719	180	7454	5	0
11720	180	7455	2	1
11721	180	7457	2	2
11722	180	7459	4	1
11723	180	7461	5	4
11724	180	7463	2	2
11725	180	7464	3	0
11726	180	7465	2	2
11727	180	7466	3	0
11728	180	7467	2	0
11729	180	7469	2	1
11730	180	7470	3	3
11731	180	7471	4	4
11732	180	7472	2	1
11733	180	7475	2	1
11734	180	7476	5	5
11735	180	7477	3	3
11736	180	7478	3	0
11737	180	7479	3	0
11738	180	7481	3	2
11739	180	7484	5	4
11740	180	7485	4	2
11741	180	7486	3	1
11742	180	7487	1	1
11743	180	7488	1	0
11744	180	7490	1	0
11745	180	7491	4	2
\.


--
-- Data for Name: conferencedays; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY conferencedays (conferencedayid, conferences_conferenceid, date, numberofparticipants) FROM stdin;
0	0	2003-01-13	242
1	0	2003-01-14	165
2	0	2003-01-15	240
3	1	2003-01-26	237
4	1	2003-01-27	208
5	2	2003-02-13	111
6	2	2003-02-14	275
7	3	2003-03-05	293
8	3	2003-03-06	231
9	4	2003-03-25	278
10	4	2003-03-26	298
11	4	2003-03-27	281
12	5	2003-04-07	180
13	5	2003-04-08	118
14	5	2003-04-09	299
15	6	2003-04-20	185
16	6	2003-04-21	113
17	7	2003-05-01	151
18	7	2003-05-02	239
19	8	2003-05-19	171
20	8	2003-05-20	165
21	9	2003-06-03	117
22	9	2003-06-04	168
23	10	2003-06-13	132
24	10	2003-06-14	280
25	10	2003-06-15	100
26	11	2003-07-03	224
27	11	2003-07-04	260
28	11	2003-07-05	285
29	12	2003-07-21	106
30	12	2003-07-22	260
31	13	2003-08-08	248
32	13	2003-08-09	141
33	14	2003-08-21	224
34	14	2003-08-22	274
35	14	2003-08-23	114
36	15	2003-08-31	139
37	15	2003-09-01	138
38	16	2003-09-17	226
39	16	2003-09-18	285
40	17	2003-10-03	116
41	17	2003-10-04	107
42	17	2003-10-05	248
43	18	2003-10-13	268
44	18	2003-10-14	298
45	19	2003-11-02	252
46	19	2003-11-03	247
47	19	2003-11-04	103
48	20	2003-11-18	212
49	20	2003-11-19	264
50	20	2003-11-20	276
51	21	2003-12-03	154
52	21	2003-12-04	123
53	21	2003-12-05	189
54	22	2003-12-17	282
55	22	2003-12-18	158
56	23	2003-12-29	264
57	23	2003-12-30	294
58	23	2003-12-31	124
59	24	2004-01-17	275
60	24	2004-01-18	213
61	25	2004-01-29	241
62	25	2004-01-30	200
63	25	2004-01-31	286
64	26	2004-02-14	201
65	26	2004-02-15	136
66	26	2004-02-16	181
67	27	2004-02-27	264
68	27	2004-02-28	188
69	28	2004-03-18	179
70	28	2004-03-19	219
71	29	2004-03-28	104
72	29	2004-03-29	204
73	30	2004-04-13	267
74	30	2004-04-14	207
75	30	2004-04-15	197
76	31	2004-04-29	245
77	31	2004-04-30	207
78	31	2004-05-01	273
79	32	2004-05-12	133
80	32	2004-05-13	276
81	33	2004-05-29	249
82	33	2004-05-30	111
83	33	2004-05-31	202
84	34	2004-06-10	252
85	34	2004-06-11	240
86	35	2004-06-29	288
87	35	2004-06-30	201
88	35	2004-07-01	275
89	36	2004-07-17	186
90	36	2004-07-18	157
91	37	2004-07-30	294
92	37	2004-07-31	250
93	37	2004-08-01	200
94	38	2004-08-18	103
95	38	2004-08-19	185
96	39	2004-09-02	170
97	39	2004-09-03	215
98	40	2004-09-22	147
99	40	2004-09-23	119
100	41	2004-10-03	249
101	41	2004-10-04	288
102	42	2004-10-23	196
103	42	2004-10-24	239
104	43	2004-11-08	154
105	43	2004-11-09	118
106	44	2004-11-19	212
107	44	2004-11-20	299
108	44	2004-11-21	139
109	45	2004-11-30	292
110	45	2004-12-01	233
111	45	2004-12-02	287
112	46	2004-12-14	137
113	46	2004-12-15	271
114	47	2004-12-28	191
115	47	2004-12-29	100
116	48	2005-01-11	222
117	48	2005-01-12	239
118	48	2005-01-13	165
119	49	2005-01-25	194
120	49	2005-01-26	159
121	49	2005-01-27	108
122	50	2005-02-06	224
123	50	2005-02-07	124
124	51	2005-02-21	105
125	51	2005-02-22	141
126	52	2005-03-07	111
127	52	2005-03-08	214
128	52	2005-03-09	147
129	53	2005-03-22	169
130	53	2005-03-23	224
131	53	2005-03-24	280
132	54	2005-04-05	183
133	54	2005-04-06	165
134	55	2005-04-24	139
135	55	2005-04-25	151
136	55	2005-04-26	204
137	56	2005-05-11	225
138	56	2005-05-12	116
139	57	2005-05-25	242
140	57	2005-05-26	134
141	57	2005-05-27	261
142	58	2005-06-10	210
143	58	2005-06-11	261
144	59	2005-06-30	225
145	59	2005-07-01	179
146	60	2005-07-11	247
147	60	2005-07-12	191
148	61	2005-07-26	144
149	61	2005-07-27	190
150	61	2005-07-28	146
151	62	2005-08-05	291
152	62	2005-08-06	156
153	63	2005-08-16	254
154	63	2005-08-17	237
155	64	2005-08-31	249
156	64	2005-09-01	128
157	65	2005-09-19	194
158	65	2005-09-20	155
159	65	2005-09-21	181
160	66	2005-10-05	115
161	66	2005-10-06	248
162	67	2005-10-15	109
163	67	2005-10-16	156
164	67	2005-10-17	197
165	68	2005-10-28	196
166	68	2005-10-29	192
167	69	2005-11-17	104
168	69	2005-11-18	274
169	69	2005-11-19	150
170	70	2005-12-03	151
171	70	2005-12-04	211
172	70	2005-12-05	231
173	71	2005-12-19	253
174	71	2005-12-20	184
175	72	2005-12-29	104
176	72	2005-12-30	247
177	72	2005-12-31	287
178	73	2006-01-17	175
179	73	2006-01-18	220
180	73	2006-01-19	101
\.


--
-- Data for Name: conferences; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY conferences (conferenceid, name, discountforstudents, description) FROM stdin;
0	Error deleniti vel.	10	Unde commodi laudantium quisquam quas atque recusandae debitis dolores.
1	Nihil voluptates cumque nobis.	29	Exercitationem itaque perferendis atque quam facere cumque nulla quasi quia atque debitis.
2	Labore odio porro.	36	Provident debitis enim est ad asperiores praesentium.
3	Eligendi quia atque perspiciatis.	38	Debitis modi impedit doloremque sint quae.
4	Temporibus rerum necessitatibus.	1	Reprehenderit temporibus numquam vitae et et praesentium reiciendis.
5	Nesciunt sunt.	48	Minus eos exercitationem sed quia amet consequuntur culpa.
6	Delectus a nisi.	49	Cumque quibusdam neque sequi iste dolorem doloribus laboriosam dignissimos.
7	Illum non repudiandae.	45	Dolor odio tenetur mollitia aperiam dolorum tempore totam.
8	Voluptatum atque quisquam.	44	Earum sequi maxime consequuntur quisquam totam ipsa labore maxime culpa.
9	Consectetur.	45	Vero fugit vero id qui sapiente laborum neque id ab explicabo eligendi odio.
10	Illum quas vel.	52	Odit delectus perspiciatis sit omnis voluptates doloremque alias totam facilis deserunt laboriosam.
11	Inventore libero.	84	Nihil aspernatur ipsam non sed similique nisi.
12	Distinctio cupiditate.	43	Sapiente perferendis minus fuga eius quia voluptas.
13	Distinctio sit.	84	Maxime voluptas reiciendis ab explicabo temporibus ab labore placeat hic voluptas.
14	Exercitationem labore.	4	Adipisci reiciendis suscipit impedit hic atque eius consequatur quos sunt voluptate error laboriosam.
15	Cupiditate.	90	Neque vel numquam similique quasi placeat voluptate explicabo dolores.
16	Dicta.	86	Asperiores quasi explicabo nobis occaecati quia eius.
17	Impedit ut.	66	Excepturi id impedit eius nostrum maiores enim.
18	Quae asperiores.	72	Veniam reiciendis vitae ut officiis molestias ullam at.
19	Ad explicabo.	40	Repellendus eligendi excepturi libero suscipit animi esse vitae fugit omnis facilis.
20	Dolores debitis.	23	Eum inventore sint quas ea nulla magnam fugit.
21	Nostrum consequuntur optio.	53	Culpa magni iusto rem quo nostrum eius minus et in a.
22	Voluptatibus sapiente pariatur.	80	Sit laborum alias cupiditate tenetur nulla eos rerum.
23	Repellendus autem.	59	Adipisci quia similique animi corrupti fugiat tempore quis delectus repellat quod aliquam.
24	Distinctio fugit.	61	Exercitationem consequatur debitis expedita iure maxime ex perferendis id.
25	Dolore aliquid.	32	Voluptate excepturi neque porro aut corporis sit.
26	Expedita ex voluptates.	29	Harum maiores commodi doloribus distinctio dolorem.
27	Hic suscipit culpa.	44	Expedita a amet optio libero nobis deleniti accusamus voluptatibus tempore enim dolorem provident.
28	Magni aut fugiat.	15	Provident voluptatibus voluptates ad ab dolore.
29	Ea aperiam.	16	Id eum doloremque delectus nulla non ipsam minima at.
30	Consequatur numquam.	69	Quos modi totam libero fugiat voluptates ipsam.
31	Deserunt nesciunt enim.	1	Reiciendis ea ipsum eligendi explicabo voluptates et delectus rem.
32	Deleniti fuga dignissimos.	56	Totam assumenda velit officiis non odio dolorum dignissimos similique magni cupiditate ipsum explicabo.
33	Veniam aliquam nobis.	65	Possimus tempore hic alias suscipit reiciendis consectetur error nemo.
34	Quia maxime odio.	64	Totam quasi earum eos officiis commodi.
35	Excepturi dolorum maiores.	33	Accusamus dolor sunt et sunt hic ullam quasi.
36	Possimus voluptatum repudiandae mollitia.	58	Dignissimos quia quidem esse ducimus asperiores aspernatur necessitatibus dolore.
37	Repellendus nihil consequuntur assumenda.	28	Distinctio eos aut voluptatem animi officiis.
38	Earum nobis maiores.	52	Officia exercitationem sint ab voluptas explicabo fugiat nisi voluptatem ipsa distinctio.
39	Eveniet minima.	19	Autem eos sapiente magnam itaque qui beatae modi.
40	Possimus eveniet autem.	59	Dolores soluta molestiae voluptas ducimus voluptatum consequuntur laudantium nulla saepe.
41	Dolores repudiandae.	42	Minima incidunt consequuntur porro cum fugit a consectetur adipisci porro quam quas.
42	Cumque sint odio maiores.	71	Minus optio culpa modi repudiandae labore ducimus.
43	Laborum.	65	Facilis dignissimos maiores assumenda ipsam voluptate similique tempore corrupti nihil repudiandae quos.
44	Rem porro inventore.	90	Alias aspernatur doloremque voluptatibus sequi occaecati eum iure mollitia dolores.
45	Repudiandae cupiditate.	83	Blanditiis soluta animi ad atque doloremque ullam eligendi reprehenderit error.
46	Eius iste ipsam.	28	Nihil error expedita nostrum corrupti at perferendis cumque earum.
47	Similique voluptates.	63	Nam iusto quidem cupiditate suscipit dolorem.
48	Necessitatibus delectus.	74	Earum sint tenetur neque minima culpa voluptatem ex atque.
49	Quo voluptate possimus.	51	Quod asperiores cum facere occaecati quo sunt quaerat laborum quos culpa.
50	Error perspiciatis temporibus.	6	Corrupti voluptatibus harum recusandae libero iusto.
51	Magni iste voluptatum.	83	Error ad porro distinctio error minima perspiciatis at nihil.
52	Doloribus quibusdam saepe.	45	Praesentium non unde voluptatem similique quos eum quibusdam odio soluta.
53	Ipsum ratione ipsam.	70	Voluptatum at dolor molestias quis cum officiis.
54	Ex eveniet.	49	Nulla maxime inventore excepturi nesciunt tempore natus voluptatibus vitae voluptates enim alias.
55	Dolorum.	59	Iste voluptatem odit reprehenderit laborum sapiente provident velit ratione culpa numquam nam eius.
56	Nemo aspernatur.	26	Quae fugit rem recusandae expedita rerum magnam ullam iste autem corrupti quam rerum.
57	Minima laboriosam.	7	Corrupti quae tempore qui distinctio animi quaerat qui.
58	Aperiam libero similique.	33	Autem voluptatibus eum animi nobis dolorem.
59	Praesentium explicabo.	18	Nesciunt qui amet unde adipisci quasi consectetur deleniti necessitatibus autem fugiat.
60	Nulla et ipsum.	10	Sed perspiciatis accusamus aperiam amet sint esse saepe.
61	Ea ipsum.	90	Ducimus reiciendis impedit corrupti minima veniam ducimus animi.
62	Molestias facilis.	59	Quisquam nesciunt quia minima debitis cupiditate quo iure et ullam.
63	Sit amet reprehenderit.	72	Ducimus magnam cum adipisci exercitationem nisi nulla ratione.
64	Hic fugiat.	31	Et voluptatem architecto eos nulla unde aliquid voluptatum quam veritatis.
65	Ab est architecto quae.	30	Culpa nam esse esse eligendi temporibus quaerat fuga fugiat minima itaque placeat dolorem.
66	Laborum.	88	Dicta vitae cupiditate id velit esse incidunt possimus dolores eligendi odio iure veniam.
67	Explicabo corporis cupiditate.	84	Dolore et soluta illum ipsa debitis optio soluta mollitia dolore ratione.
68	Amet vitae similique vitae.	6	Velit hic corrupti iusto quisquam distinctio ipsa ex aliquid similique.
69	Tenetur similique.	6	Similique totam enim doloremque laudantium earum voluptatibus dolor natus facilis dignissimos.
70	Itaque.	22	Debitis atque voluptatem illo unde velit voluptas eos suscipit accusantium.
71	Nam suscipit adipisci.	78	At natus doloribus incidunt maxime repellendus nulla excepturi sunt tempora.
72	Reprehenderit eveniet dolorum corporis.	3	Reprehenderit unde odio officia doloribus aut esse eaque natus soluta.
73	Itaque eum.	89	Atque laboriosam nemo iure repellendus eius nihil hic.
\.


--
-- Data for Name: dayparticipants; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY dayparticipants (dayparticipantid, conferencedaybook_conferencedaybookid, participants_participantid, studentid) FROM stdin;
0	0	1	\N
1	0	2	\N
2	79	1	\N
3	142	1	\N
4	79	3	531080
5	79	5	357187
6	79	6	619781
7	1	7	\N
8	1	8	\N
9	1	9	\N
10	80	7	\N
11	143	8	\N
12	143	9	\N
13	143	10	\N
14	143	12	\N
15	143	13	\N
16	1	14	770260
17	80	14	872056
18	80	15	710506
19	80	16	728160
20	80	17	368525
21	81	18	\N
22	81	19	842314
23	81	20	440352
24	144	19	208280
25	144	21	143089
26	144	22	930906
27	2	23	\N
28	82	24	\N
29	82	25	\N
30	145	23	\N
31	145	27	518384
32	146	29	\N
33	83	30	611150
34	3	32	\N
35	3	33	\N
36	3	34	\N
37	84	35	454846
38	84	37	611754
39	84	38	958288
40	84	40	475242
41	147	36	823427
42	147	37	175982
43	147	38	464638
44	4	41	\N
45	4	42	\N
46	148	41	\N
47	4	43	208964
48	85	44	\N
49	85	45	\N
50	85	47	\N
51	85	49	\N
52	85	51	381927
53	149	50	317653
54	5	52	\N
55	86	52	\N
56	86	53	\N
57	5	54	583100
58	5	55	241804
59	5	56	684466
60	5	58	231068
61	86	55	428709
62	86	56	268564
63	86	57	504466
64	150	54	131594
65	150	55	142343
66	150	56	823833
67	150	57	665845
68	6	59	\N
69	6	61	\N
70	151	59	\N
71	151	60	\N
72	151	62	\N
73	6	64	432544
74	6	65	486421
75	87	64	192459
76	87	65	446131
77	151	64	392004
78	151	66	834056
79	7	68	\N
80	152	67	\N
81	152	68	\N
82	7	69	909600
83	88	69	744309
84	88	70	757637
85	8	71	\N
86	89	71	\N
87	89	72	\N
88	153	72	\N
89	8	73	510673
90	8	74	986332
91	8	75	307879
92	90	76	\N
93	90	77	\N
94	9	78	577510
95	9	79	358758
96	9	80	477452
97	9	81	469197
98	9	82	156359
99	154	79	377440
100	154	80	937280
101	154	82	388861
102	154	84	902186
103	154	86	898976
104	91	87	\N
105	91	89	\N
106	91	91	\N
107	91	92	\N
108	10	94	939448
109	92	95	\N
110	92	96	\N
111	155	95	\N
112	155	97	\N
113	155	98	\N
114	155	99	\N
115	92	100	453439
116	92	101	976460
117	155	100	809652
118	11	102	\N
119	11	103	\N
120	11	104	725845
121	11	106	944871
122	11	107	927454
123	93	104	610225
124	12	108	\N
125	94	109	350930
126	94	110	909900
127	94	111	304312
128	94	112	671591
129	156	109	465492
130	156	110	115541
131	156	111	219820
132	156	112	476969
133	156	113	945753
134	13	115	\N
135	13	116	\N
136	95	115	\N
137	157	115	\N
138	95	117	155810
139	95	118	829697
140	95	119	679684
141	157	117	730714
142	157	119	751764
143	158	120	\N
144	158	121	841093
145	158	122	389682
146	158	123	845651
147	14	125	\N
148	14	126	\N
149	14	127	\N
150	14	128	\N
151	96	125	\N
152	96	126	\N
153	159	124	\N
154	159	125	\N
155	159	126	\N
156	159	128	\N
157	14	129	285289
158	96	129	170673
159	159	129	278731
160	160	131	\N
161	160	132	\N
162	160	133	\N
163	97	134	537294
164	97	135	189636
165	97	136	269537
166	160	134	434248
167	160	136	990029
168	15	138	\N
169	161	138	\N
170	161	139	\N
171	161	140	\N
172	98	141	667333
173	98	143	850375
174	161	142	428311
175	99	144	\N
176	162	144	\N
177	99	145	197840
178	163	146	\N
179	163	147	\N
180	163	149	\N
181	163	151	\N
182	163	152	644836
183	16	154	\N
184	100	155	902161
185	17	156	\N
186	101	157	\N
187	101	158	\N
188	164	156	\N
189	164	158	\N
190	164	159	\N
191	17	160	660222
192	17	162	317763
193	101	161	904291
194	101	163	732912
195	164	160	675003
196	18	164	\N
197	102	165	\N
198	102	166	\N
199	165	165	\N
200	165	166	\N
201	165	167	\N
202	18	168	377412
203	18	169	993237
204	102	168	733589
205	165	169	776729
206	103	171	\N
207	103	173	\N
208	103	174	\N
209	103	175	\N
210	166	171	\N
211	104	176	\N
212	104	178	\N
213	19	179	935577
214	19	181	159303
215	19	182	198979
216	19	183	186764
217	19	184	606157
218	104	179	623871
219	104	181	649322
220	167	179	659867
221	167	180	969550
222	167	181	395688
223	167	182	627606
224	167	183	832914
225	20	186	\N
226	20	187	\N
227	105	186	\N
228	105	188	\N
229	168	185	\N
230	168	187	\N
231	20	189	778586
232	20	190	369016
233	105	189	640732
234	21	191	\N
235	21	192	\N
236	106	191	\N
237	169	191	\N
238	169	193	\N
239	169	194	\N
240	106	195	854848
241	106	196	878172
242	106	197	574485
243	106	199	104861
244	22	200	\N
245	107	200	\N
246	107	202	\N
247	170	200	\N
248	22	203	662348
249	22	204	646708
250	22	205	719629
251	22	207	232319
252	170	203	156856
253	170	204	639496
254	170	205	710773
255	170	206	754882
256	171	208	\N
257	23	209	210571
258	23	210	582914
259	23	211	518313
260	108	209	363030
261	171	209	542358
262	171	210	846120
263	171	212	615549
264	171	214	269238
265	24	215	\N
266	24	216	\N
267	24	218	\N
268	24	219	\N
269	24	220	\N
270	109	216	\N
271	172	215	\N
272	172	221	340229
273	172	222	921606
274	172	223	908667
275	25	224	\N
276	25	225	\N
277	25	226	\N
278	173	225	\N
279	173	226	\N
280	173	227	\N
281	26	228	\N
282	26	229	\N
283	110	228	\N
284	174	228	\N
285	174	229	\N
286	26	230	491381
287	26	231	362412
288	110	230	548206
289	110	231	575244
290	27	233	\N
291	27	234	\N
292	27	236	\N
293	27	237	\N
294	27	238	\N
295	111	232	\N
296	175	232	\N
297	175	239	960528
298	175	240	106198
299	175	241	368078
300	28	243	718693
301	112	242	964481
302	112	243	838228
303	112	244	898667
304	113	245	\N
305	113	246	\N
306	176	245	\N
307	176	247	748511
308	176	248	877657
309	176	249	445619
310	114	250	\N
311	114	252	\N
312	114	253	\N
313	177	250	\N
314	177	251	\N
315	177	252	\N
316	29	255	732607
317	177	254	790080
318	177	256	777222
319	30	257	\N
320	30	259	\N
321	30	261	\N
322	178	257	\N
323	178	259	\N
324	30	262	439339
325	115	263	309600
326	115	264	149207
327	31	265	103868
328	179	265	387466
329	32	266	\N
330	32	267	\N
331	32	268	929781
332	32	269	577724
333	32	270	905998
334	116	268	322431
335	180	268	466326
336	180	269	871261
337	33	271	\N
338	33	273	\N
339	33	275	\N
340	117	271	\N
341	181	271	\N
342	181	272	\N
343	117	276	745688
344	117	277	959371
345	181	276	434468
346	181	278	565331
347	34	279	\N
348	34	280	\N
349	118	280	\N
350	35	282	\N
351	119	281	\N
352	119	282	\N
353	119	283	\N
354	182	282	\N
355	182	283	\N
356	182	285	\N
357	35	286	996992
358	35	287	809623
359	35	289	198693
360	182	286	331943
361	182	287	402650
362	120	290	\N
363	120	291	\N
364	120	292	\N
365	120	293	\N
366	183	290	\N
367	183	295	805769
368	121	297	\N
369	121	298	\N
370	184	299	\N
371	36	301	352799
372	36	302	461729
373	36	303	741817
374	122	300	156881
375	122	301	900561
376	184	300	134650
377	184	301	696535
378	37	304	644361
379	123	304	727437
380	123	305	243550
381	123	307	170946
382	38	308	\N
383	124	309	\N
384	38	310	449485
385	38	311	476610
386	38	312	591439
387	39	313	\N
388	39	314	\N
389	39	316	\N
390	39	317	\N
391	125	318	612891
392	40	320	\N
393	40	322	\N
394	40	323	\N
395	185	319	\N
396	185	320	\N
397	40	324	344905
398	126	325	731691
399	126	326	433013
400	126	327	494920
401	126	328	979437
402	126	329	375836
403	127	330	\N
404	186	330	\N
405	186	331	701259
406	186	332	191768
407	186	333	451579
408	186	334	163946
409	41	335	\N
410	41	337	\N
411	41	338	\N
412	187	335	\N
413	187	336	\N
414	41	339	490783
415	42	340	\N
416	42	341	\N
417	42	343	\N
418	42	345	\N
419	128	341	\N
420	42	346	715716
421	188	347	797266
422	188	348	907517
423	188	349	148271
424	43	351	\N
425	43	352	\N
426	189	350	\N
427	189	351	\N
428	189	352	\N
429	43	353	156132
430	43	355	396550
431	44	356	\N
432	129	357	\N
433	129	358	\N
434	129	359	\N
435	129	360	\N
436	45	361	318830
437	45	363	228774
438	190	361	190615
439	130	365	\N
440	130	366	\N
441	130	367	\N
442	130	368	\N
443	130	369	\N
444	191	365	\N
445	191	367	\N
446	191	370	526055
447	191	372	349216
448	131	373	\N
449	131	374	\N
450	192	375	779213
451	192	376	696576
452	46	377	\N
453	193	377	\N
454	193	379	\N
455	46	380	602592
456	193	381	616607
457	47	382	\N
458	47	383	\N
459	47	384	970642
460	47	385	388804
461	47	386	919141
462	48	387	\N
463	194	387	\N
464	48	388	500865
465	48	389	722156
466	48	391	245972
467	132	388	687737
468	132	389	637133
469	194	389	209807
470	195	392	\N
471	49	393	130129
472	49	394	755037
473	195	393	211640
474	50	395	\N
475	133	396	\N
476	133	397	\N
477	50	399	278098
478	50	400	568605
479	50	401	660746
480	50	402	395491
481	51	403	\N
482	196	403	\N
483	196	404	\N
484	196	405	\N
485	51	406	355291
486	51	408	715898
487	51	409	851785
488	51	410	138256
489	134	407	768856
490	196	406	579398
491	197	412	\N
492	52	414	467381
493	135	414	385338
494	135	415	199875
495	197	414	601634
496	53	416	\N
497	53	417	\N
498	136	416	\N
499	198	417	\N
500	53	419	610209
501	53	420	823640
502	136	418	869853
503	198	419	772136
504	198	420	401174
505	54	421	\N
506	199	421	\N
507	54	423	178785
508	55	424	\N
509	55	425	\N
510	55	426	\N
511	55	427	\N
512	55	428	\N
513	137	424	\N
514	137	425	\N
515	137	430	614021
516	200	429	251782
517	56	431	\N
518	56	432	\N
519	56	433	\N
520	138	431	\N
521	138	435	360374
522	138	437	507961
523	138	438	838098
524	138	440	573878
525	57	441	\N
526	57	443	\N
527	201	442	\N
528	201	443	\N
529	201	444	\N
530	201	445	\N
531	201	446	\N
532	57	447	700548
533	57	448	599508
534	57	449	961929
535	58	450	\N
536	58	451	130865
537	202	451	533140
538	202	452	256820
539	202	454	579174
540	202	455	313045
541	202	457	676461
542	59	458	\N
543	59	459	\N
544	139	458	\N
545	203	459	\N
546	203	460	\N
547	203	461	\N
548	59	462	968833
549	59	463	250187
550	204	464	\N
551	60	466	449467
552	60	467	124514
553	140	465	444160
554	141	468	\N
555	61	469	681363
556	61	471	672859
557	62	472	\N
558	62	473	\N
559	62	475	\N
560	205	472	\N
561	205	473	\N
562	205	474	\N
563	205	475	\N
564	205	476	278961
565	206	477	729727
566	206	479	101809
567	206	480	151315
568	206	481	314078
569	207	482	\N
570	207	484	250242
571	207	485	596022
572	207	486	299234
573	63	487	\N
574	63	488	\N
575	208	487	\N
576	208	489	\N
577	208	490	\N
578	63	491	897210
579	63	493	705831
580	209	494	\N
581	209	495	588302
582	209	496	386708
583	209	498	734992
584	209	499	291583
585	64	500	\N
586	64	502	\N
587	64	503	\N
588	210	500	\N
589	210	501	\N
590	65	504	\N
591	211	505	\N
592	211	506	485641
593	66	508	\N
594	66	510	\N
595	66	512	495440
596	66	513	642581
597	212	514	\N
598	212	515	\N
599	212	516	942978
600	67	517	\N
601	67	518	\N
602	67	519	\N
603	67	520	\N
604	213	517	\N
605	213	518	\N
606	213	521	785925
607	213	522	875943
608	68	523	\N
609	214	524	726662
610	214	525	696899
611	215	526	\N
612	215	527	\N
613	69	529	198046
614	69	530	530417
615	69	532	335486
616	69	533	711362
617	69	534	587053
618	215	529	896280
619	70	535	489114
620	216	537	\N
621	216	538	\N
622	216	539	\N
623	71	541	726474
624	217	540	330894
625	217	542	424827
626	72	544	\N
627	218	543	\N
628	218	546	391549
629	218	548	548591
630	73	549	\N
631	73	551	514624
632	74	552	969153
633	74	553	619057
634	75	554	\N
635	75	555	\N
636	76	557	755765
637	76	558	998342
638	77	560	914940
639	77	561	414986
640	77	563	671831
641	77	565	475258
642	78	567	662925
643	78	568	221327
644	78	569	380163
645	78	570	229548
646	78	571	372958
647	303	572	\N
648	219	573	469931
649	219	575	398948
650	219	576	513698
651	303	573	443729
652	303	574	604066
653	304	577	\N
654	304	578	\N
655	305	580	134778
656	305	581	238363
657	220	583	\N
658	220	584	\N
659	306	582	\N
660	306	584	\N
661	306	585	890050
662	306	586	631069
663	306	587	766718
664	221	589	\N
665	221	590	\N
666	221	591	\N
667	307	589	\N
668	221	592	393336
669	221	593	375155
670	222	594	\N
671	222	596	\N
672	308	594	\N
673	308	596	\N
674	308	597	\N
675	308	599	\N
676	308	601	\N
677	222	602	749979
678	222	603	785767
679	222	604	437157
680	309	605	\N
681	309	606	\N
682	310	608	\N
683	310	609	\N
684	310	610	146715
685	310	611	994859
686	310	612	215568
687	223	613	\N
688	223	615	\N
689	223	616	\N
690	224	618	347490
691	224	620	382071
692	311	617	831515
693	312	621	\N
694	312	623	\N
695	312	624	\N
696	225	625	396701
697	226	626	\N
698	226	627	\N
699	226	628	\N
700	226	629	721886
701	226	630	143730
702	227	631	\N
703	313	631	\N
704	228	633	\N
705	228	634	\N
706	228	635	\N
707	314	632	\N
708	314	634	\N
709	314	636	\N
710	228	638	609201
711	228	639	693935
712	314	637	155667
713	315	640	\N
714	315	642	154752
715	315	643	299200
716	315	644	507132
717	229	645	245580
718	316	645	916431
719	230	647	\N
720	317	647	\N
721	317	648	\N
722	317	649	\N
723	317	651	\N
724	317	652	594321
725	231	654	\N
726	231	655	\N
727	231	657	\N
728	231	658	\N
729	318	653	\N
730	318	659	686451
731	232	661	\N
732	319	662	268061
733	319	663	223425
734	319	664	393873
735	319	666	784099
736	233	667	\N
737	320	667	\N
738	320	668	\N
739	233	669	666330
740	233	670	569112
741	320	669	955421
742	321	672	\N
743	234	673	717778
744	234	674	892370
745	321	673	653958
746	321	674	254218
747	321	675	564530
748	321	676	577276
749	235	677	\N
750	235	678	\N
751	322	677	\N
752	322	678	\N
753	322	679	\N
754	322	681	902016
755	322	683	969436
756	236	684	\N
757	323	685	161755
758	323	686	291475
759	324	687	\N
760	237	688	988104
761	237	690	296677
762	237	691	607876
763	237	692	994035
764	237	693	165571
765	238	695	\N
766	325	694	\N
767	325	696	\N
768	325	697	\N
769	326	698	\N
770	326	699	\N
771	326	700	\N
772	326	701	\N
773	326	702	\N
774	239	703	\N
775	239	704	408246
776	239	705	628609
777	239	707	417014
778	239	708	311978
779	240	710	\N
780	240	711	250015
781	327	712	\N
782	327	713	\N
783	327	714	\N
784	241	715	384544
785	241	717	146293
786	241	718	537258
787	241	719	189829
788	241	720	212548
789	242	722	\N
790	328	721	\N
791	328	722	\N
792	328	723	\N
793	242	724	311016
794	242	725	332212
795	329	726	\N
796	329	727	\N
797	329	728	726479
798	329	729	635877
799	330	730	\N
800	330	732	\N
801	243	733	204649
802	243	735	971269
803	243	737	195808
804	330	734	734757
805	331	738	\N
806	331	740	\N
807	331	741	483711
808	331	743	865370
809	244	745	\N
810	245	746	\N
811	245	747	\N
812	245	748	\N
813	332	746	\N
814	332	748	\N
815	332	749	\N
816	332	750	263833
817	332	752	695352
818	246	754	\N
819	246	755	694716
820	246	756	261127
821	246	757	636287
822	333	759	\N
823	333	760	\N
824	333	761	\N
825	333	762	\N
826	247	763	522358
827	247	764	252050
828	333	763	910601
829	248	765	\N
830	248	766	\N
831	248	768	\N
832	248	769	\N
833	248	770	\N
834	334	766	\N
835	334	767	\N
836	334	768	\N
837	334	772	213585
838	249	773	\N
839	335	773	\N
840	335	775	\N
841	335	776	\N
842	249	777	948848
843	249	778	465614
844	249	779	869450
845	335	778	966547
846	335	779	343536
847	250	781	298898
848	251	782	\N
849	251	783	\N
850	251	784	\N
851	336	782	\N
852	251	785	323909
853	252	786	\N
854	337	787	107087
855	338	788	599889
856	338	789	237420
857	338	790	192773
858	253	791	\N
859	253	792	\N
860	339	791	\N
861	339	794	869900
862	254	795	\N
863	254	796	\N
864	254	797	\N
865	254	799	682978
866	340	798	558974
867	340	799	452984
868	340	800	760664
869	340	802	882246
870	341	803	\N
871	341	804	\N
872	255	805	296182
873	256	806	\N
874	342	808	646246
875	342	809	473766
876	257	810	\N
877	257	811	883135
878	343	811	676319
879	344	812	\N
880	344	814	\N
881	344	815	294681
882	258	816	\N
883	345	817	\N
884	258	818	575057
885	258	820	666605
886	345	818	498753
887	345	820	906025
888	345	821	466851
889	259	822	\N
890	346	822	\N
891	346	823	\N
892	346	825	\N
893	346	826	\N
894	259	827	778174
895	259	829	739058
896	259	831	599970
897	259	832	435527
898	260	833	\N
899	347	834	\N
900	347	835	\N
901	347	837	\N
902	347	838	\N
903	260	839	475600
904	260	841	216027
905	260	842	550344
906	261	843	\N
907	261	844	\N
908	261	845	718541
909	261	846	945410
910	348	845	166302
911	348	846	308862
912	348	847	831339
913	349	848	\N
914	350	849	\N
915	262	851	116491
916	262	852	982069
917	262	853	958427
918	262	854	182549
919	262	855	831706
920	350	851	262280
921	350	853	311653
922	350	855	628914
923	350	856	187816
924	351	858	\N
925	351	859	634445
926	263	860	\N
927	263	862	\N
928	263	863	615648
929	263	865	443347
930	263	866	247840
931	264	868	\N
932	264	869	\N
933	265	870	\N
934	265	872	\N
935	265	873	515290
936	352	873	627819
937	352	874	308858
938	352	875	905461
939	353	876	\N
940	353	878	\N
941	353	880	\N
942	353	881	\N
943	266	882	768445
944	353	882	214042
945	354	884	\N
946	354	885	\N
947	267	886	508178
948	267	887	895907
949	267	888	439023
950	267	890	324652
951	267	891	716749
952	354	887	487591
953	354	888	991799
954	354	889	215429
955	268	892	\N
956	268	893	\N
957	268	895	\N
958	269	896	\N
959	269	897	\N
960	269	898	\N
961	269	899	\N
962	269	900	575997
963	355	900	856667
964	356	901	\N
965	356	902	\N
966	270	903	799599
967	270	904	187485
968	356	903	419718
969	356	904	624034
970	271	906	\N
971	271	907	\N
972	357	905	\N
973	357	906	\N
974	272	909	258768
975	273	910	\N
976	358	912	370179
977	358	913	378057
978	358	914	894374
979	274	915	951875
980	274	916	517352
981	274	918	939553
982	359	919	\N
983	275	920	564040
984	275	921	636868
985	275	923	552874
986	359	920	736790
987	276	924	\N
988	276	926	\N
989	360	924	\N
990	360	925	\N
991	360	926	\N
992	276	928	976969
993	276	929	324669
994	276	930	278594
995	360	927	946820
996	360	928	188352
997	361	931	\N
998	361	932	\N
999	361	933	\N
1000	361	934	\N
1001	361	935	\N
1002	277	936	\N
1003	277	937	\N
1004	277	938	\N
1005	362	936	\N
1006	277	939	522833
1007	362	939	326532
1008	362	940	751597
1009	362	941	126087
1010	362	943	184505
1011	278	944	767577
1012	278	945	667513
1013	278	947	697422
1014	363	944	762789
1015	363	945	387802
1016	363	946	263833
1017	363	948	659847
1018	279	950	\N
1019	279	951	\N
1020	279	953	\N
1021	279	954	\N
1022	279	955	\N
1023	364	956	304236
1024	364	957	689623
1025	364	959	732688
1026	364	960	855050
1027	364	961	418755
1028	280	962	\N
1029	280	963	\N
1030	280	964	579458
1031	280	965	816298
1032	280	966	419364
1033	365	964	566856
1034	281	968	\N
1035	366	967	\N
1036	366	969	\N
1037	281	970	535478
1038	281	971	547570
1039	281	972	637589
1040	366	970	961558
1041	366	971	310027
1042	282	973	\N
1043	282	975	\N
1044	367	973	\N
1045	367	974	\N
1046	282	976	256064
1047	283	977	981706
1048	284	979	\N
1049	285	980	767887
1050	285	981	999262
1051	286	982	\N
1052	286	983	\N
1053	286	984	\N
1054	287	985	123312
1055	287	986	244641
1056	287	987	765254
1057	287	988	395946
1058	288	989	489833
1059	288	990	657765
1060	288	991	999058
1061	289	992	334401
1062	289	993	159158
1063	289	994	555504
1064	289	995	446535
1065	290	996	\N
1066	291	997	686825
1067	292	998	\N
1068	292	999	808451
1069	292	1000	863538
1070	293	1001	\N
1071	293	1002	\N
1072	294	1003	\N
1073	294	1005	\N
1074	294	1006	242663
1075	295	1008	\N
1076	295	1009	\N
1077	295	1011	\N
1078	296	1013	\N
1079	296	1014	\N
1080	296	1015	\N
1081	297	1016	434757
1082	298	1017	\N
1083	298	1019	696937
1084	299	1021	376540
1085	300	1022	557027
1086	301	1023	\N
1087	301	1024	\N
1088	301	1025	984318
1089	301	1027	153101
1090	301	1028	947013
1091	302	1029	754927
1092	368	1031	\N
1093	368	1032	\N
1094	368	1033	\N
1095	400	1030	\N
1096	400	1031	\N
1097	400	1034	902017
1098	401	1035	\N
1099	401	1037	198162
1100	401	1038	264577
1101	402	1039	\N
1102	402	1041	\N
1103	369	1043	687543
1104	369	1044	432254
1105	369	1046	266452
1106	369	1047	988387
1107	402	1042	923149
1108	402	1043	679314
1109	403	1048	\N
1110	370	1049	\N
1111	370	1050	\N
1112	370	1051	\N
1113	370	1052	\N
1114	370	1053	\N
1115	404	1049	\N
1116	404	1050	\N
1117	371	1055	\N
1118	371	1056	\N
1119	371	1057	\N
1120	371	1058	640971
1121	405	1059	640726
1122	405	1060	207102
1123	405	1062	808881
1124	405	1063	129716
1125	405	1064	470530
1126	372	1065	\N
1127	372	1066	\N
1128	372	1067	\N
1129	406	1065	\N
1130	406	1066	\N
1131	406	1068	\N
1132	406	1069	501450
1133	407	1070	\N
1134	407	1071	\N
1135	407	1072	\N
1136	407	1073	\N
1137	407	1074	\N
1138	373	1075	716214
1139	373	1077	100527
1140	373	1078	610927
1141	373	1079	492714
1142	373	1080	225453
1143	408	1081	330310
1144	408	1082	410803
1145	374	1083	\N
1146	374	1084	\N
1147	374	1085	\N
1148	409	1084	\N
1149	409	1085	\N
1150	409	1086	\N
1151	409	1087	\N
1152	409	1089	313943
1153	375	1090	\N
1154	375	1091	140897
1155	375	1092	234445
1156	375	1094	510288
1157	410	1091	931198
1158	410	1092	794164
1159	376	1095	\N
1160	376	1096	\N
1161	376	1097	\N
1162	376	1098	\N
1163	411	1095	\N
1164	376	1099	729519
1165	377	1100	\N
1166	377	1101	691526
1167	377	1102	396653
1168	377	1103	315180
1169	377	1104	886746
1170	412	1105	\N
1171	412	1106	\N
1172	412	1107	\N
1173	378	1108	746249
1174	378	1109	966805
1175	412	1108	344287
1176	379	1110	\N
1177	379	1111	\N
1178	379	1113	383746
1179	379	1114	426960
1180	379	1115	390277
1181	413	1116	\N
1182	380	1117	697204
1183	380	1119	240460
1184	413	1117	705502
1185	413	1119	143715
1186	413	1120	756370
1187	414	1121	\N
1188	414	1122	\N
1189	381	1123	\N
1190	381	1124	119708
1191	381	1125	455945
1192	382	1126	\N
1193	382	1128	\N
1194	382	1129	\N
1195	382	1131	\N
1196	382	1133	\N
1197	415	1127	\N
1198	415	1135	882375
1199	415	1136	445814
1200	415	1137	429763
1201	383	1138	\N
1202	416	1138	\N
1203	383	1139	609477
1204	383	1140	572779
1205	416	1139	269097
1206	417	1141	\N
1207	384	1142	279072
1208	384	1143	512256
1209	385	1144	\N
1210	385	1146	\N
1211	385	1147	356563
1212	385	1148	454717
1213	386	1149	\N
1214	386	1151	\N
1215	386	1152	\N
1216	418	1150	\N
1217	418	1153	150358
1218	419	1155	395604
1219	419	1156	273395
1220	419	1157	639871
1221	387	1159	\N
1222	387	1160	\N
1223	387	1161	164082
1224	420	1161	613177
1225	388	1162	\N
1226	388	1164	344651
1227	389	1166	122814
1228	389	1167	395996
1229	389	1168	719448
1230	421	1165	127025
1231	421	1166	745388
1232	390	1169	\N
1233	390	1171	\N
1234	390	1173	\N
1235	422	1174	376724
1236	422	1175	744958
1237	422	1176	298630
1238	391	1178	\N
1239	423	1177	\N
1240	423	1178	\N
1241	423	1180	\N
1242	423	1182	\N
1243	391	1183	497635
1244	391	1184	284904
1245	424	1185	\N
1246	424	1186	\N
1247	425	1187	857438
1248	392	1188	\N
1249	392	1189	\N
1250	426	1190	746750
1251	426	1191	635017
1252	426	1193	950577
1253	426	1195	352692
1254	393	1197	\N
1255	393	1198	\N
1256	393	1199	623876
1257	393	1201	202843
1258	427	1202	954622
1259	427	1203	568225
1260	427	1204	253420
1261	427	1205	927148
1262	427	1206	375935
1263	394	1207	760775
1264	394	1208	779305
1265	394	1210	523366
1266	394	1211	578455
1267	394	1212	706093
1268	395	1214	\N
1269	428	1214	\N
1270	395	1215	891074
1271	395	1216	414568
1272	396	1217	\N
1273	429	1217	\N
1274	429	1218	\N
1275	396	1219	765866
1276	396	1220	667078
1277	396	1221	545871
1278	429	1219	324158
1279	430	1222	\N
1280	430	1223	\N
1281	430	1224	\N
1282	430	1225	\N
1283	397	1227	\N
1284	397	1228	\N
1285	397	1229	\N
1286	397	1230	\N
1287	431	1226	\N
1288	431	1232	240754
1289	431	1233	652822
1290	432	1235	\N
1291	432	1236	\N
1292	432	1237	\N
1293	398	1238	806321
1294	398	1239	301039
1295	398	1240	972409
1296	432	1239	501832
1297	432	1241	809986
1298	399	1243	\N
1299	433	1242	\N
1300	399	1244	892564
1301	434	1246	\N
1302	434	1247	357110
1303	435	1249	\N
1304	435	1250	\N
1305	435	1251	\N
1306	436	1252	\N
1307	436	1253	224467
1308	436	1254	634931
1309	436	1255	396658
1310	436	1257	615395
1311	437	1258	\N
1312	437	1260	\N
1313	437	1261	\N
1314	438	1263	\N
1315	439	1264	\N
1316	439	1265	\N
1317	439	1267	\N
1318	439	1268	\N
1319	439	1269	104747
1320	440	1270	\N
1321	440	1271	389250
1322	441	1272	\N
1323	441	1273	\N
1324	441	1274	\N
1325	442	1275	\N
1326	442	1276	\N
1327	443	1278	530225
1328	444	1280	\N
1329	445	1281	\N
1330	445	1282	\N
1331	445	1283	317787
1332	445	1284	661533
1333	446	1286	\N
1334	446	1287	367738
1335	446	1288	558763
1336	447	1289	\N
1337	447	1291	\N
1338	447	1293	\N
1339	447	1294	\N
1340	448	1295	657430
1341	448	1296	589850
1342	448	1297	227524
1343	448	1299	539008
1344	449	1300	247735
1345	449	1301	420410
1346	449	1302	161488
1347	450	1304	\N
1348	450	1305	\N
1349	450	1306	\N
1350	450	1308	837288
1351	451	1309	\N
1352	451	1311	\N
1353	452	1312	\N
1354	453	1313	319025
1355	453	1315	271761
1356	454	1316	\N
1357	454	1317	\N
1358	455	1318	106419
1359	455	1319	224468
1360	455	1320	656575
1361	455	1321	449170
1362	455	1323	272381
1363	456	1325	\N
1364	456	1326	\N
1365	456	1327	545938
1366	456	1328	583627
1367	456	1329	798454
1368	457	1330	\N
1369	457	1331	111085
1370	457	1332	142364
1371	457	1333	933540
1372	457	1334	890169
1373	458	1335	\N
1374	458	1336	\N
1375	458	1338	\N
1376	459	1339	748381
1377	459	1341	429400
1378	459	1342	158179
1379	460	1343	\N
1380	460	1344	\N
1381	461	1346	581482
1382	461	1348	214081
1383	461	1349	753149
1384	462	1350	446522
1385	462	1351	384813
1386	463	1352	\N
1387	464	1354	\N
1388	464	1356	\N
1389	464	1358	686548
1390	464	1360	522726
1391	464	1362	524134
1392	465	1363	\N
1393	465	1364	\N
1394	465	1365	\N
1395	465	1366	\N
1396	466	1367	\N
1397	467	1369	\N
1398	467	1371	\N
1399	467	1372	\N
1400	467	1373	716229
1401	468	1375	\N
1402	468	1376	\N
1403	468	1377	528311
1404	468	1378	549895
1405	468	1379	618015
1406	469	1380	\N
1407	469	1382	358689
1408	469	1383	686820
1409	470	1384	\N
1410	471	1385	789823
1411	471	1386	983991
1412	471	1387	410933
1413	472	1388	565970
1414	473	1389	\N
1415	473	1390	\N
1416	474	1392	\N
1417	474	1393	\N
1418	475	1395	\N
1419	475	1397	\N
1420	475	1398	\N
1421	475	1399	\N
1422	475	1400	807413
1423	476	1401	\N
1424	476	1402	\N
1425	476	1404	\N
1426	476	1405	\N
1427	476	1406	\N
1428	477	1408	\N
1429	477	1409	\N
1430	477	1411	\N
1431	477	1413	180579
1432	478	1414	\N
1433	478	1416	\N
1434	478	1417	\N
1435	478	1418	\N
1436	479	1419	\N
1437	479	1420	\N
1438	479	1421	\N
1439	479	1422	\N
1440	479	1423	545664
1441	480	1425	\N
1442	480	1426	243784
1443	480	1428	569847
1444	481	1429	\N
1445	481	1431	\N
1446	481	1432	\N
1447	481	1433	586686
1448	481	1434	499411
1449	482	1435	\N
1450	483	1436	\N
1451	483	1438	\N
1452	483	1439	947817
1453	483	1441	202121
1454	483	1443	781602
1455	484	1444	\N
1456	484	1445	111496
1457	484	1447	315717
1458	484	1448	517917
1459	484	1449	377591
1460	485	1450	\N
1461	485	1452	\N
1462	485	1454	\N
1463	485	1455	\N
1464	486	1456	502625
1465	487	1457	911548
1466	487	1458	950718
1467	487	1459	987554
1468	487	1460	544712
1469	488	1461	\N
1470	488	1463	851196
1471	489	1464	\N
1472	490	1465	477060
1473	491	1466	\N
1474	491	1467	277230
1475	492	1469	903625
1476	492	1470	758609
1477	492	1471	411195
1478	492	1472	835934
1479	567	1468	962244
1480	568	1473	\N
1481	493	1475	915944
1482	493	1477	653039
1483	568	1475	517549
1484	568	1476	141737
1485	494	1479	\N
1486	569	1478	\N
1487	569	1479	\N
1488	569	1480	\N
1489	569	1482	\N
1490	569	1483	\N
1491	494	1484	933178
1492	494	1486	132492
1493	570	1487	\N
1494	570	1488	\N
1495	570	1489	583194
1496	570	1490	174267
1497	570	1491	195399
1498	495	1492	\N
1499	495	1493	\N
1500	495	1495	730370
1501	495	1497	855296
1502	496	1498	394161
1503	496	1499	189811
1504	496	1500	404241
1505	571	1498	967342
1506	497	1502	\N
1507	572	1501	\N
1508	572	1502	\N
1509	497	1503	778385
1510	497	1504	635814
1511	573	1505	\N
1512	573	1507	\N
1513	573	1508	\N
1514	573	1509	\N
1515	573	1510	\N
1516	498	1511	937280
1517	498	1513	927582
1518	498	1514	319100
1519	499	1515	\N
1520	499	1516	\N
1521	499	1517	\N
1522	499	1518	\N
1523	574	1515	\N
1524	574	1516	\N
1525	574	1517	\N
1526	574	1518	\N
1527	499	1519	405012
1528	500	1520	\N
1529	500	1521	796358
1530	500	1523	708822
1531	575	1522	975620
1532	575	1524	769757
1533	575	1525	549365
1534	575	1526	352959
1535	576	1527	\N
1536	501	1528	871439
1537	501	1530	116353
1538	576	1528	868724
1539	576	1529	454306
1540	576	1530	765549
1541	576	1531	563063
1542	502	1533	385557
1543	502	1535	237926
1544	577	1537	\N
1545	577	1539	\N
1546	577	1540	\N
1547	577	1541	378237
1548	503	1542	\N
1549	578	1543	223650
1550	578	1544	665250
1551	578	1545	670588
1552	504	1546	\N
1553	504	1547	520196
1554	504	1548	997568
1555	504	1549	351825
1556	505	1550	\N
1557	506	1552	857822
1558	506	1553	292046
1559	579	1551	127850
1560	579	1552	586630
1561	579	1553	136115
1562	579	1554	355162
1563	507	1555	\N
1564	580	1555	\N
1565	580	1556	\N
1566	580	1557	161059
1567	580	1558	814517
1568	581	1559	758177
1569	581	1560	521470
1570	582	1562	\N
1571	582	1563	266160
1572	582	1565	583752
1573	508	1567	\N
1574	508	1568	\N
1575	508	1569	\N
1576	583	1566	\N
1577	583	1567	\N
1578	583	1568	\N
1579	583	1569	\N
1580	583	1570	\N
1581	509	1572	772524
1582	509	1573	603565
1583	509	1574	893011
1584	584	1571	836956
1585	585	1575	\N
1586	510	1577	864281
1587	510	1578	279630
1588	510	1579	768593
1589	510	1581	650765
1590	585	1577	954647
1591	511	1582	\N
1592	511	1583	\N
1593	511	1585	\N
1594	511	1587	\N
1595	586	1583	\N
1596	586	1588	811262
1597	587	1589	567002
1598	512	1590	891150
1599	512	1592	681135
1600	513	1594	\N
1601	513	1596	\N
1602	513	1597	\N
1603	514	1598	\N
1604	588	1600	\N
1605	588	1602	\N
1606	588	1603	\N
1607	588	1604	\N
1608	515	1605	381271
1609	515	1606	754834
1610	515	1607	163530
1611	588	1606	414451
1612	516	1608	\N
1613	516	1610	\N
1614	516	1611	\N
1615	516	1612	712446
1616	589	1612	201111
1617	590	1613	\N
1618	590	1614	\N
1619	517	1615	911409
1620	517	1616	988027
1621	517	1617	909529
1622	518	1618	519326
1623	591	1618	419301
1624	591	1619	138174
1625	591	1620	276950
1626	591	1622	746090
1627	591	1623	470092
1628	519	1624	\N
1629	519	1625	\N
1630	519	1626	\N
1631	519	1628	\N
1632	519	1629	585079
1633	592	1629	515756
1634	592	1630	292654
1635	592	1632	696459
1636	592	1633	109518
1637	520	1635	\N
1638	520	1636	\N
1639	520	1637	\N
1640	520	1638	\N
1641	593	1635	\N
1642	593	1639	277852
1643	593	1641	992652
1644	593	1642	133632
1645	521	1643	\N
1646	521	1645	\N
1647	594	1643	\N
1648	521	1647	351497
1649	594	1646	634908
1650	594	1648	142326
1651	594	1650	951586
1652	594	1652	557766
1653	595	1653	\N
1654	595	1654	976183
1655	595	1656	176243
1656	595	1657	639028
1657	595	1659	531423
1658	522	1660	\N
1659	522	1661	\N
1660	596	1660	\N
1661	522	1662	308660
1662	596	1662	150010
1663	596	1663	705494
1664	596	1664	560093
1665	523	1665	462853
1666	523	1666	859670
1667	597	1666	238220
1668	598	1668	\N
1669	524	1669	525718
1670	598	1669	950030
1671	598	1670	176013
1672	599	1671	\N
1673	525	1672	262062
1674	599	1672	230041
1675	599	1673	527149
1676	599	1674	518963
1677	526	1675	\N
1678	526	1676	\N
1679	526	1678	\N
1680	526	1679	\N
1681	526	1680	\N
1682	600	1681	561988
1683	600	1682	672057
1684	600	1683	684849
1685	600	1684	744756
1686	601	1685	\N
1687	601	1686	\N
1688	601	1687	\N
1689	602	1689	\N
1690	602	1690	\N
1691	602	1692	\N
1692	527	1693	843653
1693	527	1694	792847
1694	603	1694	314393
1695	603	1696	182764
1696	604	1698	\N
1697	604	1699	\N
1698	528	1700	198500
1699	604	1700	569057
1700	604	1701	931437
1701	529	1702	\N
1702	529	1704	\N
1703	529	1705	928147
1704	605	1705	543517
1705	530	1706	\N
1706	530	1707	\N
1707	606	1706	\N
1708	606	1708	\N
1709	606	1709	\N
1710	606	1710	\N
1711	530	1712	115092
1712	530	1713	104122
1713	530	1714	180158
1714	606	1711	768018
1715	607	1716	\N
1716	531	1717	\N
1717	531	1718	\N
1718	531	1719	\N
1719	608	1718	\N
1720	531	1721	254348
1721	531	1723	775078
1722	532	1724	\N
1723	532	1725	\N
1724	532	1726	\N
1725	532	1727	\N
1726	609	1728	884681
1727	610	1729	788835
1728	610	1730	137303
1729	610	1731	485572
1730	533	1732	\N
1731	611	1733	803818
1732	611	1734	306657
1733	611	1735	316802
1734	611	1736	523815
1735	534	1738	\N
1736	534	1740	\N
1737	534	1741	\N
1738	534	1743	\N
1739	612	1744	815895
1740	612	1746	566738
1741	612	1747	244439
1742	612	1748	750056
1743	613	1749	\N
1744	535	1751	330023
1745	535	1752	908143
1746	535	1753	496978
1747	535	1755	700556
1748	535	1756	986895
1749	613	1750	148288
1750	613	1752	733474
1751	614	1758	\N
1752	614	1759	\N
1753	614	1760	\N
1754	614	1762	253543
1755	614	1764	296430
1756	536	1765	\N
1757	536	1766	733047
1758	615	1767	\N
1759	615	1768	349215
1760	615	1769	696640
1761	537	1770	\N
1762	537	1772	\N
1763	537	1774	796123
1764	616	1775	\N
1765	616	1776	\N
1766	538	1777	324056
1767	538	1779	125964
1768	538	1780	539204
1769	538	1781	775430
1770	538	1783	823286
1771	539	1784	851501
1772	539	1785	232150
1773	617	1784	225741
1774	617	1786	796878
1775	540	1787	\N
1776	540	1788	\N
1777	540	1790	\N
1778	540	1791	\N
1779	618	1788	\N
1780	618	1790	\N
1781	618	1791	\N
1782	618	1792	\N
1783	540	1793	447743
1784	541	1794	\N
1785	541	1796	984722
1786	541	1797	341618
1787	541	1799	352794
1788	619	1795	239682
1789	619	1796	838727
1790	620	1800	\N
1791	620	1801	\N
1792	620	1802	\N
1793	620	1803	574343
1794	542	1804	\N
1795	621	1804	\N
1796	622	1805	\N
1797	622	1806	\N
1798	622	1808	\N
1799	622	1809	\N
1800	543	1810	182069
1801	543	1811	811217
1802	543	1813	353860
1803	623	1814	\N
1804	623	1815	\N
1805	623	1816	\N
1806	623	1817	854340
1807	624	1818	\N
1808	544	1819	269426
1809	624	1819	905869
1810	624	1820	326219
1811	545	1822	\N
1812	545	1823	157140
1813	545	1824	763092
1814	625	1823	668010
1815	546	1826	\N
1816	546	1827	\N
1817	546	1829	\N
1818	546	1830	\N
1819	546	1832	\N
1820	626	1834	862603
1821	547	1836	\N
1822	627	1837	292539
1823	627	1838	643394
1824	548	1840	\N
1825	548	1841	\N
1826	628	1839	\N
1827	628	1840	\N
1828	628	1841	\N
1829	548	1842	366776
1830	548	1843	830681
1831	548	1845	119584
1832	629	1846	260605
1833	549	1847	\N
1834	549	1848	\N
1835	549	1849	\N
1836	630	1847	\N
1837	630	1849	\N
1838	630	1850	295587
1839	550	1851	\N
1840	550	1853	\N
1841	550	1855	331043
1842	551	1856	\N
1843	551	1857	900143
1844	551	1858	465487
1845	631	1858	560980
1846	552	1859	\N
1847	552	1860	\N
1848	632	1859	\N
1849	632	1860	\N
1850	552	1862	175048
1851	552	1863	146956
1852	553	1865	\N
1853	553	1866	\N
1854	553	1867	\N
1855	633	1864	\N
1856	633	1865	\N
1857	553	1868	236786
1858	553	1869	415109
1859	554	1871	\N
1860	554	1872	\N
1861	634	1870	\N
1862	634	1871	\N
1863	634	1873	\N
1864	634	1875	\N
1865	554	1876	645344
1866	554	1877	121066
1867	554	1878	419851
1868	634	1877	792021
1869	555	1879	\N
1870	555	1880	\N
1871	555	1882	159762
1872	556	1884	\N
1873	556	1885	902820
1874	556	1886	672506
1875	556	1887	629332
1876	635	1885	808301
1877	635	1887	489739
1878	635	1888	248060
1879	635	1889	967094
1880	557	1891	\N
1881	557	1892	\N
1882	636	1894	275018
1883	636	1896	432807
1884	636	1897	617575
1885	636	1898	456334
1886	636	1900	875357
1887	637	1901	\N
1888	637	1902	\N
1889	558	1903	580666
1890	558	1904	674655
1891	637	1904	537595
1892	637	1906	865832
1893	637	1907	575784
1894	559	1908	849144
1895	638	1908	291985
1896	638	1909	517233
1897	638	1910	770739
1898	638	1911	747727
1899	638	1912	643929
1900	560	1913	\N
1901	639	1915	268776
1902	639	1916	357952
1903	561	1917	\N
1904	561	1918	287694
1905	562	1920	\N
1906	562	1921	\N
1907	563	1922	\N
1908	563	1924	\N
1909	640	1922	\N
1910	563	1926	120932
1911	563	1927	153517
1912	563	1928	463730
1913	640	1925	848503
1914	640	1926	972734
1915	564	1929	\N
1916	564	1930	\N
1917	564	1931	\N
1918	564	1932	\N
1919	564	1933	\N
1920	641	1930	\N
1921	641	1931	\N
1922	565	1935	\N
1923	565	1936	789790
1924	565	1937	686849
1925	565	1938	773786
1926	642	1936	250745
1927	642	1938	243737
1928	566	1939	\N
1929	566	1940	\N
1930	566	1941	\N
1931	730	1943	\N
1932	825	1942	\N
1933	730	1944	432189
1934	825	1945	638744
1935	643	1946	\N
1936	643	1947	\N
1937	731	1946	\N
1938	731	1948	\N
1939	826	1946	\N
1940	826	1947	\N
1941	643	1949	775841
1942	643	1950	784577
1943	643	1952	202492
1944	731	1950	738599
1945	731	1951	522063
1946	826	1950	507615
1947	732	1953	272756
1948	827	1953	621289
1949	827	1954	717775
1950	828	1955	\N
1951	828	1956	\N
1952	644	1957	490052
1953	644	1959	534395
1954	828	1958	556148
1955	733	1960	\N
1956	733	1961	\N
1957	829	1960	\N
1958	645	1963	381521
1959	733	1962	107072
1960	733	1964	841290
1961	733	1965	210326
1962	829	1962	989352
1963	829	1964	891449
1964	829	1966	702382
1965	829	1968	180859
1966	734	1970	\N
1967	734	1972	\N
1968	646	1973	243825
1969	646	1974	598015
1970	734	1973	171938
1971	830	1974	827153
1972	830	1975	341834
1973	830	1976	190046
1974	830	1977	926551
1975	830	1978	751550
1976	647	1979	\N
1977	735	1979	\N
1978	831	1980	\N
1979	831	1982	\N
1980	831	1983	\N
1981	831	1984	\N
1982	735	1985	834660
1983	735	1986	770428
1984	832	1987	\N
1985	648	1988	516976
1986	648	1989	446002
1987	832	1988	997599
1988	649	1991	\N
1989	649	1992	\N
1990	649	1993	\N
1991	649	1995	\N
1992	649	1996	\N
1993	736	1990	\N
1994	833	1990	\N
1995	833	1991	\N
1996	833	1992	\N
1997	833	1993	\N
1998	736	1998	666395
1999	736	0	676944
2000	650	2	\N
2001	650	3	\N
2002	737	1	\N
2003	834	1	\N
2004	650	4	513399
2005	650	5	607121
2006	650	6	152010
2007	737	5	799962
2008	737	6	613015
2009	737	7	177137
2010	834	4	521270
2011	834	6	856955
2012	834	7	968712
2013	738	8	\N
2014	835	8	\N
2015	835	10	\N
2016	835	11	\N
2017	835	12	\N
2018	835	13	229586
2019	739	14	\N
2020	836	15	\N
2021	836	16	969704
2022	740	17	\N
2023	740	19	\N
2024	740	21	\N
2025	837	17	\N
2026	651	22	878203
2027	651	23	181458
2028	740	22	876836
2029	740	23	150778
2030	837	22	490662
2031	652	24	\N
2032	652	25	\N
2033	741	24	\N
2034	741	26	\N
2035	838	28	865822
2036	653	30	\N
2037	653	31	\N
2038	742	30	\N
2039	742	31	\N
2040	742	32	\N
2041	653	34	314444
2042	653	35	995116
2043	653	37	248961
2044	839	34	548073
2045	839	35	946496
2046	654	38	\N
2047	654	40	\N
2048	743	38	\N
2049	743	39	\N
2050	743	40	\N
2051	743	41	358121
2052	743	42	359879
2053	744	43	\N
2054	744	45	\N
2055	744	47	\N
2056	840	43	\N
2057	655	48	812852
2058	840	49	788189
2059	840	50	482534
2060	656	52	\N
2061	745	51	\N
2062	841	51	\N
2063	841	53	\N
2064	656	54	347933
2065	745	54	916086
2066	745	55	364813
2067	745	57	208998
2068	841	54	484673
2069	841	55	267525
2070	657	58	\N
2071	657	60	\N
2072	657	62	\N
2073	657	63	137170
2074	842	63	352562
2075	842	64	427494
2076	842	65	180784
2077	842	66	482853
2078	842	68	967844
2079	658	69	\N
2080	658	70	\N
2081	658	71	\N
2082	843	69	\N
2083	746	72	756620
2084	746	73	997752
2085	746	74	318671
2086	843	72	937461
2087	843	73	588934
2088	843	74	843273
2089	659	76	\N
2090	659	77	\N
2091	659	78	\N
2092	659	79	\N
2093	747	75	\N
2094	747	76	\N
2095	844	75	\N
2096	747	80	979678
2097	844	80	824861
2098	844	81	403066
2099	748	82	\N
2100	748	83	\N
2101	845	82	\N
2102	845	85	615003
2103	845	86	573568
2104	749	87	\N
2105	749	88	\N
2106	749	90	\N
2107	846	87	\N
2108	749	92	397817
2109	660	93	\N
2110	660	94	\N
2111	660	96	\N
2112	847	93	\N
2113	660	98	632677
2114	660	99	592714
2115	750	97	215740
2116	848	100	\N
2117	848	101	\N
2118	848	103	\N
2119	661	105	798639
2120	661	106	751308
2121	661	107	164371
2122	661	109	973747
2123	751	104	133803
2124	751	105	189069
2125	751	107	561171
2126	848	104	815365
2127	848	105	511562
2128	662	110	\N
2129	662	111	\N
2130	752	110	\N
2131	752	111	\N
2132	752	112	\N
2133	849	110	\N
2134	849	111	\N
2135	662	113	438419
2136	662	115	485899
2137	752	113	866259
2138	849	113	630119
2139	849	114	944094
2140	849	115	744613
2141	663	116	\N
2142	663	117	\N
2143	753	116	\N
2144	753	118	\N
2145	850	116	\N
2146	850	117	\N
2147	850	119	\N
2148	850	120	\N
2149	850	121	\N
2150	663	123	352886
2151	753	122	214277
2152	753	123	382536
2153	754	124	\N
2154	754	125	\N
2155	754	127	\N
2156	851	124	\N
2157	851	128	167560
2158	851	129	593576
2159	851	130	542505
2160	664	131	\N
2161	664	133	\N
2162	755	132	\N
2163	755	133	\N
2164	755	134	\N
2165	852	132	\N
2166	755	135	370159
2167	852	135	105196
2168	852	137	648079
2169	852	138	694049
2170	665	139	\N
2171	665	141	\N
2172	665	142	\N
2173	665	143	\N
2174	665	144	\N
2175	756	140	\N
2176	756	141	\N
2177	853	140	\N
2178	853	142	\N
2179	756	146	329078
2180	666	148	\N
2181	666	150	\N
2182	666	151	\N
2183	666	152	\N
2184	757	148	\N
2185	854	148	\N
2186	854	149	\N
2187	854	150	\N
2188	854	152	\N
2189	757	153	514399
2190	757	154	968146
2191	757	155	965365
2192	757	156	835399
2193	854	153	141627
2194	758	158	\N
2195	758	159	\N
2196	855	157	\N
2197	855	158	\N
2198	667	161	316410
2199	667	163	673182
2200	667	165	218137
2201	758	161	920977
2202	758	163	545607
2203	758	165	694805
2204	855	160	941965
2205	855	162	826677
2206	855	163	397705
2207	759	166	\N
2208	759	167	\N
2209	759	168	\N
2210	759	169	\N
2211	759	170	\N
2212	668	171	272735
2213	668	172	974621
2214	856	172	373727
2215	669	173	\N
2216	669	174	\N
2217	760	173	\N
2218	760	175	\N
2219	760	177	\N
2220	669	178	165929
2221	669	179	545092
2222	857	179	588560
2223	857	180	930095
2224	857	181	618023
2225	761	182	\N
2226	761	184	\N
2227	761	185	\N
2228	858	182	\N
2229	858	184	\N
2230	858	186	395833
2231	858	187	898912
2232	858	189	415945
2233	859	190	\N
2234	859	191	\N
2235	859	192	941062
2236	670	193	\N
2237	762	193	\N
2238	762	194	\N
2239	860	193	\N
2240	670	195	591966
2241	671	196	\N
2242	671	198	\N
2243	763	197	\N
2244	763	199	\N
2245	763	200	\N
2246	763	201	\N
2247	861	197	\N
2248	861	198	\N
2249	861	199	\N
2250	861	200	\N
2251	671	202	340452
2252	671	203	373652
2253	763	202	438522
2254	861	202	401606
2255	672	204	\N
2256	672	206	996274
2257	672	207	259753
2258	672	208	655558
2259	764	209	\N
2260	673	211	316339
2261	862	211	675875
2262	862	212	217922
2263	862	213	785532
2264	674	214	\N
2265	674	215	\N
2266	765	214	\N
2267	766	216	\N
2268	766	217	\N
2269	863	216	\N
2270	675	219	444750
2271	863	218	411911
2272	863	219	167803
2273	676	220	\N
2274	767	221	\N
2275	767	222	\N
2276	864	220	\N
2277	864	221	\N
2278	864	223	\N
2279	864	224	\N
2280	676	225	657115
2281	768	226	\N
2282	768	227	\N
2283	768	228	\N
2284	865	229	883590
2285	677	231	\N
2286	769	230	\N
2287	769	231	\N
2288	769	232	893945
2289	769	233	445259
2290	678	234	\N
2291	770	234	\N
2292	770	235	\N
2293	770	236	\N
2294	866	235	\N
2295	866	236	\N
2296	866	237	\N
2297	678	238	563033
2298	678	239	322001
2299	678	240	273614
2300	866	238	506345
2301	867	241	\N
2302	867	242	\N
2303	867	243	\N
2304	771	244	514606
2305	771	245	580591
2306	867	244	118752
2307	867	246	969609
2308	679	247	\N
2309	679	248	\N
2310	679	249	\N
2311	772	247	\N
2312	772	248	\N
2313	772	249	\N
2314	679	251	715925
2315	679	252	409249
2316	868	251	986366
2317	868	253	121416
2318	680	254	\N
2319	680	255	\N
2320	680	256	\N
2321	869	254	\N
2322	869	255	\N
2323	869	256	\N
2324	869	257	693880
2325	869	258	941502
2326	681	259	\N
2327	681	260	\N
2328	773	259	\N
2329	773	260	\N
2330	773	261	\N
2331	773	262	\N
2332	773	263	511217
2333	870	263	311732
2334	870	264	724689
2335	682	265	\N
2336	682	266	\N
2337	682	267	\N
2338	774	265	\N
2339	774	267	\N
2340	774	268	\N
2341	774	269	\N
2342	871	265	\N
2343	682	270	909547
2344	683	271	\N
2345	683	273	\N
2346	683	274	\N
2347	683	275	\N
2348	683	276	\N
2349	872	271	\N
2350	684	277	\N
2351	775	277	\N
2352	775	278	\N
2353	775	279	\N
2354	873	277	\N
2355	873	278	\N
2356	873	279	\N
2357	873	280	\N
2358	684	281	321938
2359	684	282	559196
2360	775	281	914178
2361	775	282	389428
2362	873	282	878924
2363	776	284	\N
2364	776	286	\N
2365	776	287	\N
2366	776	288	\N
2367	776	289	\N
2368	874	284	\N
2369	685	290	\N
2370	685	291	\N
2371	777	290	\N
2372	875	290	\N
2373	685	293	581817
2374	685	294	203991
2375	686	295	\N
2376	686	296	\N
2377	686	297	\N
2378	876	295	\N
2379	876	296	\N
2380	876	297	\N
2381	778	298	427279
2382	778	299	131211
2383	778	300	909922
2384	876	298	276766
2385	687	302	\N
2386	687	303	\N
2387	687	304	\N
2388	779	301	\N
2389	687	305	990330
2390	877	305	519268
2391	877	306	720704
2392	877	308	189618
2393	877	309	781474
2394	688	310	\N
2395	688	312	\N
2396	878	310	\N
2397	878	311	\N
2398	878	313	\N
2399	688	314	866598
2400	689	316	\N
2401	689	318	\N
2402	689	320	\N
2403	780	315	\N
2404	780	316	\N
2405	780	317	\N
2406	780	319	\N
2407	879	316	\N
2408	879	317	\N
2409	879	318	\N
2410	689	321	200836
2411	689	322	143352
2412	780	321	649580
2413	879	321	363270
2414	879	323	897757
2415	880	324	\N
2416	880	325	\N
2417	880	327	\N
2418	880	328	690793
2419	690	330	\N
2420	690	331	\N
2421	690	332	\N
2422	781	329	\N
2423	781	331	\N
2424	781	332	\N
2425	781	334	\N
2426	782	335	\N
2427	881	335	\N
2428	881	337	\N
2429	782	338	301099
2430	782	340	774916
2431	881	338	531598
2432	881	339	860892
2433	881	340	810516
2434	691	341	\N
2435	691	342	\N
2436	691	344	\N
2437	691	345	\N
2438	882	341	\N
2439	882	342	\N
2440	882	346	854072
2441	882	347	672566
2442	783	348	\N
2443	783	349	\N
2444	783	351	\N
2445	783	352	\N
2446	783	354	\N
2447	692	355	720999
2448	883	355	262111
2449	883	357	617900
2450	883	358	641408
2451	693	359	\N
2452	693	360	\N
2453	884	359	\N
2454	884	361	\N
2455	884	363	\N
2456	884	364	\N
2457	693	365	845554
2458	784	366	\N
2459	885	366	\N
2460	885	367	\N
2461	694	368	404284
2462	694	369	205092
2463	694	371	392664
2464	694	372	475046
2465	694	373	945403
2466	784	369	426252
2467	784	371	783821
2468	784	372	668456
2469	695	374	\N
2470	695	376	\N
2471	695	377	\N
2472	695	378	\N
2473	785	374	\N
2474	785	379	926645
2475	886	379	217993
2476	886	380	568707
2477	886	381	122804
2478	886	383	226047
2479	886	384	766390
2480	696	385	\N
2481	697	386	\N
2482	697	387	\N
2483	697	388	\N
2484	697	389	514066
2485	697	391	837551
2486	698	392	\N
2487	698	393	\N
2488	698	394	\N
2489	698	395	\N
2490	698	397	\N
2491	786	398	953537
2492	786	399	726567
2493	786	400	597400
2494	887	398	627579
2495	787	401	401118
2496	787	403	306103
2497	787	404	839349
2498	787	405	203632
2499	787	406	256357
2500	699	407	\N
2501	699	408	\N
2502	699	409	\N
2503	699	410	192270
2504	888	411	174718
2505	889	412	\N
2506	889	413	\N
2507	889	414	\N
2508	700	415	129712
2509	700	416	140359
2510	700	418	974475
2511	700	420	729261
2512	788	415	662821
2513	889	416	721030
2514	789	421	\N
2515	789	422	\N
2516	789	424	\N
2517	789	425	\N
2518	890	421	\N
2519	701	426	469712
2520	789	426	628150
2521	890	427	778902
2522	890	428	132568
2523	891	430	\N
2524	702	431	507334
2525	790	431	398330
2526	891	431	941649
2527	891	432	173825
2528	791	433	126162
2529	791	434	251269
2530	791	436	345505
2531	791	437	432437
2532	892	434	207375
2533	703	439	\N
2534	703	440	\N
2535	792	438	\N
2536	893	438	\N
2537	792	441	537450
2538	704	442	\N
2539	704	443	\N
2540	704	445	\N
2541	793	442	\N
2542	793	443	\N
2543	793	444	\N
2544	894	442	\N
2545	704	446	267567
2546	894	447	337088
2547	894	448	923386
2548	705	449	\N
2549	705	450	\N
2550	895	449	\N
2551	895	450	\N
2552	895	451	\N
2553	794	452	193313
2554	794	454	670981
2555	794	455	258501
2556	794	456	309838
2557	706	457	\N
2558	706	458	\N
2559	706	459	\N
2560	795	458	\N
2561	795	459	\N
2562	896	457	\N
2563	896	458	\N
2564	706	460	320931
2565	795	460	839582
2566	896	460	452267
2567	896	461	725239
2568	896	463	524518
2569	707	464	\N
2570	707	466	\N
2571	796	464	\N
2572	796	465	\N
2573	796	466	\N
2574	707	467	500653
2575	796	468	155063
2576	708	469	\N
2577	708	470	793167
2578	708	472	175712
2579	708	473	324671
2580	708	474	214016
2581	797	471	898466
2582	897	470	759404
2583	897	471	812743
2584	897	472	964199
2585	709	475	\N
2586	709	476	\N
2587	709	477	\N
2588	898	475	\N
2589	709	478	846261
2590	709	480	902092
2591	798	478	263271
2592	798	479	742197
2593	898	478	318796
2594	799	481	\N
2595	899	481	\N
2596	899	483	\N
2597	899	484	\N
2598	899	485	\N
2599	710	486	438641
2600	710	487	528124
2601	710	489	855047
2602	711	490	\N
2603	711	491	470223
2604	711	492	938271
2605	711	493	302942
2606	711	494	291194
2607	800	491	758959
2608	900	491	414179
2609	900	492	392880
2610	900	493	382948
2611	801	495	\N
2612	712	497	369540
2613	712	498	318353
2614	901	499	\N
2615	901	500	\N
2616	901	501	\N
2617	901	503	\N
2618	901	504	\N
2619	713	505	501173
2620	802	505	158724
2621	802	506	369688
2622	803	508	\N
2623	902	508	\N
2624	803	510	525249
2625	902	509	236793
2626	714	511	\N
2627	804	511	\N
2628	903	512	\N
2629	714	513	621715
2630	714	514	577638
2631	714	515	267808
2632	714	517	156954
2633	903	513	258758
2634	903	514	544253
2635	805	518	\N
2636	805	520	\N
2637	715	521	862322
2638	715	523	244468
2639	805	522	957387
2640	904	522	631287
2641	904	524	172235
2642	904	525	925397
2643	904	527	541520
2644	904	528	505982
2645	716	529	\N
2646	905	529	\N
2647	717	530	\N
2648	906	531	\N
2649	906	532	\N
2650	906	533	\N
2651	906	534	\N
2652	717	535	313396
2653	717	536	910421
2654	906	535	289949
2655	718	537	465790
2656	718	538	214793
2657	718	539	381281
2658	718	540	291620
2659	718	541	294056
2660	806	542	\N
2661	907	543	\N
2662	907	545	\N
2663	907	546	\N
2664	719	548	527932
2665	719	549	974953
2666	719	551	188037
2667	719	552	611310
2668	806	547	364914
2669	806	548	617810
2670	806	549	456710
2671	806	550	537981
2672	907	547	765656
2673	720	553	\N
2674	807	553	\N
2675	807	554	\N
2676	807	555	\N
2677	720	557	641869
2678	807	556	467933
2679	721	558	\N
2680	721	560	\N
2681	721	561	\N
2682	808	558	\N
2683	808	559	\N
2684	908	558	\N
2685	721	562	798611
2686	721	564	162175
2687	808	562	955207
2688	908	562	224217
2689	809	565	\N
2690	809	566	\N
2691	722	567	\N
2692	722	568	\N
2693	909	567	\N
2694	909	568	\N
2695	909	569	\N
2696	909	570	\N
2697	722	571	644431
2698	722	572	141463
2699	810	572	619889
2700	810	573	525327
2701	810	574	311744
2702	810	576	981697
2703	909	572	963841
2704	723	577	\N
2705	811	577	\N
2706	811	578	\N
2707	910	577	\N
2708	723	579	557242
2709	723	580	350335
2710	723	581	248296
2711	723	583	469216
2712	811	579	906295
2713	811	580	348326
2714	910	579	506720
2715	910	581	704571
2716	910	583	809454
2717	910	584	923324
2718	724	586	\N
2719	812	585	\N
2720	812	586	\N
2721	812	587	\N
2722	812	588	\N
2723	911	585	\N
2724	911	586	\N
2725	911	587	\N
2726	725	589	\N
2727	725	590	\N
2728	725	592	\N
2729	725	593	\N
2730	813	590	\N
2731	813	595	638878
2732	726	596	\N
2733	726	598	\N
2734	814	596	\N
2735	726	600	519268
2736	814	599	920934
2737	815	602	\N
2738	815	604	\N
2739	727	605	833255
2740	727	607	552979
2741	727	608	721523
2742	727	610	310721
2743	727	611	334811
2744	815	605	533585
2745	816	612	\N
2746	728	613	\N
2747	728	615	\N
2748	728	617	\N
2749	817	614	\N
2750	817	615	\N
2751	817	616	\N
2752	817	618	\N
2753	728	620	213643
2754	728	621	885011
2755	818	622	\N
2756	818	623	115166
2757	818	624	399364
2758	818	625	271139
2759	819	626	\N
2760	819	627	\N
2761	819	628	\N
2762	819	629	442849
2763	729	630	\N
2764	820	630	\N
2765	820	631	\N
2766	820	632	\N
2767	821	633	\N
2768	821	634	\N
2769	821	635	\N
2770	821	636	\N
2771	821	637	912926
2772	822	638	193634
2773	822	639	730721
2774	823	640	\N
2775	823	641	\N
2776	823	642	\N
2777	823	643	\N
2778	823	644	\N
2779	824	645	768473
2780	912	646	\N
2781	912	648	\N
2782	972	646	\N
2783	912	649	819513
2784	913	650	\N
2785	913	652	\N
2786	913	653	\N
2787	913	654	\N
2788	973	650	\N
2789	974	656	\N
2790	1013	655	\N
2791	1013	657	700406
2792	1013	658	774772
2793	1013	659	453548
2794	1013	661	999221
2795	914	663	\N
2796	914	664	\N
2797	914	665	\N
2798	975	663	\N
2799	975	665	\N
2800	975	666	\N
2801	914	667	139359
2802	975	667	964912
2803	1014	667	271343
2804	1014	668	713816
2805	915	670	\N
2806	915	671	\N
2807	915	673	\N
2808	976	670	\N
2809	1015	669	\N
2810	976	674	166886
2811	1016	675	\N
2812	1016	677	\N
2813	1016	679	\N
2814	1016	680	\N
2815	977	682	955181
2816	977	684	987664
2817	977	685	443811
2818	977	686	348630
2819	977	687	196163
2820	1016	682	603114
2821	916	689	\N
2822	1017	688	\N
2823	916	690	787662
2824	916	691	476329
2825	916	693	492423
2826	916	694	629819
2827	978	691	498051
2828	978	692	541060
2829	917	695	\N
2830	917	696	566013
2831	979	697	710380
2832	1018	697	123673
2833	1018	699	837251
2834	1018	700	448291
2835	1019	701	\N
2836	1019	703	444683
2837	980	704	\N
2838	980	705	446194
2839	1020	705	203493
2840	1020	706	145345
2841	1020	708	824003
2842	1020	710	792524
2843	1020	711	417148
2844	918	712	\N
2845	981	712	\N
2846	918	713	108262
2847	981	714	427099
2848	981	715	417655
2849	981	716	764302
2850	919	717	\N
2851	982	718	\N
2852	983	719	\N
2853	983	721	\N
2854	983	722	\N
2855	1021	719	\N
2856	920	724	584836
2857	983	723	479757
2858	921	725	\N
2859	921	726	\N
2860	1022	725	\N
2861	1022	726	\N
2862	1022	728	\N
2863	1022	729	\N
2864	1022	731	\N
2865	921	733	603562
2866	921	734	969905
2867	984	733	802027
2868	922	736	\N
2869	985	735	\N
2870	985	736	\N
2871	985	737	\N
2872	1023	738	315412
2873	986	739	\N
2874	1024	739	\N
2875	1024	740	\N
2876	923	741	717399
2877	986	741	308770
2878	986	742	156803
2879	986	743	717626
2880	987	745	\N
2881	987	746	\N
2882	1025	745	\N
2883	1025	746	\N
2884	1025	747	\N
2885	924	748	181840
2886	924	749	815416
2887	924	750	315513
2888	924	751	755508
2889	987	748	996813
2890	987	750	102245
2891	987	751	396797
2892	1025	749	832750
2893	925	752	\N
2894	925	754	\N
2895	1026	752	\N
2896	988	755	326333
2897	988	756	937977
2898	988	757	903564
2899	988	758	467169
2900	988	759	953760
2901	1027	760	258065
2902	926	761	\N
2903	926	763	\N
2904	926	765	\N
2905	926	766	\N
2906	1028	761	\N
2907	1028	762	\N
2908	1028	768	837319
2909	1029	769	\N
2910	1029	770	\N
2911	927	771	223890
2912	927	772	134154
2913	927	774	398220
2914	989	771	299331
2915	989	772	824453
2916	1029	772	526204
2917	928	775	\N
2918	928	776	\N
2919	928	778	\N
2920	928	780	\N
2921	990	776	\N
2922	990	777	\N
2923	1030	776	\N
2924	1030	778	\N
2925	1030	779	\N
2926	1030	780	\N
2927	990	781	303388
2928	991	783	\N
2929	991	784	\N
2930	991	786	\N
2931	991	787	\N
2932	929	788	440859
2933	929	789	184106
2934	1031	789	654957
2935	930	790	550604
2936	930	791	531261
2937	930	792	103699
2938	930	794	754051
2939	930	795	535693
2940	992	790	991693
2941	992	791	158928
2942	992	792	630633
2943	1032	791	914024
2944	1032	792	963998
2945	931	796	\N
2946	931	797	\N
2947	931	798	\N
2948	1033	796	\N
2949	1033	797	\N
2950	931	800	459193
2951	1033	800	441668
2952	932	801	\N
2953	932	802	\N
2954	1034	801	\N
2955	1034	802	\N
2956	993	804	616206
2957	1034	804	297534
2958	933	806	\N
2959	994	805	\N
2960	1035	805	\N
2961	994	808	550084
2962	1035	808	635897
2963	934	809	\N
2964	934	810	\N
2965	934	811	\N
2966	995	809	\N
2967	995	810	\N
2968	995	811	\N
2969	1036	809	\N
2970	1036	811	\N
2971	1036	812	\N
2972	1037	813	\N
2973	935	814	552092
2974	935	815	426847
2975	935	816	747547
2976	935	818	226594
2977	935	819	351579
2978	1037	814	895268
2979	996	821	\N
2980	996	822	\N
2981	996	823	901211
2982	996	824	138545
2983	1038	823	758317
2984	1038	824	499890
2985	936	825	\N
2986	936	826	\N
2987	936	827	731900
2988	936	828	111023
2989	997	828	832865
2990	937	829	\N
2991	998	830	\N
2992	998	831	\N
2993	998	833	\N
2994	998	834	\N
2995	998	835	\N
2996	1039	836	894213
2997	1039	837	892026
2998	1039	838	207052
2999	938	839	\N
3000	938	840	\N
3001	938	841	\N
3002	999	839	\N
3003	999	840	\N
3004	938	843	457922
3005	999	842	295366
3006	939	844	\N
3007	1000	845	443436
3008	1040	845	286967
3009	1040	846	799429
3010	940	847	\N
3011	940	848	\N
3012	940	850	\N
3013	940	852	\N
3014	940	853	\N
3015	1001	848	\N
3016	1001	849	\N
3017	1041	854	731158
3018	1041	856	392616
3019	1042	858	\N
3020	1002	859	904485
3021	1002	860	226806
3022	1002	861	922995
3023	1042	859	355670
3024	941	862	\N
3025	941	863	\N
3026	941	864	\N
3027	1043	862	\N
3028	941	865	952439
3029	1003	866	776643
3030	1003	867	130737
3031	1003	868	323450
3032	1003	870	708054
3033	1003	871	812950
3034	1043	865	174802
3035	1043	866	452137
3036	1043	867	837171
3037	1043	868	850669
3038	942	872	\N
3039	942	874	\N
3040	942	875	\N
3041	942	876	\N
3042	1044	872	\N
3043	1044	873	\N
3044	1044	875	\N
3045	1044	877	\N
3046	942	879	860106
3047	1004	878	259647
3048	1004	879	932680
3049	1004	881	316656
3050	1044	878	651578
3051	1005	882	\N
3052	1005	884	\N
3053	1005	886	206444
3054	1005	888	511905
3055	1005	889	625599
3056	1006	890	355902
3057	1006	891	204943
3058	1045	890	569021
3059	1045	891	373815
3060	1045	892	646514
3061	1045	893	128220
3062	943	894	\N
3063	943	896	\N
3064	943	897	\N
3065	1007	894	\N
3066	1007	895	\N
3067	1007	896	\N
3068	1007	897	\N
3069	943	898	265453
3070	1007	898	878526
3071	1008	899	\N
3072	1046	900	\N
3073	1046	901	\N
3074	1046	902	\N
3075	1008	903	323390
3076	1008	904	192030
3077	944	905	555325
3078	944	906	105935
3079	944	908	199884
3080	944	909	520915
3081	944	911	138363
3082	945	912	\N
3083	945	913	\N
3084	945	915	\N
3085	1009	916	475663
3086	1047	917	717629
3087	1047	918	260735
3088	1047	920	447548
3089	1010	921	\N
3090	1010	922	\N
3091	1010	923	\N
3092	1048	922	\N
3093	1048	923	\N
3094	1048	925	\N
3095	1048	926	\N
3096	946	927	984142
3097	946	928	115472
3098	946	929	873120
3099	946	930	688216
3100	1010	927	291309
3101	1010	928	367288
3102	947	931	886218
3103	1011	931	297858
3104	1011	932	618043
3105	1011	933	197759
3106	1011	935	416500
3107	1012	937	\N
3108	1049	937	\N
3109	1049	938	\N
3110	1049	939	\N
3111	1049	940	\N
3112	948	941	232590
3113	1012	941	454891
3114	1049	942	442713
3115	949	943	451552
3116	949	944	158180
3117	1050	944	341208
3118	1050	945	122640
3119	1050	946	196998
3120	1050	947	462494
3121	1051	948	\N
3122	950	950	346314
3123	950	951	344766
3124	951	952	\N
3125	951	953	225772
3126	951	954	676838
3127	1052	953	307202
3128	1053	955	\N
3129	952	956	389803
3130	952	957	790191
3131	952	958	720735
3132	1053	956	618727
3133	953	959	\N
3134	953	961	960697
3135	953	962	166433
3136	1054	964	\N
3137	1054	965	787223
3138	1054	966	490967
3139	954	968	\N
3140	954	969	\N
3141	1055	968	\N
3142	954	970	170208
3143	1055	970	712591
3144	1055	971	216334
3145	1055	972	458971
3146	1055	973	178291
3147	955	975	\N
3148	955	976	687275
3149	955	978	955247
3150	956	979	\N
3151	956	980	868881
3152	956	982	434450
3153	957	983	\N
3154	957	984	\N
3155	957	986	\N
3156	957	987	228434
3157	1056	988	\N
3158	958	989	655202
3159	958	990	216823
3160	958	992	261594
3161	958	993	338804
3162	958	994	980143
3163	1056	989	929150
3164	1056	990	436059
3165	959	995	\N
3166	1057	995	\N
3167	959	996	211362
3168	959	997	972617
3169	959	998	401959
3170	1058	999	\N
3171	1058	1001	\N
3172	960	1002	\N
3173	1059	1003	\N
3174	1059	1004	\N
3175	960	1005	621144
3176	960	1006	662134
3177	961	1007	\N
3178	961	1009	\N
3179	961	1011	\N
3180	961	1012	\N
3181	961	1013	\N
3182	1060	1007	\N
3183	1060	1008	\N
3184	1060	1015	709893
3185	1060	1017	183847
3186	1060	1018	789098
3187	962	1019	\N
3188	962	1020	402642
3189	1061	1021	\N
3190	1061	1022	\N
3191	1061	1023	\N
3192	1061	1024	\N
3193	963	1025	583819
3194	963	1026	445198
3195	963	1027	457863
3196	1062	1028	\N
3197	964	1029	500567
3198	1062	1029	115147
3199	1062	1030	423251
3200	1062	1031	431156
3201	965	1033	\N
3202	1063	1035	\N
3203	966	1036	564040
3204	1063	1036	144761
3205	1064	1037	\N
3206	1064	1038	\N
3207	1064	1039	\N
3208	1064	1040	\N
3209	967	1041	251637
3210	967	1043	367120
3211	967	1044	788956
3212	967	1045	249698
3213	967	1046	312302
3214	968	1047	\N
3215	968	1049	\N
3216	968	1050	239126
3217	968	1051	840957
3218	1065	1050	873933
3219	969	1052	\N
3220	969	1054	\N
3221	1066	1056	\N
3222	1066	1057	\N
3223	1066	1059	\N
3224	1066	1060	589505
3225	1066	1061	358887
3226	1067	1062	261542
3227	1068	1063	244088
3228	1068	1064	418569
3229	1068	1065	743693
3230	1068	1066	681243
3231	1068	1067	353356
3232	970	1068	\N
3233	970	1069	\N
3234	1069	1068	\N
3235	1069	1070	389883
3236	971	1071	\N
3237	971	1073	\N
3238	971	1074	653869
3239	971	1075	848934
3240	1070	1075	457621
3241	1070	1077	106592
3242	1071	1079	\N
3243	1072	1080	\N
3244	1072	1081	\N
3245	1072	1082	\N
3246	1072	1083	\N
3247	1072	1084	342189
3248	1073	1085	\N
3249	1074	1086	\N
3250	1074	1087	\N
3251	1074	1088	624748
3252	1075	1089	\N
3253	1075	1090	\N
3254	1076	1091	\N
3255	1077	1092	284889
3256	1077	1093	292798
3257	1078	1094	\N
3258	1078	1095	\N
3259	1078	1096	\N
3260	1078	1097	792744
3261	1078	1098	377114
3262	1079	1099	906878
3263	1079	1100	759354
3264	1080	1101	\N
3265	1080	1102	\N
3266	1080	1103	226939
3267	1080	1104	145664
3268	1080	1105	578715
3269	1081	1107	\N
3270	1081	1108	\N
3271	1081	1110	\N
3272	1081	1111	678742
3273	1082	1112	\N
3274	1083	1114	\N
3275	1083	1116	\N
3276	1083	1117	711352
3277	1151	1118	\N
3278	1084	1119	927310
3279	1151	1119	263378
3280	1151	1121	297055
3281	1152	1122	304371
3282	1152	1123	573009
3283	1152	1125	143817
3284	1085	1126	\N
3285	1085	1127	\N
3286	1153	1127	\N
3287	1153	1128	836384
3288	1153	1129	960884
3289	1086	1131	\N
3290	1086	1132	460858
3291	1154	1132	541932
3292	1154	1133	896527
3293	1154	1134	163865
3294	1154	1136	826084
3295	1087	1137	\N
3296	1155	1137	\N
3297	1155	1138	\N
3298	1155	1139	\N
3299	1155	1140	\N
3300	1155	1141	268153
3301	1088	1142	\N
3302	1088	1144	\N
3303	1088	1145	\N
3304	1089	1146	\N
3305	1089	1147	\N
3306	1089	1148	\N
3307	1089	1150	\N
3308	1089	1152	291081
3309	1156	1152	848801
3310	1156	1153	538277
3311	1090	1154	\N
3312	1090	1155	\N
3313	1090	1157	\N
3314	1157	1154	\N
3315	1157	1156	\N
3316	1157	1157	\N
3317	1157	1158	\N
3318	1157	1159	\N
3319	1091	1161	\N
3320	1091	1162	\N
3321	1091	1163	\N
3322	1091	1165	\N
3323	1158	1161	\N
3324	1158	1166	326892
3325	1158	1167	987082
3326	1092	1168	\N
3327	1092	1169	\N
3328	1092	1170	\N
3329	1092	1171	\N
3330	1159	1168	\N
3331	1159	1170	\N
3332	1159	1171	\N
3333	1159	1173	990879
3334	1160	1174	931540
3335	1160	1176	150447
3336	1093	1177	\N
3337	1093	1178	\N
3338	1093	1179	\N
3339	1093	1180	\N
3340	1161	1177	\N
3341	1161	1181	151860
3342	1161	1182	945354
3343	1162	1184	\N
3344	1162	1185	\N
3345	1162	1186	323590
3346	1094	1188	\N
3347	1094	1189	\N
3348	1094	1190	\N
3349	1163	1187	\N
3350	1163	1188	\N
3351	1094	1191	864969
3352	1164	1192	\N
3353	1095	1194	109364
3354	1095	1196	432114
3355	1095	1197	168155
3356	1095	1198	284591
3357	1095	1199	597869
3358	1164	1194	158120
3359	1165	1200	\N
3360	1096	1201	631453
3361	1096	1202	502639
3362	1166	1204	\N
3363	1166	1205	366258
3364	1166	1206	537598
3365	1097	1208	\N
3366	1167	1207	\N
3367	1167	1208	\N
3368	1167	1209	\N
3369	1167	1210	\N
3370	1097	1211	939763
3371	1168	1213	\N
3372	1168	1214	\N
3373	1168	1216	\N
3374	1098	1217	598529
3375	1098	1218	392167
3376	1098	1219	881612
3377	1098	1220	427628
3378	1099	1221	\N
3379	1099	1222	\N
3380	1099	1224	\N
3381	1099	1225	\N
3382	1099	1227	\N
3383	1169	1221	\N
3384	1169	1223	\N
3385	1169	1228	252380
3386	1169	1229	648737
3387	1170	1231	\N
3388	1100	1232	527332
3389	1170	1232	195120
3390	1170	1233	248412
3391	1170	1234	483446
3392	1170	1235	422303
3393	1101	1236	\N
3394	1101	1237	\N
3395	1171	1236	\N
3396	1101	1239	907050
3397	1102	1241	\N
3398	1102	1243	\N
3399	1102	1244	\N
3400	1172	1240	\N
3401	1102	1245	714633
3402	1173	1246	855408
3403	1103	1247	429666
3404	1174	1247	311858
3405	1174	1248	811392
3406	1174	1249	550875
3407	1174	1251	505429
3408	1104	1252	\N
3409	1175	1253	\N
3410	1175	1255	\N
3411	1105	1257	450179
3412	1175	1256	698331
3413	1106	1258	\N
3414	1176	1258	\N
3415	1106	1260	944728
3416	1176	1259	845962
3417	1176	1260	880290
3418	1107	1261	\N
3419	1107	1263	\N
3420	1107	1264	\N
3421	1107	1266	553293
3422	1107	1267	790931
3423	1177	1266	937990
3424	1108	1268	\N
3425	1108	1270	496022
3426	1178	1271	\N
3427	1109	1273	994038
3428	1109	1274	576140
3429	1178	1272	909821
3430	1178	1273	718265
3431	1178	1274	445890
3432	1110	1275	\N
3433	1179	1276	\N
3434	1179	1277	\N
3435	1179	1278	\N
3436	1179	1279	\N
3437	1179	1280	\N
3438	1111	1281	\N
3439	1180	1281	\N
3440	1180	1282	\N
3441	1111	1283	961792
3442	1112	1284	610720
3443	1112	1285	280124
3444	1112	1286	159828
3445	1112	1288	804436
3446	1112	1289	418068
3447	1113	1291	\N
3448	1113	1292	\N
3449	1181	1291	\N
3450	1181	1292	\N
3451	1113	1293	861045
3452	1181	1293	314809
3453	1181	1294	802411
3454	1181	1295	119379
3455	1114	1297	\N
3456	1114	1298	\N
3457	1114	1299	\N
3458	1114	1300	\N
3459	1182	1296	\N
3460	1182	1297	\N
3461	1182	1299	\N
3462	1183	1301	\N
3463	1183	1302	\N
3464	1183	1304	\N
3465	1183	1306	\N
3466	1183	1307	\N
3467	1115	1308	340450
3468	1115	1309	325614
3469	1115	1310	936162
3470	1115	1311	429314
3471	1115	1312	326882
3472	1116	1314	\N
3473	1116	1315	\N
3474	1116	1316	\N
3475	1116	1317	\N
3476	1184	1318	439326
3477	1185	1320	\N
3478	1117	1322	684092
3479	1117	1324	673786
3480	1117	1326	181795
3481	1118	1327	\N
3482	1118	1328	\N
3483	1186	1327	\N
3484	1118	1330	946881
3485	1186	1329	555070
3486	1186	1330	575932
3487	1186	1331	193286
3488	1119	1332	\N
3489	1187	1332	\N
3490	1187	1333	256195
3491	1187	1334	976456
3492	1120	1335	\N
3493	1120	1336	501715
3494	1188	1336	771292
3495	1188	1337	711280
3496	1121	1338	889519
3497	1122	1339	\N
3498	1122	1340	977428
3499	1123	1341	\N
3500	1123	1342	931415
3501	1123	1343	985011
3502	1124	1344	\N
3503	1124	1346	\N
3504	1124	1348	464565
3505	1124	1349	519248
3506	1124	1350	535549
3507	1125	1351	\N
3508	1125	1353	958608
3509	1125	1354	123226
3510	1125	1355	102982
3511	1125	1356	521428
3512	1126	1357	831638
3513	1127	1358	\N
3514	1127	1360	\N
3515	1128	1361	\N
3516	1128	1363	\N
3517	1128	1365	\N
3518	1128	1366	\N
3519	1128	1367	468539
3520	1129	1368	605393
3521	1129	1369	346987
3522	1130	1371	\N
3523	1130	1373	584396
3524	1131	1374	513317
3525	1131	1375	397967
3526	1131	1377	839083
3527	1132	1378	\N
3528	1132	1379	\N
3529	1132	1381	346891
3530	1133	1382	728096
3531	1134	1384	\N
3532	1134	1385	\N
3533	1134	1386	\N
3534	1134	1388	\N
3535	1134	1389	874790
3536	1135	1390	\N
3537	1135	1392	\N
3538	1135	1393	635942
3539	1136	1395	\N
3540	1136	1397	\N
3541	1137	1398	\N
3542	1138	1399	\N
3543	1138	1401	\N
3544	1138	1402	\N
3545	1139	1403	\N
3546	1139	1404	\N
3547	1140	1405	\N
3548	1140	1407	\N
3549	1140	1408	464214
3550	1140	1409	996991
3551	1141	1410	464383
3552	1141	1412	416079
3553	1142	1413	\N
3554	1142	1414	\N
3555	1142	1415	767375
3556	1142	1417	585364
3557	1142	1419	541188
3558	1143	1420	\N
3559	1143	1421	277200
3560	1143	1422	737331
3561	1144	1423	\N
3562	1145	1425	875040
3563	1145	1426	673570
3564	1146	1427	123189
3565	1147	1428	\N
3566	1147	1430	\N
3567	1147	1432	552513
3568	1148	1433	\N
3569	1148	1434	\N
3570	1148	1435	\N
3571	1148	1437	640710
3572	1148	1438	180582
3573	1149	1439	653843
3574	1150	1440	\N
3575	1246	1441	\N
3576	1246	1443	\N
3577	1246	1445	\N
3578	1189	1446	586925
3579	1189	1447	446642
3580	1189	1448	640970
3581	1189	1449	578966
3582	1246	1446	582733
3583	1190	1450	\N
3584	1190	1451	\N
3585	1190	1453	\N
3586	1190	1455	587402
3587	1247	1454	954274
3588	1247	1456	877805
3589	1191	1458	116352
3590	1191	1459	815214
3591	1248	1457	650178
3592	1248	1459	921308
3593	1249	1460	\N
3594	1192	1461	170292
3595	1192	1463	624200
3596	1192	1465	351779
3597	1249	1461	403220
3598	1249	1462	897304
3599	1249	1463	804352
3600	1249	1465	273491
3601	1193	1467	\N
3602	1193	1468	\N
3603	1193	1469	\N
3604	1193	1470	\N
3605	1250	1467	\N
3606	1250	1468	\N
3607	1250	1470	\N
3608	1193	1471	440266
3609	1250	1471	350398
3610	1194	1472	661484
3611	1251	1472	408388
3612	1195	1473	\N
3613	1252	1474	186476
3614	1252	1475	371873
3615	1196	1476	\N
3616	1196	1477	\N
3617	1196	1478	\N
3618	1196	1479	\N
3619	1253	1477	\N
3620	1196	1480	439616
3621	1253	1480	857990
3622	1253	1481	691865
3623	1197	1483	\N
3624	1197	1484	\N
3625	1197	1485	\N
3626	1254	1487	176537
3627	1198	1489	\N
3628	1198	1490	\N
3629	1198	1491	507079
3630	1198	1493	728459
3631	1198	1494	333930
3632	1255	1491	600071
3633	1255	1492	769483
3634	1255	1493	988941
3635	1199	1496	\N
3636	1199	1498	683424
3637	1199	1499	819180
3638	1200	1500	126032
3639	1201	1502	\N
3640	1201	1503	\N
3641	1201	1504	\N
3642	1201	1505	\N
3643	1256	1501	\N
3644	1256	1502	\N
3645	1201	1506	705898
3646	1256	1506	650721
3647	1256	1507	695750
3648	1202	1508	\N
3649	1202	1509	542506
3650	1257	1509	908329
3651	1257	1511	956275
3652	1257	1512	797888
3653	1257	1513	682957
3654	1203	1514	\N
3655	1203	1515	\N
3656	1203	1516	\N
3657	1258	1514	\N
3658	1258	1515	\N
3659	1258	1516	\N
3660	1258	1518	\N
3661	1203	1519	966130
3662	1204	1520	\N
3663	1204	1521	\N
3664	1204	1522	\N
3665	1204	1523	\N
3666	1204	1525	\N
3667	1259	1521	\N
3668	1259	1523	\N
3669	1260	1526	\N
3670	1260	1527	\N
3671	1260	1528	\N
3672	1260	1529	\N
3673	1205	1530	675805
3674	1260	1530	110079
3675	1206	1531	\N
3676	1206	1532	889016
3677	1206	1533	677945
3678	1206	1534	452957
3679	1261	1532	604900
3680	1261	1533	375186
3681	1261	1535	894559
3682	1262	1537	\N
3683	1207	1538	440163
3684	1207	1540	464686
3685	1207	1542	306840
3686	1262	1538	701914
3687	1262	1539	542387
3688	1262	1540	687241
3689	1262	1541	162630
3690	1208	1544	\N
3691	1208	1545	\N
3692	1208	1546	244876
3693	1263	1547	123718
3694	1263	1548	316170
3695	1263	1549	535934
3696	1209	1550	\N
3697	1209	1551	\N
3698	1209	1553	\N
3699	1264	1550	\N
3700	1264	1551	\N
3701	1264	1552	\N
3702	1264	1553	\N
3703	1265	1554	\N
3704	1265	1555	343066
3705	1265	1556	924348
3706	1210	1557	\N
3707	1210	1558	\N
3708	1266	1557	\N
3709	1266	1558	\N
3710	1266	1559	\N
3711	1266	1560	\N
3712	1210	1561	623654
3713	1211	1563	\N
3714	1211	1564	\N
3715	1211	1566	\N
3716	1267	1562	\N
3717	1211	1567	478885
3718	1211	1568	230314
3719	1267	1568	162020
3720	1267	1570	494457
3721	1268	1572	\N
3722	1268	1574	\N
3723	1212	1575	987632
3724	1268	1576	358409
3725	1268	1578	675309
3726	1268	1579	255126
3727	1213	1581	822091
3728	1269	1580	799437
3729	1269	1582	288540
3730	1269	1583	963190
3731	1214	1584	\N
3732	1214	1585	\N
3733	1214	1587	\N
3734	1270	1584	\N
3735	1270	1585	\N
3736	1270	1587	\N
3737	1270	1588	\N
3738	1215	1590	388510
3739	1215	1591	155138
3740	1215	1592	745008
3741	1215	1593	288845
3742	1271	1589	275144
3743	1272	1595	412680
3744	1216	1596	\N
3745	1273	1596	\N
3746	1216	1597	858735
3747	1216	1598	376498
3748	1274	1599	\N
3749	1274	1600	608155
3750	1274	1601	812177
3751	1274	1603	695789
3752	1217	1604	\N
3753	1275	1604	\N
3754	1275	1605	\N
3755	1217	1606	814879
3756	1217	1607	637767
3757	1275	1607	640890
3758	1218	1608	\N
3759	1276	1608	\N
3760	1218	1609	775356
3761	1276	1609	789099
3762	1219	1610	\N
3763	1277	1610	\N
3764	1277	1611	\N
3765	1277	1612	\N
3766	1277	1613	412763
3767	1277	1614	176599
3768	1220	1615	\N
3769	1278	1616	\N
3770	1278	1617	\N
3771	1279	1619	\N
3772	1279	1620	\N
3773	1279	1622	559364
3774	1279	1623	407681
3775	1280	1624	\N
3776	1280	1625	\N
3777	1221	1627	423788
3778	1221	1628	530629
3779	1280	1627	864505
3780	1280	1628	683902
3781	1281	1629	\N
3782	1281	1631	\N
3783	1222	1632	480303
3784	1282	1633	\N
3785	1282	1634	320279
3786	1282	1635	448340
3787	1282	1636	182494
3788	1223	1637	451090
3789	1223	1638	443055
3790	1283	1639	\N
3791	1224	1640	929592
3792	1224	1642	159478
3793	1225	1644	\N
3794	1225	1645	287787
3795	1284	1646	295457
3796	1284	1647	910831
3797	1285	1648	\N
3798	1285	1649	\N
3799	1285	1650	\N
3800	1226	1651	796396
3801	1226	1653	138635
3802	1226	1655	267602
3803	1285	1651	810194
3804	1286	1656	\N
3805	1227	1657	501459
3806	1227	1658	410353
3807	1286	1657	966282
3808	1287	1659	135389
3809	1287	1660	659410
3810	1287	1661	577502
3811	1288	1662	302248
3812	1289	1663	\N
3813	1289	1664	872788
3814	1289	1666	923864
3815	1289	1667	315092
3816	1290	1669	\N
3817	1290	1670	\N
3818	1228	1671	235832
3819	1290	1671	621496
3820	1229	1672	716062
3821	1229	1673	346074
3822	1230	1675	\N
3823	1230	1676	\N
3824	1230	1677	\N
3825	1230	1678	375216
3826	1230	1680	709181
3827	1231	1681	850348
3828	1291	1682	881686
3829	1291	1683	931269
3830	1291	1684	889352
3831	1291	1685	775224
3832	1232	1686	\N
3833	1292	1687	592126
3834	1292	1688	280112
3835	1292	1689	624736
3836	1292	1690	272049
3837	1292	1692	929486
3838	1293	1693	\N
3839	1233	1694	\N
3840	1294	1694	\N
3841	1294	1695	\N
3842	1294	1696	859074
3843	1294	1698	571725
3844	1234	1700	\N
3845	1234	1701	\N
3846	1234	1703	\N
3847	1234	1705	\N
3848	1295	1699	\N
3849	1295	1700	\N
3850	1295	1702	\N
3851	1295	1707	704225
3852	1296	1708	\N
3853	1296	1709	635704
3854	1296	1710	914060
3855	1297	1712	\N
3856	1297	1713	220173
3857	1297	1714	308896
3858	1235	1715	\N
3859	1235	1716	657721
3860	1235	1717	542409
3861	1235	1718	374218
3862	1235	1719	123444
3863	1298	1716	327038
3864	1298	1717	216028
3865	1298	1718	771922
3866	1236	1720	\N
3867	1236	1721	\N
3868	1299	1720	\N
3869	1299	1721	\N
3870	1236	1722	738945
3871	1299	1723	828330
3872	1299	1724	713523
3873	1237	1725	708034
3874	1238	1727	\N
3875	1238	1729	298100
3876	1239	1730	821433
3877	1239	1731	356061
3878	1300	1730	269924
3879	1300	1731	518975
3880	1300	1733	750747
3881	1300	1735	692188
3882	1240	1736	\N
3883	1301	1736	\N
3884	1301	1738	\N
3885	1301	1740	\N
3886	1301	1741	547807
3887	1301	1742	951409
3888	1241	1743	\N
3889	1241	1745	696149
3890	1241	1746	862808
3891	1302	1744	458097
3892	1303	1747	\N
3893	1303	1749	\N
3894	1303	1750	\N
3895	1242	1751	\N
3896	1242	1753	\N
3897	1242	1754	137029
3898	1304	1754	941765
3899	1304	1755	217439
3900	1304	1756	675473
3901	1304	1757	187263
3902	1305	1758	\N
3903	1243	1759	471293
3904	1243	1760	494913
3905	1305	1759	165642
3906	1305	1760	168299
3907	1305	1761	689896
3908	1305	1763	925200
3909	1306	1764	\N
3910	1306	1765	\N
3911	1306	1766	\N
3912	1306	1767	\N
3913	1244	1768	262790
3914	1244	1769	813497
3915	1244	1770	675616
3916	1244	1771	140537
3917	1244	1772	608926
3918	1245	1773	\N
3919	1307	1774	437562
3920	1307	1775	481972
3921	1307	1776	661516
3922	1308	1777	\N
3923	1308	1779	892705
3924	1309	1780	\N
3925	1309	1782	\N
3926	1309	1783	446227
3927	1309	1785	685340
3928	1310	1787	\N
3929	1310	1788	653211
3930	1311	1789	\N
3931	1311	1791	\N
3932	1311	1792	\N
3933	1311	1793	994667
3934	1311	1795	341960
3935	1312	1796	473979
3936	1312	1797	403662
3937	1312	1799	162744
3938	1312	1801	555620
3939	1312	1802	270064
3940	1313	1803	114040
3941	1313	1804	713133
3942	1313	1805	120868
3943	1313	1806	845809
3944	1313	1807	316344
3945	1314	1808	\N
3946	1315	1809	\N
3947	1315	1811	\N
3948	1315	1812	\N
3949	1315	1813	\N
3950	1316	1814	\N
3951	1316	1815	\N
3952	1317	1816	\N
3953	1317	1817	\N
3954	1318	1818	271875
3955	1318	1819	793280
3956	1318	1820	421423
3957	1319	1821	\N
3958	1319	1822	685817
3959	1320	1823	\N
3960	1320	1824	762000
3961	1321	1826	\N
3962	1321	1828	916291
3963	1321	1829	521201
3964	1322	1830	\N
3965	1323	1832	\N
3966	1323	1833	966250
3967	1382	1833	990088
3968	1382	1834	329225
3969	1382	1836	963847
3970	1324	1837	\N
3971	1383	1837	\N
3972	1383	1838	\N
3973	1383	1839	\N
3974	1383	1841	273794
3975	1325	1843	\N
3976	1325	1844	261258
3977	1326	1845	875828
3978	1326	1846	998306
3979	1326	1847	918061
3980	1326	1848	977634
3981	1384	1845	419777
3982	1385	1849	\N
3983	1385	1850	\N
3984	1385	1851	\N
3985	1385	1852	\N
3986	1385	1853	\N
3987	1327	1855	924502
3988	1328	1856	\N
3989	1328	1857	579800
3990	1328	1858	208048
3991	1328	1859	704044
3992	1386	1857	523695
3993	1329	1860	\N
3994	1387	1861	318382
3995	1387	1862	130318
3996	1387	1864	352450
3997	1387	1865	499641
3998	1388	1866	\N
3999	1388	1867	667435
4000	1388	1868	845206
4001	1388	1869	495773
4002	1389	1870	\N
4003	1330	1872	153800
4004	1330	1873	632928
4005	1330	1874	158390
4006	1330	1875	593471
4007	1330	1876	887080
4008	1389	1871	511062
4009	1331	1878	\N
4010	1390	1877	\N
4011	1390	1878	\N
4012	1390	1880	\N
4013	1390	1881	\N
4014	1390	1882	131602
4015	1332	1884	\N
4016	1391	1883	\N
4017	1391	1884	\N
4018	1391	1886	\N
4019	1391	1887	\N
4020	1392	1888	\N
4021	1392	1890	\N
4022	1392	1891	832966
4023	1392	1892	769815
4024	1392	1893	363351
4025	1333	1894	\N
4026	1393	1894	\N
4027	1333	1895	956293
4028	1333	1896	553495
4029	1333	1897	466679
4030	1333	1899	689909
4031	1334	1901	\N
4032	1394	1900	\N
4033	1394	1901	\N
4034	1394	1902	\N
4035	1334	1903	888209
4036	1395	1905	\N
4037	1395	1907	\N
4038	1395	1908	\N
4039	1395	1909	\N
4040	1335	1910	\N
4041	1335	1911	\N
4042	1335	1912	\N
4043	1396	1913	647821
4044	1336	1914	\N
4045	1397	1914	\N
4046	1397	1915	\N
4047	1397	1916	\N
4048	1397	1917	\N
4049	1336	1919	525075
4050	1336	1920	927446
4051	1337	1921	\N
4052	1398	1921	\N
4053	1337	1923	332072
4054	1398	1922	119386
4055	1398	1924	849301
4056	1398	1925	555527
4057	1338	1926	\N
4058	1399	1926	\N
4059	1399	1927	\N
4060	1399	1929	\N
4061	1338	1931	822410
4062	1338	1932	822242
4063	1339	1933	\N
4064	1400	1933	\N
4065	1339	1934	962347
4066	1339	1935	745938
4067	1339	1936	385134
4068	1400	1934	556777
4069	1340	1937	\N
4070	1340	1938	993844
4071	1340	1940	673348
4072	1340	1941	395761
4073	1340	1942	524238
4074	1401	1938	210671
4075	1401	1939	282706
4076	1341	1943	\N
4077	1402	1944	\N
4078	1402	1946	\N
4079	1402	1947	\N
4080	1402	1948	\N
4081	1402	1949	\N
4082	1341	1950	395026
4083	1341	1952	650430
4084	1341	1953	939970
4085	1403	1954	\N
4086	1403	1955	\N
4087	1403	1956	\N
4088	1342	1957	993764
4089	1342	1958	255993
4090	1342	1960	180905
4091	1342	1961	916527
4092	1403	1957	580764
4093	1343	1962	\N
4094	1404	1962	\N
4095	1404	1963	\N
4096	1404	1964	\N
4097	1404	1965	\N
4098	1404	1966	\N
4099	1344	1967	\N
4100	1344	1968	174504
4101	1344	1969	408233
4102	1405	1969	730596
4103	1345	1970	\N
4104	1406	1970	\N
4105	1406	1972	\N
4106	1406	1973	152647
4107	1406	1974	817075
4108	1406	1975	694306
4109	1407	1976	\N
4110	1407	1978	\N
4111	1407	1979	\N
4112	1407	1981	\N
4113	1346	1982	753855
4114	1407	1982	842967
4115	1408	1983	\N
4116	1408	1984	\N
4117	1408	1985	\N
4118	1408	1986	\N
4119	1408	1987	380506
4120	1409	1988	113780
4121	1409	1989	265177
4122	1410	1990	\N
4123	1410	1991	\N
4124	1410	1992	\N
4125	1410	1993	\N
4126	1347	1994	745317
4127	1348	1996	\N
4128	1348	1997	\N
4129	1348	1999	907254
4130	1348	0	240779
4131	1348	1	251124
4132	1349	2	\N
4133	1349	3	\N
4134	1349	4	\N
4135	1349	6	\N
4136	1411	2	\N
4137	1411	3	\N
4138	1411	4	\N
4139	1349	7	750131
4140	1411	7	649797
4141	1350	8	\N
4142	1350	9	\N
4143	1350	10	\N
4144	1350	12	\N
4145	1412	8	\N
4146	1412	14	843404
4147	1412	16	421612
4148	1412	18	772912
4149	1351	19	\N
4150	1351	21	\N
4151	1351	23	\N
4152	1413	19	\N
4153	1413	20	\N
4154	1413	21	\N
4155	1351	24	683858
4156	1413	24	895730
4157	1413	26	583047
4158	1414	27	\N
4159	1414	28	\N
4160	1352	29	555282
4161	1352	30	425397
4162	1353	31	\N
4163	1415	31	\N
4164	1353	33	172567
4165	1353	34	139488
4166	1415	32	738887
4167	1415	33	621838
4168	1415	34	895490
4169	1415	36	699731
4170	1416	38	\N
4171	1354	40	917800
4172	1355	41	\N
4173	1355	42	\N
4174	1355	43	567890
4175	1355	45	270550
4176	1355	46	222582
4177	1417	44	333467
4178	1356	48	927942
4179	1356	50	154577
4180	1356	51	928694
4181	1356	52	881973
4182	1356	53	588147
4183	1418	47	945680
4184	1418	48	379905
4185	1418	49	705918
4186	1418	50	620598
4187	1419	54	\N
4188	1357	56	298936
4189	1419	55	276104
4190	1419	56	389837
4191	1419	58	836376
4192	1419	59	483064
4193	1358	60	\N
4194	1420	60	\N
4195	1420	61	\N
4196	1358	62	419870
4197	1358	63	566816
4198	1420	62	413557
4199	1420	63	325879
4200	1421	64	\N
4201	1421	66	\N
4202	1421	67	\N
4203	1359	68	452385
4204	1421	68	815347
4205	1360	70	\N
4206	1360	71	\N
4207	1360	72	\N
4208	1360	73	\N
4209	1422	70	\N
4210	1360	74	583892
4211	1422	74	633261
4212	1422	75	799278
4213	1422	76	699018
4214	1423	78	\N
4215	1423	79	\N
4216	1423	80	\N
4217	1423	81	\N
4218	1361	82	691016
4219	1423	82	173914
4220	1362	83	\N
4221	1424	84	169621
4222	1424	85	442243
4223	1424	86	240646
4224	1363	87	\N
4225	1425	87	\N
4226	1425	88	\N
4227	1363	90	766133
4228	1364	91	\N
4229	1364	93	569267
4230	1364	94	143862
4231	1426	93	661974
4232	1365	95	\N
4233	1365	97	\N
4234	1365	98	\N
4235	1427	95	\N
4236	1366	100	\N
4237	1366	102	\N
4238	1366	103	395237
4239	1428	104	264229
4240	1429	105	\N
4241	1429	106	\N
4242	1429	108	785839
4243	1429	110	863842
4244	1429	112	716999
4245	1430	113	\N
4246	1430	114	\N
4247	1430	115	412964
4248	1430	117	876925
4249	1367	119	\N
4250	1367	120	\N
4251	1367	121	\N
4252	1367	122	201278
4253	1368	123	\N
4254	1368	125	\N
4255	1368	126	\N
4256	1431	127	549102
4257	1369	128	\N
4258	1369	129	\N
4259	1432	128	\N
4260	1369	130	671273
4261	1369	131	364536
4262	1369	132	859721
4263	1370	133	270831
4264	1370	134	650192
4265	1370	135	887697
4266	1370	137	991482
4267	1371	139	632833
4268	1371	140	735329
4269	1371	141	702959
4270	1371	142	592011
4271	1371	144	991866
4272	1372	145	\N
4273	1372	146	848169
4274	1372	148	673286
4275	1373	149	225504
4276	1373	150	184789
4277	1373	151	491309
4278	1374	153	\N
4279	1374	154	366441
4280	1375	155	894006
4281	1376	156	\N
4282	1376	158	851229
4283	1376	159	123814
4284	1376	161	365464
4285	1377	162	\N
4286	1377	163	559796
4287	1377	164	513702
4288	1378	166	\N
4289	1378	167	296583
4290	1378	168	187641
4291	1378	169	715662
4292	1378	171	892674
4293	1379	173	\N
4294	1379	174	421159
4295	1379	176	558088
4296	1379	177	133466
4297	1380	179	\N
4298	1380	181	\N
4299	1380	182	\N
4300	1381	184	799187
4301	1433	185	\N
4302	1433	186	\N
4303	1433	187	\N
4304	1472	186	\N
4305	1473	188	\N
4306	1473	189	\N
4307	1434	190	492196
4308	1434	191	147421
4309	1473	191	359856
4310	1473	192	218862
4311	1473	193	646890
4312	1435	195	\N
4313	1435	197	\N
4314	1474	199	\N
4315	1474	200	\N
4316	1474	201	\N
4317	1474	202	\N
4318	1436	203	908012
4319	1436	204	889302
4320	1437	205	\N
4321	1437	206	\N
4322	1475	205	\N
4323	1475	207	\N
4324	1475	208	357828
4325	1438	209	\N
4326	1438	210	\N
4327	1438	211	\N
4328	1476	209	\N
4329	1438	212	685489
4330	1438	214	129706
4331	1476	212	937352
4332	1476	213	582527
4333	1477	215	\N
4334	1477	216	\N
4335	1439	217	592782
4336	1440	218	\N
4337	1478	218	\N
4338	1440	220	930217
4339	1440	221	545577
4340	1440	223	232464
4341	1478	219	924469
4342	1479	224	\N
4343	1479	225	\N
4344	1479	227	\N
4345	1479	228	\N
4346	1479	229	\N
4347	1441	230	371634
4348	1441	231	661235
4349	1480	233	\N
4350	1480	234	\N
4351	1480	235	769427
4352	1480	236	336946
4353	1442	237	\N
4354	1481	237	\N
4355	1481	239	\N
4356	1481	240	\N
4357	1442	241	965236
4358	1442	242	596969
4359	1442	243	777790
4360	1442	245	496916
4361	1481	242	639732
4362	1481	243	956832
4363	1443	247	\N
4364	1482	247	\N
4365	1482	249	\N
4366	1482	250	\N
4367	1443	252	175565
4368	1444	253	\N
4369	1483	254	\N
4370	1444	255	659831
4371	1444	256	275303
4372	1483	255	814903
4373	1445	257	\N
4374	1484	258	\N
4375	1445	260	270143
4376	1445	261	200386
4377	1445	263	933110
4378	1445	264	200613
4379	1484	259	440409
4380	1446	265	\N
4381	1446	266	\N
4382	1446	267	\N
4383	1485	266	\N
4384	1485	268	914630
4385	1485	269	991149
4386	1485	270	315009
4387	1447	271	708170
4388	1486	272	\N
4389	1486	274	682191
4390	1487	275	201968
4391	1448	276	\N
4392	1448	277	\N
4393	1448	278	\N
4394	1448	280	\N
4395	1448	282	141949
4396	1449	283	\N
4397	1450	284	\N
4398	1450	285	\N
4399	1450	286	\N
4400	1450	287	\N
4401	1450	288	862917
4402	1488	289	\N
4403	1451	290	\N
4404	1489	290	\N
4405	1489	292	\N
4406	1451	293	769274
4407	1451	294	675639
4408	1451	295	861888
4409	1489	294	276509
4410	1489	295	146652
4411	1452	297	\N
4412	1453	298	\N
4413	1490	298	\N
4414	1490	299	\N
4415	1454	301	\N
4416	1454	302	\N
4417	1454	303	\N
4418	1454	304	\N
4419	1491	301	\N
4420	1491	302	\N
4421	1491	303	\N
4422	1455	305	\N
4423	1455	306	\N
4424	1455	307	\N
4425	1492	308	674460
4426	1456	309	\N
4427	1456	310	\N
4428	1493	309	\N
4429	1493	311	843069
4430	1457	312	400470
4431	1457	314	336263
4432	1457	315	144790
4433	1457	316	213856
4434	1457	317	544316
4435	1494	312	426273
4436	1458	318	\N
4437	1458	319	\N
4438	1458	320	\N
4439	1458	321	\N
4440	1458	322	\N
4441	1459	324	\N
4442	1459	326	\N
4443	1495	323	\N
4444	1495	324	\N
4445	1495	325	\N
4446	1459	327	914584
4447	1459	328	943284
4448	1495	327	187330
4449	1460	329	\N
4450	1460	330	\N
4451	1460	331	\N
4452	1460	332	189352
4453	1496	332	869493
4454	1496	333	550994
4455	1496	334	350777
4456	1496	335	912174
4457	1461	336	\N
4458	1461	337	\N
4459	1461	338	\N
4460	1497	336	\N
4461	1461	339	276991
4462	1497	339	794407
4463	1498	340	624079
4464	1462	341	\N
4465	1462	343	\N
4466	1499	344	891165
4467	1463	346	343305
4468	1463	348	899264
4469	1463	350	653789
4470	1463	351	592831
4471	1464	353	\N
4472	1500	352	\N
4473	1500	353	\N
4474	1464	354	839734
4475	1500	354	984569
4476	1500	355	499587
4477	1500	356	227237
4478	1465	357	\N
4479	1465	358	634528
4480	1501	358	458916
4481	1501	360	674777
4482	1501	361	571148
4483	1501	362	109075
4484	1501	363	635127
4485	1466	365	\N
4486	1466	367	\N
4487	1466	368	\N
4488	1466	369	339093
4489	1466	370	267343
4490	1502	369	131919
4491	1502	370	630876
4492	1502	371	283948
4493	1502	372	871771
4494	1502	373	419182
4495	1503	375	\N
4496	1467	376	919523
4497	1503	377	697030
4498	1503	378	649570
4499	1503	379	414424
4500	1503	381	717661
4501	1468	382	\N
4502	1468	384	\N
4503	1504	383	\N
4504	1468	386	591695
4505	1504	385	979941
4506	1504	386	954299
4507	1469	387	\N
4508	1469	388	\N
4509	1505	387	\N
4510	1469	389	478298
4511	1469	390	838365
4512	1469	392	557979
4513	1505	389	142114
4514	1506	394	\N
4515	1506	395	\N
4516	1506	396	424500
4517	1506	398	784587
4518	1506	400	489391
4519	1470	401	\N
4520	1507	401	\N
4521	1507	402	\N
4522	1507	404	\N
4523	1507	405	\N
4524	1470	406	193822
4525	1508	408	\N
4526	1471	409	917472
4527	1508	410	673097
4528	1509	411	\N
4529	1509	413	902653
4530	1509	414	480485
4531	1509	415	951554
4532	1509	416	748091
4533	1510	417	433990
4534	1510	419	156849
4535	1511	420	489836
4536	1511	422	337464
4537	1511	424	152499
4538	1512	425	\N
4539	1512	426	\N
4540	1512	427	425770
4541	1512	428	736720
4542	1513	429	575708
4543	1513	430	516112
4544	1513	431	103527
4545	1514	433	333999
4546	1515	434	\N
4547	1515	435	262906
4548	1516	436	\N
4549	1516	438	\N
4550	1516	440	356622
4551	1517	441	\N
4552	1517	442	372412
4553	1517	443	568199
4554	1517	445	275342
4555	1517	446	770302
4556	1518	447	366737
4557	1518	448	273483
4558	1519	449	174662
4559	1519	450	287421
4560	1519	451	329013
4561	1520	452	\N
4562	1520	453	\N
4563	1520	454	621382
4564	1520	455	617545
4565	1520	456	748825
4566	1521	458	\N
4567	1521	459	\N
4568	1521	460	195704
4569	1522	462	584958
4570	1522	463	308664
4571	1523	464	\N
4572	1524	465	\N
4573	1524	466	\N
4574	1524	467	\N
4575	1524	468	833382
4576	1525	469	\N
4577	1525	470	\N
4578	1525	471	864789
4579	1526	472	\N
4580	1527	473	\N
4581	1527	474	\N
4582	1528	476	786844
4583	1528	477	126812
4584	1528	478	879265
4585	1529	480	815343
4586	1530	481	\N
4587	1530	482	\N
4588	1530	483	\N
4589	1572	481	\N
4590	1572	483	\N
4591	1656	481	\N
4592	1656	482	\N
4593	1530	484	570012
4594	1572	484	153430
4595	1656	485	137558
4596	1656	486	583536
4597	1573	487	\N
4598	1573	488	\N
4599	1531	489	963111
4600	1531	490	558788
4601	1531	491	503306
4602	1531	492	813727
4603	1573	489	119727
4604	1657	489	172840
4605	1574	493	\N
4606	1574	495	\N
4607	1532	497	357986
4608	1532	498	144407
4609	1574	497	992514
4610	1658	496	634513
4611	1658	497	356489
4612	1658	498	327572
4613	1533	499	\N
4614	1533	500	\N
4615	1533	501	\N
4616	1575	500	\N
4617	1575	501	\N
4618	1659	500	\N
4619	1533	502	141522
4620	1575	503	256481
4621	1575	504	112280
4622	1576	505	\N
4623	1576	506	\N
4624	1576	507	\N
4625	1534	508	843840
4626	1577	509	\N
4627	1660	510	\N
4628	1577	511	143437
4629	1535	512	\N
4630	1535	514	\N
4631	1535	515	\N
4632	1578	512	\N
4633	1578	513	\N
4634	1535	516	929796
4635	1661	516	247231
4636	1661	517	482624
4637	1661	518	131072
4638	1579	520	\N
4639	1579	522	\N
4640	1579	523	\N
4641	1536	524	873494
4642	1536	525	164555
4643	1579	524	343455
4644	1662	525	735945
4645	1662	526	919504
4646	1662	527	476168
4647	1662	528	405331
4648	1662	529	610241
4649	1537	530	\N
4650	1580	531	\N
4651	1580	532	\N
4652	1580	534	\N
4653	1580	536	\N
4654	1580	538	141623
4655	1663	537	892202
4656	1663	538	329638
4657	1538	540	\N
4658	1538	541	853024
4659	1538	542	688542
4660	1538	543	638771
4661	1539	544	\N
4662	1539	545	\N
4663	1581	544	\N
4664	1581	546	\N
4665	1581	547	\N
4666	1664	544	\N
4667	1664	545	\N
4668	1539	548	801573
4669	1539	549	729310
4670	1581	548	956396
4671	1664	549	191282
4672	1540	551	\N
4673	1540	553	\N
4674	1540	554	\N
4675	1582	550	\N
4676	1582	551	\N
4677	1582	552	\N
4678	1582	553	\N
4679	1582	555	\N
4680	1665	550	\N
4681	1541	557	\N
4682	1666	556	\N
4683	1666	557	\N
4684	1666	558	\N
4685	1541	559	675446
4686	1583	559	410837
4687	1583	560	352497
4688	1583	561	514013
4689	1542	562	\N
4690	1542	564	\N
4691	1542	565	\N
4692	1667	562	\N
4693	1667	563	\N
4694	1542	566	371509
4695	1584	566	200339
4696	1584	568	247638
4697	1667	566	769827
4698	1543	569	\N
4699	1543	570	\N
4700	1668	572	264276
4701	1668	573	987224
4702	1669	574	\N
4703	1669	575	742189
4704	1669	576	669486
4705	1585	577	\N
4706	1670	578	\N
4707	1544	579	711618
4708	1544	581	936142
4709	1544	582	725869
4710	1544	584	705108
4711	1585	579	605240
4712	1670	579	366302
4713	1670	581	704996
4714	1545	585	\N
4715	1545	586	\N
4716	1545	588	\N
4717	1545	590	747260
4718	1545	592	391841
4719	1546	593	\N
4720	1546	594	\N
4721	1586	593	\N
4722	1671	596	818434
4723	1547	598	\N
4724	1547	599	\N
4725	1547	600	\N
4726	1547	602	490219
4727	1587	602	556067
4728	1587	604	891001
4729	1587	606	299360
4730	1672	601	393257
4731	1672	602	803802
4732	1548	607	\N
4733	1548	608	\N
4734	1588	607	\N
4735	1588	608	\N
4736	1588	609	\N
4737	1673	607	\N
4738	1548	610	604303
4739	1548	611	819558
4740	1588	610	839540
4741	1549	612	\N
4742	1589	612	\N
4743	1589	613	\N
4744	1549	614	483639
4745	1549	615	886675
4746	1589	614	508899
4747	1589	615	410704
4748	1674	614	237521
4749	1674	615	811605
4750	1674	617	618789
4751	1550	618	\N
4752	1550	619	\N
4753	1550	620	\N
4754	1550	621	830251
4755	1550	622	991807
4756	1675	621	884488
4757	1675	622	895581
4758	1675	623	892288
4759	1676	624	\N
4760	1676	625	\N
4761	1676	627	\N
4762	1676	628	\N
4763	1551	629	841131
4764	1551	630	795151
4765	1551	631	178439
4766	1551	632	984398
4767	1552	633	\N
4768	1552	634	828932
4769	1552	635	791390
4770	1677	634	318634
4771	1677	635	861071
4772	1677	636	110524
4773	1677	637	941207
4774	1677	638	428023
4775	1590	640	\N
4776	1590	642	\N
4777	1590	644	\N
4778	1678	639	\N
4779	1678	640	\N
4780	1678	641	\N
4781	1590	645	502645
4782	1590	646	553102
4783	1678	646	758812
4784	1678	647	958393
4785	1553	648	\N
4786	1553	649	\N
4787	1679	650	636670
4788	1679	652	250272
4789	1679	653	163133
4790	1679	654	807743
4791	1554	655	\N
4792	1554	657	649654
4793	1554	658	666524
4794	1554	659	550397
4795	1591	656	244131
4796	1680	656	557193
4797	1555	660	\N
4798	1555	662	\N
4799	1681	660	\N
4800	1592	663	\N
4801	1592	664	\N
4802	1592	665	\N
4803	1682	663	\N
4804	1682	665	\N
4805	1556	666	308805
4806	1592	666	776579
4807	1682	666	350866
4808	1682	667	893063
4809	1682	668	930624
4810	1557	669	\N
4811	1557	670	\N
4812	1593	669	\N
4813	1683	671	383209
4814	1683	673	397947
4815	1683	674	781548
4816	1683	675	955311
4817	1558	676	\N
4818	1558	677	\N
4819	1558	678	\N
4820	1558	680	\N
4821	1558	681	\N
4822	1684	677	\N
4823	1684	682	990206
4824	1684	683	384472
4825	1684	684	718702
4826	1684	686	496102
4827	1559	687	\N
4828	1685	687	\N
4829	1685	688	\N
4830	1559	689	157549
4831	1560	690	\N
4832	1560	691	794986
4833	1594	691	122002
4834	1594	692	698551
4835	1594	693	100357
4836	1686	692	692378
4837	1686	693	514679
4838	1595	694	\N
4839	1595	695	\N
4840	1595	697	\N
4841	1595	699	\N
4842	1595	701	\N
4843	1687	702	\N
4844	1687	703	\N
4845	1687	704	915256
4846	1561	705	\N
4847	1561	706	\N
4848	1596	705	\N
4849	1688	707	161334
4850	1688	708	488216
4851	1688	709	603560
4852	1597	710	\N
4853	1597	711	\N
4854	1689	710	\N
4855	1689	711	\N
4856	1689	713	\N
4857	1562	715	167574
4858	1562	716	413742
4859	1562	718	944084
4860	1562	719	135292
4861	1562	720	304211
4862	1689	714	689014
4863	1563	722	\N
4864	1563	723	\N
4865	1598	721	\N
4866	1598	722	\N
4867	1598	723	\N
4868	1690	721	\N
4869	1690	722	\N
4870	1690	723	\N
4871	1690	725	\N
4872	1563	727	476243
4873	1563	728	612117
4874	1598	727	553054
4875	1564	729	\N
4876	1599	729	\N
4877	1564	730	535622
4878	1564	731	261509
4879	1564	732	989343
4880	1600	733	\N
4881	1600	735	\N
4882	1565	736	121449
4883	1601	737	\N
4884	1601	739	\N
4885	1601	740	\N
4886	1601	741	\N
4887	1566	742	876153
4888	1566	743	675201
4889	1602	745	\N
4890	1567	746	269335
4891	1567	748	865613
4892	1567	749	777818
4893	1567	750	530037
4894	1602	746	415463
4895	1602	747	591232
4896	1602	749	184518
4897	1568	751	\N
4898	1568	753	\N
4899	1568	754	\N
4900	1568	755	\N
4901	1603	751	\N
4902	1568	756	833578
4903	1603	756	941818
4904	1569	757	\N
4905	1604	757	\N
4906	1604	758	\N
4907	1604	759	974991
4908	1604	760	437622
4909	1604	762	881797
4910	1570	763	\N
4911	1570	765	\N
4912	1570	767	355325
4913	1570	769	840657
4914	1605	766	591242
4915	1605	767	491619
4916	1605	768	215117
4917	1605	769	829095
4918	1605	770	789329
4919	1571	771	\N
4920	1606	771	\N
4921	1606	772	\N
4922	1571	773	402906
4923	1571	775	846603
4924	1571	776	557397
4925	1571	777	732750
4926	1606	773	538027
4927	1606	774	619198
4928	1607	778	431491
4929	1607	779	520668
4930	1607	781	537417
4931	1608	783	274991
4932	1608	784	450504
4933	1608	785	126932
4934	1608	787	306770
4935	1609	788	\N
4936	1609	789	617537
4937	1609	790	532687
4938	1609	792	182882
4939	1609	793	903786
4940	1610	794	\N
4941	1610	795	\N
4942	1610	796	964023
4943	1610	797	275425
4944	1611	798	307644
4945	1612	799	\N
4946	1613	800	\N
4947	1613	802	\N
4948	1613	803	\N
4949	1613	804	512045
4950	1613	806	208872
4951	1614	808	\N
4952	1614	809	\N
4953	1614	811	\N
4954	1614	812	\N
4955	1614	814	197558
4956	1615	815	\N
4957	1615	816	551182
4958	1616	817	\N
4959	1616	818	\N
4960	1616	819	431969
4961	1616	820	502950
4962	1617	822	\N
4963	1617	824	\N
4964	1617	825	\N
4965	1618	826	\N
4966	1618	828	\N
4967	1618	830	747597
4968	1618	831	197551
4969	1618	832	416182
4970	1619	833	\N
4971	1619	834	\N
4972	1619	835	\N
4973	1619	837	\N
4974	1619	838	\N
4975	1620	839	716792
4976	1621	841	\N
4977	1621	842	\N
4978	1621	843	\N
4979	1621	844	818558
4980	1621	845	875654
4981	1622	847	\N
4982	1622	849	491052
4983	1622	851	518842
4984	1623	852	\N
4985	1623	854	\N
4986	1623	856	\N
4987	1623	857	439965
4988	1623	859	909971
4989	1624	860	\N
4990	1624	862	477984
4991	1625	863	\N
4992	1625	865	199534
4993	1626	866	\N
4994	1626	868	\N
4995	1626	869	\N
4996	1626	870	671841
4997	1627	871	\N
4998	1627	873	370101
4999	1627	874	456105
5000	1627	875	261305
5001	1628	876	\N
5002	1628	878	\N
5003	1628	879	\N
5004	1628	880	768889
5005	1629	882	\N
5006	1629	883	\N
5007	1629	884	\N
5008	1629	885	479678
5009	1630	886	\N
5010	1630	887	\N
5011	1630	888	593056
5012	1631	889	\N
5013	1632	890	\N
5014	1632	892	\N
5015	1633	893	458571
5016	1633	894	240021
5017	1633	895	742798
5018	1633	896	598458
5019	1633	897	887778
5020	1634	898	\N
5021	1634	899	882637
5022	1634	900	342898
5023	1634	901	779808
5024	1634	903	457051
5025	1635	904	772887
5026	1635	905	567916
5027	1635	906	968915
5028	1636	907	\N
5029	1636	908	\N
5030	1636	910	\N
5031	1636	912	972137
5032	1637	914	\N
5033	1637	916	994677
5034	1637	917	110742
5035	1638	918	\N
5036	1638	920	\N
5037	1638	922	\N
5038	1638	923	\N
5039	1639	925	\N
5040	1639	926	\N
5041	1639	928	538765
5042	1639	929	644282
5043	1640	930	\N
5044	1640	931	\N
5045	1640	932	\N
5046	1640	934	\N
5047	1640	935	\N
5048	1641	936	\N
5049	1641	938	\N
5050	1641	939	\N
5051	1641	940	\N
5052	1641	941	\N
5053	1642	942	\N
5054	1642	943	583234
5055	1642	944	752172
5056	1642	945	417299
5057	1642	946	146555
5058	1643	947	195093
5059	1643	948	225417
5060	1643	949	556496
5061	1643	951	235135
5062	1644	952	\N
5063	1644	953	\N
5064	1644	954	\N
5065	1644	955	\N
5066	1644	956	\N
5067	1645	957	\N
5068	1645	958	\N
5069	1645	959	667313
5070	1645	961	356948
5071	1646	963	\N
5072	1646	964	\N
5073	1646	966	\N
5074	1647	967	\N
5075	1648	968	923405
5076	1648	969	907477
5077	1648	970	984240
5078	1649	971	\N
5079	1649	973	864848
5080	1649	974	486692
5081	1650	976	\N
5082	1651	977	\N
5083	1651	979	\N
5084	1651	980	759932
5085	1652	981	\N
5086	1652	982	\N
5087	1652	983	\N
5088	1652	984	840348
5089	1652	985	558478
5090	1653	986	977377
5091	1653	988	102121
5092	1653	989	560783
5093	1654	990	\N
5094	1654	991	\N
5095	1654	992	547128
5096	1655	994	574725
5097	1655	995	122929
5098	1770	996	\N
5099	1770	997	\N
5100	1770	998	\N
5101	1691	999	241217
5102	1770	1000	169526
5103	1844	1000	512256
5104	1844	1002	956290
5105	1692	1003	\N
5106	1692	1004	\N
5107	1692	1005	\N
5108	1692	1007	\N
5109	1771	1003	\N
5110	1771	1004	\N
5111	1771	1005	\N
5112	1771	1006	\N
5113	1845	1003	\N
5114	1692	1009	848639
5115	1771	1008	864722
5116	1845	1008	843597
5117	1845	1009	880171
5118	1693	1011	\N
5119	1846	1010	\N
5120	1846	1012	\N
5121	1693	1013	532454
5122	1693	1014	107166
5123	1693	1015	426814
5124	1693	1016	556620
5125	1694	1017	\N
5126	1847	1018	226311
5127	1848	1019	\N
5128	1695	1020	768154
5129	1695	1021	930056
5130	1695	1023	129384
5131	1695	1024	788014
5132	1695	1025	974227
5133	1848	1020	986152
5134	1848	1021	164590
5135	1848	1022	833928
5136	1848	1023	290744
5137	1849	1026	\N
5138	1772	1028	518103
5139	1772	1029	807051
5140	1772	1031	390022
5141	1772	1033	698983
5142	1772	1034	343799
5143	1696	1035	\N
5144	1696	1036	974555
5145	1696	1038	747072
5146	1696	1039	901907
5147	1773	1036	249789
5148	1773	1037	129841
5149	1773	1038	992313
5150	1773	1039	900872
5151	1773	1040	771875
5152	1774	1042	\N
5153	1774	1043	\N
5154	1697	1044	\N
5155	1697	1045	145390
5156	1697	1046	206859
5157	1775	1047	\N
5158	1850	1048	\N
5159	1775	1049	274206
5160	1775	1050	635047
5161	1775	1051	603495
5162	1775	1052	655319
5163	1850	1050	370222
5164	1850	1051	719600
5165	1850	1052	512477
5166	1698	1054	\N
5167	1698	1055	\N
5168	1698	1056	\N
5169	1776	1053	\N
5170	1776	1054	\N
5171	1698	1057	796409
5172	1698	1059	444953
5173	1776	1057	695786
5174	1851	1057	277143
5175	1851	1059	958665
5176	1851	1061	892543
5177	1851	1062	898755
5178	1699	1063	\N
5179	1699	1064	\N
5180	1777	1063	\N
5181	1777	1064	\N
5182	1852	1066	\N
5183	1700	1067	164008
5184	1778	1068	580002
5185	1852	1067	912756
5186	1852	1069	798468
5187	1701	1070	\N
5188	1701	1071	\N
5189	1779	1071	\N
5190	1779	1072	\N
5191	1779	1073	\N
5192	1853	1071	\N
5193	1853	1073	\N
5194	1853	1074	\N
5195	1853	1075	\N
5196	1853	1076	318200
5197	1780	1077	\N
5198	1780	1078	\N
5199	1780	1079	386418
5200	1854	1080	760199
5201	1702	1081	\N
5202	1702	1082	\N
5203	1781	1081	\N
5204	1781	1082	\N
5205	1855	1082	\N
5206	1855	1084	\N
5207	1855	1086	\N
5208	1855	1087	\N
5209	1855	1088	\N
5210	1702	1090	171969
5211	1781	1089	729458
5212	1781	1090	691258
5213	1781	1091	115269
5214	1703	1093	308245
5215	1703	1095	819102
5216	1703	1096	400929
5217	1703	1097	618469
5218	1703	1098	107304
5219	1782	1092	794725
5220	1782	1094	255237
5221	1856	1092	465587
5222	1856	1093	421854
5223	1856	1094	939487
5224	1856	1095	911997
5225	1857	1100	\N
5226	1704	1102	289879
5227	1783	1104	\N
5228	1858	1103	\N
5229	1858	1104	\N
5230	1858	1105	\N
5231	1705	1106	472211
5232	1705	1108	575767
5233	1705	1109	938138
5234	1705	1110	353133
5235	1783	1106	342297
5236	1706	1112	\N
5237	1784	1111	\N
5238	1859	1111	\N
5239	1859	1112	\N
5240	1706	1113	699524
5241	1706	1115	848035
5242	1706	1116	585036
5243	1706	1117	566925
5244	1859	1113	974549
5245	1859	1114	295789
5246	1860	1118	\N
5247	1707	1119	691976
5248	1860	1119	604959
5249	1785	1120	\N
5250	1785	1121	592155
5251	1785	1123	965099
5252	1785	1125	288679
5253	1785	1127	945205
5254	1861	1121	340123
5255	1861	1122	893919
5256	1786	1128	\N
5257	1786	1130	\N
5258	1862	1129	\N
5259	1862	1131	584082
5260	1787	1133	\N
5261	1863	1132	\N
5262	1787	1134	480501
5263	1787	1136	392449
5264	1787	1137	547935
5265	1863	1134	455637
5266	1863	1135	338187
5267	1863	1136	823190
5268	1708	1139	\N
5269	1708	1141	\N
5270	1864	1139	\N
5271	1864	1140	\N
5272	1708	1143	344851
5273	1708	1144	494460
5274	1788	1142	600548
5275	1788	1143	123549
5276	1788	1144	210047
5277	1788	1145	739999
5278	1788	1146	760249
5279	1864	1143	293919
5280	1864	1144	101315
5281	1709	1147	\N
5282	1709	1148	\N
5283	1789	1147	\N
5284	1789	1149	\N
5285	1789	1150	\N
5286	1789	1151	\N
5287	1865	1147	\N
5288	1865	1148	\N
5289	1865	1149	\N
5290	1865	1153	745097
5291	1865	1154	628752
5292	1790	1155	\N
5293	1790	1156	551383
5294	1790	1158	370395
5295	1791	1159	\N
5296	1791	1161	\N
5297	1791	1163	\N
5298	1866	1159	\N
5299	1866	1160	\N
5300	1710	1165	864095
5301	1710	1166	781023
5302	1791	1165	274012
5303	1866	1164	750528
5304	1866	1165	886230
5305	1866	1166	525800
5306	1711	1168	\N
5307	1711	1170	\N
5308	1711	1171	\N
5309	1792	1168	\N
5310	1867	1168	\N
5311	1867	1170	\N
5312	1867	1171	\N
5313	1711	1172	345254
5314	1711	1173	810411
5315	1792	1172	805937
5316	1792	1173	999064
5317	1867	1172	384184
5318	1712	1174	\N
5319	1712	1176	\N
5320	1712	1177	\N
5321	1868	1174	\N
5322	1868	1175	\N
5323	1712	1178	272508
5324	1868	1178	574464
5325	1713	1180	\N
5326	1713	1182	\N
5327	1713	1183	\N
5328	1713	1184	\N
5329	1793	1179	\N
5330	1869	1185	648456
5331	1869	1186	411523
5332	1869	1187	360107
5333	1869	1188	623012
5334	1869	1189	546565
5335	1714	1191	\N
5336	1870	1190	\N
5337	1870	1191	\N
5338	1870	1192	\N
5339	1870	1193	\N
5340	1870	1194	\N
5341	1715	1195	\N
5342	1794	1196	\N
5343	1794	1197	\N
5344	1871	1196	\N
5345	1871	1197	\N
5346	1871	1199	\N
5347	1871	1200	\N
5348	1715	1201	896491
5349	1795	1202	\N
5350	1872	1203	\N
5351	1872	1205	\N
5352	1716	1207	604757
5353	1716	1209	781723
5354	1716	1210	911151
5355	1716	1212	192200
5356	1795	1207	120530
5357	1795	1208	566536
5358	1795	1209	806239
5359	1795	1210	478718
5360	1872	1206	489636
5361	1873	1214	693750
5362	1873	1215	967397
5363	1873	1217	250590
5364	1873	1219	623275
5365	1874	1220	\N
5366	1874	1221	\N
5367	1717	1222	791906
5368	1796	1222	131195
5369	1796	1223	663125
5370	1796	1224	129497
5371	1796	1225	104957
5372	1718	1226	\N
5373	1718	1227	\N
5374	1718	1229	\N
5375	1797	1226	\N
5376	1797	1228	\N
5377	1797	1229	\N
5378	1875	1231	872580
5379	1875	1232	691636
5380	1719	1233	\N
5381	1798	1233	\N
5382	1798	1235	\N
5383	1876	1234	\N
5384	1876	1236	\N
5385	1798	1238	244389
5386	1798	1239	434528
5387	1798	1240	681874
5388	1720	1241	\N
5389	1799	1241	\N
5390	1799	1242	\N
5391	1799	1244	\N
5392	1720	1245	779799
5393	1720	1247	296094
5394	1720	1248	334484
5395	1877	1245	896626
5396	1800	1249	\N
5397	1800	1250	\N
5398	1800	1252	\N
5399	1878	1250	\N
5400	1878	1252	\N
5401	1878	1253	124786
5402	1721	1254	\N
5403	1801	1254	\N
5404	1801	1256	\N
5405	1879	1254	\N
5406	1721	1258	767179
5407	1721	1259	874840
5408	1721	1260	420847
5409	1721	1261	343485
5410	1801	1258	822601
5411	1722	1262	\N
5412	1722	1263	\N
5413	1722	1264	\N
5414	1722	1265	\N
5415	1802	1267	404919
5416	1802	1269	224567
5417	1802	1270	370320
5418	1802	1271	109781
5419	1880	1266	953038
5420	1880	1268	706222
5421	1880	1269	370557
5422	1803	1272	547196
5423	1803	1273	155800
5424	1803	1274	520413
5425	1803	1275	351327
5426	1803	1276	983763
5427	1881	1272	493538
5428	1881	1273	599025
5429	1882	1277	\N
5430	1723	1279	452659
5431	1882	1278	860839
5432	1882	1280	351067
5433	1724	1281	\N
5434	1724	1282	\N
5435	1724	1283	\N
5436	1724	1284	\N
5437	1724	1286	\N
5438	1804	1281	\N
5439	1804	1282	\N
5440	1883	1281	\N
5441	1883	1283	\N
5442	1883	1284	\N
5443	1883	1285	\N
5444	1804	1287	452629
5445	1883	1287	153969
5446	1884	1288	\N
5447	1805	1290	854879
5448	1805	1292	191056
5449	1725	1294	\N
5450	1725	1295	\N
5451	1725	1296	\N
5452	1885	1293	\N
5453	1885	1294	\N
5454	1885	1295	\N
5455	1725	1297	551262
5456	1806	1297	186349
5457	1726	1299	\N
5458	1886	1299	\N
5459	1886	1301	\N
5460	1726	1303	531316
5461	1807	1303	423646
5462	1807	1304	558365
5463	1886	1302	505155
5464	1886	1304	799695
5465	1727	1305	\N
5466	1727	1306	\N
5467	1727	1307	\N
5468	1887	1305	\N
5469	1727	1308	540657
5470	1728	1310	\N
5471	1888	1312	277247
5472	1888	1313	776265
5473	1729	1314	\N
5474	1729	1316	\N
5475	1729	1317	\N
5476	1729	1318	\N
5477	1808	1314	\N
5478	1889	1319	292720
5479	1889	1320	953671
5480	1730	1321	\N
5481	1890	1321	\N
5482	1730	1322	935067
5483	1730	1324	654078
5484	1809	1322	738137
5485	1809	1323	123853
5486	1809	1324	268530
5487	1890	1322	432069
5488	1890	1324	872122
5489	1890	1325	801979
5490	1890	1326	475480
5491	1891	1327	\N
5492	1891	1329	\N
5493	1810	1331	847321
5494	1810	1333	544453
5495	1891	1331	480672
5496	1891	1332	775635
5497	1731	1334	\N
5498	1731	1335	\N
5499	1731	1336	740965
5500	1811	1337	619532
5501	1892	1337	578555
5502	1892	1338	276161
5503	1892	1340	251861
5504	1732	1341	\N
5505	1732	1342	156118
5506	1732	1343	105419
5507	1812	1342	748932
5508	1733	1344	\N
5509	1733	1345	\N
5510	1733	1347	\N
5511	1733	1349	\N
5512	1893	1345	\N
5513	1893	1350	389703
5514	1893	1352	598405
5515	1813	1353	\N
5516	1813	1354	\N
5517	1894	1354	\N
5518	1894	1355	\N
5519	1894	1356	\N
5520	1734	1357	162187
5521	1734	1358	570583
5522	1813	1357	225229
5523	1813	1358	648253
5524	1813	1359	394534
5525	1894	1358	949964
5526	1895	1361	258320
5527	1735	1362	\N
5528	1735	1363	\N
5529	1896	1364	177835
5530	1814	1365	\N
5531	1897	1365	\N
5532	1897	1366	\N
5533	1897	1367	\N
5534	1897	1369	\N
5535	1736	1370	582800
5536	1814	1370	100567
5537	1814	1371	466932
5538	1814	1372	392661
5539	1737	1373	\N
5540	1815	1373	\N
5541	1815	1374	\N
5542	1737	1375	720465
5543	1737	1376	446931
5544	1737	1377	397564
5545	1815	1375	449400
5546	1898	1375	746527
5547	1898	1377	403303
5548	1816	1378	\N
5549	1816	1380	\N
5550	1816	1381	\N
5551	1816	1382	\N
5552	1816	1383	\N
5553	1899	1378	\N
5554	1899	1384	899524
5555	1899	1385	217321
5556	1738	1387	433215
5557	1900	1386	155480
5558	1900	1387	701852
5559	1900	1389	969884
5560	1739	1390	\N
5561	1739	1392	\N
5562	1817	1391	\N
5563	1901	1390	\N
5564	1901	1391	\N
5565	1739	1394	663647
5566	1818	1395	\N
5567	1818	1396	\N
5568	1902	1395	\N
5569	1740	1398	448499
5570	1818	1397	114178
5571	1818	1398	436787
5572	1741	1399	\N
5573	1741	1400	\N
5574	1903	1399	\N
5575	1903	1400	\N
5576	1903	1401	\N
5577	1903	1402	\N
5578	1903	1403	339673
5579	1904	1404	\N
5580	1904	1405	\N
5581	1819	1407	\N
5582	1819	1408	\N
5583	1819	1409	\N
5584	1819	1411	\N
5585	1819	1412	\N
5586	1742	1413	507022
5587	1742	1415	927704
5588	1742	1417	544059
5589	1742	1419	252182
5590	1742	1420	643328
5591	1905	1413	599363
5592	1905	1414	459544
5593	1905	1415	669350
5594	1905	1416	139008
5595	1905	1417	984335
5596	1820	1421	\N
5597	1820	1422	\N
5598	1820	1424	\N
5599	1820	1425	\N
5600	1820	1426	\N
5601	1743	1427	\N
5602	1821	1427	\N
5603	1821	1428	\N
5604	1821	1429	\N
5605	1821	1430	\N
5606	1743	1431	301678
5607	1743	1432	783520
5608	1906	1431	863200
5609	1906	1432	743068
5610	1906	1433	334404
5611	1744	1434	\N
5612	1744	1436	\N
5613	1907	1438	132101
5614	1907	1440	884771
5615	1745	1441	\N
5616	1745	1442	\N
5617	1745	1443	\N
5618	1822	1441	\N
5619	1822	1442	\N
5620	1822	1443	\N
5621	1822	1444	\N
5622	1908	1441	\N
5623	1822	1445	552316
5624	1909	1446	\N
5625	1909	1447	\N
5626	1823	1449	162194
5627	1909	1448	156556
5628	1909	1449	154372
5629	1909	1451	543082
5630	1746	1452	\N
5631	1746	1453	\N
5632	1746	1454	\N
5633	1746	1455	717976
5634	1746	1456	739345
5635	1910	1456	293688
5636	1911	1457	\N
5637	1911	1458	\N
5638	1911	1459	\N
5639	1747	1460	114416
5640	1824	1460	214739
5641	1824	1461	713396
5642	1824	1462	345260
5643	1824	1463	697718
5644	1911	1461	388743
5645	1911	1462	231509
5646	1748	1464	\N
5647	1748	1465	\N
5648	1748	1466	341556
5649	1748	1467	155756
5650	1825	1467	940029
5651	1912	1466	985052
5652	1912	1467	992712
5653	1826	1468	\N
5654	1749	1470	133175
5655	1749	1472	484812
5656	1749	1473	329109
5657	1749	1474	924135
5658	1749	1475	659997
5659	1826	1469	553845
5660	1913	1469	130565
5661	1913	1471	322796
5662	1913	1472	349384
5663	1750	1476	\N
5664	1750	1477	\N
5665	1914	1478	991194
5666	1751	1479	\N
5667	1751	1480	128543
5668	1751	1481	942790
5669	1751	1482	391647
5670	1915	1480	827670
5671	1915	1481	703922
5672	1915	1483	759959
5673	1915	1484	696214
5674	1752	1485	\N
5675	1752	1487	\N
5676	1827	1486	\N
5677	1752	1488	920201
5678	1752	1489	968081
5679	1752	1491	864411
5680	1827	1489	310503
5681	1827	1490	815379
5682	1827	1491	393988
5683	1916	1488	119772
5684	1916	1490	772234
5685	1916	1491	258760
5686	1916	1492	172005
5687	1753	1494	\N
5688	1828	1493	\N
5689	1828	1494	\N
5690	1917	1493	\N
5691	1917	1495	\N
5692	1917	1497	\N
5693	1917	1498	\N
5694	1917	1499	\N
5695	1828	1500	537633
5696	1828	1501	113618
5697	1754	1502	\N
5698	1918	1502	\N
5699	1918	1503	\N
5700	1829	1504	980382
5701	1755	1505	\N
5702	1755	1506	\N
5703	1830	1505	\N
5704	1830	1506	\N
5705	1830	1507	\N
5706	1919	1505	\N
5707	1919	1506	\N
5708	1919	1507	\N
5709	1919	1508	\N
5710	1755	1509	747775
5711	1755	1510	873621
5712	1830	1509	106619
5713	1830	1511	238970
5714	1756	1512	\N
5715	1920	1512	\N
5716	1920	1513	\N
5717	1920	1514	194160
5718	1920	1516	299808
5719	1921	1518	\N
5720	1921	1519	\N
5721	1757	1520	412085
5722	1757	1521	361375
5723	1831	1520	723726
5724	1831	1522	385503
5725	1831	1524	671013
5726	1831	1525	516462
5727	1831	1526	412320
5728	1922	1528	\N
5729	1832	1529	337072
5730	1832	1530	428739
5731	1832	1531	242379
5732	1832	1532	254369
5733	1832	1533	640461
5734	1922	1530	230547
5735	1922	1531	299383
5736	1922	1532	257968
5737	1922	1533	793635
5738	1758	1535	\N
5739	1923	1534	\N
5740	1923	1536	170404
5741	1923	1538	486551
5742	1923	1539	464382
5743	1759	1540	\N
5744	1759	1541	\N
5745	1759	1543	\N
5746	1924	1540	\N
5747	1924	1541	\N
5748	1924	1542	\N
5749	1924	1543	\N
5750	1759	1544	464375
5751	1924	1544	530937
5752	1760	1545	\N
5753	1833	1546	\N
5754	1833	1547	\N
5755	1925	1548	243733
5756	1925	1549	756120
5757	1834	1551	\N
5758	1926	1551	\N
5759	1926	1552	\N
5760	1926	1553	\N
5761	1761	1554	243157
5762	1834	1555	947346
5763	1834	1557	173844
5764	1834	1558	501704
5765	1834	1560	190768
5766	1926	1554	238917
5767	1926	1555	156616
5768	1762	1562	\N
5769	1762	1563	\N
5770	1763	1564	\N
5771	1927	1564	\N
5772	1835	1565	895071
5773	1927	1565	957854
5774	1927	1567	351788
5775	1927	1568	746115
5776	1764	1570	769351
5777	1836	1569	660078
5778	1836	1571	369591
5779	1836	1573	550374
5780	1928	1569	944883
5781	1928	1571	991186
5782	1765	1574	\N
5783	1765	1575	\N
5784	1765	1576	\N
5785	1765	1577	\N
5786	1837	1579	209573
5787	1929	1579	634459
5788	1766	1580	\N
5789	1838	1580	\N
5790	1930	1581	\N
5791	1766	1582	393603
5792	1766	1584	716375
5793	1766	1586	530943
5794	1838	1582	644367
5795	1930	1582	889301
5796	1930	1584	697071
5797	1767	1587	\N
5798	1839	1587	\N
5799	1839	1588	\N
5800	1931	1588	\N
5801	1931	1589	\N
5802	1931	1590	\N
5803	1931	1591	\N
5804	1767	1592	196698
5805	1839	1592	129130
5806	1839	1593	460729
5807	1768	1594	\N
5808	1840	1595	869644
5809	1840	1596	601657
5810	1841	1598	\N
5811	1932	1598	\N
5812	1769	1599	871060
5813	1769	1600	504157
5814	1769	1601	522311
5815	1769	1602	241521
5816	1769	1604	460689
5817	1842	1605	252096
5818	1842	1606	858383
5819	1843	1608	860498
5820	1843	1610	453460
5821	1843	1611	202011
5822	1843	1612	952287
5823	1843	1613	915909
5824	1967	1614	567659
5825	1933	1615	\N
5826	1933	1616	\N
5827	1968	1615	\N
5828	1968	1617	695705
5829	1968	1618	585480
5830	1968	1620	370349
5831	1934	1621	\N
5832	1934	1623	\N
5833	1934	1624	\N
5834	1934	1626	\N
5835	1969	1621	\N
5836	1934	1627	113081
5837	1969	1627	591191
5838	1969	1629	711127
5839	1969	1630	155318
5840	1935	1631	\N
5841	1935	1632	\N
5842	1970	1631	\N
5843	1970	1632	\N
5844	1935	1634	511456
5845	1970	1634	121181
5846	1936	1635	\N
5847	1936	1637	\N
5848	1936	1639	\N
5849	1936	1640	\N
5850	1971	1641	253791
5851	1971	1643	108015
5852	1937	1644	\N
5853	1937	1645	\N
5854	1972	1644	\N
5855	1972	1645	\N
5856	1972	1646	\N
5857	1972	1647	\N
5858	1938	1648	\N
5859	1938	1650	121428
5860	1973	1649	419099
5861	1973	1650	606037
5862	1939	1651	\N
5863	1974	1651	\N
5864	1974	1652	397831
5865	1974	1653	902349
5866	1940	1654	124567
5867	1940	1655	722497
5868	1940	1656	539013
5869	1940	1657	387547
5870	1940	1658	513635
5871	1975	1655	725059
5872	1941	1660	\N
5873	1976	1659	\N
5874	1976	1660	\N
5875	1976	1661	\N
5876	1976	1662	433553
5877	1977	1664	\N
5878	1977	1666	\N
5879	1977	1667	245338
5880	1977	1668	842580
5881	1977	1670	659519
5882	1942	1672	\N
5883	1942	1673	\N
5884	1942	1674	\N
5885	1942	1675	\N
5886	1942	1676	381827
5887	1978	1676	546401
5888	1978	1677	524514
5889	1979	1678	602922
5890	1943	1679	\N
5891	1943	1680	\N
5892	1943	1681	\N
5893	1980	1679	\N
5894	1943	1683	488411
5895	1944	1684	\N
5896	1944	1686	\N
5897	1981	1684	\N
5898	1944	1688	740693
5899	1944	1690	431411
5900	1981	1688	347710
5901	1945	1692	\N
5902	1945	1693	493985
5903	1945	1695	693569
5904	1945	1696	541977
5905	1945	1697	314995
5906	1982	1693	253467
5907	1982	1694	830430
5908	1982	1695	682474
5909	1982	1696	963208
5910	1982	1698	512967
5911	1983	1699	\N
5912	1983	1700	\N
5913	1946	1701	478441
5914	1983	1701	681558
5915	1983	1702	620098
5916	1984	1703	\N
5917	1984	1704	485651
5918	1984	1705	499569
5919	1947	1706	\N
5920	1947	1707	\N
5921	1985	1707	\N
5922	1985	1708	\N
5923	1985	1710	\N
5924	1985	1711	\N
5925	1985	1712	320617
5926	1986	1713	\N
5927	1986	1714	\N
5928	1948	1715	334927
5929	1948	1716	466066
5930	1948	1717	222001
5931	1949	1718	\N
5932	1949	1719	\N
5933	1949	1720	\N
5934	1987	1718	\N
5935	1987	1719	\N
5936	1988	1721	\N
5937	1988	1722	\N
5938	1950	1723	681146
5939	1989	1724	518935
5940	1989	1725	485514
5941	1951	1726	155311
5942	1951	1728	317014
5943	1951	1729	289239
5944	1951	1731	395418
5945	1951	1732	945992
5946	1990	1726	908503
5947	1991	1733	\N
5948	1991	1734	\N
5949	1991	1736	745351
5950	1952	1737	\N
5951	1992	1737	\N
5952	1952	1738	185348
5953	1952	1739	991016
5954	1992	1738	729374
5955	1992	1739	424764
5956	1992	1740	322320
5957	1992	1741	800870
5958	1953	1743	\N
5959	1953	1744	\N
5960	1953	1746	\N
5961	1953	1748	836588
5962	1953	1750	750484
5963	1993	1747	284430
5964	1993	1748	473775
5965	1993	1749	364648
5966	1993	1750	913513
5967	1993	1751	696639
5968	1954	1752	\N
5969	1994	1752	\N
5970	1994	1754	\N
5971	1994	1755	\N
5972	1954	1756	758839
5973	1954	1757	481334
5974	1954	1758	133266
5975	1955	1759	\N
5976	1955	1760	768746
5977	1955	1761	650516
5978	1995	1760	521800
5979	1995	1761	521339
5980	1995	1762	736739
5981	1956	1763	552728
5982	1956	1764	382745
5983	1956	1765	685154
5984	1956	1766	494136
5985	1956	1767	353461
5986	1996	1768	373115
5987	1996	1769	611876
5988	1996	1771	130254
5989	1996	1772	517205
5990	1996	1774	465839
5991	1997	1775	\N
5992	1957	1777	900429
5993	1957	1778	271687
5994	1997	1776	695689
5995	1958	1779	\N
5996	1958	1780	\N
5997	1958	1781	639826
5998	1998	1782	251317
5999	1998	1783	527147
6000	1998	1785	848401
6001	1998	1786	926435
6002	1959	1788	\N
6003	1959	1789	\N
6004	1959	1790	\N
6005	1959	1792	\N
6006	1959	1793	201112
6007	1999	1793	517527
6008	1999	1794	114142
6009	1999	1795	891205
6010	1999	1796	877489
6011	1999	1797	468275
6012	2000	1798	589210
6013	2000	1800	494060
6014	2000	1801	251938
6015	2001	1802	\N
6016	2001	1803	\N
6017	2001	1804	\N
6018	1960	1806	300647
6019	2001	1805	556868
6020	2001	1806	982347
6021	1961	1808	\N
6022	1961	1809	\N
6023	1961	1810	\N
6024	2002	1808	\N
6025	2002	1811	720789
6026	2002	1812	855454
6027	2002	1813	835544
6028	2002	1814	888670
6029	1962	1815	591409
6030	1962	1816	973665
6031	2003	1815	105040
6032	2003	1817	920100
6033	2003	1818	774995
6034	1963	1819	\N
6035	1963	1820	810906
6036	2004	1820	761413
6037	2004	1822	383912
6038	2004	1823	195192
6039	2004	1825	131811
6040	1964	1827	525386
6041	1964	1829	978814
6042	1964	1830	694337
6043	1964	1831	636763
6044	1965	1832	\N
6045	2005	1832	\N
6046	2005	1833	\N
6047	1965	1834	738390
6048	1965	1835	653262
6049	1965	1836	232760
6050	1965	1837	302683
6051	2005	1834	451372
6052	2006	1838	\N
6053	2006	1839	990496
6054	2006	1841	518907
6055	2006	1842	124317
6056	2006	1843	593940
6057	1966	1844	\N
6058	2007	1844	\N
6059	2007	1845	\N
6060	2007	1847	\N
6061	2007	1849	\N
6062	2007	1850	277397
6063	2008	1851	518895
6064	2008	1853	119730
6065	2009	1855	\N
6066	2009	1857	538590
6067	2009	1859	251886
6068	2009	1860	716300
6069	2009	1861	366413
6070	2010	1862	\N
6071	2010	1863	103072
6072	2010	1864	285535
6073	2011	1865	405560
6074	2011	1867	941080
6075	2011	1869	343621
6076	2011	1870	117656
6077	2012	1872	\N
6078	2012	1874	\N
6079	2012	1875	544062
6080	2012	1877	821460
6081	2013	1879	\N
6082	2013	1880	\N
6083	2013	1881	\N
6084	2014	1882	\N
6085	2014	1884	\N
6086	2014	1885	\N
6087	2015	1886	\N
6088	2016	1887	105785
6089	2017	1889	\N
6090	2017	1890	\N
6091	2017	1891	\N
6092	2018	1892	\N
6093	2018	1893	\N
6094	2019	1894	\N
6095	2019	1895	\N
6096	2019	1896	232000
6097	2020	1897	\N
6098	2020	1898	\N
6099	2021	1899	\N
6100	2021	1901	477551
6101	2022	1902	997467
6102	2022	1903	725230
6103	2022	1904	469988
6104	2022	1905	667712
6105	2022	1906	757576
6106	2023	1908	450025
6107	2024	1909	\N
6108	2024	1910	\N
6109	2024	1912	243767
6110	2024	1913	926525
6111	2024	1914	124868
6112	2025	1915	\N
6113	2026	1916	606444
6114	2027	1918	\N
6115	2027	1919	\N
6116	2027	1920	\N
6117	2027	1921	490914
6118	2028	1923	\N
6119	2028	1924	716962
6120	2029	1925	426363
6121	2030	1927	\N
6122	2030	1928	\N
6123	2030	1929	\N
6124	2030	1930	\N
6125	2031	1931	404143
6126	2031	1932	104773
6127	2032	1934	778524
6128	2032	1935	182328
6129	2032	1936	624821
6130	2032	1937	640832
6131	2033	1938	846569
6132	2033	1940	256545
6133	2034	1941	\N
6134	2034	1942	\N
6135	2034	1944	\N
6136	2034	1945	699760
6137	2035	1946	\N
6138	2035	1947	650317
6139	2035	1948	598730
6140	2036	1949	\N
6141	2036	1950	\N
6142	2036	1951	219539
6143	2037	1953	\N
6144	2038	1955	745254
6145	2039	1956	684855
6146	2039	1957	734925
6147	2040	1958	227277
6148	2040	1959	972809
6149	2041	1960	\N
6150	2041	1961	\N
6151	2041	1963	450811
6152	2042	1964	664288
6153	2043	1965	\N
6154	2043	1966	\N
6155	2044	1968	\N
6156	2044	1969	\N
6157	2044	1971	\N
6158	2045	1972	\N
6159	2045	1973	\N
6160	2046	1975	174006
6161	2047	1976	\N
6162	2047	1977	\N
6163	2047	1978	\N
6164	2047	1979	\N
6165	2047	1980	135952
6166	2048	1981	328346
6167	2048	1982	985075
6168	2048	1983	638540
6169	2049	1984	539040
6170	2049	1985	713250
6171	2049	1987	275060
6172	2049	1989	405684
6173	2049	1990	492444
6174	2050	1991	\N
6175	2050	1992	\N
6176	2050	1993	\N
6177	2050	1994	\N
6178	2050	1995	120841
6179	2051	1996	\N
6180	2051	1998	\N
6181	2051	1999	799680
6182	2051	0	595125
6183	2051	1	655526
6184	2052	2	\N
6185	2052	3	\N
6186	2053	4	\N
6187	2053	5	\N
6188	2053	7	559514
6189	2054	8	627859
6190	2055	9	\N
6191	2055	10	\N
6192	2055	11	465437
6193	2055	13	522627
6194	2142	12	852118
6195	2056	15	\N
6196	2056	16	\N
6197	2056	17	\N
6198	2056	18	163295
6199	2056	20	771020
6200	2057	22	\N
6201	2057	23	\N
6202	2143	21	\N
6203	2058	24	\N
6204	2144	25	\N
6205	2144	27	\N
6206	2144	28	\N
6207	2058	29	926525
6208	2058	30	659116
6209	2058	31	406640
6210	2058	32	195893
6211	2145	33	912312
6212	2146	34	\N
6213	2146	35	\N
6214	2059	36	268633
6215	2060	37	\N
6216	2060	38	\N
6217	2060	39	\N
6218	2060	40	\N
6219	2060	41	\N
6220	2147	43	179611
6221	2147	44	357287
6222	2061	45	838848
6223	2061	46	608090
6224	2061	47	886284
6225	2062	49	\N
6226	2062	50	\N
6227	2148	49	\N
6228	2148	50	\N
6229	2062	51	852063
6230	2062	52	870890
6231	2148	51	369028
6232	2148	52	175553
6233	2148	54	491389
6234	2063	55	\N
6235	2063	56	\N
6236	2063	58	\N
6237	2149	59	182508
6238	2064	60	\N
6239	2064	62	\N
6240	2064	63	\N
6241	2150	64	790721
6242	2150	65	742007
6243	2150	67	673799
6244	2065	68	\N
6245	2065	69	\N
6246	2065	71	\N
6247	2065	73	\N
6248	2065	74	\N
6249	2151	68	\N
6250	2151	69	\N
6251	2151	71	\N
6252	2151	72	\N
6253	2151	73	\N
6254	2066	76	\N
6255	2066	77	168405
6256	2066	78	171423
6257	2067	79	\N
6258	2152	79	\N
6259	2152	80	\N
6260	2152	81	\N
6261	2152	82	827438
6262	2068	83	937154
6263	2068	85	519899
6264	2068	87	352090
6265	2068	88	519287
6266	2068	90	380962
6267	2153	83	701089
6268	2153	85	866599
6269	2154	91	\N
6270	2154	92	\N
6271	2154	94	\N
6272	2154	95	\N
6273	2069	96	\N
6274	2155	96	\N
6275	2155	97	\N
6276	2155	98	\N
6277	2069	99	387560
6278	2069	100	248445
6279	2155	100	338231
6280	2156	101	\N
6281	2156	102	\N
6282	2070	104	692571
6283	2156	103	508625
6284	2156	104	337703
6285	2071	106	\N
6286	2071	107	\N
6287	2157	108	140740
6288	2072	109	\N
6289	2158	110	\N
6290	2158	111	\N
6291	2158	112	\N
6292	2072	114	508944
6293	2072	115	649995
6294	2158	113	262413
6295	2073	117	\N
6296	2073	118	\N
6297	2159	116	\N
6298	2159	117	\N
6299	2159	118	\N
6300	2159	119	706739
6301	2159	121	909371
6302	2160	122	415061
6303	2160	123	922318
6304	2160	124	553565
6305	2160	125	254032
6306	2161	126	769085
6307	2161	127	367614
6308	2161	128	126139
6309	2161	129	710239
6310	2074	130	404879
6311	2074	131	406886
6312	2074	132	445281
6313	2162	130	186799
6314	2162	131	105228
6315	2162	133	847539
6316	2162	134	103237
6317	2163	135	\N
6318	2163	136	\N
6319	2163	137	491720
6320	2163	139	490435
6321	2163	141	912473
6322	2164	142	\N
6323	2075	143	291906
6324	2075	144	235004
6325	2075	145	604561
6326	2164	143	485262
6327	2076	146	\N
6328	2076	147	\N
6329	2076	148	\N
6330	2076	150	\N
6331	2076	151	500491
6332	2077	152	\N
6333	2077	153	\N
6334	2077	154	\N
6335	2077	155	\N
6336	2165	152	\N
6337	2077	156	533813
6338	2165	156	378133
6339	2165	158	228107
6340	2078	159	\N
6341	2166	159	\N
6342	2166	160	\N
6343	2166	162	\N
6344	2078	163	541475
6345	2078	165	255407
6346	2079	166	\N
6347	2079	168	\N
6348	2079	169	\N
6349	2079	170	\N
6350	2167	166	\N
6351	2079	171	786898
6352	2167	171	290231
6353	2167	172	338491
6354	2168	173	\N
6355	2168	174	\N
6356	2168	175	596538
6357	2168	177	735038
6358	2080	178	\N
6359	2080	179	\N
6360	2169	179	\N
6361	2169	180	\N
6362	2169	181	\N
6363	2080	183	703518
6364	2169	182	473554
6365	2169	183	721466
6366	2170	185	\N
6367	2170	187	\N
6368	2170	188	\N
6369	2081	189	541671
6370	2081	190	379875
6371	2171	191	120858
6372	2171	193	973249
6373	2171	194	881824
6374	2171	195	853384
6375	2171	196	505373
6376	2172	197	738875
6377	2172	198	471977
6378	2172	199	935678
6379	2173	200	\N
6380	2173	201	\N
6381	2173	202	456824
6382	2173	203	924761
6383	2173	204	894296
6384	2082	205	137941
6385	2174	206	590360
6386	2174	208	939838
6387	2083	209	\N
6388	2083	211	\N
6389	2083	212	\N
6390	2083	213	\N
6391	2175	209	\N
6392	2175	210	\N
6393	2175	214	696049
6394	2175	215	937956
6395	2084	216	675217
6396	2084	218	130406
6397	2084	219	876432
6398	2084	220	222411
6399	2176	216	453832
6400	2176	217	615315
6401	2176	219	968820
6402	2176	220	423040
6403	2177	221	\N
6404	2177	222	\N
6405	2177	223	922960
6406	2177	224	971166
6407	2177	225	767575
6408	2085	226	\N
6409	2178	226	\N
6410	2179	227	\N
6411	2086	228	560370
6412	2086	230	141210
6413	2086	231	428551
6414	2087	233	\N
6415	2087	234	\N
6416	2087	235	364701
6417	2087	237	232567
6418	2087	238	492916
6419	2180	235	235689
6420	2180	236	490972
6421	2180	237	445367
6422	2180	238	925223
6423	2180	240	865070
6424	2181	241	\N
6425	2181	242	\N
6426	2181	243	\N
6427	2088	244	223270
6428	2088	246	900859
6429	2088	248	850926
6430	2089	249	\N
6431	2089	251	\N
6432	2182	249	\N
6433	2182	252	590766
6434	2182	253	374026
6435	2090	254	431922
6436	2090	255	894991
6437	2183	254	830275
6438	2183	255	275860
6439	2183	257	939931
6440	2091	259	\N
6441	2091	260	\N
6442	2091	261	729762
6443	2091	262	174550
6444	2092	263	\N
6445	2092	264	916729
6446	2092	265	819077
6447	2184	264	196833
6448	2093	266	200779
6449	2094	268	\N
6450	2094	270	937109
6451	2094	271	855675
6452	2095	272	\N
6453	2095	274	\N
6454	2185	272	\N
6455	2095	275	590475
6456	2185	275	687664
6457	2186	277	\N
6458	2096	278	336535
6459	2096	279	866294
6460	2186	278	811570
6461	2097	280	\N
6462	2097	282	458689
6463	2097	283	760917
6464	2098	284	\N
6465	2099	285	\N
6466	2099	286	\N
6467	2099	287	889571
6468	2099	288	732263
6469	2099	289	866887
6470	2100	290	\N
6471	2100	291	819874
6472	2101	292	193596
6473	2101	293	327542
6474	2101	294	117592
6475	2101	295	258591
6476	2101	296	560674
6477	2102	298	952628
6478	2102	299	171846
6479	2102	300	593937
6480	2103	302	379673
6481	2103	303	357279
6482	2103	305	919816
6483	2103	306	612378
6484	2103	307	373796
6485	2104	308	645637
6486	2105	309	422551
6487	2105	310	423384
6488	2105	311	865801
6489	2106	313	\N
6490	2106	314	\N
6491	2106	315	\N
6492	2106	317	\N
6493	2106	319	\N
6494	2107	320	\N
6495	2108	321	\N
6496	2109	322	\N
6497	2109	323	\N
6498	2109	325	\N
6499	2109	327	101166
6500	2110	328	\N
6501	2110	329	\N
6502	2110	330	216205
6503	2110	331	127764
6504	2111	332	591566
6505	2112	333	\N
6506	2112	334	\N
6507	2113	335	735197
6508	2113	336	664945
6509	2114	337	\N
6510	2114	338	635663
6511	2115	339	\N
6512	2116	341	\N
6513	2116	342	615999
6514	2116	343	933077
6515	2116	345	814235
6516	2117	346	632165
6517	2118	348	\N
6518	2118	349	630019
6519	2118	351	904502
6520	2118	353	903224
6521	2119	354	\N
6522	2119	355	\N
6523	2120	357	\N
6524	2121	358	\N
6525	2121	359	895880
6526	2121	360	647969
6527	2122	362	\N
6528	2122	363	\N
6529	2122	364	581757
6530	2122	366	889261
6531	2123	367	\N
6532	2123	368	\N
6533	2123	369	\N
6534	2123	370	\N
6535	2123	371	801087
6536	2124	372	127057
6537	2125	374	\N
6538	2125	375	650383
6539	2125	377	387595
6540	2125	378	858660
6541	2126	380	\N
6542	2126	381	\N
6543	2126	382	\N
6544	2127	383	\N
6545	2128	385	804960
6546	2128	386	199849
6547	2129	388	\N
6548	2129	389	158066
6549	2129	390	785816
6550	2130	392	\N
6551	2130	393	\N
6552	2131	394	\N
6553	2131	395	\N
6554	2132	397	619388
6555	2133	398	\N
6556	2133	399	\N
6557	2133	401	817369
6558	2133	403	629194
6559	2134	405	139630
6560	2135	406	\N
6561	2135	407	\N
6562	2136	409	\N
6563	2136	410	495708
6564	2136	411	248406
6565	2137	412	\N
6566	2137	413	\N
6567	2137	414	567044
6568	2138	415	\N
6569	2138	416	164324
6570	2139	417	309144
6571	2139	419	519495
6572	2139	420	555072
6573	2140	421	516580
6574	2140	422	514460
6575	2140	423	668588
6576	2140	425	656960
6577	2140	427	485157
6578	2141	428	230620
6579	2258	429	\N
6580	2345	429	\N
6581	2345	430	\N
6582	2345	432	\N
6583	2345	433	\N
6584	2187	434	470272
6585	2188	435	\N
6586	2188	436	\N
6587	2188	438	\N
6588	2188	439	879140
6589	2188	440	752760
6590	2189	441	\N
6591	2259	441	\N
6592	2259	442	\N
6593	2259	444	\N
6594	2259	445	\N
6595	2259	446	792139
6596	2346	446	229209
6597	2346	447	912925
6598	2190	449	\N
6599	2190	451	\N
6600	2260	449	\N
6601	2347	448	\N
6602	2347	449	\N
6603	2347	450	\N
6604	2190	452	799380
6605	2190	453	290939
6606	2190	454	962142
6607	2260	452	762488
6608	2191	455	\N
6609	2191	456	\N
6610	2261	455	\N
6611	2261	456	\N
6612	2261	458	\N
6613	2261	459	\N
6614	2348	456	\N
6615	2348	458	\N
6616	2348	459	\N
6617	2348	461	\N
6618	2191	462	631010
6619	2191	463	525356
6620	2262	464	\N
6621	2262	465	\N
6622	2262	467	\N
6623	2349	464	\N
6624	2262	468	782213
6625	2349	468	703961
6626	2349	469	922242
6627	2192	470	\N
6628	2263	470	\N
6629	2263	471	\N
6630	2263	472	\N
6631	2192	473	956611
6632	2192	475	819221
6633	2192	476	785644
6634	2350	473	989400
6635	2350	475	897620
6636	2350	476	215409
6637	2350	477	688038
6638	2350	479	892845
6639	2264	480	\N
6640	2351	480	\N
6641	2193	481	380476
6642	2193	482	971547
6643	2193	483	560056
6644	2193	485	960635
6645	2264	481	972325
6646	2351	481	400985
6647	2265	486	\N
6648	2265	488	\N
6649	2265	489	\N
6650	2265	491	\N
6651	2352	486	\N
6652	2352	487	\N
6653	2352	488	\N
6654	2352	490	\N
6655	2265	492	869657
6656	2352	492	689584
6657	2194	493	\N
6658	2266	493	\N
6659	2266	494	\N
6660	2266	495	\N
6661	2353	493	\N
6662	2194	496	271773
6663	2194	497	129189
6664	2194	498	464860
6665	2353	496	681975
6666	2195	499	\N
6667	2195	500	\N
6668	2195	501	\N
6669	2195	502	\N
6670	2195	504	\N
6671	2267	500	\N
6672	2267	501	\N
6673	2267	502	\N
6674	2354	500	\N
6675	2354	501	\N
6676	2354	502	\N
6677	2267	505	271911
6678	2196	506	\N
6679	2196	507	\N
6680	2268	508	967661
6681	2268	509	285269
6682	2268	510	235482
6683	2268	511	550457
6684	2268	512	113000
6685	2197	513	\N
6686	2355	514	\N
6687	2197	516	219660
6688	2197	517	906115
6689	2197	518	411025
6690	2269	516	709001
6691	2355	515	350474
6692	2355	516	908506
6693	2198	520	\N
6694	2270	521	762096
6695	2270	522	757688
6696	2270	523	855378
6697	2270	524	143330
6698	2199	525	\N
6699	2356	525	\N
6700	2356	526	\N
6701	2356	527	\N
6702	2356	528	\N
6703	2199	530	923163
6704	2199	531	704182
6705	2199	532	820459
6706	2271	529	628323
6707	2271	531	696284
6708	2271	533	475058
6709	2200	535	\N
6710	2200	536	\N
6711	2200	537	\N
6712	2200	538	\N
6713	2272	535	\N
6714	2272	537	\N
6715	2272	540	494293
6716	2272	541	923995
6717	2272	543	798451
6718	2357	539	922852
6719	2357	540	382418
6720	2201	544	\N
6721	2201	546	\N
6722	2201	548	\N
6723	2273	549	278433
6724	2273	550	960146
6725	2274	551	\N
6726	2274	552	\N
6727	2274	553	\N
6728	2358	551	\N
6729	2358	552	\N
6730	2202	554	482383
6731	2358	554	600314
6732	2358	556	276300
6733	2359	557	\N
6734	2203	559	520337
6735	2203	560	600308
6736	2203	562	735459
6737	2203	563	546187
6738	2275	558	845908
6739	2204	564	\N
6740	2276	564	\N
6741	2276	566	\N
6742	2276	568	\N
6743	2360	564	\N
6744	2204	570	269916
6745	2204	572	597211
6746	2204	573	720607
6747	2204	574	757815
6748	2276	570	809595
6749	2360	569	965197
6750	2360	570	355133
6751	2360	571	133882
6752	2205	576	\N
6753	2205	577	\N
6754	2277	576	\N
6755	2277	577	\N
6756	2277	578	\N
6757	2206	579	\N
6758	2206	580	\N
6759	2278	580	\N
6760	2361	580	\N
6761	2361	581	\N
6762	2278	583	508351
6763	2278	584	242076
6764	2278	586	955027
6765	2207	587	\N
6766	2362	587	\N
6767	2207	588	536936
6768	2279	588	224718
6769	2279	589	374342
6770	2208	591	\N
6771	2280	591	\N
6772	2208	592	167258
6773	2280	593	201405
6774	2280	594	677653
6775	2280	595	185925
6776	2363	592	986193
6777	2364	596	\N
6778	2364	597	\N
6779	2364	598	\N
6780	2364	599	\N
6781	2209	601	723898
6782	2209	602	107021
6783	2209	603	842221
6784	2281	601	472383
6785	2281	602	728277
6786	2281	603	360518
6787	2364	601	498542
6788	2365	605	439255
6789	2365	606	707381
6790	2365	607	775390
6791	2365	609	517397
6792	2365	610	606918
6793	2210	612	\N
6794	2210	614	\N
6795	2210	615	605440
6796	2366	615	536207
6797	2282	617	\N
6798	2367	616	\N
6799	2367	617	\N
6800	2367	618	\N
6801	2282	619	210194
6802	2211	620	\N
6803	2211	621	\N
6804	2283	620	\N
6805	2283	622	\N
6806	2283	623	\N
6807	2283	624	\N
6808	2283	625	\N
6809	2211	626	950285
6810	2284	627	\N
6811	2284	628	\N
6812	2284	629	\N
6813	2284	630	\N
6814	2368	628	\N
6815	2368	630	\N
6816	2284	632	636370
6817	2285	633	\N
6818	2285	634	\N
6819	2369	633	\N
6820	2369	634	\N
6821	2369	636	\N
6822	2285	637	572728
6823	2369	638	140172
6824	2212	639	\N
6825	2286	640	\N
6826	2286	641	\N
6827	2212	642	124890
6828	2212	643	100236
6829	2212	645	188805
6830	2370	643	526657
6831	2370	644	780565
6832	2213	646	\N
6833	2213	647	\N
6834	2213	649	\N
6835	2287	646	\N
6836	2371	646	\N
6837	2371	648	\N
6838	2287	650	156392
6839	2287	651	591055
6840	2287	652	546526
6841	2287	653	145693
6842	2371	650	234729
6843	2371	651	579826
6844	2371	652	293342
6845	2288	654	\N
6846	2288	656	\N
6847	2288	657	\N
6848	2372	655	\N
6849	2214	658	651354
6850	2214	659	321440
6851	2214	660	455983
6852	2214	661	152627
6853	2288	658	964685
6854	2288	660	729697
6855	2215	662	\N
6856	2289	662	\N
6857	2289	663	\N
6858	2373	662	\N
6859	2373	663	\N
6860	2215	664	334107
6861	2215	665	712466
6862	2215	666	116475
6863	2215	667	520328
6864	2289	665	301233
6865	2289	667	653647
6866	2373	664	875728
6867	2373	665	766458
6868	2373	666	777173
6869	2216	668	\N
6870	2216	669	\N
6871	2374	668	\N
6872	2216	671	930867
6873	2216	672	578425
6874	2216	673	322626
6875	2290	670	479646
6876	2290	671	396911
6877	2290	672	216396
6878	2290	673	543740
6879	2290	674	765984
6880	2374	671	934604
6881	2374	673	439723
6882	2374	674	470351
6883	2217	675	\N
6884	2217	676	\N
6885	2217	678	\N
6886	2217	679	\N
6887	2217	681	\N
6888	2291	676	\N
6889	2291	677	\N
6890	2291	678	\N
6891	2291	679	\N
6892	2291	682	688041
6893	2375	682	966776
6894	2375	683	659954
6895	2375	684	420058
6896	2292	686	\N
6897	2292	687	154693
6898	2292	689	848074
6899	2292	690	955487
6900	2376	687	601141
6901	2376	689	584296
6902	2376	690	387189
6903	2376	691	614936
6904	2376	692	991971
6905	2218	693	\N
6906	2218	694	\N
6907	2218	695	\N
6908	2293	693	\N
6909	2293	697	365643
6910	2293	699	357164
6911	2293	700	724343
6912	2377	696	317594
6913	2377	698	880016
6914	2377	699	792637
6915	2219	701	\N
6916	2294	701	\N
6917	2219	703	182747
6918	2219	704	295361
6919	2378	703	721490
6920	2378	704	923429
6921	2378	705	248898
6922	2378	706	705525
6923	2378	708	823557
6924	2220	709	\N
6925	2220	710	\N
6926	2379	709	\N
6927	2379	711	\N
6928	2379	712	\N
6929	2295	713	578718
6930	2296	715	482793
6931	2296	716	867613
6932	2296	717	490563
6933	2296	718	492257
6934	2221	719	\N
6935	2297	719	\N
6936	2297	721	\N
6937	2297	722	317873
6938	2222	723	\N
6939	2222	724	\N
6940	2222	725	\N
6941	2298	723	\N
6942	2298	725	\N
6943	2380	723	\N
6944	2298	726	997142
6945	2298	727	200624
6946	2298	728	352968
6947	2223	729	\N
6948	2299	729	\N
6949	2223	730	503247
6950	2223	732	427458
6951	2299	730	174591
6952	2224	734	\N
6953	2224	735	\N
6954	2224	736	\N
6955	2224	738	\N
6956	2224	739	\N
6957	2381	733	\N
6958	2300	740	789931
6959	2300	741	773332
6960	2300	742	976354
6961	2301	743	955782
6962	2382	743	336416
6963	2225	744	\N
6964	2225	746	\N
6965	2302	744	\N
6966	2302	745	\N
6967	2302	746	\N
6968	2302	747	\N
6969	2225	748	216322
6970	2226	749	\N
6971	2303	749	\N
6972	2303	750	\N
6973	2226	751	264377
6974	2303	752	562162
6975	2303	753	390673
6976	2303	754	570050
6977	2227	755	\N
6978	2227	756	\N
6979	2227	758	\N
6980	2227	759	\N
6981	2304	755	\N
6982	2304	756	\N
6983	2227	761	906283
6984	2304	760	769164
6985	2228	763	\N
6986	2228	764	\N
6987	2305	762	\N
6988	2305	764	\N
6989	2305	765	219463
6990	2305	766	678728
6991	2305	767	673246
6992	2229	769	\N
6993	2306	768	\N
6994	2306	771	538962
6995	2306	772	337499
6996	2306	773	156700
6997	2230	774	\N
6998	2307	774	\N
6999	2230	775	350856
7000	2230	776	799158
7001	2231	777	\N
7002	2308	779	\N
7003	2232	781	545691
7004	2308	780	161807
7005	2308	781	213413
7006	2233	782	\N
7007	2309	782	\N
7008	2309	784	\N
7009	2233	785	376279
7010	2233	786	519428
7011	2233	787	109597
7012	2309	785	561227
7013	2310	788	\N
7014	2310	790	\N
7015	2234	792	181779
7016	2234	793	523119
7017	2310	791	203758
7018	2235	794	\N
7019	2235	796	\N
7020	2311	795	\N
7021	2311	796	\N
7022	2311	797	\N
7023	2311	798	\N
7024	2235	799	368428
7025	2236	800	\N
7026	2236	802	\N
7027	2236	804	102723
7028	2312	803	398167
7029	2237	805	\N
7030	2237	807	\N
7031	2313	806	\N
7032	2313	808	\N
7033	2313	809	\N
7034	2313	811	\N
7035	2313	813	\N
7036	2237	814	611578
7037	2237	816	886594
7038	2314	817	\N
7039	2238	818	324895
7040	2314	818	841352
7041	2314	820	541792
7042	2239	822	\N
7043	2239	824	\N
7044	2239	826	\N
7045	2239	827	671191
7046	2315	827	121152
7047	2315	829	604563
7048	2315	831	607215
7049	2315	832	111836
7050	2240	833	\N
7051	2240	834	\N
7052	2240	835	\N
7053	2240	836	\N
7054	2316	833	\N
7055	2316	834	\N
7056	2316	835	\N
7057	2316	838	549933
7058	2241	839	\N
7059	2241	840	380792
7060	2241	842	239854
7061	2242	844	\N
7062	2317	843	\N
7063	2242	845	417377
7064	2242	846	580086
7065	2242	848	454400
7066	2242	849	226778
7067	2243	851	\N
7068	2243	853	\N
7069	2243	855	\N
7070	2318	850	\N
7071	2318	851	\N
7072	2318	852	\N
7073	2318	856	841416
7074	2318	858	721197
7075	2244	860	\N
7076	2244	862	\N
7077	2244	863	\N
7078	2244	865	\N
7079	2244	866	\N
7080	2245	867	\N
7081	2245	869	\N
7082	2245	870	\N
7083	2319	868	\N
7084	2319	869	\N
7085	2245	871	141965
7086	2245	872	878474
7087	2319	872	603771
7088	2319	874	205960
7089	2319	876	662097
7090	2246	877	\N
7091	2246	878	\N
7092	2320	877	\N
7093	2246	879	102942
7094	2320	880	967620
7095	2320	882	943711
7096	2320	883	671429
7097	2321	885	\N
7098	2321	886	\N
7099	2321	888	\N
7100	2321	889	\N
7101	2321	890	\N
7102	2247	891	297054
7103	2247	892	484098
7104	2247	893	824048
7105	2247	895	267115
7106	2247	896	576425
7107	2248	897	\N
7108	2248	898	586624
7109	2322	899	669209
7110	2249	900	\N
7111	2249	902	\N
7112	2323	900	\N
7113	2323	901	\N
7114	2323	902	\N
7115	2249	903	535559
7116	2323	903	870602
7117	2323	904	545958
7118	2250	906	\N
7119	2250	907	\N
7120	2250	908	\N
7121	2251	909	\N
7122	2251	910	\N
7123	2251	911	\N
7124	2324	912	130504
7125	2325	913	\N
7126	2325	914	\N
7127	2325	916	\N
7128	2325	917	\N
7129	2325	918	\N
7130	2252	920	851279
7131	2252	921	338172
7132	2252	922	415679
7133	2252	923	349452
7134	2253	924	310830
7135	2253	926	328452
7136	2253	928	379451
7137	2253	929	575616
7138	2253	931	825594
7139	2326	924	205478
7140	2254	932	\N
7141	2254	933	832038
7142	2327	934	\N
7143	2255	935	679738
7144	2255	936	150657
7145	2327	936	509911
7146	2327	937	365669
7147	2327	938	389225
7148	2256	939	\N
7149	2328	939	\N
7150	2256	940	654726
7151	2329	941	342997
7152	2329	943	591847
7153	2329	944	841151
7154	2329	945	980870
7155	2257	946	\N
7156	2257	947	705905
7157	2330	947	346040
7158	2330	949	663925
7159	2330	950	559631
7160	2330	952	286601
7161	2331	953	696034
7162	2332	954	798055
7163	2332	955	323785
7164	2332	956	444907
7165	2333	957	974479
7166	2333	959	662656
7167	2333	960	969884
7168	2334	962	\N
7169	2335	963	430749
7170	2335	964	304260
7171	2335	965	216094
7172	2335	966	974241
7173	2336	967	157800
7174	2337	969	\N
7175	2337	970	\N
7176	2337	972	\N
7177	2338	973	\N
7178	2338	975	\N
7179	2338	976	\N
7180	2338	977	\N
7181	2338	978	\N
7182	2339	979	\N
7183	2340	981	311004
7184	2340	982	890266
7185	2341	984	\N
7186	2341	986	\N
7187	2342	987	355416
7188	2342	988	893536
7189	2343	989	599733
7190	2344	990	\N
7191	2383	992	\N
7192	2383	993	\N
7193	2383	994	\N
7194	2428	992	\N
7195	2428	993	\N
7196	2383	995	653990
7197	2383	997	480473
7198	2429	998	\N
7199	2429	999	\N
7200	2429	1001	\N
7201	2384	1002	\N
7202	2384	1003	\N
7203	2384	1004	778615
7204	2430	1005	133346
7205	2430	1007	566285
7206	2430	1008	377613
7207	2385	1010	\N
7208	2385	1011	\N
7209	2431	1010	\N
7210	2385	1012	667549
7211	2431	1013	559968
7212	2386	1014	\N
7213	2386	1015	\N
7214	2386	1017	\N
7215	2386	1019	\N
7216	2386	1020	\N
7217	2432	1014	\N
7218	2432	1022	167012
7219	2432	1023	542156
7220	2387	1024	\N
7221	2433	1024	\N
7222	2433	1025	\N
7223	2433	1026	\N
7224	2387	1027	256286
7225	2387	1028	420795
7226	2387	1029	681652
7227	2387	1030	715696
7228	2433	1027	916190
7229	2433	1028	929260
7230	2388	1031	\N
7231	2388	1032	\N
7232	2388	1033	\N
7233	2388	1035	550519
7234	2434	1035	372523
7235	2434	1036	672490
7236	2389	1037	886279
7237	2389	1038	714446
7238	2390	1040	691646
7239	2435	1041	\N
7240	2435	1042	\N
7241	2435	1043	\N
7242	2435	1044	\N
7243	2391	1046	\N
7244	2391	1047	\N
7245	2436	1045	\N
7246	2436	1046	\N
7247	2436	1047	\N
7248	2436	1048	\N
7249	2391	1050	878759
7250	2391	1052	754415
7251	2436	1049	728593
7252	2392	1053	\N
7253	2392	1054	151532
7254	2437	1054	865432
7255	2393	1055	\N
7256	2438	1056	\N
7257	2438	1057	\N
7258	2438	1059	\N
7259	2438	1060	\N
7260	2393	1061	222540
7261	2394	1062	\N
7262	2439	1063	764081
7263	2439	1064	796950
7264	2440	1065	434544
7265	2441	1067	\N
7266	2441	1069	\N
7267	2441	1070	\N
7268	2441	1071	\N
7269	2395	1072	340692
7270	2395	1073	519824
7271	2395	1074	449893
7272	2396	1075	\N
7273	2397	1077	\N
7274	2397	1078	\N
7275	2397	1079	\N
7276	2442	1077	\N
7277	2442	1078	\N
7278	2442	1079	\N
7279	2442	1080	\N
7280	2397	1081	546757
7281	2442	1082	343654
7282	2398	1083	\N
7283	2398	1084	\N
7284	2398	1085	\N
7285	2443	1084	\N
7286	2443	1087	846459
7287	2443	1088	788721
7288	2443	1090	340648
7289	2443	1091	640951
7290	2399	1093	\N
7291	2399	1094	\N
7292	2399	1095	\N
7293	2399	1097	\N
7294	2399	1099	920182
7295	2400	1100	\N
7296	2444	1101	\N
7297	2444	1102	\N
7298	2400	1103	858862
7299	2400	1104	447512
7300	2400	1105	284478
7301	2400	1106	671850
7302	2401	1107	\N
7303	2401	1108	\N
7304	2445	1108	\N
7305	2445	1110	\N
7306	2445	1112	\N
7307	2402	1114	503934
7308	2402	1115	113300
7309	2403	1117	\N
7310	2446	1116	\N
7311	2403	1119	693347
7312	2403	1120	620643
7313	2403	1121	897779
7314	2403	1122	209388
7315	2404	1123	\N
7316	2447	1123	\N
7317	2404	1125	752676
7318	2404	1126	258853
7319	2448	1127	\N
7320	2405	1128	483208
7321	2405	1129	305532
7322	2405	1131	918110
7323	2405	1132	859106
7324	2448	1128	374779
7325	2406	1133	\N
7326	2406	1134	\N
7327	2449	1133	\N
7328	2449	1134	\N
7329	2406	1135	110441
7330	2406	1136	856848
7331	2406	1137	877828
7332	2449	1136	377123
7333	2449	1137	824062
7334	2407	1138	\N
7335	2450	1138	\N
7336	2407	1139	865208
7337	2407	1141	719516
7338	2450	1140	499854
7339	2450	1141	386316
7340	2408	1143	\N
7341	2408	1144	\N
7342	2408	1145	\N
7343	2408	1146	633474
7344	2451	1146	207061
7345	2409	1147	\N
7346	2409	1148	490268
7347	2409	1149	495906
7348	2409	1150	557242
7349	2409	1151	124530
7350	2452	1148	842426
7351	2452	1149	145000
7352	2452	1150	462785
7353	2410	1152	\N
7354	2410	1153	\N
7355	2453	1153	\N
7356	2410	1154	700428
7357	2410	1155	356410
7358	2453	1155	987676
7359	2453	1157	368742
7360	2453	1159	279289
7361	2453	1161	649811
7362	2411	1162	856043
7363	2411	1163	742195
7364	2412	1164	\N
7365	2412	1165	\N
7366	2454	1165	\N
7367	2454	1166	268811
7368	2454	1167	562606
7369	2454	1168	423451
7370	2454	1169	176758
7371	2413	1170	394084
7372	2413	1171	637939
7373	2413	1173	412738
7374	2414	1174	\N
7375	2414	1175	\N
7376	2455	1174	\N
7377	2455	1175	\N
7378	2414	1176	277914
7379	2414	1177	617165
7380	2455	1177	451084
7381	2455	1179	382482
7382	2415	1180	544189
7383	2416	1181	\N
7384	2416	1183	\N
7385	2416	1184	\N
7386	2456	1181	\N
7387	2416	1186	431785
7388	2416	1188	727710
7389	2456	1185	241537
7390	2456	1186	831024
7391	2456	1187	131579
7392	2417	1189	\N
7393	2417	1190	\N
7394	2457	1191	884114
7395	2457	1192	555443
7396	2457	1193	643595
7397	2457	1194	732299
7398	2418	1195	\N
7399	2458	1196	\N
7400	2458	1197	\N
7401	2419	1198	\N
7402	2419	1199	\N
7403	2459	1200	\N
7404	2459	1201	\N
7405	2459	1202	502191
7406	2420	1203	\N
7407	2460	1203	\N
7408	2460	1205	\N
7409	2460	1206	\N
7410	2460	1208	970237
7411	2421	1209	463874
7412	2422	1210	\N
7413	2422	1212	\N
7414	2461	1210	\N
7415	2461	1211	\N
7416	2461	1212	\N
7417	2461	1214	929898
7418	2461	1216	174087
7419	2423	1218	\N
7420	2423	1219	\N
7421	2462	1221	939911
7422	2424	1223	\N
7423	2424	1225	\N
7424	2424	1227	\N
7425	2424	1228	705628
7426	2424	1229	946284
7427	2425	1230	\N
7428	2425	1231	\N
7429	2463	1230	\N
7430	2463	1231	\N
7431	2463	1233	\N
7432	2463	1235	\N
7433	2425	1236	747206
7434	2425	1238	980514
7435	2425	1239	160054
7436	2463	1237	371000
7437	2426	1240	485278
7438	2426	1241	266074
7439	2464	1241	144669
7440	2464	1242	521176
7441	2464	1243	376744
7442	2465	1244	\N
7443	2465	1245	\N
7444	2465	1247	\N
7445	2465	1248	\N
7446	2427	1250	418983
7447	2427	1251	840577
7448	2427	1252	499193
7449	2427	1253	460936
7450	2465	1249	983703
7451	2466	1254	\N
7452	2467	1255	\N
7453	2467	1256	\N
7454	2467	1257	\N
7455	2467	1258	\N
7456	2468	1260	\N
7457	2469	1261	\N
7458	2469	1262	\N
7459	2469	1263	\N
7460	2469	1265	795931
7461	2469	1266	360964
7462	2470	1267	956056
7463	2470	1268	922482
7464	2470	1269	186920
7465	2471	1271	\N
7466	2471	1272	424097
7467	2472	1273	\N
7468	2473	1274	\N
7469	2473	1276	\N
7470	2553	1274	\N
7471	2553	1277	189864
7472	2474	1278	\N
7473	2474	1279	\N
7474	2474	1280	\N
7475	2474	1281	\N
7476	2554	1279	\N
7477	2554	1282	429046
7478	2555	1283	\N
7479	2555	1284	\N
7480	2555	1285	\N
7481	2556	1286	\N
7482	2556	1287	\N
7483	2556	1289	584020
7484	2556	1290	805502
7485	2557	1291	\N
7486	2475	1292	114178
7487	2475	1293	827160
7488	2475	1294	276165
7489	2475	1296	994592
7490	2557	1293	344603
7491	2557	1295	156027
7492	2557	1297	675000
7493	2476	1298	\N
7494	2476	1300	\N
7495	2476	1301	\N
7496	2476	1303	\N
7497	2476	1305	\N
7498	2558	1298	\N
7499	2558	1299	\N
7500	2558	1306	741487
7501	2558	1307	848803
7502	2477	1308	\N
7503	2559	1309	\N
7504	2559	1310	\N
7505	2559	1312	\N
7506	2559	1313	\N
7507	2559	1314	120444
7508	2560	1316	\N
7509	2560	1317	\N
7510	2478	1319	303422
7511	2478	1320	404180
7512	2479	1321	\N
7513	2479	1322	\N
7514	2479	1323	\N
7515	2479	1324	\N
7516	2561	1325	795543
7517	2480	1326	\N
7518	2562	1326	\N
7519	2480	1327	519064
7520	2480	1328	723774
7521	2480	1329	753120
7522	2480	1331	151836
7523	2562	1328	518023
7524	2562	1329	845325
7525	2562	1330	326640
7526	2562	1332	830590
7527	2481	1334	\N
7528	2481	1335	\N
7529	2563	1336	776698
7530	2482	1337	\N
7531	2482	1338	877103
7532	2483	1339	938412
7533	2564	1339	971643
7534	2484	1340	224923
7535	2565	1342	\N
7536	2485	1343	\N
7537	2485	1345	\N
7538	2485	1347	\N
7539	2566	1343	\N
7540	2566	1348	169509
7541	2486	1349	124655
7542	2486	1350	822806
7543	2487	1351	204091
7544	2567	1352	524773
7545	2567	1354	572499
7546	2567	1355	621152
7547	2567	1356	211169
7548	2567	1357	611860
7549	2568	1358	\N
7550	2568	1359	791836
7551	2569	1361	826472
7552	2488	1362	\N
7553	2488	1363	665482
7554	2488	1364	250058
7555	2488	1365	909759
7556	2570	1363	535847
7557	2570	1364	871253
7558	2489	1366	\N
7559	2571	1366	\N
7560	2489	1367	736799
7561	2489	1369	452631
7562	2571	1367	528502
7563	2490	1371	\N
7564	2572	1371	\N
7565	2572	1373	\N
7566	2490	1374	926820
7567	2572	1374	703168
7568	2572	1375	626451
7569	2572	1376	780692
7570	2573	1377	\N
7571	2573	1378	\N
7572	2573	1379	\N
7573	2573	1380	\N
7574	2491	1381	381476
7575	2491	1382	366498
7576	2491	1384	440227
7577	2491	1386	980676
7578	2573	1381	729385
7579	2492	1387	\N
7580	2492	1388	\N
7581	2492	1389	\N
7582	2492	1390	\N
7583	2574	1387	\N
7584	2492	1391	947885
7585	2574	1391	596643
7586	2574	1393	115928
7587	2574	1395	194270
7588	2493	1397	\N
7589	2493	1398	\N
7590	2493	1399	655351
7591	2575	1400	\N
7592	2575	1401	\N
7593	2575	1402	251708
7594	2494	1404	\N
7595	2494	1406	\N
7596	2576	1403	\N
7597	2494	1407	800237
7598	2494	1409	408955
7599	2494	1411	543233
7600	2576	1408	838947
7601	2576	1410	956129
7602	2495	1412	\N
7603	2577	1412	\N
7604	2496	1413	804840
7605	2496	1414	135295
7606	2496	1416	279935
7607	2496	1418	659374
7608	2497	1419	\N
7609	2497	1421	\N
7610	2578	1419	\N
7611	2578	1422	454319
7612	2498	1424	\N
7613	2498	1425	\N
7614	2498	1426	\N
7615	2579	1423	\N
7616	2499	1427	\N
7617	2580	1427	\N
7618	2580	1428	\N
7619	2580	1429	\N
7620	2500	1431	235551
7621	2500	1433	605916
7622	2500	1434	610096
7623	2581	1430	157074
7624	2501	1435	\N
7625	2501	1437	\N
7626	2582	1435	\N
7627	2501	1439	146320
7628	2582	1439	165869
7629	2502	1440	\N
7630	2502	1441	\N
7631	2502	1442	\N
7632	2502	1443	\N
7633	2583	1441	\N
7634	2583	1442	\N
7635	2583	1444	\N
7636	2583	1445	\N
7637	2583	1446	\N
7638	2502	1448	497306
7639	2503	1450	\N
7640	2503	1451	\N
7641	2503	1453	\N
7642	2503	1455	143363
7643	2504	1457	\N
7644	2504	1458	\N
7645	2504	1459	\N
7646	2584	1460	293380
7647	2585	1461	\N
7648	2585	1463	\N
7649	2505	1464	961749
7650	2505	1465	130751
7651	2586	1467	\N
7652	2586	1468	561389
7653	2586	1469	183901
7654	2586	1470	862409
7655	2587	1471	\N
7656	2588	1472	\N
7657	2588	1474	\N
7658	2506	1475	438743
7659	2506	1476	500301
7660	2506	1477	104046
7661	2588	1475	952213
7662	2507	1478	\N
7663	2589	1479	524810
7664	2589	1480	370198
7665	2589	1481	181975
7666	2508	1482	\N
7667	2508	1483	\N
7668	2508	1484	\N
7669	2508	1485	\N
7670	2590	1486	840096
7671	2590	1488	605296
7672	2590	1489	177301
7673	2590	1490	777498
7674	2590	1491	126407
7675	2509	1493	\N
7676	2509	1494	\N
7677	2509	1495	\N
7678	2591	1493	\N
7679	2591	1494	\N
7680	2591	1496	314495
7681	2591	1498	141337
7682	2591	1499	494226
7683	2592	1500	\N
7684	2592	1501	\N
7685	2510	1503	260298
7686	2510	1504	923245
7687	2510	1506	248739
7688	2592	1502	247316
7689	2593	1507	\N
7690	2593	1508	471803
7691	2593	1509	150063
7692	2511	1511	\N
7693	2511	1513	\N
7694	2511	1514	\N
7695	2594	1510	\N
7696	2594	1515	589050
7697	2594	1517	107236
7698	2594	1518	426776
7699	2594	1519	272300
7700	2512	1520	\N
7701	2595	1521	\N
7702	2595	1522	\N
7703	2512	1524	591320
7704	2512	1526	522210
7705	2512	1528	403505
7706	2595	1523	295713
7707	2513	1530	\N
7708	2513	1531	\N
7709	2513	1533	\N
7710	2596	1535	875905
7711	2596	1536	368265
7712	2596	1537	427964
7713	2596	1539	345218
7714	2596	1540	380364
7715	2597	1541	\N
7716	2597	1542	\N
7717	2514	1543	826724
7718	2597	1543	592421
7719	2597	1544	593392
7720	2597	1545	571784
7721	2598	1547	\N
7722	2515	1548	619946
7723	2515	1549	874250
7724	2598	1548	829410
7725	2598	1549	226069
7726	2516	1550	\N
7727	2516	1552	168346
7728	2516	1554	940244
7729	2517	1555	\N
7730	2599	1555	\N
7731	2517	1556	647417
7732	2517	1557	247885
7733	2517	1558	625312
7734	2517	1560	532199
7735	2599	1556	440267
7736	2599	1557	515920
7737	2518	1561	\N
7738	2600	1562	340275
7739	2600	1564	854962
7740	2600	1566	598775
7741	2519	1567	969877
7742	2601	1568	\N
7743	2601	1569	\N
7744	2520	1570	581165
7745	2520	1571	699369
7746	2520	1572	344124
7747	2520	1574	662023
7748	2520	1575	583314
7749	2601	1570	628522
7750	2601	1571	291039
7751	2521	1577	\N
7752	2521	1578	\N
7753	2521	1579	\N
7754	2521	1580	\N
7755	2602	1577	\N
7756	2602	1578	\N
7757	2521	1581	107366
7758	2603	1583	\N
7759	2603	1584	187739
7760	2603	1585	172852
7761	2522	1586	\N
7762	2522	1587	\N
7763	2604	1588	888628
7764	2604	1590	227947
7765	2604	1591	939401
7766	2604	1592	877291
7767	2604	1593	794596
7768	2523	1595	\N
7769	2523	1597	\N
7770	2523	1598	515522
7771	2605	1599	839615
7772	2524	1600	\N
7773	2524	1601	\N
7774	2524	1603	861163
7775	2524	1604	624974
7776	2524	1606	204765
7777	2606	1602	426828
7778	2606	1604	878282
7779	2606	1605	906268
7780	2606	1606	759390
7781	2607	1607	\N
7782	2525	1608	820905
7783	2525	1609	528927
7784	2525	1610	310608
7785	2607	1608	778344
7786	2526	1612	\N
7787	2608	1614	985720
7788	2527	1616	\N
7789	2609	1615	\N
7790	2609	1616	\N
7791	2609	1617	\N
7792	2609	1618	\N
7793	2527	1619	504803
7794	2527	1621	949564
7795	2527	1623	311610
7796	2527	1624	889958
7797	2609	1619	727775
7798	2528	1625	504901
7799	2610	1625	158623
7800	2610	1626	658130
7801	2529	1627	\N
7802	2611	1627	\N
7803	2611	1629	\N
7804	2611	1630	\N
7805	2529	1631	564480
7806	2611	1631	253911
7807	2530	1633	\N
7808	2530	1634	\N
7809	2612	1633	\N
7810	2612	1634	\N
7811	2612	1636	\N
7812	2530	1638	970306
7813	2612	1637	245955
7814	2613	1639	\N
7815	2531	1640	376406
7816	2531	1641	671490
7817	2531	1642	327552
7818	2532	1643	\N
7819	2614	1643	\N
7820	2614	1644	\N
7821	2532	1645	700977
7822	2532	1646	237264
7823	2532	1648	888944
7824	2614	1646	197855
7825	2614	1647	319374
7826	2614	1649	288555
7827	2533	1650	\N
7828	2615	1650	\N
7829	2533	1652	439937
7830	2533	1653	222244
7831	2533	1655	573233
7832	2615	1651	879951
7833	2615	1653	908939
7834	2615	1654	114960
7835	2534	1656	\N
7836	2534	1657	\N
7837	2616	1657	\N
7838	2616	1659	\N
7839	2616	1660	\N
7840	2534	1661	188478
7841	2616	1661	122786
7842	2617	1663	660218
7843	2618	1664	396806
7844	2619	1665	\N
7845	2619	1666	\N
7846	2620	1667	\N
7847	2535	1668	282034
7848	2621	1668	146198
7849	2536	1670	\N
7850	2536	1671	\N
7851	2536	1673	\N
7852	2536	1674	\N
7853	2622	1669	\N
7854	2622	1671	\N
7855	2622	1673	\N
7856	2622	1674	\N
7857	2622	1675	\N
7858	2536	1677	624494
7859	2623	1678	\N
7860	2537	1679	616594
7861	2623	1679	234227
7862	2538	1680	\N
7863	2624	1680	\N
7864	2624	1681	\N
7865	2624	1682	\N
7866	2538	1683	806638
7867	2538	1684	250688
7868	2538	1685	200919
7869	2625	1686	\N
7870	2539	1687	105878
7871	2539	1688	176641
7872	2540	1689	\N
7873	2626	1689	\N
7874	2626	1690	\N
7875	2626	1692	\N
7876	2626	1693	\N
7877	2540	1695	103046
7878	2627	1696	\N
7879	2627	1697	\N
7880	2541	1698	214496
7881	2541	1699	836387
7882	2541	1700	584067
7883	2541	1701	293432
7884	2627	1699	168338
7885	2542	1702	\N
7886	2542	1703	\N
7887	2542	1704	586994
7888	2542	1705	669643
7889	2628	1704	373671
7890	2543	1706	\N
7891	2543	1707	\N
7892	2543	1708	823009
7893	2543	1709	800687
7894	2629	1709	800148
7895	2544	1710	\N
7896	2630	1711	926794
7897	2630	1713	418792
7898	2631	1714	715636
7899	2632	1716	\N
7900	2632	1717	\N
7901	2545	1719	154338
7902	2545	1720	944546
7903	2545	1722	998576
7904	2632	1718	939581
7905	2632	1719	529387
7906	2632	1720	933310
7907	2546	1723	\N
7908	2546	1724	780695
7909	2633	1724	647353
7910	2633	1725	351203
7911	2633	1726	278248
7912	2634	1727	\N
7913	2634	1728	\N
7914	2634	1729	\N
7915	2547	1730	354095
7916	2547	1732	391448
7917	2547	1733	109710
7918	2634	1730	226771
7919	2548	1734	\N
7920	2635	1734	\N
7921	2635	1735	\N
7922	2635	1736	\N
7923	2635	1738	\N
7924	2549	1739	839105
7925	2550	1741	\N
7926	2636	1742	971032
7927	2637	1743	\N
7928	2551	1745	436842
7929	2551	1746	588644
7930	2551	1748	525293
7931	2637	1744	888931
7932	2638	1749	\N
7933	2638	1750	\N
7934	2638	1752	\N
7935	2552	1753	\N
7936	2552	1754	\N
7937	2639	1755	700436
7938	2640	1756	\N
7939	2678	1756	\N
7940	2640	1757	347507
7941	2640	1758	802793
7942	2640	1759	912516
7943	2640	1760	194563
7944	2678	1757	957807
7945	2678	1758	188058
7946	2678	1759	257778
7947	2678	1761	885529
7948	2710	1757	679564
7949	2710	1759	344367
7950	2710	1761	833884
7951	2710	1762	889687
7952	2711	1764	\N
7953	2711	1765	\N
7954	2641	1766	688004
7955	2641	1767	478293
7956	2679	1766	304009
7957	2711	1766	700792
7958	2680	1768	\N
7959	2680	1769	\N
7960	2680	1770	\N
7961	2642	1772	901410
7962	2712	1771	634769
7963	2712	1772	335058
7964	2712	1773	140128
7965	2643	1774	\N
7966	2643	1776	\N
7967	2643	1777	\N
7968	2643	1778	\N
7969	2681	1779	693479
7970	2681	1780	721567
7971	2681	1781	807047
7972	2681	1782	923696
7973	2681	1784	350783
7974	2682	1785	\N
7975	2682	1786	826325
7976	2682	1787	551785
7977	2682	1788	487572
7978	2713	1787	948275
7979	2683	1789	\N
7980	2683	1790	\N
7981	2683	1791	\N
7982	2683	1793	\N
7983	2683	1794	\N
7984	2714	1789	\N
7985	2644	1795	981330
7986	2644	1796	203109
7987	2645	1797	\N
7988	2645	1798	\N
7989	2684	1797	\N
7990	2684	1799	\N
7991	2715	1797	\N
7992	2684	1800	606025
7993	2715	1800	258184
7994	2715	1801	670404
7995	2715	1802	288475
7996	2646	1804	\N
7997	2685	1803	\N
7998	2646	1805	139206
7999	2646	1806	891568
8000	2646	1808	605557
8001	2646	1809	348387
8002	2685	1805	854164
8003	2685	1806	957879
8004	2685	1807	540581
8005	2685	1808	665724
8006	2647	1810	\N
8007	2647	1812	\N
8008	2647	1814	\N
8009	2686	1810	\N
8010	2686	1816	348028
8011	2716	1816	801111
8012	2716	1818	626900
8013	2716	1820	572954
8014	2716	1821	674470
8015	2648	1823	\N
8016	2648	1824	\N
8017	2717	1822	\N
8018	2648	1825	173697
8019	2648	1826	810145
8020	2648	1828	661675
8021	2687	1826	503978
8022	2687	1827	318254
8023	2687	1828	999589
8024	2687	1830	222406
8025	2649	1831	\N
8026	2649	1832	\N
8027	2718	1831	\N
8028	2718	1833	\N
8029	2718	1834	\N
8030	2649	1836	579341
8031	2649	1837	727382
8032	2718	1836	908261
8033	2650	1838	\N
8034	2688	1839	\N
8035	2688	1841	\N
8036	2688	1842	\N
8037	2688	1844	\N
8038	2719	1839	\N
8039	2719	1840	\N
8040	2650	1846	928326
8041	2650	1847	603317
8042	2688	1846	534093
8043	2719	1846	614368
8044	2719	1847	195656
8045	2651	1848	\N
8046	2651	1849	\N
8047	2651	1850	\N
8048	2689	1849	\N
8049	2720	1848	\N
8050	2720	1851	414448
8051	2720	1852	789205
8052	2720	1853	190697
8053	2652	1854	\N
8054	2652	1855	\N
8055	2652	1857	\N
8056	2690	1854	\N
8057	2690	1855	\N
8058	2721	1854	\N
8059	2721	1855	\N
8060	2721	1856	\N
8061	2721	1857	\N
8062	2652	1858	719679
8063	2691	1859	\N
8064	2691	1860	\N
8065	2691	1862	\N
8066	2691	1864	\N
8067	2691	1865	\N
8068	2722	1859	\N
8069	2722	1860	\N
8070	2722	1861	\N
8071	2653	1867	306171
8072	2654	1868	\N
8073	2654	1869	\N
8074	2692	1868	\N
8075	2692	1869	\N
8076	2692	1870	\N
8077	2723	1868	\N
8078	2654	1872	121836
8079	2654	1873	885212
8080	2723	1871	768687
8081	2655	1875	\N
8082	2724	1874	\N
8083	2693	1876	877068
8084	2693	1877	388544
8085	2693	1878	421069
8086	2693	1879	500315
8087	2693	1880	719276
8088	2724	1877	131118
8089	2724	1879	276215
8090	2694	1882	\N
8091	2694	1883	\N
8092	2694	1884	\N
8093	2694	1886	\N
8094	2725	1881	\N
8095	2656	1887	328114
8096	2656	1888	793342
8097	2656	1889	363706
8098	2694	1887	378376
8099	2725	1887	625638
8100	2657	1890	522739
8101	2657	1891	504018
8102	2657	1893	273982
8103	2695	1890	356110
8104	2695	1891	829940
8105	2726	1890	169187
8106	2658	1894	\N
8107	2658	1895	\N
8108	2658	1896	\N
8109	2658	1897	\N
8110	2696	1899	994836
8111	2727	1900	\N
8112	2727	1901	\N
8113	2659	1903	547952
8114	2659	1905	927546
8115	2697	1903	673450
8116	2698	1906	257149
8117	2698	1907	532871
8118	2698	1909	538177
8119	2698	1910	509920
8120	2728	1907	922142
8121	2699	1912	\N
8122	2699	1913	\N
8123	2699	1914	\N
8124	2729	1912	\N
8125	2729	1913	\N
8126	2729	1914	\N
8127	2699	1915	622386
8128	2730	1917	\N
8129	2700	1919	325786
8130	2700	1921	935914
8131	2730	1919	317354
8132	2730	1920	177622
8133	2701	1922	\N
8134	2701	1923	\N
8135	2701	1924	\N
8136	2701	1926	\N
8137	2660	1927	689072
8138	2701	1927	731786
8139	2731	1928	227324
8140	2661	1929	\N
8141	2661	1931	\N
8142	2732	1929	\N
8143	2732	1930	\N
8144	2732	1931	\N
8145	2732	1932	\N
8146	2732	1934	\N
8147	2661	1935	227861
8148	2702	1935	423436
8149	2702	1936	590460
8150	2702	1938	322150
8151	2702	1939	887669
8152	2702	1940	796606
8153	2662	1941	\N
8154	2662	1942	\N
8155	2733	1941	\N
8156	2733	1943	\N
8157	2733	1945	\N
8158	2662	1946	624719
8159	2662	1947	989521
8160	2662	1948	487581
8161	2733	1946	557311
8162	2663	1949	\N
8163	2663	1950	\N
8164	2663	1951	\N
8165	2703	1949	\N
8166	2703	1950	\N
8167	2703	1951	\N
8168	2734	1949	\N
8169	2734	1951	\N
8170	2734	1952	\N
8171	2703	1953	849448
8172	2734	1954	451754
8173	2734	1955	579549
8174	2735	1956	\N
8175	2735	1957	\N
8176	2704	1958	507504
8177	2735	1958	377339
8178	2735	1960	741644
8179	2735	1961	518154
8180	2664	1962	\N
8181	2705	1962	\N
8182	2705	1963	\N
8183	2736	1964	200453
8184	2665	1965	\N
8185	2706	1965	\N
8186	2706	1966	\N
8187	2706	1967	\N
8188	2706	1969	\N
8189	2706	1970	114633
8190	2737	1971	534563
8191	2737	1973	272654
8192	2737	1974	659984
8193	2666	1975	\N
8194	2707	1975	\N
8195	2707	1976	\N
8196	2707	1977	\N
8197	2707	1978	\N
8198	2738	1975	\N
8199	2666	1979	181500
8200	2666	1980	165218
8201	2666	1981	665529
8202	2666	1982	567888
8203	2708	1983	\N
8204	2708	1984	\N
8205	2739	1983	\N
8206	2667	1986	423590
8207	2667	1987	306046
8208	2667	1989	890237
8209	2667	1991	877132
8210	2667	1992	696345
8211	2739	1986	737783
8212	2740	1993	\N
8213	2668	1995	293538
8214	2740	1995	900109
8215	2740	1996	775040
8216	2740	1997	932951
8217	2740	1998	688875
8218	2669	1999	\N
8219	2709	1999	\N
8220	2709	1	\N
8221	2669	3	370124
8222	2669	5	107729
8223	2669	7	599889
8224	2670	9	\N
8225	2670	10	\N
8226	2670	11	\N
8227	2741	8	\N
8228	2741	10	\N
8229	2741	11	\N
8230	2670	12	285910
8231	2670	14	244526
8232	2741	12	829825
8233	2671	15	242594
8234	2671	16	360358
8235	2742	15	374382
8236	2742	16	190226
8237	2742	17	607567
8238	2672	18	112132
8239	2673	19	938896
8240	2673	20	310131
8241	2673	21	434422
8242	2743	19	352298
8243	2743	20	536252
8244	2743	21	847073
8245	2743	22	525440
8246	2744	24	\N
8247	2744	25	\N
8248	2744	26	\N
8249	2744	27	815593
8250	2744	28	734206
8251	2674	29	\N
8252	2674	30	373466
8253	2745	30	767106
8254	2675	31	\N
8255	2675	32	\N
8256	2675	33	\N
8257	2746	34	\N
8258	2746	36	\N
8259	2676	38	883958
8260	2676	39	226519
8261	2676	40	895195
8262	2676	41	126540
8263	2676	43	164007
8264	2677	44	\N
8265	2677	45	\N
8266	2677	46	\N
8267	2747	44	\N
8268	2677	47	384458
8269	2677	48	338683
8270	2747	47	507098
8271	2747	48	119330
8272	2747	50	498915
8273	2747	51	322380
8274	2748	52	\N
8275	2748	53	\N
8276	2748	54	284006
8277	2748	55	454741
8278	2749	56	127763
8279	2750	57	495972
8280	2750	59	148420
8281	2750	60	838944
8282	2751	62	\N
8283	2751	63	784117
8284	2751	64	268145
8285	2751	66	505855
8286	2751	67	219003
8287	2752	68	790766
8288	2752	69	999988
8289	2752	70	167313
8290	2753	72	\N
8291	2753	74	\N
8292	2753	76	\N
8293	2753	77	715618
8294	2754	79	\N
8295	2754	80	\N
8296	2754	81	906847
8297	2754	82	374216
8298	2754	83	513824
8299	2755	84	\N
8300	2755	85	\N
8301	2755	87	\N
8302	2755	88	\N
8303	2755	89	750483
8304	2756	90	\N
8305	2756	91	\N
8306	2756	92	\N
8307	2757	94	\N
8308	2757	95	233848
8309	2758	96	520790
8310	2758	97	646119
8311	2758	98	782927
8312	2758	100	212226
8313	2759	102	\N
8314	2760	103	\N
8315	2760	104	\N
8316	2761	105	716616
8317	2762	106	\N
8318	2762	107	\N
8319	2762	108	754729
8320	2763	109	\N
8321	2764	110	924106
8322	2764	111	114153
8323	2764	112	398041
8324	2764	113	657945
8325	2765	114	\N
8326	2765	116	640288
8327	2765	117	949592
8328	2765	118	514029
8329	2765	119	796836
8330	2766	120	\N
8331	2766	122	628970
8332	2767	123	812889
8333	2767	124	309252
8334	2768	125	365728
8335	2768	126	250839
8336	2769	128	\N
8337	2769	129	\N
8338	2769	131	\N
8339	2770	133	\N
8340	2770	134	658118
8341	2771	135	\N
8342	2771	137	395592
8343	2772	139	\N
8344	2772	141	258407
8345	2773	142	\N
8346	2773	143	\N
8347	2773	144	\N
8348	2774	145	\N
8349	2774	146	\N
8350	2774	147	\N
8351	2774	148	\N
8352	2774	149	\N
8353	2775	150	\N
8354	2775	151	\N
8355	2775	152	692951
8356	2775	154	637945
8357	2775	155	489766
8358	2776	156	\N
8359	2776	157	\N
8360	2776	159	\N
8361	2776	160	\N
8362	2777	161	590824
8363	2777	162	206522
8364	2777	163	183584
8365	2777	165	745610
8366	2777	166	426267
8367	2778	167	\N
8368	2778	168	\N
8369	2778	169	\N
8370	2779	170	\N
8371	2779	171	\N
8372	2779	172	512716
8373	2780	174	\N
8374	2869	173	\N
8375	2869	174	\N
8376	2780	175	142673
8377	2869	175	668558
8378	2870	177	\N
8379	2781	179	208322
8380	2781	180	911062
8381	2870	178	698793
8382	2782	181	\N
8383	2871	182	\N
8384	2871	184	\N
8385	2782	185	664208
8386	2782	186	793758
8387	2871	185	591685
8388	2871	187	565475
8389	2871	189	933144
8390	2783	190	\N
8391	2783	192	\N
8392	2872	191	\N
8393	2783	194	510872
8394	2783	195	913612
8395	2783	196	315674
8396	2784	197	\N
8397	2784	198	\N
8398	2873	197	\N
8399	2873	198	\N
8400	2873	200	\N
8401	2873	201	806672
8402	2785	202	\N
8403	2785	204	\N
8404	2874	202	\N
8405	2786	205	129402
8406	2786	207	262883
8407	2787	208	212830
8408	2787	210	908975
8409	2875	208	830539
8410	2788	212	\N
8411	2876	211	\N
8412	2876	213	868049
8413	2789	214	375906
8414	2789	215	782760
8415	2789	216	477991
8416	2789	217	203400
8417	2790	219	\N
8418	2790	220	\N
8419	2790	221	357352
8420	2790	223	776746
8421	2790	224	103874
8422	2877	221	172089
8423	2877	222	545790
8424	2878	225	\N
8425	2878	226	330701
8426	2791	227	\N
8427	2792	228	\N
8428	2879	228	\N
8429	2879	229	262777
8430	2879	230	431007
8431	2879	231	987115
8432	2879	232	784336
8433	2880	234	\N
8434	2880	235	\N
8435	2793	236	391685
8436	2881	237	\N
8437	2881	239	\N
8438	2881	241	\N
8439	2794	242	311014
8440	2794	243	708454
8441	2881	242	826759
8442	2795	244	\N
8443	2795	245	\N
8444	2795	246	\N
8445	2796	247	\N
8446	2796	248	\N
8447	2882	249	789925
8448	2882	250	882465
8449	2797	251	\N
8450	2797	252	\N
8451	2797	253	\N
8452	2883	251	\N
8453	2883	253	\N
8454	2883	255	\N
8455	2883	256	\N
8456	2883	257	\N
8457	2797	258	238007
8458	2797	259	546513
8459	2884	260	\N
8460	2884	261	\N
8461	2884	262	\N
8462	2884	263	\N
8463	2884	264	220225
8464	2885	265	\N
8465	2798	266	\N
8466	2798	267	\N
8467	2798	269	\N
8468	2798	270	\N
8469	2886	267	\N
8470	2798	272	128782
8471	2886	271	886747
8472	2886	272	762629
8473	2886	273	737656
8474	2886	275	203777
8475	2887	276	\N
8476	2887	277	\N
8477	2887	279	\N
8478	2887	280	\N
8479	2887	281	808718
8480	2799	282	943386
8481	2888	282	314964
8482	2888	283	813048
8483	2888	285	154383
8484	2888	287	128781
8485	2888	288	734734
8486	2889	289	\N
8487	2889	290	230689
8488	2889	291	270760
8489	2889	292	228082
8490	2889	294	211332
8491	2800	295	698276
8492	2800	297	868458
8493	2800	298	287257
8494	2800	299	522455
8495	2800	300	503745
8496	2890	295	900418
8497	2890	296	673371
8498	2891	302	\N
8499	2801	303	392948
8500	2801	305	872836
8501	2801	306	350034
8502	2891	303	867120
8503	2892	308	\N
8504	2892	309	\N
8505	2802	310	501359
8506	2802	311	627868
8507	2802	312	797286
8508	2803	313	\N
8509	2803	314	\N
8510	2803	315	\N
8511	2803	316	\N
8512	2893	317	382107
8513	2893	318	680819
8514	2893	319	356571
8515	2893	321	882085
8516	2804	322	\N
8517	2805	323	\N
8518	2805	324	\N
8519	2805	325	\N
8520	2805	326	996369
8521	2805	327	437412
8522	2894	327	790702
8523	2895	329	\N
8524	2895	330	\N
8525	2895	332	\N
8526	2895	333	\N
8527	2806	335	712930
8528	2806	336	471247
8529	2895	334	511093
8530	2807	338	747899
8531	2807	339	985334
8532	2807	340	889112
8533	2807	341	122728
8534	2807	343	435351
8535	2808	344	807410
8536	2808	345	633170
8537	2808	346	725769
8538	2896	345	566179
8539	2896	347	743227
8540	2896	348	518763
8541	2896	349	477130
8542	2809	351	\N
8543	2897	351	\N
8544	2897	352	\N
8545	2897	353	\N
8546	2897	354	\N
8547	2810	355	\N
8548	2810	356	\N
8549	2810	358	\N
8550	2810	360	\N
8551	2810	362	\N
8552	2898	356	\N
8553	2898	357	\N
8554	2898	363	509553
8555	2811	364	\N
8556	2811	366	\N
8557	2811	367	\N
8558	2811	368	\N
8559	2811	369	\N
8560	2899	370	458391
8561	2899	371	539004
8562	2899	372	863078
8563	2812	373	\N
8564	2900	374	\N
8565	2900	376	\N
8566	2900	377	\N
8567	2812	379	887361
8568	2812	380	619812
8569	2900	379	847729
8570	2813	382	613117
8571	2813	383	826470
8572	2901	381	367045
8573	2902	384	\N
8574	2902	385	\N
8575	2902	386	\N
8576	2902	387	\N
8577	2814	389	329672
8578	2814	390	945153
8579	2814	391	375340
8580	2814	392	670882
8581	2903	393	\N
8582	2903	394	\N
8583	2903	396	\N
8584	2903	397	\N
8585	2903	398	\N
8586	2815	399	530654
8587	2816	400	\N
8588	2816	401	712873
8589	2816	403	896636
8590	2904	401	721714
8591	2904	402	441899
8592	2904	403	756643
8593	2904	404	421995
8594	2817	406	\N
8595	2817	408	\N
8596	2817	410	656113
8597	2905	409	475467
8598	2905	411	636114
8599	2818	413	\N
8600	2818	414	\N
8601	2906	415	831043
8602	2906	417	783039
8603	2906	418	109089
8604	2819	419	\N
8605	2819	421	774140
8606	2819	422	547522
8607	2907	423	\N
8608	2907	424	\N
8609	2907	426	\N
8610	2820	427	365653
8611	2820	428	338271
8612	2821	430	\N
8613	2821	431	\N
8614	2821	432	\N
8615	2908	434	494266
8616	2908	435	331149
8617	2822	436	\N
8618	2909	437	\N
8619	2909	438	732550
8620	2909	439	990830
8621	2909	440	266492
8622	2823	442	\N
8623	2823	443	\N
8624	2823	444	\N
8625	2823	445	\N
8626	2823	446	\N
8627	2910	447	829154
8628	2911	449	660348
8629	2911	451	819519
8630	2911	452	275692
8631	2824	454	\N
8632	2824	455	\N
8633	2912	453	\N
8634	2912	454	\N
8635	2912	456	\N
8636	2912	457	\N
8637	2824	458	517165
8638	2824	459	682872
8639	2824	460	413441
8640	2825	461	\N
8641	2825	462	\N
8642	2913	461	\N
8643	2913	462	\N
8644	2913	463	\N
8645	2913	464	\N
8646	2913	466	\N
8647	2826	468	\N
8648	2826	469	\N
8649	2914	467	\N
8650	2914	468	\N
8651	2914	470	\N
8652	2914	471	\N
8653	2826	472	352078
8654	2826	474	572798
8655	2827	475	\N
8656	2827	477	397065
8657	2915	476	900822
8658	2915	478	503360
8659	2828	479	\N
8660	2828	480	\N
8661	2828	481	\N
8662	2828	482	910155
8663	2829	484	\N
8664	2916	484	\N
8665	2916	486	\N
8666	2916	488	\N
8667	2916	489	\N
8668	2916	490	\N
8669	2829	491	814093
8670	2829	492	329300
8671	2829	493	764065
8672	2830	495	\N
8673	2917	494	\N
8674	2830	496	888438
8675	2831	497	\N
8676	2831	498	\N
8677	2831	499	\N
8678	2918	498	\N
8679	2918	499	\N
8680	2918	500	\N
8681	2918	501	\N
8682	2918	502	\N
8683	2919	503	\N
8684	2832	504	508328
8685	2832	506	111096
8686	2832	507	376106
8687	2919	504	878582
8688	2833	508	\N
8689	2833	509	\N
8690	2833	510	\N
8691	2920	509	\N
8692	2920	510	\N
8693	2920	511	\N
8694	2920	512	\N
8695	2833	513	900041
8696	2833	514	716200
8697	2834	516	\N
8698	2834	517	300813
8699	2834	519	386308
8700	2834	520	788380
8701	2835	521	\N
8702	2835	522	\N
8703	2835	523	\N
8704	2921	521	\N
8705	2835	524	128537
8706	2836	525	473494
8707	2922	525	947007
8708	2923	526	530114
8709	2923	527	731214
8710	2923	528	149185
8711	2923	529	724955
8712	2923	530	898203
8713	2837	531	\N
8714	2837	532	\N
8715	2837	533	\N
8716	2837	535	519824
8717	2924	535	176699
8718	2924	536	405924
8719	2924	537	838992
8720	2838	538	\N
8721	2925	539	756468
8722	2925	541	158682
8723	2925	543	604888
8724	2925	544	954754
8725	2925	545	905818
8726	2926	546	939933
8727	2926	547	169042
8728	2839	549	\N
8729	2839	551	\N
8730	2927	549	\N
8731	2928	553	881487
8732	2928	554	672770
8733	2928	555	483263
8734	2929	556	\N
8735	2929	558	\N
8736	2929	559	\N
8737	2929	560	\N
8738	2929	561	\N
8739	2840	562	925956
8740	2840	564	688383
8741	2840	566	868755
8742	2840	567	659576
8743	2840	568	843746
8744	2841	570	\N
8745	2841	571	\N
8746	2841	572	\N
8747	2841	573	\N
8748	2930	570	\N
8749	2930	572	\N
8750	2930	574	\N
8751	2930	575	\N
8752	2842	577	\N
8753	2842	578	\N
8754	2842	579	\N
8755	2931	576	\N
8756	2931	580	966011
8757	2931	582	464229
8758	2932	583	\N
8759	2843	584	436675
8760	2843	585	342911
8761	2843	587	880809
8762	2843	589	722645
8763	2843	590	456140
8764	2932	585	199489
8765	2844	591	\N
8766	2844	593	860055
8767	2844	594	579080
8768	2933	592	112141
8769	2934	596	\N
8770	2845	598	\N
8771	2845	600	\N
8772	2935	597	\N
8773	2935	601	925573
8774	2846	603	122332
8775	2846	604	619399
8776	2847	605	\N
8777	2936	605	\N
8778	2936	606	\N
8779	2847	607	647761
8780	2848	609	\N
8781	2848	610	\N
8782	2848	612	\N
8783	2848	614	\N
8784	2848	615	\N
8785	2849	616	\N
8786	2849	617	\N
8787	2937	616	\N
8788	2937	617	\N
8789	2849	618	672629
8790	2849	619	618177
8791	2937	619	311387
8792	2937	621	592116
8793	2850	622	\N
8794	2851	623	\N
8795	2851	624	\N
8796	2851	625	\N
8797	2938	623	\N
8798	2938	624	\N
8799	2851	626	391933
8800	2938	627	647690
8801	2938	628	565129
8802	2852	629	\N
8803	2939	629	\N
8804	2852	630	585558
8805	2852	631	634596
8806	2939	630	973810
8807	2939	631	742284
8808	2939	632	191040
8809	2853	633	552084
8810	2853	635	739086
8811	2854	636	793550
8812	2854	637	719434
8813	2940	636	273114
8814	2940	637	946088
8815	2940	638	441280
8816	2855	640	\N
8817	2855	641	137889
8818	2941	642	917835
8819	2942	643	\N
8820	2942	645	\N
8821	2942	646	\N
8822	2856	647	763934
8823	2856	648	981204
8824	2856	649	234164
8825	2942	647	182853
8826	2942	648	138420
8827	2857	651	\N
8828	2857	652	\N
8829	2943	650	\N
8830	2943	653	100350
8831	2944	654	\N
8832	2944	655	\N
8833	2858	657	664879
8834	2858	658	871987
8835	2858	659	881165
8836	2858	661	681513
8837	2858	663	133917
8838	2859	664	\N
8839	2859	666	\N
8840	2859	667	\N
8841	2859	668	\N
8842	2859	669	\N
8843	2945	671	259787
8844	2945	672	746619
8845	2945	673	708448
8846	2860	674	969376
8847	2860	676	516461
8848	2861	677	\N
8849	2946	678	192554
8850	2946	679	999135
8851	2946	680	147076
8852	2946	682	119798
8853	2862	683	\N
8854	2862	684	\N
8855	2947	683	\N
8856	2947	684	\N
8857	2862	685	825002
8858	2862	687	562441
8859	2862	688	854984
8860	2947	685	581367
8861	2863	689	968516
8862	2863	690	338433
8863	2948	689	484214
8864	2948	690	713635
8865	2948	692	530229
8866	2948	693	296638
8867	2948	695	449366
8868	2864	696	\N
8869	2949	696	\N
8870	2949	697	\N
8871	2949	698	\N
8872	2949	699	\N
8873	2864	700	988853
8874	2864	701	442407
8875	2864	702	703435
8876	2864	703	654401
8877	2865	705	\N
8878	2865	706	\N
8879	2865	707	\N
8880	2950	704	\N
8881	2865	709	167079
8882	2950	708	945994
8883	2950	709	877121
8884	2950	711	333339
8885	2950	713	265602
8886	2951	714	\N
8887	2951	715	\N
8888	2866	716	842681
8889	2866	718	433365
8890	2866	719	207988
8891	2866	720	737151
8892	2951	717	649498
8893	2951	718	632347
8894	2867	721	\N
8895	2952	721	\N
8896	2952	722	562683
8897	2952	723	348636
8898	2952	724	476406
8899	2953	726	\N
8900	2953	727	205840
8901	2953	728	140368
8902	2953	730	978815
8903	2868	732	\N
8904	2954	731	\N
8905	2954	732	\N
8906	2954	733	\N
8907	2868	734	189170
8908	2954	734	537227
8909	2955	736	848957
8910	3027	737	\N
8911	3104	737	\N
8912	3104	738	\N
8913	3027	739	453665
8914	3027	740	659838
8915	3027	741	587803
8916	3104	739	516809
8917	3104	740	382286
8918	3104	741	840863
8919	3028	742	\N
8920	3028	743	\N
8921	3105	742	\N
8922	3105	743	\N
8923	3105	744	\N
8924	2956	745	301944
8925	2956	746	292985
8926	2956	747	985438
8927	2956	748	780446
8928	2956	750	240693
8929	3028	745	340356
8930	3028	746	892687
8931	3105	745	849457
8932	3105	746	660701
8933	2957	751	\N
8934	2957	752	\N
8935	2957	753	\N
8936	3106	751	\N
8937	3106	753	\N
8938	3106	754	\N
8939	3106	756	\N
8940	3106	757	905523
8941	2958	759	\N
8942	3107	759	\N
8943	2958	760	569021
8944	2958	761	726228
8945	3029	761	679420
8946	3107	760	921048
8947	3107	761	656329
8948	3107	762	797547
8949	2959	763	\N
8950	2959	764	\N
8951	2959	765	\N
8952	3030	763	\N
8953	3108	763	\N
8954	3108	764	\N
8955	3108	765	\N
8956	3108	767	\N
8957	3108	768	\N
8958	2959	769	216493
8959	2959	770	866766
8960	2960	771	319131
8961	2960	772	748940
8962	3109	771	664759
8963	2961	774	\N
8964	2962	775	\N
8965	2962	776	\N
8966	2962	777	\N
8967	3031	776	\N
8968	3110	775	\N
8969	3031	778	972290
8970	3031	779	207785
8971	3031	781	801869
8972	3032	782	\N
8973	3111	783	\N
8974	3032	784	265203
8975	3032	786	552225
8976	3111	784	821765
8977	2963	787	\N
8978	3112	787	\N
8979	3033	788	983229
8980	3112	788	626359
8981	3112	789	685460
8982	2964	790	626900
8983	2964	791	327144
8984	2964	792	910879
8985	2964	794	847186
8986	2964	795	583415
8987	3034	790	580790
8988	3034	792	417919
8989	3034	793	869928
8990	3034	794	408184
8991	3113	790	352217
8992	2965	796	\N
8993	2965	797	268633
8994	2965	798	452865
8995	2965	799	375622
8996	3114	797	523400
8997	3114	798	230511
8998	3114	800	381625
8999	3114	801	313100
9000	2966	802	\N
9001	3035	802	\N
9002	3035	803	\N
9003	3035	804	\N
9004	2967	805	\N
9005	3036	805	\N
9006	3036	807	\N
9007	3036	808	\N
9008	3036	809	\N
9009	3115	810	176403
9010	3115	811	939674
9011	3116	813	209310
9012	3116	815	954088
9013	3117	816	\N
9014	3117	817	\N
9015	3117	818	\N
9016	3037	820	417292
9017	3037	822	694140
9018	3037	824	775417
9019	3038	825	\N
9020	3038	826	\N
9021	3038	827	\N
9022	3038	829	\N
9023	3118	825	\N
9024	3118	826	\N
9025	3118	828	\N
9026	3118	829	\N
9027	2968	831	382818
9028	2968	832	798807
9029	2968	834	552263
9030	3038	831	781292
9031	2969	835	\N
9032	3119	835	\N
9033	3119	837	\N
9034	3119	838	424964
9035	3119	840	905437
9036	2970	842	\N
9037	2970	843	\N
9038	2970	845	\N
9039	3039	841	\N
9040	3039	842	\N
9041	3039	843	\N
9042	2970	846	481214
9043	3039	846	479199
9044	3039	848	119350
9045	2971	849	\N
9046	2971	850	\N
9047	2971	851	\N
9048	3040	849	\N
9049	3040	851	\N
9050	3120	849	\N
9051	2971	852	228274
9052	3040	852	434215
9053	3040	854	599401
9054	2972	855	\N
9055	3041	855	\N
9056	3041	856	\N
9057	3121	855	\N
9058	3121	856	\N
9059	2972	857	314081
9060	3041	857	134489
9061	3121	858	108762
9062	2973	859	\N
9063	3042	859	\N
9064	3042	860	\N
9065	3042	861	\N
9066	3122	860	\N
9067	2973	862	572996
9068	2973	863	916337
9069	2973	864	170931
9070	2973	865	489603
9071	3122	863	947494
9072	3122	864	888658
9073	2974	867	\N
9074	2974	869	\N
9075	3043	867	\N
9076	3123	866	\N
9077	3123	867	\N
9078	3123	868	\N
9079	3043	870	423736
9080	3124	871	\N
9081	3044	872	208665
9082	3124	872	684471
9083	2975	873	448066
9084	2975	874	188497
9085	2975	875	914175
9086	3045	874	260582
9087	3045	875	216786
9088	3045	876	293010
9089	3125	873	323322
9090	3125	874	245591
9091	2976	877	\N
9092	2976	879	\N
9093	2976	880	\N
9094	3046	877	\N
9095	3046	878	\N
9096	3046	880	\N
9097	2976	881	940127
9098	3046	881	341125
9099	3126	881	182382
9100	3126	883	338090
9101	2977	884	\N
9102	3047	885	\N
9103	3127	885	\N
9104	3127	886	\N
9105	3127	888	\N
9106	2977	889	726707
9107	3047	889	575890
9108	3047	890	804516
9109	3047	891	555297
9110	2978	892	\N
9111	2978	893	\N
9112	2978	894	\N
9113	2978	895	\N
9114	3048	893	\N
9115	3128	897	408344
9116	3128	898	852346
9117	3128	900	525691
9118	3049	902	\N
9119	3049	903	642556
9120	3049	904	365678
9121	3049	905	744898
9122	2979	907	\N
9123	2979	908	\N
9124	2979	909	\N
9125	3129	906	\N
9126	3129	907	\N
9127	2979	910	261671
9128	2979	911	696915
9129	3050	910	266776
9130	2980	912	\N
9131	3130	912	\N
9132	3130	913	\N
9133	3130	915	\N
9134	3130	917	\N
9135	3051	919	257508
9136	3051	920	816418
9137	3051	921	723292
9138	3051	922	203485
9139	3130	918	754140
9140	3131	923	\N
9141	3131	924	\N
9142	3131	925	139932
9143	3131	926	334071
9144	3052	927	\N
9145	3052	928	\N
9146	3052	929	\N
9147	3052	930	132599
9148	3052	932	296670
9149	2981	934	\N
9150	2981	935	\N
9151	2981	937	141575
9152	2981	938	813789
9153	3053	939	\N
9154	3053	940	\N
9155	3053	941	\N
9156	3132	939	\N
9157	3132	940	\N
9158	2982	942	298126
9159	2982	943	666520
9160	2982	944	340378
9161	3132	943	715042
9162	2983	945	\N
9163	2983	946	\N
9164	2983	948	102878
9165	2984	950	\N
9166	2984	951	\N
9167	3054	949	\N
9168	3054	950	\N
9169	3054	952	\N
9170	3133	949	\N
9171	2984	954	796098
9172	2984	955	518813
9173	3054	954	163970
9174	3134	956	\N
9175	3134	957	\N
9176	2985	958	109393
9177	2985	959	136006
9178	2985	961	458284
9179	2985	963	918713
9180	2985	964	244482
9181	3055	958	151960
9182	2986	966	\N
9183	2986	968	\N
9184	2986	969	\N
9185	2986	970	661714
9186	2986	971	483707
9187	3135	970	558330
9188	3135	972	472564
9189	3136	973	979081
9190	3136	974	772774
9191	3136	975	713258
9192	2987	977	\N
9193	2987	978	\N
9194	2987	979	\N
9195	3056	977	\N
9196	3056	978	\N
9197	2987	980	696488
9198	2987	981	245971
9199	3057	982	\N
9200	3137	984	438022
9201	3137	985	592430
9202	3137	987	734053
9203	2988	988	\N
9204	2988	989	\N
9205	3138	988	\N
9206	2988	990	558730
9207	2988	991	761475
9208	2988	993	551250
9209	3058	990	322491
9210	3138	990	945005
9211	2989	995	\N
9212	3059	994	\N
9213	3059	995	\N
9214	3059	996	\N
9215	3059	997	\N
9216	3139	995	\N
9217	3139	997	\N
9218	2989	998	784830
9219	2989	1000	862892
9220	2989	1001	133677
9221	2989	1002	998039
9222	2990	1003	\N
9223	2990	1004	412396
9224	3060	1004	837449
9225	2991	1005	\N
9226	3061	1005	\N
9227	3061	1006	\N
9228	3061	1007	331157
9229	3140	1007	607773
9230	2992	1008	\N
9231	2992	1009	\N
9232	2992	1010	\N
9233	2992	1012	\N
9234	2992	1014	\N
9235	3062	1008	\N
9236	3062	1009	\N
9237	3062	1010	\N
9238	3062	1012	\N
9239	2993	1016	\N
9240	2993	1018	166102
9241	2993	1019	333177
9242	2993	1020	763735
9243	2993	1021	210352
9244	3063	1017	676966
9245	2994	1023	\N
9246	3064	1022	\N
9247	2994	1024	273387
9248	2994	1025	253174
9249	2994	1026	877810
9250	3064	1024	926908
9251	3064	1025	862860
9252	2995	1027	\N
9253	3065	1028	292265
9254	3065	1029	750961
9255	3065	1030	760044
9256	3065	1031	461022
9257	3065	1032	912575
9258	2996	1034	\N
9259	2996	1036	\N
9260	3066	1034	\N
9261	3066	1035	\N
9262	3066	1036	\N
9263	2996	1037	899413
9264	2996	1038	422412
9265	2996	1039	181004
9266	3066	1038	323381
9267	3066	1039	669808
9268	2997	1041	\N
9269	2997	1042	\N
9270	2997	1044	\N
9271	2997	1046	\N
9272	3067	1040	\N
9273	3067	1041	\N
9274	2997	1048	478267
9275	3067	1047	142782
9276	3068	1049	\N
9277	2998	1050	717629
9278	2998	1051	175347
9279	2998	1052	701803
9280	2998	1053	750249
9281	3069	1054	\N
9282	2999	1055	\N
9283	2999	1056	\N
9284	3070	1055	\N
9285	2999	1058	816256
9286	2999	1060	325992
9287	2999	1061	440324
9288	3070	1058	213672
9289	3070	1059	954535
9290	3000	1062	\N
9291	3000	1063	\N
9292	3000	1064	\N
9293	3000	1066	\N
9294	3071	1062	\N
9295	3071	1063	\N
9296	3071	1065	\N
9297	3000	1067	391171
9298	3071	1068	417109
9299	3072	1069	\N
9300	3072	1070	\N
9301	3072	1071	\N
9302	3001	1073	715432
9303	3001	1074	865322
9304	3072	1072	740268
9305	3073	1075	\N
9306	3073	1077	\N
9307	3073	1078	\N
9308	3073	1079	\N
9309	3002	1080	670233
9310	3002	1081	438320
9311	3002	1082	576037
9312	3002	1083	938692
9313	3002	1085	189228
9314	3073	1080	892740
9315	3074	1086	\N
9316	3074	1087	\N
9317	3074	1089	\N
9318	3003	1090	148346
9319	3003	1091	661384
9320	3003	1092	665132
9321	3003	1093	437717
9322	3003	1094	765725
9323	3075	1095	\N
9324	3075	1096	\N
9325	3075	1097	\N
9326	3076	1099	\N
9327	3076	1100	\N
9328	3004	1102	626424
9329	3004	1104	565482
9330	3004	1106	256161
9331	3004	1107	580496
9332	3076	1101	506703
9333	3076	1102	742858
9334	3076	1103	598203
9335	3005	1108	\N
9336	3005	1109	595866
9337	3077	1110	572953
9338	3078	1112	\N
9339	3078	1114	\N
9340	3078	1115	\N
9341	3078	1116	\N
9342	3078	1118	470996
9343	3079	1120	\N
9344	3079	1121	\N
9345	3079	1122	\N
9346	3079	1124	522475
9347	3006	1125	\N
9348	3006	1127	\N
9349	3006	1129	\N
9350	3006	1130	\N
9351	3080	1125	\N
9352	3006	1132	757469
9353	3080	1131	234918
9354	3080	1133	613619
9355	3080	1134	447339
9356	3080	1135	368720
9357	3081	1136	\N
9358	3007	1137	950307
9359	3007	1138	471359
9360	3007	1139	141790
9361	3081	1138	103731
9362	3081	1140	313881
9363	3081	1141	539351
9364	3008	1142	\N
9365	3008	1143	\N
9366	3008	1144	698313
9367	3082	1144	504819
9368	3082	1145	937149
9369	3083	1146	\N
9370	3083	1147	\N
9371	3083	1148	288122
9372	3083	1149	732930
9373	3083	1150	371802
9374	3084	1151	\N
9375	3084	1152	\N
9376	3009	1153	\N
9377	3009	1155	\N
9378	3009	1156	\N
9379	3009	1158	\N
9380	3085	1153	\N
9381	3085	1155	\N
9382	3010	1159	\N
9383	3086	1159	\N
9384	3086	1160	\N
9385	3010	1161	679066
9386	3010	1162	214149
9387	3086	1162	590725
9388	3011	1163	\N
9389	3011	1164	\N
9390	3087	1163	\N
9391	3087	1165	\N
9392	3087	1166	\N
9393	3011	1167	618099
9394	3011	1169	507980
9395	3012	1171	\N
9396	3012	1172	\N
9397	3012	1173	\N
9398	3088	1170	\N
9399	3088	1171	\N
9400	3088	1174	325367
9401	3088	1175	996817
9402	3088	1176	946001
9403	3089	1177	391377
9404	3013	1179	302064
9405	3013	1180	115014
9406	3090	1179	577650
9407	3090	1180	839245
9408	3090	1182	850425
9409	3090	1183	401081
9410	3090	1184	973708
9411	3091	1185	\N
9412	3091	1186	\N
9413	3091	1187	\N
9414	3091	1188	\N
9415	3014	1189	812952
9416	3014	1191	683862
9417	3015	1192	\N
9418	3015	1193	\N
9419	3015	1194	\N
9420	3092	1192	\N
9421	3015	1195	917585
9422	3015	1196	558007
9423	3016	1197	\N
9424	3017	1198	\N
9425	3017	1199	\N
9426	3017	1200	\N
9427	3017	1201	\N
9428	3093	1198	\N
9429	3093	1200	\N
9430	3017	1203	137312
9431	3093	1202	152275
9432	3093	1203	670542
9433	3093	1204	738446
9434	3018	1206	\N
9435	3018	1208	\N
9436	3094	1205	\N
9437	3094	1206	\N
9438	3019	1209	\N
9439	3095	1210	\N
9440	3095	1212	\N
9441	3019	1213	634524
9442	3019	1214	140895
9443	3019	1215	215950
9444	3020	1217	\N
9445	3020	1218	\N
9446	3020	1219	\N
9447	3020	1220	\N
9448	3020	1221	\N
9449	3096	1217	\N
9450	3021	1222	\N
9451	3021	1223	\N
9452	3097	1225	611814
9453	3097	1227	726938
9454	3022	1229	\N
9455	3022	1230	\N
9456	3022	1232	364975
9457	3098	1231	539698
9458	3098	1232	586724
9459	3098	1233	758516
9460	3023	1235	\N
9461	3099	1234	\N
9462	3023	1236	547549
9463	3023	1237	837838
9464	3023	1238	880907
9465	3023	1239	323468
9466	3099	1236	607405
9467	3100	1240	129088
9468	3024	1242	666400
9469	3024	1243	873638
9470	3024	1245	206390
9471	3024	1246	428836
9472	3024	1247	555550
9473	3101	1241	606966
9474	3101	1242	795773
9475	3025	1249	\N
9476	3025	1250	\N
9477	3102	1248	\N
9478	3102	1249	\N
9479	3102	1251	\N
9480	3102	1252	\N
9481	3102	1253	\N
9482	3103	1254	\N
9483	3103	1255	\N
9484	3103	1256	\N
9485	3026	1257	189454
9486	3026	1258	758389
9487	3026	1259	434818
9488	3026	1261	794837
9489	3026	1262	237591
9490	3103	1257	327962
9491	3141	1263	\N
9492	3141	1264	\N
9493	3141	1265	\N
9494	3141	1266	\N
9495	3215	1263	\N
9496	3215	1264	\N
9497	3303	1264	\N
9498	3303	1265	\N
9499	3215	1267	987448
9500	3303	1267	521816
9501	3142	1269	138529
9502	3142	1270	126390
9503	3142	1271	301387
9504	3142	1272	536426
9505	3142	1273	608745
9506	3304	1269	329859
9507	3304	1270	250808
9508	3304	1271	222649
9509	3304	1272	792027
9510	3143	1274	\N
9511	3143	1276	\N
9512	3216	1274	\N
9513	3216	1275	\N
9514	3216	1276	\N
9515	3305	1274	\N
9516	3216	1277	712562
9517	3144	1278	\N
9518	3306	1278	\N
9519	3306	1279	\N
9520	3144	1280	611657
9521	3144	1281	651914
9522	3144	1282	782280
9523	3145	1283	\N
9524	3217	1284	\N
9525	3217	1285	\N
9526	3217	1286	\N
9527	3217	1287	\N
9528	3307	1283	\N
9529	3307	1284	\N
9530	3307	1285	\N
9531	3307	1287	\N
9532	3217	1289	339677
9533	3307	1288	386748
9534	3146	1290	\N
9535	3146	1291	\N
9536	3308	1290	\N
9537	3308	1291	\N
9538	3308	1292	\N
9539	3146	1293	400943
9540	3308	1293	836024
9541	3218	1295	\N
9542	3218	1296	617410
9543	3218	1298	491204
9544	3309	1297	570851
9545	3309	1298	589942
9546	3309	1299	808631
9547	3309	1300	511144
9548	3219	1302	\N
9549	3219	1304	\N
9550	3219	1305	\N
9551	3147	1306	921865
9552	3147	1307	456639
9553	3147	1308	509241
9554	3219	1306	161708
9555	3219	1307	587924
9556	3310	1306	670789
9557	3310	1307	289424
9558	3310	1308	391822
9559	3310	1309	765610
9560	3310	1310	477453
9561	3148	1311	\N
9562	3148	1312	\N
9563	3311	1312	\N
9564	3311	1313	\N
9565	3311	1315	\N
9566	3311	1316	\N
9567	3311	1317	827429
9568	3220	1318	\N
9569	3220	1319	\N
9570	3149	1321	777561
9571	3149	1323	552821
9572	3220	1320	818404
9573	3312	1320	165084
9574	3312	1321	255615
9575	3312	1322	165423
9576	3150	1324	\N
9577	3150	1325	\N
9578	3221	1324	\N
9579	3221	1326	\N
9580	3221	1328	\N
9581	3150	1329	827457
9582	3150	1330	754089
9583	3313	1329	892277
9584	3313	1330	850687
9585	3313	1332	396830
9586	3151	1333	\N
9587	3151	1334	\N
9588	3151	1335	\N
9589	3151	1336	\N
9590	3151	1338	983952
9591	3222	1337	115199
9592	3222	1338	721138
9593	3222	1339	583188
9594	3222	1341	270163
9595	3314	1337	512229
9596	3223	1342	\N
9597	3223	1343	\N
9598	3315	1342	\N
9599	3315	1343	\N
9600	3223	1344	766241
9601	3223	1345	555475
9602	3224	1346	\N
9603	3224	1347	\N
9604	3224	1348	\N
9605	3316	1346	\N
9606	3316	1347	\N
9607	3152	1349	537445
9608	3152	1350	843447
9609	3152	1351	393135
9610	3152	1352	638799
9611	3152	1353	293283
9612	3316	1349	758434
9613	3225	1354	\N
9614	3225	1355	\N
9615	3225	1356	\N
9616	3225	1357	\N
9617	3317	1354	\N
9618	3317	1358	628954
9619	3153	1359	196691
9620	3226	1359	996199
9621	3318	1360	958245
9622	3154	1361	\N
9623	3154	1363	\N
9624	3154	1364	\N
9625	3154	1365	\N
9626	3227	1361	\N
9627	3319	1362	\N
9628	3319	1363	\N
9629	3227	1366	835504
9630	3227	1367	186660
9631	3227	1368	360164
9632	3227	1369	782874
9633	3228	1370	\N
9634	3228	1372	823736
9635	3228	1374	525213
9636	3228	1376	984159
9637	3228	1378	264004
9638	3155	1379	\N
9639	3229	1379	\N
9640	3320	1379	\N
9641	3320	1381	\N
9642	3320	1382	\N
9643	3155	1383	514600
9644	3155	1384	559020
9645	3156	1385	\N
9646	3156	1386	\N
9647	3156	1388	346352
9648	3156	1389	466299
9649	3156	1390	546572
9650	3230	1391	\N
9651	3230	1393	\N
9652	3230	1395	\N
9653	3321	1391	\N
9654	3321	1393	\N
9655	3321	1394	\N
9656	3321	1396	\N
9657	3157	1398	961946
9658	3157	1399	656774
9659	3157	1400	349200
9660	3230	1397	945853
9661	3230	1398	882118
9662	3321	1397	250661
9663	3158	1402	\N
9664	3231	1401	\N
9665	3231	1402	\N
9666	3322	1401	\N
9667	3322	1402	\N
9668	3158	1403	340240
9669	3158	1404	268223
9670	3231	1403	680203
9671	3322	1403	676604
9672	3322	1405	848586
9673	3159	1407	\N
9674	3159	1408	917018
9675	3232	1409	210091
9676	3323	1409	305500
9677	3323	1411	367556
9678	3323	1412	546980
9679	3233	1414	\N
9680	3233	1415	\N
9681	3233	1416	\N
9682	3233	1417	\N
9683	3324	1413	\N
9684	3324	1414	\N
9685	3324	1415	\N
9686	3160	1418	670292
9687	3233	1418	247554
9688	3161	1420	\N
9689	3161	1421	\N
9690	3161	1422	\N
9691	3325	1420	\N
9692	3325	1421	\N
9693	3161	1423	243045
9694	3161	1424	206185
9695	3325	1423	808600
9696	3325	1425	346628
9697	3325	1426	882584
9698	3162	1427	\N
9699	3162	1428	\N
9700	3234	1427	\N
9701	3234	1430	744585
9702	3234	1431	330807
9703	3234	1432	648281
9704	3235	1433	\N
9705	3235	1434	\N
9706	3326	1434	\N
9707	3326	1435	245220
9708	3326	1436	374349
9709	3326	1437	992729
9710	3326	1438	773728
9711	3236	1440	\N
9712	3236	1441	\N
9713	3327	1439	\N
9714	3163	1443	280688
9715	3163	1444	441827
9716	3236	1443	456700
9717	3236	1444	335340
9718	3236	1445	324550
9719	3327	1443	698541
9720	3327	1444	380750
9721	3327	1446	713830
9722	3327	1447	231748
9723	3328	1448	\N
9724	3328	1449	\N
9725	3164	1450	651530
9726	3164	1451	575887
9727	3164	1452	498577
9728	3237	1450	866476
9729	3237	1451	174604
9730	3238	1454	\N
9731	3329	1454	\N
9732	3329	1455	\N
9733	3238	1456	898955
9734	3238	1458	321771
9735	3329	1457	918652
9736	3165	1459	\N
9737	3165	1460	\N
9738	3239	1459	\N
9739	3239	1460	\N
9740	3239	1461	242693
9741	3239	1463	787246
9742	3239	1464	539167
9743	3330	1461	743922
9744	3166	1465	\N
9745	3166	1466	\N
9746	3240	1465	\N
9747	3331	1468	555394
9748	3331	1469	660501
9749	3167	1470	\N
9750	3241	1470	\N
9751	3241	1471	\N
9752	3241	1473	\N
9753	3241	1474	\N
9754	3167	1475	189368
9755	3168	1476	\N
9756	3168	1478	\N
9757	3168	1479	\N
9758	3242	1477	\N
9759	3332	1480	624143
9760	3332	1481	525318
9761	3169	1482	\N
9762	3169	1483	\N
9763	3169	1484	\N
9764	3243	1482	\N
9765	3244	1486	\N
9766	3244	1487	\N
9767	3333	1485	\N
9768	3333	1487	\N
9769	3333	1488	\N
9770	3333	1489	\N
9771	3170	1490	836966
9772	3170	1492	241090
9773	3170	1493	730746
9774	3244	1490	981564
9775	3171	1494	\N
9776	3171	1495	\N
9777	3245	1495	\N
9778	3171	1496	956163
9779	3171	1497	843060
9780	3245	1496	658583
9781	3245	1497	154937
9782	3334	1496	276443
9783	3334	1497	382105
9784	3334	1499	397131
9785	3334	1500	464267
9786	3334	1501	609888
9787	3246	1502	\N
9788	3246	1503	\N
9789	3246	1505	\N
9790	3246	1507	\N
9791	3335	1502	\N
9792	3172	1509	\N
9793	3172	1511	486285
9794	3172	1512	215108
9795	3172	1514	937224
9796	3247	1510	355208
9797	3247	1511	177001
9798	3247	1512	958391
9799	3336	1516	\N
9800	3173	1517	217365
9801	3173	1519	119833
9802	3173	1520	486239
9803	3173	1521	178030
9804	3248	1517	304433
9805	3248	1518	697131
9806	3248	1519	169361
9807	3249	1522	\N
9808	3249	1523	\N
9809	3337	1523	\N
9810	3174	1524	708709
9811	3175	1526	\N
9812	3175	1527	448457
9813	3250	1527	128477
9814	3251	1528	\N
9815	3251	1529	\N
9816	3338	1528	\N
9817	3176	1530	685499
9818	3176	1531	605094
9819	3176	1532	677522
9820	3176	1533	181390
9821	3338	1531	768135
9822	3338	1532	513502
9823	3339	1535	\N
9824	3339	1536	\N
9825	3339	1537	\N
9826	3252	1538	921890
9827	3339	1538	888118
9828	3339	1539	335814
9829	3177	1540	\N
9830	3177	1542	\N
9831	3177	1543	\N
9832	3177	1544	\N
9833	3177	1545	424222
9834	3178	1546	\N
9835	3253	1546	\N
9836	3340	1546	\N
9837	3340	1548	\N
9838	3253	1549	831852
9839	3253	1550	397848
9840	3253	1551	661469
9841	3340	1549	683214
9842	3340	1551	312707
9843	3341	1552	\N
9844	3341	1553	219675
9845	3341	1554	251685
9846	3341	1555	795698
9847	3179	1556	\N
9848	3254	1557	\N
9849	3254	1558	\N
9850	3254	1560	\N
9851	3254	1561	\N
9852	3342	1556	\N
9853	3342	1557	\N
9854	3342	1558	\N
9855	3342	1559	\N
9856	3342	1560	\N
9857	3179	1562	442211
9858	3254	1562	391364
9859	3343	1563	\N
9860	3343	1564	\N
9861	3180	1565	665118
9862	3180	1566	975908
9863	3343	1565	296372
9864	3343	1566	861189
9865	3181	1567	\N
9866	3255	1567	\N
9867	3344	1567	\N
9868	3255	1568	427590
9869	3344	1569	663671
9870	3182	1570	\N
9871	3182	1571	\N
9872	3256	1570	\N
9873	3256	1572	\N
9874	3256	1573	\N
9875	3256	1574	\N
9876	3182	1575	103961
9877	3345	1576	581398
9878	3183	1577	\N
9879	3257	1577	\N
9880	3257	1578	\N
9881	3257	1580	\N
9882	3346	1577	\N
9883	3257	1581	834439
9884	3346	1581	965918
9885	3258	1582	\N
9886	3347	1582	\N
9887	3347	1583	\N
9888	3347	1584	\N
9889	3347	1585	\N
9890	3184	1586	522301
9891	3184	1587	713415
9892	3347	1586	132492
9893	3185	1588	\N
9894	3185	1589	\N
9895	3185	1590	\N
9896	3185	1591	\N
9897	3259	1588	\N
9898	3259	1589	\N
9899	3259	1590	\N
9900	3348	1588	\N
9901	3185	1592	192645
9902	3260	1593	\N
9903	3349	1593	\N
9904	3349	1594	\N
9905	3186	1595	702325
9906	3349	1595	653837
9907	3349	1596	865300
9908	3187	1598	\N
9909	3187	1599	\N
9910	3187	1600	\N
9911	3187	1601	\N
9912	3187	1602	\N
9913	3261	1598	\N
9914	3350	1598	\N
9915	3188	1604	\N
9916	3188	1606	\N
9917	3188	1607	\N
9918	3188	1608	\N
9919	3351	1603	\N
9920	3351	1609	588564
9921	3351	1610	713779
9922	3189	1612	\N
9923	3262	1612	\N
9924	3262	1613	\N
9925	3352	1611	\N
9926	3189	1614	854942
9927	3189	1615	318299
9928	3189	1617	110162
9929	3189	1619	671823
9930	3262	1615	458743
9931	3262	1616	803555
9932	3190	1620	\N
9933	3190	1621	\N
9934	3263	1620	\N
9935	3263	1621	\N
9936	3263	1623	397475
9937	3263	1624	126249
9938	3263	1625	457947
9939	3353	1622	790965
9940	3191	1626	\N
9941	3191	1627	\N
9942	3264	1626	\N
9943	3191	1629	467420
9944	3191	1631	408831
9945	3191	1632	777382
9946	3354	1628	667198
9947	3355	1634	\N
9948	3355	1635	\N
9949	3355	1637	\N
9950	3355	1638	\N
9951	3192	1640	\N
9952	3265	1639	\N
9953	3265	1640	\N
9954	3356	1639	\N
9955	3265	1642	274396
9956	3356	1641	568783
9957	3356	1642	542534
9958	3356	1643	449803
9959	3356	1645	700095
9960	3193	1646	\N
9961	3193	1647	\N
9962	3193	1649	\N
9963	3266	1646	\N
9964	3357	1646	\N
9965	3357	1647	\N
9966	3357	1648	\N
9967	3266	1650	784819
9968	3266	1651	185523
9969	3357	1651	656472
9970	3267	1652	\N
9971	3267	1653	\N
9972	3358	1652	\N
9973	3194	1654	379749
9974	3194	1656	571290
9975	3194	1657	691266
9976	3194	1658	936999
9977	3194	1659	625772
9978	3267	1655	137665
9979	3358	1654	240137
9980	3358	1655	537540
9981	3358	1657	853583
9982	3359	1660	\N
9983	3359	1661	\N
9984	3359	1663	\N
9985	3359	1665	\N
9986	3359	1666	\N
9987	3195	1668	453683
9988	3268	1667	932969
9989	3268	1668	121761
9990	3268	1669	338492
9991	3268	1670	451275
9992	3196	1671	\N
9993	3196	1672	\N
9994	3196	1673	\N
9995	3196	1675	\N
9996	3196	1676	\N
9997	3269	1671	\N
9998	3360	1672	\N
9999	3269	1677	515490
10000	3269	1678	703497
10001	3270	1679	\N
10002	3270	1681	\N
10003	3361	1679	\N
10004	3197	1683	770403
10005	3270	1682	880648
10006	3271	1684	\N
10007	3198	1685	973372
10008	3199	1686	\N
10009	3272	1686	\N
10010	3362	1686	\N
10011	3199	1688	575754
10012	3199	1690	535220
10013	3199	1691	285732
10014	3272	1687	539937
10015	3272	1689	234146
10016	3272	1690	247769
10017	3272	1691	361684
10018	3200	1693	\N
10019	3200	1694	\N
10020	3273	1693	\N
10021	3363	1695	736003
10022	3363	1696	698739
10023	3363	1697	195932
10024	3363	1698	163351
10025	3363	1699	197246
10026	3274	1700	\N
10027	3274	1701	\N
10028	3201	1702	239946
10029	3201	1704	376024
10030	3201	1706	221531
10031	3274	1703	244124
10032	3274	1704	749712
10033	3274	1705	855643
10034	3202	1708	\N
10035	3202	1709	\N
10036	3202	1710	\N
10037	3202	1711	\N
10038	3275	1707	\N
10039	3364	1707	\N
10040	3364	1708	\N
10041	3364	1713	287457
10042	3364	1714	823987
10043	3365	1715	\N
10044	3365	1716	\N
10045	3365	1717	\N
10046	3365	1718	\N
10047	3203	1719	271152
10048	3276	1720	390451
10049	3276	1721	188081
10050	3204	1722	\N
10051	3204	1724	\N
10052	3204	1726	\N
10053	3366	1722	\N
10054	3366	1724	\N
10055	3366	1725	\N
10056	3366	1726	\N
10057	3366	1727	\N
10058	3204	1728	357051
10059	3205	1729	\N
10060	3205	1730	\N
10061	3367	1729	\N
10062	3205	1731	507706
10063	3277	1731	485713
10064	3277	1732	378926
10065	3277	1733	735502
10066	3367	1731	587933
10067	3367	1732	866525
10068	3368	1734	\N
10069	3206	1736	275119
10070	3206	1738	144350
10071	3278	1735	364987
10072	3278	1737	643536
10073	3278	1738	757081
10074	3278	1739	870871
10075	3368	1735	912230
10076	3368	1736	748191
10077	3207	1740	329994
10078	3279	1740	986163
10079	3369	1740	799920
10080	3369	1741	298541
10081	3369	1743	309021
10082	3280	1745	\N
10083	3280	1746	\N
10084	3280	1748	\N
10085	3370	1744	\N
10086	3370	1745	\N
10087	3370	1746	\N
10088	3208	1750	820409
10089	3208	1751	160268
10090	3208	1752	636721
10091	3208	1754	174464
10092	3370	1749	672658
10093	3370	1750	519899
10094	3209	1755	\N
10095	3281	1755	\N
10096	3209	1756	288634
10097	3281	1756	695498
10098	3371	1756	512048
10099	3372	1758	\N
10100	3282	1759	747361
10101	3282	1760	110126
10102	3282	1761	721844
10103	3372	1759	674451
10104	3372	1760	518729
10105	3372	1762	950959
10106	3372	1764	396055
10107	3210	1766	\N
10108	3283	1765	\N
10109	3283	1767	542266
10110	3283	1768	700937
10111	3373	1767	711103
10112	3211	1769	\N
10113	3211	1770	\N
10114	3284	1769	\N
10115	3211	1771	753245
10116	3211	1772	559853
10117	3211	1773	159878
10118	3284	1771	284089
10119	3374	1771	946741
10120	3212	1774	910309
10121	3375	1774	353856
10122	3213	1775	\N
10123	3213	1777	\N
10124	3213	1779	\N
10125	3285	1775	\N
10126	3213	1780	399884
10127	3213	1781	195945
10128	3376	1780	628391
10129	3376	1781	404124
10130	3376	1782	462385
10131	3377	1783	\N
10132	3214	1784	954362
10133	3286	1784	423706
10134	3286	1785	967929
10135	3286	1786	575565
10136	3377	1785	678213
10137	3377	1786	658059
10138	3287	1787	\N
10139	3287	1788	\N
10140	3287	1789	992982
10141	3287	1790	284013
10142	3287	1791	237322
10143	3378	1789	513245
10144	3378	1791	692736
10145	3379	1793	\N
10146	3379	1794	\N
10147	3380	1796	\N
10148	3288	1797	\N
10149	3381	1797	\N
10150	3288	1799	888893
10151	3288	1800	553376
10152	3288	1801	521247
10153	3381	1799	862307
10154	3381	1800	628123
10155	3289	1802	\N
10156	3382	1802	\N
10157	3289	1803	528793
10158	3289	1804	760687
10159	3382	1803	553826
10160	3290	1805	\N
10161	3290	1806	798300
10162	3290	1807	924404
10163	3290	1808	342649
10164	3290	1809	976623
10165	3383	1806	112115
10166	3383	1808	898204
10167	3383	1810	543995
10168	3383	1811	822998
10169	3291	1812	428390
10170	3291	1814	664018
10171	3291	1815	499306
10172	3291	1816	691363
10173	3291	1818	883522
10174	3292	1820	\N
10175	3384	1819	\N
10176	3384	1820	\N
10177	3384	1821	\N
10178	3384	1822	326083
10179	3293	1823	\N
10180	3293	1824	\N
10181	3385	1824	\N
10182	3293	1826	353954
10183	3293	1828	794842
10184	3293	1829	383388
10185	3385	1825	392224
10186	3385	1826	980865
10187	3386	1830	\N
10188	3386	1831	\N
10189	3294	1832	740385
10190	3386	1832	383069
10191	3387	1833	\N
10192	3387	1834	\N
10193	3387	1835	\N
10194	3295	1836	229891
10195	3295	1837	449382
10196	3387	1836	827013
10197	3388	1838	\N
10198	3388	1840	\N
10199	3388	1841	\N
10200	3388	1842	504771
10201	3388	1843	170887
10202	3296	1844	\N
10203	3389	1844	\N
10204	3296	1845	510662
10205	3296	1846	688649
10206	3390	1847	\N
10207	3391	1848	\N
10208	3391	1849	\N
10209	3391	1850	\N
10210	3391	1851	\N
10211	3391	1852	\N
10212	3297	1853	229910
10213	3297	1854	756750
10214	3298	1855	\N
10215	3298	1856	946338
10216	3392	1856	669511
10217	3392	1857	181113
10218	3392	1858	214413
10219	3392	1860	112496
10220	3299	1862	396632
10221	3299	1864	935944
10222	3299	1865	777126
10223	3299	1867	932464
10224	3393	1861	503830
10225	3393	1862	931280
10226	3300	1868	\N
10227	3300	1869	\N
10228	3300	1870	\N
10229	3301	1871	\N
10230	3301	1873	\N
10231	3394	1871	\N
10232	3301	1874	542931
10233	3395	1875	\N
10234	3395	1876	\N
10235	3302	1877	\N
10236	3396	1877	\N
10237	3302	1878	667094
10238	3302	1879	860053
10239	3302	1880	348094
10240	3302	1881	410765
10241	3397	1883	\N
10242	3397	1885	874052
10243	3398	1886	\N
10244	3451	1886	\N
10245	3451	1888	\N
10246	3451	1889	\N
10247	3488	1886	\N
10248	3451	1890	363281
10249	3451	1891	711521
10250	3488	1890	613177
10251	3488	1891	656158
10252	3488	1892	428891
10253	3399	1893	\N
10254	3452	1893	\N
10255	3452	1894	\N
10256	3452	1896	\N
10257	3452	1897	\N
10258	3452	1898	\N
10259	3400	1900	535030
10260	3453	1900	465116
10261	3489	1900	240104
10262	3401	1901	151406
10263	3401	1902	311702
10264	3401	1904	381044
10265	3401	1905	899830
10266	3401	1907	156958
10267	3454	1901	868839
10268	3454	1903	511699
10269	3490	1902	370958
10270	3490	1903	183893
10271	3490	1904	463442
10272	3402	1908	\N
10273	3402	1909	\N
10274	3455	1908	\N
10275	3455	1909	\N
10276	3455	1910	\N
10277	3455	1911	\N
10278	3455	1912	\N
10279	3491	1908	\N
10280	3491	1909	\N
10281	3491	1910	\N
10282	3492	1914	\N
10283	3492	1915	\N
10284	3403	1916	930704
10285	3492	1917	722871
10286	3492	1918	210065
10287	3404	1920	\N
10288	3404	1921	\N
10289	3493	1919	\N
10290	3493	1920	\N
10291	3493	1921	\N
10292	3456	1922	943095
10293	3456	1924	689111
10294	3456	1925	106196
10295	3456	1926	141220
10296	3456	1927	408950
10297	3405	1928	\N
10298	3457	1928	\N
10299	3494	1928	\N
10300	3494	1929	\N
10301	3494	1930	\N
10302	3405	1932	840947
10303	3405	1933	841564
10304	3405	1934	198028
10305	3405	1936	882989
10306	3494	1931	864492
10307	3495	1938	\N
10308	3406	1940	421115
10309	3458	1939	161103
10310	3407	1942	\N
10311	3459	1941	\N
10312	3459	1943	\N
10313	3459	1944	\N
10314	3407	1945	447036
10315	3407	1946	301176
10316	3459	1945	319325
10317	3459	1946	361063
10318	3408	1948	\N
10319	3408	1949	\N
10320	3408	1950	\N
10321	3408	1951	\N
10322	3408	1952	\N
10323	3460	1947	\N
10324	3460	1949	\N
10325	3460	1951	\N
10326	3460	1952	\N
10327	3496	1947	\N
10328	3496	1953	916483
10329	3496	1954	155050
10330	3496	1955	307796
10331	3409	1956	\N
10332	3409	1958	\N
10333	3461	1957	\N
10334	3497	1956	\N
10335	3497	1957	\N
10336	3410	1959	\N
10337	3410	1960	\N
10338	3462	1960	\N
10339	3462	1961	\N
10340	3462	1963	\N
10341	3462	1964	\N
10342	3498	1965	498644
10343	3411	1966	\N
10344	3463	1966	\N
10345	3463	1968	\N
10346	3499	1967	\N
10347	3499	1970	783824
10348	3499	1971	635128
10349	3500	1973	\N
10350	3500	1974	\N
10351	3500	1975	\N
10352	3500	1977	\N
10353	3464	1978	320874
10354	3464	1979	846324
10355	3412	1980	\N
10356	3412	1981	\N
10357	3501	1981	\N
10358	3412	1982	322158
10359	3412	1983	522439
10360	3412	1985	811644
10361	3465	1982	553061
10362	3465	1984	609177
10363	3413	1986	\N
10364	3413	1987	\N
10365	3466	1987	\N
10366	3466	1989	\N
10367	3502	1987	\N
10368	3466	1990	215822
10369	3466	1991	371068
10370	3414	1992	\N
10371	3414	1993	\N
10372	3414	1995	\N
10373	3414	1996	\N
10374	3503	1992	\N
10375	3414	1998	821473
10376	3467	1997	210268
10377	3467	1998	757252
10378	3467	0	667488
10379	3467	1	566092
10380	3415	2	\N
10381	3468	3	\N
10382	3468	4	\N
10383	3468	6	\N
10384	3504	8	316216
10385	3504	9	908903
10386	3469	10	\N
10387	3505	10	\N
10388	3505	12	\N
10389	3505	14	\N
10390	3505	15	\N
10391	3505	16	434888
10392	3416	17	122120
10393	3417	18	\N
10394	3506	18	\N
10395	3417	19	753994
10396	3417	21	677545
10397	3417	22	977485
10398	3470	20	367547
10399	3470	21	121045
10400	3470	22	655075
10401	3470	23	571125
10402	3418	24	\N
10403	3471	24	\N
10404	3471	25	\N
10405	3507	25	\N
10406	3418	26	328818
10407	3471	26	178016
10408	3471	28	142802
10409	3471	29	985869
10410	3507	26	235346
10411	3507	27	942051
10412	3507	28	817876
10413	3419	30	\N
10414	3419	31	\N
10415	3419	32	\N
10416	3472	30	\N
10417	3472	31	\N
10418	3472	33	\N
10419	3420	34	\N
10420	3420	36	\N
10421	3420	38	\N
10422	3420	39	\N
10423	3420	40	\N
10424	3473	41	624092
10425	3473	43	364589
10426	3473	44	290253
10427	3508	41	880859
10428	3508	43	943478
10429	3508	44	557957
10430	3474	45	\N
10431	3474	46	\N
10432	3474	47	\N
10433	3474	48	\N
10434	3474	49	173988
10435	3509	49	506520
10436	3509	51	840902
10437	3509	52	104343
10438	3475	53	\N
10439	3475	54	\N
10440	3475	55	341599
10441	3475	57	823282
10442	3475	58	711860
10443	3476	59	\N
10444	3476	60	866380
10445	3510	61	564823
10446	3510	62	254026
10447	3421	63	\N
10448	3421	64	\N
10449	3477	64	\N
10450	3511	63	\N
10451	3477	65	338884
10452	3477	66	601486
10453	3511	65	837020
10454	3422	67	\N
10455	3478	67	\N
10456	3478	68	\N
10457	3478	69	\N
10458	3512	67	\N
10459	3422	70	454923
10460	3422	72	788092
10461	3422	73	130357
10462	3422	75	977644
10463	3512	70	369751
10464	3512	71	565288
10465	3479	77	\N
10466	3423	79	102066
10467	3423	80	239896
10468	3423	81	914664
10469	3423	82	794473
10470	3423	84	171133
10471	3479	79	102588
10472	3479	80	254170
10473	3424	85	\N
10474	3424	86	\N
10475	3424	88	\N
10476	3424	90	\N
10477	3424	91	\N
10478	3480	85	\N
10479	3513	85	\N
10480	3513	87	\N
10481	3513	89	\N
10482	3513	91	\N
10483	3513	92	\N
10484	3425	94	\N
10485	3425	95	\N
10486	3481	93	\N
10487	3481	95	\N
10488	3514	93	\N
10489	3514	95	\N
10490	3514	96	\N
10491	3481	97	219334
10492	3481	99	222155
10493	3426	100	\N
10494	3426	101	505090
10495	3426	102	838208
10496	3515	101	465528
10497	3427	103	\N
10498	3482	104	\N
10499	3482	105	\N
10500	3516	104	\N
10501	3516	106	\N
10502	3516	107	\N
10503	3482	108	549662
10504	3516	108	529396
10505	3483	109	\N
10506	3483	111	\N
10507	3483	113	\N
10508	3517	109	\N
10509	3428	114	296465
10510	3483	114	860384
10511	3429	115	\N
10512	3429	116	412234
10513	3429	117	595135
10514	3429	119	268103
10515	3429	120	570087
10516	3484	117	488953
10517	3484	118	138688
10518	3484	119	670737
10519	3484	121	339380
10520	3430	122	\N
10521	3430	123	\N
10522	3430	124	\N
10523	3430	125	\N
10524	3485	122	\N
10525	3485	124	\N
10526	3485	125	\N
10527	3485	126	\N
10528	3430	127	542275
10529	3485	127	919617
10530	3518	127	623624
10531	3431	129	\N
10532	3431	130	\N
10533	3486	128	\N
10534	3486	129	\N
10535	3519	128	\N
10536	3519	129	\N
10537	3431	131	527081
10538	3486	131	986587
10539	3486	132	398693
10540	3486	133	568593
10541	3432	134	\N
10542	3432	135	\N
10543	3487	134	\N
10544	3487	135	\N
10545	3520	134	\N
10546	3520	135	\N
10547	3520	136	\N
10548	3432	137	589995
10549	3432	138	226057
10550	3487	137	324141
10551	3487	138	404438
10552	3433	139	729291
10553	3521	140	\N
10554	3434	141	767126
10555	3434	142	522881
10556	3434	143	495804
10557	3435	144	\N
10558	3435	146	\N
10559	3522	145	\N
10560	3522	146	\N
10561	3435	148	650329
10562	3435	149	324555
10563	3435	151	411176
10564	3523	152	\N
10565	3436	153	984157
10566	3436	154	140003
10567	3523	153	393574
10568	3523	154	411965
10569	3523	156	159724
10570	3523	157	138458
10571	3437	158	\N
10572	3437	159	\N
10573	3437	160	\N
10574	3437	161	368114
10575	3524	161	707504
10576	3524	162	553953
10577	3525	163	\N
10578	3525	164	776240
10579	3525	165	641655
10580	3438	166	\N
10581	3438	167	\N
10582	3526	166	\N
10583	3526	169	910015
10584	3526	171	408017
10585	3526	173	676834
10586	3526	174	840346
10587	3439	175	\N
10588	3527	176	\N
10589	3439	177	907694
10590	3527	177	676344
10591	3440	179	\N
10592	3440	181	\N
10593	3440	182	\N
10594	3440	184	\N
10595	3528	178	\N
10596	3528	179	\N
10597	3528	180	\N
10598	3440	185	124135
10599	3528	185	626628
10600	3528	186	255801
10601	3441	187	\N
10602	3441	189	\N
10603	3529	187	\N
10604	3529	188	\N
10605	3441	191	434299
10606	3441	192	557084
10607	3530	193	\N
10608	3530	194	\N
10609	3530	196	285674
10610	3530	197	454027
10611	3442	199	\N
10612	3442	200	\N
10613	3442	201	672131
10614	3442	202	678698
10615	3443	203	\N
10616	3443	204	\N
10617	3531	203	\N
10618	3531	204	\N
10619	3531	205	\N
10620	3443	206	630516
10621	3443	207	812845
10622	3444	209	\N
10623	3444	210	\N
10624	3444	211	\N
10625	3444	212	586440
10626	3445	213	235305
10627	3532	213	592722
10628	3533	214	\N
10629	3533	216	\N
10630	3446	217	655467
10631	3446	218	641614
10632	3533	217	574931
10633	3533	219	567622
10634	3533	220	754607
10635	3447	222	\N
10636	3534	223	848433
10637	3534	224	536115
10638	3534	226	887032
10639	3534	228	301848
10640	3534	229	218961
10641	3448	231	\N
10642	3448	232	\N
10643	3448	234	\N
10644	3448	235	\N
10645	3535	236	792273
10646	3535	237	299938
10647	3535	238	555422
10648	3535	239	848297
10649	3535	240	300076
10650	3536	241	\N
10651	3449	243	487820
10652	3449	244	635833
10653	3449	245	253724
10654	3536	242	968205
10655	3536	243	486950
10656	3536	244	127812
10657	3450	246	\N
10658	3450	247	742635
10659	3537	247	866362
10660	3537	248	883399
10661	3538	250	449300
10662	3539	252	\N
10663	3539	253	\N
10664	3540	255	\N
10665	3540	257	\N
10666	3540	258	\N
10667	3540	259	550447
10668	3540	260	108094
10669	3541	261	273273
10670	3542	262	\N
10671	3542	263	\N
10672	3542	264	605529
10673	3542	265	883312
10674	3543	266	\N
10675	3543	267	\N
10676	3544	268	954557
10677	3544	269	336675
10678	3544	270	988558
10679	3544	271	868928
10680	3544	272	630184
10681	3545	273	\N
10682	3546	274	\N
10683	3546	275	\N
10684	3546	277	907352
10685	3547	278	775976
10686	3547	279	603972
10687	3547	281	360661
10688	3548	282	\N
10689	3548	284	\N
10690	3548	286	\N
10691	3548	288	818119
10692	3548	289	938527
10693	3549	290	\N
10694	3549	291	\N
10695	3550	292	\N
10696	3551	294	\N
10697	3551	295	\N
10698	3552	296	496892
10699	3553	298	\N
10700	3553	299	526134
10701	3554	300	\N
10702	3555	301	\N
10703	3555	302	570546
10704	3555	303	438869
10705	3555	304	260128
10706	3556	305	698397
10707	3556	307	997926
10708	3556	309	139236
10709	3557	310	\N
10710	3557	312	\N
10711	3557	313	\N
10712	3636	310	\N
10713	3636	311	\N
10714	3636	312	\N
10715	3636	313	\N
10716	3557	314	621280
10717	3637	315	343622
10718	3558	316	\N
10719	3558	317	\N
10720	3638	317	\N
10721	3558	318	952863
10722	3558	319	462187
10723	3638	318	307943
10724	3638	319	945545
10725	3638	321	432522
10726	3638	323	403880
10727	3639	324	487058
10728	3639	325	339385
10729	3639	326	940072
10730	3559	327	\N
10731	3640	327	\N
10732	3640	329	\N
10733	3640	330	\N
10734	3640	331	\N
10735	3640	332	\N
10736	3559	333	587086
10737	3559	334	491713
10738	3559	335	673427
10739	3559	336	999964
10740	3560	337	\N
10741	3641	337	\N
10742	3641	338	\N
10743	3641	340	\N
10744	3561	341	\N
10745	3561	343	\N
10746	3561	344	\N
10747	3561	346	\N
10748	3642	341	\N
10749	3642	342	\N
10750	3642	343	\N
10751	3562	347	\N
10752	3643	347	\N
10753	3643	349	\N
10754	3563	350	\N
10755	3563	352	\N
10756	3563	353	\N
10757	3563	354	\N
10758	3563	355	\N
10759	3644	350	\N
10760	3564	356	\N
10761	3564	357	763698
10762	3645	358	260030
10763	3645	359	563731
10764	3645	360	936193
10765	3565	361	\N
10766	3565	362	\N
10767	3565	363	\N
10768	3646	361	\N
10769	3646	362	\N
10770	3646	364	\N
10771	3646	365	302940
10772	3566	366	\N
10773	3566	367	545116
10774	3567	368	\N
10775	3647	368	\N
10776	3647	370	\N
10777	3567	371	329826
10778	3567	373	601226
10779	3567	374	202691
10780	3567	375	925541
10781	3568	377	\N
10782	3648	378	919830
10783	3648	380	589931
10784	3648	382	847733
10785	3569	383	\N
10786	3569	384	\N
10787	3569	385	\N
10788	3649	383	\N
10789	3649	384	\N
10790	3649	385	\N
10791	3649	386	\N
10792	3649	387	\N
10793	3569	388	574466
10794	3570	390	\N
10795	3650	390	\N
10796	3650	391	\N
10797	3570	393	968495
10798	3570	395	825068
10799	3570	397	449217
10800	3570	398	737958
10801	3650	392	811287
10802	3571	400	\N
10803	3651	399	\N
10804	3651	400	\N
10805	3651	401	\N
10806	3572	402	\N
10807	3572	403	\N
10808	3572	404	\N
10809	3572	405	\N
10810	3572	407	\N
10811	3652	402	\N
10812	3652	408	966580
10813	3652	409	134017
10814	3652	410	354474
10815	3573	411	\N
10816	3573	413	\N
10817	3573	414	\N
10818	3573	415	\N
10819	3573	417	\N
10820	3653	418	540602
10821	3653	419	125248
10822	3653	420	562902
10823	3653	421	604044
10824	3574	422	\N
10825	3574	423	\N
10826	3574	424	\N
10827	3574	425	546799
10828	3574	427	102791
10829	3654	429	\N
10830	3575	430	866012
10831	3575	431	745977
10832	3654	431	160398
10833	3654	432	640622
10834	3655	433	\N
10835	3576	434	\N
10836	3656	434	\N
10837	3656	435	\N
10838	3656	436	\N
10839	3656	437	440090
10840	3657	438	\N
10841	3657	439	\N
10842	3657	441	\N
10843	3657	442	\N
10844	3577	443	777923
10845	3577	444	723104
10846	3577	445	901691
10847	3578	447	\N
10848	3578	449	\N
10849	3578	450	\N
10850	3658	446	\N
10851	3658	447	\N
10852	3658	448	\N
10853	3658	449	\N
10854	3658	450	\N
10855	3579	451	\N
10856	3659	451	\N
10857	3579	452	477630
10858	3579	453	517718
10859	3579	454	220953
10860	3579	456	240717
10861	3659	452	313767
10862	3580	458	\N
10863	3660	459	917845
10864	3660	460	139091
10865	3581	461	\N
10866	3581	462	\N
10867	3581	463	\N
10868	3581	465	\N
10869	3661	467	753717
10870	3582	468	890442
10871	3582	469	132043
10872	3583	470	562864
10873	3662	471	417587
10874	3584	472	\N
10875	3663	472	\N
10876	3584	473	872610
10877	3585	475	440339
10878	3585	476	978896
10879	3585	477	855933
10880	3664	474	507129
10881	3664	475	552982
10882	3664	476	272697
10883	3664	478	207078
10884	3665	479	\N
10885	3586	481	452471
10886	3587	482	\N
10887	3587	483	610639
10888	3587	485	605959
10889	3587	487	628381
10890	3588	488	\N
10891	3588	490	\N
10892	3588	491	\N
10893	3666	489	\N
10894	3666	490	\N
10895	3588	493	166812
10896	3666	492	104273
10897	3589	494	\N
10898	3589	496	\N
10899	3589	497	\N
10900	3589	498	\N
10901	3667	499	364594
10902	3667	500	764409
10903	3667	502	909085
10904	3667	503	253653
10905	3590	504	\N
10906	3668	505	\N
10907	3590	507	943632
10908	3668	506	935608
10909	3668	507	986602
10910	3591	508	\N
10911	3591	509	\N
10912	3591	510	\N
10913	3591	511	\N
10914	3591	512	558465
10915	3592	513	\N
10916	3592	514	\N
10917	3592	516	\N
10918	3669	517	375686
10919	3670	518	844175
10920	3670	519	123522
10921	3670	521	225477
10922	3593	522	\N
10923	3593	523	\N
10924	3593	525	\N
10925	3671	522	\N
10926	3593	527	841826
10927	3593	528	199291
10928	3671	527	604759
10929	3671	529	213623
10930	3671	530	410003
10931	3672	531	829317
10932	3672	532	465039
10933	3672	533	930398
10934	3672	535	696041
10935	3672	536	781580
10936	3594	538	348132
10937	3594	539	736857
10938	3594	541	697035
10939	3594	542	925797
10940	3594	543	628048
10941	3673	545	663435
10942	3673	546	406036
10943	3673	547	457544
10944	3673	549	303542
10945	3595	550	\N
10946	3595	551	100484
10947	3595	552	746699
10948	3674	551	268380
10949	3596	553	\N
10950	3596	554	\N
10951	3596	556	338806
10952	3596	558	134020
10953	3596	559	902859
10954	3675	555	100053
10955	3675	557	916021
10956	3675	558	505361
10957	3675	559	785274
10958	3597	560	\N
10959	3676	560	\N
10960	3676	561	\N
10961	3676	562	\N
10962	3676	563	\N
10963	3597	564	635781
10964	3597	565	589805
10965	3597	566	897158
10966	3676	564	361647
10967	3598	567	\N
10968	3598	568	\N
10969	3598	569	\N
10970	3677	567	\N
10971	3677	568	\N
10972	3677	569	\N
10973	3598	570	561963
10974	3599	571	\N
10975	3599	572	490616
10976	3599	573	168184
10977	3600	575	\N
10978	3600	577	638890
10979	3600	579	331682
10980	3678	577	467702
10981	3601	580	868915
10982	3601	581	367642
10983	3601	582	260930
10984	3601	583	415086
10985	3601	585	482584
10986	3602	587	\N
10987	3602	588	\N
10988	3602	589	275303
10989	3602	590	115792
10990	3603	591	\N
10991	3603	593	\N
10992	3603	595	\N
10993	3679	591	\N
10994	3679	593	\N
10995	3679	594	\N
10996	3679	595	\N
10997	3603	597	239766
10998	3603	599	371456
10999	3679	596	725664
11000	3604	600	704702
11001	3680	600	337149
11002	3680	602	223993
11003	3681	603	\N
11004	3681	604	\N
11005	3605	605	315052
11006	3605	606	138816
11007	3605	607	276527
11008	3681	606	457755
11009	3606	608	\N
11010	3606	609	\N
11011	3682	610	\N
11012	3682	611	\N
11013	3682	612	135140
11014	3607	613	\N
11015	3608	614	\N
11016	3608	615	\N
11017	3683	614	\N
11018	3683	615	\N
11019	3608	616	522273
11020	3608	617	879656
11021	3683	616	118072
11022	3683	618	962318
11023	3684	619	\N
11024	3609	620	542457
11025	3609	621	533852
11026	3609	622	615265
11027	3684	621	166855
11028	3684	623	330640
11029	3684	624	497032
11030	3684	626	387785
11031	3610	627	\N
11032	3610	628	\N
11033	3610	629	\N
11034	3610	630	\N
11035	3611	632	\N
11036	3611	633	\N
11037	3611	634	\N
11038	3685	631	\N
11039	3611	636	365287
11040	3611	637	989766
11041	3685	635	604757
11042	3685	636	736759
11043	3685	637	340194
11044	3685	638	452865
11045	3612	639	924643
11046	3612	640	233766
11047	3613	641	\N
11048	3613	642	\N
11049	3613	643	\N
11050	3613	645	\N
11051	3613	647	\N
11052	3614	648	\N
11053	3614	649	\N
11054	3614	650	\N
11055	3686	648	\N
11056	3614	651	253317
11057	3615	653	293054
11058	3687	652	382283
11059	3616	654	\N
11060	3616	656	209878
11061	3616	657	914192
11062	3688	655	550204
11063	3617	658	\N
11064	3617	660	884448
11065	3618	661	501316
11066	3619	662	243475
11067	3620	664	173953
11068	3620	665	952334
11069	3620	666	298051
11070	3620	668	278927
11071	3621	670	\N
11072	3621	671	\N
11073	3621	672	189230
11074	3621	673	254658
11075	3622	674	295053
11076	3623	676	\N
11077	3623	677	\N
11078	3623	678	203935
11079	3624	679	\N
11080	3624	680	\N
11081	3624	681	\N
11082	3624	683	720204
11083	3624	684	577840
11084	3625	685	902158
11085	3626	687	\N
11086	3627	688	\N
11087	3627	689	\N
11088	3627	691	\N
11089	3627	692	\N
11090	3627	693	\N
11091	3628	694	\N
11092	3628	696	\N
11093	3628	697	337952
11094	3629	698	\N
11095	3629	699	199069
11096	3629	700	228496
11097	3630	701	\N
11098	3630	702	\N
11099	3630	703	\N
11100	3630	704	\N
11101	3631	705	\N
11102	3631	707	\N
11103	3631	708	\N
11104	3632	709	\N
11105	3632	711	\N
11106	3632	712	788486
11107	3632	714	707201
11108	3633	715	\N
11109	3633	716	\N
11110	3633	717	596117
11111	3633	718	310619
11112	3633	719	513362
11113	3634	720	535284
11114	3635	721	\N
11115	3635	722	\N
11116	3635	723	\N
11117	3635	724	\N
11118	3635	725	950836
11119	3764	727	\N
11120	3689	728	\N
11121	3689	730	\N
11122	3765	728	\N
11123	3841	728	\N
11124	3841	729	\N
11125	3690	732	\N
11126	3766	731	\N
11127	3766	732	\N
11128	3766	733	\N
11129	3690	734	290739
11130	3690	735	243159
11131	3690	737	345518
11132	3690	738	332925
11133	3842	734	662489
11134	3842	735	540689
11135	3691	740	\N
11136	3767	740	\N
11137	3767	741	\N
11138	3843	739	\N
11139	3843	740	\N
11140	3843	742	\N
11141	3767	744	377252
11142	3767	745	306498
11143	3767	746	162008
11144	3692	747	\N
11145	3768	747	\N
11146	3692	748	493040
11147	3844	748	846749
11148	3693	749	\N
11149	3769	750	\N
11150	3845	749	\N
11151	3693	751	349223
11152	3693	752	365467
11153	3845	752	624494
11154	3845	753	200349
11155	3845	754	840318
11156	3845	756	413531
11157	3770	757	\N
11158	3846	758	142096
11159	3694	759	\N
11160	3771	759	\N
11161	3771	760	\N
11162	3771	761	\N
11163	3847	759	\N
11164	3694	762	793086
11165	3771	762	158641
11166	3771	764	313695
11167	3847	763	743759
11168	3847	765	698681
11169	3848	766	\N
11170	3772	767	424379
11171	3772	768	718655
11172	3695	769	\N
11173	3695	770	\N
11174	3695	771	\N
11175	3695	772	\N
11176	3773	769	\N
11177	3773	770	\N
11178	3695	773	475267
11179	3773	773	761570
11180	3849	774	663218
11181	3849	776	147019
11182	3849	777	536462
11183	3849	779	474273
11184	3849	780	793515
11185	3696	781	\N
11186	3696	782	\N
11187	3774	781	\N
11188	3774	783	\N
11189	3850	781	\N
11190	3850	782	\N
11191	3850	783	\N
11192	3696	784	308739
11193	3774	784	422065
11194	3850	784	307234
11195	3850	785	136915
11196	3775	786	\N
11197	3851	786	\N
11198	3697	788	108316
11199	3697	790	457473
11200	3775	788	551940
11201	3775	789	483069
11202	3851	788	352796
11203	3852	792	\N
11204	3852	793	876905
11205	3852	794	351790
11206	3852	796	736980
11207	3776	797	\N
11208	3776	798	\N
11209	3776	799	\N
11210	3776	800	\N
11211	3776	801	\N
11212	3777	802	\N
11213	3853	802	\N
11214	3853	803	496393
11215	3778	804	\N
11216	3778	805	\N
11217	3778	806	\N
11218	3698	808	363888
11219	3698	809	243499
11220	3698	810	181533
11221	3698	811	616393
11222	3778	807	184092
11223	3854	807	177281
11224	3854	808	349148
11225	3854	810	297952
11226	3699	812	\N
11227	3699	813	\N
11228	3779	813	\N
11229	3779	814	\N
11230	3699	815	369366
11231	3699	817	440055
11232	3855	815	727670
11233	3855	817	500148
11234	3700	818	\N
11235	3700	819	\N
11236	3856	819	\N
11237	3700	820	430210
11238	3700	822	153298
11239	3780	820	805571
11240	3780	821	912214
11241	3780	823	462219
11242	3780	825	279632
11243	3780	827	449484
11244	3856	820	398801
11245	3856	821	491596
11246	3701	828	\N
11247	3701	829	\N
11248	3702	830	\N
11249	3702	831	\N
11250	3781	830	\N
11251	3781	832	\N
11252	3857	831	\N
11253	3702	834	233783
11254	3781	833	318174
11255	3857	833	247758
11256	3857	835	990284
11257	3857	836	398545
11258	3857	837	311133
11259	3782	838	\N
11260	3703	839	286527
11261	3703	840	456634
11262	3782	839	852911
11263	3782	841	620121
11264	3858	839	714429
11265	3704	842	\N
11266	3704	843	\N
11267	3704	845	\N
11268	3859	842	\N
11269	3859	847	550138
11270	3859	848	849463
11271	3705	849	724019
11272	3705	850	415786
11273	3705	852	557023
11274	3783	850	242507
11275	3783	851	837270
11276	3860	850	901103
11277	3861	853	208183
11278	3861	854	952320
11279	3861	855	701443
11280	3706	856	\N
11281	3706	857	\N
11282	3784	856	\N
11283	3784	857	\N
11284	3862	856	\N
11285	3862	857	\N
11286	3862	858	\N
11287	3862	860	150816
11288	3862	861	885233
11289	3707	862	\N
11290	3707	864	\N
11291	3863	862	\N
11292	3707	865	826724
11293	3785	865	219516
11294	3785	866	516364
11295	3863	865	793961
11296	3863	866	364624
11297	3864	868	\N
11298	3864	869	\N
11299	3786	870	472957
11300	3864	870	740453
11301	3864	871	677746
11302	3865	873	\N
11303	3708	874	208258
11304	3787	874	347737
11305	3865	874	798575
11306	3865	875	945845
11307	3865	876	486164
11308	3866	878	\N
11309	3866	879	\N
11310	3866	880	\N
11311	3866	881	\N
11312	3866	882	\N
11313	3709	883	391837
11314	3709	885	163302
11315	3788	883	266785
11316	3788	884	764035
11317	3788	885	307218
11318	3788	887	686141
11319	3710	888	\N
11320	3710	889	\N
11321	3789	888	\N
11322	3867	888	\N
11323	3790	890	\N
11324	3711	891	724413
11325	3711	892	780229
11326	3790	891	997443
11327	3790	892	533863
11328	3790	893	617657
11329	3712	894	\N
11330	3712	895	\N
11331	3712	896	\N
11332	3712	898	\N
11333	3791	894	\N
11334	3791	900	831930
11335	3713	901	\N
11336	3792	901	\N
11337	3792	902	\N
11338	3713	903	503600
11339	3792	904	721569
11340	3868	903	357391
11341	3868	904	845571
11342	3868	905	817437
11343	3868	906	598627
11344	3714	907	\N
11345	3714	908	\N
11346	3714	909	\N
11347	3793	908	\N
11348	3793	910	554327
11349	3793	911	401813
11350	3793	912	898312
11351	3793	913	646820
11352	3715	914	\N
11353	3715	915	\N
11354	3794	914	\N
11355	3794	915	\N
11356	3869	915	\N
11357	3715	916	324584
11358	3715	917	832586
11359	3794	916	477710
11360	3794	917	234137
11361	3794	918	660314
11362	3869	917	662189
11363	3716	919	\N
11364	3716	920	\N
11365	3716	921	\N
11366	3716	922	\N
11367	3716	923	\N
11368	3795	919	\N
11369	3795	921	\N
11370	3870	919	\N
11371	3870	921	\N
11372	3870	924	516476
11373	3717	925	\N
11374	3796	925	\N
11375	3717	926	717849
11376	3717	927	760010
11377	3717	928	974654
11378	3717	929	118088
11379	3796	926	601238
11380	3796	927	916941
11381	3796	929	555302
11382	3871	930	\N
11383	3871	932	360216
11384	3872	933	\N
11385	3872	935	\N
11386	3872	936	\N
11387	3872	937	\N
11388	3718	938	164694
11389	3718	940	415520
11390	3718	941	400339
11391	3718	942	491576
11392	3872	938	949662
11393	3873	943	\N
11394	3719	945	630878
11395	3873	944	656233
11396	3873	945	164686
11397	3873	946	316116
11398	3720	947	\N
11399	3874	947	\N
11400	3720	948	581849
11401	3797	949	883142
11402	3798	950	\N
11403	3875	951	177825
11404	3875	952	868671
11405	3875	953	395785
11406	3875	954	916278
11407	3721	955	\N
11408	3721	957	\N
11409	3721	958	\N
11410	3721	959	\N
11411	3799	956	\N
11412	3799	957	\N
11413	3876	955	\N
11414	3876	956	\N
11415	3876	958	\N
11416	3876	959	\N
11417	3876	960	\N
11418	3721	961	426977
11419	3722	962	\N
11420	3800	962	\N
11421	3877	963	\N
11422	3877	965	587902
11423	3723	966	\N
11424	3723	968	\N
11425	3723	969	\N
11426	3878	966	\N
11427	3878	967	\N
11428	3878	969	\N
11429	3723	971	283907
11430	3801	970	547800
11431	3878	971	780033
11432	3724	972	\N
11433	3724	974	\N
11434	3802	973	\N
11435	3802	974	\N
11436	3879	972	\N
11437	3879	973	\N
11438	3879	974	\N
11439	3724	975	646628
11440	3802	975	714039
11441	3725	976	\N
11442	3725	978	\N
11443	3725	980	\N
11444	3725	981	\N
11445	3803	977	\N
11446	3803	978	\N
11447	3803	980	\N
11448	3725	982	501829
11449	3803	982	993535
11450	3803	983	876809
11451	3880	982	918046
11452	3726	984	\N
11453	3726	985	925208
11454	3726	986	209313
11455	3726	987	896739
11456	3804	985	500843
11457	3804	986	888708
11458	3881	985	171778
11459	3881	986	448259
11460	3881	987	174541
11461	3881	988	578072
11462	3727	990	712955
11463	3727	991	662753
11464	3727	992	811129
11465	3727	993	787382
11466	3727	994	282604
11467	3805	995	\N
11468	3805	997	\N
11469	3805	998	970154
11470	3805	999	831077
11471	3806	1000	\N
11472	3806	1002	\N
11473	3806	1004	\N
11474	3806	1005	\N
11475	3806	1006	474484
11476	3728	1007	159173
11477	3728	1008	653293
11478	3728	1010	640150
11479	3807	1011	\N
11480	3729	1012	373881
11481	3729	1014	340902
11482	3729	1015	697641
11483	3729	1016	693568
11484	3807	1012	113123
11485	3807	1014	915012
11486	3807	1015	467996
11487	3882	1012	627931
11488	3730	1017	\N
11489	3730	1018	\N
11490	3730	1020	\N
11491	3730	1022	\N
11492	3808	1018	\N
11493	3808	1020	\N
11494	3808	1022	\N
11495	3730	1023	863735
11496	3731	1024	\N
11497	3809	1025	179231
11498	3809	1026	927653
11499	3809	1027	362149
11500	3809	1028	480163
11501	3732	1029	\N
11502	3732	1030	\N
11503	3732	1031	241248
11504	3732	1032	774913
11505	3810	1031	753207
11506	3810	1033	115685
11507	3733	1035	\N
11508	3811	1034	\N
11509	3811	1036	347999
11510	3811	1037	997742
11511	3811	1038	693961
11512	3734	1040	\N
11513	3734	1041	\N
11514	3812	1039	\N
11515	3734	1042	293262
11516	3735	1043	\N
11517	3735	1044	\N
11518	3735	1045	\N
11519	3735	1046	\N
11520	3813	1043	\N
11521	3813	1044	\N
11522	3813	1046	\N
11523	3813	1047	\N
11524	3736	1048	\N
11525	3736	1049	\N
11526	3736	1050	\N
11527	3814	1049	\N
11528	3815	1051	\N
11529	3815	1052	\N
11530	3815	1053	\N
11531	3815	1055	737358
11532	3815	1057	737996
11533	3737	1058	\N
11534	3737	1060	\N
11535	3816	1061	313733
11536	3738	1062	231762
11537	3738	1064	280194
11538	3738	1065	994313
11539	3739	1067	\N
11540	3817	1066	\N
11541	3817	1068	\N
11542	3739	1069	681367
11543	3817	1069	595252
11544	3817	1071	276391
11545	3817	1073	682761
11546	3818	1074	\N
11547	3818	1075	728976
11548	3818	1076	728282
11549	3740	1077	\N
11550	3740	1078	\N
11551	3740	1079	\N
11552	3819	1077	\N
11553	3819	1078	\N
11554	3819	1079	\N
11555	3819	1080	\N
11556	3819	1081	\N
11557	3740	1082	928131
11558	3740	1084	250207
11559	3741	1085	\N
11560	3741	1086	\N
11561	3741	1088	\N
11562	3741	1089	\N
11563	3741	1090	\N
11564	3820	1091	837128
11565	3742	1093	\N
11566	3821	1093	\N
11567	3821	1094	\N
11568	3742	1095	510712
11569	3743	1096	\N
11570	3743	1098	\N
11571	3743	1099	\N
11572	3744	1101	\N
11573	3744	1102	\N
11574	3822	1100	\N
11575	3744	1103	354411
11576	3744	1104	628385
11577	3744	1105	542449
11578	3745	1107	\N
11579	3745	1108	\N
11580	3745	1110	\N
11581	3745	1112	\N
11582	3746	1113	\N
11583	3823	1114	\N
11584	3747	1115	\N
11585	3824	1115	\N
11586	3824	1116	\N
11587	3824	1117	\N
11588	3824	1118	\N
11589	3748	1120	\N
11590	3748	1121	\N
11591	3748	1123	\N
11592	3825	1119	\N
11593	3825	1120	\N
11594	3825	1121	\N
11595	3749	1124	\N
11596	3826	1125	\N
11597	3826	1126	\N
11598	3826	1127	324045
11599	3826	1128	790115
11600	3826	1130	458794
11601	3827	1131	\N
11602	3827	1132	\N
11603	3750	1134	908962
11604	3750	1135	896683
11605	3750	1136	360481
11606	3750	1137	504286
11607	3827	1133	696691
11608	3751	1138	\N
11609	3828	1139	242493
11610	3752	1141	\N
11611	3829	1143	\N
11612	3829	1144	\N
11613	3753	1145	\N
11614	3830	1146	\N
11615	3753	1148	133723
11616	3754	1149	\N
11617	3754	1150	\N
11618	3754	1151	\N
11619	3754	1152	\N
11620	3831	1149	\N
11621	3754	1154	438222
11622	3755	1156	754446
11623	3755	1157	310118
11624	3755	1158	535112
11625	3832	1156	551939
11626	3832	1157	614629
11627	3832	1158	940401
11628	3756	1159	\N
11629	3756	1160	452168
11630	3756	1162	450261
11631	3833	1160	365160
11632	3833	1161	493157
11633	3833	1162	428355
11634	3757	1163	\N
11635	3834	1163	\N
11636	3834	1165	596233
11637	3834	1167	240974
11638	3834	1169	826376
11639	3834	1170	949425
11640	3835	1171	\N
11641	3758	1173	244772
11642	3758	1175	520413
11643	3758	1176	636537
11644	3835	1172	610529
11645	3836	1177	\N
11646	3836	1178	\N
11647	3836	1179	\N
11648	3836	1181	\N
11649	3759	1182	521489
11650	3760	1183	182028
11651	3760	1184	696137
11652	3761	1186	\N
11653	3837	1185	\N
11654	3837	1186	\N
11655	3837	1187	\N
11656	3761	1189	421616
11657	3761	1191	386186
11658	3761	1192	414241
11659	3837	1188	435545
11660	3837	1189	320826
11661	3762	1193	\N
11662	3838	1194	\N
11663	3838	1195	\N
11664	3838	1196	\N
11665	3839	1197	\N
11666	3839	1199	\N
11667	3763	1200	518316
11668	3839	1200	724720
11669	3839	1202	959825
11670	3839	1203	298660
11671	3840	1205	\N
11672	3840	1207	\N
11673	3949	1209	\N
11674	3883	1210	670863
11675	3950	1210	906520
11676	3950	1212	157679
11677	3950	1213	532740
11678	3950	1215	847030
11679	3950	1217	789416
11680	3951	1218	\N
11681	3951	1219	128708
11682	3951	1221	938004
11683	3951	1222	208895
11684	3951	1223	919113
11685	3952	1224	176533
11686	3884	1226	\N
11687	3884	1228	\N
11688	3953	1226	\N
11689	3953	1229	570773
11690	3953	1230	197798
11691	3885	1231	\N
11692	3885	1232	\N
11693	3885	1233	\N
11694	3954	1234	443310
11695	3886	1235	\N
11696	3886	1236	\N
11697	3955	1235	\N
11698	3886	1237	948460
11699	3886	1238	717789
11700	3955	1238	497875
11701	3955	1239	336519
11702	3955	1240	878353
11703	3955	1242	725174
11704	3956	1243	\N
11705	3956	1245	\N
11706	3956	1246	\N
11707	3887	1247	225199
11708	3957	1248	\N
11709	3957	1249	\N
11710	3957	1251	\N
11711	3888	1253	\N
11712	3889	1255	\N
11713	3889	1256	\N
11714	3889	1257	\N
11715	3889	1259	\N
11716	3958	1260	961933
11717	3958	1261	580569
11718	3959	1262	\N
11719	3959	1263	\N
11720	3959	1264	\N
11721	3890	1266	270576
11722	3890	1267	987975
11723	3890	1269	377733
11724	3890	1270	457951
11725	3959	1266	865647
11726	3959	1267	505057
11727	3891	1272	\N
11728	3960	1271	\N
11729	3960	1272	\N
11730	3960	1273	\N
11731	3891	1274	256502
11732	3960	1275	685905
11733	3892	1276	\N
11734	3892	1278	541806
11735	3961	1277	587823
11736	3961	1278	155867
11737	3962	1280	\N
11738	3962	1281	\N
11739	3962	1282	139612
11740	3893	1284	\N
11741	3893	1285	\N
11742	3893	1286	\N
11743	3893	1287	\N
11744	3963	1284	\N
11745	3963	1285	\N
11746	3963	1288	272489
11747	3963	1289	474494
11748	3963	1290	105662
11749	3964	1292	\N
11750	3964	1294	\N
11751	3894	1295	777249
11752	3964	1295	118418
11753	3895	1297	\N
11754	3965	1296	\N
11755	3896	1298	\N
11756	3896	1299	643335
11757	3966	1299	733957
11758	3966	1300	176348
11759	3897	1302	802877
11760	3898	1304	\N
11761	3898	1305	\N
11762	3967	1304	\N
11763	3967	1305	\N
11764	3967	1306	\N
11765	3967	1307	\N
11766	3899	1308	\N
11767	3899	1309	\N
11768	3899	1310	\N
11769	3968	1308	\N
11770	3968	1310	\N
11771	3899	1311	806374
11772	3899	1312	512711
11773	3968	1312	324723
11774	3900	1314	\N
11775	3900	1316	\N
11776	3900	1318	725856
11777	3969	1318	505777
11778	3969	1319	597271
11779	3969	1321	735090
11780	3901	1323	\N
11781	3901	1324	\N
11782	3901	1325	\N
11783	3970	1322	\N
11784	3901	1326	680458
11785	3901	1327	794802
11786	3970	1327	870060
11787	3970	1329	189239
11788	3971	1331	\N
11789	3902	1332	732612
11790	3902	1334	655679
11791	3902	1335	949013
11792	3902	1337	509214
11793	3971	1333	131340
11794	3903	1339	\N
11795	3903	1341	\N
11796	3903	1342	\N
11797	3972	1338	\N
11798	3972	1339	\N
11799	3972	1340	\N
11800	3904	1343	338676
11801	3973	1344	523048
11802	3973	1345	523144
11803	3973	1347	639626
11804	3973	1348	583382
11805	3973	1350	549585
11806	3974	1352	\N
11807	3974	1353	\N
11808	3974	1354	\N
11809	3974	1355	240381
11810	3974	1356	379088
11811	3905	1357	\N
11812	3905	1359	\N
11813	3905	1361	\N
11814	3905	1362	366306
11815	3905	1363	999107
11816	3906	1364	151916
11817	3907	1366	\N
11818	3907	1367	\N
11819	3907	1369	\N
11820	3907	1370	\N
11821	3975	1365	\N
11822	3975	1372	863298
11823	3976	1374	\N
11824	3976	1375	884289
11825	3976	1376	152279
11826	3976	1378	742422
11827	3908	1379	695432
11828	3908	1380	215132
11829	3977	1379	988853
11830	3977	1380	767936
11831	3977	1381	816075
11832	3909	1383	\N
11833	3978	1382	\N
11834	3978	1384	\N
11835	3978	1385	\N
11836	3910	1386	\N
11837	3910	1387	\N
11838	3979	1386	\N
11839	3979	1387	\N
11840	3910	1388	806893
11841	3910	1390	441265
11842	3980	1392	\N
11843	3980	1393	\N
11844	3980	1394	451783
11845	3980	1395	726312
11846	3980	1396	645259
11847	3911	1397	\N
11848	3911	1398	\N
11849	3911	1399	\N
11850	3911	1401	\N
11851	3981	1397	\N
11852	3981	1399	\N
11853	3911	1402	587065
11854	3982	1404	\N
11855	3982	1405	\N
11856	3912	1406	\N
11857	3912	1407	698679
11858	3912	1408	874441
11859	3912	1409	722131
11860	3983	1407	194200
11861	3983	1408	848421
11862	3983	1409	154873
11863	3983	1410	796662
11864	3983	1411	642003
11865	3984	1412	\N
11866	3984	1413	\N
11867	3984	1414	\N
11868	3984	1415	\N
11869	3913	1416	632890
11870	3985	1417	183369
11871	3986	1418	\N
11872	3986	1420	\N
11873	3986	1421	\N
11874	3986	1422	761895
11875	3914	1423	863690
11876	3914	1425	862640
11877	3987	1427	338014
11878	3987	1428	485461
11879	3988	1429	\N
11880	3988	1430	123411
11881	3988	1431	640597
11882	3988	1432	776581
11883	3915	1433	\N
11884	3989	1433	\N
11885	3989	1435	\N
11886	3989	1436	\N
11887	3989	1437	\N
11888	3989	1438	\N
11889	3915	1439	431915
11890	3915	1441	285961
11891	3915	1442	995696
11892	3915	1443	908333
11893	3990	1444	293076
11894	3990	1445	410641
11895	3990	1446	289361
11896	3990	1447	789301
11897	3990	1448	218764
11898	3916	1449	\N
11899	3916	1450	\N
11900	3991	1451	743853
11901	3991	1452	829505
11902	3992	1453	\N
11903	3992	1454	\N
11904	3992	1455	\N
11905	3917	1456	\N
11906	3993	1457	\N
11907	3917	1459	356412
11908	3993	1459	443180
11909	3993	1460	282409
11910	3993	1461	872512
11911	3993	1463	760776
11912	3918	1465	195253
11913	3918	1466	596873
11914	3918	1467	334527
11915	3918	1468	593549
11916	3918	1469	939747
11917	3994	1465	829738
11918	3919	1470	\N
11919	3920	1472	270269
11920	3995	1472	637749
11921	3996	1474	\N
11922	3996	1475	667548
11923	3996	1477	497271
11924	3996	1478	457869
11925	3921	1479	\N
11926	3921	1481	\N
11927	3997	1479	\N
11928	3997	1480	\N
11929	3997	1481	\N
11930	3921	1483	864376
11931	3921	1485	676128
11932	3921	1487	875069
11933	3997	1482	917072
11934	3997	1483	165666
11935	3922	1488	\N
11936	3922	1489	\N
11937	3922	1490	\N
11938	3922	1491	\N
11939	3922	1492	\N
11940	3998	1493	224909
11941	3998	1494	586347
11942	3923	1496	\N
11943	3923	1497	\N
11944	3924	1498	\N
11945	3999	1499	\N
11946	3999	1501	\N
11947	3999	1502	\N
11948	3924	1504	993158
11949	3924	1505	242740
11950	3924	1506	553137
11951	3924	1508	289639
11952	3925	1509	\N
11953	3925	1510	269314
11954	3926	1511	254656
11955	3927	1512	\N
11956	4000	1513	677775
11957	4001	1514	\N
11958	4001	1515	\N
11959	3928	1517	737765
11960	3928	1518	414484
11961	3928	1519	838749
11962	3928	1520	197214
11963	4001	1516	919222
11964	4001	1518	117367
11965	3929	1521	\N
11966	3929	1522	\N
11967	3929	1523	\N
11968	3929	1524	\N
11969	4002	1521	\N
11970	3930	1525	\N
11971	4003	1525	\N
11972	4003	1527	\N
11973	4003	1529	\N
11974	3930	1530	366175
11975	3931	1531	\N
11976	3931	1532	\N
11977	3931	1533	\N
11978	3931	1535	\N
11979	4004	1536	319034
11980	4004	1537	784291
11981	4004	1538	280568
11982	4004	1539	417210
11983	4004	1540	816545
11984	3932	1541	\N
11985	3932	1542	\N
11986	3932	1543	\N
11987	4005	1541	\N
11988	4005	1542	\N
11989	4005	1543	\N
11990	4005	1544	\N
11991	3932	1545	560291
11992	3932	1547	894274
11993	3933	1548	\N
11994	3933	1550	370326
11995	4006	1550	717167
11996	4006	1551	171662
11997	4006	1552	486856
11998	4006	1553	812258
11999	3934	1554	\N
12000	3934	1555	\N
12001	3934	1556	\N
12002	4007	1554	\N
12003	3934	1557	225300
12004	4007	1557	535061
12005	4008	1558	\N
12006	4008	1559	\N
12007	3935	1560	720593
12008	3935	1561	786382
12009	3935	1563	151005
12010	3935	1564	182669
12011	3935	1566	469048
12012	4008	1560	740901
12013	4009	1567	\N
12014	4009	1568	\N
12015	4009	1570	\N
12016	4009	1571	\N
12017	4009	1572	\N
12018	3936	1573	\N
12019	4010	1573	\N
12020	4010	1574	\N
12021	4010	1575	\N
12022	4010	1577	\N
12023	3936	1579	849506
12024	4010	1578	928179
12025	3937	1581	\N
12026	3937	1582	178868
12027	3938	1583	\N
12028	3938	1584	\N
12029	4011	1584	\N
12030	4011	1586	\N
12031	4011	1587	\N
12032	3938	1588	420576
12033	3938	1589	103373
12034	4011	1588	884079
12035	4012	1590	\N
12036	4012	1591	\N
12037	4012	1592	\N
12038	4012	1593	754428
12039	4012	1594	890132
12040	3939	1595	737718
12041	3939	1597	737174
12042	3939	1599	542292
12043	3939	1600	331359
12044	4013	1596	678498
12045	3940	1601	\N
12046	3940	1602	164079
12047	4014	1602	364672
12048	3941	1603	\N
12049	3941	1604	\N
12050	3941	1605	\N
12051	3941	1606	\N
12052	3941	1607	\N
12053	4015	1604	\N
12054	4015	1605	\N
12055	4016	1608	\N
12056	3942	1610	700046
12057	3942	1611	505963
12058	3942	1612	603037
12059	3942	1613	165408
12060	3943	1614	\N
12061	3943	1615	\N
12062	3943	1616	\N
12063	3943	1618	839739
12064	4017	1619	\N
12065	3944	1620	\N
12066	3944	1622	\N
12067	3944	1623	761718
12068	3944	1624	620299
12069	3945	1625	\N
12070	3945	1626	\N
12071	3946	1627	\N
12072	3946	1628	530110
12073	3946	1629	866109
12074	3946	1630	950347
12075	3946	1632	779176
12076	3947	1633	809827
12077	3947	1635	993966
12078	3948	1637	\N
12079	3948	1639	\N
12080	3948	1640	\N
12081	4018	1641	\N
12082	4018	1642	620087
12083	4018	1643	445678
12084	4018	1644	457550
12085	4019	1645	\N
12086	4019	1646	\N
12087	4019	1648	\N
12088	4019	1649	\N
12089	4019	1650	\N
12090	4099	1645	\N
12091	4099	1646	\N
12092	4099	1647	\N
12093	4099	1648	\N
12094	4099	1650	\N
12095	4165	1645	\N
12096	4165	1647	\N
12097	4165	1649	\N
12098	4020	1651	\N
12099	4166	1651	\N
12100	4100	1652	557044
12101	4100	1653	108058
12102	4100	1654	909383
12103	4021	1656	416922
12104	4101	1655	788258
12105	4101	1656	291016
12106	4167	1656	589350
12107	4022	1658	\N
12108	4022	1659	\N
12109	4102	1657	\N
12110	4102	1658	\N
12111	4168	1657	\N
12112	4168	1658	\N
12113	4168	1659	\N
12114	4022	1660	394754
12115	4102	1660	616456
12116	4168	1660	646996
12117	4168	1661	605262
12118	4103	1662	\N
12119	4169	1663	\N
12120	4169	1664	818139
12121	4169	1666	862129
12122	4023	1667	\N
12123	4104	1667	\N
12124	4104	1669	\N
12125	4104	1670	337236
12126	4104	1671	978391
12127	4170	1671	291536
12128	4170	1672	989655
12129	4170	1674	809013
12130	4105	1676	\N
12131	4105	1677	\N
12132	4105	1678	\N
12133	4024	1679	485363
12134	4024	1680	506674
12135	4024	1681	582590
12136	4024	1683	582891
12137	4024	1684	565886
12138	4105	1679	481650
12139	4025	1686	\N
12140	4025	1687	699756
12141	4106	1687	684564
12142	4106	1688	264108
12143	4106	1689	821264
12144	4106	1690	576683
12145	4171	1687	879310
12146	4171	1688	358284
12147	4026	1691	\N
12148	4026	1692	\N
12149	4172	1691	\N
12150	4026	1693	382872
12151	4107	1693	982991
12152	4172	1693	536170
12153	4172	1695	385535
12154	4027	1696	\N
12155	4027	1698	\N
12156	4027	1700	\N
12157	4027	1701	781110
12158	4108	1701	717841
12159	4108	1703	882070
12160	4108	1704	810846
12161	4173	1701	571823
12162	4173	1702	554631
12163	4173	1703	162735
12164	4173	1705	384382
12165	4028	1706	\N
12166	4028	1707	\N
12167	4028	1708	\N
12168	4028	1710	\N
12169	4028	1711	\N
12170	4109	1706	\N
12171	4174	1706	\N
12172	4174	1707	\N
12173	4174	1708	\N
12174	4174	1709	\N
12175	4109	1712	444528
12176	4109	1713	687463
12177	4109	1715	106134
12178	4110	1716	\N
12179	4110	1717	\N
12180	4110	1718	\N
12181	4110	1719	\N
12182	4175	1716	\N
12183	4110	1720	993396
12184	4175	1720	463784
12185	4175	1722	801689
12186	4029	1723	\N
12187	4029	1724	\N
12188	4029	1725	\N
12189	4029	1726	\N
12190	4111	1724	\N
12191	4176	1723	\N
12192	4111	1727	764832
12193	4111	1728	649521
12194	4111	1729	841639
12195	4111	1731	478558
12196	4030	1732	\N
12197	4177	1732	\N
12198	4177	1733	\N
12199	4177	1734	\N
12200	4030	1735	382803
12201	4112	1736	924465
12202	4112	1738	393737
12203	4112	1739	988507
12204	4177	1735	705734
12205	4031	1740	\N
12206	4113	1741	340174
12207	4113	1742	452718
12208	4032	1743	\N
12209	4114	1743	\N
12210	4114	1744	\N
12211	4114	1746	318040
12212	4114	1747	612586
12213	4178	1746	748316
12214	4178	1747	414304
12215	4178	1749	265303
12216	4178	1750	767517
12217	4033	1751	\N
12218	4033	1753	\N
12219	4033	1754	\N
12220	4033	1756	\N
12221	4033	1757	\N
12222	4115	1751	\N
12223	4115	1752	\N
12224	4179	1758	877602
12225	4179	1760	845073
12226	4179	1761	565473
12227	4179	1762	628651
12228	4116	1763	\N
12229	4180	1763	\N
12230	4180	1764	\N
12231	4116	1765	779228
12232	4116	1766	267235
12233	4180	1765	183517
12234	4034	1767	\N
12235	4034	1768	\N
12236	4117	1768	\N
12237	4117	1769	\N
12238	4181	1767	\N
12239	4181	1768	\N
12240	4181	1769	\N
12241	4181	1770	\N
12242	4117	1771	921558
12243	4117	1772	623525
12244	4181	1771	327819
12245	4118	1774	\N
12246	4182	1773	\N
12247	4182	1774	\N
12248	4182	1775	\N
12249	4118	1777	544811
12250	4118	1778	252563
12251	4182	1776	222685
12252	4182	1777	585792
12253	4183	1780	\N
12254	4035	1782	510956
12255	4035	1783	725254
12256	4119	1784	\N
12257	4119	1786	\N
12258	4119	1788	\N
12259	4184	1784	\N
12260	4184	1785	\N
12261	4036	1789	635611
12262	4119	1789	439076
12263	4184	1789	552439
12264	4184	1790	129886
12265	4037	1791	\N
12266	4037	1792	\N
12267	4037	1793	\N
12268	4120	1791	\N
12269	4185	1791	\N
12270	4185	1792	\N
12271	4037	1794	264011
12272	4185	1794	777515
12273	4185	1796	360394
12274	4186	1798	\N
12275	4121	1799	750332
12276	4121	1800	929783
12277	4121	1801	279995
12278	4121	1802	243010
12279	4121	1803	230906
12280	4186	1799	525594
12281	4186	1800	899940
12282	4186	1801	885819
12283	4038	1804	\N
12284	4122	1804	\N
12285	4122	1806	\N
12286	4039	1807	\N
12287	4187	1807	\N
12288	4039	1808	924636
12289	4040	1809	\N
12290	4040	1811	\N
12291	4040	1813	\N
12292	4123	1810	\N
12293	4123	1811	\N
12294	4123	1813	\N
12295	4188	1814	689508
12296	4188	1815	876995
12297	4124	1816	\N
12298	4124	1817	\N
12299	4124	1818	\N
12300	4124	1820	\N
12301	4189	1816	\N
12302	4189	1817	\N
12303	4189	1819	\N
12304	4041	1821	672884
12305	4041	1822	654203
12306	4124	1821	505063
12307	4042	1823	\N
12308	4125	1823	\N
12309	4125	1825	\N
12310	4125	1826	\N
12311	4190	1823	\N
12312	4190	1824	\N
12313	4190	1826	\N
12314	4190	1827	\N
12315	4190	1829	\N
12316	4042	1830	673236
12317	4042	1831	835784
12318	4042	1832	245586
12319	4125	1830	666298
12320	4125	1832	646149
12321	4043	1834	\N
12322	4043	1835	\N
12323	4126	1833	\N
12324	4043	1836	141006
12325	4044	1837	\N
12326	4044	1839	\N
12327	4191	1837	\N
12328	4191	1838	\N
12329	4127	1840	935468
12330	4127	1841	802993
12331	4127	1842	248924
12332	4045	1843	\N
12333	4045	1844	117972
12334	4045	1846	971536
12335	4045	1848	537610
12336	4192	1844	932944
12337	4192	1845	682645
12338	4192	1846	148087
12339	4128	1849	435970
12340	4193	1849	959819
12341	4193	1850	992411
12342	4193	1851	176272
12343	4193	1852	992337
12344	4129	1854	\N
12345	4129	1855	\N
12346	4129	1856	\N
12347	4194	1857	611236
12348	4194	1858	770244
12349	4046	1859	\N
12350	4046	1861	813812
12351	4046	1862	775895
12352	4195	1860	113738
12353	4195	1861	370379
12354	4195	1863	277303
12355	4195	1864	942366
12356	4195	1865	797726
12357	4047	1866	\N
12358	4130	1867	\N
12359	4130	1868	\N
12360	4130	1869	\N
12361	4196	1866	\N
12362	4130	1870	136530
12363	4130	1871	616021
12364	4196	1871	554889
12365	4196	1872	844913
12366	4048	1873	\N
12367	4197	1874	\N
12368	4197	1876	\N
12369	4197	1877	\N
12370	4048	1878	337329
12371	4131	1878	323858
12372	4197	1878	296826
12373	4197	1879	780947
12374	4049	1880	450868
12375	4049	1881	640708
12376	4132	1880	568865
12377	4132	1881	180174
12378	4132	1882	282114
12379	4133	1884	\N
12380	4198	1885	477650
12381	4198	1886	700789
12382	4198	1888	220162
12383	4134	1889	\N
12384	4134	1891	\N
12385	4050	1892	881830
12386	4050	1893	629922
12387	4050	1894	420539
12388	4050	1895	421766
12389	4050	1896	472346
12390	4134	1892	724752
12391	4134	1893	573137
12392	4134	1894	601999
12393	4199	1892	311512
12394	4199	1893	211633
12395	4135	1897	\N
12396	4051	1898	461030
12397	4135	1898	506011
12398	4135	1899	772024
12399	4200	1899	402203
12400	4200	1900	349135
12401	4200	1901	684997
12402	4200	1902	901930
12403	4200	1904	629464
12404	4052	1905	\N
12405	4052	1906	\N
12406	4201	1905	\N
12407	4052	1908	470750
12408	4136	1907	168476
12409	4053	1909	\N
12410	4053	1910	\N
12411	4053	1911	\N
12412	4053	1912	\N
12413	4137	1909	\N
12414	4202	1909	\N
12415	4202	1910	\N
12416	4202	1912	\N
12417	4053	1913	583887
12418	4137	1913	332995
12419	4137	1914	480025
12420	4202	1913	453463
12421	4202	1914	999833
12422	4054	1915	\N
12423	4138	1915	\N
12424	4138	1917	\N
12425	4203	1915	\N
12426	4203	1916	\N
12427	4054	1918	241804
12428	4138	1918	258629
12429	4138	1919	907170
12430	4138	1921	582914
12431	4055	1922	\N
12432	4055	1923	721174
12433	4055	1925	659106
12434	4139	1923	296744
12435	4056	1927	\N
12436	4056	1928	\N
12437	4056	1929	\N
12438	4056	1931	\N
12439	4140	1927	\N
12440	4140	1928	\N
12441	4204	1926	\N
12442	4204	1927	\N
12443	4204	1928	\N
12444	4204	1932	317465
12445	4057	1933	\N
12446	4057	1935	\N
12447	4141	1933	\N
12448	4057	1936	848307
12449	4057	1938	908655
12450	4141	1936	585995
12451	4141	1938	268364
12452	4058	1939	\N
12453	4058	1940	\N
12454	4205	1939	\N
12455	4205	1940	\N
12456	4205	1941	\N
12457	4205	1942	\N
12458	4058	1943	497941
12459	4058	1944	311253
12460	4205	1944	521070
12461	4059	1946	\N
12462	4059	1947	571201
12463	4059	1949	259815
12464	4206	1947	881207
12465	4206	1948	127705
12466	4060	1950	\N
12467	4060	1952	\N
12468	4207	1950	\N
12469	4060	1953	855031
12470	4142	1953	715063
12471	4142	1954	575284
12472	4143	1955	\N
12473	4208	1956	\N
12474	4208	1957	\N
12475	4208	1958	\N
12476	4208	1960	\N
12477	4061	1961	509054
12478	4061	1963	378940
12479	4143	1962	223814
12480	4143	1963	152645
12481	4143	1964	892033
12482	4143	1966	453337
12483	4062	1967	\N
12484	4144	1967	\N
12485	4144	1968	481041
12486	4144	1969	814023
12487	4144	1970	756721
12488	4063	1971	\N
12489	4063	1972	\N
12490	4063	1973	\N
12491	4063	1974	\N
12492	4063	1975	\N
12493	4209	1971	\N
12494	4145	1976	101894
12495	4145	1978	103285
12496	4145	1979	734746
12497	4209	1976	983290
12498	4146	1981	\N
12499	4210	1980	\N
12500	4146	1982	825798
12501	4210	1982	996495
12502	4210	1984	461372
12503	4210	1985	236552
12504	4064	1986	\N
12505	4064	1987	\N
12506	4064	1988	\N
12507	4064	1989	\N
12508	4064	1991	\N
12509	4147	1986	\N
12510	4147	1988	\N
12511	4147	1989	\N
12512	4147	1990	\N
12513	4065	1992	\N
12514	4148	1992	\N
12515	4148	1993	\N
12516	4148	1994	\N
12517	4148	1995	425911
12518	4211	1995	993902
12519	4211	1996	333600
12520	4211	1997	206066
12521	4066	1998	\N
12522	4149	1998	\N
12523	4149	0	\N
12524	4149	1	\N
12525	4212	1999	\N
12526	4212	0	\N
12527	4066	3	715559
12528	4066	4	593304
12529	4066	5	367995
12530	4149	2	383934
12531	4212	3	735224
12532	4212	4	696420
12533	4212	5	728280
12534	4067	6	\N
12535	4213	7	\N
12536	4067	8	702739
12537	4213	8	468449
12538	4213	10	360695
12539	4150	11	\N
12540	4150	12	\N
12541	4214	11	\N
12542	4150	13	177036
12543	4151	14	\N
12544	4151	15	\N
12545	4215	14	\N
12546	4215	16	\N
12547	4215	17	\N
12548	4215	19	\N
12549	4151	20	592414
12550	4151	22	814470
12551	4068	24	\N
12552	4068	26	\N
12553	4068	27	\N
12554	4216	24	\N
12555	4216	25	\N
12556	4216	26	\N
12557	4216	27	\N
12558	4068	28	243501
12559	4152	29	\N
12560	4152	31	\N
12561	4152	32	890801
12562	4217	33	167027
12563	4069	35	989666
12564	4153	34	297297
12565	4218	34	735273
12566	4218	36	625894
12567	4070	37	\N
12568	4070	38	\N
12569	4154	38	\N
12570	4219	38	\N
12571	4219	39	\N
12572	4070	40	589413
12573	4070	41	559473
12574	4070	42	783146
12575	4154	40	865809
12576	4154	41	952405
12577	4154	43	543091
12578	4219	40	931015
12579	4071	44	\N
12580	4071	45	\N
12581	4220	46	780100
12582	4072	47	\N
12583	4155	47	\N
12584	4155	49	\N
12585	4072	50	886269
12586	4155	51	687951
12587	4221	50	929147
12588	4221	51	970014
12589	4221	52	498520
12590	4073	54	\N
12591	4156	53	\N
12592	4222	53	\N
12593	4222	54	\N
12594	4073	55	644150
12595	4156	56	587954
12596	4156	57	576112
12597	4157	58	\N
12598	4157	60	\N
12599	4157	61	\N
12600	4157	62	\N
12601	4074	63	298561
12602	4074	64	208570
12603	4074	65	408443
12604	4074	66	591738
12605	4223	64	217258
12606	4223	65	115534
12607	4223	67	148452
12608	4223	68	175414
12609	4158	69	\N
12610	4224	69	\N
12611	4224	70	\N
12612	4075	71	804229
12613	4075	72	298370
12614	4075	73	415496
12615	4075	74	801032
12616	4224	72	236489
12617	4224	73	144773
12618	4159	75	\N
12619	4225	75	\N
12620	4076	76	259137
12621	4076	78	955365
12622	4076	79	519764
12623	4076	81	640959
12624	4159	76	174998
12625	4225	76	525442
12626	4225	77	459289
12627	4225	79	835302
12628	4160	82	\N
12629	4160	84	\N
12630	4160	86	\N
12631	4226	83	\N
12632	4226	84	\N
12633	4160	87	205253
12634	4160	88	948025
12635	4226	87	716096
12636	4226	88	103679
12637	4161	90	\N
12638	4227	89	\N
12639	4227	91	\N
12640	4227	92	\N
12641	4227	93	\N
12642	4077	94	237366
12643	4078	95	\N
12644	4078	96	\N
12645	4078	97	\N
12646	4078	99	819535
12647	4228	98	111937
12648	4228	99	635971
12649	4228	101	263231
12650	4079	102	\N
12651	4079	103	\N
12652	4162	102	\N
12653	4079	104	689880
12654	4162	104	143639
12655	4162	105	363936
12656	4162	107	190394
12657	4080	108	\N
12658	4080	109	\N
12659	4163	111	742088
12660	4163	112	806542
12661	4229	111	608615
12662	4229	112	855521
12663	4230	113	\N
12664	4081	115	940202
12665	4081	116	713543
12666	4081	118	544718
12667	4230	114	553214
12668	4082	119	\N
12669	4082	120	\N
12670	4082	121	\N
12671	4231	119	\N
12672	4231	120	\N
12673	4231	121	\N
12674	4082	122	665865
12675	4083	123	\N
12676	4232	124	\N
12677	4232	125	\N
12678	4232	126	273338
12679	4232	127	285954
12680	4232	128	555380
12681	4084	129	\N
12682	4233	129	\N
12683	4233	130	228497
12684	4233	132	309221
12685	4233	133	895723
12686	4085	134	\N
12687	4085	135	\N
12688	4085	137	\N
12689	4164	134	\N
12690	4234	138	\N
12691	4234	139	262083
12692	4086	141	\N
12693	4086	143	\N
12694	4086	144	\N
12695	4235	145	715342
12696	4235	146	780585
12697	4235	147	919358
12698	4087	148	\N
12699	4087	150	\N
12700	4087	151	751266
12701	4087	152	721035
12702	4087	153	169874
12703	4088	154	\N
12704	4088	155	\N
12705	4088	156	\N
12706	4088	157	\N
12707	4236	154	\N
12708	4236	158	779881
12709	4236	159	458812
12710	4236	160	220708
12711	4236	161	485174
12712	4237	162	\N
12713	4237	163	\N
12714	4237	165	\N
12715	4089	166	549289
12716	4089	168	438953
12717	4089	170	389265
12718	4089	172	138688
12719	4089	174	277766
12720	4090	176	\N
12721	4090	178	\N
12722	4090	179	\N
12723	4090	180	\N
12724	4238	175	\N
12725	4238	177	\N
12726	4238	181	229720
12727	4238	182	434587
12728	4091	183	\N
12729	4239	183	\N
12730	4091	184	417520
12731	4091	185	201311
12732	4091	186	218957
12733	4091	187	919671
12734	4239	184	828260
12735	4239	185	922618
12736	4239	186	739297
12737	4239	187	220177
12738	4240	188	\N
12739	4092	189	708343
12740	4092	190	724627
12741	4092	191	740755
12742	4092	192	378989
12743	4240	190	928724
12744	4240	191	309871
12745	4093	193	\N
12746	4093	194	\N
12747	4093	195	\N
12748	4241	193	\N
12749	4242	196	\N
12750	4242	197	\N
12751	4094	199	293429
12752	4094	200	104119
12753	4242	198	472762
12754	4095	201	\N
12755	4095	203	\N
12756	4095	204	\N
12757	4095	205	217711
12758	4095	207	457223
12759	4243	206	392241
12760	4243	207	396823
12761	4244	208	739005
12762	4244	209	673565
12763	4096	210	\N
12764	4096	212	\N
12765	4096	213	\N
12766	4245	210	\N
12767	4245	211	\N
12768	4245	212	\N
12769	4245	213	\N
12770	4245	214	298829
12771	4097	215	\N
12772	4097	216	\N
12773	4097	217	\N
12774	4097	218	\N
12775	4097	219	\N
12776	4246	215	\N
12777	4246	216	\N
12778	4246	220	878381
12779	4246	222	896278
12780	4247	223	\N
12781	4248	224	\N
12782	4248	226	\N
12783	4248	227	\N
12784	4248	228	889357
12785	4248	230	620645
12786	4098	232	\N
12787	4249	232	\N
12788	4249	233	\N
12789	4249	234	\N
12790	4250	236	\N
12791	4250	238	\N
12792	4251	239	\N
12793	4251	240	285467
12794	4251	241	990515
12795	4251	243	506344
12796	4251	244	110582
12797	4252	245	\N
12798	4252	246	\N
12799	4252	247	\N
12800	4252	248	\N
12801	4252	250	183500
12802	4253	252	\N
12803	4253	253	\N
12804	4253	254	\N
12805	4253	255	\N
12806	4254	256	\N
12807	4255	257	654660
12808	4324	258	\N
12809	4324	259	\N
12810	4324	260	\N
12811	4324	261	\N
12812	4324	262	542815
12813	4370	263	948355
12814	4370	265	747364
12815	4370	267	582597
12816	4370	269	336187
12817	4371	270	\N
12818	4256	272	606232
12819	4325	271	467089
12820	4371	272	133174
12821	4257	273	\N
12822	4257	274	\N
12823	4372	273	\N
12824	4372	274	\N
12825	4372	275	\N
12826	4257	276	761222
12827	4326	277	296557
12828	4372	276	851844
12829	4258	279	\N
12830	4258	280	\N
12831	4258	281	\N
12832	4327	278	\N
12833	4327	279	\N
12834	4327	280	\N
12835	4258	282	526758
12836	4373	283	933257
12837	4259	284	\N
12838	4259	285	\N
12839	4328	284	\N
12840	4259	287	353775
12841	4259	289	547061
12842	4328	286	557190
12843	4374	287	192597
12844	4329	290	491250
12845	4329	291	123981
12846	4329	292	863108
12847	4329	293	271656
12848	4329	294	148905
12849	4375	290	704709
12850	4375	291	247853
12851	4260	296	\N
12852	4376	295	\N
12853	4260	297	865083
12854	4260	298	449396
12855	4260	299	226840
12856	4261	301	\N
12857	4377	300	\N
12858	4378	302	\N
12859	4378	303	\N
12860	4330	304	102294
12861	4330	305	313832
12862	4379	306	\N
12863	4379	307	\N
12864	4331	308	462842
12865	4331	310	490991
12866	4379	308	988856
12867	4379	309	386641
12868	4379	310	868854
12869	4262	311	\N
12870	4262	313	\N
12871	4262	315	\N
12872	4332	311	\N
12873	4262	316	949695
12874	4262	317	310269
12875	4332	317	629426
12876	4332	318	598545
12877	4263	320	\N
12878	4263	321	\N
12879	4263	322	\N
12880	4333	320	\N
12881	4333	322	\N
12882	4334	323	\N
12883	4334	324	\N
12884	4334	325	\N
12885	4380	323	\N
12886	4380	327	967542
12887	4380	329	551500
12888	4380	331	558479
12889	4380	332	175352
12890	4264	333	\N
12891	4381	335	532042
12892	4335	337	\N
12893	4335	338	\N
12894	4335	339	167051
12895	4382	339	710420
12896	4382	340	708285
12897	4265	341	\N
12898	4265	343	\N
12899	4336	341	\N
12900	4336	343	\N
12901	4383	341	\N
12902	4266	345	\N
12903	4337	345	\N
12904	4337	346	\N
12905	4337	347	\N
12906	4337	349	\N
12907	4337	351	\N
12908	4338	352	808976
12909	4338	353	627919
12910	4338	354	144432
12911	4338	355	823998
12912	4384	352	654307
12913	4267	356	\N
12914	4267	357	\N
12915	4339	356	\N
12916	4339	357	\N
12917	4340	358	\N
12918	4385	358	\N
12919	4268	360	205540
12920	4268	361	597364
12921	4268	362	839813
12922	4268	363	518620
12923	4268	364	837465
12924	4385	359	830017
12925	4269	365	\N
12926	4269	366	\N
12927	4386	365	\N
12928	4386	366	\N
12929	4386	367	\N
12930	4269	368	917076
12931	4269	369	189818
12932	4269	370	461301
12933	4341	368	108655
12934	4341	369	540077
12935	4341	370	185591
12936	4341	371	248450
12937	4341	372	826703
12938	4386	368	549951
12939	4386	369	592507
12940	4342	373	\N
12941	4387	374	\N
12942	4387	375	\N
12943	4270	376	625331
12944	4342	376	476869
12945	4271	377	\N
12946	4271	378	\N
12947	4343	377	\N
12948	4343	378	\N
12949	4343	379	\N
12950	4388	377	\N
12951	4388	379	\N
12952	4388	381	\N
12953	4388	383	\N
12954	4271	384	717008
12955	4271	385	129933
12956	4271	386	726318
12957	4272	387	\N
12958	4272	389	\N
12959	4272	390	\N
12960	4344	387	\N
12961	4344	388	\N
12962	4389	391	747400
12963	4389	392	148044
12964	4389	393	450243
12965	4345	394	\N
12966	4345	396	\N
12967	4390	395	\N
12968	4390	398	616641
12969	4390	399	253887
12970	4390	400	441826
12971	4346	401	\N
12972	4346	402	\N
12973	4346	403	\N
12974	4391	402	\N
12975	4391	403	\N
12976	4391	404	890207
12977	4347	405	\N
12978	4392	405	\N
12979	4273	406	858579
12980	4273	407	940358
12981	4273	408	879020
12982	4347	406	385275
12983	4347	408	885666
12984	4347	410	695215
12985	4347	412	117925
12986	4392	406	513529
12987	4392	407	841444
12988	4392	408	795634
12989	4392	409	914174
12990	4348	413	\N
12991	4348	414	\N
12992	4393	413	\N
12993	4393	414	\N
12994	4393	415	\N
12995	4274	416	733485
12996	4274	417	483617
12997	4274	418	210915
12998	4274	419	346341
12999	4274	420	631180
13000	4393	416	288233
13001	4393	417	929781
13002	4275	421	\N
13003	4349	421	\N
13004	4349	422	\N
13005	4349	423	\N
13006	4275	425	284375
13007	4275	426	396551
13008	4275	427	141851
13009	4394	425	101224
13010	4394	426	123523
13011	4276	428	\N
13012	4277	429	\N
13013	4277	430	\N
13014	4277	431	\N
13015	4350	429	\N
13016	4277	432	393663
13017	4350	433	320145
13018	4350	435	181982
13019	4350	437	201808
13020	4278	438	\N
13021	4278	440	\N
13022	4351	438	\N
13023	4351	439	\N
13024	4395	438	\N
13025	4395	439	\N
13026	4351	442	416526
13027	4351	443	434668
13028	4395	442	588797
13029	4279	444	424389
13030	4279	445	298681
13031	4279	446	156677
13032	4352	445	577175
13033	4352	446	430053
13034	4352	447	959491
13035	4396	445	322427
13036	4396	446	377921
13037	4396	447	413961
13038	4280	448	\N
13039	4353	448	\N
13040	4397	448	\N
13041	4280	449	317166
13042	4280	450	624091
13043	4280	451	979704
13044	4353	450	165295
13045	4354	452	\N
13046	4354	453	\N
13047	4354	454	\N
13048	4398	452	\N
13049	4281	455	102680
13050	4281	456	813631
13051	4354	455	797568
13052	4398	455	436567
13053	4398	457	370655
13054	4355	459	\N
13055	4355	460	\N
13056	4399	459	\N
13057	4399	460	\N
13058	4399	461	\N
13059	4399	462	\N
13060	4282	463	785339
13061	4282	464	889159
13062	4355	463	422142
13063	4355	464	684747
13064	4283	465	\N
13065	4356	465	\N
13066	4400	465	\N
13067	4401	466	\N
13068	4284	467	479608
13069	4401	467	603857
13070	4401	468	411013
13071	4401	470	528579
13072	4401	472	547078
13073	4285	473	\N
13074	4402	473	\N
13075	4402	474	\N
13076	4285	476	290119
13077	4357	475	999334
13078	4358	477	\N
13079	4358	478	\N
13080	4286	480	642719
13081	4286	481	601103
13082	4286	482	954343
13083	4286	483	113993
13084	4358	480	914218
13085	4358	482	389696
13086	4358	483	503034
13087	4403	479	689124
13088	4403	480	876610
13089	4403	482	268732
13090	4403	483	583696
13091	4403	484	686253
13092	4404	485	\N
13093	4404	486	\N
13094	4404	487	\N
13095	4287	488	227280
13096	4287	489	530002
13097	4287	491	736724
13098	4287	492	458931
13099	4287	494	381075
13100	4404	489	132760
13101	4404	490	612011
13102	4405	495	\N
13103	4288	497	872387
13104	4288	498	230490
13105	4359	496	302312
13106	4359	497	602658
13107	4359	498	980322
13108	4359	499	613023
13109	4405	496	952442
13110	4405	498	176410
13111	4405	499	179704
13112	4289	500	\N
13113	4289	501	\N
13114	4360	502	457713
13115	4406	503	966993
13116	4290	504	\N
13117	4290	505	\N
13118	4361	505	\N
13119	4361	506	\N
13120	4407	505	\N
13121	4407	506	\N
13122	4407	507	\N
13123	4407	509	\N
13124	4407	511	\N
13125	4290	512	795405
13126	4290	513	573347
13127	4361	513	714467
13128	4361	514	494480
13129	4291	515	\N
13130	4291	517	\N
13131	4291	519	225634
13132	4291	521	577229
13133	4292	523	\N
13134	4362	522	\N
13135	4362	523	\N
13136	4362	525	\N
13137	4362	526	\N
13138	4362	527	\N
13139	4408	522	\N
13140	4292	529	591941
13141	4292	531	837701
13142	4408	528	639446
13143	4363	532	\N
13144	4363	534	\N
13145	4409	533	\N
13146	4293	535	200914
13147	4293	536	800545
13148	4293	537	616708
13149	4293	538	798011
13150	4293	539	737242
13151	4363	535	269756
13152	4363	537	873916
13153	4410	541	\N
13154	4410	543	\N
13155	4410	544	\N
13156	4294	545	884660
13157	4410	545	866734
13158	4364	546	\N
13159	4364	547	\N
13160	4364	548	\N
13161	4364	550	\N
13162	4411	547	\N
13163	4411	548	\N
13164	4411	549	\N
13165	4411	551	\N
13166	4295	552	541088
13167	4364	552	526556
13168	4411	552	615431
13169	4296	553	\N
13170	4296	554	\N
13171	4296	555	\N
13172	4296	557	\N
13173	4365	553	\N
13174	4365	554	\N
13175	4412	558	581328
13176	4412	559	216326
13177	4412	560	319758
13178	4366	561	\N
13179	4366	562	\N
13180	4366	563	\N
13181	4297	564	935990
13182	4297	565	272697
13183	4297	566	591136
13184	4298	567	894164
13185	4367	568	339234
13186	4367	570	423465
13187	4367	571	226551
13188	4367	572	704406
13189	4299	573	\N
13190	4299	574	\N
13191	4299	575	\N
13192	4299	576	\N
13193	4368	574	\N
13194	4413	573	\N
13195	4413	574	\N
13196	4413	575	\N
13197	4300	577	\N
13198	4300	578	\N
13199	4300	580	\N
13200	4369	577	\N
13201	4369	578	\N
13202	4300	582	526012
13203	4300	583	265094
13204	4414	581	760615
13205	4301	585	\N
13206	4301	587	\N
13207	4301	588	\N
13208	4301	589	282194
13209	4301	590	583511
13210	4302	591	\N
13211	4415	591	\N
13212	4303	592	299981
13213	4416	593	511454
13214	4417	594	\N
13215	4417	595	967609
13216	4417	596	738970
13217	4417	598	521840
13218	4417	599	733923
13219	4304	600	\N
13220	4418	600	\N
13221	4304	601	438883
13222	4305	602	\N
13223	4305	604	\N
13224	4419	605	\N
13225	4419	606	\N
13226	4419	608	289619
13227	4419	609	870500
13228	4419	610	726139
13229	4306	612	195200
13230	4420	613	\N
13231	4307	615	130685
13232	4420	614	234375
13233	4420	615	732850
13234	4420	616	904902
13235	4308	617	\N
13236	4421	617	\N
13237	4421	618	\N
13238	4421	620	\N
13239	4308	622	213397
13240	4308	623	223206
13241	4309	624	147239
13242	4309	625	403697
13243	4309	626	851861
13244	4310	627	\N
13245	4310	628	\N
13246	4310	629	\N
13247	4422	628	\N
13248	4422	630	663226
13249	4311	632	\N
13250	4311	634	\N
13251	4423	632	\N
13252	4423	633	\N
13253	4423	634	\N
13254	4311	636	309046
13255	4311	638	694701
13256	4423	635	819575
13257	4312	639	\N
13258	4312	640	878798
13259	4312	641	165256
13260	4312	642	271011
13261	4313	643	\N
13262	4424	644	697781
13263	4424	646	848977
13264	4425	647	\N
13265	4425	649	\N
13266	4425	650	\N
13267	4314	651	\N
13268	4426	652	\N
13269	4426	654	\N
13270	4315	655	\N
13271	4315	656	\N
13272	4315	657	\N
13273	4315	658	\N
13274	4316	659	\N
13275	4316	660	\N
13276	4316	661	\N
13277	4316	663	\N
13278	4427	664	262358
13279	4317	665	\N
13280	4317	666	\N
13281	4428	665	\N
13282	4428	666	\N
13283	4317	667	591933
13284	4317	668	359596
13285	4317	669	653610
13286	4428	668	362799
13287	4318	670	\N
13288	4318	672	\N
13289	4318	674	484068
13290	4318	675	806723
13291	4319	676	\N
13292	4319	677	\N
13293	4429	678	980296
13294	4429	680	555326
13295	4429	681	684513
13296	4429	682	866778
13297	4320	683	\N
13298	4320	684	\N
13299	4320	685	\N
13300	4430	683	\N
13301	4430	684	\N
13302	4430	685	\N
13303	4430	687	\N
13304	4431	689	\N
13305	4431	690	\N
13306	4431	691	243422
13307	4431	692	391415
13308	4432	693	\N
13309	4432	694	\N
13310	4321	695	\N
13311	4321	696	\N
13312	4321	698	\N
13313	4321	699	\N
13314	4321	701	982900
13315	4433	703	\N
13316	4322	704	\N
13317	4322	706	\N
13318	4322	707	\N
13319	4323	708	\N
13320	4323	709	609387
13321	4434	710	\N
13322	4434	711	\N
13323	4434	712	\N
13324	4434	713	\N
13325	4434	714	150104
13326	4497	714	841102
13327	4497	715	146958
13328	4435	717	\N
13329	4498	716	\N
13330	4435	718	407949
13331	4435	719	425790
13332	4498	718	225500
13333	4498	719	386715
13334	4498	720	940051
13335	4498	722	588683
13336	4436	723	781372
13337	4499	723	325169
13338	4499	724	426720
13339	4499	725	434038
13340	4499	726	840065
13341	4499	727	676319
13342	4437	728	\N
13343	4500	728	\N
13344	4500	729	\N
13345	4500	730	\N
13346	4500	731	\N
13347	4437	733	835749
13348	4501	734	398358
13349	4501	736	614002
13350	4501	738	686633
13351	4501	739	294963
13352	4501	740	279005
13353	4438	741	\N
13354	4502	741	\N
13355	4439	742	\N
13356	4439	743	\N
13357	4439	744	912479
13358	4440	745	253587
13359	4440	746	201410
13360	4440	748	800312
13361	4440	750	575732
13362	4503	745	621347
13363	4504	752	\N
13364	4504	753	\N
13365	4504	754	\N
13366	4504	755	\N
13367	4441	757	217928
13368	4441	759	234979
13369	4504	756	809856
13370	4442	760	\N
13371	4442	761	715534
13372	4442	763	408042
13373	4442	764	466073
13374	4505	761	823486
13375	4505	762	542172
13376	4505	763	552917
13377	4505	764	856425
13378	4505	765	702601
13379	4506	767	\N
13380	4506	768	\N
13381	4506	770	\N
13382	4443	771	441755
13383	4506	772	463109
13384	4506	774	563203
13385	4444	775	\N
13386	4444	776	\N
13387	4444	777	\N
13388	4444	778	\N
13389	4507	775	\N
13390	4444	779	638324
13391	4507	779	621622
13392	4445	780	541516
13393	4508	781	\N
13394	4446	783	\N
13395	4446	784	\N
13396	4446	785	322219
13397	4509	786	\N
13398	4509	787	\N
13399	4447	788	896506
13400	4447	789	627709
13401	4447	790	727305
13402	4447	791	542312
13403	4509	788	131276
13404	4448	792	\N
13405	4448	794	\N
13406	4448	795	\N
13407	4510	792	\N
13408	4510	793	\N
13409	4448	796	235451
13410	4511	797	\N
13411	4511	799	\N
13412	4449	800	\N
13413	4449	801	\N
13414	4449	802	\N
13415	4449	803	\N
13416	4512	804	916594
13417	4512	805	233547
13418	4512	806	534082
13419	4513	807	\N
13420	4450	808	637712
13421	4513	809	441366
13422	4513	811	622337
13423	4451	812	\N
13424	4451	813	\N
13425	4451	814	\N
13426	4514	812	\N
13427	4451	816	598195
13428	4514	815	366234
13429	4514	816	771816
13430	4514	817	824030
13431	4514	818	241095
13432	4515	820	140381
13433	4515	821	564513
13434	4452	822	\N
13435	4452	823	\N
13436	4516	822	\N
13437	4516	823	\N
13438	4516	824	\N
13439	4516	826	\N
13440	4516	827	\N
13441	4452	829	117893
13442	4453	831	\N
13443	4453	832	\N
13444	4517	830	\N
13445	4517	831	\N
13446	4517	832	\N
13447	4453	833	443380
13448	4453	834	118639
13449	4454	835	\N
13450	4454	836	\N
13451	4454	837	\N
13452	4518	836	\N
13453	4455	839	\N
13454	4455	840	\N
13455	4455	842	\N
13456	4519	838	\N
13457	4519	839	\N
13458	4456	844	\N
13459	4456	845	\N
13460	4456	846	\N
13461	4456	847	957690
13462	4456	848	482804
13463	4520	847	696078
13464	4520	849	742111
13465	4457	850	\N
13466	4457	852	\N
13467	4457	854	\N
13468	4457	855	\N
13469	4521	856	685518
13470	4458	857	\N
13471	4458	858	\N
13472	4458	860	\N
13473	4458	861	\N
13474	4522	858	\N
13475	4458	862	362992
13476	4522	862	217280
13477	4522	864	831395
13478	4522	865	310803
13479	4522	866	853321
13480	4459	867	\N
13481	4459	868	\N
13482	4523	867	\N
13483	4523	868	\N
13484	4523	870	\N
13485	4523	871	\N
13486	4523	872	\N
13487	4459	874	773577
13488	4460	875	\N
13489	4460	876	\N
13490	4460	878	658794
13491	4524	877	824584
13492	4524	878	180958
13493	4461	880	870544
13494	4525	879	157770
13495	4526	881	\N
13496	4462	882	553953
13497	4462	883	116969
13498	4462	885	928007
13499	4462	887	389793
13500	4526	883	208862
13501	4526	884	446118
13502	4463	888	\N
13503	4463	889	\N
13504	4527	888	\N
13505	4527	890	\N
13506	4527	891	\N
13507	4527	892	\N
13508	4463	893	975823
13509	4463	895	600913
13510	4463	896	260318
13511	4464	897	\N
13512	4464	898	148194
13513	4465	899	\N
13514	4528	899	\N
13515	4466	900	\N
13516	4466	902	\N
13517	4466	903	\N
13518	4466	904	\N
13519	4466	905	446340
13520	4467	906	\N
13521	4467	908	\N
13522	4467	909	\N
13523	4467	910	\N
13524	4467	912	\N
13525	4529	913	813206
13526	4529	914	848558
13527	4468	915	153412
13528	4468	916	675460
13529	4468	918	161256
13530	4468	920	680402
13531	4468	921	995321
13532	4530	915	423735
13533	4531	923	\N
13534	4531	925	\N
13535	4531	926	\N
13536	4469	928	944168
13537	4469	929	649114
13538	4469	930	737427
13539	4531	927	688978
13540	4470	931	\N
13541	4470	933	742716
13542	4470	934	784068
13543	4471	935	787563
13544	4532	935	664119
13545	4472	936	\N
13546	4472	937	\N
13547	4472	938	\N
13548	4472	939	213380
13549	4533	939	384893
13550	4533	940	283370
13551	4473	941	289582
13552	4473	942	432308
13553	4473	943	408840
13554	4473	944	733851
13555	4534	941	232999
13556	4535	946	932554
13557	4535	947	650889
13558	4535	948	470478
13559	4535	949	754765
13560	4474	950	\N
13561	4474	952	\N
13562	4474	953	\N
13563	4536	951	\N
13564	4536	952	\N
13565	4536	953	\N
13566	4536	954	\N
13567	4474	956	563240
13568	4474	958	481969
13569	4536	956	482699
13570	4537	959	\N
13571	4537	960	\N
13572	4537	961	\N
13573	4537	963	449206
13574	4475	964	\N
13575	4475	965	\N
13576	4538	964	\N
13577	4475	966	659975
13578	4539	967	368894
13579	4539	968	382085
13580	4539	970	379114
13581	4540	971	\N
13582	4476	972	\N
13583	4476	973	\N
13584	4476	974	\N
13585	4476	975	932611
13586	4541	977	\N
13587	4541	979	\N
13588	4541	980	421275
13589	4541	981	428560
13590	4541	982	892377
13591	4477	983	\N
13592	4477	984	626502
13593	4477	985	156488
13594	4477	987	164514
13595	4477	988	844967
13596	4542	985	528835
13597	4542	986	879473
13598	4542	987	739654
13599	4542	988	636127
13600	4478	989	\N
13601	4478	990	\N
13602	4479	991	\N
13603	4543	992	\N
13604	4543	993	\N
13605	4543	994	\N
13606	4543	995	776904
13607	4543	996	928252
13608	4480	997	501714
13609	4480	998	974054
13610	4480	999	143964
13611	4544	998	630129
13612	4544	999	535941
13613	4544	1000	455584
13614	4481	1002	\N
13615	4481	1004	\N
13616	4545	1002	\N
13617	4481	1005	169741
13618	4481	1006	452168
13619	4481	1007	694037
13620	4545	1006	586227
13621	4482	1008	\N
13622	4482	1009	995974
13623	4482	1010	853270
13624	4482	1011	247888
13625	4546	1010	241283
13626	4546	1011	895450
13627	4546	1013	640230
13628	4483	1014	\N
13629	4483	1015	358907
13630	4483	1017	725804
13631	4484	1018	\N
13632	4484	1019	\N
13633	4547	1018	\N
13634	4547	1019	\N
13635	4547	1020	\N
13636	4484	1021	423600
13637	4484	1023	579227
13638	4485	1024	\N
13639	4485	1026	\N
13640	4485	1027	\N
13641	4485	1028	\N
13642	4485	1029	\N
13643	4548	1030	945812
13644	4548	1031	937422
13645	4549	1032	\N
13646	4549	1033	\N
13647	4549	1034	\N
13648	4549	1036	629766
13649	4549	1038	231113
13650	4550	1039	\N
13651	4550	1041	147208
13652	4550	1042	272034
13653	4550	1043	910056
13654	4486	1045	\N
13655	4486	1046	\N
13656	4551	1048	644745
13657	4551	1049	628152
13658	4551	1051	472846
13659	4552	1052	\N
13660	4552	1053	\N
13661	4552	1055	\N
13662	4487	1056	406730
13663	4487	1058	875758
13664	4487	1060	654992
13665	4487	1061	785675
13666	4487	1062	833516
13667	4488	1064	\N
13668	4553	1063	\N
13669	4553	1064	\N
13670	4553	1066	\N
13671	4488	1067	402220
13672	4553	1067	295166
13673	4553	1068	143578
13674	4554	1069	\N
13675	4489	1070	229231
13676	4489	1071	665638
13677	4489	1072	955162
13678	4489	1074	806464
13679	4554	1070	850998
13680	4555	1075	729734
13681	4555	1076	780886
13682	4555	1077	810126
13683	4490	1078	\N
13684	4490	1079	\N
13685	4556	1078	\N
13686	4556	1080	\N
13687	4556	1081	\N
13688	4556	1082	824930
13689	4556	1083	372558
13690	4491	1084	\N
13691	4491	1086	\N
13692	4491	1087	\N
13693	4557	1084	\N
13694	4557	1085	\N
13695	4557	1088	943936
13696	4557	1089	884895
13697	4557	1090	726080
13698	4492	1091	\N
13699	4492	1092	\N
13700	4492	1093	\N
13701	4492	1094	\N
13702	4558	1096	154428
13703	4493	1097	\N
13704	4493	1098	\N
13705	4493	1099	\N
13706	4493	1101	\N
13707	4493	1103	474129
13708	4494	1105	353038
13709	4494	1106	364760
13710	4494	1107	876523
13711	4494	1108	261991
13712	4495	1109	\N
13713	4496	1110	\N
13714	4496	1111	\N
13715	4496	1113	\N
13716	4496	1114	811436
13717	4496	1115	606419
13718	4559	1116	\N
13719	4559	1117	\N
13720	4617	1116	\N
13721	4559	1118	761603
13722	4559	1119	982803
13723	4559	1120	610721
13724	4617	1118	120530
13725	4617	1119	705673
13726	4617	1120	850980
13727	4560	1122	\N
13728	4618	1121	\N
13729	4618	1123	\N
13730	4560	1124	289229
13731	4560	1125	119062
13732	4618	1124	193595
13733	4561	1126	907181
13734	4619	1127	\N
13735	4619	1129	562897
13736	4562	1131	\N
13737	4562	1132	\N
13738	4562	1133	\N
13739	4620	1135	708517
13740	4620	1136	691140
13741	4620	1137	119658
13742	4620	1138	824670
13743	4620	1139	922345
13744	4563	1141	\N
13745	4563	1142	\N
13746	4563	1143	\N
13747	4563	1144	\N
13748	4563	1145	944812
13749	4564	1146	\N
13750	4564	1147	\N
13751	4564	1148	\N
13752	4564	1149	\N
13753	4621	1146	\N
13754	4621	1147	\N
13755	4621	1148	\N
13756	4621	1150	461895
13757	4565	1151	\N
13758	4622	1151	\N
13759	4565	1153	915413
13760	4565	1154	847431
13761	4622	1152	879700
13762	4623	1155	\N
13763	4623	1156	160690
13764	4624	1157	\N
13765	4566	1159	475900
13766	4624	1158	195131
13767	4624	1159	855343
13768	4624	1160	520545
13769	4625	1161	\N
13770	4625	1162	\N
13771	4567	1163	955951
13772	4567	1164	661335
13773	4568	1166	\N
13774	4568	1167	\N
13775	4568	1168	\N
13776	4568	1169	\N
13777	4626	1171	425990
13778	4626	1172	952369
13779	4626	1174	704717
13780	4627	1175	\N
13781	4627	1176	\N
13782	4627	1177	\N
13783	4569	1179	286370
13784	4627	1178	735981
13785	4627	1180	563577
13786	4570	1181	\N
13787	4570	1182	\N
13788	4570	1183	\N
13789	4628	1181	\N
13790	4628	1182	\N
13791	4570	1184	176159
13792	4571	1185	409791
13793	4571	1186	703798
13794	4571	1188	536804
13795	4571	1189	201582
13796	4571	1190	548944
13797	4572	1192	907310
13798	4572	1193	460001
13799	4572	1194	632395
13800	4629	1191	803033
13801	4629	1193	108704
13802	4573	1195	\N
13803	4573	1196	\N
13804	4573	1197	\N
13805	4573	1199	\N
13806	4630	1196	\N
13807	4630	1198	\N
13808	4630	1200	\N
13809	4630	1201	\N
13810	4630	1202	928370
13811	4631	1203	\N
13812	4631	1204	\N
13813	4631	1206	\N
13814	4574	1207	203878
13815	4574	1208	481055
13816	4575	1210	\N
13817	4632	1209	\N
13818	4632	1210	\N
13819	4632	1211	\N
13820	4576	1212	905365
13821	4576	1214	290738
13822	4576	1215	497496
13823	4576	1216	715097
13824	4576	1217	331338
13825	4633	1212	345758
13826	4633	1214	822842
13827	4634	1218	\N
13828	4634	1220	226916
13829	4577	1221	393659
13830	4577	1222	458379
13831	4635	1221	948065
13832	4578	1223	\N
13833	4578	1224	\N
13834	4578	1225	687608
13835	4636	1226	896921
13836	4636	1227	531731
13837	4636	1229	668915
13838	4636	1230	472549
13839	4579	1231	\N
13840	4579	1232	\N
13841	4579	1233	\N
13842	4579	1235	\N
13843	4637	1236	\N
13844	4637	1238	248355
13845	4637	1239	523945
13846	4580	1240	\N
13847	4580	1241	\N
13848	4580	1242	493608
13849	4580	1243	627580
13850	4580	1244	457495
13851	4581	1245	\N
13852	4581	1246	903038
13853	4581	1247	771859
13854	4582	1248	\N
13855	4638	1249	815656
13856	4638	1251	841787
13857	4638	1252	702230
13858	4638	1253	777377
13859	4638	1254	550132
13860	4583	1255	\N
13861	4583	1257	\N
13862	4583	1259	\N
13863	4583	1260	\N
13864	4583	1261	\N
13865	4639	1256	\N
13866	4639	1262	445846
13867	4639	1263	971233
13868	4640	1265	\N
13869	4584	1266	819052
13870	4584	1267	797254
13871	4584	1269	467299
13872	4584	1270	224818
13873	4584	1271	906619
13874	4640	1266	904431
13875	4641	1272	598158
13876	4585	1273	\N
13877	4585	1275	\N
13878	4642	1276	\N
13879	4642	1277	272851
13880	4586	1278	\N
13881	4643	1278	\N
13882	4586	1280	205147
13883	4643	1279	634410
13884	4587	1282	\N
13885	4587	1284	201229
13886	4587	1285	453155
13887	4587	1286	180154
13888	4587	1287	680708
13889	4588	1288	\N
13890	4588	1289	242702
13891	4588	1290	630423
13892	4588	1291	489526
13893	4644	1289	778976
13894	4644	1290	694085
13895	4589	1292	\N
13896	4589	1293	273187
13897	4589	1294	591337
13898	4589	1296	966707
13899	4589	1298	525455
13900	4645	1294	254711
13901	4646	1300	\N
13902	4646	1302	\N
13903	4646	1303	\N
13904	4590	1304	336208
13905	4590	1306	318275
13906	4590	1307	665435
13907	4646	1304	112149
13908	4591	1308	\N
13909	4591	1310	\N
13910	4591	1311	\N
13911	4591	1312	\N
13912	4591	1313	573210
13913	4647	1313	472137
13914	4647	1314	177094
13915	4592	1316	\N
13916	4592	1317	\N
13917	4592	1319	\N
13918	4592	1320	413369
13919	4648	1320	320588
13920	4648	1321	175568
13921	4593	1322	\N
13922	4593	1324	\N
13923	4593	1325	\N
13924	4593	1326	\N
13925	4649	1322	\N
13926	4594	1327	\N
13927	4650	1327	\N
13928	4594	1328	130126
13929	4650	1328	110507
13930	4650	1329	236881
13931	4650	1330	446291
13932	4595	1331	785547
13933	4651	1331	450625
13934	4651	1332	479218
13935	4651	1333	886524
13936	4651	1334	182030
13937	4596	1336	\N
13938	4596	1337	\N
13939	4596	1338	\N
13940	4596	1339	139234
13941	4596	1340	892331
13942	4652	1341	375735
13943	4652	1342	961810
13944	4652	1344	864554
13945	4652	1345	394614
13946	4652	1346	181449
13947	4597	1348	524745
13948	4597	1350	666556
13949	4597	1351	291346
13950	4597	1352	174649
13951	4653	1348	766254
13952	4653	1349	732193
13953	4653	1351	830126
13954	4598	1353	\N
13955	4599	1354	\N
13956	4599	1356	\N
13957	4599	1357	\N
13958	4599	1359	\N
13959	4654	1360	821981
13960	4655	1361	\N
13961	4655	1363	\N
13962	4600	1365	611616
13963	4600	1367	544763
13964	4600	1368	474444
13965	4655	1364	451772
13966	4655	1365	744162
13967	4656	1369	\N
13968	4656	1370	\N
13969	4656	1371	\N
13970	4656	1373	\N
13971	4601	1375	606505
13972	4601	1377	714277
13973	4601	1378	851693
13974	4602	1379	\N
13975	4657	1379	\N
13976	4602	1380	262471
13977	4602	1382	575145
13978	4657	1380	829663
13979	4658	1384	\N
13980	4658	1385	\N
13981	4658	1387	\N
13982	4658	1388	\N
13983	4603	1389	772761
13984	4658	1389	324649
13985	4604	1390	\N
13986	4604	1391	\N
13987	4604	1392	\N
13988	4659	1393	571131
13989	4659	1395	109127
13990	4659	1396	310803
13991	4659	1397	314183
13992	4659	1398	736560
13993	4660	1399	\N
13994	4605	1400	445674
13995	4605	1401	668695
13996	4605	1403	791447
13997	4606	1404	\N
13998	4661	1405	\N
13999	4661	1407	846453
14000	4661	1408	418947
14001	4661	1410	787668
14002	4607	1412	\N
14003	4607	1413	479330
14004	4608	1415	\N
14005	4608	1416	\N
14006	4662	1417	933868
14007	4662	1419	508839
14008	4662	1420	198993
14009	4663	1421	\N
14010	4609	1423	460563
14011	4609	1424	270487
14012	4609	1425	217244
14013	4609	1426	870796
14014	4663	1422	366155
14015	4664	1427	\N
14016	4664	1428	\N
14017	4664	1430	\N
14018	4664	1431	\N
14019	4610	1432	243460
14020	4610	1434	703654
14021	4610	1436	435737
14022	4664	1432	143124
14023	4611	1437	\N
14024	4611	1439	\N
14025	4665	1437	\N
14026	4665	1439	\N
14027	4611	1440	590595
14028	4666	1441	623984
14029	4666	1443	459649
14030	4666	1445	172995
14031	4666	1446	996404
14032	4612	1447	\N
14033	4667	1448	119913
14034	4613	1449	\N
14035	4613	1451	\N
14036	4668	1449	\N
14037	4668	1450	\N
14038	4668	1452	\N
14039	4669	1453	\N
14040	4669	1455	\N
14041	4614	1456	768041
14042	4614	1458	205121
14043	4614	1459	673624
14044	4614	1460	722559
14045	4669	1456	586993
14046	4669	1457	322545
14047	4669	1459	842398
14048	4670	1461	\N
14049	4670	1463	\N
14050	4670	1464	531434
14051	4615	1465	\N
14052	4615	1466	\N
14053	4671	1465	\N
14054	4615	1467	383812
14055	4615	1469	108020
14056	4616	1470	\N
14057	4616	1471	\N
14058	4672	1470	\N
14059	4672	1472	479359
14060	4672	1473	653743
14061	4672	1474	323852
14062	4672	1475	190743
14063	4673	1476	\N
14064	4674	1477	\N
14065	4674	1479	\N
14066	4674	1480	\N
14067	4675	1481	\N
14068	4675	1482	\N
14069	4676	1484	\N
14070	4676	1485	\N
14071	4676	1486	\N
14072	4676	1487	464817
14073	4677	1488	\N
14074	4677	1489	\N
14075	4678	1490	\N
14076	4678	1491	\N
14077	4678	1492	\N
14078	4678	1493	\N
14079	4678	1495	\N
14080	4679	1496	\N
14081	4679	1497	\N
14082	4679	1498	\N
14083	4680	1499	\N
14084	4680	1501	104225
14085	4680	1502	972250
14086	4680	1503	324224
14087	4681	1504	\N
14088	4681	1505	\N
14089	4681	1506	\N
14090	4682	1508	\N
14091	4682	1509	\N
14092	4682	1511	\N
14093	4682	1512	\N
14094	4682	1513	498645
14095	4683	1515	\N
14096	4683	1516	373189
14097	4683	1517	565733
14098	4684	1518	714030
14099	4684	1519	590602
14100	4685	1520	\N
14101	4685	1521	583043
14102	4685	1522	405601
14103	4685	1523	399936
14104	4686	1524	\N
14105	4686	1525	\N
14106	4687	1526	\N
14107	4687	1527	\N
14108	4687	1528	\N
14109	4688	1529	\N
14110	4689	1530	\N
14111	4689	1532	\N
14112	4689	1534	864132
14113	4690	1535	428887
14114	4690	1536	546204
14115	4691	1538	\N
14116	4692	1540	880518
14117	4732	1539	685464
14118	4732	1540	828525
14119	4732	1541	234797
14120	4732	1542	383339
14121	4732	1543	781422
14122	4693	1544	\N
14123	4733	1545	\N
14124	4733	1546	\N
14125	4733	1547	\N
14126	4733	1548	\N
14127	4733	1549	439791
14128	4734	1550	\N
14129	4694	1551	545167
14130	4695	1552	\N
14131	4735	1552	\N
14132	4735	1553	\N
14133	4735	1554	\N
14134	4736	1556	\N
14135	4736	1557	141845
14136	4696	1558	817800
14137	4696	1560	995610
14138	4696	1561	271219
14139	4737	1558	669941
14140	4737	1559	770295
14141	4737	1560	573175
14142	4737	1561	843807
14143	4737	1563	774703
14144	4697	1564	\N
14145	4697	1566	\N
14146	4697	1567	749446
14147	4697	1569	814742
14148	4697	1570	153002
14149	4738	1568	680292
14150	4698	1572	\N
14151	4698	1573	\N
14152	4698	1574	\N
14153	4739	1575	938909
14154	4739	1576	668396
14155	4739	1577	248834
14156	4739	1579	443076
14157	4699	1580	\N
14158	4699	1581	\N
14159	4699	1582	800509
14160	4700	1583	613332
14161	4740	1583	551941
14162	4701	1584	\N
14163	4701	1586	\N
14164	4741	1588	807373
14165	4741	1589	983093
14166	4741	1590	808043
14167	4741	1592	541539
14168	4742	1593	\N
14169	4702	1594	802086
14170	4702	1595	434722
14171	4703	1596	\N
14172	4703	1597	\N
14173	4703	1599	\N
14174	4703	1600	\N
14175	4703	1601	\N
14176	4743	1597	\N
14177	4743	1599	\N
14178	4743	1600	\N
14179	4743	1602	511020
14180	4704	1603	\N
14181	4744	1603	\N
14182	4744	1605	854505
14183	4705	1606	\N
14184	4705	1607	\N
14185	4705	1609	\N
14186	4745	1606	\N
14187	4745	1610	457665
14188	4745	1611	598855
14189	4745	1612	139848
14190	4706	1613	\N
14191	4706	1615	\N
14192	4706	1616	\N
14193	4746	1613	\N
14194	4746	1614	\N
14195	4746	1616	\N
14196	4746	1617	\N
14197	4747	1618	\N
14198	4707	1620	713279
14199	4707	1621	404834
14200	4748	1622	821584
14201	4708	1623	\N
14202	4708	1624	\N
14203	4749	1623	\N
14204	4749	1624	\N
14205	4708	1625	340256
14206	4708	1627	831113
14207	4708	1629	611394
14208	4750	1631	\N
14209	4750	1632	\N
14210	4750	1633	605704
14211	4750	1634	628504
14212	4709	1636	\N
14213	4709	1638	\N
14214	4709	1639	\N
14215	4709	1640	\N
14216	4709	1641	\N
14217	4751	1635	\N
14218	4751	1636	\N
14219	4751	1642	979388
14220	4751	1643	803957
14221	4752	1644	\N
14222	4710	1645	789048
14223	4752	1646	608969
14224	4711	1647	\N
14225	4711	1648	\N
14226	4711	1649	\N
14227	4712	1650	\N
14228	4712	1651	\N
14229	4712	1652	\N
14230	4753	1650	\N
14231	4753	1652	\N
14232	4753	1653	\N
14233	4753	1655	\N
14234	4712	1656	185089
14235	4753	1656	988755
14236	4713	1658	193917
14237	4714	1659	\N
14238	4714	1661	\N
14239	4754	1659	\N
14240	4754	1660	\N
14241	4714	1662	347466
14242	4754	1662	148991
14243	4754	1664	583679
14244	4755	1666	\N
14245	4755	1667	\N
14246	4755	1669	777895
14247	4755	1670	403198
14248	4715	1671	\N
14249	4756	1673	669486
14250	4756	1674	344555
14251	4716	1675	\N
14252	4757	1675	\N
14253	4757	1676	\N
14254	4757	1677	\N
14255	4758	1679	\N
14256	4758	1680	122317
14257	4758	1681	118589
14258	4758	1682	553773
14259	4717	1684	\N
14260	4759	1683	\N
14261	4759	1684	\N
14262	4759	1686	\N
14263	4717	1687	639079
14264	4717	1688	870860
14265	4717	1689	209211
14266	4760	1691	\N
14267	4760	1692	\N
14268	4718	1693	179853
14269	4760	1693	942021
14270	4760	1695	710048
14271	4719	1696	\N
14272	4719	1697	280163
14273	4719	1699	236234
14274	4720	1700	\N
14275	4720	1702	391029
14276	4720	1704	944176
14277	4720	1706	653379
14278	4761	1707	\N
14279	4761	1708	\N
14280	4761	1710	\N
14281	4721	1711	155389
14282	4722	1713	\N
14283	4722	1714	\N
14284	4762	1712	\N
14285	4722	1715	234640
14286	4722	1716	192753
14287	4722	1717	601949
14288	4762	1715	769705
14289	4762	1716	579258
14290	4762	1717	675841
14291	4762	1718	749351
14292	4723	1719	\N
14293	4723	1720	\N
14294	4723	1722	616588
14295	4723	1723	202564
14296	4763	1722	450499
14297	4724	1725	\N
14298	4764	1724	\N
14299	4764	1725	\N
14300	4764	1726	561023
14301	4764	1727	454274
14302	4764	1728	715112
14303	4725	1729	\N
14304	4725	1730	\N
14305	4765	1731	121931
14306	4765	1732	904539
14307	4726	1734	\N
14308	4726	1736	\N
14309	4726	1737	\N
14310	4766	1733	\N
14311	4766	1734	\N
14312	4726	1738	860796
14313	4726	1739	301809
14314	4766	1738	158927
14315	4727	1740	\N
14316	4727	1742	\N
14317	4727	1743	\N
14318	4727	1744	\N
14319	4727	1745	\N
14320	4767	1741	\N
14321	4767	1742	\N
14322	4767	1743	\N
14323	4767	1746	606225
14324	4767	1747	262703
14325	4728	1748	501047
14326	4768	1749	369510
14327	4729	1751	\N
14328	4769	1751	\N
14329	4769	1752	975287
14330	4769	1754	134385
14331	4769	1755	768338
14332	4730	1756	988945
14333	4730	1758	149892
14334	4730	1759	945124
14335	4730	1760	782028
14336	4730	1762	176832
14337	4770	1764	\N
14338	4770	1766	\N
14339	4770	1767	\N
14340	4770	1768	363692
14341	4731	1769	209009
14342	4771	1771	\N
14343	4771	1772	\N
14344	4771	1773	307788
14345	4771	1774	730996
14346	4771	1776	601508
14347	4772	1778	\N
14348	4772	1779	\N
14349	4772	1780	\N
14350	4772	1782	\N
14351	4773	1784	716282
14352	4774	1785	\N
14353	4774	1786	\N
14354	4774	1787	\N
14355	4774	1788	921256
14356	4775	1790	908080
14357	4776	1791	\N
14358	4777	1792	\N
14359	4778	1793	\N
14360	4778	1794	258999
14361	4779	1795	\N
14362	4779	1796	\N
14363	4779	1797	\N
14364	4779	1798	\N
14365	4779	1799	\N
14366	4780	1800	453692
14367	4780	1801	228081
14368	4780	1802	609782
14369	4781	1803	780138
14370	4782	1805	\N
14371	4782	1807	371704
14372	4782	1808	132790
14373	4782	1810	631040
14374	4783	1811	443605
14375	4784	1812	\N
14376	4784	1813	\N
14377	4784	1814	\N
14378	4784	1815	\N
14379	4784	1816	\N
14380	4785	1818	\N
14381	4785	1819	866468
14382	4786	1821	674005
14383	4787	1822	\N
14384	4787	1823	\N
14385	4787	1825	\N
14386	4788	1826	\N
14387	4789	1827	\N
14388	4789	1828	184068
14389	4789	1830	707574
14390	4789	1831	306237
14391	4790	1832	\N
14392	4790	1833	\N
14393	4790	1835	352443
14394	4790	1836	695310
14395	4790	1837	865141
14396	4791	1838	\N
14397	4792	1839	\N
14398	4792	1840	\N
14399	4793	1841	968513
14400	4794	1842	\N
14401	4794	1843	\N
14402	4794	1845	\N
14403	4795	1847	\N
14404	4795	1849	955523
14405	4795	1851	859172
14406	4796	1853	109516
14407	4796	1854	417699
14408	4796	1855	987325
14409	4797	1856	\N
14410	4797	1857	767001
14411	4797	1858	764418
14412	4797	1859	905051
14413	4797	1860	751955
14414	4798	1861	\N
14415	4798	1862	481727
14416	4798	1863	342909
14417	4798	1864	789099
14418	4798	1866	784345
14419	4799	1867	\N
14420	4799	1868	\N
14421	4799	1869	239667
14422	4799	1870	588086
14423	4800	1872	852005
14424	4887	1873	\N
14425	4887	1874	\N
14426	4887	1875	\N
14427	4954	1873	\N
14428	4954	1875	\N
14429	4801	1876	\N
14430	4801	1877	\N
14431	4801	1878	\N
14432	4801	1879	\N
14433	4888	1876	\N
14434	4955	1876	\N
14435	4801	1880	562137
14436	4888	1880	587369
14437	4889	1881	985425
14438	4889	1882	586143
14439	4889	1884	763405
14440	4890	1885	175283
14441	4802	1886	\N
14442	4956	1886	\N
14443	4956	1888	\N
14444	4956	1889	\N
14445	4956	1890	\N
14446	4802	1891	887716
14447	4802	1892	926417
14448	4891	1894	\N
14449	4803	1896	299458
14450	4803	1897	748284
14451	4803	1898	809837
14452	4891	1895	588319
14453	4804	1899	\N
14454	4804	1901	124084
14455	4804	1902	791685
14456	4804	1903	192291
14457	4804	1904	884410
14458	4892	1900	997014
14459	4892	1901	228452
14460	4892	1902	340349
14461	4805	1905	364926
14462	4893	1905	105086
14463	4893	1906	909463
14464	4893	1907	416146
14465	4893	1909	474249
14466	4957	1905	427381
14467	4957	1906	868118
14468	4957	1907	729481
14469	4957	1908	117167
14470	4957	1909	146170
14471	4806	1910	\N
14472	4894	1911	\N
14473	4894	1912	197171
14474	4958	1913	\N
14475	4958	1914	\N
14476	4958	1916	\N
14477	4958	1918	\N
14478	4958	1919	\N
14479	4807	1921	937807
14480	4808	1922	\N
14481	4808	1923	\N
14482	4895	1922	\N
14483	4808	1924	972038
14484	4808	1926	662103
14485	4895	1924	785833
14486	4895	1926	765442
14487	4809	1927	\N
14488	4896	1927	\N
14489	4896	1928	\N
14490	4959	1927	\N
14491	4810	1929	\N
14492	4897	1930	\N
14493	4897	1931	\N
14494	4897	1932	\N
14495	4960	1929	\N
14496	4810	1934	202819
14497	4810	1935	310823
14498	4897	1933	410742
14499	4898	1937	\N
14500	4898	1938	\N
14501	4898	1939	\N
14502	4961	1936	\N
14503	4811	1940	273318
14504	4811	1941	505675
14505	4811	1943	775465
14506	4811	1944	764974
14507	4811	1945	963143
14508	4898	1940	677915
14509	4961	1940	832309
14510	4961	1941	229620
14511	4812	1946	\N
14512	4812	1947	\N
14513	4812	1948	\N
14514	4812	1949	\N
14515	4812	1951	\N
14516	4962	1946	\N
14517	4962	1947	\N
14518	4962	1948	\N
14519	4962	1949	\N
14520	4813	1952	\N
14521	4813	1954	\N
14522	4813	1956	\N
14523	4899	1952	\N
14524	4899	1953	\N
14525	4899	1954	\N
14526	4899	1955	\N
14527	4963	1953	\N
14528	4813	1957	392711
14529	4899	1958	737054
14530	4963	1957	259729
14531	4963	1958	431615
14532	4963	1959	116298
14533	4900	1960	\N
14534	4964	1960	\N
14535	4814	1962	\N
14536	4901	1963	180361
14537	4901	1964	713384
14538	4901	1965	508097
14539	4901	1967	737414
14540	4901	1968	720686
14541	4965	1964	784080
14542	4965	1965	278553
14543	4965	1966	662676
14544	4902	1969	\N
14545	4966	1970	\N
14546	4966	1971	\N
14547	4966	1973	\N
14548	4815	1975	501950
14549	4815	1977	849746
14550	4815	1978	379944
14551	4903	1980	\N
14552	4967	1981	567954
14553	4967	1982	383959
14554	4904	1984	\N
14555	4816	1985	827835
14556	4816	1986	341853
14557	4816	1988	452234
14558	4816	1989	952787
14559	4816	1990	464123
14560	4968	1986	165843
14561	4817	1992	\N
14562	4817	1993	\N
14563	4817	1995	\N
14564	4817	1996	\N
14565	4905	1991	\N
14566	4905	1992	\N
14567	4905	1993	\N
14568	4905	1995	\N
14569	4817	1997	617439
14570	4969	1998	\N
14571	4969	1999	\N
14572	4969	0	195794
14573	4818	1	325397
14574	4970	1	832773
14575	4970	2	923152
14576	4970	3	691795
14577	4970	4	975884
14578	4970	5	150875
14579	4819	6	\N
14580	4819	7	\N
14581	4819	8	\N
14582	4906	6	\N
14583	4971	9	525335
14584	4971	10	108911
14585	4820	11	\N
14586	4907	12	\N
14587	4972	11	\N
14588	4820	14	567038
14589	4907	13	986469
14590	4907	14	123684
14591	4907	15	344997
14592	4972	13	979164
14593	4972	14	677252
14594	4908	16	\N
14595	4908	17	\N
14596	4908	18	\N
14597	4908	19	\N
14598	4908	21	621130
14599	4973	20	721952
14600	4973	21	214900
14601	4973	22	622418
14602	4973	23	698677
14603	4821	24	\N
14604	4909	25	\N
14605	4909	27	\N
14606	4909	29	\N
14607	4909	30	177898
14608	4822	31	\N
14609	4822	33	\N
14610	4822	34	\N
14611	4974	31	\N
14612	4910	35	140875
14613	4975	37	\N
14614	4975	38	\N
14615	4975	39	\N
14616	4975	40	\N
14617	4823	42	606976
14618	4823	43	440983
14619	4823	44	485303
14620	4911	41	500598
14621	4911	42	706868
14622	4912	45	\N
14623	4912	46	\N
14624	4824	47	102538
14625	4912	47	977236
14626	4912	49	528020
14627	4912	50	754225
14628	4976	47	817089
14629	4825	51	737996
14630	4825	52	845496
14631	4825	53	525117
14632	4913	51	872680
14633	4977	54	\N
14634	4914	55	676723
14635	4914	56	656250
14636	4914	58	434640
14637	4914	59	285302
14638	4914	61	217847
14639	4915	62	\N
14640	4915	64	\N
14641	4915	65	845663
14642	4915	66	846374
14643	4978	66	516525
14644	4978	68	379333
14645	4978	69	667814
14646	4826	70	\N
14647	4979	70	\N
14648	4979	71	\N
14649	4979	72	\N
14650	4979	73	\N
14651	4979	74	\N
14652	4916	75	\N
14653	4916	76	\N
14654	4916	77	\N
14655	4980	75	\N
14656	4980	76	\N
14657	4827	78	184443
14658	4916	78	140201
14659	4980	78	912188
14660	4980	80	271674
14661	4980	81	824347
14662	4828	82	\N
14663	4828	84	\N
14664	4828	85	\N
14665	4917	82	\N
14666	4917	83	\N
14667	4917	84	\N
14668	4981	82	\N
14669	4981	83	\N
14670	4828	86	855752
14671	4828	87	354051
14672	4917	86	582154
14673	4917	88	298295
14674	4981	86	383453
14675	4981	87	278464
14676	4981	88	988018
14677	4918	90	\N
14678	4918	92	\N
14679	4918	94	212582
14680	4918	96	147592
14681	4982	93	545673
14682	4982	94	850887
14683	4982	95	965756
14684	4829	97	\N
14685	4829	98	\N
14686	4829	99	\N
14687	4829	100	\N
14688	4919	98	\N
14689	4983	97	\N
14690	4829	101	534667
14691	4983	101	895533
14692	4983	103	497412
14693	4830	104	\N
14694	4830	105	\N
14695	4830	106	\N
14696	4920	105	\N
14697	4920	106	\N
14698	4920	107	783220
14699	4920	109	518975
14700	4984	107	247871
14701	4831	110	101489
14702	4832	111	\N
14703	4832	113	\N
14704	4921	111	\N
14705	4921	112	\N
14706	4985	111	\N
14707	4832	114	485560
14708	4832	115	477780
14709	4832	116	950292
14710	4985	114	237701
14711	4985	116	127689
14712	4922	117	\N
14713	4833	118	950081
14714	4833	119	685436
14715	4833	121	917297
14716	4986	119	298940
14717	4923	122	\N
14718	4923	123	\N
14719	4987	122	\N
14720	4834	125	478993
14721	4923	125	604704
14722	4835	126	\N
14723	4988	127	889366
14724	4988	128	192866
14725	4924	130	\N
14726	4836	132	474479
14727	4924	131	177645
14728	4924	132	527943
14729	4924	133	767029
14730	4837	134	\N
14731	4925	134	\N
14732	4925	136	\N
14733	4925	137	\N
14734	4925	138	\N
14735	4989	135	\N
14736	4989	137	\N
14737	4989	138	\N
14738	4989	139	\N
14739	4838	140	\N
14740	4838	141	\N
14741	4838	143	\N
14742	4926	140	\N
14743	4990	141	\N
14744	4990	142	\N
14745	4838	144	477281
14746	4926	144	862994
14747	4926	145	838469
14748	4926	146	531791
14749	4990	145	910610
14750	4990	146	128240
14751	4990	148	826825
14752	4839	150	\N
14753	4991	149	\N
14754	4991	150	\N
14755	4991	151	\N
14756	4991	152	\N
14757	4839	153	368666
14758	4927	154	636501
14759	4927	155	808697
14760	4927	156	124133
14761	4927	157	679729
14762	4928	159	\N
14763	4928	161	\N
14764	4840	163	507532
14765	4840	164	298687
14766	4840	165	763619
14767	4840	167	748602
14768	4928	162	610629
14769	4841	168	\N
14770	4841	170	\N
14771	4841	171	\N
14772	4841	172	841504
14773	4841	173	783255
14774	4992	172	493346
14775	4992	173	374316
14776	4992	174	110477
14777	4842	175	\N
14778	4929	175	\N
14779	4929	176	\N
14780	4993	175	\N
14781	4993	176	\N
14782	4993	177	\N
14783	4929	178	359519
14784	4929	179	791631
14785	4929	180	274803
14786	4993	178	506400
14787	4930	181	\N
14788	4930	182	\N
14789	4994	181	\N
14790	4994	183	\N
14791	4930	185	101637
14792	4930	186	700696
14793	4930	187	496732
14794	4994	184	713470
14795	4931	188	\N
14796	4995	189	\N
14797	4995	190	\N
14798	4995	191	\N
14799	4843	192	462013
14800	4843	193	281700
14801	4931	192	959328
14802	4931	193	976697
14803	4995	193	903513
14804	4995	194	729683
14805	4996	196	\N
14806	4996	197	\N
14807	4996	198	\N
14808	4844	199	510952
14809	4996	199	155648
14810	4996	200	175764
14811	4845	201	\N
14812	4845	202	\N
14813	4932	202	\N
14814	4932	203	\N
14815	4845	204	701248
14816	4932	204	989717
14817	4997	205	321133
14818	4997	206	107875
14819	4997	207	237298
14820	4997	208	232049
14821	4846	209	\N
14822	4846	210	\N
14823	4998	209	\N
14824	4998	211	\N
14825	4998	212	\N
14826	4998	213	\N
14827	4998	215	\N
14828	4999	216	\N
14829	4999	217	\N
14830	4999	218	499268
14831	4847	219	\N
14832	4847	220	\N
14833	4847	221	\N
14834	4847	222	283212
14835	4847	223	237239
14836	5000	222	645506
14837	5000	223	567206
14838	5001	224	814037
14839	5001	225	216284
14840	5001	226	403016
14841	4848	227	\N
14842	4933	227	\N
14843	5002	227	\N
14844	5002	228	\N
14845	5002	230	\N
14846	4848	231	521500
14847	4848	232	601775
14848	4848	233	665459
14849	4933	231	435845
14850	4933	232	952464
14851	4933	233	109438
14852	4849	234	\N
14853	4849	236	\N
14854	4849	237	\N
14855	4934	234	\N
14856	4934	235	\N
14857	4934	236	\N
14858	4934	237	\N
14859	4934	238	746763
14860	5003	238	306264
14861	4850	239	\N
14862	4850	240	\N
14863	4850	241	\N
14864	4850	242	\N
14865	4935	243	914607
14866	4935	244	887526
14867	4935	246	878057
14868	4851	247	\N
14869	4851	248	\N
14870	4851	250	\N
14871	4936	247	\N
14872	4936	248	\N
14873	4936	249	\N
14874	5004	248	\N
14875	5004	249	\N
14876	4851	251	220014
14877	4936	251	569927
14878	4936	252	213869
14879	4937	253	\N
14880	5005	253	\N
14881	5005	254	\N
14882	4937	256	120218
14883	4937	257	855650
14884	4852	258	\N
14885	4938	258	\N
14886	5006	258	\N
14887	4938	259	754499
14888	4938	260	889730
14889	5006	259	301899
14890	4853	261	\N
14891	4853	262	\N
14892	4939	261	\N
14893	5007	261	\N
14894	5007	262	\N
14895	4939	263	294351
14896	5007	263	115929
14897	4854	264	\N
14898	4854	265	\N
14899	5008	264	\N
14900	5008	265	\N
14901	4854	266	681858
14902	4854	267	711565
14903	4854	268	809843
14904	4940	267	890946
14905	4940	268	301519
14906	5008	266	131085
14907	4855	270	\N
14908	4855	271	\N
14909	4855	272	\N
14910	5009	270	\N
14911	5009	271	\N
14912	4855	273	306860
14913	4855	274	947036
14914	4856	276	\N
14915	4856	277	\N
14916	4856	278	\N
14917	4856	279	\N
14918	5010	275	\N
14919	4856	281	206346
14920	5010	281	303139
14921	5010	282	144801
14922	4857	283	883502
14923	5011	284	578090
14924	5012	285	\N
14925	5012	286	\N
14926	5012	288	\N
14927	4941	289	765944
14928	4941	290	738266
14929	4941	291	994797
14930	5013	292	\N
14931	4858	293	\N
14932	4858	295	\N
14933	4942	293	\N
14934	4942	294	\N
14935	5014	294	\N
14936	5014	295	\N
14937	4858	296	839837
14938	4858	297	317657
14939	4858	298	683032
14940	5014	296	476017
14941	4859	299	\N
14942	4859	301	\N
14943	4943	299	\N
14944	4943	300	\N
14945	5015	300	\N
14946	5015	301	\N
14947	5015	302	\N
14948	4859	303	468011
14949	4859	305	763441
14950	4943	303	526961
14951	5015	303	239397
14952	4944	306	\N
14953	4860	307	633761
14954	4860	308	997219
14955	4860	309	307494
14956	4860	310	867200
14957	4860	311	189606
14958	4944	307	902432
14959	4944	308	262408
14960	4861	312	\N
14961	4861	313	314983
14962	4861	314	737583
14963	4861	316	701427
14964	4861	317	929528
14965	4945	313	642369
14966	4945	314	446867
14967	4945	315	843659
14968	4945	316	698742
14969	5016	313	348414
14970	5016	314	232819
14971	5016	316	496408
14972	4862	318	\N
14973	5017	319	\N
14974	5017	320	\N
14975	4946	321	173938
14976	5017	322	598818
14977	4947	323	\N
14978	4947	324	\N
14979	4947	325	\N
14980	4947	326	\N
14981	4947	328	\N
14982	5018	324	\N
14983	5018	325	\N
14984	5018	326	\N
14985	5018	327	\N
14986	4863	329	525586
14987	5018	329	725828
14988	4864	330	\N
14989	4864	331	\N
14990	4948	330	\N
14991	4948	331	\N
14992	4948	333	\N
14993	4948	334	\N
14994	5019	331	\N
14995	5019	332	\N
14996	4864	335	300416
14997	4864	337	407123
14998	4864	338	465341
14999	5019	336	573615
15000	5019	337	266437
15001	5020	340	\N
15002	4865	341	462343
15003	4949	342	521771
15004	4949	344	784136
15005	5020	341	442220
15006	5020	342	541211
15007	4866	345	\N
15008	4866	346	\N
15009	4950	345	\N
15010	4950	346	\N
15011	4950	347	\N
15012	4950	348	\N
15013	4950	349	\N
15014	4866	351	155973
15015	4866	352	107010
15016	4866	354	962575
15017	4867	355	\N
15018	4867	356	\N
15019	4867	358	\N
15020	4951	356	\N
15021	4951	358	\N
15022	4867	359	565774
15023	4867	360	880361
15024	4951	360	504649
15025	4951	361	384323
15026	4868	362	\N
15027	4868	364	\N
15028	4868	366	\N
15029	4868	367	\N
15030	4952	368	925505
15031	4953	369	\N
15032	4869	370	139550
15033	4869	371	526314
15034	4870	372	\N
15035	4870	373	996770
15036	4870	374	196407
15037	4871	375	\N
15038	4871	376	\N
15039	4871	377	660017
15040	4872	378	\N
15041	4872	380	149115
15042	4872	382	213939
15043	4872	383	621704
15044	4872	385	500329
15045	4873	387	\N
15046	4874	388	334308
15047	4875	390	405917
15048	4875	391	761344
15049	4875	392	738070
15050	4875	393	690167
15051	4876	395	683446
15052	4876	396	963317
15053	4876	397	990927
15054	4876	399	253766
15055	4877	400	755572
15056	4877	401	193200
15057	4878	402	\N
15058	4878	403	675657
15059	4878	404	324548
15060	4878	406	527098
15061	4878	407	214794
15062	4879	408	\N
15063	4879	409	\N
15064	4879	411	\N
15065	4880	412	395898
15066	4880	413	339081
15067	4881	414	\N
15068	4881	415	\N
15069	4881	416	\N
15070	4882	417	\N
15071	4882	419	405130
15072	4882	420	626038
15073	4882	421	603203
15074	4883	422	\N
15075	4883	424	845288
15076	4884	425	\N
15077	4884	427	\N
15078	4884	429	995570
15079	4885	430	596234
15080	4886	431	\N
15081	4886	432	\N
15082	4886	433	\N
15083	4886	434	939680
15084	5103	435	\N
15085	5103	436	\N
15086	5103	437	\N
15087	5181	438	\N
15088	5021	439	986611
15089	5181	439	790941
15090	5182	441	\N
15091	5183	443	\N
15092	5183	444	\N
15093	5183	445	\N
15094	5104	446	968696
15095	5104	447	560581
15096	5183	447	942701
15097	5022	448	\N
15098	5022	449	\N
15099	5105	448	\N
15100	5105	449	\N
15101	5105	450	\N
15102	5105	451	\N
15103	5184	448	\N
15104	5184	449	\N
15105	5022	452	216349
15106	5105	452	555278
15107	5023	453	201264
15108	5023	454	659700
15109	5023	455	165654
15110	5106	454	891929
15111	5024	457	\N
15112	5024	458	\N
15113	5107	457	\N
15114	5107	458	\N
15115	5185	456	\N
15116	5185	458	\N
15117	5024	459	178489
15118	5024	460	376441
15119	5024	461	790040
15120	5107	459	490134
15121	5185	459	847938
15122	5025	462	789601
15123	5186	462	167059
15124	5187	463	\N
15125	5187	464	\N
15126	5187	466	\N
15127	5108	467	356546
15128	5187	467	821291
15129	5026	468	\N
15130	5026	470	\N
15131	5026	471	\N
15132	5026	472	\N
15133	5109	468	\N
15134	5188	468	\N
15135	5188	469	\N
15136	5109	474	154937
15137	5027	475	\N
15138	5027	476	\N
15139	5110	475	\N
15140	5189	475	\N
15141	5189	477	\N
15142	5027	479	945726
15143	5027	480	582500
15144	5027	482	349175
15145	5189	478	923709
15146	5190	483	\N
15147	5190	484	\N
15148	5028	486	441165
15149	5028	487	109372
15150	5028	488	465739
15151	5028	490	201777
15152	5028	491	280927
15153	5190	485	649768
15154	5190	486	967754
15155	5190	487	145778
15156	5029	492	\N
15157	5111	492	\N
15158	5191	492	\N
15159	5191	493	\N
15160	5030	494	\N
15161	5030	496	\N
15162	5030	497	\N
15163	5030	498	\N
15164	5112	494	\N
15165	5112	499	972213
15166	5112	500	673099
15167	5112	501	614311
15168	5192	499	526341
15169	5031	502	\N
15170	5113	502	\N
15171	5113	503	\N
15172	5031	505	537961
15173	5031	506	521773
15174	5031	507	317039
15175	5031	508	312416
15176	5032	509	\N
15177	5032	510	\N
15178	5114	510	\N
15179	5032	511	885626
15180	5032	512	835976
15181	5032	513	719386
15182	5114	512	290858
15183	5114	514	309187
15184	5114	515	150704
15185	5033	516	\N
15186	5033	517	\N
15187	5033	518	\N
15188	5193	516	\N
15189	5193	517	\N
15190	5193	518	\N
15191	5115	519	500274
15192	5115	521	220368
15193	5115	522	308474
15194	5115	523	635987
15195	5193	519	582477
15196	5116	524	\N
15197	5116	526	\N
15198	5116	528	\N
15199	5194	524	\N
15200	5194	529	213861
15201	5034	530	\N
15202	5034	532	\N
15203	5117	530	\N
15204	5195	530	\N
15205	5195	534	834029
15206	5195	535	128235
15207	5195	537	208828
15208	5195	538	160181
15209	5035	539	\N
15210	5118	539	\N
15211	5035	541	233310
15212	5118	540	154478
15213	5118	541	986575
15214	5196	540	365813
15215	5197	542	\N
15216	5197	544	\N
15217	5197	546	\N
15218	5197	547	\N
15219	5197	548	\N
15220	5036	549	540234
15221	5036	550	593568
15222	5037	551	\N
15223	5198	551	\N
15224	5198	552	\N
15225	5037	553	985728
15226	5037	554	542596
15227	5119	554	700806
15228	5038	555	\N
15229	5038	556	\N
15230	5038	557	\N
15231	5038	558	\N
15232	5120	556	\N
15233	5120	557	\N
15234	5120	559	\N
15235	5038	560	743013
15236	5199	561	740660
15237	5199	562	378775
15238	5199	563	304752
15239	5039	564	\N
15240	5121	564	\N
15241	5039	565	693362
15242	5039	567	741083
15243	5039	568	918530
15244	5200	565	476901
15245	5040	569	\N
15246	5040	571	\N
15247	5040	572	\N
15248	5040	573	\N
15249	5122	570	\N
15250	5201	569	\N
15251	5201	570	\N
15252	5201	571	\N
15253	5040	574	387900
15254	5122	574	827768
15255	5123	575	\N
15256	5041	577	569199
15257	5041	578	650137
15258	5041	579	374856
15259	5041	580	275198
15260	5041	581	755946
15261	5123	576	377481
15262	5123	578	811596
15263	5202	576	833577
15264	5203	583	\N
15265	5203	584	\N
15266	5203	585	\N
15267	5042	587	\N
15268	5042	588	\N
15269	5042	589	330020
15270	5204	589	715997
15271	5205	590	\N
15272	5205	592	\N
15273	5124	594	561599
15274	5205	593	682670
15275	5205	594	309738
15276	5205	595	780124
15277	5206	597	\N
15278	5206	598	\N
15279	5206	599	\N
15280	5043	600	471726
15281	5044	601	\N
15282	5044	603	\N
15283	5207	602	\N
15284	5207	603	\N
15285	5207	604	\N
15286	5207	606	\N
15287	5044	607	589503
15288	5207	607	408427
15289	5208	608	\N
15290	5208	610	\N
15291	5208	611	\N
15292	5208	612	925468
15293	5208	613	615989
15294	5125	615	\N
15295	5125	617	\N
15296	5125	618	\N
15297	5209	614	\N
15298	5045	619	\N
15299	5045	620	\N
15300	5126	619	\N
15301	5126	620	\N
15302	5126	621	\N
15303	5126	622	\N
15304	5045	624	130386
15305	5045	626	341422
15306	5126	624	174932
15307	5046	627	\N
15308	5046	628	\N
15309	5210	628	\N
15310	5210	629	\N
15311	5210	630	\N
15312	5047	631	\N
15313	5047	632	\N
15314	5047	633	\N
15315	5047	634	575756
15316	5047	635	995147
15317	5048	636	\N
15318	5127	636	\N
15319	5211	637	\N
15320	5211	639	\N
15321	5211	640	\N
15322	5211	641	\N
15323	5211	643	\N
15324	5048	644	918964
15325	5048	645	612615
15326	5049	647	\N
15327	5049	648	\N
15328	5049	649	\N
15329	5049	650	\N
15330	5049	651	880976
15331	5128	652	476419
15332	5212	651	981402
15333	5050	653	\N
15334	5050	655	\N
15335	5129	654	\N
15336	5129	656	\N
15337	5129	657	\N
15338	5050	658	475729
15339	5213	658	240015
15340	5213	660	296014
15341	5213	662	761983
15342	5213	663	709101
15343	5213	665	348678
15344	5130	666	\N
15345	5130	667	\N
15346	5130	668	\N
15347	5214	670	235155
15348	5214	671	196418
15349	5215	672	\N
15350	5051	673	599851
15351	5051	674	177897
15352	5131	675	\N
15353	5216	675	\N
15354	5216	676	\N
15355	5216	677	\N
15356	5131	678	361498
15357	5131	680	262704
15358	5052	682	\N
15359	5132	681	\N
15360	5132	682	\N
15361	5132	683	\N
15362	5052	684	253443
15363	5052	685	716157
15364	5052	686	438978
15365	5052	688	488649
15366	5053	689	\N
15367	5133	690	\N
15368	5133	691	\N
15369	5217	689	\N
15370	5217	690	\N
15371	5217	692	487925
15372	5217	693	162790
15373	5217	695	398260
15374	5054	696	\N
15375	5218	696	\N
15376	5134	697	645174
15377	5134	698	379868
15378	5055	699	\N
15379	5055	701	\N
15380	5135	699	\N
15381	5135	700	\N
15382	5135	702	\N
15383	5135	703	\N
15384	5056	705	\N
15385	5136	704	\N
15386	5136	705	\N
15387	5136	706	\N
15388	5056	707	101971
15389	5056	709	445368
15390	5056	710	616120
15391	5056	711	852300
15392	5136	708	864162
15393	5219	707	664578
15394	5057	712	412831
15395	5137	712	731097
15396	5137	713	751076
15397	5137	714	485681
15398	5138	715	\N
15399	5138	716	\N
15400	5058	718	390370
15401	5058	720	234910
15402	5058	721	218138
15403	5058	722	146606
15404	5058	723	667118
15405	5220	717	417653
15406	5059	724	\N
15407	5059	725	\N
15408	5139	724	\N
15409	5059	727	483843
15410	5139	727	704409
15411	5139	728	729076
15412	5139	729	544933
15413	5060	730	\N
15414	5060	732	\N
15415	5060	733	\N
15416	5060	735	\N
15417	5140	730	\N
15418	5140	731	\N
15419	5140	732	\N
15420	5060	736	308871
15421	5061	737	\N
15422	5061	739	\N
15423	5221	737	\N
15424	5141	740	322328
15425	5221	740	695565
15426	5142	741	\N
15427	5142	742	924688
15428	5142	743	894836
15429	5142	744	927501
15430	5143	746	\N
15431	5222	745	\N
15432	5143	747	779251
15433	5143	749	600113
15434	5143	750	399641
15435	5062	751	\N
15436	5062	752	\N
15437	5062	753	\N
15438	5144	752	\N
15439	5144	753	\N
15440	5223	751	\N
15441	5062	755	652630
15442	5223	754	168817
15443	5063	756	\N
15444	5063	757	\N
15445	5063	758	\N
15446	5063	759	\N
15447	5063	760	\N
15448	5224	756	\N
15449	5224	758	\N
15450	5145	761	264085
15451	5064	762	\N
15452	5064	763	\N
15453	5146	764	549159
15454	5225	764	686803
15455	5225	765	272232
15456	5225	766	285590
15457	5225	767	138478
15458	5225	768	364886
15459	5065	769	\N
15460	5065	770	861854
15461	5147	771	\N
15462	5066	772	568055
15463	5147	772	605196
15464	5147	773	326262
15465	5147	774	335645
15466	5067	775	\N
15467	5226	775	\N
15468	5067	777	379612
15469	5148	776	624493
15470	5148	778	785615
15471	5148	780	846076
15472	5148	782	518622
15473	5148	783	478356
15474	5226	776	531288
15475	5226	777	902839
15476	5226	778	827120
15477	5149	784	\N
15478	5227	784	\N
15479	5068	786	250544
15480	5227	785	656563
15481	5227	787	357993
15482	5069	788	\N
15483	5069	790	\N
15484	5228	789	\N
15485	5069	792	365731
15486	5150	792	839440
15487	5151	793	\N
15488	5151	795	\N
15489	5151	796	\N
15490	5229	793	\N
15491	5070	797	373281
15492	5070	798	423944
15493	5151	798	533852
15494	5229	797	778683
15495	5230	799	\N
15496	5071	801	708553
15497	5071	803	852484
15498	5071	804	476193
15499	5152	800	540311
15500	5230	800	873871
15501	5230	801	839418
15502	5072	805	\N
15503	5153	806	\N
15504	5231	805	\N
15505	5072	807	270150
15506	5073	808	\N
15507	5154	808	\N
15508	5154	809	\N
15509	5232	808	\N
15510	5232	809	\N
15511	5232	811	\N
15512	5232	813	349503
15513	5155	814	296174
15514	5155	815	153046
15515	5155	816	666893
15516	5233	814	834800
15517	5233	815	635032
15518	5074	817	\N
15519	5234	817	\N
15520	5074	818	895759
15521	5074	819	126385
15522	5074	820	937571
15523	5075	821	\N
15524	5075	823	\N
15525	5156	821	\N
15526	5156	823	\N
15527	5235	821	\N
15528	5235	823	\N
15529	5235	824	\N
15530	5235	825	\N
15531	5075	826	692925
15532	5075	827	246940
15533	5157	828	\N
15534	5076	829	513791
15535	5076	830	608034
15536	5076	832	153382
15537	5076	833	653292
15538	5157	829	645340
15539	5236	829	209904
15540	5236	830	662303
15541	5236	831	234218
15542	5237	834	\N
15543	5077	835	734592
15544	5077	836	429569
15545	5237	835	920831
15546	5237	836	693825
15547	5078	837	\N
15548	5078	839	\N
15549	5158	838	\N
15550	5158	839	\N
15551	5238	837	\N
15552	5238	838	\N
15553	5078	840	811985
15554	5078	841	137387
15555	5078	842	799826
15556	5158	840	415873
15557	5238	840	994056
15558	5239	844	\N
15559	5079	846	213913
15560	5159	845	495487
15561	5159	846	703401
15562	5159	847	731838
15563	5239	845	833950
15564	5080	849	\N
15565	5160	849	\N
15566	5160	850	\N
15567	5240	848	\N
15568	5240	849	\N
15569	5240	850	\N
15570	5080	851	687519
15571	5080	853	192314
15572	5080	854	850201
15573	5160	851	953804
15574	5160	852	460395
15575	5160	853	124847
15576	5240	852	413210
15577	5240	853	122644
15578	5081	855	\N
15579	5241	855	\N
15580	5241	856	\N
15581	5241	857	\N
15582	5081	858	281983
15583	5241	858	754396
15584	5241	859	904480
15585	5161	860	\N
15586	5242	860	\N
15587	5161	861	635076
15588	5161	862	612108
15589	5161	863	729337
15590	5161	864	466423
15591	5082	865	\N
15592	5082	866	\N
15593	5162	867	280438
15594	5162	868	848796
15595	5162	869	823272
15596	5083	871	881227
15597	5163	871	277910
15598	5163	872	934643
15599	5163	873	653904
15600	5163	874	898643
15601	5084	875	\N
15602	5084	876	\N
15603	5084	877	\N
15604	5084	878	\N
15605	5164	879	590350
15606	5164	880	627281
15607	5085	882	\N
15608	5165	881	\N
15609	5165	882	\N
15610	5165	883	\N
15611	5165	884	\N
15612	5243	882	\N
15613	5243	883	\N
15614	5085	885	193422
15615	5085	887	575509
15616	5085	889	701661
15617	5165	885	221732
15618	5243	885	755207
15619	5086	891	\N
15620	5166	890	\N
15621	5166	891	\N
15622	5166	892	\N
15623	5166	893	868474
15624	5166	894	913512
15625	5244	893	324717
15626	5244	894	908967
15627	5244	896	556687
15628	5244	897	887623
15629	5244	898	224447
15630	5087	900	\N
15631	5087	901	\N
15632	5245	902	474194
15633	5246	903	\N
15634	5246	905	\N
15635	5088	906	343675
15636	5088	907	925409
15637	5088	909	987003
15638	5167	906	998533
15639	5167	908	486926
15640	5167	909	664338
15641	5089	911	\N
15642	5089	912	\N
15643	5089	913	\N
15644	5089	914	\N
15645	5168	910	\N
15646	5168	911	\N
15647	5168	913	\N
15648	5247	910	\N
15649	5247	911	\N
15650	5168	916	918588
15651	5247	916	518221
15652	5247	917	219642
15653	5247	919	681373
15654	5169	921	\N
15655	5090	922	485130
15656	5090	923	676887
15657	5090	924	309225
15658	5090	926	965049
15659	5248	922	253499
15660	5248	924	367458
15661	5091	927	721450
15662	5091	929	384831
15663	5170	928	117457
15664	5170	930	392084
15665	5170	932	902234
15666	5170	933	723378
15667	5170	934	270286
15668	5249	927	716279
15669	5249	928	306529
15670	5092	935	\N
15671	5092	936	\N
15672	5171	935	\N
15673	5092	937	108262
15674	5171	938	947887
15675	5250	938	428257
15676	5093	939	\N
15677	5172	939	\N
15678	5093	941	998612
15679	5093	942	875817
15680	5172	940	121925
15681	5251	940	315688
15682	5251	942	167840
15683	5251	944	942681
15684	5251	946	680530
15685	5251	947	368236
15686	5094	948	\N
15687	5094	950	\N
15688	5252	949	\N
15689	5252	950	\N
15690	5252	951	\N
15691	5252	952	\N
15692	5173	954	414196
15693	5173	955	414748
15694	5095	956	\N
15695	5095	957	\N
15696	5095	958	\N
15697	5174	956	\N
15698	5095	959	355833
15699	5174	959	834619
15700	5174	960	858429
15701	5096	961	\N
15702	5096	962	\N
15703	5253	962	\N
15704	5253	963	\N
15705	5253	964	\N
15706	5253	965	212300
15707	5097	966	\N
15708	5097	967	\N
15709	5097	969	\N
15710	5097	971	\N
15711	5175	966	\N
15712	5254	966	\N
15713	5254	967	\N
15714	5254	968	\N
15715	5254	970	\N
15716	5254	971	\N
15717	5176	972	\N
15718	5176	974	\N
15719	5176	975	\N
15720	5255	973	\N
15721	5255	976	149813
15722	5255	978	765090
15723	5255	980	856704
15724	5098	981	\N
15725	5098	982	\N
15726	5098	984	\N
15727	5256	981	\N
15728	5256	982	\N
15729	5098	985	324826
15730	5099	986	\N
15731	5177	987	\N
15732	5177	988	\N
15733	5177	989	549001
15734	5100	990	\N
15735	5178	991	\N
15736	5178	993	\N
15737	5257	990	\N
15738	5178	994	515697
15739	5178	995	809894
15740	5257	994	137096
15741	5257	995	858190
15742	5257	997	912709
15743	5257	998	131821
15744	5101	999	\N
15745	5101	1000	\N
15746	5101	1001	\N
15747	5101	1002	\N
15748	5101	1003	\N
15749	5179	1000	\N
15750	5258	999	\N
15751	5179	1005	354287
15752	5258	1004	900787
15753	5259	1006	378228
15754	5259	1007	168616
15755	5102	1008	\N
15756	5180	1010	691174
15757	5260	1011	\N
15758	5260	1012	557414
15759	5260	1013	859080
15760	5260	1014	457607
15761	5260	1015	254015
15762	5261	1016	\N
15763	5261	1017	\N
15764	5261	1018	994447
15765	5262	1019	517639
15766	5262	1020	818436
15767	5262	1021	853947
15768	5262	1022	745006
15769	5262	1023	672138
15770	5263	1024	\N
15771	5263	1025	\N
15772	5264	1027	\N
15773	5264	1028	936759
15774	5264	1029	486299
15775	5264	1030	724812
15776	5264	1031	313430
15777	5265	1032	189527
15778	5265	1034	813670
15779	5312	1032	833783
15780	5312	1033	270824
15781	5312	1034	350466
15782	5312	1035	664059
15783	5266	1037	\N
15784	5313	1036	\N
15785	5313	1037	\N
15786	5313	1038	\N
15787	5266	1039	850320
15788	5266	1041	628063
15789	5266	1042	209886
15790	5266	1043	174020
15791	5314	1044	\N
15792	5314	1045	\N
15793	5314	1046	852114
15794	5267	1047	\N
15795	5315	1048	\N
15796	5315	1049	\N
15797	5268	1051	\N
15798	5268	1052	\N
15799	5268	1053	\N
15800	5316	1050	\N
15801	5269	1054	\N
15802	5269	1055	\N
15803	5317	1054	\N
15804	5269	1056	525976
15805	5269	1057	163931
15806	5317	1056	824354
15807	5317	1057	365649
15808	5317	1058	664539
15809	5317	1059	777819
15810	5270	1061	746612
15811	5318	1060	165149
15812	5318	1061	931278
15813	5318	1062	363212
15814	5318	1063	830962
15815	5318	1064	821827
15816	5271	1066	\N
15817	5271	1067	\N
15818	5319	1065	\N
15819	5271	1068	203413
15820	5319	1068	986603
15821	5319	1069	180241
15822	5319	1070	570367
15823	5272	1071	\N
15824	5320	1073	738271
15825	5273	1074	\N
15826	5273	1076	\N
15827	5273	1077	\N
15828	5273	1078	\N
15829	5273	1080	\N
15830	5274	1081	\N
15831	5274	1083	\N
15832	5274	1084	\N
15833	5321	1081	\N
15834	5321	1083	\N
15835	5275	1085	\N
15836	5275	1087	\N
15837	5276	1089	\N
15838	5276	1090	\N
15839	5276	1091	\N
15840	5276	1092	\N
15841	5322	1088	\N
15842	5322	1089	\N
15843	5277	1093	\N
15844	5323	1093	\N
15845	5323	1095	\N
15846	5323	1096	\N
15847	5323	1098	\N
15848	5277	1099	107517
15849	5278	1100	480928
15850	5324	1100	345065
15851	5324	1101	183988
15852	5324	1102	397018
15853	5324	1103	220105
15854	5279	1104	\N
15855	5279	1105	\N
15856	5325	1107	850594
15857	5326	1108	\N
15858	5280	1109	559204
15859	5280	1110	338398
15860	5280	1112	727958
15861	5280	1113	301746
15862	5326	1110	163126
15863	5281	1115	\N
15864	5281	1116	\N
15865	5281	1117	\N
15866	5327	1114	\N
15867	5327	1115	\N
15868	5327	1116	\N
15869	5282	1118	\N
15870	5282	1119	\N
15871	5282	1120	\N
15872	5328	1118	\N
15873	5328	1119	\N
15874	5282	1121	371196
15875	5328	1122	330922
15876	5328	1123	294157
15877	5329	1125	\N
15878	5283	1127	310177
15879	5283	1128	925657
15880	5283	1129	183159
15881	5283	1130	675783
15882	5329	1126	599991
15883	5329	1128	654572
15884	5330	1132	\N
15885	5330	1133	\N
15886	5284	1135	620932
15887	5331	1136	\N
15888	5331	1138	\N
15889	5331	1140	\N
15890	5331	1142	\N
15891	5285	1143	202929
15892	5286	1144	\N
15893	5286	1145	\N
15894	5332	1144	\N
15895	5332	1145	\N
15896	5286	1146	805357
15897	5286	1147	267382
15898	5286	1148	398777
15899	5287	1149	435910
15900	5333	1149	205356
15901	5333	1150	927161
15902	5334	1151	\N
15903	5334	1152	\N
15904	5334	1154	\N
15905	5288	1155	989928
15906	5288	1157	652014
15907	5288	1158	174253
15908	5288	1159	530043
15909	5288	1160	709402
15910	5334	1155	461700
15911	5334	1156	433459
15912	5289	1162	\N
15913	5289	1163	\N
15914	5289	1164	\N
15915	5335	1161	\N
15916	5335	1162	\N
15917	5335	1163	\N
15918	5289	1165	425518
15919	5289	1167	349654
15920	5336	1168	\N
15921	5336	1169	\N
15922	5336	1171	\N
15923	5336	1172	\N
15924	5336	1173	\N
15925	5290	1174	\N
15926	5290	1175	\N
15927	5291	1176	\N
15928	5337	1177	\N
15929	5337	1178	\N
15930	5291	1179	443451
15931	5337	1179	305542
15932	5337	1180	919069
15933	5338	1182	823537
15934	5292	1183	\N
15935	5292	1185	\N
15936	5292	1187	\N
15937	5339	1183	\N
15938	5339	1184	\N
15939	5339	1188	982366
15940	5339	1189	740212
15941	5339	1191	448689
15942	5293	1192	670711
15943	5294	1194	\N
15944	5340	1193	\N
15945	5294	1196	147377
15946	5294	1197	408904
15947	5294	1198	780265
15948	5294	1199	380227
15949	5295	1200	\N
15950	5295	1202	\N
15951	5295	1203	\N
15952	5341	1200	\N
15953	5341	1204	499776
15954	5296	1205	\N
15955	5296	1206	\N
15956	5296	1208	\N
15957	5342	1205	\N
15958	5342	1206	\N
15959	5342	1209	308320
15960	5342	1210	751667
15961	5342	1211	841410
15962	5297	1212	\N
15963	5297	1213	\N
15964	5343	1212	\N
15965	5297	1214	540803
15966	5297	1215	156300
15967	5298	1216	\N
15968	5298	1217	\N
15969	5298	1218	\N
15970	5298	1219	\N
15971	5344	1216	\N
15972	5344	1217	\N
15973	5298	1221	727320
15974	5345	1222	\N
15975	5345	1223	\N
15976	5345	1224	\N
15977	5345	1225	\N
15978	5346	1227	\N
15979	5299	1228	305750
15980	5299	1229	420180
15981	5299	1230	932454
15982	5299	1232	727360
15983	5346	1228	930829
15984	5300	1233	812816
15985	5301	1234	\N
15986	5301	1235	\N
15987	5301	1236	\N
15988	5301	1237	\N
15989	5301	1238	\N
15990	5347	1234	\N
15991	5302	1239	655078
15992	5303	1241	\N
15993	5304	1242	\N
15994	5304	1243	\N
15995	5348	1242	\N
15996	5348	1243	\N
15997	5348	1244	\N
15998	5348	1245	\N
15999	5304	1246	793002
16000	5304	1248	457119
16001	5305	1249	\N
16002	5305	1250	\N
16003	5305	1252	\N
16004	5305	1253	\N
16005	5349	1255	956268
16006	5349	1256	499836
16007	5349	1257	568232
16008	5349	1258	777932
16009	5349	1259	124927
16010	5306	1260	\N
16011	5306	1261	\N
16012	5306	1262	\N
16013	5350	1260	\N
16014	5350	1263	275691
16015	5307	1265	\N
16016	5307	1266	\N
16017	5307	1268	\N
16018	5307	1269	\N
16019	5351	1270	890739
16020	5351	1271	994369
16021	5352	1273	\N
16022	5352	1274	\N
16023	5352	1275	\N
16024	5352	1276	\N
16025	5308	1277	171013
16026	5308	1278	553210
16027	5309	1279	\N
16028	5353	1279	\N
16029	5353	1281	\N
16030	5353	1282	\N
16031	5354	1284	\N
16032	5354	1286	\N
16033	5354	1287	\N
16034	5354	1288	453180
16035	5310	1289	651738
16036	5355	1289	246584
16037	5355	1290	264979
16038	5311	1291	\N
16039	5356	1291	\N
16040	5311	1293	595482
16041	5357	1294	\N
16042	5357	1296	\N
16043	5357	1297	\N
16044	5357	1299	\N
16045	5358	1300	\N
16046	5358	1301	394671
16047	5359	1302	671815
16048	5360	1303	\N
16049	5360	1304	\N
16050	5360	1305	\N
16051	5361	1306	\N
16052	5362	1307	\N
16053	5362	1309	\N
16054	5362	1310	853831
16055	5363	1311	583721
16056	5363	1312	576072
16057	5363	1313	966244
16058	5364	1314	429144
16059	5364	1315	481692
16060	5365	1316	\N
16061	5365	1318	\N
16062	5365	1319	489915
16063	5366	1320	\N
16064	5366	1321	\N
16065	5366	1323	\N
16066	5367	1324	\N
16067	5367	1326	\N
16068	5368	1327	\N
16069	5368	1329	\N
16070	5368	1330	818364
16071	5369	1331	\N
16072	5369	1332	324418
16073	5369	1333	414254
16074	5370	1334	\N
16075	5370	1335	\N
16076	5370	1336	\N
16077	5370	1337	\N
16078	5370	1338	432896
16079	5371	1339	\N
16080	5371	1340	\N
16081	5371	1341	374532
16082	5371	1342	543439
16083	5372	1343	503148
16084	5373	1344	\N
16085	5373	1345	419231
16086	5373	1346	278269
16087	5373	1347	129712
16088	5373	1348	894032
16089	5374	1350	910829
16090	5374	1351	824919
16091	5374	1352	126823
16092	5374	1353	850263
16093	5375	1355	362567
16094	5375	1357	607550
16095	5376	1358	446779
16096	5377	1360	245180
16097	5378	1361	178242
16098	5378	1362	528077
16099	5378	1363	713524
16100	5379	1365	\N
16101	5379	1366	\N
16102	5379	1367	\N
16103	5379	1368	\N
16104	5380	1369	402633
16105	5380	1370	608286
16106	5381	1371	430391
16107	5382	1372	\N
16108	5382	1373	\N
16109	5382	1375	\N
16110	5383	1376	\N
16111	5383	1377	\N
16112	5383	1379	700253
16113	5383	1381	631448
16114	5383	1383	996804
16115	5384	1384	900453
16116	5384	1385	962363
16117	5385	1387	\N
16118	5385	1388	\N
16119	5385	1389	\N
16120	5386	1390	\N
16121	5386	1391	\N
16122	5386	1393	\N
16123	5386	1395	\N
16124	5386	1396	\N
16125	5387	1397	\N
16126	5387	1398	\N
16127	5387	1400	469052
16128	5388	1401	\N
16129	5388	1402	\N
16130	5389	1403	125464
16131	5390	1405	\N
16132	5390	1407	\N
16133	5499	1405	\N
16134	5499	1406	\N
16135	5390	1408	622999
16136	5390	1409	789266
16137	5390	1410	410554
16138	5465	1409	142783
16139	5465	1410	188312
16140	5499	1408	209225
16141	5499	1409	418610
16142	5499	1410	873842
16143	5466	1411	\N
16144	5500	1411	\N
16145	5466	1412	533018
16146	5466	1414	122016
16147	5466	1415	747394
16148	5466	1416	160798
16149	5500	1412	180478
16150	5500	1413	771534
16151	5500	1415	529203
16152	5391	1417	\N
16153	5391	1418	\N
16154	5391	1419	\N
16155	5501	1417	\N
16156	5501	1420	689807
16157	5501	1421	575253
16158	5501	1422	115286
16159	5392	1423	\N
16160	5392	1425	\N
16161	5467	1423	\N
16162	5467	1424	\N
16163	5502	1423	\N
16164	5467	1426	269371
16165	5467	1428	364918
16166	5468	1429	\N
16167	5468	1430	\N
16168	5468	1431	464218
16169	5468	1433	191535
16170	5393	1434	573610
16171	5393	1436	401234
16172	5503	1434	831107
16173	5394	1438	\N
16174	5469	1437	\N
16175	5469	1439	\N
16176	5469	1440	\N
16177	5469	1441	\N
16178	5504	1437	\N
16179	5394	1442	626648
16180	5394	1443	543171
16181	5469	1442	315253
16182	5395	1444	\N
16183	5395	1446	\N
16184	5395	1448	\N
16185	5470	1444	\N
16186	5470	1449	611337
16187	5470	1450	763408
16188	5470	1451	958791
16189	5470	1452	278584
16190	5505	1449	717876
16191	5505	1450	435137
16192	5471	1453	\N
16193	5471	1454	\N
16194	5506	1453	\N
16195	5506	1454	\N
16196	5506	1455	\N
16197	5396	1456	332387
16198	5396	1458	615259
16199	5396	1459	840548
16200	5396	1461	716511
16201	5472	1462	\N
16202	5472	1464	\N
16203	5472	1465	\N
16204	5472	1466	\N
16205	5397	1467	462364
16206	5397	1468	441717
16207	5397	1469	895306
16208	5397	1470	605851
16209	5472	1467	691546
16210	5507	1467	488222
16211	5507	1468	415946
16212	5507	1470	863853
16213	5398	1471	\N
16214	5508	1471	\N
16215	5398	1473	215137
16216	5508	1472	679115
16217	5473	1474	\N
16218	5473	1475	\N
16219	5509	1474	\N
16220	5509	1475	\N
16221	5509	1476	\N
16222	5509	1477	\N
16223	5399	1478	401082
16224	5399	1479	361583
16225	5473	1479	718817
16226	5400	1481	\N
16227	5400	1483	\N
16228	5400	1484	\N
16229	5400	1486	\N
16230	5510	1481	\N
16231	5510	1482	\N
16232	5474	1487	265726
16233	5474	1489	355182
16234	5510	1487	943576
16235	5401	1490	\N
16236	5401	1491	\N
16237	5401	1492	\N
16238	5475	1490	\N
16239	5475	1491	\N
16240	5475	1492	\N
16241	5511	1491	\N
16242	5511	1492	\N
16243	5511	1494	\N
16244	5511	1495	\N
16245	5401	1496	367453
16246	5401	1497	173254
16247	5475	1496	951414
16248	5511	1496	811237
16249	5402	1499	\N
16250	5402	1500	\N
16251	5402	1501	635174
16252	5402	1502	321436
16253	5476	1501	123136
16254	5476	1502	685929
16255	5403	1503	\N
16256	5403	1504	\N
16257	5512	1504	\N
16258	5512	1505	\N
16259	5512	1506	\N
16260	5512	1508	\N
16261	5477	1509	502308
16262	5477	1510	633213
16263	5512	1509	815942
16264	5404	1512	\N
16265	5404	1513	\N
16266	5478	1512	\N
16267	5478	1513	\N
16268	5478	1515	\N
16269	5478	1516	\N
16270	5478	1518	\N
16271	5513	1511	\N
16272	5513	1513	\N
16273	5513	1515	\N
16274	5404	1519	881536
16275	5404	1520	751737
16276	5404	1521	689258
16277	5513	1519	731456
16278	5405	1522	\N
16279	5514	1522	\N
16280	5514	1523	\N
16281	5514	1524	800248
16282	5406	1525	\N
16283	5515	1526	651005
16284	5407	1527	\N
16285	5516	1528	\N
16286	5516	1529	\N
16287	5516	1530	\N
16288	5407	1531	409793
16289	5407	1532	368584
16290	5407	1533	565706
16291	5479	1531	854635
16292	5479	1532	412322
16293	5516	1531	555991
16294	5516	1532	515013
16295	5408	1534	\N
16296	5480	1534	\N
16297	5480	1536	\N
16298	5517	1535	\N
16299	5408	1538	203943
16300	5517	1537	751131
16301	5517	1538	288044
16302	5517	1539	452774
16303	5409	1540	\N
16304	5409	1541	\N
16305	5409	1542	636343
16306	5481	1542	994029
16307	5481	1544	391223
16308	5481	1546	472480
16309	5481	1548	749421
16310	5410	1549	\N
16311	5410	1550	\N
16312	5410	1551	\N
16313	5410	1552	\N
16314	5410	1554	\N
16315	5518	1549	\N
16316	5482	1556	122718
16317	5482	1557	907270
16318	5518	1555	191889
16319	5483	1558	\N
16320	5483	1559	\N
16321	5411	1560	916481
16322	5483	1560	511713
16323	5483	1561	724840
16324	5519	1560	820357
16325	5412	1563	\N
16326	5412	1564	\N
16327	5412	1565	\N
16328	5412	1566	\N
16329	5484	1563	\N
16330	5484	1565	\N
16331	5520	1562	\N
16332	5520	1563	\N
16333	5413	1567	\N
16334	5413	1568	\N
16335	5413	1569	400628
16336	5413	1570	208342
16337	5413	1571	585938
16338	5485	1569	948691
16339	5521	1569	222380
16340	5486	1572	\N
16341	5486	1573	\N
16342	5486	1574	\N
16343	5522	1575	934085
16344	5487	1576	\N
16345	5487	1577	\N
16346	5523	1576	\N
16347	5523	1577	\N
16348	5523	1578	\N
16349	5414	1579	667821
16350	5414	1580	965411
16351	5487	1579	981180
16352	5487	1580	886886
16353	5488	1581	\N
16354	5488	1582	\N
16355	5415	1584	791908
16356	5415	1585	896321
16357	5488	1583	352453
16358	5416	1587	\N
16359	5524	1586	\N
16360	5524	1587	\N
16361	5524	1588	\N
16362	5524	1589	\N
16363	5416	1590	354387
16364	5489	1590	570361
16365	5489	1592	820104
16366	5489	1594	317734
16367	5489	1595	738362
16368	5489	1597	163014
16369	5417	1598	\N
16370	5417	1599	\N
16371	5417	1600	\N
16372	5417	1601	\N
16373	5490	1599	\N
16374	5490	1601	\N
16375	5525	1598	\N
16376	5525	1600	\N
16377	5525	1601	\N
16378	5525	1602	\N
16379	5525	1603	\N
16380	5490	1604	231792
16381	5490	1605	567736
16382	5491	1607	\N
16383	5418	1608	735917
16384	5418	1609	845682
16385	5491	1609	552741
16386	5419	1610	\N
16387	5526	1610	\N
16388	5492	1611	316952
16389	5492	1612	389350
16390	5492	1613	708404
16391	5526	1612	747291
16392	5420	1615	\N
16393	5420	1616	\N
16394	5493	1615	\N
16395	5493	1616	\N
16396	5493	1618	\N
16397	5527	1615	\N
16398	5527	1617	\N
16399	5420	1619	287931
16400	5421	1620	\N
16401	5494	1621	\N
16402	5421	1622	922802
16403	5494	1622	186643
16404	5494	1624	686443
16405	5528	1622	523723
16406	5529	1625	\N
16407	5529	1626	\N
16408	5529	1627	\N
16409	5529	1628	\N
16410	5529	1630	\N
16411	5422	1631	711449
16412	5422	1633	309043
16413	5422	1635	605091
16414	5495	1636	\N
16415	5495	1637	\N
16416	5495	1638	\N
16417	5495	1639	\N
16418	5495	1641	\N
16419	5530	1636	\N
16420	5530	1637	\N
16421	5530	1638	\N
16422	5530	1640	\N
16423	5530	1643	471871
16424	5496	1645	\N
16425	5423	1647	613636
16426	5423	1648	214587
16427	5423	1650	370081
16428	5496	1646	262707
16429	5496	1647	796551
16430	5496	1648	345870
16431	5531	1646	104804
16432	5497	1651	\N
16433	5532	1651	\N
16434	5532	1652	\N
16435	5532	1653	\N
16436	5532	1654	\N
16437	5532	1656	\N
16438	5424	1657	136094
16439	5424	1658	532526
16440	5497	1657	210065
16441	5497	1658	968316
16442	5425	1659	\N
16443	5425	1660	\N
16444	5425	1662	\N
16445	5498	1659	\N
16446	5498	1660	\N
16447	5426	1663	\N
16448	5426	1664	\N
16449	5426	1665	\N
16450	5426	1666	\N
16451	5533	1668	546750
16452	5533	1670	598860
16453	5533	1671	771743
16454	5533	1672	801575
16455	5533	1673	684832
16456	5427	1675	\N
16457	5427	1676	\N
16458	5534	1674	\N
16459	5427	1677	144390
16460	5427	1678	568377
16461	5427	1680	636615
16462	5534	1678	687656
16463	5428	1681	\N
16464	5428	1682	\N
16465	5428	1683	673835
16466	5428	1684	998194
16467	5535	1683	873419
16468	5536	1685	\N
16469	5536	1687	980785
16470	5536	1688	180813
16471	5536	1689	757594
16472	5536	1690	297514
16473	5429	1691	\N
16474	5429	1692	\N
16475	5429	1694	\N
16476	5429	1695	\N
16477	5537	1691	\N
16478	5537	1692	\N
16479	5537	1693	\N
16480	5537	1696	470743
16481	5430	1698	\N
16482	5538	1700	461619
16483	5538	1701	177560
16484	5538	1702	830466
16485	5431	1703	\N
16486	5431	1704	229024
16487	5539	1704	720012
16488	5539	1706	759892
16489	5539	1708	113914
16490	5540	1709	\N
16491	5540	1711	380662
16492	5540	1712	297656
16493	5432	1713	\N
16494	5432	1714	593748
16495	5432	1715	497492
16496	5432	1716	495280
16497	5541	1714	936628
16498	5541	1715	802100
16499	5541	1716	478573
16500	5541	1717	651029
16501	5433	1718	\N
16502	5433	1719	\N
16503	5433	1721	\N
16504	5542	1718	\N
16505	5542	1719	\N
16506	5542	1720	\N
16507	5434	1722	454737
16508	5543	1722	983690
16509	5543	1723	478726
16510	5543	1724	429732
16511	5543	1725	852633
16512	5435	1727	469818
16513	5544	1726	247104
16514	5544	1727	671976
16515	5544	1729	350118
16516	5436	1730	\N
16517	5436	1732	\N
16518	5436	1733	\N
16519	5545	1731	\N
16520	5545	1732	\N
16521	5545	1734	\N
16522	5545	1735	\N
16523	5436	1736	338296
16524	5436	1737	232558
16525	5545	1736	359755
16526	5546	1738	465126
16527	5437	1740	\N
16528	5547	1740	\N
16529	5547	1742	\N
16530	5437	1743	424252
16531	5547	1744	609518
16532	5438	1745	\N
16533	5438	1747	\N
16534	5438	1749	723100
16535	5548	1748	146955
16536	5439	1750	\N
16537	5549	1750	\N
16538	5549	1751	\N
16539	5439	1753	267897
16540	5439	1755	295577
16541	5550	1756	\N
16542	5440	1757	735426
16543	5440	1759	387597
16544	5440	1760	552067
16545	5551	1762	356221
16546	5552	1763	\N
16547	5441	1764	237527
16548	5441	1765	704608
16549	5552	1764	630957
16550	5552	1766	250257
16551	5552	1768	370654
16552	5552	1769	950217
16553	5442	1770	\N
16554	5553	1771	\N
16555	5553	1773	\N
16556	5553	1774	\N
16557	5443	1776	\N
16558	5443	1777	\N
16559	5554	1775	\N
16560	5554	1777	\N
16561	5554	1778	\N
16562	5443	1779	840942
16563	5554	1779	720273
16564	5444	1781	\N
16565	5444	1782	\N
16566	5555	1781	\N
16567	5555	1782	\N
16568	5444	1784	429618
16569	5555	1783	297652
16570	5556	1785	\N
16571	5556	1787	\N
16572	5556	1789	\N
16573	5556	1791	\N
16574	5556	1793	\N
16575	5445	1795	\N
16576	5557	1794	\N
16577	5557	1795	\N
16578	5446	1796	\N
16579	5558	1797	\N
16580	5558	1798	\N
16581	5447	1799	\N
16582	5447	1800	\N
16583	5447	1801	\N
16584	5447	1802	\N
16585	5448	1803	\N
16586	5448	1805	\N
16587	5448	1806	\N
16588	5449	1808	\N
16589	5559	1807	\N
16590	5449	1809	700480
16591	5450	1810	280246
16592	5450	1811	480387
16593	5450	1812	197309
16594	5560	1810	725216
16595	5560	1811	564030
16596	5561	1813	\N
16597	5561	1814	\N
16598	5561	1815	\N
16599	5451	1816	\N
16600	5451	1817	\N
16601	5451	1818	\N
16602	5562	1816	\N
16603	5562	1818	\N
16604	5562	1819	\N
16605	5562	1821	\N
16606	5562	1822	841611
16607	5452	1823	\N
16608	5452	1824	\N
16609	5452	1825	\N
16610	5452	1826	472990
16611	5453	1828	\N
16612	5453	1829	570801
16613	5563	1829	635425
16614	5563	1830	350062
16615	5454	1831	\N
16616	5454	1832	491604
16617	5564	1832	303380
16618	5564	1834	950670
16619	5455	1835	338460
16620	5456	1836	\N
16621	5456	1837	\N
16622	5456	1839	\N
16623	5456	1840	433739
16624	5565	1841	107462
16625	5566	1843	\N
16626	5566	1844	\N
16627	5566	1845	\N
16628	5457	1846	421149
16629	5457	1847	157854
16630	5457	1848	408850
16631	5457	1850	354538
16632	5457	1851	676487
16633	5458	1852	\N
16634	5458	1853	\N
16635	5458	1855	845177
16636	5458	1856	976061
16637	5567	1854	314436
16638	5567	1855	699830
16639	5459	1857	\N
16640	5459	1858	281240
16641	5459	1859	402245
16642	5460	1860	351679
16643	5568	1860	217546
16644	5568	1862	610395
16645	5461	1863	419412
16646	5461	1864	351788
16647	5461	1866	230152
16648	5461	1867	639424
16649	5569	1863	642873
16650	5462	1868	470086
16651	5462	1870	384977
16652	5463	1871	\N
16653	5463	1872	\N
16654	5463	1873	\N
16655	5463	1874	\N
16656	5463	1875	\N
16657	5464	1876	996368
16658	5643	1878	\N
16659	5643	1879	\N
16660	5570	1881	852969
16661	5570	1882	776784
16662	5570	1883	714312
16663	5570	1885	613343
16664	5571	1887	\N
16665	5644	1886	\N
16666	5644	1889	388603
16667	5572	1890	355948
16668	5573	1891	\N
16669	5573	1893	\N
16670	5645	1892	\N
16671	5645	1893	\N
16672	5645	1894	\N
16673	5645	1895	\N
16674	5645	1896	485824
16675	5574	1897	\N
16676	5574	1899	\N
16677	5574	1901	\N
16678	5574	1903	\N
16679	5646	1897	\N
16680	5574	1904	522971
16681	5646	1905	803756
16682	5646	1906	168077
16683	5646	1907	621019
16684	5646	1908	335307
16685	5575	1910	\N
16686	5575	1911	\N
16687	5575	1912	376689
16688	5647	1913	139706
16689	5648	1915	\N
16690	5648	1916	\N
16691	5576	1918	121169
16692	5649	1919	\N
16693	5649	1920	\N
16694	5577	1921	562266
16695	5577	1923	516385
16696	5649	1921	610161
16697	5650	1924	\N
16698	5650	1925	591050
16699	5578	1926	\N
16700	5578	1927	\N
16701	5578	1928	978921
16702	5578	1930	402382
16703	5651	1931	169379
16704	5652	1933	\N
16705	5652	1934	\N
16706	5652	1935	799346
16707	5653	1936	\N
16708	5653	1937	\N
16709	5653	1939	\N
16710	5579	1941	300906
16711	5579	1942	464482
16712	5653	1940	989555
16713	5580	1943	\N
16714	5580	1945	\N
16715	5580	1946	\N
16716	5580	1947	\N
16717	5580	1948	206865
16718	5654	1948	504349
16719	5654	1950	342166
16720	5581	1951	\N
16721	5581	1953	\N
16722	5655	1951	\N
16723	5655	1952	\N
16724	5656	1955	\N
16725	5656	1956	\N
16726	5656	1957	\N
16727	5656	1958	\N
16728	5656	1960	341381
16729	5657	1962	\N
16730	5657	1963	\N
16731	5657	1964	\N
16732	5582	1965	447704
16733	5582	1966	368661
16734	5657	1966	351811
16735	5657	1967	992588
16736	5658	1968	\N
16737	5659	1969	\N
16738	5659	1970	405978
16739	5659	1972	519630
16740	5659	1973	693999
16741	5659	1974	747781
16742	5583	1975	\N
16743	5583	1976	\N
16744	5583	1977	\N
16745	5660	1978	778268
16746	5584	1979	\N
16747	5585	1980	298985
16748	5585	1981	136511
16749	5585	1982	294057
16750	5585	1983	825986
16751	5585	1984	229814
16752	5586	1985	\N
16753	5586	1986	\N
16754	5661	1985	\N
16755	5661	1986	\N
16756	5661	1987	\N
16757	5661	1988	\N
16758	5586	1989	519242
16759	5586	1990	913715
16760	5661	1989	626407
16761	5587	1991	\N
16762	5587	1992	\N
16763	5587	1993	596946
16764	5662	1993	386599
16765	5662	1995	913703
16766	5588	1996	\N
16767	5663	1996	\N
16768	5663	1997	\N
16769	5664	1998	137709
16770	5664	1999	992196
16771	5664	0	703786
16772	5664	1	871514
16773	5664	3	216167
16774	5589	4	\N
16775	5665	4	\N
16776	5589	6	423376
16777	5666	7	\N
16778	5666	9	\N
16779	5666	10	\N
16780	5590	12	686808
16781	5590	13	709559
16782	5590	14	908551
16783	5666	11	261123
16784	5591	16	\N
16785	5591	17	\N
16786	5592	18	101000
16787	5667	18	677418
16788	5667	19	210709
16789	5667	20	512575
16790	5593	21	\N
16791	5593	22	\N
16792	5593	24	\N
16793	5593	25	120436
16794	5668	26	304297
16795	5668	27	146151
16796	5668	28	848932
16797	5669	29	\N
16798	5669	30	\N
16799	5594	31	938678
16800	5595	32	\N
16801	5670	32	\N
16802	5670	33	\N
16803	5596	34	\N
16804	5596	35	\N
16805	5671	34	\N
16806	5671	36	511401
16807	5672	37	\N
16808	5597	38	446957
16809	5597	39	634461
16810	5597	41	738676
16811	5672	38	367878
16812	5598	43	\N
16813	5598	45	243967
16814	5598	46	414156
16815	5599	48	\N
16816	5599	49	\N
16817	5599	50	143164
16818	5599	51	764876
16819	5600	53	\N
16820	5600	55	\N
16821	5673	52	\N
16822	5673	53	\N
16823	5673	54	\N
16824	5673	55	\N
16825	5673	56	144559
16826	5674	58	\N
16827	5601	59	\N
16828	5601	60	\N
16829	5601	61	\N
16830	5601	62	\N
16831	5602	63	\N
16832	5602	64	\N
16833	5602	65	\N
16834	5675	63	\N
16835	5602	66	530863
16836	5675	67	671445
16837	5675	69	529827
16838	5675	70	263286
16839	5603	71	\N
16840	5603	72	\N
16841	5676	71	\N
16842	5603	73	216442
16843	5603	75	263232
16844	5603	76	555232
16845	5604	78	\N
16846	5677	78	\N
16847	5677	79	\N
16848	5604	80	281110
16849	5605	82	\N
16850	5678	82	\N
16851	5678	83	\N
16852	5678	84	\N
16853	5605	85	480226
16854	5606	86	\N
16855	5606	87	633112
16856	5679	88	\N
16857	5679	90	\N
16858	5679	92	\N
16859	5607	93	202797
16860	5607	95	775817
16861	5680	96	\N
16862	5680	98	413541
16863	5608	99	\N
16864	5608	101	\N
16865	5681	99	\N
16866	5681	102	426232
16867	5681	104	641061
16868	5681	105	932991
16869	5682	106	\N
16870	5609	107	164210
16871	5610	108	249699
16872	5610	109	219911
16873	5610	110	419921
16874	5610	111	133003
16875	5683	109	185976
16876	5683	110	416693
16877	5683	111	461810
16878	5611	112	\N
16879	5611	114	\N
16880	5684	112	\N
16881	5684	113	\N
16882	5684	114	\N
16883	5684	115	\N
16884	5684	116	\N
16885	5611	118	604697
16886	5611	119	644912
16887	5685	121	\N
16888	5685	123	\N
16889	5685	124	\N
16890	5685	125	\N
16891	5685	126	\N
16892	5612	128	\N
16893	5612	130	\N
16894	5612	131	\N
16895	5612	132	\N
16896	5686	133	298866
16897	5687	134	\N
16898	5687	136	566819
16899	5688	137	879258
16900	5689	138	\N
16901	5689	140	\N
16902	5689	142	\N
16903	5689	144	\N
16904	5689	145	624589
16905	5613	147	\N
16906	5690	149	212157
16907	5690	150	644244
16908	5690	151	722459
16909	5614	152	\N
16910	5614	154	\N
16911	5614	156	572174
16912	5614	157	398994
16913	5691	155	380396
16914	5615	158	\N
16915	5692	158	\N
16916	5692	159	\N
16917	5692	160	\N
16918	5616	162	\N
16919	5616	163	\N
16920	5616	164	\N
16921	5693	161	\N
16922	5616	165	251634
16923	5616	166	232203
16924	5693	165	336175
16925	5693	166	213052
16926	5617	168	\N
16927	5694	168	\N
16928	5694	169	\N
16929	5694	170	\N
16930	5617	172	499892
16931	5694	171	831466
16932	5694	172	951623
16933	5618	173	\N
16934	5618	174	311313
16935	5618	175	196891
16936	5695	174	314131
16937	5695	175	786269
16938	5695	176	967995
16939	5696	177	\N
16940	5696	178	\N
16941	5696	179	813379
16942	5696	180	891003
16943	5697	181	\N
16944	5697	182	\N
16945	5697	183	\N
16946	5697	184	958123
16947	5697	185	511793
16948	5698	186	\N
16949	5698	187	\N
16950	5619	188	945248
16951	5620	189	\N
16952	5620	190	\N
16953	5699	189	\N
16954	5699	190	\N
16955	5699	191	\N
16956	5699	192	\N
16957	5621	193	\N
16958	5700	194	\N
16959	5621	195	315996
16960	5621	197	730688
16961	5621	198	719130
16962	5621	200	679258
16963	5701	202	967246
16964	5702	203	\N
16965	5702	205	\N
16966	5622	207	990084
16967	5622	208	331133
16968	5702	206	885858
16969	5702	207	493553
16970	5702	209	223603
16971	5623	210	\N
16972	5623	211	\N
16973	5623	212	\N
16974	5623	213	\N
16975	5623	215	\N
16976	5703	216	225496
16977	5624	218	\N
16978	5624	220	\N
16979	5624	221	\N
16980	5624	222	\N
16981	5704	217	\N
16982	5704	218	\N
16983	5704	223	163988
16984	5704	224	448214
16985	5704	225	304201
16986	5705	226	\N
16987	5706	227	\N
16988	5706	229	\N
16989	5706	230	387209
16990	5625	231	770081
16991	5625	233	621548
16992	5625	234	747320
16993	5625	235	769117
16994	5707	232	617319
16995	5626	236	\N
16996	5626	238	\N
16997	5626	239	\N
16998	5626	240	959384
16999	5708	240	795876
17000	5708	241	900639
17001	5627	242	\N
17002	5709	242	\N
17003	5627	243	891513
17004	5709	243	768497
17005	5709	244	154952
17006	5709	245	737894
17007	5709	247	241845
17008	5628	248	\N
17009	5628	249	\N
17010	5710	248	\N
17011	5628	250	323555
17012	5628	252	264412
17013	5628	254	501830
17014	5710	250	172734
17015	5710	251	613183
17016	5629	256	\N
17017	5711	255	\N
17018	5711	257	\N
17019	5629	258	379610
17020	5629	260	202951
17021	5711	258	469811
17022	5711	260	283154
17023	5711	261	420998
17024	5630	262	\N
17025	5630	263	511625
17026	5630	264	424283
17027	5630	265	853498
17028	5630	266	117188
17029	5712	267	\N
17030	5712	268	\N
17031	5631	269	565001
17032	5631	270	233920
17033	5631	271	530681
17034	5712	269	143855
17035	5712	271	860353
17036	5632	272	\N
17037	5713	272	\N
17038	5713	273	\N
17039	5713	274	\N
17040	5632	275	602073
17041	5714	276	\N
17042	5714	277	\N
17043	5633	278	885438
17044	5634	279	\N
17045	5634	280	\N
17046	5634	281	\N
17047	5634	282	\N
17048	5715	279	\N
17049	5715	280	\N
17050	5715	281	\N
17051	5715	284	768576
17052	5635	285	\N
17053	5635	286	\N
17054	5716	285	\N
17055	5636	287	\N
17056	5636	289	859602
17057	5717	288	345599
17058	5637	290	946284
17059	5637	292	945620
17060	5637	293	873055
17061	5637	295	859944
17062	5637	296	121244
17063	5718	290	804866
17064	5718	291	134321
17065	5718	292	469337
17066	5638	297	\N
17067	5638	299	\N
17068	5638	300	\N
17069	5719	301	828502
17070	5639	302	587776
17071	5639	303	835274
17072	5639	304	271170
17073	5640	305	\N
17074	5720	306	\N
17075	5720	307	\N
17076	5720	309	\N
17077	5720	310	\N
17078	5720	311	\N
17079	5640	312	959518
17080	5641	314	\N
17081	5641	315	\N
17082	5641	316	\N
17083	5641	317	\N
17084	5641	318	\N
17085	5721	313	\N
17086	5721	319	426749
17087	5721	320	163474
17088	5721	321	336473
17089	5642	322	\N
17090	5642	323	\N
17091	5642	324	\N
17092	5722	322	\N
17093	5722	323	\N
17094	5642	325	564425
17095	5722	325	834431
17096	5722	326	557911
17097	5723	327	396962
17098	5723	328	357093
17099	5875	328	174063
17100	5875	329	330486
17101	5724	331	\N
17102	5724	332	\N
17103	5724	333	\N
17104	5805	330	\N
17105	5805	331	\N
17106	5876	330	\N
17107	5876	331	\N
17108	5724	334	556643
17109	5805	335	434991
17110	5876	334	623488
17111	5725	337	\N
17112	5725	338	\N
17113	5725	339	\N
17114	5806	336	\N
17115	5806	337	\N
17116	5806	338	\N
17117	5806	339	\N
17118	5806	341	\N
17119	5877	336	\N
17120	5877	337	\N
17121	5877	338	\N
17122	5877	339	\N
17123	5725	342	518220
17124	5726	343	\N
17125	5726	344	\N
17126	5726	345	\N
17127	5726	346	\N
17128	5726	348	\N
17129	5807	343	\N
17130	5807	344	\N
17131	5878	343	\N
17132	5878	345	\N
17133	5878	347	\N
17134	5878	348	\N
17135	5808	349	473162
17136	5808	350	686420
17137	5808	352	849204
17138	5727	354	\N
17139	5727	355	\N
17140	5727	356	\N
17141	5727	357	\N
17142	5727	358	135923
17143	5809	359	585205
17144	5728	360	\N
17145	5728	361	\N
17146	5810	360	\N
17147	5728	362	724794
17148	5810	362	379447
17149	5810	363	862999
17150	5879	362	911659
17151	5879	363	923560
17152	5729	364	\N
17153	5729	365	\N
17154	5811	365	\N
17155	5811	366	\N
17156	5811	367	\N
17157	5880	365	\N
17158	5880	366	\N
17159	5880	367	\N
17160	5729	368	593148
17161	5729	370	406840
17162	5881	372	\N
17163	5730	374	157844
17164	5730	376	824035
17165	5730	378	647296
17166	5881	373	486033
17167	5881	375	661833
17168	5731	380	637600
17169	5812	379	139856
17170	5812	380	517209
17171	5732	381	\N
17172	5732	382	977961
17173	5732	383	832214
17174	5813	382	145029
17175	5733	384	\N
17176	5733	385	\N
17177	5814	384	\N
17178	5882	384	\N
17179	5882	385	\N
17180	5882	386	144710
17181	5882	387	534556
17182	5882	388	803976
17183	5883	389	\N
17184	5883	390	\N
17185	5734	391	434178
17186	5883	391	518279
17187	5735	392	\N
17188	5735	393	\N
17189	5735	395	\N
17190	5735	396	\N
17191	5815	392	\N
17192	5815	393	\N
17193	5884	392	\N
17194	5736	398	\N
17195	5816	397	\N
17196	5816	399	\N
17197	5816	401	\N
17198	5885	398	\N
17199	5885	400	\N
17200	5885	401	\N
17201	5885	402	521013
17202	5737	403	\N
17203	5737	404	\N
17204	5737	406	\N
17205	5737	407	\N
17206	5817	404	\N
17207	5817	405	\N
17208	5886	404	\N
17209	5817	408	762402
17210	5817	410	215378
17211	5817	411	475651
17212	5886	408	453692
17213	5886	409	124187
17214	5886	410	495904
17215	5886	411	316130
17216	5738	413	\N
17217	5738	414	\N
17218	5738	415	\N
17219	5738	416	\N
17220	5738	418	\N
17221	5818	413	\N
17222	5818	414	\N
17223	5818	415	\N
17224	5818	416	\N
17225	5739	419	\N
17226	5739	420	\N
17227	5739	421	\N
17228	5739	422	\N
17229	5819	423	469587
17230	5819	425	649435
17231	5819	426	510327
17232	5819	427	437991
17233	5887	424	551413
17234	5740	429	\N
17235	5740	431	\N
17236	5740	432	\N
17237	5820	428	\N
17238	5820	430	\N
17239	5820	431	\N
17240	5740	433	812669
17241	5888	434	825146
17242	5888	436	844672
17243	5821	437	\N
17244	5889	438	\N
17245	5741	439	791752
17246	5741	440	623634
17247	5741	442	177280
17248	5741	443	198776
17249	5821	439	921530
17250	5822	445	\N
17251	5822	446	\N
17252	5890	444	\N
17253	5890	445	\N
17254	5742	447	485585
17255	5742	449	118377
17256	5742	451	769660
17257	5742	452	515590
17258	5742	453	170054
17259	5822	447	945600
17260	5822	449	597753
17261	5743	454	\N
17262	5743	455	\N
17263	5743	457	\N
17264	5823	454	\N
17265	5743	458	679098
17266	5891	459	354443
17267	5891	460	605518
17268	5892	461	\N
17269	5892	462	\N
17270	5892	463	684431
17271	5892	465	151256
17272	5892	466	160321
17273	5744	468	\N
17274	5824	468	\N
17275	5824	469	\N
17276	5824	470	824833
17277	5824	472	414301
17278	5745	474	\N
17279	5745	475	\N
17280	5893	473	\N
17281	5893	474	\N
17282	5893	476	\N
17283	5893	477	\N
17284	5893	479	\N
17285	5825	480	\N
17286	5825	481	\N
17287	5894	480	\N
17288	5894	481	\N
17289	5894	483	520548
17290	5894	484	843493
17291	5894	485	712207
17292	5826	486	548902
17293	5826	487	495800
17294	5826	488	727452
17295	5895	489	\N
17296	5895	490	\N
17297	5895	491	\N
17298	5746	493	513687
17299	5827	493	732899
17300	5827	495	820451
17301	5895	492	223569
17302	5747	497	\N
17303	5828	496	\N
17304	5828	497	\N
17305	5828	498	174132
17306	5828	499	144352
17307	5896	499	571951
17308	5896	500	434119
17309	5896	501	530277
17310	5896	502	381539
17311	5829	503	506891
17312	5829	504	970963
17313	5897	503	378536
17314	5748	505	\N
17315	5748	506	797349
17316	5830	506	804133
17317	5898	506	592683
17318	5899	507	\N
17319	5899	508	\N
17320	5899	509	\N
17321	5899	511	\N
17322	5831	513	579373
17323	5831	515	186626
17324	5831	517	826015
17325	5749	518	\N
17326	5749	519	\N
17327	5749	521	\N
17328	5749	522	\N
17329	5749	523	\N
17330	5832	519	\N
17331	5832	520	\N
17332	5832	522	\N
17333	5900	518	\N
17334	5901	524	\N
17335	5901	525	\N
17336	5901	526	\N
17337	5750	527	411219
17338	5833	528	\N
17339	5902	529	\N
17340	5902	530	\N
17341	5751	531	406101
17342	5902	531	201026
17343	5752	532	\N
17344	5752	533	\N
17345	5903	532	\N
17346	5752	534	302033
17347	5753	535	\N
17348	5834	536	\N
17349	5834	537	\N
17350	5904	535	\N
17351	5753	538	494884
17352	5753	539	750109
17353	5834	539	739641
17354	5835	541	\N
17355	5905	541	\N
17356	5754	543	908088
17357	5754	544	396874
17358	5754	545	278589
17359	5754	546	457292
17360	5835	543	207517
17361	5755	547	\N
17362	5755	548	\N
17363	5906	547	\N
17364	5906	548	\N
17365	5836	550	228797
17366	5836	551	949104
17367	5906	549	869658
17368	5837	552	\N
17369	5907	552	\N
17370	5837	553	175478
17371	5907	553	528145
17372	5907	554	915589
17373	5756	556	\N
17374	5908	555	\N
17375	5908	556	\N
17376	5908	558	\N
17377	5756	559	979694
17378	5756	560	860424
17379	5756	561	809156
17380	5756	562	829003
17381	5838	559	156538
17382	5908	559	476683
17383	5757	563	\N
17384	5839	563	\N
17385	5839	565	\N
17386	5839	567	\N
17387	5839	568	\N
17388	5839	569	\N
17389	5757	570	109117
17390	5757	571	942974
17391	5840	572	\N
17392	5909	573	948993
17393	5909	575	451901
17394	5841	576	\N
17395	5841	577	286245
17396	5841	578	569904
17397	5910	577	514960
17398	5910	578	260851
17399	5910	579	699243
17400	5910	581	816226
17401	5910	582	926445
17402	5842	584	\N
17403	5911	583	\N
17404	5911	584	\N
17405	5758	585	972783
17406	5843	586	\N
17407	5912	586	\N
17408	5912	587	\N
17409	5912	588	\N
17410	5912	589	\N
17411	5759	590	992969
17412	5843	590	754098
17413	5843	592	953178
17414	5843	593	617844
17415	5760	594	\N
17416	5844	594	\N
17417	5913	594	\N
17418	5844	595	679559
17419	5913	596	972304
17420	5913	597	659355
17421	5845	598	\N
17422	5914	598	\N
17423	5914	599	\N
17424	5845	600	798098
17425	5845	601	795864
17426	5845	602	448175
17427	5914	600	272212
17428	5846	603	\N
17429	5846	604	\N
17430	5915	603	\N
17431	5915	605	\N
17432	5915	606	526143
17433	5915	607	128730
17434	5915	609	987773
17435	5761	610	\N
17436	5761	611	\N
17437	5916	610	\N
17438	5916	612	\N
17439	5761	613	782115
17440	5761	614	393578
17441	5761	615	430808
17442	5917	616	\N
17443	5917	618	\N
17444	5762	620	734057
17445	5762	621	778452
17446	5762	623	962124
17447	5762	624	818966
17448	5917	619	302281
17449	5917	621	258073
17450	5917	622	219042
17451	5847	625	\N
17452	5847	626	\N
17453	5847	627	\N
17454	5847	628	\N
17455	5847	629	590726
17456	5763	631	\N
17457	5763	632	\N
17458	5848	630	\N
17459	5848	631	\N
17460	5848	633	509058
17461	5848	634	407180
17462	5848	635	482525
17463	5918	633	959750
17464	5918	634	884414
17465	5918	636	303040
17466	5918	637	588130
17467	5849	638	\N
17468	5919	639	\N
17469	5764	640	953774
17470	5764	641	356788
17471	5764	642	393140
17472	5765	643	\N
17473	5765	644	\N
17474	5765	645	\N
17475	5920	643	\N
17476	5920	644	\N
17477	5921	646	\N
17478	5921	648	\N
17479	5921	649	\N
17480	5921	651	\N
17481	5766	652	877764
17482	5766	653	263169
17483	5766	654	990687
17484	5850	652	163421
17485	5850	653	640881
17486	5850	655	725151
17487	5850	657	797242
17488	5850	658	890379
17489	5921	653	420504
17490	5851	659	\N
17491	5851	660	\N
17492	5922	659	\N
17493	5767	661	308323
17494	5767	663	320128
17495	5851	661	606698
17496	5851	663	944054
17497	5851	664	231064
17498	5922	661	443654
17499	5922	662	452590
17500	5852	665	\N
17501	5852	666	\N
17502	5852	667	\N
17503	5923	665	\N
17504	5852	669	163807
17505	5852	670	717348
17506	5923	668	197727
17507	5923	669	482354
17508	5923	671	134483
17509	5923	672	473250
17510	5924	674	\N
17511	5768	676	731867
17512	5768	677	622057
17513	5768	678	743345
17514	5853	680	\N
17515	5925	679	\N
17516	5769	681	124129
17517	5769	682	968579
17518	5853	682	111694
17519	5853	683	118172
17520	5853	684	207922
17521	5925	681	372336
17522	5925	682	517027
17523	5854	686	867640
17524	5854	688	955608
17525	5854	689	842734
17526	5854	690	437019
17527	5855	691	\N
17528	5770	692	170328
17529	5770	694	806134
17530	5770	695	538395
17531	5770	696	921102
17532	5855	692	290168
17533	5926	692	708389
17534	5926	694	946069
17535	5926	695	304794
17536	5926	696	343855
17537	5926	697	440748
17538	5771	699	\N
17539	5856	698	\N
17540	5772	701	\N
17541	5772	703	\N
17542	5857	700	\N
17543	5857	702	\N
17544	5927	700	\N
17545	5927	701	\N
17546	5927	704	177059
17547	5858	706	\N
17548	5773	707	491509
17549	5858	707	574506
17550	5858	708	558440
17551	5858	709	590608
17552	5858	710	893019
17553	5928	707	503442
17554	5928	708	489165
17555	5928	710	429997
17556	5859	711	\N
17557	5859	712	\N
17558	5859	713	\N
17559	5929	711	\N
17560	5859	714	367412
17561	5859	715	615801
17562	5929	714	118746
17563	5860	717	\N
17564	5774	719	575503
17565	5774	720	514817
17566	5860	718	104762
17567	5860	719	622070
17568	5860	721	555741
17569	5930	718	948176
17570	5775	722	\N
17571	5775	723	\N
17572	5775	725	\N
17573	5861	723	\N
17574	5861	724	\N
17575	5861	725	\N
17576	5931	723	\N
17577	5775	727	485289
17578	5931	727	713045
17579	5776	728	192321
17580	5776	729	702758
17581	5776	730	471043
17582	5776	731	163983
17583	5862	728	823859
17584	5862	729	491053
17585	5862	730	497345
17586	5862	732	591815
17587	5862	733	856344
17588	5863	735	\N
17589	5863	736	\N
17590	5863	737	\N
17591	5932	734	\N
17592	5932	735	\N
17593	5932	736	\N
17594	5932	737	\N
17595	5932	738	\N
17596	5777	739	225143
17597	5778	740	\N
17598	5778	741	272239
17599	5778	742	544838
17600	5778	743	337731
17601	5864	741	342999
17602	5933	741	895613
17603	5933	743	567935
17604	5865	744	524139
17605	5934	745	146219
17606	5935	746	\N
17607	5935	748	\N
17608	5779	749	216191
17609	5779	750	213702
17610	5779	751	690074
17611	5779	752	628527
17612	5779	753	595970
17613	5866	749	591364
17614	5866	750	258034
17615	5866	751	283364
17616	5935	749	541749
17617	5780	754	\N
17618	5867	754	\N
17619	5867	755	\N
17620	5936	755	\N
17621	5936	756	\N
17622	5780	758	349957
17623	5780	759	506333
17624	5780	760	390993
17625	5780	761	157258
17626	5868	762	\N
17627	5781	763	867771
17628	5781	764	212878
17629	5868	763	896691
17630	5868	765	345489
17631	5868	766	322442
17632	5868	767	315724
17633	5937	763	331916
17634	5937	765	610802
17635	5937	766	869078
17636	5782	768	\N
17637	5869	768	\N
17638	5869	769	\N
17639	5938	768	\N
17640	5938	769	\N
17641	5938	770	\N
17642	5938	771	\N
17643	5783	773	\N
17644	5783	774	\N
17645	5783	776	\N
17646	5870	772	\N
17647	5783	778	751087
17648	5870	778	591029
17649	5870	779	713453
17650	5939	777	428805
17651	5939	778	631456
17652	5940	780	\N
17653	5940	781	\N
17654	5784	782	803072
17655	5871	783	314880
17656	5871	784	309450
17657	5871	785	609322
17658	5940	783	591615
17659	5940	785	436269
17660	5785	786	285646
17661	5786	787	\N
17662	5786	788	\N
17663	5941	788	\N
17664	5941	789	\N
17665	5941	791	\N
17666	5872	792	423409
17667	5941	792	981757
17668	5787	793	\N
17669	5787	794	\N
17670	5787	795	\N
17671	5787	796	\N
17672	5873	793	\N
17673	5873	794	\N
17674	5873	795	\N
17675	5787	797	683706
17676	5873	797	730582
17677	5942	797	303601
17678	5942	799	452604
17679	5942	800	423578
17680	5788	801	\N
17681	5788	803	\N
17682	5874	802	\N
17683	5874	804	\N
17684	5943	801	\N
17685	5874	805	611150
17686	5943	806	967113
17687	5789	807	786164
17688	5789	808	867274
17689	5789	809	938082
17690	5944	807	763578
17691	5944	809	404771
17692	5944	810	508618
17693	5944	811	953455
17694	5790	812	958242
17695	5791	813	\N
17696	5791	814	637544
17697	5945	814	928275
17698	5792	815	\N
17699	5792	816	\N
17700	5792	817	\N
17701	5946	819	532451
17702	5793	820	584795
17703	5793	821	308509
17704	5793	822	161562
17705	5947	820	630913
17706	5794	823	\N
17707	5948	823	\N
17708	5794	824	337247
17709	5794	825	183856
17710	5949	826	\N
17711	5949	828	\N
17712	5795	829	100973
17713	5795	830	684680
17714	5795	831	365090
17715	5795	833	747693
17716	5795	834	547310
17717	5949	830	977596
17718	5949	831	916940
17719	5796	836	\N
17720	5796	837	935558
17721	5796	838	619250
17722	5796	839	315833
17723	5796	840	858465
17724	5950	837	148546
17725	5951	842	\N
17726	5951	843	\N
17727	5951	844	\N
17728	5797	845	292198
17729	5951	845	528649
17730	5951	847	922921
17731	5952	848	\N
17732	5952	849	\N
17733	5952	851	\N
17734	5952	852	\N
17735	5952	853	\N
17736	5798	854	150344
17737	5798	855	996082
17738	5798	856	146825
17739	5798	857	426461
17740	5798	859	377504
17741	5799	861	\N
17742	5799	863	\N
17743	5799	864	\N
17744	5799	865	\N
17745	5953	866	\N
17746	5800	867	996226
17747	5800	868	876269
17748	5800	869	781112
17749	5953	867	948131
17750	5801	870	\N
17751	5954	871	\N
17752	5954	872	\N
17753	5801	873	233324
17754	5801	874	346690
17755	5801	875	934801
17756	5801	877	425554
17757	5954	873	380801
17758	5955	878	\N
17759	5955	879	395803
17760	5955	880	747576
17761	5956	882	\N
17762	5956	883	\N
17763	5956	884	\N
17764	5802	886	636329
17765	5802	887	299229
17766	5956	885	962461
17767	5803	889	\N
17768	5803	891	\N
17769	5803	893	\N
17770	5803	894	\N
17771	5803	895	\N
17772	5957	897	695244
17773	5957	899	673295
17774	5957	900	834410
17775	5957	901	710083
17776	5957	902	644830
17777	5804	903	\N
17778	5804	904	\N
17779	5804	906	\N
17780	5804	907	\N
17781	5804	908	\N
17782	5958	903	\N
17783	5958	910	627847
17784	5958	912	416736
17785	5959	913	\N
17786	5959	914	\N
17787	6022	913	\N
17788	6022	915	999416
17789	5960	917	\N
17790	5960	919	\N
17791	5960	920	\N
17792	6023	916	\N
17793	6023	917	\N
17794	6023	919	\N
17795	5960	922	878325
17796	5960	923	897138
17797	5961	924	\N
17798	5961	925	\N
17799	6024	924	\N
17800	6024	925	\N
17801	6024	926	\N
17802	5961	927	794964
17803	5961	928	162891
17804	6024	927	594877
17805	6024	928	946855
17806	5962	929	\N
17807	5962	930	\N
17808	5962	931	875559
17809	6025	932	280473
17810	6025	933	742987
17811	6025	934	833873
17812	5963	935	\N
17813	5963	936	\N
17814	5963	937	\N
17815	6026	939	115644
17816	5964	940	948122
17817	6027	941	\N
17818	6027	943	\N
17819	5965	944	603054
17820	6027	944	301965
17821	6027	945	647659
17822	6028	946	778166
17823	6029	947	\N
17824	6029	948	557920
17825	6030	950	\N
17826	6030	951	\N
17827	5966	952	416072
17828	5966	953	615463
17829	5966	954	598016
17830	5966	955	393136
17831	6030	952	633544
17832	6030	953	383104
17833	6030	954	655549
17834	6031	956	909324
17835	6032	957	\N
17836	5967	958	697132
17837	5967	959	605078
17838	5967	961	465562
17839	6032	958	624037
17840	6032	960	578722
17841	6033	962	372075
17842	6033	963	891838
17843	5968	964	\N
17844	5968	965	\N
17845	5968	966	\N
17846	5968	967	\N
17847	6034	964	\N
17848	5969	968	\N
17849	5969	969	\N
17850	5969	970	\N
17851	5969	971	634672
17852	5969	972	278457
17853	5970	974	\N
17854	6035	973	\N
17855	6035	974	\N
17856	6035	975	\N
17857	6035	976	\N
17858	6035	978	\N
17859	5970	979	560877
17860	6036	980	\N
17861	6036	981	\N
17862	6036	982	\N
17863	6036	983	192699
17864	6036	984	240813
17865	5971	985	\N
17866	6037	985	\N
17867	6037	987	\N
17868	6037	988	\N
17869	5971	990	656034
17870	5972	992	\N
17871	5972	993	\N
17872	5972	995	\N
17873	6038	992	\N
17874	6038	994	\N
17875	5972	997	902396
17876	5973	998	792993
17877	5973	1000	931101
17878	6039	998	475922
17879	6040	1001	\N
17880	6040	1002	\N
17881	6040	1004	\N
17882	5974	1005	\N
17883	5974	1006	\N
17884	5974	1008	386138
17885	5974	1009	324995
17886	5975	1010	\N
17887	5975	1012	\N
17888	5975	1013	\N
17889	6041	1011	\N
17890	6041	1013	\N
17891	5975	1014	431840
17892	5975	1015	702830
17893	6041	1014	162195
17894	5976	1016	\N
17895	5976	1017	\N
17896	5976	1018	\N
17897	5976	1019	\N
17898	5976	1020	\N
17899	6042	1022	650733
17900	5977	1023	\N
17901	5977	1024	\N
17902	6043	1023	\N
17903	6043	1024	\N
17904	6043	1025	\N
17905	6043	1027	\N
17906	5977	1028	490444
17907	5977	1030	212206
17908	5977	1031	704498
17909	6043	1029	158485
17910	5978	1033	\N
17911	5978	1035	\N
17912	5978	1036	935180
17913	6044	1037	293726
17914	5979	1039	932503
17915	5979	1040	944126
17916	5979	1042	871032
17917	5979	1043	824026
17918	5980	1045	311651
17919	6045	1047	\N
17920	6045	1048	\N
17921	6045	1049	\N
17922	6045	1051	\N
17923	5981	1052	770398
17924	5982	1054	\N
17925	6046	1054	\N
17926	6046	1055	\N
17927	6046	1057	\N
17928	5982	1058	362949
17929	6046	1058	435884
17930	5983	1059	\N
17931	6047	1059	\N
17932	5983	1060	269736
17933	5984	1062	\N
17934	5984	1063	\N
17935	6048	1061	\N
17936	6048	1063	\N
17937	6048	1064	\N
17938	6048	1065	693148
17939	5985	1066	\N
17940	5985	1067	\N
17941	5985	1068	\N
17942	6049	1070	\N
17943	5986	1071	628083
17944	5986	1072	233624
17945	5986	1073	453185
17946	5986	1074	936172
17947	5986	1075	381728
17948	6049	1071	410615
17949	6049	1072	845373
17950	6049	1073	996992
17951	6049	1075	890471
17952	5987	1077	\N
17953	6050	1076	\N
17954	5987	1078	771086
17955	5988	1079	\N
17956	5989	1080	\N
17957	5989	1081	\N
17958	5989	1082	\N
17959	6051	1081	\N
17960	6051	1082	\N
17961	6051	1083	\N
17962	5989	1084	630515
17963	5989	1086	422437
17964	6052	1087	\N
17965	6052	1088	\N
17966	6052	1089	\N
17967	5990	1090	418425
17968	5990	1091	559032
17969	5990	1092	366219
17970	5990	1093	502397
17971	6052	1091	523156
17972	6052	1092	965347
17973	6053	1094	378363
17974	6053	1095	413226
17975	6053	1096	953304
17976	6053	1097	605227
17977	6053	1098	317694
17978	5991	1099	\N
17979	6054	1099	\N
17980	5991	1100	382168
17981	5991	1102	552998
17982	5991	1103	176242
17983	5991	1104	432461
17984	5992	1105	\N
17985	6055	1106	527844
17986	6055	1107	756623
17987	6055	1108	840191
17988	6055	1109	834037
17989	6055	1110	173982
17990	5993	1111	\N
17991	5993	1112	158135
17992	5994	1113	\N
17993	6056	1114	\N
17994	6056	1115	\N
17995	5994	1117	178899
17996	5995	1118	\N
17997	5995	1119	\N
17998	5995	1121	\N
17999	5995	1123	\N
18000	5995	1125	\N
18001	6057	1126	565439
18002	6057	1127	656177
18003	6058	1128	\N
18004	6058	1130	\N
18005	5996	1132	\N
18006	5997	1133	\N
18007	5997	1135	\N
18008	6059	1133	\N
18009	6059	1136	509615
18010	5998	1137	\N
18011	5998	1138	\N
18012	6060	1138	\N
18013	5998	1139	608496
18014	6060	1139	901376
18015	5999	1141	\N
18016	6061	1142	\N
18017	6061	1143	\N
18018	6061	1145	\N
18019	6061	1147	\N
18020	6000	1148	499951
18021	6062	1149	208917
18022	6062	1150	665274
18023	6062	1151	277263
18024	6001	1152	\N
18025	6001	1154	\N
18026	6063	1152	\N
18027	6063	1153	\N
18028	6063	1154	\N
18029	6063	1155	\N
18030	6063	1156	\N
18031	6001	1157	276185
18032	6001	1158	688157
18033	6002	1159	\N
18034	6064	1159	\N
18035	6002	1160	184609
18036	6002	1161	953020
18037	6002	1162	103175
18038	6064	1161	544973
18039	6064	1162	179608
18040	6003	1163	\N
18041	6003	1165	\N
18042	6065	1166	317349
18043	6065	1167	250421
18044	6065	1168	231609
18045	6065	1169	642058
18046	6066	1170	\N
18047	6066	1172	\N
18048	6066	1173	297767
18049	6066	1174	451824
18050	6066	1175	142554
18051	6067	1176	\N
18052	6067	1177	\N
18053	6067	1178	\N
18054	6004	1179	320877
18055	6004	1181	826296
18056	6004	1182	249316
18057	6005	1183	\N
18058	6005	1184	\N
18059	6068	1184	\N
18060	6068	1185	\N
18061	6068	1186	\N
18062	6069	1187	\N
18063	6006	1189	\N
18064	6070	1189	\N
18065	6007	1191	\N
18066	6007	1193	\N
18067	6007	1194	\N
18068	6071	1190	\N
18069	6071	1192	\N
18070	6071	1193	\N
18071	6071	1194	\N
18072	6007	1195	692010
18073	6007	1196	621651
18074	6071	1195	688402
18075	6008	1197	\N
18076	6008	1198	\N
18077	6008	1199	\N
18078	6009	1200	\N
18079	6072	1200	\N
18080	6072	1201	938201
18081	6072	1203	198459
18082	6010	1204	\N
18083	6010	1206	\N
18084	6010	1207	\N
18085	6073	1205	\N
18086	6073	1208	318767
18087	6073	1209	122754
18088	6011	1210	\N
18089	6011	1211	\N
18090	6011	1212	\N
18091	6011	1213	259047
18092	6011	1214	849006
18093	6074	1216	\N
18094	6074	1217	\N
18095	6012	1218	534194
18096	6075	1220	\N
18097	6075	1221	457035
18098	6013	1223	\N
18099	6013	1225	\N
18100	6013	1227	\N
18101	6013	1229	\N
18102	6013	1231	235269
18103	6014	1232	919472
18104	6014	1233	389415
18105	6015	1234	\N
18106	6015	1236	\N
18107	6015	1237	393036
18108	6015	1238	559114
18109	6015	1239	137544
18110	6016	1240	\N
18111	6016	1241	\N
18112	6016	1242	\N
18113	6017	1243	473871
18114	6018	1244	\N
18115	6018	1245	\N
18116	6018	1246	\N
18117	6019	1247	\N
18118	6019	1248	\N
18119	6019	1249	\N
18120	6019	1251	466173
18121	6020	1252	\N
18122	6020	1253	\N
18123	6021	1254	\N
18124	6021	1255	\N
18125	6021	1256	663867
18126	6021	1258	631883
18127	6021	1259	996936
18128	6149	1260	\N
18129	6149	1261	\N
18130	6224	1260	\N
18131	6076	1262	656266
18132	6149	1262	143979
18133	6149	1263	526086
18134	6149	1265	213268
18135	6224	1263	785106
18136	6077	1266	\N
18137	6150	1267	\N
18138	6150	1269	\N
18139	6150	1271	430294
18140	6150	1272	928920
18141	6078	1274	\N
18142	6078	1276	\N
18143	6078	1277	\N
18144	6151	1273	\N
18145	6225	1273	\N
18146	6078	1279	570980
18147	6078	1280	693160
18148	6151	1278	950407
18149	6151	1279	874610
18150	6151	1280	825775
18151	6151	1282	505809
18152	6225	1278	674601
18153	6225	1279	654921
18154	6079	1283	\N
18155	6079	1284	\N
18156	6079	1286	\N
18157	6079	1287	\N
18158	6152	1283	\N
18159	6152	1284	\N
18160	6226	1289	123372
18161	6080	1290	\N
18162	6080	1291	967439
18163	6153	1292	556668
18164	6227	1291	241952
18165	6081	1293	\N
18166	6228	1293	\N
18167	6228	1294	\N
18168	6228	1296	\N
18169	6081	1297	394851
18170	6081	1298	578851
18171	6081	1299	127666
18172	6081	1301	170522
18173	6154	1297	101587
18174	6154	1299	949465
18175	6228	1297	726698
18176	6082	1302	\N
18177	6155	1303	367812
18178	6155	1304	161332
18179	6155	1305	474822
18180	6155	1306	952720
18181	6155	1307	408803
18182	6229	1303	863156
18183	6156	1308	\N
18184	6156	1309	\N
18185	6156	1311	\N
18186	6230	1308	\N
18187	6230	1309	\N
18188	6230	1310	\N
18189	6156	1313	869782
18190	6156	1315	380871
18191	6230	1312	383746
18192	6083	1316	\N
18193	6083	1317	\N
18194	6083	1319	\N
18195	6083	1321	\N
18196	6157	1316	\N
18197	6157	1317	\N
18198	6231	1316	\N
18199	6083	1322	864047
18200	6157	1322	955870
18201	6157	1323	598043
18202	6157	1324	127920
18203	6231	1322	300282
18204	6231	1323	126623
18205	6232	1325	\N
18206	6232	1326	\N
18207	6084	1327	188834
18208	6084	1329	503860
18209	6158	1327	180248
18210	6159	1331	\N
18211	6159	1333	\N
18212	6159	1335	\N
18213	6159	1337	\N
18214	6159	1338	\N
18215	6233	1330	\N
18216	6085	1339	764232
18217	6085	1340	416420
18218	6085	1341	513433
18219	6085	1342	410095
18220	6233	1339	277652
18221	6233	1340	549539
18222	6233	1341	291546
18223	6160	1343	\N
18224	6160	1344	762088
18225	6160	1345	622589
18226	6086	1347	\N
18227	6161	1348	173061
18228	6161	1349	649693
18229	6161	1350	224352
18230	6161	1351	588107
18231	6087	1352	\N
18232	6087	1353	\N
18233	6087	1354	\N
18234	6087	1355	\N
18235	6087	1357	\N
18236	6162	1353	\N
18237	6162	1354	\N
18238	6162	1355	\N
18239	6234	1353	\N
18240	6162	1358	280999
18241	6088	1359	\N
18242	6088	1360	\N
18243	6163	1359	\N
18244	6235	1359	\N
18245	6235	1360	\N
18246	6235	1362	357518
18247	6089	1364	\N
18248	6089	1365	\N
18249	6164	1363	\N
18250	6236	1364	\N
18251	6236	1365	\N
18252	6236	1366	\N
18253	6089	1367	145907
18254	6164	1367	951595
18255	6164	1368	269612
18256	6165	1369	\N
18257	6237	1369	\N
18258	6090	1371	294879
18259	6165	1370	365923
18260	6165	1371	520407
18261	6165	1372	868062
18262	6165	1373	537220
18263	6237	1370	519437
18264	6237	1372	134940
18265	6237	1373	851880
18266	6166	1375	\N
18267	6091	1376	394445
18268	6091	1377	690227
18269	6091	1378	339071
18270	6091	1379	590704
18271	6091	1381	100308
18272	6238	1376	856780
18273	6238	1378	740948
18274	6092	1383	910130
18275	6167	1382	591310
18276	6239	1382	970959
18277	6093	1384	\N
18278	6093	1385	\N
18279	6240	1384	\N
18280	6093	1386	140327
18281	6093	1388	541588
18282	6168	1386	658263
18283	6168	1387	364839
18284	6168	1388	825204
18285	6168	1389	885870
18286	6169	1390	\N
18287	6241	1390	\N
18288	6241	1391	\N
18289	6094	1393	697635
18290	6094	1394	553871
18291	6094	1395	425255
18292	6094	1396	139322
18293	6170	1397	\N
18294	6170	1398	\N
18295	6170	1399	\N
18296	6095	1400	642336
18297	6095	1402	538999
18298	6170	1400	999535
18299	6170	1401	368039
18300	6242	1400	187669
18301	6171	1403	\N
18302	6171	1404	\N
18303	6171	1405	\N
18304	6096	1406	619345
18305	6096	1407	121186
18306	6096	1408	777607
18307	6243	1406	962727
18308	6244	1409	\N
18309	6172	1410	835526
18310	6172	1412	858706
18311	6172	1413	353572
18312	6172	1414	809879
18313	6244	1410	966067
18314	6244	1411	777514
18315	6245	1415	\N
18316	6245	1416	\N
18317	6245	1417	\N
18318	6245	1419	\N
18319	6173	1420	829050
18320	6173	1421	476015
18321	6174	1422	\N
18322	6174	1424	\N
18323	6174	1426	\N
18324	6246	1422	\N
18325	6246	1423	\N
18326	6097	1427	915855
18327	6097	1428	114633
18328	6246	1427	149703
18329	6246	1429	379263
18330	6247	1431	\N
18331	6098	1432	690747
18332	6098	1433	587857
18333	6175	1432	538526
18334	6175	1434	508718
18335	6247	1433	288593
18336	6247	1434	752880
18337	6247	1435	399753
18338	6099	1436	123129
18339	6248	1437	\N
18340	6248	1439	\N
18341	6100	1441	985222
18342	6176	1441	548933
18343	6177	1443	\N
18344	6177	1444	\N
18345	6101	1446	743577
18346	6101	1447	263292
18347	6101	1448	166576
18348	6101	1449	299540
18349	6249	1445	477877
18350	6178	1451	\N
18351	6250	1451	\N
18352	6250	1452	\N
18353	6250	1454	\N
18354	6250	1455	130848
18355	6102	1456	578049
18356	6102	1458	646798
18357	6102	1460	741573
18358	6251	1457	846251
18359	6251	1459	316562
18360	6251	1461	664577
18361	6179	1462	\N
18362	6103	1463	476613
18363	6103	1465	813161
18364	6179	1463	162818
18365	6179	1465	471294
18366	6179	1467	539329
18367	6252	1464	459863
18368	6104	1468	\N
18369	6104	1469	\N
18370	6104	1470	\N
18371	6104	1471	\N
18372	6104	1472	620065
18373	6180	1472	835936
18374	6180	1474	473484
18375	6105	1475	\N
18376	6105	1476	808819
18377	6105	1477	907215
18378	6181	1476	830399
18379	6181	1477	771489
18380	6181	1478	887313
18381	6253	1476	392893
18382	6253	1477	643695
18383	6106	1479	\N
18384	6106	1480	\N
18385	6254	1480	\N
18386	6254	1481	\N
18387	6182	1482	155660
18388	6182	1484	919662
18389	6107	1485	\N
18390	6107	1487	\N
18391	6255	1485	\N
18392	6255	1486	\N
18393	6107	1488	458789
18394	6107	1489	294078
18395	6183	1488	305769
18396	6256	1491	\N
18397	6256	1493	\N
18398	6256	1494	\N
18399	6256	1496	\N
18400	6108	1497	947706
18401	6184	1497	607155
18402	6184	1498	930984
18403	6256	1497	655721
18404	6109	1499	\N
18405	6109	1500	\N
18406	6109	1502	\N
18407	6185	1499	\N
18408	6257	1499	\N
18409	6257	1501	\N
18410	6257	1502	\N
18411	6257	1503	\N
18412	6257	1504	\N
18413	6109	1506	881018
18414	6185	1505	777777
18415	6185	1506	331964
18416	6185	1507	545713
18417	6110	1509	\N
18418	6110	1510	\N
18419	6258	1509	\N
18420	6258	1510	\N
18421	6258	1512	\N
18422	6186	1513	197431
18423	6186	1514	848378
18424	6186	1515	124609
18425	6187	1517	\N
18426	6187	1518	\N
18427	6111	1520	163808
18428	6259	1519	655153
18429	6259	1520	930217
18430	6188	1522	\N
18431	6188	1524	\N
18432	6112	1526	530466
18433	6112	1527	593370
18434	6112	1528	381114
18435	6112	1529	641600
18436	6188	1526	839240
18437	6188	1527	752094
18438	6188	1528	278762
18439	6113	1530	\N
18440	6189	1531	\N
18441	6189	1533	\N
18442	6189	1534	\N
18443	6189	1535	\N
18444	6113	1536	677712
18445	6113	1537	810651
18446	6189	1537	784559
18447	6260	1536	450717
18448	6114	1538	\N
18449	6114	1539	\N
18450	6114	1541	\N
18451	6261	1538	\N
18452	6114	1542	806244
18453	6115	1543	\N
18454	6115	1544	\N
18455	6115	1545	\N
18456	6190	1543	\N
18457	6190	1545	\N
18458	6190	1546	\N
18459	6190	1547	512384
18460	6262	1547	213738
18461	6262	1548	706642
18462	6262	1550	241492
18463	6262	1551	973476
18464	6262	1552	201747
18465	6116	1553	\N
18466	6116	1554	\N
18467	6116	1555	\N
18468	6263	1553	\N
18469	6116	1556	364222
18470	6116	1557	568109
18471	6191	1556	669121
18472	6191	1557	898975
18473	6191	1558	638596
18474	6191	1560	900383
18475	6192	1561	\N
18476	6192	1562	\N
18477	6117	1564	324298
18478	6192	1564	934070
18479	6264	1563	236007
18480	6264	1564	963644
18481	6118	1566	\N
18482	6118	1567	\N
18483	6193	1565	\N
18484	6193	1566	\N
18485	6265	1566	\N
18486	6193	1568	122460
18487	6265	1568	838939
18488	6265	1569	912104
18489	6194	1570	\N
18490	6119	1571	770936
18491	6194	1571	478538
18492	6194	1572	171875
18493	6194	1573	571214
18494	6194	1574	787308
18495	6266	1575	\N
18496	6266	1576	\N
18497	6266	1577	\N
18498	6120	1579	794636
18499	6120	1580	117554
18500	6195	1578	734624
18501	6266	1578	842932
18502	6266	1579	185678
18503	6196	1582	\N
18504	6196	1583	\N
18505	6196	1584	\N
18506	6121	1585	151979
18507	6121	1587	898304
18508	6267	1586	281741
18509	6267	1588	662932
18510	6267	1589	625213
18511	6267	1590	586113
18512	6267	1591	357379
18513	6122	1592	\N
18514	6197	1592	\N
18515	6268	1592	\N
18516	6268	1593	448441
18517	6268	1594	221979
18518	6123	1595	\N
18519	6123	1596	\N
18520	6123	1597	\N
18521	6123	1599	\N
18522	6269	1596	\N
18523	6269	1601	529645
18524	6269	1602	468479
18525	6269	1603	222404
18526	6124	1605	\N
18527	6124	1606	\N
18528	6198	1604	\N
18529	6270	1605	\N
18530	6124	1607	382288
18531	6270	1607	859877
18532	6270	1608	531011
18533	6270	1609	818005
18534	6125	1610	\N
18535	6125	1611	\N
18536	6125	1612	\N
18537	6125	1613	\N
18538	6271	1611	\N
18539	6271	1613	\N
18540	6125	1615	981742
18541	6271	1614	906553
18542	6271	1615	766795
18543	6126	1616	\N
18544	6126	1617	\N
18545	6272	1617	\N
18546	6126	1618	977287
18547	6126	1620	249087
18548	6126	1621	835535
18549	6272	1618	622333
18550	6272	1620	316410
18551	6199	1623	\N
18552	6127	1625	914293
18553	6273	1624	725394
18554	6128	1627	\N
18555	6274	1626	\N
18556	6128	1628	369117
18557	6200	1628	942930
18558	6200	1629	355630
18559	6274	1628	450184
18560	6129	1630	\N
18561	6201	1631	\N
18562	6201	1632	\N
18563	6275	1630	\N
18564	6275	1631	\N
18565	6275	1632	\N
18566	6129	1634	962536
18567	6129	1635	540276
18568	6201	1634	811520
18569	6275	1633	116723
18570	6130	1636	\N
18571	6130	1637	\N
18572	6130	1638	\N
18573	6202	1636	\N
18574	6202	1637	\N
18575	6202	1638	\N
18576	6202	1640	\N
18577	6202	1642	\N
18578	6276	1636	\N
18579	6130	1643	554768
18580	6130	1645	985430
18581	6276	1643	562221
18582	6276	1644	472675
18583	6276	1645	471893
18584	6131	1646	\N
18585	6203	1646	\N
18586	6203	1647	\N
18587	6203	1648	\N
18588	6277	1647	\N
18589	6277	1649	\N
18590	6131	1650	819488
18591	6131	1651	878237
18592	6203	1650	990176
18593	6277	1650	381688
18594	6132	1652	\N
18595	6132	1653	\N
18596	6132	1654	\N
18597	6204	1652	\N
18598	6204	1654	\N
18599	6278	1652	\N
18600	6278	1653	\N
18601	6132	1655	100135
18602	6204	1655	593637
18603	6204	1657	805815
18604	6205	1659	\N
18605	6279	1660	310984
18606	6279	1662	594218
18607	6133	1663	\N
18608	6206	1664	\N
18609	6280	1664	\N
18610	6206	1665	321901
18611	6207	1666	\N
18612	6207	1668	\N
18613	6207	1669	\N
18614	6281	1666	\N
18615	6281	1667	\N
18616	6134	1670	756117
18617	6134	1671	792927
18618	6207	1670	290159
18619	6207	1671	956534
18620	6281	1670	412302
18621	6281	1671	264444
18622	6281	1672	321924
18623	6135	1674	\N
18624	6135	1676	201389
18625	6135	1677	149950
18626	6135	1678	736021
18627	6208	1675	659022
18628	6282	1675	461921
18629	6136	1679	\N
18630	6209	1679	\N
18631	6136	1681	289739
18632	6209	1680	739588
18633	6209	1681	497012
18634	6209	1682	330666
18635	6283	1681	277290
18636	6283	1682	812612
18637	6283	1683	770902
18638	6210	1685	\N
18639	6210	1686	985792
18640	6211	1688	\N
18641	6211	1690	\N
18642	6137	1692	270524
18643	6284	1692	426907
18644	6284	1693	815527
18645	6284	1694	740511
18646	6284	1696	575161
18647	6284	1697	209283
18648	6138	1698	\N
18649	6138	1699	\N
18650	6212	1699	\N
18651	6212	1700	\N
18652	6212	1702	\N
18653	6212	1703	\N
18654	6212	1705	\N
18655	6285	1698	\N
18656	6285	1699	\N
18657	6285	1700	\N
18658	6213	1706	\N
18659	6213	1707	\N
18660	6213	1708	\N
18661	6286	1707	\N
18662	6286	1708	\N
18663	6286	1709	\N
18664	6139	1711	680168
18665	6139	1712	913131
18666	6139	1713	694063
18667	6139	1714	607182
18668	6139	1716	666401
18669	6286	1710	245544
18670	6286	1711	341481
18671	6140	1717	\N
18672	6140	1718	\N
18673	6140	1719	\N
18674	6214	1717	\N
18675	6287	1717	\N
18676	6287	1718	\N
18677	6140	1720	429971
18678	6140	1721	101331
18679	6214	1720	238194
18680	6214	1722	667876
18681	6214	1723	907730
18682	6287	1720	179965
18683	6215	1724	\N
18684	6288	1724	\N
18685	6288	1725	\N
18686	6288	1727	\N
18687	6288	1728	\N
18688	6215	1729	496387
18689	6215	1730	481399
18690	6215	1731	317855
18691	6141	1732	\N
18692	6216	1732	\N
18693	6216	1734	273665
18694	6216	1735	218713
18695	6216	1736	740037
18696	6289	1734	288140
18697	6289	1735	347244
18698	6289	1737	727640
18699	6289	1738	525062
18700	6142	1740	\N
18701	6142	1741	\N
18702	6142	1742	\N
18703	6217	1740	\N
18704	6217	1742	\N
18705	6290	1739	\N
18706	6290	1741	\N
18707	6290	1742	\N
18708	6217	1743	895844
18709	6217	1745	323137
18710	6217	1747	104478
18711	6143	1748	\N
18712	6143	1749	\N
18713	6143	1750	\N
18714	6143	1751	\N
18715	6218	1748	\N
18716	6291	1748	\N
18717	6291	1749	\N
18718	6291	1751	\N
18719	6291	1753	\N
18720	6291	1754	\N
18721	6143	1755	723221
18722	6218	1755	775600
18723	6218	1756	225758
18724	6218	1758	288911
18725	6218	1760	257009
18726	6144	1761	\N
18727	6219	1763	753441
18728	6219	1764	404419
18729	6219	1765	983304
18730	6292	1762	296274
18731	6293	1766	\N
18732	6293	1767	\N
18733	6145	1768	589003
18734	6220	1769	718507
18735	6220	1770	453682
18736	6220	1772	635899
18737	6220	1773	870169
18738	6220	1774	981828
18739	6293	1769	515744
18740	6146	1775	\N
18741	6221	1775	\N
18742	6221	1776	\N
18743	6146	1777	453356
18744	6146	1778	265899
18745	6221	1777	651103
18746	6221	1778	740181
18747	6221	1779	382841
18748	6294	1777	356834
18749	6294	1779	241458
18750	6294	1780	577823
18751	6294	1781	730061
18752	6147	1782	\N
18753	6147	1783	293045
18754	6147	1784	732652
18755	6147	1785	296209
18756	6222	1783	144607
18757	6148	1786	\N
18758	6148	1787	109716
18759	6148	1788	123147
18760	6223	1787	759954
18761	6223	1788	939952
18762	6295	1790	\N
18763	6333	1789	\N
18764	6333	1790	\N
18765	6333	1791	\N
18766	6295	1793	561356
18767	6296	1794	\N
18768	6334	1794	\N
18769	6296	1795	182818
18770	6296	1796	169029
18771	6296	1797	572511
18772	6297	1798	375852
18773	6298	1800	\N
18774	6298	1801	\N
18775	6298	1802	\N
18776	6298	1803	\N
18777	6298	1804	884223
18778	6335	1805	530219
18779	6335	1806	121422
18780	6335	1808	755105
18781	6335	1809	866899
18782	6299	1810	\N
18783	6336	1810	\N
18784	6300	1811	\N
18785	6337	1811	\N
18786	6300	1812	124701
18787	6337	1812	385562
18788	6337	1814	991023
18789	6338	1815	\N
18790	6338	1816	\N
18791	6338	1818	\N
18792	6301	1819	197253
18793	6301	1820	460582
18794	6302	1821	\N
18795	6302	1822	\N
18796	6302	1823	\N
18797	6302	1824	\N
18798	6339	1826	526008
18799	6339	1827	749255
18800	6339	1828	460609
18801	6340	1829	\N
18802	6340	1830	\N
18803	6340	1831	614142
18804	6340	1832	958924
18805	6340	1834	405193
18806	6303	1835	\N
18807	6303	1837	\N
18808	6303	1839	\N
18809	6303	1840	\N
18810	6303	1841	694607
18811	6304	1842	\N
18812	6341	1842	\N
18813	6304	1843	606851
18814	6304	1844	633326
18815	6341	1843	631498
18816	6341	1844	746580
18817	6305	1845	\N
18818	6305	1846	\N
18819	6342	1845	\N
18820	6306	1848	\N
18821	6306	1850	\N
18822	6343	1847	\N
18823	6343	1851	654047
18824	6307	1852	\N
18825	6307	1854	\N
18826	6344	1852	\N
18827	6344	1854	\N
18828	6344	1856	\N
18829	6344	1857	\N
18830	6307	1859	293113
18831	6307	1860	318280
18832	6308	1862	\N
18833	6308	1863	110485
18834	6345	1864	\N
18835	6309	1865	272788
18836	6309	1866	121682
18837	6345	1865	840956
18838	6345	1866	900374
18839	6345	1868	750067
18840	6346	1869	\N
18841	6346	1871	\N
18842	6310	1873	313499
18843	6310	1874	180905
18844	6346	1872	631070
18845	6346	1873	757170
18846	6311	1875	\N
18847	6347	1875	\N
18848	6347	1876	\N
18849	6311	1878	645035
18850	6311	1880	349483
18851	6347	1878	874598
18852	6312	1881	\N
18853	6312	1883	501260
18854	6348	1882	594668
18855	6348	1883	644430
18856	6313	1884	\N
18857	6313	1885	\N
18858	6313	1886	\N
18859	6313	1887	921290
18860	6349	1888	370747
18861	6349	1889	264846
18862	6350	1890	\N
18863	6314	1891	236133
18864	6314	1893	858781
18865	6350	1891	473245
18866	6350	1892	707902
18867	6351	1895	\N
18868	6315	1896	263566
18869	6315	1897	276529
18870	6315	1899	593672
18871	6315	1900	263457
18872	6315	1901	697591
18873	6351	1896	755596
18874	6316	1902	\N
18875	6316	1904	\N
18876	6352	1903	\N
18877	6352	1905	740698
18878	6352	1906	357276
18879	6352	1907	391330
18880	6352	1909	831855
18881	6317	1910	594922
18882	6317	1911	599964
18883	6317	1912	203450
18884	6318	1913	\N
18885	6353	1913	\N
18886	6353	1914	\N
18887	6353	1916	\N
18888	6353	1917	\N
18889	6318	1919	771978
18890	6353	1918	462568
18891	6319	1920	\N
18892	6319	1922	\N
18893	6319	1923	457683
18894	6319	1924	242016
18895	6319	1925	376594
18896	6354	1923	518754
18897	6354	1924	335483
18898	6320	1926	\N
18899	6320	1927	\N
18900	6320	1928	\N
18901	6320	1930	\N
18902	6355	1926	\N
18903	6355	1931	669508
18904	6321	1932	\N
18905	6356	1932	\N
18906	6356	1933	499341
18907	6356	1935	223822
18908	6322	1936	\N
18909	6357	1936	\N
18910	6357	1937	\N
18911	6322	1938	903975
18912	6357	1938	361554
18913	6358	1939	\N
18914	6323	1941	422026
18915	6323	1942	986474
18916	6323	1943	303220
18917	6359	1944	\N
18918	6359	1946	\N
18919	6359	1947	\N
18920	6359	1948	\N
18921	6324	1949	674375
18922	6324	1950	145655
18923	6324	1951	172106
18924	6324	1952	791329
18925	6324	1954	586178
18926	6359	1949	635279
18927	6325	1956	\N
18928	6325	1958	772881
18929	6360	1957	346740
18930	6360	1958	218920
18931	6326	1959	\N
18932	6326	1960	716823
18933	6326	1961	134026
18934	6326	1962	576634
18935	6361	1961	605713
18936	6327	1963	648684
18937	6362	1963	442958
18938	6362	1964	950789
18939	6362	1966	143408
18940	6328	1967	366734
18941	6363	1967	749702
18942	6329	1968	\N
18943	6330	1969	\N
18944	6330	1971	\N
18945	6364	1973	652534
18946	6331	1974	819441
18947	6331	1975	522001
18948	6331	1976	684076
18949	6331	1977	402432
18950	6332	1978	\N
18951	6365	1978	\N
18952	6365	1979	\N
18953	6332	1981	741075
18954	6365	1980	809427
18955	6366	1982	112251
18956	6366	1983	577404
18957	6366	1985	962391
18958	6366	1986	639401
18959	6367	1987	\N
18960	6367	1988	848936
18961	6367	1989	385486
18962	6367	1990	260192
18963	6368	1991	561766
18964	6368	1992	258711
18965	6369	1993	\N
18966	6369	1994	\N
18967	6370	1996	\N
18968	6370	1998	\N
18969	6370	1999	\N
18970	6370	0	\N
18971	6370	2	218807
18972	6371	3	\N
18973	6371	4	\N
18974	6371	5	\N
18975	6371	7	779663
18976	6371	8	938639
18977	6372	9	\N
18978	6372	11	\N
18979	6372	12	976542
18980	6372	13	646827
18981	6373	14	\N
18982	6373	15	\N
18983	6373	16	\N
18984	6373	18	\N
18985	6374	19	779042
18986	6374	21	200783
18987	6375	22	\N
18988	6375	23	694366
18989	6375	24	208574
18990	6376	25	287709
18991	6377	26	\N
18992	6377	27	513508
18993	6377	28	503612
18994	6377	29	608674
18995	6377	30	577975
18996	6378	32	\N
18997	6379	33	\N
18998	6379	34	306308
18999	6380	35	\N
19000	6380	36	\N
19001	6380	38	277871
19002	6380	40	525808
19003	6381	42	\N
19004	6382	43	\N
19005	6382	44	\N
19006	6382	45	731693
19007	6382	47	825065
19008	6382	48	133278
19009	6383	49	\N
19010	6383	50	\N
19011	6383	51	\N
19012	6383	53	\N
19013	6384	54	\N
19014	6384	55	\N
19015	6384	56	\N
19016	6384	57	575941
19017	6384	58	755407
19018	6385	60	\N
19019	6385	61	\N
19020	6385	62	\N
19021	6385	63	822219
19022	6386	64	\N
19023	6386	65	\N
19024	6386	67	205404
19025	6386	68	148693
19026	6386	69	137719
19027	6387	71	\N
19028	6387	72	221969
19029	6388	73	580865
19030	6388	75	969948
19031	6389	76	\N
19032	6389	78	\N
19033	6389	79	\N
19034	6389	81	\N
19035	6389	83	146037
19036	6390	84	\N
19037	6390	86	\N
19038	6390	87	\N
19039	6390	88	311571
19040	6391	89	\N
19041	6391	90	256228
19042	6391	91	181934
19043	6391	92	682828
19044	6391	93	264624
19045	6392	94	864878
19046	6392	95	615811
19047	6393	96	\N
19048	6394	97	295921
19049	6394	98	123334
19050	6449	99	\N
19051	6449	100	450822
19052	6395	101	\N
19053	6395	103	\N
19054	6450	101	\N
19055	6450	102	\N
19056	6450	103	\N
19057	6450	104	\N
19058	6450	105	\N
19059	6395	107	884169
19060	6451	108	\N
19061	6451	110	\N
19062	6451	111	\N
19063	6451	113	506055
19064	6396	114	\N
19065	6396	116	201879
19066	6396	117	902350
19067	6396	118	524757
19068	6396	119	355426
19069	6452	115	304905
19070	6452	116	600992
19071	6452	117	555451
19072	6397	120	561084
19073	6397	121	666527
19074	6397	123	292350
19075	6453	120	129035
19076	6453	121	802883
19077	6453	122	800522
19078	6453	124	602671
19079	6398	125	\N
19080	6398	126	143934
19081	6398	127	135479
19082	6454	126	946849
19083	6455	129	\N
19084	6455	130	\N
19085	6399	131	797060
19086	6399	132	519450
19087	6455	131	136069
19088	6456	133	\N
19089	6400	134	\N
19090	6457	135	283988
19091	6458	136	982600
19092	6459	137	\N
19093	6459	138	\N
19094	6459	139	\N
19095	6459	140	766357
19096	6459	141	549861
19097	6401	142	\N
19098	6401	143	\N
19099	6401	145	\N
19100	6460	142	\N
19101	6460	143	\N
19102	6460	144	\N
19103	6460	145	\N
19104	6401	147	911122
19105	6401	148	322797
19106	6460	146	243445
19107	6402	149	\N
19108	6461	149	\N
19109	6461	151	\N
19110	6461	152	\N
19111	6461	154	\N
19112	6402	155	996133
19113	6462	156	\N
19114	6403	157	871580
19115	6403	158	456745
19116	6403	160	296387
19117	6403	161	860542
19118	6462	157	320585
19119	6462	159	446399
19120	6462	161	685502
19121	6462	162	320653
19122	6404	163	\N
19123	6404	165	\N
19124	6404	166	\N
19125	6404	167	937411
19126	6404	168	987847
19127	6463	168	959972
19128	6464	170	\N
19129	6464	171	\N
19130	6405	173	124440
19131	6405	175	980268
19132	6464	172	156350
19133	6464	174	636389
19134	6464	176	811667
19135	6406	178	\N
19136	6406	180	\N
19137	6406	181	\N
19138	6465	177	\N
19139	6406	182	453678
19140	6465	182	194824
19141	6465	183	859244
19142	6465	184	935630
19143	6465	185	271702
19144	6466	186	\N
19145	6466	188	\N
19146	6466	189	\N
19147	6466	190	\N
19148	6407	192	917172
19149	6407	193	155047
19150	6466	191	518273
19151	6467	194	\N
19152	6408	195	501422
19153	6408	196	991011
19154	6467	196	840973
19155	6467	197	423470
19156	6467	198	159770
19157	6409	199	\N
19158	6409	201	\N
19159	6409	202	\N
19160	6468	199	\N
19161	6409	204	827361
19162	6409	205	919419
19163	6468	204	283716
19164	6468	205	165138
19165	6468	206	894128
19166	6468	207	242213
19167	6410	208	\N
19168	6410	210	\N
19169	6410	212	\N
19170	6410	214	\N
19171	6410	215	531296
19172	6469	216	\N
19173	6469	217	\N
19174	6411	219	334408
19175	6411	220	574548
19176	6412	221	\N
19177	6412	222	\N
19178	6412	224	\N
19179	6412	226	\N
19180	6470	221	\N
19181	6470	222	\N
19182	6412	227	997595
19183	6413	228	\N
19184	6413	230	\N
19185	6471	231	840741
19186	6414	232	\N
19187	6414	233	\N
19188	6472	232	\N
19189	6472	233	\N
19190	6472	234	\N
19191	6414	235	389141
19192	6415	237	\N
19193	6415	239	\N
19194	6415	240	\N
19195	6415	241	\N
19196	6473	237	\N
19197	6473	238	\N
19198	6473	239	\N
19199	6473	240	\N
19200	6415	243	982450
19201	6416	244	\N
19202	6416	246	\N
19203	6416	247	\N
19204	6416	248	\N
19205	6416	249	\N
19206	6474	244	\N
19207	6474	246	\N
19208	6474	247	\N
19209	6474	248	\N
19210	6474	249	\N
19211	6417	251	\N
19212	6417	252	\N
19213	6475	253	383319
19214	6475	254	756366
19215	6475	256	354060
19216	6418	258	\N
19217	6476	257	\N
19218	6418	259	326158
19219	6418	261	439500
19220	6418	263	566464
19221	6419	265	\N
19222	6477	264	\N
19223	6477	265	\N
19224	6477	267	\N
19225	6419	269	652408
19226	6420	270	\N
19227	6478	270	\N
19228	6478	271	\N
19229	6478	272	\N
19230	6478	273	\N
19231	6478	275	150325
19232	6421	276	\N
19233	6421	278	\N
19234	6421	279	667045
19235	6421	280	140326
19236	6421	281	377834
19237	6422	282	\N
19238	6423	283	\N
19239	6423	285	622167
19240	6423	286	460366
19241	6423	287	257509
19242	6424	288	\N
19243	6424	290	\N
19244	6424	291	\N
19245	6479	288	\N
19246	6479	292	957923
19247	6479	293	328448
19248	6425	295	\N
19249	6425	296	\N
19250	6425	297	572266
19251	6425	298	171186
19252	6425	299	942628
19253	6480	297	546255
19254	6480	298	885976
19255	6426	300	\N
19256	6426	301	253671
19257	6426	302	216599
19258	6426	303	113444
19259	6426	304	320737
19260	6481	301	261345
19261	6427	305	\N
19262	6427	306	233942
19263	6482	307	246896
19264	6482	308	551851
19265	6428	309	\N
19266	6428	311	685174
19267	6429	312	\N
19268	6429	313	\N
19269	6483	313	\N
19270	6430	314	\N
19271	6430	315	\N
19272	6484	314	\N
19273	6484	315	\N
19274	6484	316	718854
19275	6484	318	108671
19276	6431	319	\N
19277	6431	321	\N
19278	6485	320	\N
19279	6431	322	811418
19280	6431	323	428970
19281	6431	324	558991
19282	6485	322	180360
19283	6485	323	830185
19284	6485	325	394580
19285	6432	326	\N
19286	6486	326	\N
19287	6432	328	588558
19288	6487	329	\N
19289	6433	331	207996
19290	6433	333	549383
19291	6433	334	837151
19292	6433	335	282459
19293	6487	331	125428
19294	6434	336	\N
19295	6434	337	\N
19296	6434	338	\N
19297	6488	339	332730
19298	6488	340	141827
19299	6489	341	\N
19300	6435	342	912087
19301	6435	343	234910
19302	6436	344	\N
19303	6436	345	\N
19304	6490	344	\N
19305	6490	345	\N
19306	6490	346	\N
19307	6490	348	\N
19308	6490	349	844830
19309	6437	350	836583
19310	6491	350	573896
19311	6491	351	237990
19312	6491	352	923917
19313	6491	353	771843
19314	6438	354	\N
19315	6438	355	\N
19316	6438	356	385596
19317	6438	357	896483
19318	6438	359	654986
19319	6492	356	922359
19320	6492	357	278458
19321	6492	359	294774
19322	6492	360	624922
19323	6492	361	687917
19324	6439	363	712701
19325	6493	362	552613
19326	6493	363	180703
19327	6493	364	989715
19328	6493	366	658778
19329	6493	368	420956
19330	6440	369	\N
19331	6440	370	\N
19332	6494	369	\N
19333	6494	370	\N
19334	6440	371	375805
19335	6441	372	\N
19336	6441	373	\N
19337	6495	372	\N
19338	6495	373	\N
19339	6495	374	\N
19340	6441	376	477540
19341	6441	377	874107
19342	6441	378	521948
19343	6442	379	390644
19344	6442	380	732519
19345	6442	381	316768
19346	6442	383	164869
19347	6442	385	187943
19348	6443	386	\N
19349	6443	387	\N
19350	6443	388	732225
19351	6443	389	581254
19352	6496	389	278674
19353	6496	390	267990
19354	6496	391	240641
19355	6496	392	620433
19356	6496	394	983969
19357	6444	395	426937
19358	6444	396	496240
19359	6444	398	203127
19360	6445	399	403596
19361	6445	401	569801
19362	6446	402	\N
19363	6446	403	\N
19364	6446	404	\N
19365	6446	405	594956
19366	6446	406	224596
19367	6497	407	\N
19368	6447	408	566120
19369	6447	409	823705
19370	6498	411	\N
19371	6498	412	576107
19372	6498	413	774387
19373	6448	414	\N
19374	6499	414	\N
19375	6499	416	\N
19376	6499	417	\N
19377	6499	418	\N
19378	6499	419	699734
19379	6500	420	466843
19380	6501	421	644983
19381	6502	423	\N
19382	6502	424	\N
19383	6502	425	\N
19384	6503	426	977494
19385	6504	427	\N
19386	6505	428	\N
19387	6505	429	913897
19388	6506	431	\N
19389	6506	433	\N
19390	6506	434	\N
19391	6506	436	\N
19392	6507	437	\N
19393	6507	438	\N
19394	6508	439	\N
19395	6508	440	504367
19396	6508	441	331874
19397	6508	443	433340
19398	6509	444	\N
19399	6509	445	\N
19400	6509	446	\N
19401	6510	447	\N
19402	6510	448	\N
19403	6510	450	\N
19404	6510	451	146149
19405	6510	453	824821
19406	6511	454	999713
19407	6512	455	820304
19408	6513	456	\N
19409	6513	458	\N
19410	6513	459	824390
19411	6514	460	373382
19412	6515	461	\N
19413	6515	463	\N
19414	6516	464	\N
19415	6516	466	\N
19416	6516	467	\N
19417	6516	469	\N
19418	6517	470	\N
19419	6517	471	\N
19420	6517	472	\N
19421	6517	473	643902
19422	6517	474	786606
19423	6518	475	\N
19424	6519	477	\N
19425	6519	478	457949
19426	6519	479	596738
19427	6520	480	\N
19428	6520	482	626311
19429	6521	484	\N
19430	6521	485	\N
19431	6522	486	\N
19432	6522	487	\N
19433	6522	488	\N
19434	6522	489	\N
19435	6523	490	\N
19436	6524	491	147432
19437	6524	492	542308
19438	6524	493	918044
19439	6570	492	578395
19440	6525	494	\N
19441	6525	496	\N
19442	6525	498	591295
19443	6571	499	\N
19444	6571	500	\N
19445	6571	502	456980
19446	6571	503	752312
19447	6526	505	\N
19448	6526	506	\N
19449	6526	507	972987
19450	6526	508	806011
19451	6572	507	460183
19452	6572	508	611142
19453	6572	509	868417
19454	6572	510	275724
19455	6572	512	308748
19456	6527	514	\N
19457	6527	515	276572
19458	6573	516	474057
19459	6573	517	426663
19460	6573	518	816643
19461	6528	519	\N
19462	6528	520	\N
19463	6574	519	\N
19464	6574	520	\N
19465	6528	521	710204
19466	6528	522	825275
19467	6528	523	199861
19468	6574	521	481974
19469	6575	524	\N
19470	6529	525	407720
19471	6529	526	330223
19472	6529	528	590715
19473	6529	530	139513
19474	6529	531	986396
19475	6575	525	886457
19476	6575	527	401182
19477	6575	529	865574
19478	6530	532	\N
19479	6530	534	\N
19480	6530	536	\N
19481	6576	537	772997
19482	6576	538	376887
19483	6576	539	246080
19484	6576	540	139731
19485	6531	541	\N
19486	6577	541	\N
19487	6531	542	512102
19488	6531	544	830496
19489	6531	545	862181
19490	6531	546	324270
19491	6532	547	\N
19492	6532	548	\N
19493	6578	547	\N
19494	6578	548	\N
19495	6578	549	\N
19496	6532	550	103415
19497	6532	551	967917
19498	6532	552	398934
19499	6533	553	\N
19500	6533	555	\N
19501	6579	553	\N
19502	6579	554	\N
19503	6579	557	893861
19504	6579	558	667778
19505	6534	559	\N
19506	6580	561	\N
19507	6580	563	\N
19508	6535	564	\N
19509	6535	566	\N
19510	6581	564	\N
19511	6581	566	\N
19512	6581	567	\N
19513	6535	569	577154
19514	6535	570	219885
19515	6535	571	284148
19516	6581	568	433208
19517	6536	572	\N
19518	6536	573	\N
19519	6582	574	924138
19520	6537	576	\N
19521	6583	575	\N
19522	6583	576	\N
19523	6537	577	938508
19524	6583	577	725130
19525	6538	578	\N
19526	6538	579	\N
19527	6584	578	\N
19528	6584	579	\N
19529	6584	581	\N
19530	6584	583	\N
19531	6584	584	\N
19532	6539	585	\N
19533	6585	586	\N
19534	6585	587	\N
19535	6585	588	\N
19536	6585	589	\N
19537	6540	590	\N
19538	6540	592	\N
19539	6540	593	\N
19540	6540	594	568102
19541	6541	595	\N
19542	6586	596	\N
19543	6586	598	822858
19544	6586	599	232222
19545	6586	601	613951
19546	6586	603	323219
19547	6587	604	\N
19548	6542	605	216459
19549	6543	606	577043
19550	6588	607	133460
19551	6588	608	684493
19552	6589	609	\N
19553	6589	610	\N
19554	6589	611	742863
19555	6544	613	\N
19556	6590	612	\N
19557	6590	614	\N
19558	6590	616	\N
19559	6590	617	\N
19560	6544	618	173097
19561	6544	619	646555
19562	6544	620	597789
19563	6544	621	894578
19564	6590	618	500274
19565	6591	622	\N
19566	6591	624	\N
19567	6591	625	\N
19568	6545	626	138639
19569	6545	627	981134
19570	6545	628	479271
19571	6545	629	665012
19572	6591	626	391303
19573	6546	630	\N
19574	6546	631	\N
19575	6546	632	\N
19576	6546	633	594132
19577	6547	634	391204
19578	6547	636	773111
19579	6547	637	269673
19580	6547	639	607708
19581	6547	640	938616
19582	6548	641	\N
19583	6548	642	\N
19584	6592	642	\N
19585	6548	643	984055
19586	6548	644	371879
19587	6548	646	809543
19588	6592	643	329905
19589	6592	645	790809
19590	6592	646	368800
19591	6592	648	381723
19592	6549	649	\N
19593	6549	651	\N
19594	6549	652	\N
19595	6549	653	372689
19596	6593	654	\N
19597	6550	655	732548
19598	6550	656	743244
19599	6550	657	474703
19600	6550	658	485345
19601	6550	659	778260
19602	6551	660	\N
19603	6551	661	\N
19604	6551	663	\N
19605	6551	664	\N
19606	6594	660	\N
19607	6551	665	434816
19608	6594	665	130441
19609	6594	666	870839
19610	6594	667	563072
19611	6552	668	\N
19612	6595	668	\N
19613	6595	669	\N
19614	6552	670	438353
19615	6552	671	307898
19616	6553	672	\N
19617	6553	673	594766
19618	6553	675	980092
19619	6596	673	419105
19620	6596	675	592833
19621	6554	676	\N
19622	6554	677	\N
19623	6554	679	964808
19624	6555	680	\N
19625	6555	681	\N
19626	6555	683	497062
19627	6555	684	258197
19628	6555	685	289044
19629	6597	683	486345
19630	6597	684	354985
19631	6597	685	159838
19632	6597	686	797356
19633	6556	687	\N
19634	6556	689	\N
19635	6598	691	248204
19636	6557	692	\N
19637	6599	692	\N
19638	6599	693	\N
19639	6599	694	\N
19640	6557	696	800882
19641	6557	697	589396
19642	6557	698	939949
19643	6557	699	904312
19644	6599	695	388520
19645	6558	700	\N
19646	6558	701	\N
19647	6558	702	371149
19648	6558	703	142393
19649	6600	702	333638
19650	6559	704	\N
19651	6559	705	\N
19652	6559	706	452836
19653	6559	707	243568
19654	6601	706	747728
19655	6560	709	226139
19656	6560	711	377973
19657	6602	708	541481
19658	6602	709	644926
19659	6602	710	831773
19660	6602	711	998357
19661	6602	712	409616
19662	6561	713	\N
19663	6603	714	380045
19664	6562	716	\N
19665	6604	715	\N
19666	6604	716	\N
19667	6562	717	458975
19668	6562	718	290895
19669	6604	718	184468
19670	6563	719	\N
19671	6564	720	188426
19672	6564	722	373561
19673	6605	720	934319
19674	6606	724	\N
19675	6565	725	806456
19676	6606	725	406321
19677	6606	726	257752
19678	6606	728	726242
19679	6566	729	\N
19680	6566	730	\N
19681	6607	729	\N
19682	6566	732	207405
19683	6566	733	772829
19684	6607	731	819975
19685	6607	732	320547
19686	6607	733	898819
19687	6567	735	\N
19688	6567	736	\N
19689	6567	738	\N
19690	6567	739	\N
19691	6608	740	884786
19692	6608	741	245861
19693	6568	742	\N
19694	6568	743	\N
19695	6568	744	\N
19696	6609	742	\N
19697	6568	745	887802
19698	6610	747	518389
19699	6610	749	541618
19700	6569	750	431208
19701	6611	751	\N
19702	6700	751	\N
19703	6700	753	\N
19704	6700	754	713658
19705	6612	755	\N
19706	6612	756	\N
19707	6612	757	437888
19708	6612	759	485575
19709	6701	758	201355
19710	6613	760	\N
19711	6702	760	\N
19712	6613	761	158974
19713	6613	762	210879
19714	6613	763	814578
19715	6613	764	437462
19716	6702	761	478168
19717	6702	763	282150
19718	6702	765	762107
19719	6703	766	\N
19720	6703	768	\N
19721	6703	769	\N
19722	6703	770	\N
19723	6703	772	\N
19724	6614	773	334143
19725	6615	774	\N
19726	6615	775	\N
19727	6615	776	\N
19728	6704	774	\N
19729	6704	776	\N
19730	6615	778	330735
19731	6616	779	\N
19732	6616	780	\N
19733	6616	781	\N
19734	6616	783	\N
19735	6705	779	\N
19736	6616	785	396156
19737	6705	784	827325
19738	6706	786	\N
19739	6706	787	\N
19740	6617	788	408808
19741	6617	789	450287
19742	6707	790	\N
19743	6707	791	\N
19744	6707	792	\N
19745	6707	793	\N
19746	6707	795	\N
19747	6618	796	537366
19748	6618	797	385662
19749	6618	798	264664
19750	6619	799	323922
19751	6619	800	696319
19752	6620	801	\N
19753	6708	802	843590
19754	6621	803	475534
19755	6709	805	436359
19756	6622	806	\N
19757	6622	807	\N
19758	6622	808	280335
19759	6622	809	974772
19760	6710	809	245072
19761	6710	810	289310
19762	6710	811	332295
19763	6710	813	234986
19764	6710	815	331073
19765	6711	817	644044
19766	6711	818	421748
19767	6623	820	264092
19768	6623	821	608498
19769	6623	823	513528
19770	6623	824	403185
19771	6624	826	\N
19772	6624	827	212816
19773	6624	829	195610
19774	6624	831	218571
19775	6712	827	711181
19776	6712	829	834757
19777	6712	830	762711
19778	6625	832	\N
19779	6625	833	\N
19780	6625	834	\N
19781	6625	836	\N
19782	6625	837	140841
19783	6713	839	\N
19784	6713	840	\N
19785	6713	842	\N
19786	6626	843	234775
19787	6713	843	347619
19788	6713	844	368438
19789	6627	845	\N
19790	6714	845	\N
19791	6628	846	419204
19792	6715	847	444353
19793	6715	848	864963
19794	6715	849	774230
19795	6715	850	864574
19796	6629	851	653830
19797	6629	853	122895
19798	6629	854	808388
19799	6629	855	321938
19800	6629	856	378891
19801	6630	858	\N
19802	6630	859	\N
19803	6630	860	\N
19804	6630	861	\N
19805	6716	857	\N
19806	6716	859	\N
19807	6630	863	842667
19808	6717	864	\N
19809	6718	866	\N
19810	6718	867	\N
19811	6718	868	\N
19812	6718	869	791928
19813	6631	871	\N
19814	6719	871	\N
19815	6631	873	499493
19816	6631	874	847497
19817	6632	875	\N
19818	6632	877	\N
19819	6632	878	\N
19820	6632	879	\N
19821	6720	875	\N
19822	6720	876	\N
19823	6633	880	\N
19824	6633	881	\N
19825	6721	883	638026
19826	6721	885	799244
19827	6634	887	\N
19828	6634	889	\N
19829	6722	886	\N
19830	6722	887	\N
19831	6722	888	\N
19832	6722	889	\N
19833	6634	890	385367
19834	6634	891	157778
19835	6722	890	941174
19836	6635	892	\N
19837	6635	893	\N
19838	6635	894	\N
19839	6635	895	806133
19840	6635	896	349276
19841	6723	897	\N
19842	6723	898	\N
19843	6636	899	883463
19844	6723	899	623577
19845	6723	901	376219
19846	6637	902	\N
19847	6724	902	\N
19848	6724	903	\N
19849	6724	904	\N
19850	6724	905	\N
19851	6725	906	\N
19852	6725	907	\N
19853	6725	908	\N
19854	6725	909	\N
19855	6638	911	\N
19856	6638	912	147314
19857	6726	912	980135
19858	6639	913	\N
19859	6727	914	107214
19860	6727	915	115532
19861	6727	916	980930
19862	6727	917	602988
19863	6727	918	322603
19864	6640	919	\N
19865	6640	920	\N
19866	6640	921	\N
19867	6728	923	938844
19868	6728	924	320820
19869	6728	925	931450
19870	6728	926	344808
19871	6641	927	\N
19872	6641	928	\N
19873	6641	930	\N
19874	6729	931	741145
19875	6729	932	290437
19876	6642	934	\N
19877	6730	933	\N
19878	6730	935	\N
19879	6730	936	\N
19880	6642	938	120749
19881	6643	939	\N
19882	6731	940	\N
19883	6731	941	\N
19884	6731	942	480638
19885	6731	943	568494
19886	6731	944	408153
19887	6644	945	\N
19888	6732	945	\N
19889	6644	946	117021
19890	6644	947	724058
19891	6644	948	562676
19892	6732	946	716817
19893	6733	949	\N
19894	6733	950	\N
19895	6733	952	\N
19896	6733	953	\N
19897	6733	954	265912
19898	6645	955	\N
19899	6734	955	\N
19900	6645	957	929622
19901	6646	959	578066
19902	6646	960	171213
19903	6646	961	425116
19904	6646	962	224068
19905	6646	963	776999
19906	6647	964	180550
19907	6735	964	982778
19908	6735	965	500175
19909	6735	966	828059
19910	6735	967	898021
19911	6735	968	901421
19912	6736	970	\N
19913	6736	972	\N
19914	6736	973	\N
19915	6736	975	\N
19916	6736	976	\N
19917	6648	977	987194
19918	6648	979	308339
19919	6649	980	\N
19920	6649	982	\N
19921	6649	984	\N
19922	6649	985	\N
19923	6649	987	\N
19924	6737	980	\N
19925	6737	988	157101
19926	6737	989	351852
19927	6650	990	\N
19928	6650	991	734809
19929	6651	992	583153
19930	6738	992	354628
19931	6738	993	638573
19932	6738	994	793389
19933	6738	996	951436
19934	6739	997	\N
19935	6739	998	\N
19936	6739	999	\N
19937	6739	1001	\N
19938	6739	1003	\N
19939	6652	1004	943667
19940	6652	1006	770905
19941	6653	1007	\N
19942	6653	1008	\N
19943	6653	1009	\N
19944	6654	1010	\N
19945	6654	1012	\N
19946	6654	1013	\N
19947	6654	1014	809282
19948	6654	1015	148414
19949	6740	1015	438920
19950	6740	1016	325732
19951	6740	1018	888655
19952	6740	1019	491602
19953	6740	1020	155577
19954	6655	1021	\N
19955	6655	1022	\N
19956	6741	1022	\N
19957	6655	1023	947017
19958	6655	1025	880076
19959	6655	1027	131426
19960	6741	1023	401747
19961	6741	1025	744092
19962	6742	1028	\N
19963	6742	1029	\N
19964	6656	1030	882252
19965	6656	1031	958729
19966	6657	1032	\N
19967	6657	1034	\N
19968	6657	1035	294383
19969	6743	1035	565997
19970	6743	1036	952307
19971	6744	1037	\N
19972	6744	1038	\N
19973	6744	1039	594188
19974	6745	1040	\N
19975	6745	1041	\N
19976	6745	1042	\N
19977	6745	1043	\N
19978	6658	1044	747931
19979	6658	1045	276471
19980	6659	1046	660690
19981	6660	1047	\N
19982	6660	1048	\N
19983	6660	1049	\N
19984	6660	1050	\N
19985	6660	1051	189957
19986	6661	1052	\N
19987	6661	1053	413758
19988	6661	1055	796671
19989	6662	1056	521898
19990	6746	1056	260939
19991	6663	1057	\N
19992	6663	1059	\N
19993	6663	1060	377704
19994	6663	1062	550863
19995	6663	1063	130347
19996	6747	1061	341819
19997	6664	1064	\N
19998	6664	1066	\N
19999	6748	1064	\N
20000	6665	1068	\N
20001	6749	1067	\N
20002	6749	1068	\N
20003	6749	1069	\N
20004	6749	1070	\N
20005	6749	1071	\N
20006	6665	1072	682076
20007	6665	1074	741114
20008	6665	1076	812696
20009	6665	1077	322303
20010	6666	1078	242255
20011	6750	1078	226410
20012	6750	1079	175141
20013	6751	1080	\N
20014	6667	1081	642056
20015	6667	1082	708267
20016	6667	1083	435066
20017	6667	1084	277686
20018	6667	1086	488395
20019	6752	1088	\N
20020	6753	1090	185805
20021	6668	1091	\N
20022	6668	1093	\N
20023	6669	1094	343774
20024	6754	1094	774598
20025	6754	1096	938846
20026	6754	1097	465730
20027	6755	1098	\N
20028	6670	1099	\N
20029	6670	1100	\N
20030	6670	1102	\N
20031	6756	1099	\N
20032	6756	1103	516484
20033	6756	1105	587460
20034	6756	1107	637636
20035	6671	1108	\N
20036	6671	1110	\N
20037	6757	1109	\N
20038	6671	1112	908062
20039	6757	1112	888495
20040	6757	1113	332146
20041	6757	1114	215978
20042	6758	1115	\N
20043	6672	1117	773608
20044	6758	1116	636761
20045	6759	1118	\N
20046	6759	1119	\N
20047	6759	1120	\N
20048	6759	1121	\N
20049	6673	1123	729032
20050	6759	1122	925808
20051	6760	1124	\N
20052	6760	1126	\N
20053	6760	1127	\N
20054	6674	1129	765820
20055	6675	1130	\N
20056	6675	1131	\N
20057	6761	1130	\N
20058	6761	1132	854507
20059	6761	1133	831804
20060	6761	1134	757208
20061	6761	1136	285968
20062	6762	1137	\N
20063	6676	1138	484128
20064	6676	1139	542568
20065	6677	1140	\N
20066	6678	1141	\N
20067	6678	1142	\N
20068	6678	1143	132353
20069	6678	1144	910807
20070	6678	1145	222795
20071	6763	1144	979823
20072	6763	1146	893600
20073	6679	1147	\N
20074	6679	1148	527391
20075	6764	1148	671745
20076	6764	1149	798438
20077	6680	1150	\N
20078	6680	1151	\N
20079	6680	1153	\N
20080	6765	1155	\N
20081	6765	1156	\N
20082	6681	1157	900651
20083	6765	1157	987875
20084	6682	1159	\N
20085	6766	1158	\N
20086	6766	1159	\N
20087	6683	1160	177137
20088	6683	1162	708415
20089	6683	1163	146137
20090	6683	1164	588472
20091	6683	1166	198076
20092	6684	1167	677881
20093	6684	1168	257673
20094	6684	1169	447424
20095	6685	1171	\N
20096	6685	1172	\N
20097	6685	1174	\N
20098	6685	1176	\N
20099	6767	1171	\N
20100	6767	1172	\N
20101	6767	1173	\N
20102	6767	1174	\N
20103	6767	1175	\N
20104	6685	1177	656690
20105	6768	1179	\N
20106	6768	1180	\N
20107	6686	1181	910729
20108	6768	1182	105483
20109	6768	1183	378342
20110	6768	1184	508014
20111	6769	1186	\N
20112	6687	1188	779050
20113	6687	1190	934126
20114	6769	1187	422325
20115	6770	1191	\N
20116	6770	1192	\N
20117	6770	1193	\N
20118	6688	1195	202881
20119	6688	1197	274124
20120	6688	1198	416460
20121	6770	1194	485675
20122	6770	1195	781383
20123	6771	1199	\N
20124	6771	1200	\N
20125	6689	1201	338347
20126	6689	1202	582832
20127	6689	1203	446810
20128	6689	1204	882030
20129	6771	1201	188398
20130	6690	1205	\N
20131	6690	1206	\N
20132	6690	1207	\N
20133	6690	1208	\N
20134	6772	1205	\N
20135	6772	1209	175783
20136	6772	1210	901240
20137	6691	1212	189023
20138	6691	1213	893321
20139	6691	1214	676494
20140	6691	1215	736145
20141	6691	1216	465673
20142	6773	1211	857627
20143	6774	1217	\N
20144	6774	1218	\N
20145	6774	1220	954917
20146	6692	1221	\N
20147	6775	1222	\N
20148	6775	1223	\N
20149	6692	1224	742018
20150	6692	1225	826842
20151	6775	1225	450164
20152	6693	1226	\N
20153	6693	1227	\N
20154	6693	1229	\N
20155	6693	1230	167481
20156	6693	1231	123851
20157	6776	1230	173918
20158	6776	1231	406469
20159	6776	1233	277732
20160	6776	1234	722599
20161	6776	1235	760589
20162	6694	1236	\N
20163	6694	1237	\N
20164	6694	1238	\N
20165	6777	1236	\N
20166	6777	1239	992681
20167	6777	1240	703220
20168	6695	1241	\N
20169	6695	1243	\N
20170	6695	1245	206416
20171	6778	1244	565389
20172	6696	1246	\N
20173	6779	1246	\N
20174	6779	1248	\N
20175	6779	1249	\N
20176	6696	1250	382417
20177	6780	1252	\N
20178	6780	1254	\N
20179	6780	1255	\N
20180	6780	1256	758743
20181	6780	1257	149822
20182	6697	1258	\N
20183	6697	1259	\N
20184	6697	1260	\N
20185	6697	1261	797558
20186	6697	1262	666756
20187	6698	1263	\N
20188	6698	1264	647807
20189	6698	1266	251067
20190	6781	1264	180788
20191	6782	1267	935913
20192	6782	1268	401801
20193	6782	1269	874484
20194	6783	1271	\N
20195	6783	1272	\N
20196	6783	1273	\N
20197	6783	1274	\N
20198	6783	1275	369945
20199	6784	1276	670826
20200	6784	1278	765747
20201	6785	1279	\N
20202	6786	1280	\N
20203	6786	1281	\N
20204	6787	1283	\N
20205	6787	1284	\N
20206	6787	1285	813404
20207	6787	1286	373368
20208	6788	1287	\N
20209	6788	1288	\N
20210	6788	1289	793825
20211	6788	1291	907387
20212	6699	1292	\N
20213	6789	1292	\N
20214	6789	1293	717005
20215	6789	1295	495990
20216	6790	1296	760219
20217	6791	1297	\N
20218	6791	1298	\N
20219	6791	1300	\N
20220	6791	1301	702740
20221	6792	1302	\N
20222	6792	1303	\N
20223	6792	1304	\N
20224	6853	1302	\N
20225	6853	1303	\N
20226	6792	1305	195128
20227	6792	1306	540707
20228	6793	1307	\N
20229	6793	1309	322480
20230	6854	1308	674637
20231	6854	1309	779871
20232	6854	1310	130011
20233	6855	1311	\N
20234	6855	1313	\N
20235	6794	1314	562872
20236	6794	1315	597670
20237	6795	1317	\N
20238	6856	1317	\N
20239	6856	1319	\N
20240	6856	1320	\N
20241	6796	1321	\N
20242	6857	1323	261723
20243	6857	1324	565925
20244	6857	1325	659495
20245	6858	1327	\N
20246	6858	1328	\N
20247	6858	1329	\N
20248	6858	1330	645080
20249	6858	1331	570249
20250	6797	1332	\N
20251	6797	1334	\N
20252	6797	1335	\N
20253	6859	1333	\N
20254	6859	1334	\N
20255	6859	1335	\N
20256	6797	1336	238609
20257	6797	1338	781550
20258	6798	1340	\N
20259	6798	1341	\N
20260	6860	1339	\N
20261	6798	1342	384961
20262	6798	1343	600947
20263	6798	1344	633798
20264	6799	1345	\N
20265	6799	1346	\N
20266	6799	1347	\N
20267	6861	1345	\N
20268	6861	1348	774121
20269	6861	1349	411668
20270	6861	1350	251884
20271	6861	1352	388841
20272	6800	1353	\N
20273	6800	1355	\N
20274	6800	1357	\N
20275	6800	1358	\N
20276	6800	1359	\N
20277	6862	1353	\N
20278	6863	1361	\N
20279	6863	1362	\N
20280	6801	1363	188391
20281	6801	1365	144519
20282	6801	1367	365549
20283	6801	1369	615366
20284	6802	1370	\N
20285	6802	1371	\N
20286	6864	1371	\N
20287	6802	1372	870091
20288	6864	1372	477157
20289	6864	1373	377487
20290	6803	1375	\N
20291	6803	1376	\N
20292	6803	1377	\N
20293	6803	1378	\N
20294	6803	1379	188354
20295	6865	1379	943252
20296	6865	1380	516392
20297	6865	1381	708279
20298	6804	1382	\N
20299	6804	1383	\N
20300	6804	1384	\N
20301	6804	1385	\N
20302	6804	1387	\N
20303	6866	1383	\N
20304	6866	1384	\N
20305	6866	1385	\N
20306	6866	1386	\N
20307	6866	1388	864464
20308	6805	1389	\N
20309	6867	1389	\N
20310	6867	1390	\N
20311	6867	1391	\N
20312	6867	1392	\N
20313	6805	1393	146051
20314	6867	1394	915842
20315	6806	1396	\N
20316	6806	1397	660362
20317	6807	1399	\N
20318	6807	1400	\N
20319	6868	1398	\N
20320	6868	1399	\N
20321	6868	1400	\N
20322	6807	1401	541121
20323	6807	1402	952838
20324	6808	1404	\N
20325	6869	1405	430648
20326	6869	1406	959913
20327	6869	1407	974419
20328	6869	1409	972729
20329	6869	1410	400973
20330	6870	1411	\N
20331	6870	1412	\N
20332	6870	1413	\N
20333	6870	1414	317775
20334	6809	1415	\N
20335	6809	1417	\N
20336	6809	1418	\N
20337	6810	1420	\N
20338	6810	1421	\N
20339	6810	1423	\N
20340	6871	1420	\N
20341	6871	1421	\N
20342	6871	1422	\N
20343	6871	1424	\N
20344	6810	1425	597043
20345	6810	1427	381239
20346	6811	1428	\N
20347	6811	1430	\N
20348	6872	1428	\N
20349	6811	1431	212353
20350	6811	1433	844789
20351	6872	1432	989172
20352	6872	1433	490548
20353	6812	1434	\N
20354	6812	1435	442528
20355	6812	1437	145519
20356	6812	1439	819924
20357	6873	1436	712437
20358	6873	1438	836209
20359	6813	1440	\N
20360	6813	1441	865010
20361	6813	1443	336062
20362	6813	1444	141106
20363	6813	1446	584395
20364	6874	1441	238261
20365	6874	1442	819995
20366	6874	1443	125807
20367	6874	1444	273300
20368	6875	1447	\N
20369	6875	1448	\N
20370	6875	1449	\N
20371	6875	1450	\N
20372	6876	1451	\N
20373	6876	1452	\N
20374	6814	1453	233390
20375	6814	1454	500657
20376	6814	1455	898687
20377	6876	1453	993498
20378	6876	1455	132712
20379	6815	1456	\N
20380	6815	1457	\N
20381	6815	1459	\N
20382	6877	1456	\N
20383	6815	1461	629850
20384	6816	1462	\N
20385	6816	1463	\N
20386	6878	1464	229580
20387	6817	1465	326290
20388	6817	1466	416920
20389	6817	1467	649703
20390	6817	1468	891179
20391	6818	1469	\N
20392	6818	1470	\N
20393	6879	1469	\N
20394	6879	1470	\N
20395	6879	1471	\N
20396	6880	1472	210825
20397	6880	1473	562064
20398	6819	1474	\N
20399	6881	1475	\N
20400	6881	1476	\N
20401	6819	1477	244931
20402	6820	1478	\N
20403	6820	1479	\N
20404	6820	1480	\N
20405	6820	1482	\N
20406	6882	1483	802870
20407	6882	1484	480385
20408	6882	1485	763111
20409	6883	1486	642772
20410	6883	1488	150922
20411	6883	1489	230610
20412	6883	1490	275964
20413	6883	1492	177884
20414	6821	1493	\N
20415	6884	1494	354322
20416	6884	1495	901603
20417	6885	1496	\N
20418	6822	1497	498238
20419	6822	1499	873808
20420	6822	1500	798993
20421	6822	1502	907997
20422	6886	1503	\N
20423	6823	1504	603048
20424	6824	1505	\N
20425	6824	1506	\N
20426	6824	1507	776556
20427	6824	1508	744932
20428	6887	1507	468771
20429	6825	1510	\N
20430	6825	1511	\N
20431	6888	1509	\N
20432	6888	1510	\N
20433	6888	1511	\N
20434	6826	1512	\N
20435	6889	1512	\N
20436	6889	1513	368090
20437	6889	1514	342619
20438	6889	1515	309092
20439	6827	1516	\N
20440	6827	1517	\N
20441	6890	1517	\N
20442	6890	1518	\N
20443	6890	1519	\N
20444	6890	1521	\N
20445	6890	1522	\N
20446	6827	1524	538152
20447	6828	1525	\N
20448	6828	1526	\N
20449	6828	1528	\N
20450	6828	1530	\N
20451	6891	1526	\N
20452	6891	1527	\N
20453	6891	1531	912515
20454	6829	1532	233135
20455	6829	1533	553978
20456	6829	1534	148538
20457	6892	1532	452906
20458	6830	1535	355621
20459	6830	1536	982548
20460	6830	1537	572395
20461	6893	1535	267318
20462	6893	1537	203829
20463	6894	1538	302582
20464	6831	1539	\N
20465	6831	1540	\N
20466	6895	1539	\N
20467	6895	1540	\N
20468	6895	1541	\N
20469	6895	1542	\N
20470	6831	1544	245307
20471	6831	1545	590234
20472	6895	1543	736537
20473	6832	1546	\N
20474	6832	1547	\N
20475	6832	1549	230494
20476	6832	1550	724881
20477	6896	1548	920539
20478	6896	1549	991669
20479	6896	1550	674205
20480	6896	1551	314497
20481	6833	1552	\N
20482	6833	1553	\N
20483	6833	1554	\N
20484	6897	1552	\N
20485	6897	1553	\N
20486	6897	1554	\N
20487	6897	1555	\N
20488	6897	1556	\N
20489	6833	1558	933758
20490	6898	1559	\N
20491	6898	1560	\N
20492	6898	1561	767880
20493	6898	1563	247926
20494	6898	1564	829101
20495	6899	1566	145682
20496	6834	1568	714767
20497	6834	1569	243064
20498	6834	1571	464939
20499	6834	1572	310529
20500	6835	1573	\N
20501	6835	1574	\N
20502	6835	1575	\N
20503	6835	1576	\N
20504	6835	1578	\N
20505	6900	1573	\N
20506	6900	1574	\N
20507	6900	1580	481164
20508	6836	1581	\N
20509	6836	1582	\N
20510	6901	1581	\N
20511	6901	1582	\N
20512	6901	1583	898404
20513	6837	1584	\N
20514	6837	1585	\N
20515	6837	1587	\N
20516	6902	1584	\N
20517	6837	1588	884149
20518	6902	1588	916145
20519	6838	1589	\N
20520	6838	1591	\N
20521	6903	1592	250565
20522	6904	1593	\N
20523	6904	1594	\N
20524	6839	1595	256154
20525	6839	1596	910416
20526	6839	1597	937323
20527	6904	1596	867255
20528	6905	1598	\N
20529	6905	1599	\N
20530	6840	1600	507527
20531	6840	1601	935095
20532	6840	1602	899148
20533	6840	1603	614745
20534	6840	1605	788041
20535	6841	1607	172070
20536	6841	1609	315502
20537	6906	1606	511969
20538	6907	1611	\N
20539	6842	1613	897875
20540	6842	1614	138885
20541	6907	1612	918073
20542	6907	1613	420879
20543	6908	1615	\N
20544	6908	1617	\N
20545	6843	1619	121820
20546	6843	1620	259295
20547	6843	1621	857943
20548	6843	1622	148870
20549	6908	1618	416122
20550	6909	1623	\N
20551	6844	1624	\N
20552	6844	1626	\N
20553	6844	1627	\N
20554	6910	1625	\N
20555	6844	1629	767482
20556	6910	1629	918944
20557	6910	1631	612799
20558	6910	1632	447018
20559	6845	1633	\N
20560	6845	1635	303262
20561	6845	1636	254740
20562	6845	1637	670064
20563	6845	1639	429824
20564	6911	1641	\N
20565	6911	1643	\N
20566	6846	1645	\N
20567	6846	1646	\N
20568	6912	1644	\N
20569	6846	1647	596136
20570	6912	1647	608478
20571	6847	1648	\N
20572	6847	1649	371446
20573	6847	1650	545837
20574	6848	1651	\N
20575	6848	1652	952350
20576	6848	1654	857555
20577	6913	1652	405615
20578	6913	1653	156669
20579	6849	1655	\N
20580	6849	1656	\N
20581	6849	1657	\N
20582	6914	1655	\N
20583	6914	1658	476455
20584	6914	1659	117325
20585	6850	1660	\N
20586	6850	1661	\N
20587	6850	1662	\N
20588	6850	1663	\N
20589	6851	1664	\N
20590	6915	1664	\N
20591	6915	1665	\N
20592	6851	1666	534019
20593	6915	1666	860830
20594	6915	1667	442217
20595	6915	1668	684447
20596	6916	1670	\N
20597	6916	1671	\N
20598	6916	1672	\N
20599	6852	1673	989002
20600	6917	1674	\N
20601	6917	1675	164342
20602	6917	1676	358253
20603	6917	1678	551748
20604	6917	1680	420800
20605	6918	1681	\N
20606	6918	1682	\N
20607	6919	1684	\N
20608	6919	1685	436164
20609	6919	1686	942061
20610	6919	1687	256480
20611	6920	1688	\N
20612	6920	1689	\N
20613	6920	1690	\N
20614	6920	1691	\N
20615	6920	1692	\N
20616	6921	1694	\N
20617	6921	1695	\N
20618	6921	1697	648788
20619	6921	1698	610559
20620	6921	1699	586206
20621	6922	1700	651908
20622	6922	1701	787608
20623	6923	1703	\N
20624	6923	1705	\N
20625	6923	1707	710706
20626	6923	1709	160078
20627	6923	1711	271767
20628	6924	1712	\N
20629	6924	1713	889220
20630	6924	1714	494486
20631	6924	1715	343023
20632	6925	1716	748365
20633	6925	1717	771049
20634	6926	1718	442355
20635	6926	1719	132646
20636	6926	1721	362890
20637	6926	1722	573106
20638	6927	1724	\N
20639	6928	1726	\N
20640	6928	1727	819592
20641	6929	1728	\N
20642	6929	1729	\N
20643	6929	1730	\N
20644	6929	1732	\N
20645	6929	1733	\N
20646	6930	1734	\N
20647	6930	1735	978707
20648	6930	1736	766039
20649	6930	1738	466134
20650	6930	1739	377193
20651	6931	1740	\N
20652	6931	1741	\N
20653	6931	1743	\N
20654	6931	1744	\N
20655	6932	1745	430946
20656	6933	1747	\N
20657	6933	1749	\N
20658	6933	1750	\N
20659	6933	1751	470733
20660	6933	1753	348290
20661	6989	1751	254405
20662	6990	1754	\N
20663	6934	1756	104365
20664	6934	1758	424310
20665	6934	1759	802737
20666	6935	1760	217089
20667	6991	1760	186727
20668	6991	1761	113448
20669	6936	1762	\N
20670	6936	1763	\N
20671	6992	1762	\N
20672	6992	1763	\N
20673	6936	1765	201571
20674	6992	1765	216673
20675	6993	1766	\N
20676	6993	1768	\N
20677	6993	1769	\N
20678	6937	1770	582551
20679	6938	1771	\N
20680	6938	1772	\N
20681	6938	1774	\N
20682	6994	1771	\N
20683	6994	1772	\N
20684	6994	1774	\N
20685	6994	1775	\N
20686	6994	1776	\N
20687	6938	1777	915621
20688	6939	1778	\N
20689	6939	1779	\N
20690	6939	1780	\N
20691	6939	1781	\N
20692	6995	1778	\N
20693	6995	1779	\N
20694	6995	1780	\N
20695	6995	1782	567842
20696	6940	1783	\N
20697	6940	1784	\N
20698	6940	1785	778680
20699	6940	1786	904986
20700	6996	1788	\N
20701	6996	1789	\N
20702	6941	1791	440574
20703	6941	1792	674526
20704	6996	1790	845849
20705	6942	1794	921715
20706	6942	1795	330593
20707	6997	1794	134101
20708	6997	1795	604829
20709	6997	1797	731746
20710	6997	1799	940112
20711	6943	1800	\N
20712	6943	1802	\N
20713	6943	1804	\N
20714	6998	1805	936549
20715	6998	1806	481366
20716	6944	1807	\N
20717	6944	1809	\N
20718	6944	1810	\N
20719	6999	1808	\N
20720	6999	1809	\N
20721	6999	1811	\N
20722	6999	1812	\N
20723	6999	1813	\N
20724	6944	1814	247136
20725	6945	1815	\N
20726	6945	1816	\N
20727	7000	1815	\N
20728	6945	1817	638372
20729	7001	1818	\N
20730	6946	1819	141901
20731	6946	1820	763476
20732	7001	1820	100210
20733	6947	1822	\N
20734	6947	1823	\N
20735	6947	1824	\N
20736	6947	1825	\N
20737	6947	1826	131057
20738	7002	1826	738159
20739	6948	1827	\N
20740	6948	1828	\N
20741	6948	1830	\N
20742	7003	1832	131822
20743	7003	1834	799844
20744	6949	1835	212289
20745	6949	1836	610160
20746	6949	1837	835231
20747	6949	1838	729656
20748	7004	1839	\N
20749	6950	1840	\N
20750	7005	1840	\N
20751	7005	1841	\N
20752	7005	1842	\N
20753	7005	1844	\N
20754	7005	1845	\N
20755	6951	1846	\N
20756	6951	1848	324420
20757	7006	1847	550331
20758	7006	1849	468148
20759	7006	1850	996771
20760	6952	1851	\N
20761	6952	1853	\N
20762	7007	1851	\N
20763	7007	1852	\N
20764	6952	1854	401738
20765	6952	1855	826607
20766	6952	1857	687470
20767	6953	1858	\N
20768	6953	1859	\N
20769	6953	1860	\N
20770	7008	1859	\N
20771	6953	1862	851483
20772	6954	1863	\N
20773	7009	1863	\N
20774	6954	1865	251549
20775	6954	1866	751495
20776	6954	1867	755317
20777	7009	1865	957914
20778	7009	1867	287716
20779	7009	1868	722107
20780	7009	1870	539521
20781	6955	1871	\N
20782	7010	1871	\N
20783	7010	1872	823108
20784	7011	1873	\N
20785	7011	1874	\N
20786	6956	1875	155746
20787	6957	1876	\N
20788	6957	1877	\N
20789	6957	1878	\N
20790	7012	1876	\N
20791	7012	1877	\N
20792	6957	1880	930426
20793	7012	1880	455789
20794	6958	1881	\N
20795	6958	1882	\N
20796	6958	1883	\N
20797	7013	1884	119886
20798	7013	1885	905061
20799	6959	1886	\N
20800	6959	1887	\N
20801	6959	1888	\N
20802	7014	1889	\N
20803	6960	1890	358871
20804	6960	1891	629384
20805	6960	1893	851499
20806	6960	1894	380117
20807	6960	1896	685287
20808	6961	1897	\N
20809	7015	1898	781047
20810	7015	1900	332791
20811	7015	1901	870143
20812	6962	1902	\N
20813	6962	1903	\N
20814	6962	1904	\N
20815	7016	1902	\N
20816	7016	1904	\N
20817	7016	1905	\N
20818	6962	1906	607275
20819	6963	1907	912819
20820	7017	1908	721411
20821	7017	1909	813959
20822	7017	1910	380533
20823	7017	1911	909415
20824	7017	1912	917919
20825	7018	1913	\N
20826	7018	1915	\N
20827	6964	1916	172905
20828	7019	1917	\N
20829	6965	1918	225190
20830	6965	1920	515546
20831	6965	1922	548235
20832	6965	1924	529905
20833	6965	1925	191891
20834	7019	1918	291911
20835	7020	1926	\N
20836	7020	1927	903640
20837	7020	1929	946346
20838	7020	1931	670257
20839	7020	1932	786611
20840	6966	1934	\N
20841	6966	1935	\N
20842	6966	1937	\N
20843	7021	1938	733755
20844	7021	1940	681228
20845	6967	1942	\N
20846	6967	1943	\N
20847	7022	1941	\N
20848	7022	1942	\N
20849	6967	1945	991286
20850	7022	1945	770985
20851	7022	1946	938654
20852	7022	1947	444343
20853	6968	1948	\N
20854	7023	1948	\N
20855	7023	1949	\N
20856	7023	1950	\N
20857	6968	1952	975640
20858	7023	1952	842949
20859	6969	1954	\N
20860	7024	1953	\N
20861	6970	1955	\N
20862	7025	1955	\N
20863	7025	1957	\N
20864	7025	1958	588007
20865	7025	1959	410582
20866	7026	1960	458047
20867	7026	1961	296991
20868	7026	1962	871513
20869	6971	1964	\N
20870	7027	1963	\N
20871	7027	1964	\N
20872	7027	1965	\N
20873	6971	1966	879982
20874	6971	1968	447999
20875	7027	1967	170833
20876	6972	1970	\N
20877	6972	1971	\N
20878	6972	1972	\N
20879	7028	1973	\N
20880	7028	1974	\N
20881	6973	1976	903976
20882	6973	1977	640532
20883	6974	1978	887336
20884	6975	1979	\N
20885	6975	1980	\N
20886	6975	1981	149243
20887	7029	1981	108773
20888	6976	1982	\N
20889	7030	1982	\N
20890	7030	1984	\N
20891	7030	1985	989702
20892	7030	1986	923611
20893	7030	1987	583149
20894	6977	1988	\N
20895	6977	1989	\N
20896	6978	1990	\N
20897	6978	1991	\N
20898	6978	1992	580982
20899	6979	1993	\N
20900	7031	1994	\N
20901	6979	1995	532390
20902	6979	1996	770140
20903	6979	1997	134376
20904	6980	1998	575167
20905	6981	1999	221396
20906	6982	0	685301
20907	6982	2	677212
20908	6982	4	393313
20909	6982	5	880829
20910	6983	6	\N
20911	6983	7	150316
20912	6983	8	724299
20913	6983	9	590532
20914	6983	10	892499
20915	6984	12	\N
20916	6984	14	\N
20917	6984	15	307457
20918	6984	16	205383
20919	6985	17	287057
20920	6986	19	\N
20921	6986	20	\N
20922	6986	21	764546
20923	6986	22	171103
20924	6987	23	122293
20925	6987	24	766807
20926	6988	25	\N
20927	6988	27	702117
20928	7032	28	\N
20929	7108	28	\N
20930	7108	29	\N
20931	7108	30	\N
20932	7108	31	\N
20933	7197	28	\N
20934	7197	29	\N
20935	7032	32	334298
20936	7109	34	\N
20937	7109	35	\N
20938	7198	34	\N
20939	7033	36	913889
20940	7033	37	942592
20941	7033	38	821367
20942	7109	36	353785
20943	7034	39	\N
20944	7034	40	\N
20945	7034	41	\N
20946	7034	42	\N
20947	7034	43	778457
20948	7110	44	\N
20949	7110	46	\N
20950	7199	44	\N
20951	7199	45	\N
20952	7199	47	\N
20953	7035	48	764186
20954	7035	50	296961
20955	7110	48	433544
20956	7110	49	166443
20957	7111	51	\N
20958	7111	52	\N
20959	7111	53	\N
20960	7200	51	\N
20961	7200	52	\N
20962	7111	54	738403
20963	7111	55	490840
20964	7036	57	\N
20965	7201	56	\N
20966	7201	58	130444
20967	7201	59	957100
20968	7037	60	\N
20969	7112	61	170193
20970	7112	62	837952
20971	7112	63	570743
20972	7112	65	289889
20973	7202	66	\N
20974	7202	67	\N
20975	7202	68	\N
20976	7202	69	\N
20977	7113	71	703673
20978	7113	72	734791
20979	7113	73	433668
20980	7113	75	177643
20981	7113	76	123081
20982	7202	70	719320
20983	7038	77	\N
20984	7038	79	\N
20985	7038	80	\N
20986	7038	81	\N
20987	7038	82	\N
20988	7203	77	\N
20989	7203	78	\N
20990	7203	79	\N
20991	7203	80	\N
20992	7039	83	\N
20993	7114	83	\N
20994	7204	84	\N
20995	7039	85	824711
20996	7114	85	795182
20997	7115	87	\N
20998	7115	88	\N
20999	7115	90	\N
21000	7205	86	\N
21001	7040	91	203570
21002	7040	93	137902
21003	7040	94	594679
21004	7115	92	586653
21005	7041	95	986079
21006	7041	96	666050
21007	7116	95	525109
21008	7116	97	394778
21009	7116	98	735377
21010	7116	99	574751
21011	7116	101	524388
21012	7042	102	\N
21013	7042	103	\N
21014	7206	102	\N
21015	7206	103	\N
21016	7042	105	625645
21017	7042	106	878526
21018	7042	107	360648
21019	7117	104	419894
21020	7206	104	960512
21021	7206	106	851914
21022	7206	107	952024
21023	7043	108	\N
21024	7118	109	448616
21025	7118	110	759668
21026	7118	111	571469
21027	7118	112	483670
21028	7207	109	357559
21029	7207	110	978169
21030	7208	113	\N
21031	7044	114	624043
21032	7119	114	675867
21033	7208	115	141078
21034	7208	116	554895
21035	7208	117	763616
21036	7208	119	968121
21037	7045	121	\N
21038	7045	122	\N
21039	7120	121	\N
21040	7120	122	\N
21041	7120	123	\N
21042	7045	124	496824
21043	7209	125	973087
21044	7046	127	\N
21045	7121	126	\N
21046	7121	128	195783
21047	7121	129	231899
21048	7121	130	170649
21049	7121	131	166071
21050	7210	128	531749
21051	7211	132	\N
21052	7211	133	\N
21053	7211	134	\N
21054	7047	135	203524
21055	7047	137	724829
21056	7047	138	271302
21057	7047	139	312117
21058	7047	141	908382
21059	7048	143	\N
21060	7122	143	\N
21061	7212	142	\N
21062	7048	144	415750
21063	7048	145	383522
21064	7048	147	976219
21065	7122	144	488322
21066	7212	144	823779
21067	7212	145	549847
21068	7123	148	\N
21069	7049	149	108444
21070	7049	150	328554
21071	7124	151	\N
21072	7124	152	\N
21073	7124	154	901999
21074	7050	155	\N
21075	7213	156	\N
21076	7050	158	239665
21077	7050	160	489457
21078	7050	162	411142
21079	7050	163	897719
21080	7051	165	\N
21081	7051	167	\N
21082	7051	168	\N
21083	7051	169	\N
21084	7214	164	\N
21085	7214	165	\N
21086	7214	171	561524
21087	7214	172	832683
21088	7052	173	\N
21089	7052	174	\N
21090	7052	175	\N
21091	7052	176	\N
21092	7125	174	\N
21093	7125	178	639733
21094	7125	180	741643
21095	7125	181	592352
21096	7215	178	269939
21097	7215	179	849169
21098	7215	180	610260
21099	7215	181	967102
21100	7215	183	177060
21101	7053	184	\N
21102	7053	185	\N
21103	7053	187	\N
21104	7053	188	\N
21105	7126	184	\N
21106	7126	185	\N
21107	7216	184	\N
21108	7126	189	540645
21109	7054	190	\N
21110	7054	192	\N
21111	7127	190	\N
21112	7217	191	\N
21113	7217	192	\N
21114	7054	193	739090
21115	7127	193	278287
21116	7055	194	\N
21117	7055	195	\N
21118	7055	196	\N
21119	7218	194	\N
21120	7055	197	428957
21121	7128	197	894786
21122	7056	198	\N
21123	7219	199	492511
21124	7219	200	720447
21125	7219	201	406980
21126	7219	202	514149
21127	7219	203	255666
21128	7220	204	\N
21129	7129	205	892366
21130	7129	206	363894
21131	7130	207	\N
21132	7057	208	565926
21133	7057	209	989835
21134	7057	210	894195
21135	7057	212	524183
21136	7057	214	725682
21137	7221	209	572033
21138	7131	215	\N
21139	7222	215	\N
21140	7222	216	\N
21141	7222	217	\N
21142	7222	218	\N
21143	7222	219	\N
21144	7132	221	\N
21145	7132	222	961006
21146	7132	223	123321
21147	7132	224	348884
21148	7223	223	336281
21149	7058	225	\N
21150	7133	225	\N
21151	7058	226	391341
21152	7133	226	571135
21153	7133	227	109412
21154	7133	229	101398
21155	7133	230	233988
21156	7224	226	494549
21157	7134	231	\N
21158	7059	232	435172
21159	7059	233	483456
21160	7059	235	745331
21161	7059	236	385205
21162	7059	237	698622
21163	7134	232	237237
21164	7135	238	\N
21165	7225	238	\N
21166	7225	239	\N
21167	7135	240	897589
21168	7226	241	\N
21169	7226	242	\N
21170	7226	243	\N
21171	7136	244	899394
21172	7226	244	260156
21173	7060	245	\N
21174	7060	246	\N
21175	7060	247	\N
21176	7137	246	\N
21177	7227	245	\N
21178	7060	248	853053
21179	7137	248	882036
21180	7137	249	520022
21181	7137	250	649501
21182	7137	251	976991
21183	7227	248	447680
21184	7138	253	\N
21185	7138	254	\N
21186	7228	252	\N
21187	7061	256	782838
21188	7062	257	\N
21189	7062	259	\N
21190	7062	260	\N
21191	7139	257	\N
21192	7139	258	\N
21193	7229	257	\N
21194	7062	261	240478
21195	7062	262	788799
21196	7139	261	512052
21197	7063	263	\N
21198	7140	263	\N
21199	7140	264	\N
21200	7230	264	\N
21201	7230	265	\N
21202	7230	266	\N
21203	7230	268	\N
21204	7063	269	916773
21205	7063	270	448034
21206	7140	270	471438
21207	7230	269	780191
21208	7064	271	\N
21209	7141	272	\N
21210	7231	271	\N
21211	7231	273	\N
21212	7231	275	\N
21213	7231	276	\N
21214	7064	278	623068
21215	7141	277	196223
21216	7141	278	334697
21217	7141	279	628475
21218	7141	280	205455
21219	7065	281	\N
21220	7142	281	\N
21221	7142	283	\N
21222	7232	282	\N
21223	7232	284	600516
21224	7066	285	\N
21225	7066	286	\N
21226	7066	287	\N
21227	7233	285	\N
21228	7143	289	996395
21229	7143	291	269626
21230	7143	293	745028
21231	7143	295	222991
21232	7143	296	716455
21233	7234	297	\N
21234	7067	298	500156
21235	7234	298	426903
21236	7234	299	746754
21237	7234	300	646538
21238	7068	301	\N
21239	7144	301	\N
21240	7144	302	\N
21241	7144	303	\N
21242	7144	304	\N
21243	7144	306	\N
21244	7235	301	\N
21245	7235	302	\N
21246	7235	303	\N
21247	7235	307	921690
21248	7236	308	\N
21249	7236	309	\N
21250	7069	310	517035
21251	7069	311	745078
21252	7145	310	286199
21253	7236	310	710471
21254	7236	311	352039
21255	7236	313	509862
21256	7146	314	\N
21257	7146	315	\N
21258	7146	316	\N
21259	7146	317	\N
21260	7237	314	\N
21261	7070	318	146119
21262	7070	319	468522
21263	7070	320	216592
21264	7146	318	246903
21265	7237	318	254706
21266	7237	319	837586
21267	7071	321	\N
21268	7071	322	\N
21269	7071	324	\N
21270	7071	326	\N
21271	7071	328	\N
21272	7147	329	811490
21273	7072	330	\N
21274	7072	331	\N
21275	7072	333	255666
21276	7148	332	873723
21277	7148	333	336108
21278	7238	332	842883
21279	7149	335	\N
21280	7239	334	\N
21281	7239	335	\N
21282	7073	337	751820
21283	7073	338	548583
21284	7149	336	734268
21285	7149	337	158954
21286	7149	338	347006
21287	7149	339	604989
21288	7239	337	468991
21289	7074	340	\N
21290	7074	341	\N
21291	7074	343	\N
21292	7074	344	\N
21293	7240	340	\N
21294	7240	342	\N
21295	7240	343	\N
21296	7240	344	\N
21297	7150	345	138143
21298	7151	346	\N
21299	7241	347	\N
21300	7241	348	\N
21301	7151	350	489760
21302	7151	351	289638
21303	7152	352	\N
21304	7152	353	\N
21305	7075	354	576328
21306	7075	355	126616
21307	7075	356	744821
21308	7152	354	807319
21309	7152	355	181808
21310	7076	358	\N
21311	7076	360	616830
21312	7076	361	727225
21313	7076	362	290676
21314	7076	363	248762
21315	7242	359	231439
21316	7242	360	183187
21317	7242	361	296761
21318	7153	364	\N
21319	7153	365	\N
21320	7243	365	\N
21321	7243	367	\N
21322	7153	368	854630
21323	7243	368	272362
21324	7243	369	853610
21325	7243	370	415270
21326	7077	371	\N
21327	7078	372	\N
21328	7244	373	\N
21329	7078	375	463853
21330	7078	376	259128
21331	7244	374	479535
21332	7245	377	\N
21333	7245	378	\N
21334	7154	379	763891
21335	7154	380	168337
21336	7154	381	639014
21337	7154	382	883862
21338	7079	384	\N
21339	7155	384	\N
21340	7246	383	\N
21341	7155	386	395882
21342	7155	387	867337
21343	7155	388	896588
21344	7156	389	\N
21345	7156	391	\N
21346	7156	393	\N
21347	7080	394	763630
21348	7247	394	820035
21349	7247	395	546018
21350	7247	397	179282
21351	7157	398	\N
21352	7157	400	\N
21353	7248	398	\N
21354	7157	401	474770
21355	7081	402	\N
21356	7081	403	\N
21357	7082	405	\N
21358	7082	406	\N
21359	7158	405	\N
21360	7158	406	\N
21361	7158	407	121184
21362	7158	408	152143
21363	7083	410	\N
21364	7249	409	\N
21365	7249	411	\N
21366	7083	412	126111
21367	7083	414	420914
21368	7083	415	317128
21369	7159	412	985941
21370	7159	413	664169
21371	7159	414	939897
21372	7159	416	172209
21373	7249	412	115966
21374	7249	413	123927
21375	7160	418	\N
21376	7084	420	452516
21377	7160	419	222528
21378	7085	421	\N
21379	7161	421	\N
21380	7161	423	\N
21381	7161	424	\N
21382	7161	425	\N
21383	7161	427	\N
21384	7085	428	471763
21385	7085	430	919866
21386	7085	431	899351
21387	7085	433	648803
21388	7162	434	\N
21389	7162	435	\N
21390	7086	436	566770
21391	7086	438	463433
21392	7086	439	841487
21393	7086	440	596728
21394	7162	436	480713
21395	7087	442	828744
21396	7087	443	790542
21397	7087	444	892800
21398	7087	445	315471
21399	7087	447	533952
21400	7088	448	\N
21401	7088	449	\N
21402	7163	448	\N
21403	7163	449	\N
21404	7088	450	870247
21405	7088	452	317831
21406	7088	453	443124
21407	7089	454	\N
21408	7089	455	\N
21409	7164	454	\N
21410	7164	455	\N
21411	7089	456	491418
21412	7090	457	\N
21413	7165	457	\N
21414	7165	459	\N
21415	7165	460	\N
21416	7165	461	\N
21417	7090	462	347363
21418	7090	463	919968
21419	7090	464	140137
21420	7090	465	974480
21421	7091	466	\N
21422	7091	467	\N
21423	7166	468	886372
21424	7167	470	540380
21425	7167	471	395454
21426	7168	473	502567
21427	7168	474	374917
21428	7168	475	810615
21429	7168	476	415266
21430	7168	477	210590
21431	7092	478	\N
21432	7092	479	\N
21433	7093	481	883646
21434	7093	483	359336
21435	7093	484	266269
21436	7169	481	689955
21437	7094	485	\N
21438	7170	485	\N
21439	7170	486	\N
21440	7094	487	185080
21441	7094	488	108506
21442	7094	489	458432
21443	7170	487	254477
21444	7170	488	693228
21445	7095	490	\N
21446	7095	491	\N
21447	7171	492	474028
21448	7171	493	506047
21449	7171	494	932779
21450	7171	496	745580
21451	7171	497	576963
21452	7096	498	\N
21453	7172	500	448091
21454	7172	501	857972
21455	7172	502	384065
21456	7097	503	\N
21457	7173	504	440609
21458	7173	506	557610
21459	7173	507	312821
21460	7173	508	242535
21461	7173	509	567216
21462	7098	510	\N
21463	7174	511	591911
21464	7174	513	616004
21465	7174	514	646591
21466	7099	515	706117
21467	7099	517	475872
21468	7100	519	\N
21469	7100	521	\N
21470	7175	519	\N
21471	7175	520	\N
21472	7175	522	\N
21473	7175	523	\N
21474	7100	524	104963
21475	7100	525	219063
21476	7100	526	196686
21477	7101	527	829844
21478	7176	527	198579
21479	7176	528	750384
21480	7177	529	\N
21481	7102	530	256216
21482	7102	531	832111
21483	7102	532	227883
21484	7177	530	823458
21485	7103	533	273000
21486	7104	535	\N
21487	7104	536	\N
21488	7178	534	\N
21489	7104	537	202888
21490	7104	538	345764
21491	7179	540	\N
21492	7179	541	\N
21493	7179	543	\N
21494	7105	544	452335
21495	7180	545	\N
21496	7106	546	\N
21497	7106	548	215446
21498	7181	547	369748
21499	7182	549	\N
21500	7182	550	\N
21501	7182	551	832798
21502	7182	552	116332
21503	7182	553	522908
21504	7183	554	\N
21505	7184	556	\N
21506	7184	557	\N
21507	7107	558	987914
21508	7107	559	510432
21509	7184	558	501423
21510	7184	559	216253
21511	7185	560	\N
21512	7185	561	568156
21513	7185	562	807180
21514	7185	564	841533
21515	7186	565	370770
21516	7186	566	214271
21517	7186	567	560783
21518	7187	569	\N
21519	7187	571	\N
21520	7187	572	\N
21521	7187	573	804853
21522	7188	575	758882
21523	7188	576	484805
21524	7188	577	673767
21525	7189	578	\N
21526	7189	580	\N
21527	7189	581	391804
21528	7190	582	529350
21529	7190	583	916128
21530	7190	585	322471
21531	7191	586	\N
21532	7191	587	\N
21533	7191	588	\N
21534	7191	589	\N
21535	7191	590	702159
21536	7192	591	555883
21537	7192	592	409857
21538	7193	594	264680
21539	7194	595	\N
21540	7195	596	\N
21541	7195	597	162103
21542	7195	599	183284
21543	7196	601	\N
21544	7196	602	728399
21545	7196	603	280945
21546	7338	604	\N
21547	7338	605	\N
21548	7250	606	912241
21549	7250	607	467284
21550	7339	608	\N
21551	7251	609	233921
21552	7251	611	126076
21553	7423	609	270792
21554	7423	610	335430
21555	7252	613	\N
21556	7252	614	\N
21557	7252	615	\N
21558	7340	617	235711
21559	7340	618	663712
21560	7424	616	755937
21561	7424	617	351412
21562	7424	618	837953
21563	7424	619	753564
21564	7424	621	480506
21565	7341	622	\N
21566	7425	623	\N
21567	7425	624	\N
21568	7425	625	\N
21569	7425	627	\N
21570	7425	629	\N
21571	7341	631	172403
21572	7341	633	913525
21573	7253	634	\N
21574	7253	635	861290
21575	7253	636	781713
21576	7253	637	455443
21577	7342	636	149004
21578	7342	638	879253
21579	7342	639	232089
21580	7426	635	785134
21581	7426	637	315834
21582	7426	638	959837
21583	7254	640	\N
21584	7254	641	\N
21585	7254	642	\N
21586	7254	643	\N
21587	7254	645	\N
21588	7343	640	\N
21589	7343	642	\N
21590	7343	644	\N
21591	7427	647	\N
21592	7427	648	459155
21593	7428	649	\N
21594	7428	650	\N
21595	7255	652	\N
21596	7429	651	\N
21597	7255	653	284784
21598	7344	653	674708
21599	7344	654	217358
21600	7256	655	\N
21601	7430	656	418645
21602	7345	657	\N
21603	7345	658	\N
21604	7257	659	395466
21605	7431	659	438563
21606	7431	660	733935
21607	7258	661	\N
21608	7346	662	204750
21609	7346	663	492370
21610	7346	664	449051
21611	7346	665	787294
21612	7432	663	935842
21613	7259	666	\N
21614	7259	667	\N
21615	7347	667	\N
21616	7347	668	\N
21617	7347	669	445810
21618	7347	671	281651
21619	7433	670	984234
21620	7260	672	\N
21621	7260	673	\N
21622	7260	674	586463
21623	7260	676	515529
21624	7434	674	113744
21625	7261	678	\N
21626	7435	677	\N
21627	7435	678	\N
21628	7435	680	\N
21629	7435	681	\N
21630	7348	682	932334
21631	7348	683	786328
21632	7348	684	467551
21633	7348	685	386841
21634	7348	686	418632
21635	7435	682	781727
21636	7262	687	\N
21637	7436	687	\N
21638	7262	688	672551
21639	7262	690	248941
21640	7262	691	144543
21641	7349	689	356693
21642	7349	690	160651
21643	7349	692	948717
21644	7349	693	362455
21645	7350	694	\N
21646	7437	694	\N
21647	7437	695	527497
21648	7437	697	625023
21649	7438	698	\N
21650	7351	700	\N
21651	7351	702	\N
21652	7439	699	\N
21653	7439	701	\N
21654	7351	703	882585
21655	7351	704	742853
21656	7440	705	\N
21657	7440	706	\N
21658	7440	707	\N
21659	7440	708	\N
21660	7263	709	564279
21661	7263	710	919457
21662	7263	712	214287
21663	7263	714	489542
21664	7440	710	961291
21665	7441	715	\N
21666	7264	717	968772
21667	7264	719	300988
21668	7264	721	305390
21669	7264	722	813224
21670	7264	723	335431
21671	7352	717	173517
21672	7352	718	192550
21673	7352	719	278837
21674	7352	720	760222
21675	7265	725	\N
21676	7442	725	\N
21677	7442	726	\N
21678	7442	727	\N
21679	7266	728	\N
21680	7266	729	\N
21681	7266	731	\N
21682	7353	728	\N
21683	7443	729	\N
21684	7353	732	573289
21685	7353	733	949836
21686	7353	734	189267
21687	7353	735	759788
21688	7443	733	864496
21689	7267	737	\N
21690	7354	736	\N
21691	7354	737	\N
21692	7354	738	\N
21693	7444	736	\N
21694	7444	737	\N
21695	7444	738	\N
21696	7267	739	800190
21697	7267	740	235641
21698	7267	741	675610
21699	7354	739	327247
21700	7354	741	933827
21701	7268	742	\N
21702	7268	743	\N
21703	7268	744	\N
21704	7268	745	\N
21705	7268	746	\N
21706	7355	742	\N
21707	7355	748	853033
21708	7445	748	939908
21709	7445	749	370458
21710	7269	750	\N
21711	7356	750	\N
21712	7269	752	180189
21713	7446	752	589744
21714	7447	753	\N
21715	7270	755	186058
21716	7357	754	497557
21717	7447	755	960504
21718	7447	756	460446
21719	7358	758	\N
21720	7271	759	945278
21721	7271	760	455432
21722	7358	760	874755
21723	7358	761	747667
21724	7448	759	217957
21725	7448	761	442159
21726	7272	762	303694
21727	7272	763	719992
21728	7272	764	627747
21729	7359	763	848791
21730	7449	762	821039
21731	7449	763	287190
21732	7449	764	820174
21733	7449	765	283388
21734	7449	767	494387
21735	7273	768	\N
21736	7273	769	\N
21737	7450	769	\N
21738	7450	770	\N
21739	7360	771	845098
21740	7360	772	420357
21741	7360	773	661762
21742	7450	771	659665
21743	7451	774	\N
21744	7361	776	232653
21745	7451	776	352002
21746	7451	777	848305
21747	7274	778	\N
21748	7362	779	\N
21749	7362	780	\N
21750	7274	781	257352
21751	7274	782	978779
21752	7362	782	555468
21753	7362	784	631050
21754	7452	781	825886
21755	7452	783	623289
21756	7452	784	872183
21757	7275	785	\N
21758	7275	786	\N
21759	7275	787	\N
21760	7453	785	\N
21761	7275	788	460961
21762	7275	789	884928
21763	7276	790	\N
21764	7276	791	\N
21765	7363	790	\N
21766	7363	792	\N
21767	7276	793	887355
21768	7363	794	164105
21769	7363	795	339713
21770	7454	794	352858
21771	7454	795	504539
21772	7454	797	718114
21773	7454	798	165292
21774	7455	799	\N
21775	7455	800	\N
21776	7455	802	\N
21777	7277	803	\N
21778	7277	804	\N
21779	7277	805	108335
21780	7364	805	513909
21781	7456	806	773248
21782	7456	808	450812
21783	7456	809	243665
21784	7456	810	841441
21785	7456	812	402925
21786	7278	813	\N
21787	7278	814	\N
21788	7278	815	\N
21789	7457	814	\N
21790	7457	815	\N
21791	7457	816	\N
21792	7457	818	\N
21793	7278	819	760361
21794	7365	819	341288
21795	7365	820	306708
21796	7457	819	966949
21797	7279	821	\N
21798	7279	823	\N
21799	7366	821	\N
21800	7366	822	\N
21801	7458	821	\N
21802	7279	824	332098
21803	7279	825	332498
21804	7366	824	309709
21805	7366	825	428000
21806	7458	824	250776
21807	7458	826	261324
21808	7367	828	\N
21809	7367	830	\N
21810	7459	828	\N
21811	7280	831	947011
21812	7280	832	432253
21813	7280	834	599529
21814	7367	831	256160
21815	7281	835	\N
21816	7368	835	\N
21817	7460	835	\N
21818	7460	836	\N
21819	7368	837	198508
21820	7460	837	227809
21821	7282	839	\N
21822	7369	838	\N
21823	7369	839	\N
21824	7282	840	627975
21825	7369	840	184424
21826	7369	841	752146
21827	7369	842	876576
21828	7461	841	755836
21829	7462	843	\N
21830	7283	845	119376
21831	7283	846	276482
21832	7283	847	834263
21833	7283	849	930197
21834	7462	845	451925
21835	7462	846	394310
21836	7284	850	\N
21837	7370	850	\N
21838	7370	851	\N
21839	7370	853	330440
21840	7371	854	\N
21841	7371	855	\N
21842	7463	854	\N
21843	7371	856	939493
21844	7371	857	940464
21845	7371	858	930669
21846	7285	859	\N
21847	7372	859	\N
21848	7372	860	\N
21849	7285	861	131832
21850	7285	862	757005
21851	7285	863	844933
21852	7464	861	398197
21853	7464	862	814377
21854	7464	863	795350
21855	7464	865	499792
21856	7373	867	\N
21857	7373	868	\N
21858	7373	869	\N
21859	7373	870	\N
21860	7465	866	\N
21861	7373	871	410114
21862	7465	871	563832
21863	7286	873	\N
21864	7286	874	\N
21865	7374	873	\N
21866	7374	875	\N
21867	7286	877	638193
21868	7286	878	165266
21869	7374	876	591059
21870	7466	876	569519
21871	7287	879	\N
21872	7375	879	\N
21873	7287	880	438285
21874	7375	880	957787
21875	7467	881	440979
21876	7288	883	\N
21877	7468	882	\N
21878	7468	884	\N
21879	7468	885	\N
21880	7468	886	\N
21881	7288	887	384952
21882	7288	889	339339
21883	7376	887	511814
21884	7376	888	134625
21885	7289	890	\N
21886	7289	891	\N
21887	7377	892	960509
21888	7469	892	895573
21889	7470	894	\N
21890	7470	895	\N
21891	7470	896	\N
21892	7470	898	\N
21893	7290	899	\N
21894	7378	900	\N
21895	7378	901	\N
21896	7378	903	\N
21897	7471	899	\N
21898	7378	904	732859
21899	7471	904	724253
21900	7471	905	982640
21901	7291	906	611407
21902	7379	907	528150
21903	7379	909	326588
21904	7379	911	564102
21905	7379	912	302078
21906	7472	906	830301
21907	7472	907	869443
21908	7292	914	\N
21909	7292	915	\N
21910	7380	913	\N
21911	7473	913	\N
21912	7292	916	228273
21913	7473	916	640448
21914	7473	918	722426
21915	7293	920	\N
21916	7381	919	\N
21917	7474	920	\N
21918	7474	921	\N
21919	7474	922	\N
21920	7293	923	853546
21921	7381	923	988710
21922	7474	923	470368
21923	7294	924	\N
21924	7294	926	\N
21925	7294	927	\N
21926	7382	924	\N
21927	7382	928	224409
21928	7475	929	297668
21929	7475	931	685609
21930	7475	932	833400
21931	7476	934	\N
21932	7476	935	\N
21933	7476	936	\N
21934	7476	938	\N
21935	7295	939	145524
21936	7295	941	654846
21937	7383	942	\N
21938	7383	944	\N
21939	7383	945	\N
21940	7477	942	\N
21941	7477	943	\N
21942	7477	944	\N
21943	7477	945	\N
21944	7383	947	611856
21945	7477	947	114578
21946	7296	948	\N
21947	7296	950	\N
21948	7296	952	\N
21949	7296	953	\N
21950	7296	954	528019
21951	7384	954	434009
21952	7384	956	775926
21953	7384	957	761251
21954	7384	958	983906
21955	7384	959	888396
21956	7478	954	832126
21957	7478	955	466404
21958	7478	956	527978
21959	7297	960	\N
21960	7297	962	\N
21961	7385	960	\N
21962	7385	962	\N
21963	7479	960	\N
21964	7479	962	\N
21965	7479	963	\N
21966	7385	964	747761
21967	7479	964	905422
21968	7479	965	770302
21969	7298	966	\N
21970	7480	966	\N
21971	7480	967	\N
21972	7480	968	463513
21973	7299	969	\N
21974	7299	971	\N
21975	7299	973	\N
21976	7386	969	\N
21977	7481	969	\N
21978	7481	970	\N
21979	7481	971	\N
21980	7299	975	907123
21981	7299	976	274411
21982	7481	974	606834
21983	7481	975	627864
21984	7300	977	\N
21985	7300	978	\N
21986	7300	979	\N
21987	7482	977	\N
21988	7300	981	245773
21989	7300	982	170871
21990	7387	981	954523
21991	7387	982	821447
21992	7387	983	712469
21993	7387	984	524843
21994	7482	981	780309
21995	7482	982	717732
21996	7482	983	749582
21997	7301	985	\N
21998	7302	986	\N
21999	7302	987	383888
22000	7388	987	738871
22001	7483	988	690394
22002	7483	990	947933
22003	7303	991	\N
22004	7303	992	\N
22005	7303	993	\N
22006	7303	994	\N
22007	7389	991	\N
22008	7484	991	\N
22009	7484	992	\N
22010	7304	995	\N
22011	7390	995	\N
22012	7390	996	\N
22013	7304	997	551753
22014	7390	997	552443
22015	7485	997	793091
22016	7485	998	569246
22017	7485	999	670370
22018	7485	1001	969152
22019	7391	1002	\N
22020	7486	1002	\N
22021	7486	1003	\N
22022	7486	1004	\N
22023	7391	1005	540718
22024	7391	1007	552507
22025	7392	1008	\N
22026	7392	1009	\N
22027	7392	1010	\N
22028	7487	1008	\N
22029	7487	1009	\N
22030	7487	1011	\N
22031	7487	1012	\N
22032	7487	1013	\N
22033	7305	1014	886262
22034	7392	1014	527686
22035	7392	1016	796980
22036	7306	1017	\N
22037	7306	1019	\N
22038	7306	1021	\N
22039	7393	1017	\N
22040	7393	1018	\N
22041	7393	1020	\N
22042	7393	1022	499863
22043	7307	1023	\N
22044	7394	1023	\N
22045	7394	1024	\N
22046	7307	1025	341499
22047	7488	1025	796245
22048	7488	1026	749460
22049	7488	1027	613286
22050	7488	1029	774326
22051	7488	1030	147464
22052	7308	1031	\N
22053	7308	1032	\N
22054	7395	1031	\N
22055	7395	1033	\N
22056	7395	1034	\N
22057	7395	1035	\N
22058	7308	1037	918491
22059	7308	1038	881299
22060	7396	1039	\N
22061	7396	1040	\N
22062	7309	1041	347268
22063	7396	1042	335378
22064	7396	1044	770287
22065	7489	1042	283351
22066	7397	1045	\N
22067	7397	1047	\N
22068	7397	1048	\N
22069	7310	1049	479581
22070	7310	1050	407917
22071	7310	1051	180073
22072	7310	1052	465558
22073	7397	1049	679817
22074	7397	1050	376648
22075	7398	1054	\N
22076	7398	1055	558963
22077	7490	1055	637086
22078	7490	1056	580036
22079	7490	1057	469925
22080	7311	1058	\N
22081	7311	1059	\N
22082	7311	1061	\N
22083	7399	1059	\N
22084	7311	1062	704681
22085	7399	1063	623621
22086	7399	1064	578878
22087	7399	1065	578770
22088	7312	1067	\N
22089	7312	1069	\N
22090	7312	1070	\N
22091	7491	1067	\N
22092	7491	1069	\N
22093	7400	1071	918051
22094	7491	1071	344764
22095	7313	1072	298291
22096	7313	1073	111622
22097	7313	1074	565852
22098	7492	1072	829205
22099	7492	1073	475259
22100	7492	1074	804456
22101	7492	1075	322382
22102	7492	1076	411152
22103	7314	1077	\N
22104	7314	1078	644917
22105	7314	1079	504400
22106	7314	1080	690092
22107	7401	1079	264371
22108	7315	1081	\N
22109	7315	1083	\N
22110	7315	1084	\N
22111	7402	1081	\N
22112	7402	1082	\N
22113	7315	1085	281287
22114	7493	1085	633569
22115	7493	1086	176784
22116	7403	1087	\N
22117	7403	1088	\N
22118	7403	1089	\N
22119	7403	1091	\N
22120	7403	1092	\N
22121	7494	1087	\N
22122	7494	1088	\N
22123	7316	1094	514128
22124	7316	1095	294698
22125	7316	1096	104931
22126	7316	1097	791063
22127	7316	1099	275954
22128	7494	1093	599867
22129	7494	1094	108934
22130	7404	1100	\N
22131	7317	1101	958623
22132	7317	1103	582239
22133	7317	1104	836756
22134	7317	1105	847719
22135	7404	1102	100754
22136	7404	1103	865103
22137	7404	1104	985588
22138	7495	1101	143131
22139	7495	1102	699811
22140	7495	1104	335970
22141	7318	1106	\N
22142	7318	1107	\N
22143	7318	1109	\N
22144	7318	1111	428634
22145	7405	1113	\N
22146	7405	1114	\N
22147	7405	1115	\N
22148	7405	1117	\N
22149	7496	1112	\N
22150	7496	1114	\N
22151	7496	1116	\N
22152	7496	1117	\N
22153	7319	1118	612895
22154	7405	1118	265673
22155	7496	1118	478457
22156	7320	1119	\N
22157	7320	1120	\N
22158	7406	1120	\N
22159	7406	1121	\N
22160	7497	1120	\N
22161	7497	1121	\N
22162	7497	1123	\N
22163	7497	1125	\N
22164	7497	1126	\N
22165	7320	1128	974375
22166	7320	1129	820994
22167	7320	1131	457968
22168	7406	1128	229448
22169	7321	1133	\N
22170	7321	1134	\N
22171	7321	1135	\N
22172	7321	1136	\N
22173	7321	1137	\N
22174	7407	1138	619530
22175	7407	1140	516914
22176	7498	1139	327712
22177	7408	1142	\N
22178	7499	1141	\N
22179	7499	1143	849187
22180	7499	1144	258122
22181	7322	1145	\N
22182	7322	1146	\N
22183	7322	1148	\N
22184	7409	1145	\N
22185	7500	1145	\N
22186	7500	1146	\N
22187	7500	1147	\N
22188	7322	1149	551152
22189	7410	1150	\N
22190	7410	1151	\N
22191	7410	1152	\N
22192	7410	1153	\N
22193	7411	1154	\N
22194	7501	1155	\N
22195	7323	1156	673242
22196	7323	1158	311733
22197	7323	1160	411877
22198	7323	1162	127311
22199	7323	1163	725920
22200	7501	1156	322515
22201	7501	1157	691389
22202	7412	1164	\N
22203	7324	1165	932723
22204	7324	1166	586377
22205	7324	1167	369939
22206	7324	1168	858539
22207	7324	1169	607889
22208	7502	1171	\N
22209	7325	1173	568255
22210	7413	1172	894163
22211	7502	1172	972057
22212	7502	1173	338315
22213	7502	1175	350763
22214	7503	1176	\N
22215	7326	1177	844109
22216	7326	1178	335962
22217	7326	1180	494199
22218	7414	1177	911413
22219	7414	1178	803036
22220	7503	1177	206041
22221	7327	1181	\N
22222	7327	1182	\N
22223	7327	1183	\N
22224	7415	1184	828498
22225	7504	1184	617389
22226	7504	1185	638910
22227	7504	1186	545485
22228	7504	1187	310208
22229	7328	1188	571782
22230	7329	1189	\N
22231	7329	1191	\N
22232	7329	1192	\N
22233	7329	1193	\N
22234	7329	1194	\N
22235	7330	1196	\N
22236	7416	1195	\N
22237	7330	1197	609791
22238	7505	1198	519526
22239	7331	1199	\N
22240	7331	1201	\N
22241	7331	1202	954812
22242	7417	1202	104186
22243	7417	1203	925371
22244	7332	1204	\N
22245	7506	1204	\N
22246	7332	1205	169620
22247	7333	1206	\N
22248	7333	1207	\N
22249	7507	1206	\N
22250	7333	1208	858408
22251	7418	1208	137634
22252	7507	1209	591566
22253	7334	1211	\N
22254	7334	1212	\N
22255	7334	1213	\N
22256	7334	1214	\N
22257	7334	1215	\N
22258	7508	1216	425565
22259	7508	1217	557983
22260	7335	1218	\N
22261	7335	1219	\N
22262	7419	1219	\N
22263	7419	1220	\N
22264	7419	1221	\N
22265	7419	1222	\N
22266	7420	1223	\N
22267	7420	1224	\N
22268	7420	1225	\N
22269	7420	1226	\N
22270	7420	1227	\N
22271	7509	1228	245841
22272	7509	1229	564049
22273	7509	1230	639133
22274	7509	1231	234593
22275	7509	1232	688973
22276	7336	1234	\N
22277	7336	1235	\N
22278	7510	1233	\N
22279	7510	1235	\N
22280	7510	1236	\N
22281	7510	1237	\N
22282	7510	1238	\N
22283	7336	1239	700212
22284	7421	1239	483059
22285	7421	1240	323788
22286	7337	1241	327634
22287	7422	1241	391184
22288	7511	1243	\N
22289	7561	1242	\N
22290	7511	1244	908158
22291	7561	1244	830171
22292	7562	1245	\N
22293	7562	1246	\N
22294	7512	1247	386026
22295	7512	1248	472722
22296	7512	1250	809145
22297	7512	1251	219975
22298	7562	1247	222704
22299	7562	1248	400045
22300	7513	1253	\N
22301	7513	1254	\N
22302	7513	1255	\N
22303	7513	1256	\N
22304	7513	1257	\N
22305	7563	1258	517352
22306	7514	1259	\N
22307	7514	1260	254955
22308	7564	1260	805629
22309	7565	1261	\N
22310	7515	1262	436625
22311	7515	1263	310741
22312	7516	1265	\N
22313	7516	1266	\N
22314	7516	1267	\N
22315	7516	1269	\N
22316	7516	1270	\N
22317	7566	1271	406504
22318	7517	1272	\N
22319	7567	1273	\N
22320	7567	1274	\N
22321	7567	1275	\N
22322	7517	1276	316803
22323	7568	1277	\N
22324	7568	1278	\N
22325	7518	1279	\N
22326	7518	1280	\N
22327	7518	1281	\N
22328	7569	1279	\N
22329	7569	1280	\N
22330	7569	1281	\N
22331	7569	1282	\N
22332	7570	1283	\N
22333	7570	1285	\N
22334	7570	1287	595607
22335	7570	1288	450447
22336	7570	1289	487503
22337	7519	1291	\N
22338	7519	1292	\N
22339	7519	1293	\N
22340	7519	1295	\N
22341	7519	1296	\N
22342	7571	1290	\N
22343	7520	1297	293333
22344	7520	1298	926516
22345	7572	1300	\N
22346	7521	1301	757527
22347	7572	1301	387234
22348	7522	1302	\N
22349	7573	1302	\N
22350	7523	1303	109172
22351	7523	1305	612774
22352	7524	1306	\N
22353	7524	1307	\N
22354	7574	1307	\N
22355	7524	1309	133223
22356	7574	1309	504931
22357	7574	1310	843094
22358	7525	1312	\N
22359	7525	1313	\N
22360	7575	1311	\N
22361	7575	1312	\N
22362	7575	1313	\N
22363	7575	1314	807620
22364	7575	1315	739323
22365	7576	1316	\N
22366	7526	1317	729746
22367	7526	1318	352549
22368	7527	1319	\N
22369	7577	1320	\N
22370	7577	1321	\N
22371	7527	1322	675881
22372	7577	1322	433034
22373	7578	1324	\N
22374	7578	1325	\N
22375	7578	1326	\N
22376	7578	1327	\N
22377	7578	1328	\N
22378	7528	1329	\N
22379	7579	1331	374190
22380	7579	1332	697896
22381	7529	1334	\N
22382	7529	1335	\N
22383	7529	1336	203309
22384	7580	1337	168137
22385	7580	1338	685783
22386	7530	1339	\N
22387	7530	1340	\N
22388	7530	1342	\N
22389	7530	1344	\N
22390	7581	1340	\N
22391	7581	1341	\N
22392	7582	1345	\N
22393	7582	1346	\N
22394	7582	1347	524655
22395	7582	1348	629555
22396	7583	1349	568916
22397	7531	1351	\N
22398	7531	1352	\N
22399	7531	1353	\N
22400	7531	1355	\N
22401	7584	1351	\N
22402	7584	1353	\N
22403	7584	1355	\N
22404	7584	1356	\N
22405	7584	1358	231982
22406	7532	1360	\N
22407	7532	1361	\N
22408	7532	1363	\N
22409	7585	1359	\N
22410	7585	1364	598764
22411	7533	1366	\N
22412	7533	1367	\N
22413	7533	1368	\N
22414	7533	1370	\N
22415	7586	1366	\N
22416	7533	1371	485371
22417	7586	1371	606670
22418	7534	1372	456248
22419	7534	1373	459702
22420	7587	1372	264647
22421	7588	1375	\N
22422	7588	1377	\N
22423	7588	1378	\N
22424	7588	1379	554998
22425	7588	1380	328867
22426	7589	1381	\N
22427	7535	1382	495067
22428	7535	1383	126717
22429	7535	1384	609156
22430	7589	1382	249009
22431	7536	1385	\N
22432	7536	1386	\N
22433	7590	1385	\N
22434	7536	1388	827209
22435	7537	1389	\N
22436	7591	1390	\N
22437	7591	1391	\N
22438	7591	1392	\N
22439	7537	1393	662546
22440	7537	1394	395905
22441	7537	1396	879995
22442	7591	1393	353516
22443	7592	1397	\N
22444	7538	1399	\N
22445	7593	1398	\N
22446	7593	1399	\N
22447	7593	1401	\N
22448	7593	1402	\N
22449	7593	1404	201313
22450	7539	1405	\N
22451	7594	1406	\N
22452	7594	1407	\N
22453	7540	1408	589294
22454	7540	1410	485164
22455	7540	1411	590550
22456	7541	1413	639811
22457	7541	1415	997642
22458	7542	1416	\N
22459	7543	1418	\N
22460	7543	1419	\N
22461	7543	1420	\N
22462	7543	1421	\N
22463	7595	1422	\N
22464	7595	1424	\N
22465	7544	1426	\N
22466	7544	1427	\N
22467	7596	1425	\N
22468	7544	1428	900064
22469	7596	1428	619342
22470	7597	1430	\N
22471	7545	1431	744939
22472	7545	1433	817446
22473	7546	1435	\N
22474	7546	1436	\N
22475	7598	1434	\N
22476	7546	1437	181874
22477	7546	1438	804964
22478	7598	1438	718310
22479	7547	1439	\N
22480	7547	1440	\N
22481	7547	1442	\N
22482	7599	1444	209029
22483	7548	1445	\N
22484	7548	1446	\N
22485	7549	1447	\N
22486	7600	1448	\N
22487	7549	1449	913041
22488	7549	1450	463733
22489	7549	1451	589621
22490	7549	1452	548045
22491	7600	1450	895006
22492	7600	1451	945227
22493	7600	1452	126195
22494	7600	1453	709623
22495	7601	1455	\N
22496	7601	1456	\N
22497	7601	1457	\N
22498	7601	1458	\N
22499	7601	1459	\N
22500	7550	1460	\N
22501	7550	1461	\N
22502	7550	1462	\N
22503	7602	1460	\N
22504	7602	1461	\N
22505	7550	1464	431002
22506	7602	1463	143993
22507	7603	1466	\N
22508	7603	1467	\N
22509	7603	1468	\N
22510	7551	1469	683147
22511	7552	1471	\N
22512	7604	1471	\N
22513	7604	1472	\N
22514	7552	1473	178499
22515	7552	1474	288017
22516	7552	1475	187496
22517	7552	1476	309336
22518	7604	1473	463643
22519	7604	1474	869062
22520	7604	1476	402170
22521	7553	1477	\N
22522	7554	1478	\N
22523	7554	1479	\N
22524	7554	1480	\N
22525	7605	1479	\N
22526	7605	1481	\N
22527	7554	1482	469495
22528	7605	1482	377081
22529	7555	1484	\N
22530	7606	1483	\N
22531	7555	1485	824554
22532	7606	1485	438501
22533	7606	1487	812191
22534	7556	1489	\N
22535	7556	1491	\N
22536	7556	1492	\N
22537	7556	1493	\N
22538	7607	1488	\N
22539	7607	1489	\N
22540	7607	1495	938379
22541	7607	1497	259763
22542	7607	1498	345724
22543	7557	1500	\N
22544	7557	1502	\N
22545	7557	1503	\N
22546	7608	1504	773366
22547	7608	1506	632608
22548	7608	1507	707609
22549	7608	1508	355793
22550	7558	1509	\N
22551	7609	1510	\N
22552	7609	1511	\N
22553	7558	1513	359476
22554	7558	1514	271340
22555	7559	1515	733644
22556	7610	1515	189893
22557	7610	1517	682805
22558	7610	1518	807893
22559	7610	1519	699042
22560	7560	1520	\N
22561	7611	1520	\N
22562	7611	1522	474446
22563	7611	1524	350522
22564	7611	1525	560536
22565	7612	1526	642399
22566	7612	1527	529410
22567	7613	1528	\N
22568	7613	1529	\N
22569	7614	1530	\N
22570	7614	1532	831365
22571	7615	1534	306453
22572	7616	1535	\N
22573	7616	1536	\N
22574	7616	1537	162967
22575	7616	1538	283171
22576	7616	1539	994609
22577	7617	1540	\N
22578	7618	1542	\N
22579	7618	1543	\N
22580	7618	1545	\N
22581	7619	1546	\N
22582	7619	1547	294305
22583	7619	1549	894248
22584	7619	1550	567727
22585	7619	1552	540092
22586	7620	1553	\N
22587	7620	1555	793012
22588	7620	1556	965216
22589	7620	1557	661039
22590	7621	1558	289456
22591	7621	1559	782956
22592	7621	1561	324288
22593	7622	1563	\N
22594	7622	1565	\N
22595	7622	1566	\N
22596	7622	1567	\N
22597	7622	1569	134104
22598	7623	1570	\N
22599	7623	1571	868562
22600	7623	1572	462596
22601	7624	1573	\N
22602	7624	1575	\N
22603	7624	1577	\N
22604	7624	1578	329488
22605	7625	1579	\N
22606	7625	1581	\N
22607	7625	1582	711829
22608	7626	1584	\N
22609	7626	1585	\N
22610	7627	1586	711407
22611	7628	1587	\N
22612	7628	1588	\N
22613	7628	1589	535088
22614	7628	1590	705502
22615	7628	1591	743155
22616	7629	1592	\N
22617	7629	1593	\N
22618	7629	1595	797837
22619	7630	1597	\N
22620	7631	1598	\N
22621	7631	1599	728298
22622	7631	1600	590852
22623	7631	1602	996933
22624	7631	1603	122076
22625	7632	1604	\N
22626	7633	1605	140087
22627	7633	1606	702109
22628	7633	1607	933904
22629	7633	1609	961361
22630	7634	1610	\N
22631	7634	1612	\N
22632	7634	1613	\N
22633	7634	1614	916670
22634	7635	1616	\N
22635	7635	1617	\N
22636	7635	1618	382503
22637	7635	1619	328931
22638	7635	1620	361355
22639	7636	1622	\N
22640	7636	1623	\N
22641	7636	1625	\N
22642	7636	1626	\N
22643	7637	1627	\N
22644	7637	1628	778921
22645	7638	1629	777541
22646	7638	1630	550021
22647	7639	1631	219731
22648	7639	1632	591608
22649	7639	1634	919347
22650	7640	1635	\N
22651	7641	1636	\N
22652	7641	1638	259666
22653	7641	1639	540631
22654	7641	1641	782926
22655	7642	1642	723857
22656	7642	1643	555973
22657	7643	1644	\N
22658	7644	1645	\N
22659	7644	1646	\N
22660	7644	1647	\N
22661	7644	1648	\N
22662	7645	1649	\N
22663	7645	1650	\N
22664	7645	1651	\N
22665	7711	1652	\N
22666	7711	1653	\N
22667	7646	1654	\N
22668	7712	1654	\N
22669	7646	1656	433113
22670	7646	1657	337171
22671	7712	1656	139162
22672	7712	1657	801072
22673	7712	1658	240418
22674	7712	1660	123565
22675	7647	1661	\N
22676	7713	1662	\N
22677	7713	1663	\N
22678	7713	1665	\N
22679	7647	1666	164142
22680	7647	1668	267386
22681	7647	1670	527186
22682	7647	1671	521062
22683	7713	1666	176154
22684	7648	1672	\N
22685	7714	1672	\N
22686	7714	1673	\N
22687	7648	1675	597932
22688	7648	1676	510211
22689	7648	1677	274858
22690	7648	1679	406654
22691	7714	1674	246825
22692	7714	1676	769907
22693	7714	1677	940213
22694	7649	1680	231465
22695	7649	1681	553529
22696	7649	1682	448539
22697	7649	1683	432216
22698	7715	1681	154988
22699	7650	1684	\N
22700	7650	1685	930050
22701	7650	1686	534743
22702	7716	1685	965230
22703	7651	1687	\N
22704	7651	1689	\N
22705	7717	1687	\N
22706	7717	1690	448092
22707	7717	1691	961010
22708	7717	1692	192172
22709	7717	1693	446520
22710	7652	1694	\N
22711	7718	1694	\N
22712	7718	1695	\N
22713	7718	1696	\N
22714	7653	1698	\N
22715	7653	1699	\N
22716	7719	1697	\N
22717	7719	1698	\N
22718	7719	1699	\N
22719	7719	1700	839935
22720	7719	1701	876755
22721	7654	1703	\N
22722	7654	1704	\N
22723	7720	1702	\N
22724	7720	1704	\N
22725	7720	1705	\N
22726	7654	1706	639819
22727	7654	1707	467767
22728	7721	1709	165479
22729	7721	1710	190636
22730	7655	1711	\N
22731	7655	1713	\N
22732	7655	1714	366550
22733	7656	1715	\N
22734	7656	1716	\N
22735	7722	1715	\N
22736	7656	1718	663313
22737	7657	1719	\N
22738	7723	1719	\N
22739	7657	1721	164469
22740	7657	1722	536201
22741	7657	1723	516381
22742	7657	1724	604059
22743	7723	1720	891982
22744	7723	1721	658697
22745	7723	1722	925238
22746	7723	1723	648370
22747	7658	1726	\N
22748	7724	1727	115928
22749	7724	1728	421786
22750	7724	1729	367524
22751	7724	1731	749437
22752	7724	1733	862671
22753	7659	1734	185251
22754	7659	1735	245371
22755	7659	1737	277679
22756	7659	1739	928302
22757	7659	1740	129233
22758	7725	1734	548190
22759	7725	1735	138642
22760	7660	1741	979529
22761	7726	1741	334674
22762	7726	1743	937199
22763	7661	1744	\N
22764	7661	1746	\N
22765	7661	1747	\N
22766	7661	1748	\N
22767	7727	1744	\N
22768	7727	1749	115579
22769	7662	1750	446834
22770	7728	1750	663162
22771	7728	1751	175567
22772	7728	1752	245669
22773	7663	1753	\N
22774	7663	1755	730541
22775	7729	1755	714643
22776	7729	1757	187004
22777	7729	1759	157596
22778	7729	1761	834568
22779	7729	1762	962504
22780	7664	1764	\N
22781	7730	1763	\N
22782	7730	1764	\N
22783	7730	1766	\N
22784	7665	1767	\N
22785	7731	1767	\N
22786	7731	1768	\N
22787	7731	1769	\N
22788	7731	1770	\N
22789	7731	1771	\N
22790	7665	1772	234102
22791	7665	1773	601381
22792	7666	1774	\N
22793	7732	1774	\N
22794	7732	1776	467063
22795	7732	1777	821403
22796	7733	1779	\N
22797	7733	1780	\N
22798	7667	1782	846129
22799	7667	1783	528370
22800	7667	1784	563382
22801	7667	1785	162013
22802	7668	1786	258164
22803	7668	1787	860306
22804	7668	1788	846705
22805	7668	1789	869516
22806	7668	1790	615447
22807	7734	1786	777996
22808	7734	1787	601784
22809	7735	1792	\N
22810	7669	1794	799687
22811	7669	1795	512598
22812	7670	1797	\N
22813	7670	1798	\N
22814	7670	1799	\N
22815	7670	1800	615107
22816	7670	1801	883896
22817	7671	1803	\N
22818	7671	1804	\N
22819	7671	1805	626613
22820	7671	1807	864232
22821	7736	1805	434809
22822	7672	1808	\N
22823	7672	1809	\N
22824	7737	1808	\N
22825	7672	1810	303721
22826	7672	1811	397946
22827	7673	1813	\N
22828	7673	1814	\N
22829	7673	1815	\N
22830	7673	1816	529180
22831	7673	1817	972898
22832	7674	1819	\N
22833	7738	1818	\N
22834	7738	1820	\N
22835	7738	1821	790397
22836	7738	1822	100917
22837	7675	1823	\N
22838	7739	1824	327641
22839	7740	1826	\N
22840	7740	1827	\N
22841	7740	1828	582468
22842	7740	1829	677462
22843	7740	1830	272765
22844	7676	1832	\N
22845	7676	1834	\N
22846	7676	1835	101275
22847	7676	1836	594814
22848	7677	1837	\N
22849	7741	1837	\N
22850	7741	1839	\N
22851	7741	1841	\N
22852	7741	1842	\N
22853	7677	1843	862347
22854	7677	1844	722952
22855	7677	1845	486335
22856	7677	1847	615821
22857	7741	1843	820414
22858	7742	1848	\N
22859	7742	1850	\N
22860	7742	1852	991598
22861	7743	1853	\N
22862	7743	1854	\N
22863	7743	1856	\N
22864	7678	1857	702195
22865	7678	1858	406114
22866	7678	1860	375113
22867	7678	1862	332171
22868	7678	1863	447182
22869	7679	1865	694851
22870	7680	1866	\N
22871	7681	1867	\N
22872	7681	1868	\N
22873	7681	1869	681660
22874	7682	1870	\N
22875	7682	1871	\N
22876	7682	1873	913073
22877	7683	1874	\N
22878	7683	1875	\N
22879	7683	1877	279698
22880	7684	1879	\N
22881	7684	1880	117766
22882	7684	1882	678026
22883	7684	1883	589241
22884	7684	1884	233881
22885	7685	1885	\N
22886	7686	1887	429234
22887	7686	1889	416563
22888	7686	1890	690903
22889	7686	1892	576497
22890	7687	1893	242795
22891	7687	1894	343347
22892	7687	1895	139639
22893	7688	1896	\N
22894	7689	1897	548340
22895	7689	1898	998019
22896	7689	1899	708083
22897	7690	1901	\N
22898	7690	1902	\N
22899	7690	1903	221587
22900	7691	1904	780294
22901	7691	1906	886921
22902	7691	1907	712230
22903	7691	1909	791806
22904	7692	1910	218153
22905	7692	1911	642162
22906	7693	1913	206661
22907	7693	1914	550267
22908	7693	1915	294816
22909	7694	1917	\N
22910	7694	1918	\N
22911	7694	1919	789703
22912	7694	1920	896375
22913	7695	1921	\N
22914	7695	1923	494955
22915	7695	1925	311720
22916	7695	1926	872230
22917	7695	1927	941113
22918	7696	1929	\N
22919	7696	1930	\N
22920	7696	1931	\N
22921	7697	1933	\N
22922	7698	1934	\N
22923	7698	1935	\N
22924	7698	1936	\N
22925	7699	1937	\N
22926	7699	1938	990048
22927	7699	1939	865808
22928	7699	1940	770050
22929	7700	1941	\N
22930	7700	1942	\N
22931	7700	1943	\N
22932	7700	1944	\N
22933	7701	1945	\N
22934	7701	1946	\N
22935	7701	1948	\N
22936	7702	1950	692850
22937	7703	1952	\N
22938	7704	1953	\N
22939	7704	1954	409251
22940	7705	1956	\N
22941	7705	1957	314470
22942	7706	1958	512466
22943	7707	1959	\N
22944	7707	1960	\N
22945	7707	1961	843435
22946	7707	1963	539144
22947	7708	1964	226532
22948	7708	1965	427395
22949	7708	1966	411701
22950	7708	1967	603286
22951	7709	1968	\N
22952	7709	1969	815542
22953	7709	1970	533051
22954	7709	1972	687050
22955	7710	1973	\N
22956	7823	1974	\N
22957	7823	1975	\N
22958	7904	1975	\N
22959	7904	1976	\N
22960	7904	1977	247045
22961	7744	1979	\N
22962	7744	1980	\N
22963	7744	1981	\N
22964	7744	1982	\N
22965	7744	1984	131532
22966	7824	1984	287231
22967	7905	1983	882727
22968	7905	1984	722722
22969	7745	1985	\N
22970	7745	1986	\N
22971	7906	1985	\N
22972	7825	1988	396611
22973	7906	1987	479963
22974	7906	1988	453979
22975	7906	1990	239174
22976	7746	1991	\N
22977	7746	1992	\N
22978	7826	1991	\N
22979	7826	1992	\N
22980	7907	1991	\N
22981	7746	1993	867056
22982	7746	1994	640834
22983	7826	1993	949931
22984	7907	1993	424006
22985	7907	1994	368502
22986	7907	1995	536513
22987	7747	1997	\N
22988	7747	1998	\N
22989	7747	1999	989959
22990	7747	0	892404
22991	7747	1	653837
22992	7827	0	771348
22993	7827	2	487917
22994	7827	3	758851
22995	7908	1999	554880
22996	7909	4	\N
22997	7909	5	\N
22998	7748	6	573469
22999	7828	6	811032
23000	7828	8	452348
23001	7828	9	506387
23002	7828	10	700857
23003	7828	12	478984
23004	7909	6	566627
23005	7749	13	\N
23006	7749	14	\N
23007	7829	14	\N
23008	7829	15	\N
23009	7829	17	\N
23010	7829	18	\N
23011	7829	19	\N
23012	7750	20	\N
23013	7910	20	\N
23014	7750	21	983800
23015	7751	22	\N
23016	7751	23	\N
23017	7751	24	\N
23018	7830	22	\N
23019	7830	23	\N
23020	7830	24	\N
23021	7830	25	639940
23022	7831	27	\N
23023	7752	28	844697
23024	7831	28	350476
23025	7831	30	515440
23026	7831	31	824734
23027	7831	33	151607
23028	7832	34	\N
23029	7911	34	\N
23030	7911	36	\N
23031	7832	38	309592
23032	7753	40	\N
23033	7753	41	\N
23034	7833	39	\N
23035	7833	41	\N
23036	7753	42	706581
23037	7833	42	314450
23038	7833	43	338736
23039	7833	44	407622
23040	7834	46	\N
23041	7754	48	640207
23042	7754	50	720603
23043	7754	51	642730
23044	7834	47	449673
23045	7834	48	484303
23046	7834	49	118303
23047	7755	52	\N
23048	7835	52	\N
23049	7835	53	\N
23050	7912	52	\N
23051	7912	54	\N
23052	7912	55	\N
23053	7755	56	593478
23054	7835	56	636461
23055	7756	57	\N
23056	7756	58	\N
23057	7756	60	\N
23058	7913	58	\N
23059	7913	60	\N
23060	7756	61	139265
23061	7756	63	526892
23062	7836	61	332225
23063	7913	61	585443
23064	7757	64	\N
23065	7757	65	\N
23066	7837	64	\N
23067	7914	64	\N
23068	7914	65	\N
23069	7914	67	\N
23070	7837	69	922702
23071	7837	70	810621
23072	7914	68	377444
23073	7758	72	\N
23074	7758	73	\N
23075	7838	71	\N
23076	7758	74	317499
23077	7758	76	293833
23078	7758	77	159801
23079	7915	74	420084
23080	7915	75	107509
23081	7915	76	583224
23082	7915	77	372096
23083	7759	79	\N
23084	7759	80	\N
23085	7916	78	\N
23086	7916	79	\N
23087	7916	80	\N
23088	7916	81	\N
23089	7759	82	581872
23090	7839	83	422483
23091	7839	84	937226
23092	7839	85	338881
23093	7839	87	252650
23094	7760	89	\N
23095	7840	89	\N
23096	7917	88	\N
23097	7917	89	\N
23098	7760	90	122378
23099	7840	91	124589
23100	7917	91	728458
23101	7761	92	\N
23102	7841	93	\N
23103	7841	94	\N
23104	7841	96	\N
23105	7841	98	\N
23106	7918	92	\N
23107	7918	93	\N
23108	7761	99	848592
23109	7761	100	336975
23110	7841	99	449754
23111	7918	99	397579
23112	7762	102	\N
23113	7842	101	\N
23114	7842	102	\N
23115	7762	103	188668
23116	7762	104	219463
23117	7842	103	913151
23118	7763	105	\N
23119	7763	107	\N
23120	7763	108	\N
23121	7763	109	\N
23122	7763	110	\N
23123	7843	105	\N
23124	7843	106	\N
23125	7843	108	\N
23126	7919	105	\N
23127	7919	106	\N
23128	7843	111	750754
23129	7843	112	339751
23130	7919	112	257809
23131	7764	113	\N
23132	7764	114	\N
23133	7764	115	\N
23134	7764	117	653334
23135	7764	119	206546
23136	7844	116	381529
23137	7844	118	211464
23138	7844	119	578128
23139	7765	120	\N
23140	7845	121	\N
23141	7845	122	\N
23142	7845	123	\N
23143	7845	124	\N
23144	7765	125	142242
23145	7765	126	197359
23146	7765	127	618829
23147	7920	125	746373
23148	7920	127	446526
23149	7920	129	295222
23150	7766	130	\N
23151	7921	130	\N
23152	7846	132	272674
23153	7846	133	475137
23154	7846	135	613046
23155	7846	136	686173
23156	7921	131	490495
23157	7921	132	853411
23158	7767	137	\N
23159	7767	138	508342
23160	7767	140	265711
23161	7847	138	771331
23162	7847	139	705719
23163	7847	141	490868
23164	7922	139	979729
23165	7922	140	295632
23166	7922	141	168678
23167	7768	142	\N
23168	7848	142	\N
23169	7848	144	\N
23170	7923	143	\N
23171	7923	144	\N
23172	7923	145	\N
23173	7768	147	563747
23174	7768	149	551413
23175	7768	150	978995
23176	7848	147	905325
23177	7848	148	304116
23178	7923	146	506659
23179	7923	148	608845
23180	7769	151	\N
23181	7769	153	716701
23182	7849	152	926321
23183	7924	152	387994
23184	7770	154	\N
23185	7850	155	866558
23186	7850	156	957166
23187	7925	155	620647
23188	7925	157	412492
23189	7771	159	620301
23190	7926	158	324777
23191	7926	159	762657
23192	7926	160	952521
23193	7851	161	\N
23194	7851	162	\N
23195	7851	163	\N
23196	7927	161	\N
23197	7927	162	\N
23198	7772	164	\N
23199	7772	165	913429
23200	7773	167	\N
23201	7852	167	\N
23202	7928	167	\N
23203	7928	168	\N
23204	7928	169	\N
23205	7928	170	\N
23206	7773	171	890157
23207	7929	173	\N
23208	7774	175	931595
23209	7774	176	342663
23210	7774	177	604491
23211	7853	178	\N
23212	7853	179	\N
23213	7853	180	\N
23214	7853	181	\N
23215	7930	178	\N
23216	7930	179	\N
23217	7775	183	185461
23218	7775	184	178423
23219	7775	186	104781
23220	7775	188	524880
23221	7853	182	502451
23222	7776	189	\N
23223	7854	189	\N
23224	7854	190	\N
23225	7931	189	\N
23226	7776	192	241343
23227	7776	194	841815
23228	7776	195	166085
23229	7776	196	613539
23230	7854	191	815389
23231	7855	197	\N
23232	7855	198	\N
23233	7855	200	\N
23234	7855	201	\N
23235	7932	197	\N
23236	7932	198	\N
23237	7932	199	\N
23238	7932	200	\N
23239	7932	202	\N
23240	7856	203	\N
23241	7856	204	\N
23242	7856	205	\N
23243	7933	203	\N
23244	7933	204	\N
23245	7933	206	\N
23246	7777	207	163090
23247	7777	208	193290
23248	7777	209	512016
23249	7777	210	784854
23250	7933	207	857518
23251	7933	208	859973
23252	7857	211	\N
23253	7934	212	\N
23254	7778	213	601729
23255	7857	214	396674
23256	7857	215	754881
23257	7934	214	874542
23258	7779	217	\N
23259	7779	218	471045
23260	7779	219	970614
23261	7779	220	705546
23262	7779	221	552194
23263	7858	219	199977
23264	7780	222	\N
23265	7859	222	\N
23266	7859	223	\N
23267	7859	224	\N
23268	7780	226	404834
23269	7780	227	539624
23270	7935	225	600582
23271	7935	226	238511
23272	7781	229	\N
23273	7860	228	\N
23274	7860	229	\N
23275	7860	231	\N
23276	7860	232	\N
23277	7860	233	\N
23278	7936	228	\N
23279	7781	234	736465
23280	7936	234	301273
23281	7782	236	\N
23282	7861	235	\N
23283	7937	235	\N
23284	7937	236	\N
23285	7861	238	886790
23286	7861	239	222708
23287	7783	240	\N
23288	7862	241	\N
23289	7862	243	673062
23290	7862	244	335984
23291	7862	246	979766
23292	7938	242	960831
23293	7863	247	\N
23294	7939	248	\N
23295	7939	249	\N
23296	7939	250	\N
23297	7939	251	\N
23298	7784	252	828721
23299	7864	252	633508
23300	7785	253	\N
23301	7785	254	\N
23302	7785	255	\N
23303	7865	253	\N
23304	7865	254	\N
23305	7865	256	\N
23306	7940	257	328705
23307	7940	258	218168
23308	7940	260	645491
23309	7786	261	\N
23310	7786	263	\N
23311	7786	264	\N
23312	7866	262	\N
23313	7866	264	\N
23314	7941	261	\N
23315	7786	265	666532
23316	7786	267	604999
23317	7867	269	\N
23318	7942	268	\N
23319	7942	270	124060
23320	7942	271	494266
23321	7942	273	836554
23322	7943	274	\N
23323	7787	276	447749
23324	7787	277	616886
23325	7787	278	966615
23326	7787	279	814769
23327	7868	275	170298
23328	7868	276	719888
23329	7868	277	174241
23330	7788	281	\N
23331	7788	282	\N
23332	7869	280	\N
23333	7944	281	\N
23334	7869	283	248637
23335	7869	284	925191
23336	7944	283	923202
23337	7789	285	\N
23338	7789	287	\N
23339	7789	288	\N
23340	7870	286	\N
23341	7870	288	\N
23342	7870	289	\N
23343	7870	290	\N
23344	7945	292	694898
23345	7945	294	194032
23346	7790	295	\N
23347	7790	296	\N
23348	7790	297	\N
23349	7871	295	\N
23350	7790	298	974347
23351	7946	298	386541
23352	7946	299	655870
23353	7946	300	273847
23354	7946	301	944549
23355	7872	302	\N
23356	7947	302	\N
23357	7791	303	820728
23358	7872	303	705901
23359	7872	304	199073
23360	7872	306	922789
23361	7872	308	900922
23362	7947	304	274648
23363	7947	305	297171
23364	7947	306	939493
23365	7792	310	\N
23366	7792	312	\N
23367	7948	309	\N
23368	7948	310	\N
23369	7873	313	379859
23370	7873	315	906878
23371	7948	313	339177
23372	7793	316	\N
23373	7949	316	\N
23374	7949	317	\N
23375	7949	318	\N
23376	7949	319	\N
23377	7793	320	502554
23378	7949	320	245320
23379	7874	322	\N
23380	7874	323	\N
23381	7874	324	346052
23382	7874	325	406944
23383	7874	327	784920
23384	7794	329	\N
23385	7794	330	\N
23386	7794	331	\N
23387	7950	332	715529
23388	7950	333	199834
23389	7795	334	\N
23390	7795	335	\N
23391	7875	334	\N
23392	7875	336	\N
23393	7875	337	\N
23394	7875	338	484782
23395	7876	339	\N
23396	7876	340	\N
23397	7876	341	\N
23398	7951	340	\N
23399	7951	341	\N
23400	7796	342	968641
23401	7796	343	106526
23402	7796	344	393440
23403	7951	343	655998
23404	7797	345	\N
23405	7797	346	\N
23406	7877	345	\N
23407	7952	345	\N
23408	7797	348	875004
23409	7797	349	848892
23410	7877	348	143518
23411	7952	347	401319
23412	7952	348	421202
23413	7798	350	\N
23414	7953	351	\N
23415	7798	352	102915
23416	7798	353	244995
23417	7878	352	124582
23418	7799	355	\N
23419	7954	354	\N
23420	7799	356	989120
23421	7799	358	328721
23422	7799	359	886476
23423	7799	360	562341
23424	7879	361	\N
23425	7955	361	\N
23426	7955	362	\N
23427	7800	364	146240
23428	7800	365	995341
23429	7879	363	849328
23430	7955	363	457173
23431	7955	364	404599
23432	7801	366	\N
23433	7801	367	\N
23434	7880	366	\N
23435	7880	367	\N
23436	7801	368	168047
23437	7801	369	786873
23438	7801	370	105417
23439	7956	368	549790
23440	7802	371	\N
23441	7802	372	\N
23442	7802	374	\N
23443	7881	372	\N
23444	7881	373	\N
23445	7881	374	\N
23446	7881	375	\N
23447	7881	376	\N
23448	7802	377	170319
23449	7957	377	956422
23450	7957	378	793389
23451	7958	379	\N
23452	7958	380	\N
23453	7958	382	\N
23454	7958	383	\N
23455	7958	385	\N
23456	7803	387	902625
23457	7803	388	563326
23458	7803	389	866874
23459	7959	390	870428
23460	7959	391	408750
23461	7959	392	173409
23462	7804	393	\N
23463	7804	394	128393
23464	7804	395	430107
23465	7882	394	413849
23466	7960	394	301128
23467	7960	395	634954
23468	7961	396	\N
23469	7961	397	\N
23470	7961	398	\N
23471	7961	399	\N
23472	7883	400	772286
23473	7961	400	104602
23474	7884	402	\N
23475	7884	403	837918
23476	7884	405	904455
23477	7884	406	492947
23478	7884	407	347486
23479	7962	403	754695
23480	7962	404	368433
23481	7805	408	477521
23482	7805	409	405269
23483	7805	410	303317
23484	7806	411	153713
23485	7806	412	834247
23486	7963	411	623669
23487	7963	412	304030
23488	7807	413	\N
23489	7807	414	\N
23490	7885	416	760242
23491	7885	417	943574
23492	7885	418	296382
23493	7885	419	451341
23494	7885	420	364296
23495	7808	421	\N
23496	7808	422	\N
23497	7808	423	\N
23498	7808	424	467631
23499	7808	425	575946
23500	7809	426	\N
23501	7809	427	459436
23502	7809	428	898367
23503	7886	427	877673
23504	7886	428	776506
23505	7886	430	161120
23506	7886	431	463002
23507	7887	432	\N
23508	7887	433	\N
23509	7887	434	\N
23510	7887	435	\N
23511	7888	436	\N
23512	7810	437	891826
23513	7888	437	927595
23514	7811	438	425564
23515	7812	439	\N
23516	7812	441	\N
23517	7889	439	\N
23518	7889	441	\N
23519	7812	442	454776
23520	7889	443	314459
23521	7890	445	\N
23522	7890	446	\N
23523	7890	447	\N
23524	7813	448	112644
23525	7813	450	879103
23526	7814	451	\N
23527	7891	452	\N
23528	7891	454	\N
23529	7891	455	\N
23530	7891	456	\N
23531	7891	457	\N
23532	7892	458	320189
23533	7815	459	\N
23534	7893	459	\N
23535	7893	460	898891
23536	7893	461	845607
23537	7816	463	\N
23538	7816	464	\N
23539	7816	465	670655
23540	7817	466	573230
23541	7817	468	906525
23542	7894	466	481801
23543	7894	468	169326
23544	7894	469	542231
23545	7818	470	\N
23546	7818	471	\N
23547	7895	470	\N
23548	7819	472	\N
23549	7819	473	\N
23550	7819	474	\N
23551	7896	473	\N
23552	7896	475	\N
23553	7896	476	\N
23554	7896	477	963242
23555	7896	478	733381
23556	7820	479	\N
23557	7820	480	\N
23558	7820	481	758679
23559	7897	481	995467
23560	7897	483	937142
23561	7898	484	735397
23562	7821	485	\N
23563	7821	486	260400
23564	7821	487	480788
23565	7899	486	679150
23566	7822	489	209337
23567	7822	491	753823
23568	7822	492	221839
23569	7900	493	\N
23570	7900	494	664601
23571	7901	495	\N
23572	7901	496	\N
23573	7901	498	797391
23574	7901	500	731820
23575	7902	501	\N
23576	7902	503	\N
23577	7902	504	\N
23578	7902	506	\N
23579	7902	508	\N
23580	7903	509	\N
23581	7964	510	623878
23582	7964	511	900049
23583	8030	510	668796
23584	8030	511	456671
23585	8084	510	685521
23586	8084	511	818728
23587	8084	512	109494
23588	8084	513	922274
23589	7965	515	\N
23590	8031	514	\N
23591	8085	514	\N
23592	7965	516	819488
23593	7965	517	736312
23594	8031	516	842797
23595	8031	517	667931
23596	8031	518	637205
23597	8031	519	582258
23598	8085	517	261213
23599	8085	518	646264
23600	8032	521	\N
23601	8032	523	\N
23602	8032	524	\N
23603	8032	525	\N
23604	8032	527	\N
23605	7966	528	908547
23606	8086	529	\N
23607	8086	530	\N
23608	8086	532	\N
23609	8033	533	588119
23610	7967	534	\N
23611	7967	535	\N
23612	8034	534	\N
23613	8034	536	\N
23614	8087	534	\N
23615	8087	537	558214
23616	8088	539	\N
23617	8088	540	\N
23618	8035	541	448542
23619	8088	541	402060
23620	8036	542	\N
23621	8036	544	\N
23622	8089	542	\N
23623	8036	545	802901
23624	8089	545	503947
23625	8089	546	120931
23626	8037	547	\N
23627	8090	547	\N
23628	8090	548	\N
23629	8037	550	214926
23630	7968	551	879823
23631	7968	552	332049
23632	7968	553	545470
23633	7968	554	586205
23634	7968	555	146407
23635	8091	552	998902
23636	8091	553	623651
23637	7969	556	672723
23638	7969	557	250203
23639	7969	558	652433
23640	8092	556	318615
23641	7970	559	\N
23642	7970	560	\N
23643	7970	561	\N
23644	8038	559	\N
23645	8093	559	\N
23646	8093	560	\N
23647	8093	562	\N
23648	7970	563	684605
23649	7970	564	882096
23650	8038	563	869236
23651	8038	565	869443
23652	8038	567	621671
23653	8038	569	844718
23654	8039	570	\N
23655	8039	571	\N
23656	8094	570	\N
23657	7971	573	702737
23658	7971	574	909982
23659	8039	572	488360
23660	8039	574	983519
23661	8039	575	108093
23662	8094	573	508284
23663	8094	575	410490
23664	7972	576	\N
23665	7972	577	\N
23666	7972	578	\N
23667	8040	576	\N
23668	8040	577	\N
23669	8040	579	\N
23670	8095	576	\N
23671	8040	580	664045
23672	8040	582	557210
23673	7973	584	\N
23674	7973	585	\N
23675	7973	586	\N
23676	8041	587	187806
23677	8041	588	282075
23678	8096	587	504326
23679	8096	588	425472
23680	8096	590	146110
23681	8096	591	683649
23682	8096	593	507524
23683	7974	594	\N
23684	7974	595	\N
23685	7974	597	\N
23686	8042	594	\N
23687	7974	598	132138
23688	7974	599	278122
23689	8042	598	603885
23690	8097	599	972813
23691	7975	601	\N
23692	7975	602	\N
23693	8098	600	\N
23694	7975	603	801246
23695	7975	604	419379
23696	8043	603	542844
23697	8043	604	268231
23698	8044	605	\N
23699	8044	606	\N
23700	8099	605	\N
23701	8099	606	\N
23702	8099	607	\N
23703	7976	608	941704
23704	8044	608	459259
23705	8044	610	891874
23706	8099	609	151233
23707	8100	612	\N
23708	8100	613	\N
23709	8100	614	\N
23710	8100	615	\N
23711	7977	616	324833
23712	7977	617	355344
23713	7977	618	478922
23714	8045	617	317540
23715	8045	619	244428
23716	7978	620	\N
23717	7978	621	\N
23718	7978	622	\N
23719	7978	624	\N
23720	7978	625	\N
23721	8046	621	\N
23722	8046	623	\N
23723	8101	620	\N
23724	8046	626	842099
23725	8101	626	863346
23726	8101	627	658264
23727	8102	628	\N
23728	8047	629	586693
23729	8047	631	183239
23730	8047	632	728141
23731	8047	633	273063
23732	8102	629	113198
23733	8102	631	628949
23734	8102	632	756059
23735	8048	635	\N
23736	8048	636	\N
23737	8103	634	\N
23738	7979	637	664392
23739	8048	637	597227
23740	8048	639	326558
23741	8103	638	637801
23742	8103	639	648465
23743	8103	640	423136
23744	7980	641	\N
23745	7980	642	\N
23746	7980	643	\N
23747	8049	641	\N
23748	8049	645	645331
23749	8049	646	278047
23750	8049	647	519234
23751	7981	648	\N
23752	7981	650	\N
23753	7981	651	\N
23754	8104	648	\N
23755	8104	649	\N
23756	8050	653	491403
23757	8050	655	701350
23758	8050	656	673736
23759	8104	652	522399
23760	8104	653	878917
23761	8104	654	614959
23762	7982	657	\N
23763	8105	658	\N
23764	8105	659	\N
23765	8105	660	\N
23766	7982	662	276142
23767	8051	661	887357
23768	8105	661	922230
23769	8105	662	247384
23770	7983	664	\N
23771	7983	665	\N
23772	8052	664	\N
23773	8052	665	\N
23774	7983	666	933694
23775	7983	667	593648
23776	8052	666	984277
23777	8106	666	403265
23778	8106	668	487048
23779	7984	669	\N
23780	7984	671	\N
23781	7984	672	\N
23782	8053	670	\N
23783	8107	669	\N
23784	8107	670	\N
23785	8107	673	110409
23786	8107	674	195939
23787	8107	675	873500
23788	7985	676	\N
23789	7985	677	\N
23790	8054	676	\N
23791	8108	676	\N
23792	8108	677	\N
23793	8108	678	\N
23794	8108	679	\N
23795	7985	681	910272
23796	8108	680	734660
23797	7986	682	\N
23798	8055	682	\N
23799	8055	683	\N
23800	8055	684	\N
23801	8055	686	\N
23802	8109	682	\N
23803	7986	687	609481
23804	7986	688	797016
23805	7986	689	704530
23806	7986	690	384525
23807	8055	687	326535
23808	8056	691	\N
23809	8056	692	\N
23810	8056	694	\N
23811	8056	696	\N
23812	8110	697	103262
23813	8110	698	555651
23814	7987	699	\N
23815	8057	700	\N
23816	8057	701	\N
23817	8111	699	\N
23818	8111	700	\N
23819	8111	701	\N
23820	8111	702	\N
23821	8111	703	\N
23822	7987	705	957484
23823	7987	706	621707
23824	8057	704	249801
23825	8057	705	292416
23826	7988	707	\N
23827	7988	708	\N
23828	7988	709	\N
23829	7988	710	\N
23830	8058	707	\N
23831	8058	708	\N
23832	8112	707	\N
23833	8112	708	\N
23834	8112	709	\N
23835	8112	710	\N
23836	7988	711	148425
23837	8058	711	165534
23838	7989	713	\N
23839	8059	712	\N
23840	8059	714	780284
23841	8059	715	556275
23842	8059	716	280347
23843	7990	718	\N
23844	7990	719	\N
23845	7990	720	\N
23846	7990	722	\N
23847	8060	717	\N
23848	8113	717	\N
23849	8113	718	\N
23850	8113	724	404045
23851	7991	725	\N
23852	8114	725	\N
23853	8114	727	\N
23854	7991	728	849476
23855	8061	728	287588
23856	8061	729	327890
23857	8061	731	590913
23858	8115	733	\N
23859	7992	734	606046
23860	8062	734	800390
23861	7993	736	\N
23862	8063	735	\N
23863	8063	736	\N
23864	8063	737	\N
23865	8116	736	\N
23866	8063	738	432097
23867	8063	740	614143
23868	8116	738	364416
23869	8116	740	386003
23870	7994	741	\N
23871	7994	743	\N
23872	7994	745	677345
23873	7994	747	942566
23874	7994	748	113722
23875	8064	749	\N
23876	8064	751	\N
23877	8117	750	\N
23878	8117	751	\N
23879	7995	752	346245
23880	8064	753	789363
23881	8064	754	926674
23882	8117	752	630196
23883	8117	753	407518
23884	8118	755	\N
23885	8118	756	\N
23886	8065	757	\N
23887	8065	758	187793
23888	8065	760	952584
23889	7996	761	\N
23890	7996	762	\N
23891	8066	762	\N
23892	7996	763	154005
23893	7997	764	\N
23894	8067	764	\N
23895	8067	766	\N
23896	8119	764	\N
23897	7997	767	521499
23898	8067	767	690180
23899	8067	769	153309
23900	8119	767	280961
23901	7998	770	\N
23902	8068	771	\N
23903	8068	773	\N
23904	8068	775	\N
23905	8120	777	114940
23906	8069	778	229626
23907	7999	780	\N
23908	7999	781	\N
23909	7999	783	\N
23910	7999	785	\N
23911	7999	786	\N
23912	8070	788	830856
23913	8070	789	764740
23914	8070	790	616419
23915	8070	791	448250
23916	8071	792	\N
23917	8071	793	\N
23918	8071	795	\N
23919	8071	797	\N
23920	8071	799	\N
23921	8000	800	195908
23922	8000	802	776771
23923	8001	803	162802
23924	8001	804	236170
23925	8001	805	856781
23926	8072	803	481137
23927	8072	804	464081
23928	8072	806	821951
23929	8072	807	977587
23930	8002	808	\N
23931	8073	808	\N
23932	8073	810	\N
23933	8073	811	\N
23934	8073	812	\N
23935	8073	813	\N
23936	8002	814	202826
23937	8002	816	435295
23938	8003	817	\N
23939	8003	819	\N
23940	8003	820	\N
23941	8003	821	\N
23942	8003	822	\N
23943	8074	818	\N
23944	8074	824	405477
23945	8074	826	721372
23946	8074	827	340108
23947	8074	828	265644
23948	8075	829	\N
23949	8004	831	762344
23950	8004	832	485336
23951	8076	833	\N
23952	8076	834	\N
23953	8076	836	\N
23954	8005	837	457994
23955	8005	838	302673
23956	8076	837	160866
23957	8006	840	\N
23958	8006	841	\N
23959	8006	842	771285
23960	8006	843	543882
23961	8006	845	859734
23962	8077	842	453725
23963	8077	844	168889
23964	8007	846	507270
23965	8007	847	889092
23966	8007	849	343303
23967	8008	850	\N
23968	8008	851	\N
23969	8008	852	\N
23970	8008	854	782248
23971	8078	853	730747
23972	8079	855	\N
23973	8079	856	\N
23974	8009	857	990209
23975	8009	859	309147
23976	8010	860	927969
23977	8010	862	499784
23978	8080	860	700317
23979	8080	861	564390
23980	8080	863	269002
23981	8080	864	838313
23982	8081	866	\N
23983	8011	867	150920
23984	8011	868	189690
23985	8011	869	216455
23986	8011	870	841699
23987	8011	872	537140
23988	8081	867	514269
23989	8012	873	\N
23990	8013	874	\N
23991	8013	876	\N
23992	8082	875	\N
23993	8013	877	807326
23994	8013	878	952876
23995	8013	879	176587
23996	8014	881	\N
23997	8014	882	\N
23998	8014	884	\N
23999	8083	886	\N
24000	8015	887	511731
24001	8015	889	799647
24002	8016	890	\N
24003	8016	891	851224
24004	8016	893	638724
24005	8017	895	836452
24006	8017	897	546996
24007	8017	898	598215
24008	8017	899	392600
24009	8018	900	632740
24010	8018	901	707894
24011	8018	903	816332
24012	8018	904	649671
24013	8018	906	154637
24014	8019	907	\N
24015	8019	908	\N
24016	8019	909	\N
24017	8019	910	365690
24018	8020	911	\N
24019	8020	912	737460
24020	8020	913	148057
24021	8021	915	823555
24022	8021	916	717657
24023	8022	918	\N
24024	8022	919	908927
24025	8022	921	867624
24026	8023	922	\N
24027	8023	924	\N
24028	8023	925	\N
24029	8023	926	435538
24030	8024	928	\N
24031	8024	929	\N
24032	8024	930	561899
24033	8025	931	\N
24034	8025	932	\N
24035	8025	933	\N
24036	8026	934	724183
24037	8026	936	101725
24038	8027	937	840396
24039	8028	938	156087
24040	8029	939	\N
24041	8029	941	\N
24042	8121	943	\N
24043	8121	945	236564
24044	8121	947	738635
24045	8193	944	156403
24046	8193	946	209708
24047	8193	948	283359
24048	8193	949	113464
24049	8194	950	\N
24050	8194	951	\N
24051	8194	952	\N
24052	8194	953	\N
24053	8122	955	288736
24054	8122	956	932134
24055	8122	957	782156
24056	8195	954	266201
24057	8195	955	852388
24058	8195	956	191817
24059	8195	957	115975
24060	8195	959	595293
24061	8123	960	\N
24062	8123	961	262601
24063	8124	962	677889
24064	8124	963	419126
24065	8124	964	667677
24066	8124	965	225161
24067	8124	966	102295
24068	8125	967	\N
24069	8196	968	\N
24070	8196	969	\N
24071	8196	970	\N
24072	8196	972	\N
24073	8196	973	\N
24074	8125	974	400527
24075	8125	976	905767
24076	8197	977	\N
24077	8126	978	104289
24078	8126	979	337529
24079	8126	980	578127
24080	8126	981	696565
24081	8197	978	683623
24082	8127	983	\N
24083	8127	984	\N
24084	8127	985	\N
24085	8127	986	\N
24086	8127	988	469586
24087	8128	989	606086
24088	8129	990	\N
24089	8198	990	\N
24090	8129	992	506159
24091	8129	993	415545
24092	8130	995	\N
24093	8199	994	\N
24094	8130	996	563263
24095	8130	997	498902
24096	8199	996	796805
24097	8199	997	866242
24098	8131	998	\N
24099	8131	999	\N
24100	8131	1000	\N
24101	8200	998	\N
24102	8200	999	\N
24103	8200	1000	\N
24104	8131	1001	916846
24105	8131	1002	291869
24106	8200	1002	707263
24107	8132	1003	\N
24108	8132	1004	\N
24109	8132	1005	\N
24110	8201	1007	677507
24111	8201	1008	741274
24112	8201	1009	429527
24113	8201	1010	584847
24114	8133	1012	457338
24115	8133	1013	637163
24116	8133	1014	775533
24117	8133	1015	195036
24118	8133	1016	754676
24119	8134	1018	\N
24120	8134	1019	\N
24121	8202	1017	\N
24122	8202	1020	172324
24123	8135	1021	390827
24124	8135	1022	268262
24125	8203	1021	726431
24126	8203	1023	743523
24127	8204	1024	\N
24128	8204	1025	\N
24129	8136	1026	877169
24130	8136	1027	123004
24131	8137	1028	\N
24132	8137	1029	\N
24133	8137	1030	\N
24134	8137	1032	\N
24135	8205	1028	\N
24136	8137	1033	510039
24137	8205	1033	779803
24138	8205	1034	833895
24139	8138	1035	539249
24140	8139	1037	\N
24141	8139	1038	\N
24142	8206	1036	\N
24143	8206	1039	930504
24144	8207	1040	\N
24145	8207	1041	\N
24146	8140	1043	338296
24147	8140	1044	562953
24148	8140	1045	823816
24149	8140	1046	285427
24150	8207	1042	734326
24151	8207	1043	911820
24152	8141	1047	\N
24153	8141	1048	\N
24154	8208	1047	\N
24155	8142	1049	425677
24156	8142	1050	668747
24157	8142	1051	382784
24158	8142	1053	664682
24159	8142	1054	292934
24160	8143	1055	\N
24161	8143	1056	\N
24162	8143	1057	\N
24163	8143	1058	\N
24164	8209	1055	\N
24165	8209	1056	\N
24166	8210	1059	757746
24167	8210	1060	930291
24168	8144	1061	\N
24169	8144	1063	\N
24170	8144	1064	\N
24171	8211	1062	\N
24172	8211	1064	\N
24173	8211	1066	\N
24174	8145	1067	\N
24175	8145	1069	\N
24176	8212	1070	328264
24177	8212	1072	452684
24178	8212	1074	521909
24179	8146	1076	481809
24180	8146	1077	629121
24181	8146	1078	245398
24182	8146	1079	288367
24183	8147	1080	\N
24184	8147	1082	\N
24185	8213	1080	\N
24186	8213	1082	\N
24187	8213	1083	\N
24188	8213	1085	\N
24189	8147	1086	428131
24190	8147	1088	607908
24191	8147	1090	268860
24192	8148	1091	\N
24193	8148	1092	\N
24194	8148	1093	872901
24195	8148	1094	302294
24196	8214	1093	376950
24197	8214	1094	665374
24198	8149	1095	\N
24199	8215	1096	\N
24200	8149	1097	490965
24201	8149	1098	786178
24202	8149	1100	781594
24203	8215	1097	809675
24204	8150	1101	\N
24205	8150	1102	\N
24206	8150	1103	\N
24207	8150	1105	\N
24208	8150	1106	482612
24209	8216	1106	299039
24210	8216	1107	782060
24211	8216	1109	675912
24212	8151	1110	\N
24213	8151	1111	\N
24214	8217	1112	409757
24215	8217	1113	752317
24216	8217	1114	722770
24217	8217	1115	428502
24218	8152	1116	\N
24219	8152	1117	\N
24220	8152	1118	\N
24221	8152	1119	\N
24222	8152	1121	356637
24223	8153	1122	337304
24224	8153	1123	740855
24225	8153	1124	416872
24226	8153	1126	247303
24227	8218	1127	\N
24228	8154	1129	451921
24229	8218	1129	476421
24230	8155	1130	\N
24231	8219	1130	\N
24232	8219	1131	457212
24233	8219	1132	785119
24234	8220	1134	\N
24235	8220	1135	\N
24236	8220	1137	\N
24237	8220	1138	\N
24238	8220	1139	\N
24239	8156	1140	\N
24240	8221	1140	\N
24241	8221	1141	\N
24242	8156	1142	451907
24243	8157	1144	\N
24244	8222	1143	\N
24245	8222	1144	\N
24246	8157	1145	987025
24247	8222	1146	874477
24248	8222	1147	168638
24249	8222	1148	786611
24250	8158	1150	\N
24251	8158	1151	\N
24252	8158	1152	\N
24253	8158	1153	\N
24254	8158	1154	\N
24255	8223	1149	\N
24256	8223	1155	227759
24257	8223	1156	417594
24258	8223	1157	111378
24259	8224	1158	\N
24260	8224	1160	\N
24261	8224	1162	\N
24262	8159	1163	667823
24263	8159	1164	418260
24264	8159	1165	940674
24265	8224	1163	707350
24266	8160	1166	\N
24267	8160	1167	\N
24268	8160	1168	\N
24269	8160	1169	\N
24270	8225	1167	\N
24271	8161	1170	\N
24272	8226	1170	\N
24273	8161	1171	814865
24274	8226	1171	704017
24275	8226	1172	658267
24276	8226	1174	842163
24277	8226	1175	660504
24278	8227	1177	\N
24279	8227	1179	\N
24280	8162	1180	353990
24281	8162	1181	675371
24282	8162	1182	230443
24283	8163	1183	611948
24284	8163	1184	400216
24285	8163	1186	185578
24286	8163	1188	597088
24287	8164	1190	671939
24288	8164	1192	950546
24289	8164	1193	870696
24290	8228	1189	539125
24291	8165	1194	\N
24292	8229	1194	\N
24293	8165	1195	656997
24294	8165	1197	916543
24295	8229	1195	253484
24296	8229	1196	446102
24297	8229	1197	685568
24298	8229	1198	969098
24299	8166	1200	\N
24300	8166	1201	\N
24301	8166	1203	\N
24302	8230	1199	\N
24303	8166	1205	429657
24304	8166	1206	846824
24305	8167	1207	\N
24306	8167	1208	\N
24307	8231	1207	\N
24308	8167	1210	961592
24309	8232	1211	\N
24310	8232	1212	250624
24311	8232	1213	610576
24312	8232	1214	173853
24313	8233	1215	\N
24314	8168	1216	988697
24315	8168	1218	659746
24316	8233	1216	454394
24317	8169	1219	\N
24318	8169	1220	\N
24319	8169	1221	\N
24320	8234	1220	\N
24321	8169	1222	853264
24322	8170	1223	\N
24323	8170	1224	\N
24324	8170	1225	\N
24325	8235	1223	\N
24326	8235	1224	\N
24327	8235	1226	\N
24328	8170	1227	591153
24329	8170	1228	588839
24330	8171	1229	\N
24331	8171	1230	\N
24332	8172	1231	529524
24333	8172	1232	438528
24334	8172	1233	310251
24335	8173	1234	\N
24336	8173	1236	\N
24337	8173	1237	\N
24338	8173	1238	\N
24339	8173	1239	337133
24340	8174	1240	366030
24341	8174	1241	131014
24342	8174	1242	583400
24343	8174	1243	640118
24344	8174	1245	561299
24345	8175	1246	\N
24346	8175	1247	\N
24347	8176	1249	877163
24348	8177	1251	\N
24349	8178	1252	191566
24350	8178	1253	556868
24351	8178	1254	194390
24352	8179	1255	\N
24353	8179	1257	\N
24354	8180	1259	631622
24355	8181	1260	\N
24356	8181	1262	\N
24357	8181	1263	\N
24358	8182	1264	448770
24359	8182	1266	457130
24360	8182	1267	709557
24361	8182	1268	846415
24362	8182	1270	903255
24363	8183	1271	\N
24364	8183	1272	\N
24365	8183	1273	\N
24366	8184	1274	\N
24367	8184	1275	676016
24368	8184	1276	704561
24369	8184	1277	186759
24370	8185	1278	847793
24371	8186	1280	822042
24372	8187	1281	\N
24373	8187	1282	\N
24374	8188	1283	258799
24375	8188	1284	704965
24376	8188	1286	207019
24377	8189	1288	\N
24378	8189	1290	\N
24379	8189	1292	941020
24380	8189	1294	786792
24381	8190	1295	879517
24382	8190	1296	535417
24383	8191	1297	\N
24384	8191	1298	\N
24385	8191	1299	\N
24386	8191	1300	\N
24387	8192	1301	\N
24388	8192	1302	\N
24389	8192	1303	704756
24390	8236	1304	\N
24391	8236	1306	\N
24392	8273	1304	\N
24393	8273	1306	\N
24394	8236	1307	285045
24395	8273	1308	779918
24396	8273	1310	711510
24397	8273	1311	219249
24398	8237	1312	\N
24399	8237	1313	\N
24400	8274	1314	568970
24401	8238	1315	\N
24402	8238	1316	\N
24403	8238	1317	\N
24404	8275	1316	\N
24405	8275	1317	\N
24406	8238	1319	581836
24407	8275	1318	549508
24408	8275	1319	550603
24409	8275	1321	988062
24410	8239	1322	\N
24411	8239	1323	\N
24412	8239	1324	\N
24413	8239	1326	\N
24414	8276	1322	\N
24415	8276	1323	\N
24416	8276	1325	\N
24417	8276	1327	530276
24418	8240	1329	\N
24419	8277	1329	\N
24420	8240	1330	706762
24421	8240	1332	380938
24422	8240	1334	240885
24423	8240	1335	890945
24424	8277	1330	941061
24425	8241	1336	\N
24426	8241	1337	\N
24427	8278	1336	\N
24428	8241	1338	429074
24429	8278	1338	434337
24430	8278	1339	613530
24431	8278	1340	754159
24432	8278	1342	171209
24433	8242	1343	\N
24434	8242	1344	\N
24435	8279	1346	758109
24436	8279	1348	125124
24437	8279	1349	422455
24438	8279	1350	630472
24439	8280	1351	\N
24440	8280	1352	\N
24441	8280	1353	\N
24442	8280	1354	\N
24443	8280	1355	\N
24444	8243	1356	438289
24445	8243	1357	665554
24446	8243	1358	273878
24447	8244	1359	\N
24448	8244	1360	607754
24449	8244	1361	294828
24450	8244	1362	128392
24451	8281	1360	132338
24452	8281	1361	897101
24453	8281	1363	154570
24454	8281	1364	749279
24455	8245	1365	\N
24456	8245	1366	\N
24457	8245	1367	\N
24458	8245	1368	\N
24459	8246	1369	\N
24460	8282	1370	\N
24461	8246	1372	394223
24462	8246	1373	646472
24463	8283	1374	905682
24464	8247	1376	\N
24465	8247	1378	\N
24466	8247	1379	\N
24467	8284	1375	\N
24468	8284	1376	\N
24469	8247	1380	614570
24470	8247	1381	923411
24471	8284	1381	957563
24472	8248	1382	\N
24473	8285	1382	\N
24474	8285	1383	\N
24475	8248	1384	739134
24476	8248	1385	159063
24477	8248	1386	269239
24478	8248	1387	577714
24479	8285	1384	908121
24480	8285	1386	889463
24481	8286	1388	\N
24482	8286	1389	\N
24483	8249	1390	234816
24484	8249	1391	840496
24485	8249	1393	111212
24486	8286	1390	581980
24487	8286	1391	405504
24488	8250	1394	\N
24489	8250	1395	\N
24490	8250	1396	640598
24491	8250	1397	548229
24492	8287	1396	795501
24493	8251	1399	\N
24494	8251	1400	\N
24495	8251	1402	\N
24496	8251	1403	\N
24497	8288	1398	\N
24498	8288	1399	\N
24499	8251	1405	358629
24500	8252	1407	\N
24501	8252	1408	\N
24502	8289	1406	\N
24503	8289	1407	\N
24504	8290	1410	\N
24505	8290	1411	\N
24506	8290	1412	\N
24507	8290	1413	\N
24508	8253	1415	489689
24509	8253	1416	687134
24510	8290	1415	497658
24511	8254	1417	770351
24512	8254	1418	278783
24513	8254	1419	247579
24514	8254	1420	800270
24515	8254	1422	651872
24516	8291	1418	312583
24517	8255	1423	\N
24518	8255	1424	\N
24519	8292	1423	\N
24520	8255	1426	180102
24521	8255	1427	690883
24522	8293	1429	\N
24523	8256	1431	307977
24524	8293	1431	183899
24525	8293	1432	739269
24526	8293	1433	497414
24527	8257	1434	\N
24528	8257	1435	\N
24529	8294	1434	\N
24530	8294	1436	913815
24531	8294	1437	320039
24532	8295	1438	\N
24533	8295	1439	\N
24534	8295	1441	\N
24535	8295	1443	\N
24536	8295	1444	606423
24537	8258	1445	\N
24538	8258	1447	\N
24539	8296	1445	\N
24540	8296	1446	\N
24541	8258	1448	912757
24542	8259	1449	\N
24543	8259	1450	\N
24544	8259	1451	\N
24545	8297	1453	418720
24546	8297	1454	390429
24547	8260	1455	\N
24548	8298	1457	\N
24549	8298	1459	\N
24550	8298	1460	927646
24551	8261	1462	\N
24552	8261	1463	\N
24553	8299	1465	\N
24554	8299	1466	\N
24555	8299	1467	\N
24556	8262	1468	869974
24557	8262	1469	464616
24558	8262	1470	768134
24559	8299	1468	525182
24560	8299	1469	853839
24561	8263	1471	\N
24562	8263	1472	441477
24563	8300	1472	694624
24564	8300	1473	448147
24565	8264	1474	338221
24566	8301	1475	\N
24567	8265	1477	560946
24568	8265	1479	678491
24569	8301	1476	109366
24570	8301	1477	802035
24571	8302	1481	\N
24572	8302	1483	\N
24573	8302	1484	\N
24574	8302	1485	\N
24575	8266	1486	\N
24576	8266	1488	139373
24577	8303	1490	\N
24578	8303	1492	\N
24579	8303	1493	\N
24580	8303	1494	239949
24581	8303	1496	959976
24582	8304	1497	\N
24583	8304	1499	233913
24584	8267	1500	\N
24585	8267	1502	684957
24586	8268	1503	590266
24587	8305	1503	459323
24588	8305	1504	262271
24589	8269	1505	\N
24590	8306	1505	\N
24591	8306	1507	\N
24592	8306	1509	\N
24593	8270	1510	\N
24594	8270	1511	\N
24595	8270	1512	\N
24596	8270	1513	\N
24597	8270	1514	\N
24598	8307	1510	\N
24599	8307	1511	\N
24600	8271	1515	105572
24601	8272	1516	\N
24602	8308	1516	\N
24603	8308	1517	\N
24604	8308	1518	\N
24605	8308	1519	\N
24606	8309	1521	\N
24607	8310	1523	\N
24608	8311	1524	\N
24609	8311	1525	\N
24610	8311	1526	\N
24611	8311	1528	\N
24612	8311	1530	515395
24613	8312	1531	\N
24614	8312	1532	\N
24615	8312	1533	\N
24616	8312	1534	455976
24617	8312	1535	472041
24618	8313	1537	\N
24619	8313	1539	\N
24620	8313	1540	555324
24621	8313	1541	192090
24622	8314	1542	\N
24623	8314	1544	\N
24624	8314	1545	612312
24625	8315	1546	\N
24626	8315	1547	426258
24627	8315	1548	499917
24628	8316	1549	\N
24629	8316	1551	\N
24630	8317	1552	\N
24631	8317	1553	428149
24632	8317	1554	674761
24633	8318	1555	\N
24634	8318	1556	\N
24635	8318	1558	453164
24636	8319	1559	\N
24637	8319	1561	691242
24638	8319	1563	195795
24639	8319	1564	929033
24640	8319	1565	621226
24641	8356	1560	546146
24642	8356	1561	957128
24643	8356	1562	276180
24644	8356	1563	654110
24645	8320	1566	\N
24646	8320	1567	\N
24647	8320	1568	\N
24648	8320	1569	\N
24649	8357	1566	\N
24650	8320	1570	893728
24651	8357	1571	623289
24652	8357	1573	850091
24653	8426	1570	463978
24654	8426	1571	633293
24655	8426	1572	725117
24656	8427	1574	\N
24657	8427	1575	\N
24658	8427	1576	\N
24659	8358	1577	\N
24660	8358	1578	\N
24661	8428	1577	\N
24662	8428	1579	\N
24663	8321	1580	889034
24664	8321	1582	170971
24665	8358	1580	439955
24666	8358	1581	112126
24667	8358	1582	997051
24668	8322	1583	\N
24669	8322	1585	\N
24670	8322	1586	\N
24671	8359	1583	\N
24672	8359	1584	\N
24673	8359	1585	\N
24674	8322	1587	538631
24675	8359	1587	318748
24676	8359	1588	638663
24677	8429	1587	871906
24678	8429	1588	700362
24679	8429	1589	589841
24680	8429	1590	477817
24681	8429	1591	933902
24682	8323	1592	\N
24683	8323	1593	\N
24684	8323	1595	\N
24685	8323	1597	\N
24686	8360	1593	\N
24687	8360	1594	\N
24688	8430	1592	\N
24689	8361	1598	\N
24690	8361	1599	\N
24691	8361	1600	\N
24692	8361	1601	\N
24693	8361	1603	\N
24694	8431	1598	\N
24695	8431	1599	\N
24696	8431	1601	\N
24697	8431	1603	\N
24698	8431	1605	\N
24699	8324	1606	\N
24700	8324	1607	342638
24701	8362	1607	889884
24702	8362	1608	245626
24703	8363	1610	\N
24704	8363	1612	\N
24705	8363	1613	\N
24706	8432	1609	\N
24707	8432	1610	\N
24708	8432	1612	\N
24709	8325	1614	717369
24710	8363	1614	774981
24711	8432	1614	719981
24712	8326	1615	\N
24713	8326	1616	\N
24714	8326	1618	\N
24715	8326	1619	\N
24716	8433	1615	\N
24717	8326	1620	590507
24718	8364	1620	408587
24719	8364	1621	177267
24720	8364	1622	666704
24721	8433	1621	509777
24722	8327	1624	\N
24723	8327	1625	\N
24724	8327	1627	\N
24725	8434	1623	\N
24726	8434	1624	\N
24727	8434	1626	\N
24728	8434	1628	709714
24729	8328	1629	\N
24730	8328	1630	\N
24731	8328	1631	\N
24732	8328	1632	\N
24733	8365	1629	\N
24734	8365	1630	\N
24735	8365	1631	\N
24736	8435	1629	\N
24737	8365	1633	723610
24738	8365	1635	942500
24739	8435	1633	517289
24740	8436	1636	\N
24741	8329	1637	240155
24742	8366	1637	633312
24743	8330	1639	\N
24744	8367	1639	\N
24745	8367	1640	\N
24746	8437	1638	\N
24747	8330	1642	299013
24748	8330	1643	728081
24749	8330	1645	836780
24750	8367	1641	161202
24751	8367	1643	221661
24752	8437	1642	980030
24753	8437	1643	514192
24754	8437	1644	789972
24755	8368	1647	\N
24756	8331	1649	165533
24757	8331	1651	405822
24758	8331	1652	695013
24759	8368	1648	912737
24760	8369	1653	\N
24761	8369	1654	\N
24762	8369	1656	103116
24763	8332	1658	\N
24764	8438	1657	\N
24765	8438	1658	\N
24766	8332	1659	116254
24767	8438	1660	658773
24768	8438	1661	657885
24769	8370	1663	\N
24770	8370	1664	\N
24771	8370	1665	784001
24772	8370	1666	705182
24773	8370	1668	194449
24774	8439	1665	762974
24775	8439	1666	977056
24776	8439	1667	317329
24777	8439	1669	973398
24778	8333	1670	\N
24779	8333	1671	\N
24780	8333	1672	\N
24781	8371	1670	\N
24782	8333	1673	836281
24783	8334	1674	\N
24784	8334	1675	\N
24785	8372	1677	542967
24786	8335	1678	\N
24787	8335	1679	\N
24788	8335	1680	\N
24789	8335	1681	\N
24790	8373	1678	\N
24791	8373	1679	\N
24792	8373	1680	\N
24793	8373	1682	\N
24794	8440	1679	\N
24795	8373	1683	749995
24796	8440	1684	426360
24797	8336	1685	\N
24798	8336	1687	\N
24799	8336	1689	\N
24800	8441	1685	\N
24801	8374	1690	484784
24802	8374	1691	639538
24803	8374	1692	551305
24804	8374	1693	488475
24805	8442	1695	\N
24806	8337	1696	599485
24807	8337	1697	560237
24808	8337	1698	232240
24809	8443	1699	\N
24810	8443	1701	\N
24811	8443	1702	\N
24812	8375	1703	362454
24813	8443	1704	956916
24814	8338	1705	\N
24815	8338	1706	\N
24816	8338	1707	\N
24817	8444	1705	\N
24818	8444	1706	\N
24819	8444	1708	\N
24820	8444	1709	712920
24821	8444	1710	464584
24822	8339	1711	\N
24823	8445	1712	\N
24824	8445	1714	\N
24825	8339	1715	100525
24826	8339	1716	636918
24827	8339	1717	568943
24828	8376	1715	742518
24829	8445	1716	101109
24830	8446	1718	\N
24831	8377	1719	786622
24832	8377	1721	275556
24833	8377	1722	590911
24834	8377	1724	494896
24835	8377	1725	102606
24836	8446	1720	856680
24837	8340	1726	\N
24838	8340	1728	\N
24839	8340	1729	\N
24840	8378	1730	254872
24841	8447	1731	345029
24842	8447	1733	198757
24843	8447	1734	181717
24844	8447	1735	192200
24845	8447	1736	299111
24846	8341	1738	\N
24847	8341	1739	\N
24848	8448	1737	\N
24849	8379	1740	\N
24850	8379	1741	\N
24851	8449	1740	\N
24852	8449	1741	\N
24853	8449	1742	\N
24854	8449	1743	\N
24855	8342	1744	636712
24856	8342	1745	654380
24857	8342	1747	593446
24858	8342	1748	164327
24859	8342	1749	363406
24860	8449	1745	522699
24861	8380	1751	\N
24862	8380	1752	\N
24863	8343	1753	497153
24864	8450	1754	229319
24865	8450	1755	811468
24866	8344	1756	\N
24867	8344	1757	\N
24868	8451	1756	\N
24869	8451	1758	\N
24870	8344	1759	399532
24871	8381	1759	243204
24872	8451	1759	138474
24873	8345	1760	\N
24874	8382	1760	\N
24875	8382	1761	\N
24876	8382	1762	\N
24877	8382	1764	\N
24878	8345	1765	232354
24879	8346	1766	\N
24880	8346	1767	\N
24881	8346	1768	\N
24882	8346	1769	\N
24883	8383	1766	\N
24884	8452	1766	\N
24885	8452	1768	\N
24886	8346	1770	492836
24887	8383	1771	774870
24888	8383	1772	476684
24889	8347	1774	\N
24890	8453	1773	\N
24891	8347	1775	346303
24892	8347	1776	307442
24893	8384	1775	499075
24894	8384	1776	215953
24895	8384	1777	600593
24896	8453	1775	712801
24897	8453	1776	953796
24898	8453	1777	591526
24899	8453	1779	735961
24900	8348	1780	\N
24901	8348	1781	\N
24902	8385	1780	\N
24903	8385	1782	\N
24904	8454	1781	\N
24905	8454	1782	\N
24906	8385	1783	593538
24907	8455	1785	\N
24908	8455	1786	\N
24909	8386	1788	811438
24910	8387	1789	\N
24911	8387	1790	\N
24912	8349	1792	190999
24913	8387	1791	302234
24914	8387	1792	509567
24915	8350	1793	\N
24916	8388	1794	\N
24917	8388	1795	\N
24918	8388	1796	\N
24919	8456	1793	\N
24920	8456	1794	\N
24921	8456	1795	\N
24922	8350	1797	784798
24923	8350	1799	196956
24924	8388	1797	910673
24925	8351	1800	\N
24926	8351	1801	\N
24927	8351	1802	\N
24928	8457	1803	738147
24929	8457	1804	925786
24930	8352	1805	\N
24931	8352	1806	\N
24932	8389	1805	\N
24933	8458	1805	\N
24934	8458	1806	\N
24935	8352	1807	645710
24936	8389	1807	114516
24937	8353	1809	\N
24938	8390	1808	\N
24939	8390	1809	\N
24940	8459	1808	\N
24941	8390	1811	880935
24942	8459	1811	333403
24943	8391	1812	\N
24944	8391	1813	\N
24945	8391	1814	\N
24946	8391	1815	\N
24947	8460	1816	988784
24948	8460	1818	359821
24949	8460	1819	926381
24950	8460	1820	404421
24951	8354	1821	\N
24952	8354	1823	\N
24953	8392	1821	\N
24954	8392	1822	\N
24955	8461	1821	\N
24956	8354	1824	626677
24957	8354	1825	707894
24958	8461	1824	874609
24959	8461	1825	103947
24960	8355	1826	\N
24961	8355	1827	\N
24962	8393	1826	\N
24963	8462	1826	\N
24964	8462	1828	\N
24965	8463	1829	\N
24966	8394	1830	264078
24967	8394	1831	578261
24968	8394	1832	277563
24969	8463	1830	706417
24970	8464	1833	\N
24971	8395	1834	834869
24972	8395	1835	923701
24973	8395	1836	865320
24974	8395	1837	918331
24975	8464	1834	375874
24976	8464	1835	518262
24977	8465	1839	\N
24978	8396	1840	511109
24979	8396	1842	529227
24980	8396	1843	991687
24981	8396	1845	940798
24982	8396	1847	796357
24983	8465	1840	219955
24984	8465	1841	262069
24985	8397	1848	357791
24986	8397	1849	173911
24987	8397	1850	792909
24988	8397	1852	812378
24989	8397	1854	378079
24990	8466	1856	\N
24991	8466	1857	\N
24992	8466	1858	295388
24993	8398	1860	\N
24994	8467	1859	\N
24995	8467	1860	\N
24996	8467	1861	\N
24997	8467	1862	669799
24998	8399	1863	\N
24999	8399	1864	\N
25000	8399	1865	531782
25001	8399	1866	577753
25002	8400	1867	\N
25003	8468	1867	\N
25004	8468	1868	114079
25005	8468	1869	403676
25006	8468	1870	283930
25007	8468	1871	510828
25008	8401	1873	\N
25009	8401	1874	412855
25010	8401	1875	496656
25011	8469	1875	148536
25012	8402	1876	\N
25013	8402	1877	\N
25014	8470	1879	169184
25015	8470	1880	553343
25016	8470	1881	146266
25017	8403	1883	\N
25018	8403	1884	\N
25019	8471	1882	\N
25020	8471	1884	\N
25021	8472	1885	\N
25022	8404	1886	339313
25023	8472	1887	884956
25024	8405	1888	\N
25025	8406	1889	\N
25026	8406	1890	\N
25027	8406	1891	\N
25028	8473	1892	224025
25029	8473	1894	669271
25030	8407	1895	\N
25031	8474	1896	499229
25032	8408	1898	337503
25033	8408	1900	135854
25034	8475	1897	163900
25035	8475	1898	523799
25036	8475	1899	741978
25037	8409	1902	\N
25038	8409	1903	\N
25039	8476	1904	121105
25040	8410	1906	\N
25041	8410	1908	536807
25042	8410	1909	908041
25043	8410	1911	857610
25044	8410	1912	284304
25045	8411	1913	\N
25046	8411	1915	\N
25047	8411	1917	\N
25048	8477	1914	\N
25049	8477	1916	\N
25050	8411	1918	472381
25051	8411	1919	193375
25052	8477	1918	752036
25053	8477	1919	311853
25054	8412	1921	\N
25055	8478	1921	\N
25056	8413	1923	\N
25057	8413	1924	\N
25058	8413	1926	414874
25059	8413	1927	710633
25060	8414	1928	\N
25061	8414	1929	424955
25062	8414	1930	207071
25063	8414	1931	285139
25064	8414	1932	971114
25065	8415	1933	\N
25066	8415	1934	\N
25067	8415	1935	\N
25068	8415	1937	\N
25069	8415	1939	574542
25070	8416	1940	\N
25071	8416	1942	\N
25072	8416	1943	\N
25073	8416	1944	904798
25074	8417	1946	\N
25075	8417	1948	364073
25076	8417	1949	389181
25077	8418	1951	\N
25078	8418	1952	\N
25079	8418	1953	342554
25080	8418	1954	842772
25081	8418	1955	880847
25082	8419	1956	\N
25083	8419	1957	\N
25084	8419	1958	\N
25085	8419	1959	\N
25086	8419	1961	\N
25087	8420	1962	\N
25088	8420	1963	\N
25089	8420	1965	\N
25090	8420	1966	210003
25091	8420	1967	819847
25092	8421	1968	\N
25093	8422	1969	\N
25094	8422	1970	906054
25095	8423	1971	\N
25096	8423	1972	653807
25097	8423	1974	159822
25098	8423	1976	343284
25099	8423	1977	560423
25100	8424	1978	\N
25101	8424	1979	\N
25102	8424	1981	569801
25103	8424	1982	783641
25104	8425	1983	828166
25105	8425	1984	155841
25106	8425	1985	673897
25107	8425	1986	176456
25108	8479	1988	\N
25109	8543	1987	\N
25110	8543	1989	\N
25111	8543	1990	\N
25112	8543	1991	\N
25113	8616	1987	\N
25114	8616	1988	\N
25115	8616	1989	\N
25116	8543	1993	843271
25117	8480	1994	\N
25118	8480	1995	\N
25119	8544	1996	871704
25120	8544	1998	907983
25121	8617	1997	606595
25122	8617	1999	436049
25123	8617	0	213110
25124	8617	1	188057
25125	8545	2	\N
25126	8545	3	\N
25127	8545	4	548485
25128	8545	5	372554
25129	8618	4	427305
25130	8618	5	744229
25131	8618	7	103768
25132	8619	8	771698
25133	8481	9	\N
25134	8481	11	\N
25135	8481	12	\N
25136	8481	13	\N
25137	8481	14	\N
25138	8546	9	\N
25139	8546	10	\N
25140	8620	9	\N
25141	8620	10	\N
25142	8620	11	\N
25143	8546	16	736222
25144	8546	17	147755
25145	8621	18	\N
25146	8621	19	\N
25147	8482	20	793105
25148	8621	21	389258
25149	8621	22	751818
25150	8621	23	617958
25151	8483	24	\N
25152	8483	25	\N
25153	8483	26	\N
25154	8483	28	\N
25155	8547	25	\N
25156	8622	24	\N
25157	8622	25	\N
25158	8622	26	\N
25159	8622	27	\N
25160	8622	28	\N
25161	8483	29	664200
25162	8484	30	\N
25163	8484	31	\N
25164	8484	32	\N
25165	8548	30	\N
25166	8623	30	\N
25167	8623	31	\N
25168	8484	34	443200
25169	8548	33	926072
25170	8548	34	435234
25171	8548	36	911605
25172	8485	38	\N
25173	8624	38	\N
25174	8624	40	\N
25175	8624	41	\N
25176	8485	42	229111
25177	8485	43	380550
25178	8485	44	202428
25179	8549	43	230168
25180	8624	42	561918
25181	8550	45	\N
25182	8550	46	\N
25183	8550	48	\N
25184	8625	45	\N
25185	8625	46	\N
25186	8486	49	481185
25187	8550	49	181120
25188	8550	50	672195
25189	8487	51	\N
25190	8487	52	\N
25191	8551	51	\N
25192	8487	54	956468
25193	8487	55	437739
25194	8551	53	529621
25195	8488	56	\N
25196	8488	58	\N
25197	8488	59	\N
25198	8488	60	\N
25199	8552	56	\N
25200	8552	57	\N
25201	8552	59	\N
25202	8626	56	\N
25203	8626	57	\N
25204	8626	58	\N
25205	8488	62	602192
25206	8489	64	\N
25207	8489	65	\N
25208	8489	66	\N
25209	8627	63	\N
25210	8489	68	662822
25211	8553	67	240522
25212	8553	68	831131
25213	8553	70	983098
25214	8553	71	542513
25215	8553	72	564347
25216	8554	73	\N
25217	8554	74	\N
25218	8554	75	\N
25219	8628	73	\N
25220	8628	74	\N
25221	8628	76	\N
25222	8628	77	\N
25223	8554	78	627586
25224	8628	79	785406
25225	8490	80	\N
25226	8490	82	\N
25227	8555	80	\N
25228	8555	81	\N
25229	8555	83	912782
25230	8555	85	780052
25231	8491	86	\N
25232	8491	87	\N
25233	8491	88	\N
25234	8556	90	119901
25235	8556	92	239251
25236	8556	93	973468
25237	8556	94	904291
25238	8492	95	\N
25239	8492	96	\N
25240	8492	97	\N
25241	8629	95	\N
25242	8492	98	280413
25243	8492	99	225591
25244	8557	98	622723
25245	8557	100	345186
25246	8557	102	912281
25247	8557	103	907949
25248	8629	99	460417
25249	8629	100	117294
25250	8493	104	\N
25251	8493	105	\N
25252	8558	105	\N
25253	8558	106	\N
25254	8493	108	775882
25255	8493	110	571699
25256	8493	111	668870
25257	8558	108	729253
25258	8630	107	902966
25259	8631	112	\N
25260	8631	113	\N
25261	8631	114	\N
25262	8631	115	341962
25263	8631	116	215379
25264	8494	117	\N
25265	8494	118	800613
25266	8494	119	983382
25267	8495	121	\N
25268	8632	120	\N
25269	8559	122	473587
25270	8632	123	325993
25271	8632	124	295841
25272	8632	125	283065
25273	8496	126	\N
25274	8496	127	\N
25275	8560	126	\N
25276	8633	127	\N
25277	8496	129	883212
25278	8560	128	795209
25279	8560	129	873835
25280	8497	131	\N
25281	8497	133	\N
25282	8561	131	\N
25283	8561	133	\N
25284	8561	134	\N
25285	8561	136	\N
25286	8561	138	\N
25287	8497	139	143439
25288	8634	139	436239
25289	8634	140	991336
25290	8634	141	789526
25291	8634	142	372879
25292	8562	143	\N
25293	8562	145	\N
25294	8562	146	\N
25295	8562	147	\N
25296	8635	143	\N
25297	8498	149	210338
25298	8635	148	528346
25299	8499	150	\N
25300	8563	150	\N
25301	8563	151	\N
25302	8563	152	\N
25303	8499	154	535261
25304	8563	153	941873
25305	8563	154	131463
25306	8500	155	\N
25307	8500	157	\N
25308	8500	158	\N
25309	8564	155	\N
25310	8500	159	845281
25311	8564	159	696253
25312	8501	161	\N
25313	8565	162	208312
25314	8565	164	888245
25315	8636	162	933582
25316	8566	165	\N
25317	8566	166	\N
25318	8566	167	\N
25319	8566	168	\N
25320	8566	169	\N
25321	8502	171	142091
25322	8502	172	791868
25323	8503	173	\N
25324	8503	174	379045
25325	8503	176	283699
25326	8503	178	185257
25327	8567	174	844468
25328	8567	175	635409
25329	8567	177	525110
25330	8567	179	701431
25331	8504	180	\N
25332	8504	182	\N
25333	8504	183	\N
25334	8568	185	193685
25335	8568	186	409366
25336	8569	187	\N
25337	8637	188	\N
25338	8637	189	\N
25339	8637	190	\N
25340	8637	191	\N
25341	8505	192	591805
25342	8569	192	192356
25343	8637	192	954470
25344	8570	194	\N
25345	8506	195	408863
25346	8638	196	514108
25347	8507	198	\N
25348	8571	198	\N
25349	8571	199	\N
25350	8571	201	\N
25351	8571	203	\N
25352	8639	205	562718
25353	8639	206	350964
25354	8640	207	\N
25355	8508	208	748025
25356	8640	209	329243
25357	8640	210	933289
25358	8641	211	\N
25359	8509	212	758575
25360	8509	213	425810
25361	8641	213	549547
25362	8510	214	521783
25363	8510	216	759070
25364	8511	217	\N
25365	8511	218	\N
25366	8511	219	464603
25367	8511	220	654483
25368	8642	219	681412
25369	8642	221	633556
25370	8642	223	615179
25371	8642	224	726391
25372	8572	226	\N
25373	8643	225	\N
25374	8643	226	\N
25375	8643	227	\N
25376	8572	228	649286
25377	8643	229	812544
25378	8643	230	162415
25379	8512	232	\N
25380	8512	233	\N
25381	8573	231	\N
25382	8573	232	\N
25383	8644	232	\N
25384	8644	234	\N
25385	8644	235	\N
25386	8644	236	\N
25387	8512	237	539977
25388	8512	238	120621
25389	8644	237	590545
25390	8513	239	\N
25391	8645	239	\N
25392	8645	241	\N
25393	8513	243	754211
25394	8645	243	935675
25395	8574	244	\N
25396	8574	245	\N
25397	8574	246	573874
25398	8574	248	989634
25399	8574	249	617110
25400	8514	250	\N
25401	8514	251	\N
25402	8575	250	\N
25403	8575	251	\N
25404	8575	252	\N
25405	8514	253	362929
25406	8575	253	751298
25407	8646	253	167423
25408	8646	254	958791
25409	8646	255	671652
25410	8646	256	448654
25411	8515	257	\N
25412	8515	259	\N
25413	8515	260	\N
25414	8576	258	\N
25415	8576	259	\N
25416	8647	257	\N
25417	8647	259	\N
25418	8515	261	496727
25419	8515	262	480695
25420	8576	261	104452
25421	8648	263	\N
25422	8648	264	\N
25423	8516	265	193335
25424	8577	265	318407
25425	8577	266	245462
25426	8577	267	140504
25427	8577	268	926419
25428	8578	269	\N
25429	8649	269	\N
25430	8578	270	834045
25431	8649	270	361107
25432	8649	271	921465
25433	8649	272	418216
25434	8649	273	918243
25435	8579	274	\N
25436	8517	275	703774
25437	8517	276	615140
25438	8517	277	724739
25439	8517	279	956141
25440	8650	275	253237
25441	8650	276	895073
25442	8580	280	\N
25443	8651	281	709466
25444	8651	282	981406
25445	8651	283	816937
25446	8651	284	647727
25447	8651	285	925438
25448	8518	286	\N
25449	8518	287	\N
25450	8581	286	\N
25451	8581	287	\N
25452	8581	288	\N
25453	8652	286	\N
25454	8652	287	\N
25455	8581	290	281936
25456	8582	291	\N
25457	8582	293	\N
25458	8582	295	\N
25459	8582	296	\N
25460	8653	291	\N
25461	8653	292	\N
25462	8653	293	\N
25463	8653	295	\N
25464	8653	296	\N
25465	8519	298	911066
25466	8519	299	153853
25467	8582	297	389817
25468	8583	300	\N
25469	8520	302	108331
25470	8520	303	934136
25471	8520	304	158182
25472	8520	306	971741
25473	8520	307	353998
25474	8654	309	\N
25475	8654	311	\N
25476	8654	313	\N
25477	8521	314	896263
25478	8584	314	146104
25479	8585	316	\N
25480	8585	317	\N
25481	8655	315	\N
25482	8522	318	463044
25483	8523	319	\N
25484	8523	321	\N
25485	8523	322	\N
25486	8523	323	\N
25487	8586	319	\N
25488	8656	320	\N
25489	8656	321	\N
25490	8656	324	169105
25491	8524	325	\N
25492	8524	327	\N
25493	8657	326	\N
25494	8587	328	670044
25495	8587	330	932058
25496	8587	331	543116
25497	8587	332	974032
25498	8587	333	364043
25499	8525	334	\N
25500	8588	335	\N
25501	8588	337	\N
25502	8658	334	\N
25503	8588	339	481750
25504	8588	341	464397
25505	8589	342	\N
25506	8589	343	\N
25507	8659	343	\N
25508	8526	344	540695
25509	8659	344	986108
25510	8659	345	370539
25511	8527	346	524543
25512	8590	346	272792
25513	8528	347	\N
25514	8528	348	\N
25515	8591	347	\N
25516	8591	348	\N
25517	8660	348	\N
25518	8591	349	774772
25519	8591	350	539117
25520	8592	351	\N
25521	8592	352	\N
25522	8592	353	\N
25523	8592	354	\N
25524	8529	355	269201
25525	8529	356	437918
25526	8529	357	185100
25527	8529	358	439138
25528	8529	360	903874
25529	8592	355	684424
25530	8661	355	781597
25531	8661	356	836229
25532	8661	357	707112
25533	8661	358	719782
25534	8661	359	444372
25535	8593	362	\N
25536	8662	361	\N
25537	8662	362	\N
25538	8662	363	\N
25539	8662	364	\N
25540	8662	365	\N
25541	8530	366	787859
25542	8593	366	882151
25543	8593	367	267390
25544	8663	369	\N
25545	8663	370	\N
25546	8531	371	935711
25547	8594	371	348383
25548	8594	373	603100
25549	8594	374	525180
25550	8594	375	957243
25551	8594	376	231678
25552	8663	371	982693
25553	8663	372	660598
25554	8663	373	866207
25555	8532	377	\N
25556	8664	378	\N
25557	8532	380	814926
25558	8664	379	392605
25559	8664	380	858944
25560	8664	381	198024
25561	8533	382	\N
25562	8595	382	\N
25563	8665	382	\N
25564	8533	383	271460
25565	8533	384	750371
25566	8665	383	456919
25567	8534	386	\N
25568	8534	387	\N
25569	8596	388	338107
25570	8535	389	375303
25571	8535	391	649720
25572	8535	392	447872
25573	8535	394	590943
25574	8597	390	132320
25575	8597	391	903778
25576	8597	392	818281
25577	8666	390	281115
25578	8598	395	\N
25579	8536	396	744651
25580	8598	397	748526
25581	8598	399	420465
25582	8598	401	535069
25583	8598	402	552796
25584	8667	404	\N
25585	8537	406	955883
25586	8599	406	958376
25587	8599	408	758818
25588	8599	410	304785
25589	8599	411	700515
25590	8538	412	900448
25591	8538	414	280178
25592	8538	415	806939
25593	8538	416	632113
25594	8538	417	457555
25595	8600	412	325924
25596	8600	413	694676
25597	8600	414	447028
25598	8600	415	741448
25599	8668	412	646677
25600	8668	413	636061
25601	8668	414	897691
25602	8668	415	417362
25603	8539	419	\N
25604	8601	418	\N
25605	8601	419	\N
25606	8669	419	\N
25607	8669	420	756354
25608	8669	422	731105
25609	8669	423	350061
25610	8669	424	669930
25611	8602	425	\N
25612	8670	426	\N
25613	8540	427	465327
25614	8540	428	220320
25615	8540	429	435168
25616	8540	431	181970
25617	8540	433	804556
25618	8602	427	172315
25619	8602	428	426331
25620	8602	429	971486
25621	8602	431	862254
25622	8670	427	622311
25623	8603	434	\N
25624	8603	435	\N
25625	8603	436	\N
25626	8603	437	267956
25627	8604	438	412982
25628	8604	439	353632
25629	8604	440	785761
25630	8671	439	240658
25631	8541	442	504537
25632	8541	443	362068
25633	8541	444	865190
25634	8541	446	338962
25635	8541	447	152597
25636	8605	442	520850
25637	8605	444	318035
25638	8605	446	844445
25639	8605	447	107167
25640	8605	448	787736
25641	8672	441	336915
25642	8672	442	156730
25643	8672	443	223875
25644	8606	450	\N
25645	8606	451	\N
25646	8673	450	\N
25647	8673	451	\N
25648	8673	453	\N
25649	8606	454	277352
25650	8673	454	469848
25651	8673	455	723926
25652	8542	457	\N
25653	8542	458	\N
25654	8607	456	\N
25655	8607	459	756467
25656	8674	461	\N
25657	8674	462	\N
25658	8608	463	929487
25659	8608	464	992556
25660	8608	465	810751
25661	8608	467	553836
25662	8609	469	283895
25663	8609	470	111165
25664	8675	468	479864
25665	8675	469	607051
25666	8675	470	629119
25667	8675	471	528189
25668	8675	472	355841
25669	8610	473	\N
25670	8610	474	\N
25671	8610	475	\N
25672	8676	473	\N
25673	8676	474	\N
25674	8676	475	\N
25675	8676	477	178444
25676	8611	479	\N
25677	8677	478	\N
25678	8677	479	\N
25679	8611	480	524359
25680	8611	481	229796
25681	8677	480	265996
25682	8612	482	\N
25683	8612	483	\N
25684	8612	484	\N
25685	8612	486	\N
25686	8612	487	114857
25687	8678	487	325549
25688	8678	488	483986
25689	8678	489	244884
25690	8678	491	771699
25691	8678	492	309082
25692	8613	493	\N
25693	8679	494	941241
25694	8679	495	119738
25695	8679	496	561158
25696	8679	498	989728
25697	8679	499	633881
25698	8680	500	\N
25699	8680	501	\N
25700	8680	502	\N
25701	8680	503	871099
25702	8614	504	\N
25703	8681	506	\N
25704	8681	508	670835
25705	8681	509	598968
25706	8615	511	\N
25707	8682	510	\N
25708	8682	512	685884
25709	8683	514	277116
25710	8684	515	750464
25711	8684	517	369432
25712	8684	518	543688
25713	8685	519	538988
25714	8685	520	690198
25715	8685	521	772273
25716	8685	523	721119
25717	8685	524	761290
25718	8686	526	347480
25719	8686	527	187917
25720	8686	528	145883
25721	8686	529	746743
25722	8686	530	653077
25723	8687	531	517298
25724	8687	532	532644
25725	8687	533	639070
25726	8688	534	\N
25727	8688	535	332286
25728	8689	536	\N
25729	8689	537	\N
25730	8689	538	\N
25731	8689	539	\N
25732	8690	541	327652
25733	8690	542	677148
25734	8690	543	335619
25735	8691	544	303532
25736	8692	545	\N
25737	8692	546	\N
25738	8692	548	\N
25739	8692	549	\N
25740	8692	550	478931
25741	8693	551	\N
25742	8693	552	\N
25743	8693	553	\N
25744	8694	554	\N
25745	8694	556	428349
25746	8694	558	178849
25747	8694	559	905804
25748	8694	560	126115
25749	8695	561	\N
25750	8695	562	\N
25751	8695	563	\N
25752	8695	564	\N
25753	8695	565	\N
25754	8696	566	\N
25755	8696	567	602178
25756	8696	568	565173
25757	8697	569	\N
25758	8698	570	\N
25759	8699	572	\N
25760	8699	574	\N
25761	8760	571	\N
25762	8699	575	948064
25763	8760	576	497939
25764	8761	577	\N
25765	8700	578	894422
25766	8761	579	816932
25767	8761	581	725892
25768	8761	583	631147
25769	8761	584	981736
25770	8701	586	\N
25771	8701	588	\N
25772	8701	589	\N
25773	8701	590	724300
25774	8762	592	\N
25775	8702	593	918976
25776	8702	594	421945
25777	8702	595	387328
25778	8762	594	530288
25779	8703	596	\N
25780	8703	598	\N
25781	8703	599	\N
25782	8703	600	\N
25783	8763	596	\N
25784	8763	601	245113
25785	8704	602	\N
25786	8704	604	\N
25787	8764	602	\N
25788	8764	603	\N
25789	8764	606	842190
25790	8705	607	\N
25791	8765	608	\N
25792	8705	610	732610
25793	8705	611	910243
25794	8765	609	372759
25795	8765	610	363760
25796	8765	612	806151
25797	8765	614	829754
25798	8766	615	\N
25799	8766	616	\N
25800	8766	617	\N
25801	8706	618	709712
25802	8707	619	\N
25803	8707	620	\N
25804	8767	619	\N
25805	8767	622	848934
25806	8708	623	584003
25807	8708	624	220921
25808	8768	623	506643
25809	8709	626	\N
25810	8709	627	\N
25811	8709	628	\N
25812	8709	630	\N
25813	8709	631	\N
25814	8769	625	\N
25815	8769	626	\N
25816	8769	627	\N
25817	8769	628	\N
25818	8769	629	\N
25819	8710	632	\N
25820	8710	634	\N
25821	8770	633	\N
25822	8770	634	\N
25823	8770	636	554437
25824	8770	638	305155
25825	8711	640	\N
25826	8711	641	\N
25827	8711	642	\N
25828	8771	639	\N
25829	8712	644	\N
25830	8772	643	\N
25831	8772	644	\N
25832	8772	645	\N
25833	8712	646	470551
25834	8712	648	522986
25835	8712	650	518198
25836	8713	652	\N
25837	8713	653	\N
25838	8773	651	\N
25839	8773	654	551029
25840	8773	656	261686
25841	8714	657	\N
25842	8714	658	\N
25843	8714	659	\N
25844	8714	661	\N
25845	8714	662	\N
25846	8774	664	592989
25847	8774	665	513214
25848	8775	666	\N
25849	8715	667	534484
25850	8775	667	638417
25851	8775	668	216765
25852	8775	670	673392
25853	8775	671	648665
25854	8716	672	\N
25855	8716	673	\N
25856	8776	672	\N
25857	8776	673	\N
25858	8776	674	\N
25859	8776	676	\N
25860	8776	678	\N
25861	8717	680	\N
25862	8717	681	\N
25863	8717	683	\N
25864	8777	680	\N
25865	8717	684	963918
25866	8717	685	123452
25867	8718	686	\N
25868	8718	687	\N
25869	8718	688	\N
25870	8718	689	605102
25871	8718	690	407652
25872	8778	689	637582
25873	8778	690	133220
25874	8778	691	742826
25875	8778	692	921220
25876	8719	694	\N
25877	8719	695	\N
25878	8719	696	\N
25879	8719	697	912575
25880	8720	698	\N
25881	8779	700	584387
25882	8721	701	\N
25883	8721	702	\N
25884	8780	701	\N
25885	8721	703	488258
25886	8721	704	792054
25887	8721	706	432187
25888	8780	703	803248
25889	8780	704	900388
25890	8722	707	\N
25891	8722	708	\N
25892	8781	707	\N
25893	8722	709	906995
25894	8723	711	402831
25895	8723	713	958814
25896	8723	715	904826
25897	8723	716	263809
25898	8723	717	379448
25899	8782	710	301986
25900	8782	711	433607
25901	8782	712	455697
25902	8724	718	\N
25903	8724	720	\N
25904	8724	721	\N
25905	8724	723	\N
25906	8724	724	473829
25907	8725	725	\N
25908	8783	725	\N
25909	8725	727	318790
25910	8725	728	225274
25911	8726	730	\N
25912	8784	729	\N
25913	8784	731	988078
25914	8784	732	409602
25915	8784	733	540226
25916	8784	734	524268
25917	8727	735	\N
25918	8727	736	\N
25919	8727	737	\N
25920	8785	735	\N
25921	8785	736	\N
25922	8786	738	539186
25923	8786	739	753326
25924	8786	740	581170
25925	8787	742	\N
25926	8787	743	360725
25927	8787	745	746240
25928	8787	746	813372
25929	8787	747	357897
25930	8788	748	\N
25931	8788	749	\N
25932	8788	751	283952
25933	8788	753	808143
25934	8728	755	280858
25935	8728	757	683283
25936	8789	754	509661
25937	8789	755	632243
25938	8729	758	\N
25939	8729	759	\N
25940	8790	758	\N
25941	8790	759	\N
25942	8790	761	\N
25943	8729	762	594337
25944	8729	763	433657
25945	8729	765	134481
25946	8730	766	\N
25947	8730	768	\N
25948	8730	770	\N
25949	8730	771	\N
25950	8791	766	\N
25951	8791	772	542964
25952	8791	773	277277
25953	8791	774	444962
25954	8731	776	\N
25955	8731	777	\N
25956	8731	778	\N
25957	8731	779	\N
25958	8792	780	862853
25959	8732	781	\N
25960	8793	781	\N
25961	8793	783	\N
25962	8732	785	597227
25963	8732	786	110445
25964	8793	784	159139
25965	8793	785	674691
25966	8793	787	647559
25967	8733	788	\N
25968	8733	789	\N
25969	8733	790	583054
25970	8794	790	462889
25971	8794	792	825437
25972	8794	793	313353
25973	8794	794	618913
25974	8794	795	906197
25975	8734	797	\N
25976	8795	796	\N
25977	8795	798	\N
25978	8734	799	119290
25979	8735	801	\N
25980	8735	803	\N
25981	8796	800	\N
25982	8796	801	\N
25983	8796	803	\N
25984	8796	804	899002
25985	8796	805	427408
25986	8736	807	\N
25987	8797	806	\N
25988	8797	807	\N
25989	8797	809	928724
25990	8797	810	954478
25991	8797	811	407123
25992	8737	812	\N
25993	8737	813	\N
25994	8737	814	\N
25995	8798	812	\N
25996	8798	813	\N
25997	8737	815	891165
25998	8798	815	143643
25999	8798	816	278195
26000	8798	817	704994
26001	8738	818	\N
26002	8738	819	\N
26003	8799	820	898610
26004	8799	821	249713
26005	8799	822	669597
26006	8739	824	\N
26007	8800	823	\N
26008	8800	825	\N
26009	8800	827	\N
26010	8739	828	543642
26011	8739	829	134428
26012	8800	828	914286
26013	8801	830	479980
26014	8740	831	\N
26015	8740	832	\N
26016	8802	832	\N
26017	8802	833	\N
26018	8802	835	\N
26019	8802	837	\N
26020	8740	839	478341
26021	8740	840	560529
26022	8740	841	229054
26023	8803	843	\N
26024	8803	844	\N
26025	8803	845	\N
26026	8803	847	\N
26027	8803	848	\N
26028	8741	850	982031
26029	8741	851	846308
26030	8742	852	\N
26031	8804	852	\N
26032	8742	853	847345
26033	8742	854	937660
26034	8742	855	403669
26035	8804	853	882014
26036	8804	854	108897
26037	8804	855	852080
26038	8743	856	409880
26039	8743	858	943018
26040	8743	860	556407
26041	8743	861	901063
26042	8744	862	\N
26043	8744	863	\N
26044	8744	864	\N
26045	8744	866	\N
26046	8805	867	\N
26047	8745	868	628319
26048	8745	869	596101
26049	8745	870	352294
26050	8805	868	250567
26051	8805	869	912126
26052	8806	871	\N
26053	8806	872	\N
26054	8806	873	\N
26055	8746	874	534676
26056	8746	876	256101
26057	8746	877	920443
26058	8806	874	912600
26059	8806	876	210514
26060	8747	879	\N
26061	8747	881	\N
26062	8807	879	\N
26063	8807	880	\N
26064	8807	881	\N
26065	8807	882	828718
26066	8808	883	\N
26067	8808	885	\N
26068	8748	886	\N
26069	8809	888	267375
26070	8810	889	\N
26071	8810	890	\N
26072	8749	891	752414
26073	8749	892	222274
26074	8749	893	567487
26075	8749	894	832334
26076	8749	895	855220
26077	8810	891	101819
26078	8810	892	575503
26079	8810	893	445248
26080	8750	896	769392
26081	8811	896	726609
26082	8751	898	\N
26083	8751	899	\N
26084	8752	900	\N
26085	8752	902	\N
26086	8753	903	575330
26087	8754	904	\N
26088	8754	905	\N
26089	8754	906	\N
26090	8754	907	895785
26091	8754	908	363757
26092	8755	909	\N
26093	8755	910	399969
26094	8756	911	\N
26095	8756	913	426477
26096	8756	914	327834
26097	8756	915	743648
26098	8757	916	\N
26099	8757	917	\N
26100	8757	918	\N
26101	8757	919	\N
26102	8758	920	\N
26103	8758	921	757173
26104	8758	923	785964
26105	8758	925	500123
26106	8759	927	780503
26107	8812	929	\N
26108	8812	930	601985
26109	8812	931	950347
26110	8812	932	808777
26111	8859	930	844005
26112	8908	930	838737
26113	8813	933	389110
26114	8813	934	271401
26115	8813	935	263124
26116	8813	936	918340
26117	8860	933	116050
26118	8860	935	388010
26119	8860	936	439657
26120	8860	938	899202
26121	8814	939	\N
26122	8861	939	\N
26123	8814	940	694481
26124	8814	941	277401
26125	8814	942	385390
26126	8909	943	\N
26127	8862	944	217277
26128	8862	945	934865
26129	8862	946	916597
26130	8815	948	\N
26131	8863	947	\N
26132	8863	948	\N
26133	8863	950	\N
26134	8910	947	\N
26135	8910	949	\N
26136	8910	950	\N
26137	8910	951	\N
26138	8910	953	\N
26139	8816	954	\N
26140	8816	955	\N
26141	8816	957	\N
26142	8816	958	\N
26143	8864	954	\N
26144	8864	955	\N
26145	8864	956	\N
26146	8864	957	\N
26147	8864	959	\N
26148	8816	960	167510
26149	8865	962	\N
26150	8865	963	555305
26151	8817	965	\N
26152	8911	964	\N
26153	8817	966	393381
26154	8817	968	255696
26155	8817	970	757289
26156	8817	972	908426
26157	8911	967	333655
26158	8911	968	904757
26159	8911	970	792180
26160	8818	973	\N
26161	8818	974	\N
26162	8912	973	\N
26163	8866	975	288282
26164	8819	976	\N
26165	8819	977	\N
26166	8819	978	\N
26167	8867	976	\N
26168	8913	976	\N
26169	8913	978	\N
26170	8819	979	485840
26171	8868	980	\N
26172	8868	981	\N
26173	8914	981	\N
26174	8820	982	935518
26175	8820	983	927100
26176	8820	984	100228
26177	8820	986	455067
26178	8868	982	429843
26179	8868	983	231423
26180	8868	984	919190
26181	8914	982	614947
26182	8869	988	\N
26183	8869	989	\N
26184	8869	990	\N
26185	8915	991	547351
26186	8915	992	976782
26187	8915	993	651552
26188	8915	994	929888
26189	8915	995	211234
26190	8821	996	763497
26191	8821	997	645604
26192	8821	998	391485
26193	8821	999	622359
26194	8821	1000	258687
26195	8822	1001	\N
26196	8822	1002	\N
26197	8822	1003	\N
26198	8870	1001	\N
26199	8870	1002	\N
26200	8870	1004	\N
26201	8870	1005	\N
26202	8916	1002	\N
26203	8916	1003	\N
26204	8822	1007	630166
26205	8871	1009	\N
26206	8871	1010	\N
26207	8823	1011	407216
26208	8823	1012	527226
26209	8823	1013	211144
26210	8823	1014	728421
26211	8871	1011	151733
26212	8871	1013	605633
26213	8871	1014	761236
26214	8824	1015	\N
26215	8824	1016	\N
26216	8824	1017	\N
26217	8917	1015	\N
26218	8824	1018	624863
26219	8825	1019	\N
26220	8825	1020	\N
26221	8825	1021	\N
26222	8872	1019	\N
26223	8872	1020	\N
26224	8825	1023	777850
26225	8825	1024	681538
26226	8918	1022	559105
26227	8918	1023	272068
26228	8919	1025	\N
26229	8826	1026	\N
26230	8826	1027	\N
26231	8826	1028	\N
26232	8826	1030	\N
26233	8826	1031	\N
26234	8873	1026	\N
26235	8873	1027	\N
26236	8873	1032	991835
26237	8873	1033	914811
26238	8873	1034	155856
26239	8920	1033	230359
26240	8920	1035	255649
26241	8920	1037	733772
26242	8827	1039	\N
26243	8874	1038	\N
26244	8921	1039	\N
26245	8921	1040	\N
26246	8921	1042	\N
26247	8827	1043	673338
26248	8921	1044	631502
26249	8828	1046	\N
26250	8875	1045	\N
26251	8829	1048	\N
26252	8829	1050	\N
26253	8922	1048	\N
26254	8922	1049	\N
26255	8922	1050	\N
26256	8830	1052	\N
26257	8876	1053	\N
26258	8876	1054	\N
26259	8876	1055	\N
26260	8876	1056	\N
26261	8876	1057	\N
26262	8923	1058	\N
26263	8923	1059	\N
26264	8923	1061	183066
26265	8923	1062	790525
26266	8831	1063	516441
26267	8924	1063	187360
26268	8832	1064	\N
26269	8925	1064	\N
26270	8925	1065	\N
26271	8925	1066	\N
26272	8925	1067	\N
26273	8832	1069	795953
26274	8832	1070	149364
26275	8877	1071	\N
26276	8877	1072	\N
26277	8877	1073	\N
26278	8877	1074	\N
26279	8833	1075	195096
26280	8833	1076	681379
26281	8833	1078	651074
26282	8877	1075	266596
26283	8926	1075	595125
26284	8926	1077	255945
26285	8926	1079	950365
26286	8834	1080	\N
26287	8878	1080	\N
26288	8927	1080	\N
26289	8927	1081	\N
26290	8927	1082	\N
26291	8927	1083	\N
26292	8927	1084	\N
26293	8834	1085	656430
26294	8878	1085	875533
26295	8878	1087	257643
26296	8835	1088	\N
26297	8879	1089	\N
26298	8879	1090	\N
26299	8879	1092	\N
26300	8879	1093	\N
26301	8835	1094	981869
26302	8835	1095	782406
26303	8928	1095	140350
26304	8928	1096	177226
26305	8928	1097	921570
26306	8929	1098	\N
26307	8929	1099	\N
26308	8836	1100	864467
26309	8837	1101	\N
26310	8880	1101	\N
26311	8930	1101	\N
26312	8837	1102	558647
26313	8837	1103	603274
26314	8880	1103	217618
26315	8880	1104	148726
26316	8880	1105	429107
26317	8930	1102	176724
26318	8930	1103	406840
26319	8930	1105	554572
26320	8930	1107	394192
26321	8838	1108	\N
26322	8838	1109	\N
26323	8881	1108	\N
26324	8881	1109	\N
26325	8881	1110	435839
26326	8881	1111	898223
26327	8881	1112	156608
26328	8931	1111	176648
26329	8931	1113	654655
26330	8931	1115	320636
26331	8931	1116	776917
26332	8882	1117	\N
26333	8839	1118	401098
26334	8839	1119	742452
26335	8882	1119	456745
26336	8882	1120	561675
26337	8882	1121	574583
26338	8932	1118	233662
26339	8932	1120	794170
26340	8932	1122	706521
26341	8933	1123	\N
26342	8840	1125	635758
26343	8933	1125	360550
26344	8933	1126	884881
26345	8934	1127	\N
26346	8934	1128	\N
26347	8934	1129	\N
26348	8841	1130	560479
26349	8841	1131	960871
26350	8883	1130	637553
26351	8842	1133	\N
26352	8884	1133	\N
26353	8884	1134	\N
26354	8884	1135	\N
26355	8884	1136	\N
26356	8842	1137	179023
26357	8842	1138	543970
26358	8842	1140	378460
26359	8935	1141	\N
26360	8885	1142	343194
26361	8885	1143	911765
26362	8935	1143	869730
26363	8935	1144	187420
26364	8935	1145	229722
26365	8935	1146	118524
26366	8843	1147	\N
26367	8843	1148	\N
26368	8843	1149	\N
26369	8886	1148	\N
26370	8843	1150	841910
26371	8886	1150	767063
26372	8886	1151	482105
26373	8886	1152	279446
26374	8886	1153	817274
26375	8936	1150	472019
26376	8936	1151	603428
26377	8937	1154	\N
26378	8844	1155	681956
26379	8887	1155	307786
26380	8887	1156	160511
26381	8887	1157	677324
26382	8937	1155	446321
26383	8845	1158	\N
26384	8845	1160	757678
26385	8845	1161	404954
26386	8845	1162	883014
26387	8845	1163	207971
26388	8888	1159	670560
26389	8888	1160	372667
26390	8888	1161	773908
26391	8888	1162	621440
26392	8888	1163	157585
26393	8938	1159	268298
26394	8938	1161	961265
26395	8938	1163	943073
26396	8938	1164	176771
26397	8938	1165	665799
26398	8889	1166	\N
26399	8846	1167	671109
26400	8889	1167	691481
26401	8939	1168	752558
26402	8847	1169	\N
26403	8847	1170	\N
26404	8847	1171	\N
26405	8847	1172	\N
26406	8847	1174	\N
26407	8940	1170	\N
26408	8940	1171	\N
26409	8940	1173	\N
26410	8890	1175	904490
26411	8890	1176	218371
26412	8890	1178	851995
26413	8890	1179	304616
26414	8890	1180	269573
26415	8940	1175	499298
26416	8891	1181	\N
26417	8891	1182	\N
26418	8941	1184	867058
26419	8892	1185	\N
26420	8892	1186	\N
26421	8942	1185	\N
26422	8848	1188	712744
26423	8848	1189	585010
26424	8848	1190	897107
26425	8848	1192	111240
26426	8892	1187	982987
26427	8942	1187	298104
26428	8942	1189	326491
26429	8893	1193	\N
26430	8943	1193	\N
26431	8943	1194	\N
26432	8849	1195	178603
26433	8943	1195	919404
26434	8943	1197	459561
26435	8943	1198	673016
26436	8894	1199	267217
26437	8850	1200	\N
26438	8895	1200	\N
26439	8895	1202	\N
26440	8850	1203	569057
26441	8944	1203	118956
26442	8944	1205	458158
26443	8944	1206	890380
26444	8944	1208	692402
26445	8944	1210	393951
26446	8851	1212	\N
26447	8851	1214	\N
26448	8851	1216	\N
26449	8896	1212	\N
26450	8896	1213	\N
26451	8945	1212	\N
26452	8851	1218	996779
26453	8851	1219	165992
26454	8852	1221	\N
26455	8852	1222	\N
26456	8852	1223	\N
26457	8852	1224	\N
26458	8852	1225	\N
26459	8946	1221	\N
26460	8897	1226	347777
26461	8897	1228	109123
26462	8897	1229	203055
26463	8897	1230	148961
26464	8897	1231	501902
26465	8946	1226	500153
26466	8898	1232	\N
26467	8898	1233	\N
26468	8898	1235	632232
26469	8853	1236	\N
26470	8899	1236	\N
26471	8899	1237	\N
26472	8947	1236	\N
26473	8899	1239	318776
26474	8899	1240	304516
26475	8947	1238	187140
26476	8947	1239	854896
26477	8947	1240	693637
26478	8854	1241	\N
26479	8900	1242	\N
26480	8948	1241	\N
26481	8948	1242	\N
26482	8948	1244	\N
26483	8948	1246	\N
26484	8854	1247	570372
26485	8948	1247	618238
26486	8855	1248	\N
26487	8855	1250	586182
26488	8855	1251	563942
26489	8855	1253	218676
26490	8855	1254	740015
26491	8949	1249	103866
26492	8949	1250	630519
26493	8949	1251	475826
26494	8949	1252	745580
26495	8949	1253	831414
26496	8856	1255	\N
26497	8856	1256	\N
26498	8901	1255	\N
26499	8901	1256	\N
26500	8901	1257	\N
26501	8950	1258	955299
26502	8902	1260	\N
26503	8902	1261	\N
26504	8951	1260	\N
26505	8951	1261	\N
26506	8902	1262	264636
26507	8951	1262	100952
26508	8903	1263	\N
26509	8903	1264	\N
26510	8857	1265	388999
26511	8857	1266	161689
26512	8952	1265	302253
26513	8858	1267	\N
26514	8904	1267	\N
26515	8904	1268	\N
26516	8953	1267	\N
26517	8953	1268	\N
26518	8953	1269	\N
26519	8904	1270	382518
26520	8904	1272	189552
26521	8904	1273	249187
26522	8953	1270	837734
26523	8953	1271	420866
26524	8905	1274	\N
26525	8905	1275	\N
26526	8905	1276	\N
26527	8905	1278	369407
26528	8954	1278	848657
26529	8955	1279	\N
26530	8955	1280	\N
26531	8955	1281	\N
26532	8906	1282	408156
26533	8906	1284	161097
26534	8955	1282	381090
26535	8956	1285	\N
26536	8956	1286	997509
26537	8907	1288	\N
26538	8907	1289	\N
26539	8907	1290	\N
26540	8907	1291	\N
26541	8957	1292	180804
26542	8958	1293	\N
26543	8958	1294	\N
26544	8958	1295	\N
26545	8959	1296	\N
26546	8959	1297	\N
26547	8959	1298	196441
26548	8960	1299	\N
26549	8960	1300	625057
26550	8960	1301	333927
26551	8961	1302	\N
26552	8961	1303	\N
26553	8961	1304	682850
26554	8962	1305	115032
26555	8963	1306	\N
26556	8963	1307	\N
26557	8964	1308	711731
26558	8964	1309	449650
26559	8964	1311	679346
26560	8965	1313	\N
26561	8965	1314	\N
26562	8965	1315	\N
26563	8965	1316	834866
26564	8966	1317	\N
26565	8966	1318	957980
26566	8967	1320	948451
26567	8967	1321	685398
26568	8967	1322	402662
26569	8968	1323	\N
26570	8968	1324	\N
26571	8969	1325	\N
26572	8969	1326	566316
26573	8969	1328	187458
26574	8969	1329	843686
26575	8969	1330	361402
26576	8970	1331	\N
26577	8971	1332	\N
26578	8971	1334	611251
26579	8971	1335	506355
26580	8971	1336	836817
26581	8972	1337	\N
26582	8972	1339	\N
26583	8972	1340	370593
26584	8972	1341	106987
26585	8972	1343	819044
26586	8973	1344	\N
26587	8973	1345	815261
26588	8973	1346	957458
26589	8973	1348	678953
26590	8973	1349	148038
26591	8974	1350	\N
26592	8974	1351	575169
26593	8974	1353	230097
26594	8975	1354	\N
26595	8976	1355	200836
26596	8977	1356	\N
26597	8977	1357	\N
26598	8977	1358	\N
26599	8977	1360	923740
26600	8978	1361	\N
26601	8979	1362	\N
26602	8979	1363	\N
26603	8979	1364	507499
26604	9051	1364	880011
26605	9052	1365	\N
26606	9052	1366	\N
26607	9052	1367	\N
26608	8980	1368	981191
26609	8980	1369	991842
26610	8980	1370	304867
26611	9053	1372	\N
26612	8981	1374	\N
26613	8981	1375	\N
26614	8981	1376	\N
26615	8981	1377	\N
26616	8981	1378	\N
26617	9054	1373	\N
26618	9054	1379	673710
26619	9054	1380	358244
26620	9054	1382	737711
26621	8982	1383	902729
26622	9055	1384	686582
26623	9055	1385	441461
26624	9056	1387	\N
26625	9056	1389	\N
26626	9056	1390	\N
26627	9056	1391	227662
26628	8983	1393	\N
26629	8983	1394	\N
26630	8983	1396	\N
26631	9057	1392	\N
26632	9057	1394	\N
26633	9057	1397	964950
26634	9057	1398	602780
26635	8984	1399	\N
26636	8984	1400	409348
26637	8985	1401	\N
26638	8985	1402	\N
26639	9058	1404	980897
26640	9058	1405	704472
26641	9058	1407	818891
26642	9058	1408	105867
26643	8986	1409	\N
26644	9059	1409	\N
26645	9059	1410	\N
26646	9059	1411	\N
26647	8986	1412	467829
26648	8986	1413	465813
26649	8986	1414	408170
26650	8987	1416	\N
26651	8987	1417	\N
26652	9060	1416	\N
26653	9060	1418	\N
26654	9060	1419	\N
26655	8987	1421	754327
26656	9060	1420	287512
26657	9060	1421	571684
26658	8988	1423	\N
26659	8988	1424	154051
26660	8988	1425	669867
26661	8988	1426	146183
26662	9061	1424	300432
26663	9061	1425	964024
26664	9061	1426	896171
26665	8989	1427	374274
26666	8989	1429	342725
26667	9062	1427	441616
26668	9063	1430	\N
26669	8990	1431	\N
26670	9064	1432	866733
26671	9065	1433	\N
26672	8991	1435	186797
26673	8991	1436	182272
26674	9066	1435	281803
26675	9066	1436	374569
26676	9066	1437	655250
26677	9066	1438	714950
26678	9066	1440	141157
26679	9067	1441	675373
26680	9068	1442	\N
26681	8992	1443	690086
26682	8992	1444	655316
26683	8992	1445	683430
26684	8992	1446	808676
26685	8992	1447	849517
26686	9068	1443	841930
26687	9069	1449	\N
26688	9069	1450	\N
26689	9069	1451	\N
26690	8993	1452	\N
26691	8993	1454	\N
26692	8993	1456	\N
26693	9070	1452	\N
26694	9070	1454	\N
26695	9070	1455	\N
26696	8993	1457	281048
26697	8994	1459	\N
26698	9071	1458	\N
26699	8994	1461	331755
26700	8994	1462	305447
26701	9071	1460	663408
26702	9071	1462	482387
26703	8995	1463	\N
26704	8995	1464	662458
26705	8995	1465	150673
26706	9072	1464	678858
26707	9072	1465	956471
26708	9072	1467	828026
26709	9072	1468	977668
26710	8996	1469	\N
26711	9073	1469	\N
26712	9073	1470	\N
26713	8996	1471	814056
26714	8997	1472	\N
26715	8997	1474	\N
26716	8997	1475	350567
26717	9074	1476	760814
26718	9074	1477	470540
26719	9074	1478	608706
26720	9074	1479	427986
26721	9074	1481	399915
26722	9075	1482	365138
26723	9075	1483	452593
26724	9076	1484	\N
26725	9076	1486	\N
26726	9076	1488	\N
26727	8998	1489	164413
26728	8998	1490	587477
26729	8998	1491	231178
26730	8998	1493	537492
26731	9076	1489	805233
26732	8999	1494	\N
26733	8999	1495	\N
26734	8999	1496	\N
26735	8999	1498	\N
26736	8999	1499	\N
26737	9077	1500	388831
26738	9077	1501	554743
26739	9077	1503	950903
26740	9077	1505	807020
26741	9077	1506	317309
26742	9000	1507	\N
26743	9000	1508	629710
26744	9078	1509	482576
26745	9078	1511	509814
26746	9078	1512	644300
26747	9078	1513	867603
26748	9079	1514	482623
26749	9001	1515	\N
26750	9001	1516	\N
26751	9001	1518	\N
26752	9080	1515	\N
26753	9080	1517	\N
26754	9080	1518	\N
26755	9080	1520	\N
26756	9002	1522	\N
26757	9002	1523	\N
26758	9081	1522	\N
26759	9081	1523	\N
26760	9081	1524	\N
26761	9002	1526	749629
26762	9002	1527	981254
26763	9003	1528	\N
26764	9003	1529	489000
26765	9003	1530	278039
26766	9003	1531	267559
26767	9082	1530	614377
26768	9082	1531	959944
26769	9004	1532	\N
26770	9004	1533	114267
26771	9083	1533	534585
26772	9083	1535	364377
26773	9005	1536	\N
26774	9005	1537	586455
26775	9084	1538	781786
26776	9084	1539	617496
26777	9084	1540	867709
26778	9084	1542	112896
26779	9006	1543	\N
26780	9006	1544	\N
26781	9006	1545	\N
26782	9085	1543	\N
26783	9006	1547	854052
26784	9085	1547	803001
26785	9085	1548	960783
26786	9007	1549	\N
26787	9007	1551	\N
26788	9007	1553	\N
26789	9007	1554	\N
26790	9086	1549	\N
26791	9086	1550	\N
26792	9086	1551	\N
26793	9007	1555	925288
26794	9086	1556	189377
26795	9086	1557	531928
26796	9087	1558	639044
26797	9087	1560	462666
26798	9087	1561	431955
26799	9087	1563	756377
26800	9087	1565	410785
26801	9008	1567	\N
26802	9008	1568	\N
26803	9008	1569	\N
26804	9008	1571	328043
26805	9088	1570	819585
26806	9009	1572	\N
26807	9089	1572	\N
26808	9089	1573	\N
26809	9089	1574	\N
26810	9089	1576	\N
26811	9089	1577	940148
26812	9010	1578	\N
26813	9010	1579	740305
26814	9011	1580	417129
26815	9011	1581	722636
26816	9011	1582	157819
26817	9011	1584	254356
26818	9011	1585	231954
26819	9012	1586	\N
26820	9012	1588	\N
26821	9013	1589	\N
26822	9013	1590	968154
26823	9013	1592	495656
26824	9013	1593	658987
26825	9014	1594	\N
26826	9014	1595	\N
26827	9014	1596	\N
26828	9014	1598	\N
26829	9014	1599	167242
26830	9015	1600	\N
26831	9015	1602	\N
26832	9015	1603	563979
26833	9015	1604	633400
26834	9016	1605	\N
26835	9016	1607	\N
26836	9016	1608	\N
26837	9016	1610	615816
26838	9017	1611	\N
26839	9018	1612	\N
26840	9018	1613	\N
26841	9018	1614	495438
26842	9018	1615	306695
26843	9019	1617	\N
26844	9019	1618	\N
26845	9019	1619	\N
26846	9020	1620	\N
26847	9020	1621	\N
26848	9020	1622	438122
26849	9020	1623	487440
26850	9021	1624	\N
26851	9022	1625	\N
26852	9022	1627	\N
26853	9022	1628	\N
26854	9023	1629	\N
26855	9023	1630	\N
26856	9024	1631	\N
26857	9025	1632	\N
26858	9025	1633	\N
26859	9025	1635	\N
26860	9025	1636	\N
26861	9026	1637	\N
26862	9027	1638	693527
26863	9027	1639	136233
26864	9027	1640	337056
26865	9027	1642	895589
26866	9027	1643	264496
26867	9028	1644	\N
26868	9028	1645	\N
26869	9028	1646	\N
26870	9029	1647	128413
26871	9030	1648	\N
26872	9030	1649	\N
26873	9030	1650	\N
26874	9030	1651	\N
26875	9031	1653	662572
26876	9032	1654	710062
26877	9033	1655	362534
26878	9033	1656	861141
26879	9034	1657	\N
26880	9035	1658	\N
26881	9035	1659	\N
26882	9035	1660	\N
26883	9036	1662	519600
26884	9037	1663	\N
26885	9037	1664	\N
26886	9037	1666	899838
26887	9037	1667	890634
26888	9037	1668	876433
26889	9038	1669	\N
26890	9038	1671	437106
26891	9039	1672	\N
26892	9039	1673	711693
26893	9039	1675	282860
26894	9039	1677	689019
26895	9039	1678	634660
26896	9040	1679	\N
26897	9040	1680	\N
26898	9041	1682	331145
26899	9041	1683	580575
26900	9041	1684	195615
26901	9041	1685	140672
26902	9042	1686	\N
26903	9042	1687	320216
26904	9042	1688	442023
26905	9042	1689	625458
26906	9042	1690	461165
26907	9043	1691	\N
26908	9043	1692	261196
26909	9044	1693	\N
26910	9044	1694	\N
26911	9044	1695	766083
26912	9045	1696	\N
26913	9045	1697	\N
26914	9045	1699	\N
26915	9045	1700	299706
26916	9046	1701	659126
26917	9046	1702	100518
26918	9046	1703	482620
26919	9047	1704	922511
26920	9048	1705	550896
26921	9048	1706	286374
26922	9049	1708	790142
26923	9049	1709	602864
26924	9049	1710	937538
26925	9049	1711	969324
26926	9049	1712	549435
26927	9050	1713	\N
26928	9050	1715	877504
26929	9090	1716	\N
26930	9090	1717	\N
26931	9226	1716	\N
26932	9226	1717	\N
26933	9226	1719	\N
26934	9226	1720	281741
26935	9176	1721	\N
26936	9176	1722	\N
26937	9227	1721	\N
26938	9227	1722	\N
26939	9091	1723	388212
26940	9091	1724	591896
26941	9091	1725	153639
26942	9091	1726	226508
26943	9091	1728	482388
26944	9176	1723	946587
26945	9176	1724	991008
26946	9176	1725	194965
26947	9092	1729	\N
26948	9092	1730	\N
26949	9177	1729	\N
26950	9177	1731	\N
26951	9177	1733	\N
26952	9177	1734	\N
26953	9228	1729	\N
26954	9093	1735	\N
26955	9093	1736	\N
26956	9178	1735	\N
26957	9178	1736	\N
26958	9178	1737	\N
26959	9229	1735	\N
26960	9178	1739	379342
26961	9178	1741	993373
26962	9229	1739	468414
26963	9229	1741	169572
26964	9094	1742	\N
26965	9094	1744	\N
26966	9094	1745	172241
26967	9094	1746	690726
26968	9179	1746	641036
26969	9095	1747	\N
26970	9095	1748	464418
26971	9095	1750	518090
26972	9230	1748	904052
26973	9230	1750	851783
26974	9230	1751	645165
26975	9230	1752	290662
26976	9096	1754	\N
26977	9096	1755	\N
26978	9180	1753	\N
26979	9180	1754	\N
26980	9231	1754	\N
26981	9231	1757	814574
26982	9097	1758	\N
26983	9232	1759	360477
26984	9232	1760	415256
26985	9232	1761	126480
26986	9232	1762	557481
26987	9232	1763	720053
26988	9181	1765	\N
26989	9098	1767	966446
26990	9233	1766	800828
26991	9233	1768	739944
26992	9182	1769	\N
26993	9234	1769	\N
26994	9234	1770	836361
26995	9234	1771	701607
26996	9099	1773	\N
26997	9099	1775	520240
26998	9100	1777	\N
26999	9100	1778	766907
27000	9183	1778	316788
27001	9101	1780	\N
27002	9184	1779	\N
27003	9184	1780	\N
27004	9184	1781	\N
27005	9235	1779	\N
27006	9184	1782	949389
27007	9184	1783	706819
27008	9102	1785	\N
27009	9185	1784	\N
27010	9185	1786	\N
27011	9236	1785	\N
27012	9102	1787	979667
27013	9186	1788	498661
27014	9237	1788	404254
27015	9187	1790	\N
27016	9103	1791	431384
27017	9187	1791	218166
27018	9187	1792	439244
27019	9238	1791	465113
27020	9188	1794	\N
27021	9188	1795	\N
27022	9188	1796	\N
27023	9239	1793	\N
27024	9239	1794	\N
27025	9104	1798	942491
27026	9104	1799	752156
27027	9188	1797	512423
27028	9188	1798	943911
27029	9239	1797	366762
27030	9105	1800	\N
27031	9105	1801	\N
27032	9189	1801	\N
27033	9189	1802	652267
27034	9189	1803	416835
27035	9189	1805	490814
27036	9189	1807	563998
27037	9240	1802	369009
27038	9240	1803	336176
27039	9240	1804	870282
27040	9106	1809	\N
27041	9106	1811	\N
27042	9190	1808	\N
27043	9241	1809	\N
27044	9190	1812	558207
27045	9190	1813	653518
27046	9190	1815	708368
27047	9190	1817	996307
27048	9191	1818	\N
27049	9191	1819	\N
27050	9191	1820	\N
27051	9191	1821	\N
27052	9191	1822	\N
27053	9242	1819	\N
27054	9107	1823	\N
27055	9107	1824	\N
27056	9107	1825	\N
27057	9192	1824	\N
27058	9192	1825	\N
27059	9243	1823	\N
27060	9243	1825	\N
27061	9243	1827	\N
27062	9243	1828	\N
27063	9243	1829	\N
27064	9193	1830	\N
27065	9244	1830	\N
27066	9108	1831	298199
27067	9193	1832	483904
27068	9244	1832	517513
27069	9244	1833	745409
27070	9244	1834	719695
27071	9244	1835	485749
27072	9194	1836	365480
27073	9194	1837	386962
27074	9109	1838	253810
27075	9109	1839	336823
27076	9195	1838	677586
27077	9245	1838	309632
27078	9245	1839	175249
27079	9246	1840	\N
27080	9110	1842	498588
27081	9110	1843	342493
27082	9110	1845	444815
27083	9110	1846	876765
27084	9196	1842	866677
27085	9246	1841	699320
27086	9246	1843	557140
27087	9111	1847	\N
27088	9111	1848	\N
27089	9247	1848	\N
27090	9111	1849	254673
27091	9111	1850	126191
27092	9111	1851	209456
27093	9197	1849	708890
27094	9247	1849	161437
27095	9247	1851	862226
27096	9247	1852	827533
27097	9112	1854	\N
27098	9112	1855	\N
27099	9198	1854	\N
27100	9248	1853	\N
27101	9113	1857	\N
27102	9113	1858	\N
27103	9249	1856	\N
27104	9249	1857	\N
27105	9249	1858	\N
27106	9114	1860	\N
27107	9114	1861	\N
27108	9114	1862	\N
27109	9114	1863	\N
27110	9199	1859	\N
27111	9199	1861	\N
27112	9199	1865	955379
27113	9199	1866	889883
27114	9115	1867	\N
27115	9200	1868	\N
27116	9250	1867	\N
27117	9250	1869	\N
27118	9250	1870	\N
27119	9200	1871	338223
27120	9200	1873	323860
27121	9201	1874	\N
27122	9201	1875	\N
27123	9201	1876	565971
27124	9251	1877	396926
27125	9251	1879	196804
27126	9252	1880	\N
27127	9252	1881	777844
27128	9252	1883	408701
27129	9116	1884	\N
27130	9117	1885	\N
27131	9253	1886	\N
27132	9253	1888	\N
27133	9253	1890	\N
27134	9117	1891	421678
27135	9253	1892	358839
27136	9202	1893	\N
27137	9118	1895	854681
27138	9118	1897	640755
27139	9202	1894	441953
27140	9202	1895	719490
27141	9202	1896	124038
27142	9119	1898	\N
27143	9119	1900	\N
27144	9203	1898	\N
27145	9119	1901	631318
27146	9119	1902	330342
27147	9119	1903	307911
27148	9254	1902	667962
27149	9120	1904	\N
27150	9120	1905	\N
27151	9204	1904	\N
27152	9204	1905	\N
27153	9204	1907	\N
27154	9120	1908	812910
27155	9255	1908	628353
27156	9121	1909	\N
27157	9205	1911	332014
27158	9205	1913	606520
27159	9256	1910	913419
27160	9256	1911	523445
27161	9256	1912	811492
27162	9256	1913	758316
27163	9256	1914	841384
27164	9122	1915	\N
27165	9206	1915	\N
27166	9206	1916	\N
27167	9257	1915	\N
27168	9122	1917	282742
27169	9122	1919	412573
27170	9122	1920	197601
27171	9122	1921	121512
27172	9207	1923	\N
27173	9207	1924	\N
27174	9207	1926	\N
27175	9207	1927	563793
27176	9207	1928	782567
27177	9123	1929	\N
27178	9258	1929	\N
27179	9258	1931	\N
27180	9258	1932	\N
27181	9258	1933	\N
27182	9123	1934	972778
27183	9208	1935	\N
27184	9259	1935	\N
27185	9124	1936	757117
27186	9124	1937	253797
27187	9124	1938	531285
27188	9124	1939	603197
27189	9124	1940	457890
27190	9259	1936	129335
27191	9125	1942	\N
27192	9125	1943	\N
27193	9125	1945	\N
27194	9125	1946	\N
27195	9125	1948	\N
27196	9209	1941	\N
27197	9209	1942	\N
27198	9209	1943	\N
27199	9209	1944	\N
27200	9260	1941	\N
27201	9260	1949	209516
27202	9260	1951	235837
27203	9260	1952	322976
27204	9126	1954	\N
27205	9261	1953	\N
27206	9126	1956	485313
27207	9126	1958	463141
27208	9126	1959	291352
27209	9210	1955	658975
27210	9261	1956	938017
27211	9261	1958	644776
27212	9262	1960	\N
27213	9211	1961	533995
27214	9211	1962	775836
27215	9262	1961	228683
27216	9262	1962	534775
27217	9212	1963	\N
27218	9212	1964	\N
27219	9127	1965	325963
27220	9212	1966	619513
27221	9213	1967	324162
27222	9213	1969	596988
27223	9213	1970	116906
27224	9214	1971	\N
27225	9214	1972	\N
27226	9214	1974	\N
27227	9214	1976	740213
27228	9263	1976	700348
27229	9263	1977	974706
27230	9128	1978	\N
27231	9128	1979	\N
27232	9128	1980	\N
27233	9128	1982	244896
27234	9215	1981	836660
27235	9215	1982	188254
27236	9264	1981	434309
27237	9129	1984	\N
27238	9216	1983	\N
27239	9216	1984	\N
27240	9265	1983	\N
27241	9265	1984	\N
27242	9265	1985	\N
27243	9265	1986	\N
27244	9129	1987	761447
27245	9129	1989	292450
27246	9129	1991	506416
27247	9265	1987	124532
27248	9130	1992	\N
27249	9217	1992	\N
27250	9130	1994	318500
27251	9130	1996	388192
27252	9130	1997	532766
27253	9130	1998	921431
27254	9266	1993	638382
27255	9266	1995	291196
27256	9218	1999	\N
27257	9218	0	\N
27258	9267	0	\N
27259	9267	2	\N
27260	9267	3	\N
27261	9267	4	\N
27262	9267	5	\N
27263	9131	6	526946
27264	9131	7	706232
27265	9218	6	759366
27266	9219	8	\N
27267	9219	9	\N
27268	9219	11	\N
27269	9219	12	\N
27270	9268	8	\N
27271	9132	13	878627
27272	9132	14	124776
27273	9132	15	408943
27274	9268	13	908818
27275	9268	14	348129
27276	9220	16	\N
27277	9133	18	283881
27278	9220	17	400250
27279	9220	18	999745
27280	9269	17	674554
27281	9269	18	217178
27282	9269	20	364368
27283	9270	21	\N
27284	9270	22	461770
27285	9134	23	\N
27286	9134	24	\N
27287	9134	25	\N
27288	9221	23	\N
27289	9271	23	\N
27290	9134	26	564752
27291	9134	27	929356
27292	9221	27	281343
27293	9221	28	217687
27294	9221	30	421591
27295	9271	26	882942
27296	9135	31	\N
27297	9135	32	\N
27298	9135	33	\N
27299	9135	34	\N
27300	9222	32	\N
27301	9222	33	\N
27302	9272	31	\N
27303	9272	32	\N
27304	9272	33	\N
27305	9272	34	\N
27306	9135	35	729289
27307	9272	35	752721
27308	9223	36	\N
27309	9223	37	\N
27310	9223	38	\N
27311	9136	39	799343
27312	9223	39	318993
27313	9223	40	355867
27314	9273	40	583181
27315	9273	41	252088
27316	9137	43	\N
27317	9224	42	\N
27318	9274	42	\N
27319	9274	43	\N
27320	9274	44	\N
27321	9274	45	\N
27322	9137	47	677184
27323	9137	49	432953
27324	9137	50	442598
27325	9275	51	\N
27326	9138	52	350077
27327	9138	54	826680
27328	9138	56	231399
27329	9225	53	679795
27330	9275	53	728936
27331	9275	54	786603
27332	9275	55	455173
27333	9276	57	\N
27334	9276	59	333887
27335	9276	60	287471
27336	9276	62	311606
27337	9139	63	836879
27338	9277	63	594613
27339	9277	64	452844
27340	9277	65	618203
27341	9277	66	342561
27342	9140	67	613533
27343	9140	68	541045
27344	9278	67	216848
27345	9141	70	\N
27346	9279	69	\N
27347	9279	71	\N
27348	9279	72	\N
27349	9279	73	\N
27350	9141	74	213530
27351	9141	76	635714
27352	9280	77	\N
27353	9142	78	664919
27354	9142	80	585503
27355	9142	81	573823
27356	9142	82	618048
27357	9142	83	270065
27358	9280	78	532898
27359	9143	84	283272
27360	9281	84	676609
27361	9281	85	340837
27362	9281	86	994044
27363	9282	87	\N
27364	9282	89	243316
27365	9282	90	383039
27366	9282	91	294750
27367	9282	93	485568
27368	9144	94	\N
27369	9144	95	664254
27370	9283	95	438747
27371	9283	97	860615
27372	9145	99	\N
27373	9145	100	\N
27374	9284	98	\N
27375	9284	99	\N
27376	9284	100	\N
27377	9145	101	589932
27378	9145	103	610103
27379	9285	104	\N
27380	9146	105	282827
27381	9285	105	729829
27382	9285	106	103204
27383	9285	107	409165
27384	9147	109	\N
27385	9147	111	860069
27386	9147	112	191669
27387	9147	113	692401
27388	9286	111	201421
27389	9286	112	284217
27390	9286	114	685931
27391	9286	115	365261
27392	9286	117	433822
27393	9148	118	\N
27394	9148	120	\N
27395	9148	121	\N
27396	9148	122	903452
27397	9148	123	954086
27398	9287	123	615161
27399	9287	125	731773
27400	9149	126	\N
27401	9288	126	\N
27402	9288	127	\N
27403	9288	128	\N
27404	9288	129	154079
27405	9288	130	370488
27406	9150	132	\N
27407	9289	133	764469
27408	9289	135	617287
27409	9289	136	933305
27410	9290	138	\N
27411	9290	139	\N
27412	9151	140	\N
27413	9151	141	\N
27414	9291	140	\N
27415	9152	142	348327
27416	9152	143	109355
27417	9152	144	896093
27418	9152	145	392224
27419	9292	142	843332
27420	9292	143	420605
27421	9292	145	993903
27422	9292	147	419769
27423	9153	149	\N
27424	9153	150	\N
27425	9153	152	\N
27426	9293	148	\N
27427	9154	153	\N
27428	9294	153	\N
27429	9154	154	558061
27430	9154	155	487189
27431	9154	156	144353
27432	9154	157	802060
27433	9294	154	470082
27434	9294	155	864001
27435	9294	156	738169
27436	9294	157	193694
27437	9295	158	\N
27438	9295	160	\N
27439	9295	161	\N
27440	9295	162	\N
27441	9295	163	\N
27442	9155	164	793336
27443	9155	165	709958
27444	9155	166	879404
27445	9156	167	\N
27446	9156	168	\N
27447	9296	167	\N
27448	9156	170	993757
27449	9157	172	\N
27450	9157	173	\N
27451	9157	174	939382
27452	9158	175	\N
27453	9158	176	\N
27454	9158	177	\N
27455	9297	176	\N
27456	9297	178	837611
27457	9298	179	\N
27458	9298	180	147885
27459	9298	181	910697
27460	9159	182	\N
27461	9159	183	\N
27462	9159	184	372399
27463	9159	185	155209
27464	9160	187	\N
27465	9160	188	957974
27466	9299	188	171817
27467	9299	189	954828
27468	9300	191	306408
27469	9300	192	892119
27470	9300	193	470630
27471	9161	194	\N
27472	9161	195	\N
27473	9161	197	\N
27474	9161	198	444353
27475	9161	200	306447
27476	9162	202	712164
27477	9162	203	915819
27478	9301	201	875877
27479	9301	202	304329
27480	9302	204	\N
27481	9302	206	\N
27482	9302	207	\N
27483	9302	208	\N
27484	9163	210	416163
27485	9163	211	746995
27486	9163	213	671579
27487	9163	214	489208
27488	9302	209	991008
27489	9164	216	\N
27490	9164	217	198992
27491	9303	217	621736
27492	9303	219	584330
27493	9303	220	914918
27494	9165	222	\N
27495	9165	223	\N
27496	9165	224	\N
27497	9165	225	\N
27498	9165	226	\N
27499	9166	227	\N
27500	9166	229	\N
27501	9166	230	\N
27502	9166	231	\N
27503	9166	232	\N
27504	9304	228	\N
27505	9305	233	\N
27506	9306	235	\N
27507	9306	237	\N
27508	9306	238	\N
27509	9167	239	\N
27510	9307	239	\N
27511	9307	240	349996
27512	9307	242	373409
27513	9307	243	808856
27514	9307	245	898252
27515	9168	246	562735
27516	9168	248	481917
27517	9168	250	480099
27518	9168	252	629916
27519	9169	253	\N
27520	9169	254	\N
27521	9308	253	\N
27522	9308	254	\N
27523	9308	255	765601
27524	9308	257	621444
27525	9308	258	437437
27526	9170	260	\N
27527	9170	261	200393
27528	9170	262	441973
27529	9309	264	\N
27530	9309	265	\N
27531	9309	266	\N
27532	9309	267	\N
27533	9171	268	585711
27534	9172	269	\N
27535	9172	270	\N
27536	9310	269	\N
27537	9310	270	\N
27538	9172	272	246438
27539	9172	273	783542
27540	9310	272	223542
27541	9310	273	882840
27542	9311	274	250871
27543	9311	275	212919
27544	9311	276	253813
27545	9311	277	484839
27546	9173	278	\N
27547	9173	279	\N
27548	9312	278	\N
27549	9312	280	968013
27550	9312	282	427557
27551	9312	283	293306
27552	9174	284	176812
27553	9174	286	445250
27554	9313	284	810052
27555	9313	286	101730
27556	9175	287	\N
27557	9175	288	\N
27558	9314	287	\N
27559	9314	288	\N
27560	9314	289	\N
27561	9314	290	\N
27562	9175	291	558366
27563	9314	291	823645
27564	9315	292	\N
27565	9315	294	\N
27566	9388	295	161053
27567	9388	297	317632
27568	9316	298	\N
27569	9389	298	\N
27570	9389	299	\N
27571	9389	300	\N
27572	9389	302	329753
27573	9389	303	740116
27574	9317	305	\N
27575	9390	304	\N
27576	9390	306	362743
27577	9318	308	\N
27578	9318	309	\N
27579	9318	310	\N
27580	9318	312	\N
27581	9391	307	\N
27582	9391	309	\N
27583	9391	311	\N
27584	9318	313	959333
27585	9391	313	523699
27586	9319	314	\N
27587	9320	315	\N
27588	9320	316	\N
27589	9320	317	\N
27590	9320	318	\N
27591	9320	319	\N
27592	9392	315	\N
27593	9392	317	\N
27594	9392	318	\N
27595	9321	320	\N
27596	9322	321	\N
27597	9322	322	\N
27598	9322	323	\N
27599	9322	324	185212
27600	9393	324	660085
27601	9323	326	\N
27602	9323	327	\N
27603	9323	328	\N
27604	9323	330	\N
27605	9394	325	\N
27606	9394	331	593409
27607	9394	332	545567
27608	9394	333	160972
27609	9324	334	\N
27610	9324	335	\N
27611	9324	336	\N
27612	9324	337	400737
27613	9395	339	\N
27614	9395	341	\N
27615	9396	342	\N
27616	9396	343	\N
27617	9396	345	\N
27618	9396	346	459214
27619	9396	347	123960
27620	9397	348	781192
27621	9397	349	156558
27622	9325	350	\N
27623	9398	350	\N
27624	9398	351	\N
27625	9398	352	803569
27626	9399	354	\N
27627	9326	355	867362
27628	9326	357	855160
27629	9399	356	347094
27630	9400	359	\N
27631	9400	360	\N
27632	9327	362	879808
27633	9327	363	360493
27634	9328	364	\N
27635	9328	365	899898
27636	9328	366	119949
27637	9328	368	909966
27638	9328	370	963822
27639	9329	372	\N
27640	9329	373	\N
27641	9329	374	805105
27642	9329	376	350737
27643	9401	374	555435
27644	9402	377	\N
27645	9402	378	\N
27646	9330	379	556004
27647	9330	380	950332
27648	9330	381	820352
27649	9330	383	221707
27650	9402	380	983895
27651	9402	381	611861
27652	9331	384	\N
27653	9403	384	\N
27654	9331	385	604828
27655	9331	387	505982
27656	9403	385	416834
27657	9403	387	759617
27658	9403	388	494013
27659	9403	389	672458
27660	9332	391	\N
27661	9332	392	\N
27662	9332	393	\N
27663	9404	390	\N
27664	9404	395	976244
27665	9404	396	430488
27666	9404	398	852467
27667	9405	399	\N
27668	9405	400	\N
27669	9405	402	\N
27670	9333	404	450245
27671	9405	404	752740
27672	9405	406	671087
27673	9334	407	\N
27674	9334	408	971518
27675	9335	409	\N
27676	9406	409	\N
27677	9406	411	129323
27678	9407	413	726323
27679	9407	414	732403
27680	9407	416	985478
27681	9336	417	\N
27682	9408	418	\N
27683	9336	419	511773
27684	9336	420	825956
27685	9336	421	316974
27686	9409	422	\N
27687	9337	423	375867
27688	9337	425	290646
27689	9409	423	888869
27690	9409	424	191463
27691	9409	425	439218
27692	9409	426	867836
27693	9338	427	\N
27694	9339	428	\N
27695	9339	429	\N
27696	9339	430	\N
27697	9410	432	137783
27698	9410	433	575576
27699	9340	434	\N
27700	9340	435	\N
27701	9411	434	\N
27702	9411	435	\N
27703	9411	436	\N
27704	9411	437	\N
27705	9340	438	495764
27706	9340	440	695440
27707	9340	441	837570
27708	9411	438	692407
27709	9341	442	\N
27710	9341	444	\N
27711	9412	442	\N
27712	9341	445	681947
27713	9412	445	338154
27714	9342	446	\N
27715	9413	446	\N
27716	9413	447	\N
27717	9413	448	\N
27718	9342	449	278431
27719	9413	449	832288
27720	9343	450	132953
27721	9343	451	322975
27722	9343	452	896027
27723	9343	453	946648
27724	9414	450	657627
27725	9414	451	165697
27726	9414	452	481556
27727	9344	455	\N
27728	9344	456	\N
27729	9415	455	\N
27730	9415	457	145049
27731	9415	459	937453
27732	9415	460	737499
27733	9415	461	796722
27734	9416	463	\N
27735	9345	464	969971
27736	9345	465	612106
27737	9416	464	710737
27738	9346	466	\N
27739	9346	467	\N
27740	9346	469	\N
27741	9346	470	\N
27742	9346	471	\N
27743	9417	466	\N
27744	9417	468	\N
27745	9417	473	669305
27746	9417	474	461343
27747	9347	475	\N
27748	9418	475	\N
27749	9418	476	\N
27750	9348	478	\N
27751	9419	477	\N
27752	9419	479	328119
27753	9419	481	549052
27754	9419	482	495549
27755	9419	483	555273
27756	9420	484	\N
27757	9420	485	\N
27758	9349	486	935326
27759	9420	486	914878
27760	9420	487	500647
27761	9420	489	283007
27762	9350	490	\N
27763	9351	491	108033
27764	9352	493	\N
27765	9421	492	\N
27766	9421	494	\N
27767	9352	495	776165
27768	9352	496	128692
27769	9422	497	\N
27770	9422	499	\N
27771	9353	500	753620
27772	9353	502	843025
27773	9422	500	501419
27774	9422	502	393511
27775	9422	503	847344
27776	9354	505	\N
27777	9354	506	\N
27778	9423	504	\N
27779	9423	505	\N
27780	9423	507	\N
27781	9354	509	229311
27782	9355	510	\N
27783	9355	511	\N
27784	9355	512	\N
27785	9355	514	\N
27786	9356	515	\N
27787	9356	516	\N
27788	9356	517	\N
27789	9424	515	\N
27790	9424	516	\N
27791	9425	518	\N
27792	9357	519	\N
27793	9357	520	\N
27794	9357	521	\N
27795	9426	522	391198
27796	9426	523	470585
27797	9426	524	768688
27798	9427	526	\N
27799	9427	527	\N
27800	9358	528	668765
27801	9358	529	597567
27802	9358	531	457022
27803	9358	532	678166
27804	9427	528	148574
27805	9427	530	195475
27806	9427	532	475255
27807	9428	534	\N
27808	9359	535	711581
27809	9359	536	894788
27810	9359	537	198606
27811	9359	539	128077
27812	9360	540	\N
27813	9429	540	\N
27814	9360	541	514698
27815	9429	541	604278
27816	9429	542	433509
27817	9430	543	\N
27818	9430	545	\N
27819	9430	546	\N
27820	9361	547	\N
27821	9361	548	\N
27822	9361	549	\N
27823	9361	550	\N
27824	9361	551	\N
27825	9431	547	\N
27826	9431	553	631217
27827	9431	554	237596
27828	9362	555	210300
27829	9362	556	784217
27830	9362	557	375585
27831	9362	558	325024
27832	9362	559	401725
27833	9363	561	\N
27834	9432	560	\N
27835	9432	562	\N
27836	9363	563	779935
27837	9363	564	650567
27838	9363	565	890647
27839	9432	563	985332
27840	9432	565	339024
27841	9432	567	298664
27842	9433	568	\N
27843	9433	569	972003
27844	9434	570	405946
27845	9364	572	\N
27846	9435	571	\N
27847	9435	572	\N
27848	9364	573	156641
27849	9364	574	584757
27850	9364	575	212082
27851	9364	576	826232
27852	9435	574	306560
27853	9435	575	946742
27854	9435	576	869201
27855	9365	577	\N
27856	9436	578	\N
27857	9436	579	\N
27858	9365	580	759829
27859	9436	580	717573
27860	9366	581	\N
27861	9366	582	\N
27862	9366	583	\N
27863	9366	585	\N
27864	9366	586	128762
27865	9437	586	906242
27866	9367	587	\N
27867	9367	589	\N
27868	9438	587	\N
27869	9367	590	918442
27870	9367	591	753869
27871	9367	592	222162
27872	9438	591	460403
27873	9438	592	716647
27874	9368	593	\N
27875	9439	595	809820
27876	9439	596	618393
27877	9439	598	889821
27878	9439	599	238091
27879	9440	600	\N
27880	9440	602	\N
27881	9369	603	293737
27882	9440	603	600749
27883	9370	605	203885
27884	9371	606	391648
27885	9441	606	559680
27886	9441	607	329977
27887	9441	608	371643
27888	9441	610	151121
27889	9442	611	\N
27890	9442	613	331028
27891	9442	614	847156
27892	9442	616	260461
27893	9372	618	853812
27894	9372	619	157350
27895	9372	621	215959
27896	9372	622	993672
27897	9373	623	861921
27898	9373	624	729632
27899	9374	625	\N
27900	9374	626	\N
27901	9374	627	723358
27902	9374	628	846604
27903	9374	629	590335
27904	9443	630	\N
27905	9375	632	\N
27906	9375	633	\N
27907	9444	631	\N
27908	9444	632	\N
27909	9444	633	\N
27910	9444	634	\N
27911	9376	635	\N
27912	9376	636	\N
27913	9445	635	\N
27914	9445	636	\N
27915	9376	637	985047
27916	9445	638	861185
27917	9445	639	787257
27918	9445	640	777995
27919	9377	641	\N
27920	9377	643	\N
27921	9377	644	891468
27922	9377	646	491590
27923	9377	647	629462
27924	9446	644	895618
27925	9378	649	\N
27926	9378	650	604251
27927	9378	651	147858
27928	9378	652	805926
27929	9378	654	635884
27930	9447	650	250253
27931	9448	656	142258
27932	9449	657	\N
27933	9449	658	939852
27934	9379	659	\N
27935	9379	660	343262
27936	9379	662	919509
27937	9379	663	141177
27938	9450	660	402266
27939	9450	661	108478
27940	9450	662	695199
27941	9450	664	907958
27942	9380	665	\N
27943	9380	666	\N
27944	9380	667	\N
27945	9380	668	654209
27946	9451	668	942415
27947	9381	669	\N
27948	9452	670	\N
27949	9452	671	\N
27950	9452	673	\N
27951	9452	674	543701
27952	9382	676	\N
27953	9382	678	432789
27954	9382	680	969393
27955	9382	681	226688
27956	9453	677	360668
27957	9453	679	781232
27958	9453	680	602473
27959	9383	682	\N
27960	9383	684	\N
27961	9454	685	\N
27962	9454	687	\N
27963	9454	688	223117
27964	9384	689	549979
27965	9385	691	\N
27966	9385	693	\N
27967	9385	694	158368
27968	9385	695	606753
27969	9455	694	730677
27970	9455	696	919060
27971	9455	697	751753
27972	9455	698	916661
27973	9386	699	277094
27974	9456	699	235266
27975	9456	701	894041
27976	9456	702	722690
27977	9457	703	\N
27978	9458	704	\N
27979	9458	705	910268
27980	9387	706	\N
27981	9459	706	\N
27982	9459	707	\N
27983	9459	708	\N
27984	9387	709	874562
27985	9387	710	523501
27986	9387	711	248435
27987	9387	712	830413
27988	9459	709	813511
27989	9459	711	362979
27990	9460	713	\N
27991	9460	715	\N
27992	9460	716	\N
27993	9460	717	607667
27994	9461	718	\N
27995	9461	719	430153
27996	9461	720	396497
27997	9461	721	693736
27998	9539	722	\N
27999	9539	723	\N
28000	9539	725	\N
28001	9539	726	\N
28002	9539	727	695479
28003	9462	729	\N
28004	9540	728	\N
28005	9462	731	228901
28006	9462	732	574412
28007	9462	733	410278
28008	9462	734	859543
28009	9541	735	418659
28010	9541	736	350714
28011	9463	737	\N
28012	9542	737	\N
28013	9463	738	302882
28014	9542	739	789280
28015	9542	740	611344
28016	9464	741	\N
28017	9464	742	\N
28018	9543	742	\N
28019	9543	744	\N
28020	9543	745	\N
28021	9464	746	977881
28022	9543	746	310201
28023	9544	748	\N
28024	9544	749	\N
28025	9465	750	391145
28026	9465	751	934256
28027	9465	753	463349
28028	9544	750	967944
28029	9544	751	320324
28030	9545	755	\N
28031	9545	757	724736
28032	9466	758	\N
28033	9546	758	\N
28034	9546	759	\N
28035	9546	761	\N
28036	9466	763	438730
28037	9466	764	342809
28038	9466	765	591422
28039	9467	766	\N
28040	9467	767	\N
28041	9547	766	\N
28042	9547	767	\N
28043	9467	769	720253
28044	9547	768	686168
28045	9547	769	293793
28046	9547	770	723351
28047	9468	771	308395
28048	9468	773	781265
28049	9468	774	702762
28050	9468	775	318387
28051	9468	776	266326
28052	9548	771	537721
28053	9469	777	\N
28054	9469	778	\N
28055	9549	777	\N
28056	9549	778	\N
28057	9469	779	483322
28058	9469	780	648697
28059	9549	779	709002
28060	9550	781	\N
28061	9550	782	\N
28062	9470	784	883940
28063	9550	783	683903
28064	9471	786	\N
28065	9551	785	\N
28066	9551	787	\N
28067	9551	789	191435
28068	9551	790	292645
28069	9551	791	152255
28070	9472	792	\N
28071	9472	793	\N
28072	9472	794	\N
28073	9472	796	537607
28074	9552	795	565104
28075	9552	797	834852
28076	9552	798	479330
28077	9552	799	178976
28078	9473	800	\N
28079	9553	801	\N
28080	9553	802	\N
28081	9553	803	\N
28082	9473	805	203434
28083	9473	807	190262
28084	9553	804	905183
28085	9554	808	\N
28086	9554	809	\N
28087	9474	810	\N
28088	9474	811	\N
28089	9555	812	886241
28090	9555	813	399228
28091	9475	815	\N
28092	9475	816	\N
28093	9475	817	\N
28094	9556	815	\N
28095	9556	817	\N
28096	9556	819	736695
28097	9476	820	\N
28098	9476	821	\N
28099	9476	822	\N
28100	9476	824	\N
28101	9557	820	\N
28102	9557	821	\N
28103	9557	825	283912
28104	9557	826	712384
28105	9477	827	\N
28106	9477	829	\N
28107	9477	830	\N
28108	9477	832	\N
28109	9558	827	\N
28110	9558	833	778273
28111	9478	835	341624
28112	9559	834	137746
28113	9559	835	747353
28114	9559	836	686978
28115	9559	838	226071
28116	9479	839	890140
28117	9560	839	964065
28118	9560	841	518155
28119	9560	843	439364
28120	9560	844	385224
28121	9560	846	182937
28122	9480	848	\N
28123	9480	849	\N
28124	9480	850	\N
28125	9480	852	767199
28126	9561	852	210330
28127	9561	853	176354
28128	9561	854	714763
28129	9481	856	\N
28130	9481	858	\N
28131	9562	855	\N
28132	9562	857	\N
28133	9562	859	\N
28134	9482	860	455100
28135	9482	861	367759
28136	9563	862	186825
28137	9563	863	146063
28138	9564	864	\N
28139	9564	865	\N
28140	9564	866	\N
28141	9564	867	\N
28142	9564	868	\N
28143	9483	869	597558
28144	9483	870	260054
28145	9483	871	122280
28146	9483	873	853001
28147	9483	875	853869
28148	9565	876	\N
28149	9565	877	\N
28150	9484	879	555594
28151	9484	880	522929
28152	9485	881	\N
28153	9485	882	\N
28154	9566	881	\N
28155	9566	882	\N
28156	9566	883	\N
28157	9566	884	\N
28158	9566	885	\N
28159	9485	886	572914
28160	9486	887	\N
28161	9486	889	\N
28162	9567	887	\N
28163	9567	888	\N
28164	9486	890	111788
28165	9486	891	497356
28166	9486	893	459072
28167	9567	890	787572
28168	9487	894	\N
28169	9487	895	699918
28170	9487	896	118681
28171	9487	897	142365
28172	9568	898	\N
28173	9488	900	554914
28174	9488	901	732383
28175	9488	902	768459
28176	9568	899	397775
28177	9568	900	472278
28178	9568	901	973357
28179	9568	902	924490
28180	9489	903	\N
28181	9489	904	\N
28182	9569	903	\N
28183	9569	905	\N
28184	9569	906	\N
28185	9569	908	\N
28186	9569	909	\N
28187	9489	910	381510
28188	9489	912	531920
28189	9489	914	854246
28190	9570	915	\N
28191	9490	917	782599
28192	9490	919	445333
28193	9570	916	609388
28194	9571	920	\N
28195	9571	921	\N
28196	9491	922	157109
28197	9491	923	160760
28198	9491	925	723254
28199	9491	926	919627
28200	9571	922	489346
28201	9492	927	\N
28202	9492	928	\N
28203	9572	928	\N
28204	9572	929	\N
28205	9572	930	\N
28206	9493	931	\N
28207	9493	933	\N
28208	9493	935	\N
28209	9493	936	566525
28210	9573	937	\N
28211	9573	938	\N
28212	9494	939	140843
28213	9573	939	159129
28214	9573	940	575019
28215	9573	942	134554
28216	9574	943	\N
28217	9495	944	\N
28218	9575	944	\N
28219	9495	945	552512
28220	9496	946	\N
28221	9496	947	\N
28222	9496	948	\N
28223	9497	949	159970
28224	9576	950	829378
28225	9576	952	125590
28226	9576	954	123102
28227	9576	956	936311
28228	9498	957	\N
28229	9498	959	\N
28230	9498	960	\N
28231	9498	961	\N
28232	9498	962	\N
28233	9577	957	\N
28234	9577	958	\N
28235	9577	960	\N
28236	9577	962	\N
28237	9499	963	\N
28238	9499	964	907401
28239	9499	966	501699
28240	9499	967	864746
28241	9499	968	799263
28242	9500	970	\N
28243	9500	972	\N
28244	9500	973	434461
28245	9578	973	413673
28246	9578	974	225816
28247	9579	975	\N
28248	9579	976	\N
28249	9501	977	651595
28250	9501	979	548622
28251	9579	978	697864
28252	9579	979	871831
28253	9502	980	\N
28254	9502	981	\N
28255	9502	982	\N
28256	9580	981	\N
28257	9580	982	\N
28258	9580	983	\N
28259	9580	984	\N
28260	9580	985	836129
28261	9503	986	\N
28262	9581	987	\N
28263	9581	988	555775
28264	9504	989	\N
28265	9504	990	\N
28266	9504	991	\N
28267	9504	992	449204
28268	9504	993	644161
28269	9505	994	\N
28270	9505	995	\N
28271	9505	997	\N
28272	9505	998	\N
28273	9582	995	\N
28274	9582	996	\N
28275	9582	998	\N
28276	9582	999	870358
28277	9582	1000	919443
28278	9583	1001	\N
28279	9583	1003	432437
28280	9583	1005	595658
28281	9506	1006	\N
28282	9506	1007	\N
28283	9584	1006	\N
28284	9584	1008	547237
28285	9584	1009	384145
28286	9585	1010	\N
28287	9585	1012	\N
28288	9585	1013	421604
28289	9585	1015	230082
28290	9507	1016	132668
28291	9586	1016	980668
28292	9586	1017	231835
28293	9508	1018	\N
28294	9587	1018	\N
28295	9587	1019	\N
28296	9508	1020	571002
28297	9508	1021	538565
28298	9508	1023	768639
28299	9587	1020	712832
28300	9587	1022	941892
28301	9587	1024	395890
28302	9588	1025	\N
28303	9588	1026	\N
28304	9509	1027	651334
28305	9509	1028	146260
28306	9509	1029	366196
28307	9509	1030	226527
28308	9588	1027	384482
28309	9588	1028	413099
28310	9588	1029	762976
28311	9510	1031	\N
28312	9589	1032	\N
28313	9510	1034	489277
28314	9589	1033	455345
28315	9589	1034	964216
28316	9589	1036	679177
28317	9511	1038	\N
28318	9511	1039	\N
28319	9511	1040	\N
28320	9511	1041	\N
28321	9511	1043	\N
28322	9512	1044	\N
28323	9512	1046	\N
28324	9512	1047	\N
28325	9512	1048	\N
28326	9512	1049	\N
28327	9590	1050	629594
28328	9513	1051	632156
28329	9513	1053	690358
28330	9513	1054	836406
28331	9513	1055	115550
28332	9591	1051	209186
28333	9592	1057	\N
28334	9592	1058	\N
28335	9592	1059	\N
28336	9592	1060	\N
28337	9592	1062	\N
28338	9514	1063	472741
28339	9514	1065	196644
28340	9593	1063	510121
28341	9515	1066	\N
28342	9515	1067	\N
28343	9515	1068	\N
28344	9515	1069	\N
28345	9515	1071	130375
28346	9516	1073	\N
28347	9517	1075	\N
28348	9518	1076	\N
28349	9519	1077	363908
28350	9519	1078	137000
28351	9519	1079	656528
28352	9519	1081	270063
28353	9519	1083	817560
28354	9520	1084	654478
28355	9520	1085	225309
28356	9521	1086	\N
28357	9521	1087	203069
28358	9522	1089	\N
28359	9522	1090	\N
28360	9522	1091	864245
28361	9522	1092	336553
28362	9522	1093	304875
28363	9523	1094	118961
28364	9523	1096	843770
28365	9523	1097	165279
28366	9523	1099	937211
28367	9524	1100	\N
28368	9524	1101	381882
28369	9525	1102	\N
28370	9525	1104	847168
28371	9526	1106	\N
28372	9526	1107	\N
28373	9526	1108	\N
28374	9527	1110	\N
28375	9528	1111	143054
28376	9529	1112	\N
28377	9529	1113	\N
28378	9529	1114	\N
28379	9529	1115	\N
28380	9530	1116	\N
28381	9530	1118	\N
28382	9531	1119	\N
28383	9532	1120	209515
28384	9533	1121	\N
28385	9533	1122	\N
28386	9534	1123	\N
28387	9534	1125	\N
28388	9534	1126	\N
28389	9534	1127	\N
28390	9534	1128	\N
28391	9535	1129	\N
28392	9535	1130	\N
28393	9535	1132	\N
28394	9535	1133	945075
28395	9536	1134	966266
28396	9537	1136	727188
28397	9537	1138	895223
28398	9537	1139	279582
28399	9538	1140	\N
28400	9538	1142	\N
28401	9538	1144	911159
28402	9594	1145	\N
28403	9594	1147	\N
28404	9594	1149	379802
28405	9594	1150	738186
28406	9594	1151	911151
28407	9660	1149	284945
28408	9595	1153	\N
28409	9595	1154	\N
28410	9595	1155	\N
28411	9661	1152	\N
28412	9662	1156	\N
28413	9662	1158	\N
28414	9662	1159	842493
28415	9596	1161	\N
28416	9596	1162	\N
28417	9596	1164	698583
28418	9596	1165	766654
28419	9663	1164	408418
28420	9663	1165	641329
28421	9663	1167	629944
28422	9663	1168	100986
28423	9597	1169	\N
28424	9597	1170	\N
28425	9597	1171	\N
28426	9597	1172	\N
28427	9664	1173	401591
28428	9664	1175	373149
28429	9664	1177	523023
28430	9664	1179	459914
28431	9664	1180	103567
28432	9665	1181	\N
28433	9598	1182	488000
28434	9598	1184	472290
28435	9598	1185	985600
28436	9598	1186	737605
28437	9598	1187	459492
28438	9599	1188	\N
28439	9599	1189	597990
28440	9599	1190	105627
28441	9666	1189	490255
28442	9666	1190	430316
28443	9600	1191	116012
28444	9600	1192	397180
28445	9600	1193	777554
28446	9600	1194	232363
28447	9600	1195	823121
28448	9667	1191	625335
28449	9601	1197	\N
28450	9601	1198	\N
28451	9668	1199	909652
28452	9668	1200	381641
28453	9668	1201	212221
28454	9668	1202	647519
28455	9602	1204	\N
28456	9602	1206	453758
28457	9602	1207	114994
28458	9602	1208	895016
28459	9602	1209	294713
28460	9669	1205	433459
28461	9603	1210	\N
28462	9603	1211	\N
28463	9670	1211	\N
28464	9603	1212	990055
28465	9603	1213	936896
28466	9670	1212	206080
28467	9670	1213	687877
28468	9671	1214	322848
28469	9671	1216	735599
28470	9672	1217	\N
28471	9604	1218	183626
28472	9672	1218	326358
28473	9605	1219	281423
28474	9673	1219	727862
28475	9673	1220	453720
28476	9673	1221	202376
28477	9673	1222	864213
28478	9673	1223	671565
28479	9606	1225	\N
28480	9606	1226	930094
28481	9606	1227	111148
28482	9606	1229	846366
28483	9674	1226	924695
28484	9674	1228	773005
28485	9674	1230	590391
28486	9674	1231	506586
28487	9674	1232	349204
28488	9607	1234	515157
28489	9675	1233	197427
28490	9675	1234	880297
28491	9675	1235	135550
28492	9676	1237	926531
28493	9676	1238	314119
28494	9608	1239	137021
28495	9608	1240	608577
28496	9677	1239	899388
28497	9677	1240	535983
28498	9677	1241	523282
28499	9677	1242	523442
28500	9677	1243	798363
28501	9609	1245	\N
28502	9609	1246	\N
28503	9609	1247	\N
28504	9678	1244	\N
28505	9678	1249	190900
28506	9678	1251	195055
28507	9678	1253	998442
28508	9678	1254	782355
28509	9610	1255	\N
28510	9610	1257	\N
28511	9610	1258	\N
28512	9610	1259	\N
28513	9679	1255	\N
28514	9610	1260	125008
28515	9679	1260	491610
28516	9679	1261	811813
28517	9611	1262	\N
28518	9680	1262	\N
28519	9680	1263	\N
28520	9680	1265	296827
28521	9680	1267	828472
28522	9612	1268	\N
28523	9681	1268	\N
28524	9612	1269	534884
28525	9612	1271	901001
28526	9612	1272	466752
28527	9612	1273	641737
28528	9681	1269	996727
28529	9613	1274	\N
28530	9682	1275	\N
28531	9682	1276	\N
28532	9682	1277	876230
28533	9682	1278	434989
28534	9682	1279	304523
28535	9614	1280	\N
28536	9614	1281	\N
28537	9683	1280	\N
28538	9615	1282	684237
28539	9615	1283	661878
28540	9615	1284	488438
28541	9615	1286	117704
28542	9615	1288	591876
28543	9684	1289	119932
28544	9684	1290	905969
28545	9684	1291	186048
28546	9616	1292	\N
28547	9616	1294	423677
28548	9616	1295	166965
28549	9685	1293	241931
28550	9685	1294	969343
28551	9685	1296	143487
28552	9617	1298	\N
28553	9686	1299	393627
28554	9618	1300	\N
28555	9687	1300	\N
28556	9687	1301	\N
28557	9618	1302	826767
28558	9619	1303	427013
28559	9619	1304	114573
28560	9619	1305	470847
28561	9619	1306	947138
28562	9688	1303	455785
28563	9688	1304	968659
28564	9689	1308	\N
28565	9689	1309	933082
28566	9689	1310	503712
28567	9690	1311	\N
28568	9690	1312	246237
28569	9620	1313	\N
28570	9620	1314	\N
28571	9691	1316	327236
28572	9691	1317	205644
28573	9691	1318	444347
28574	9691	1319	752569
28575	9691	1320	879049
28576	9621	1321	180666
28577	9692	1321	637786
28578	9622	1322	\N
28579	9622	1323	412879
28580	9622	1324	189035
28581	9622	1326	738514
28582	9693	1323	378533
28583	9693	1324	684077
28584	9693	1325	271716
28585	9693	1326	491931
28586	9623	1327	\N
28587	9623	1328	\N
28588	9623	1329	\N
28589	9694	1327	\N
28590	9694	1328	\N
28591	9623	1331	790540
28592	9624	1332	\N
28593	9624	1333	\N
28594	9624	1334	\N
28595	9624	1335	\N
28596	9695	1332	\N
28597	9695	1337	703923
28598	9695	1338	292232
28599	9625	1339	\N
28600	9625	1340	\N
28601	9625	1341	\N
28602	9625	1343	\N
28603	9696	1344	983512
28604	9697	1345	\N
28605	9697	1346	\N
28606	9626	1347	\N
28607	9626	1348	\N
28608	9626	1349	\N
28609	9626	1351	260586
28610	9626	1352	146224
28611	9698	1350	379802
28612	9627	1353	\N
28613	9627	1354	\N
28614	9627	1356	\N
28615	9627	1358	\N
28616	9627	1359	\N
28617	9699	1353	\N
28618	9699	1360	330812
28619	9699	1361	663666
28620	9700	1362	\N
28621	9701	1363	\N
28622	9701	1364	623329
28623	9701	1365	427863
28624	9701	1366	332937
28625	9702	1367	\N
28626	9702	1368	\N
28627	9702	1369	\N
28628	9702	1370	\N
28629	9702	1371	\N
28630	9628	1372	304295
28631	9628	1373	171438
28632	9628	1374	442908
28633	9629	1375	\N
28634	9703	1375	\N
28635	9629	1376	107186
28636	9629	1377	801222
28637	9630	1378	\N
28638	9630	1380	444269
28639	9630	1382	883577
28640	9630	1383	568746
28641	9630	1384	990263
28642	9704	1379	391474
28643	9631	1386	\N
28644	9631	1387	\N
28645	9631	1388	\N
28646	9631	1390	\N
28647	9631	1391	\N
28648	9705	1385	\N
28649	9632	1392	\N
28650	9632	1393	\N
28651	9632	1394	\N
28652	9632	1396	\N
28653	9632	1397	\N
28654	9706	1392	\N
28655	9706	1393	\N
28656	9706	1394	\N
28657	9633	1399	545170
28658	9633	1400	176503
28659	9707	1401	\N
28660	9707	1402	\N
28661	9707	1403	\N
28662	9707	1405	786142
28663	9707	1406	540878
28664	9708	1407	\N
28665	9708	1408	680558
28666	9708	1409	368032
28667	9708	1410	176677
28668	9708	1412	658438
28669	9634	1413	\N
28670	9634	1414	\N
28671	9634	1415	\N
28672	9709	1413	\N
28673	9709	1414	\N
28674	9709	1416	606612
28675	9709	1417	627661
28676	9635	1418	\N
28677	9710	1418	\N
28678	9710	1420	784408
28679	9710	1422	729153
28680	9710	1423	863852
28681	9710	1424	374246
28682	9636	1425	\N
28683	9636	1426	\N
28684	9636	1428	\N
28685	9636	1429	\N
28686	9711	1430	880120
28687	9711	1431	289013
28688	9711	1432	953593
28689	9711	1434	377644
28690	9711	1435	320295
28691	9712	1436	\N
28692	9712	1437	\N
28693	9637	1439	\N
28694	9637	1440	\N
28695	9637	1441	\N
28696	9713	1438	\N
28697	9713	1439	\N
28698	9713	1440	\N
28699	9713	1441	\N
28700	9637	1443	687787
28701	9637	1444	886430
28702	9713	1442	948432
28703	9638	1445	\N
28704	9638	1447	\N
28705	9638	1449	784523
28706	9638	1450	563283
28707	9714	1448	274785
28708	9714	1450	311314
28709	9639	1451	\N
28710	9715	1452	\N
28711	9715	1454	\N
28712	9715	1456	\N
28713	9639	1457	400308
28714	9639	1458	242554
28715	9639	1459	605670
28716	9639	1460	949124
28717	9715	1457	881969
28718	9716	1461	\N
28719	9640	1462	\N
28720	9640	1463	\N
28721	9640	1464	249169
28722	9640	1466	473538
28723	9640	1468	935885
28724	9717	1464	347709
28725	9717	1466	876033
28726	9717	1468	395913
28727	9718	1469	\N
28728	9641	1470	880960
28729	9641	1471	860858
28730	9641	1473	810595
28731	9718	1470	164378
28732	9642	1474	\N
28733	9642	1476	\N
28734	9642	1477	\N
28735	9642	1478	\N
28736	9719	1479	804104
28737	9720	1480	\N
28738	9643	1481	988477
28739	9643	1482	202093
28740	9643	1483	840320
28741	9643	1484	247280
28742	9644	1485	\N
28743	9721	1485	\N
28744	9721	1486	\N
28745	9721	1487	\N
28746	9721	1489	\N
28747	9644	1491	511673
28748	9644	1493	210623
28749	9644	1494	330933
28750	9644	1495	473319
28751	9645	1496	\N
28752	9722	1496	\N
28753	9722	1497	\N
28754	9645	1498	237820
28755	9645	1500	642607
28756	9722	1498	268939
28757	9646	1501	321157
28758	9647	1503	\N
28759	9647	1504	660737
28760	9647	1505	514089
28761	9647	1506	579080
28762	9647	1507	905331
28763	9723	1508	238857
28764	9723	1509	583917
28765	9648	1510	573851
28766	9648	1511	304204
28767	9648	1512	581671
28768	9648	1514	424119
28769	9648	1516	307161
28770	9724	1510	565049
28771	9724	1512	454677
28772	9724	1513	916113
28773	9724	1514	657301
28774	9649	1517	\N
28775	9649	1519	785184
28776	9649	1521	405654
28777	9725	1518	217103
28778	9650	1522	663759
28779	9726	1522	195310
28780	9726	1523	299054
28781	9651	1525	\N
28782	9651	1526	\N
28783	9651	1527	\N
28784	9727	1524	\N
28785	9652	1528	\N
28786	9652	1530	\N
28787	9728	1528	\N
28788	9728	1529	\N
28789	9728	1530	\N
28790	9728	1531	\N
28791	9652	1532	441072
28792	9653	1533	\N
28793	9653	1535	\N
28794	9653	1536	\N
28795	9653	1537	\N
28796	9653	1538	\N
28797	9654	1539	544280
28798	9654	1541	695794
28799	9729	1542	\N
28800	9655	1543	699048
28801	9656	1544	828669
28802	9656	1545	388193
28803	9656	1546	531354
28804	9656	1547	675495
28805	9656	1549	824588
28806	9657	1550	\N
28807	9657	1552	\N
28808	9657	1553	794689
28809	9657	1554	870652
28810	9657	1555	442893
28811	9658	1556	\N
28812	9658	1558	\N
28813	9658	1560	612518
28814	9659	1561	\N
28815	9659	1562	800038
28816	9659	1564	781242
28817	9659	1566	482413
28818	9659	1567	724476
28819	9782	1568	\N
28820	9782	1569	\N
28821	9782	1570	\N
28822	9846	1571	418291
28823	9846	1572	238924
28824	9846	1573	506158
28825	9846	1574	734783
28826	9730	1575	\N
28827	9730	1576	963934
28828	9730	1577	335822
28829	9730	1579	516238
28830	9847	1576	439603
28831	9847	1577	959011
28832	9847	1578	944635
28833	9847	1580	478621
28834	9848	1581	\N
28835	9848	1583	\N
28836	9848	1584	\N
28837	9731	1585	451983
28838	9783	1586	684916
28839	9849	1587	\N
28840	9849	1589	\N
28841	9850	1590	\N
28842	9850	1591	\N
28843	9850	1593	\N
28844	9732	1594	724129
28845	9732	1595	524710
28846	9732	1596	733709
28847	9732	1597	715923
28848	9784	1594	536969
28849	9784	1596	969379
28850	9784	1597	906894
28851	9784	1598	611735
28852	9850	1594	302040
28853	9850	1595	361744
28854	9785	1599	\N
28855	9785	1600	712426
28856	9851	1600	330915
28857	9733	1602	\N
28858	9786	1601	\N
28859	9786	1602	\N
28860	9786	1603	\N
28861	9852	1602	\N
28862	9852	1603	\N
28863	9852	1605	223094
28864	9734	1606	\N
28865	9734	1607	\N
28866	9734	1608	\N
28867	9853	1607	\N
28868	9853	1608	\N
28869	9853	1610	\N
28870	9787	1611	762445
28871	9788	1612	\N
28872	9788	1613	\N
28873	9854	1613	\N
28874	9854	1614	\N
28875	9735	1616	148328
28876	9788	1615	867996
28877	9788	1616	573156
28878	9788	1617	401074
28879	9854	1615	431717
28880	9854	1616	929024
28881	9854	1617	808151
28882	9736	1618	\N
28883	9736	1620	\N
28884	9736	1621	\N
28885	9736	1622	\N
28886	9855	1618	\N
28887	9855	1620	\N
28888	9855	1622	\N
28889	9855	1623	\N
28890	9855	1624	\N
28891	9736	1626	974069
28892	9789	1625	457490
28893	9789	1626	742231
28894	9789	1627	591890
28895	9790	1629	\N
28896	9856	1628	\N
28897	9790	1630	442771
28898	9856	1630	602430
28899	9737	1631	\N
28900	9791	1631	\N
28901	9791	1632	\N
28902	9857	1631	\N
28903	9857	1632	\N
28904	9737	1633	796791
28905	9791	1633	152697
28906	9791	1634	382272
28907	9857	1633	601538
28908	9857	1634	814291
28909	9738	1635	\N
28910	9738	1636	\N
28911	9738	1638	\N
28912	9738	1639	\N
28913	9858	1635	\N
28914	9858	1637	\N
28915	9738	1641	868629
28916	9858	1640	334490
28917	9858	1641	628396
28918	9858	1642	713388
28919	9792	1643	\N
28920	9859	1643	\N
28921	9859	1644	\N
28922	9739	1645	351194
28923	9739	1647	183791
28924	9739	1648	251867
28925	9739	1650	348573
28926	9792	1645	444473
28927	9792	1646	416683
28928	9793	1651	\N
28929	9793	1653	\N
28930	9793	1654	\N
28931	9793	1655	\N
28932	9860	1651	\N
28933	9860	1653	\N
28934	9740	1657	810739
28935	9740	1658	782813
28936	9740	1659	373966
28937	9793	1656	562520
28938	9860	1656	808100
28939	9860	1657	951312
28940	9741	1660	\N
28941	9741	1661	\N
28942	9741	1662	\N
28943	9741	1663	\N
28944	9794	1661	\N
28945	9741	1664	945448
28946	9794	1664	843651
28947	9794	1665	916387
28948	9794	1666	465827
28949	9794	1667	534547
28950	9861	1664	644278
28951	9861	1665	489880
28952	9861	1667	409243
28953	9742	1669	\N
28954	9742	1670	\N
28955	9742	1671	\N
28956	9742	1672	\N
28957	9862	1668	\N
28958	9862	1669	\N
28959	9742	1673	529792
28960	9795	1673	855614
28961	9743	1675	\N
28962	9863	1675	\N
28963	9863	1676	\N
28964	9863	1677	\N
28965	9863	1678	\N
28966	9743	1679	245093
28967	9743	1680	757123
28968	9743	1681	516706
28969	9796	1680	615519
28970	9796	1681	417358
28971	9796	1683	508225
28972	9796	1684	551919
28973	9796	1685	807513
28974	9744	1686	\N
28975	9744	1687	\N
28976	9744	1689	\N
28977	9797	1686	\N
28978	9797	1688	\N
28979	9797	1689	\N
28980	9744	1690	431431
28981	9797	1690	997625
28982	9745	1691	\N
28983	9864	1691	\N
28984	9864	1692	751785
28985	9864	1693	703994
28986	9864	1694	491857
28987	9864	1695	839466
28988	9746	1696	\N
28989	9865	1696	\N
28990	9865	1697	\N
28991	9798	1698	131001
28992	9798	1700	913697
28993	9865	1698	727672
28994	9747	1701	\N
28995	9799	1701	\N
28996	9747	1703	904906
28997	9799	1702	478632
28998	9748	1704	\N
28999	9748	1706	\N
29000	9866	1708	550081
29001	9866	1710	888935
29002	9866	1711	245700
29003	9749	1712	\N
29004	9749	1713	\N
29005	9749	1715	\N
29006	9749	1716	\N
29007	9800	1712	\N
29008	9800	1713	\N
29009	9800	1714	\N
29010	9800	1715	\N
29011	9750	1718	\N
29012	9750	1719	\N
29013	9750	1720	473495
29014	9751	1721	\N
29015	9751	1722	\N
29016	9751	1723	\N
29017	9867	1721	\N
29018	9867	1722	\N
29019	9751	1724	466328
29020	9867	1724	614015
29021	9752	1725	\N
29022	9752	1726	\N
29023	9752	1728	\N
29024	9752	1729	\N
29025	9752	1730	\N
29026	9801	1725	\N
29027	9801	1727	\N
29028	9868	1726	\N
29029	9868	1727	\N
29030	9868	1728	\N
29031	9753	1731	\N
29032	9753	1732	\N
29033	9753	1734	\N
29034	9754	1735	\N
29035	9802	1735	\N
29036	9869	1736	\N
29037	9754	1737	795550
29038	9754	1738	154152
29039	9869	1737	725187
29040	9755	1739	\N
29041	9803	1739	\N
29042	9803	1740	\N
29043	9870	1739	\N
29044	9755	1742	646561
29045	9755	1744	186607
29046	9803	1741	121875
29047	9870	1741	848898
29048	9870	1742	496231
29049	9756	1745	\N
29050	9756	1746	\N
29051	9804	1745	\N
29052	9871	1746	\N
29053	9871	1747	\N
29054	9871	1748	\N
29055	9756	1749	468525
29056	9756	1751	354901
29057	9804	1750	232969
29058	9871	1749	452242
29059	9871	1750	140152
29060	9757	1752	\N
29061	9872	1752	\N
29062	9757	1753	468426
29063	9757	1754	269504
29064	9805	1754	480786
29065	9758	1755	\N
29066	9873	1755	\N
29067	9759	1756	\N
29068	9759	1757	\N
29069	9806	1757	\N
29070	9874	1756	\N
29071	9874	1757	\N
29072	9874	1759	213953
29073	9874	1761	653616
29074	9874	1762	655931
29075	9807	1764	\N
29076	9807	1766	\N
29077	9875	1763	\N
29078	9807	1767	205736
29079	9808	1768	\N
29080	9760	1769	936509
29081	9876	1769	730802
29082	9876	1771	699766
29083	9876	1772	505480
29084	9876	1773	803568
29085	9761	1774	\N
29086	9761	1775	\N
29087	9809	1775	\N
29088	9809	1776	\N
29089	9809	1777	\N
29090	9809	1778	\N
29091	9877	1774	\N
29092	9761	1779	109554
29093	9761	1780	823594
29094	9809	1779	474855
29095	9877	1780	189594
29096	9877	1781	874037
29097	9877	1782	742366
29098	9762	1783	\N
29099	9762	1784	\N
29100	9878	1783	\N
29101	9878	1784	\N
29102	9878	1785	\N
29103	9762	1787	670944
29104	9810	1788	\N
29105	9810	1790	\N
29106	9763	1792	337469
29107	9810	1791	116542
29108	9764	1793	\N
29109	9811	1793	\N
29110	9811	1795	\N
29111	9811	1796	\N
29112	9764	1797	288193
29113	9811	1797	125843
29114	9879	1798	\N
29115	9812	1799	266575
29116	9812	1800	654363
29117	9812	1802	763686
29118	9812	1803	842263
29119	9812	1804	836774
29120	9879	1799	192738
29121	9765	1805	\N
29122	9765	1806	\N
29123	9765	1807	\N
29124	9813	1805	\N
29125	9813	1806	\N
29126	9813	1808	\N
29127	9880	1806	\N
29128	9880	1807	\N
29129	9765	1809	100878
29130	9813	1810	560518
29131	9813	1811	452290
29132	9766	1813	\N
29133	9814	1813	\N
29134	9814	1814	\N
29135	9814	1815	\N
29136	9766	1816	329307
29137	9766	1817	550026
29138	9766	1818	963157
29139	9766	1820	894819
29140	9815	1821	\N
29141	9881	1821	\N
29142	9767	1822	385208
29143	9815	1822	557111
29144	9815	1823	709678
29145	9816	1824	\N
29146	9816	1825	\N
29147	9816	1826	119441
29148	9882	1826	924798
29149	9882	1827	505869
29150	9882	1828	945990
29151	9882	1829	451415
29152	9883	1830	\N
29153	9817	1831	713659
29154	9768	1832	\N
29155	9768	1833	\N
29156	9768	1834	\N
29157	9768	1835	\N
29158	9768	1836	\N
29159	9818	1832	\N
29160	9884	1832	\N
29161	9818	1837	231306
29162	9818	1838	548866
29163	9885	1839	\N
29164	9885	1840	\N
29165	9885	1841	\N
29166	9769	1842	997857
29167	9769	1843	430161
29168	9769	1844	714048
29169	9769	1845	458913
29170	9769	1846	983600
29171	9770	1847	\N
29172	9819	1847	\N
29173	9886	1847	\N
29174	9886	1849	\N
29175	9770	1850	606060
29176	9770	1851	168529
29177	9819	1850	910653
29178	9886	1850	653003
29179	9886	1852	451523
29180	9771	1853	363448
29181	9820	1853	494652
29182	9820	1854	319739
29183	9820	1855	138632
29190	9821	1861	\N
