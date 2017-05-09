
DROP TABLE MechanicSkills;
DROP TABLE Mentorings;
DROP TABLE Skills;
DROP TABLE ServiceTechnicians;
DROP TABLE Certifications;
DROP TABLE Mechanics;
DROP TABLE Employees;
DROP TABLE VisitItem;
DROP TABLE MaintenanceVisit;
DROP TABLE EmailProspective;
DROP TABLE EmailSteady;
DROP TABLE MaintenancePackage;
DROP TABLE MaintenanceItem;
DROP TABLE Vehicle;
DROP TABLE Emails;
DROP TABLE ProspectiveCustomers;
DROP TABLE PremiereCustomers;
DROP TABLE SteadyCustomers;
DROP TABLE ExistingCustomers;
DROP TABLE Addresses;
DROP TABLE PrivateIndividuals;
DROP TABLE Corporations;
DROP TABLE Customers;

create table Customers (
    custID 	        VARCHAR(20) NOT NULL,
    cName 	        VARCHAR(40) NOT NULL,
    cFirstName 		VARCHAR(20) NOT NULL,
    cLastName 		VARCHAR(20) NOT NULL,
    cPhone 			VARCHAR(20) NOT NULL,
    cEmail          VARCHAR(40) NOT NULL,
    CONSTRAINT customer_pk PRIMARY KEY (custID)
);

create table Corporations(
    custID 			VARCHAR(20) NOT NULL,
    CONSTRAINT corporation_pk PRIMARY KEY (custID),
    CONSTRAINT corportaion_fk FOREIGN KEY (custID)
        REFERENCES Customers (custID)
);

create table PrivateIndividuals(
    custID 			VARCHAR(20) NOT NULL,
    street 			VARCHAR(40) NOT NULL,
    city 			VARCHAR(20) NOT NULL,
    state 			VARCHAR(10) NOT NULL,
    CONSTRAINT privind_pk PRIMARY KEY (custID),
    CONSTRAINT privind_fk FOREIGN KEY (custID)
        REFERENCES Customers (custID)
);

create table Addresses(
    custID 			VARCHAR(20) NOT NULL,
    type 			VARCHAR(10) NOT NULL,
    street 			VARCHAR(40) NOT NULL,
    city 			VARCHAR(20) NOT NULL,
    state 			VARCHAR(10) NOT NULL,
    CONSTRAINT address_pk PRIMARY KEY (custID, type, street),
    CONSTRAINT address_fk FOREIGN KEY (custID)
        REFERENCES Customers (custID)
);

create table ExistingCustomers(
    custID 			VARCHAR(20) NOT NULL,
    regDate 		DATE NOT NULL,
    CONSTRAINT existing_pk PRIMARY KEY (custID),
    CONSTRAINT existing_fk FOREIGN KEY (custID)
        REFERENCES Customers (custID)
);

create table SteadyCustomers(
    custID 			VARCHAR(20) NOT NULL,
    loyalty_points 	INTEGER NOT NULL,
    CONSTRAINT steady_pk PRIMARY KEY (custID),
    CONSTRAINT steady_fk FOREIGN KEY (custID)
        REFERENCES ExistingCustomers (custID)
);

create table PremiereCustomers(
    custID 			VARCHAR(20) NOT NULL,
    monthly_fee 	DECIMAL NOT NULL,
    CONSTRAINT premiere_pk PRIMARY KEY (custID),
    CONSTRAINT premiere_fk FOREIGN KEY (custID)
        REFERENCES ExistingCustomers (custID)
);

create table ProspectiveCustomers(
    custID 			VARCHAR(20) NOT NULL,
    refID 			VARCHAR(20) NOT NULL,
    status 			VARCHAR(10) NOT NULL,
    referal_date 	DATE NOT NULL,
    CONSTRAINT prospective_pk PRIMARY KEY (custID, refID),
    CONSTRAINT prospective_fk_cust FOREIGN KEY (custID)
        REFERENCES Customers (custID),
    CONSTRAINT prospective_fk_ref FOREIGN KEY (refID)
        REFERENCES ExistingCustomers (custID)
);


