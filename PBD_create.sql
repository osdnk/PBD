-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2017-12-16 15:35:03.53

-- tables
-- Table: Clients
CREATE TABLE Clients (
    ClientID int  NOT NULL,
    CONSTRAINT Clients_pk PRIMARY KEY (ClientID)
);

-- Table: CompanyClients
CREATE TABLE CompanyClients (
    CompanyClientID int  NOT NULL,
    Clients_ClientID int  NOT NULL,
    Name varchar(20)  NOT NULL,
    EMail varchar(40)  NOT NULL,
    Phone varchar(20)  NOT NULL,
    Address varchar(100)  NOT NULL,
    CONSTRAINT CompanyClients_pk PRIMARY KEY (CompanyClientID)
);

-- Table: ConferenceBooks
CREATE TABLE ConferenceBooks (
    ConferenceBookID int  NOT NULL,
    Conferences_ConferenceID int  NOT NULL,
    BookTime date  NOT NULL,
    Clients_ClientID int  NOT NULL,
    CONSTRAINT ConferenceBooks_pk PRIMARY KEY (ConferenceBookID)
);

-- Table: ConferenceCosts
CREATE TABLE ConferenceCosts (
    ConferenceCostID int  NOT NULL,
    Conferences_ConferenceID int  NOT NULL,
    Cost decimal(18,2)  NOT NULL,
    DataForm date  NOT NULL,
    DataTo date  NOT NULL,
    CONSTRAINT ConferenceCosts_pk PRIMARY KEY (ConferenceCostID)
);

-- Table: ConferenceDayBook
CREATE TABLE ConferenceDayBook (
    ConferenceDayBookID int  NOT NULL,
    ConferenceDays_ConferenceDaysID int  NOT NULL,
    ConferenceBookID_ConferenceBookID int  NOT NULL,
    ParticipantsNumber int  NOT NULL,
    StudentParticipantsNumber int  NOT NULL,
    CONSTRAINT ConferenceDayBook_pk PRIMARY KEY (ConferenceDayBookID)
);

-- Table: ConferenceDays
CREATE TABLE ConferenceDays (
    ConferenceDayID int  NOT NULL,
    Conferences_ConferenceID int  NOT NULL,
    Date date  NOT NULL,
    NumberOfParticipants int  NOT NULL,
    CONSTRAINT ConferenceDays_pk PRIMARY KEY (ConferenceDayID)
);

-- Table: Conferences
CREATE TABLE Conferences (
    ConferenceID int  NOT NULL,
    Name varchar(50)  NOT NULL,
    DiscountForStudents float  NOT NULL,
    Description varchar(200)  NOT NULL,
    CONSTRAINT Conferences_pk PRIMARY KEY (ConferenceID)
);

-- Table: DayParticipants
CREATE TABLE DayParticipants (
    DayParticipantID int  NOT NULL,
    ConferenceDayBook_ConferenceDayBookID int  NOT NULL,
    Participants_ParticipantID int  NOT NULL,
    StudentID varchar(50)  NULL,
    CONSTRAINT DayParticipants_pk PRIMARY KEY (DayParticipantID)
);

-- Table: Participants
CREATE TABLE Participants (
    ParticipantID int  NOT NULL,
    FirstName varchar(50)  NOT NULL,
    LastName varchar(50)  NOT NULL,
    CONSTRAINT Participants_pk PRIMARY KEY (ParticipantID)
);

-- Table: Payments
CREATE TABLE Payments (
    PaymentID int  NOT NULL,
    ConferenceBookID_ConferenceBookID int  NOT NULL,
    Value decimal(18,2)  NOT NULL,
    PayTime date  NOT NULL,
    CONSTRAINT Payments_pk PRIMARY KEY (PaymentID)
);

-- Table: PrivateClients
CREATE TABLE PrivateClients (
    PrivateClientID int  NOT NULL,
    Clients_ClientID int  NOT NULL,
    FirstName varchar(20)  NOT NULL,
    LastName varchar(20)  NOT NULL,
    EMail varchar(40)  NOT NULL,
    Phone varchar(20)  NOT NULL,
    Address varchar(100)  NOT NULL,
    CONSTRAINT PrivateClients_pk PRIMARY KEY (PrivateClientID)
);

-- Table: WorkshopBook
CREATE TABLE WorkshopBook (
    WorkshopBookID int  NOT NULL,
    Workshops_WorkshopID int  NOT NULL,
    ConferenceDayBook_ConferenceDayBookID int  NOT NULL,
    ParticipantNumber int  NOT NULL,
    CONSTRAINT WorkshopBook_pk PRIMARY KEY (WorkshopBookID)
);

-- Table: WorkshopParticipants
CREATE TABLE WorkshopParticipants (
    WorkshopParticipantID int  NOT NULL,
    WorkshopBook_WorkshopBookID int  NOT NULL,
    DayParticipants_DayParticipantID int  NOT NULL,
    CONSTRAINT WorkshopParticipants_pk PRIMARY KEY (WorkshopParticipantID)
);