create table Emails(
    emailID 		VARCHAR(20) NOT NULL,
    subject 		VARCHAR(20) not NULL,
    message 		VARCHAR(50) NOT NULL,
    CONSTRAINT email_pk PRIMARY KEY (emailID)
);


CREATE TABLE Vehicle(
    custID                  varchar(20) NOT NULL,
    VIN       			varchar(17) NOT NULL,
    make                	varchar(20) NOT NULL,
    model               	varchar(20) NOT NULL,
    vyear               	int NOT NULL,
    currentMileage      	int NOT NULL,
    estimatedMilePerYear  	int NOT NULL,
    CONSTRAINT 	vehicle_pk  PRIMARY KEY (VIN),
	CONSTRAINT	vehicle_fk 	FOREIGN KEY(custID) 
		REFERENCES Customers(custID)
);

CREATE TABLE MaintenanceItem (
    itemID 		varchar(20) NOT NULL,
    itemName 	varchar(30) NOT NULL,
    itemCost 	double NOT NULL,
    laborHours 	int NOT NULL,
    itemDesc 	varchar(50),
    skillName 	varchar(20) NOT NULL,
    CONSTRAINT MaintenanceItem_pk PRIMARY KEY (itemID)
);

CREATE TABLE MaintenancePackage(
    packageID 			VARCHAR(20) NOT NULL,
    packageName         varchar(20) NOT NULL,
    packMileage         int NOT NULL,
    VIN                 varchar(17) NOT NULL,
    itemID              varchar(20) NOT NULL,
    CONSTRAINT  maintenancepackage_pk  PRIMARY KEY (packageID),
    CONSTRAINT maintenancepackage_fk FOREIGN KEY (VIN) 
		REFERENCES Vehicle (VIN),
    CONSTRAINT maintenancepackage_fk_2 FOREIGN KEY (itemID) 
		REFERENCES MaintenanceItem (itemID)
);

create table EmailSteady(
    emailID 		VARCHAR(20) NOT NULL,
    custID 			VARCHAR(20) NOT NULL,
    packageID 		VARCHAR(20) NOT NULL,
    date_sent 		DATE NOT NULL,
    CONSTRAINT email_steady_pk PRIMARY KEY (emailID, custID, packageID, date_sent),
    CONSTRAINT email_steady_fk FOREIGN KEY (emailID)
        REFERENCES Emails (emailID),
    CONSTRAINT email_cust_fk FOREIGN KEY (custID)
        REFERENCES SteadyCustomers (custID),
    CONSTRAINT email_pack_id FOREIGN KEY (packageID)
        REFERENCES MaintenancePackage (packageID)
);

create table EmailProspective(
    emailID 			VARCHAR(20) NOT NULL,
    custID 			VARCHAR(20) NOT NULL,
    refID                       VARCHAR(20) NOT NULL,
    date_sent 			DATE NOT NULL,
    CONSTRAINT email_pros_pk PRIMARY KEY (emailID, custID, date_sent),
    CONSTRAINT email_pros_fk FOREIGN KEY (emailID)
        REFERENCES Emails (emailID),
    CONSTRAINT email_pros_cust_fk FOREIGN KEY (custID, refID)
        REFERENCES ProspectiveCustomers (custID, refID)
);

CREATE TABLE MaintenanceVisit (
    VIN 			varchar(17) NOT NULL,
    visitID 		varchar(20) NOT NULL,
    visitDate 		date NOT NULL,
    expectedMileage int NOT NULL,
    actualMileage 	int NOT NULL,
    billedAmount 	double NOT NULL,
    packageID 		VARCHAR(20) NOT NULL,
    employeeID 		varchar(20) NOT NULL,
    CONSTRAINT MaintenanceVisits_pk PRIMARY KEY (visitID),
    CONSTRAINT MaintenanceVisit_fk_1 FOREIGN KEY (VIN) 
        REFERENCES Vehicle (VIN),
    CONSTRAINT MaintenanceVisit_fk_2 FOREIGN KEY (packageID) 
        REFERENCES MaintenancePackage (packageID)
    
);

CREATE TABLE VisitItem (
    itemID 		varchar(20) NOT NULL,
    visitID 	varchar(20) NOT NULL,
    hours 		int NOT NULL,
    employeeID 	varchar(20) NOT NULL,
    CONSTRAINT VisitItem_pk PRIMARY KEY (itemID, visitID),
    CONSTRAINT VisitItem_fk_1 FOREIGN KEY (itemID) 
				REFERENCES MaintenanceItem (itemID),
    CONSTRAINT VisitItem_fk_2 FOREIGN KEY (visitID) 
				REFERENCES MaintenanceVisit (visitID)
);

	
create table Employees(
    employeeID 	VARCHAR(20) NOT NULL,
    firstName 	VARCHAR(20) NOT NULL,
    lastName 	VARCHAR(20) NOT NULL,
    phone 		VARCHAR(20) NOT NULL,
    CONSTRAINT employees_pk PRIMARY KEY(employeeID)
);

create table Mechanics(
    employeeID 	VARCHAR(20) NOT NULL,
    title 		VARCHAR(20) NOT NULL,
    CONSTRAINT mechanics_pk PRIMARY KEY (employeeID),
    CONSTRAINT mechanics_fk FOREIGN KEY(employeeID)
        REFERENCES Employees (employeeID)
);

create table Certifications(
    employeeID 		VARCHAR(20) NOT NULL,
    certification 	VARCHAR(40) NOT NULL,
    CONSTRAINT certifications_pk PRIMARY KEY (employeeID, certification),
    CONSTRAINT certifications_fk FOREIGN KEY (employeeID) 
        REFERENCES Mechanics (employeeID)
);

create table ServiceTechnicians(
    employeeID VARCHAR(20) NOT NULL,
    CONSTRAINT servicetechnicians_pk PRIMARY KEY (employeeID),
    CONSTRAINT servicetechnicians_fk FOREIGN KEY (employeeID)
        REFERENCES Mechanics (employeeID) 
);

create table Skills(
    skillName VARCHAR(20) NOT NULL,
    CONSTRAINT skills_pk PRIMARY KEY (skillName)
);

create table Mentorings(
    mentor 		VARCHAR(20) NOT NULL,
    mentoree 	VARCHAR(20) NOT NULL,
    skillName 	VARCHAR(20) NOT NULL,
    startDate 	DATE NOT NULL,
    endDate 	DATE,
    CONSTRAINT mentorings_pk PRIMARY KEY (mentor,mentoree,skillName,startDate),
    CONSTRAINT mentorings_fk_m1 FOREIGN KEY (mentor) 
        REFERENCES Mechanics (employeeID),
    CONSTRAINT mentorings_fk_m2 FOREIGN KEY (mentoree)
        REFERENCES Mechanics (employeeID),
    CONSTRAINT mentorings_fk FOREIGN KEY (skillName)
        REFERENCES Skills (skillName)
);

create table MechanicSkills(
    employeeID 		VARCHAR(20) NOT NULL,
    skillName 		VARCHAR(20) NOT NULL,
    proficiency 	VARCHAR(15) NOT NULL,
    CONSTRAINT mechanicskills_pk PRIMARY KEY (employeeID,skillName),
    CONSTRAINT mechanicskills_fk FOREIGN KEY (employeeID)
        REFERENCES Mechanics (employeeID),
    CONSTRAINT mechanicskills_fk_skill FOREIGN KEY (skillName)
        REFERENCES Skills (skillName)
);