-- Table: Workshops
CREATE TABLE Workshops (
    WorkshopID int  NOT NULL,
    ConferenceDays_ConferenceDaysID int  NOT NULL,
    Name varchar(50)  NOT NULL,
    Time time  NOT NULL,
    Cost decimal(18,2)  NOT NULL,
    NumberOfParticipants int  NOT NULL,
    CONSTRAINT Workshops_pk PRIMARY KEY (WorkshopID)
);

-- foreign keys
-- Reference: CompanyClients_Clients (table: CompanyClients)
ALTER TABLE CompanyClients ADD CONSTRAINT CompanyClients_Clients
    FOREIGN KEY (Clients_ClientID)
    REFERENCES Clients (ClientID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: ConferenceBookID_Clients (table: ConferenceBooks)
ALTER TABLE ConferenceBooks ADD CONSTRAINT ConferenceBookID_Clients
    FOREIGN KEY (Clients_ClientID)
    REFERENCES Clients (ClientID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: ConferenceBookID_Conferences (table: ConferenceBooks)
ALTER TABLE ConferenceBooks ADD CONSTRAINT ConferenceBookID_Conferences
    FOREIGN KEY (Conferences_ConferenceID)
    REFERENCES Conferences (ConferenceID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: ConferenceDayBook_ConferenceBookID (table: ConferenceDayBook)
ALTER TABLE ConferenceDayBook ADD CONSTRAINT ConferenceDayBook_ConferenceBookID
    FOREIGN KEY (ConferenceBookID_ConferenceBookID)
    REFERENCES ConferenceBooks (ConferenceBookID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: ConferenceDayBook_ConferenceDays (table: ConferenceDayBook)
ALTER TABLE ConferenceDayBook ADD CONSTRAINT ConferenceDayBook_ConferenceDays
    FOREIGN KEY (ConferenceDays_ConferenceDaysID)
    REFERENCES ConferenceDays (ConferenceDayID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: ConferenceDays_Conferences (table: ConferenceDays)
ALTER TABLE ConferenceDays ADD CONSTRAINT ConferenceDays_Conferences
    FOREIGN KEY (Conferences_ConferenceID)
    REFERENCES Conferences (ConferenceID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Payments_ConferenceBookID (table: Payments)
ALTER TABLE Payments ADD CONSTRAINT Payments_ConferenceBookID
    FOREIGN KEY (ConferenceBookID_ConferenceBookID)
    REFERENCES ConferenceBooks (ConferenceBookID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: PrivateClients_Clients (table: PrivateClients)
ALTER TABLE PrivateClients ADD CONSTRAINT PrivateClients_Clients
    FOREIGN KEY (Clients_ClientID)
    REFERENCES Clients (ClientID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Table_12_ConferenceDayBook (table: DayParticipants)
ALTER TABLE DayParticipants ADD CONSTRAINT Table_12_ConferenceDayBook
    FOREIGN KEY (ConferenceDayBook_ConferenceDayBookID)
    REFERENCES ConferenceDayBook (ConferenceDayBookID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Table_12_Participants (table: DayParticipants)
ALTER TABLE DayParticipants ADD CONSTRAINT Table_12_Participants
    FOREIGN KEY (Participants_ParticipantID)
    REFERENCES Participants (ParticipantID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Table_6_Conferences (table: ConferenceCosts)
ALTER TABLE ConferenceCosts ADD CONSTRAINT Table_6_Conferences
    FOREIGN KEY (Conferences_ConferenceID)
    REFERENCES Conferences (ConferenceID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: WorkshopBook_ConferenceDayBook (table: WorkshopBook)
ALTER TABLE WorkshopBook ADD CONSTRAINT WorkshopBook_ConferenceDayBook
    FOREIGN KEY (ConferenceDayBook_ConferenceDayBookID)
    REFERENCES ConferenceDayBook (ConferenceDayBookID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: WorkshopBook_Workshops (table: WorkshopBook)
ALTER TABLE WorkshopBook ADD CONSTRAINT WorkshopBook_Workshops
    FOREIGN KEY (Workshops_WorkshopID)
    REFERENCES Workshops (WorkshopID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: WorkshopParticipants_DayParticipants (table: WorkshopParticipants)
ALTER TABLE WorkshopParticipants ADD CONSTRAINT WorkshopParticipants_DayParticipants
    FOREIGN KEY (DayParticipants_DayParticipantID)
    REFERENCES DayParticipants (DayParticipantID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: WorkshopParticipants_WorkshopBook (table: WorkshopParticipants)
ALTER TABLE WorkshopParticipants ADD CONSTRAINT WorkshopParticipants_WorkshopBook
    FOREIGN KEY (WorkshopBook_WorkshopBookID)
    REFERENCES WorkshopBook (WorkshopBookID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Workshops_ConferenceDays (table: Workshops)
ALTER TABLE Workshops ADD CONSTRAINT Workshops_ConferenceDays
    FOREIGN KEY (ConferenceDays_ConferenceDaysID)
    REFERENCES ConferenceDays (ConferenceDayID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- End of file.

