DROP TABLE IF EXISTS SoilProfile;
DROP TABLE IF EXISTS ClimateObservation;
DROP TABLE IF EXISTS WeatherStation;
DROP TABLE IF EXISTS YieldRecord;
DROP TABLE IF EXISTS Crop;
DROP TABLE IF EXISTS GeneticVariety;
DROP TABLE IF EXISTS VarietyInfo;
DROP TABLE IF EXISTS Farm;
DROP TABLE IF EXISTS Farmer;


CREATE TABLE Farmer (
    FarmerID      VARCHAR(10)  PRIMARY KEY,
    FarmerName    VARCHAR(100) NOT NULL,
    PhoneNumber   VARCHAR(20),
    Email         VARCHAR(100),
    Address       VARCHAR(200),
    NationalID    VARCHAR(20)  UNIQUE NOT NULL
);


CREATE TABLE Farm (
    FarmID           VARCHAR(10)  PRIMARY KEY,
    FarmName         VARCHAR(100) NOT NULL,
    Location         VARCHAR(200),
    TotalAreaHa      DECIMAL(10,2),
    CultivatedAreaHa DECIMAL(10,2),
    OrganicCertified BOOLEAN      DEFAULT FALSE,
    FarmerID         VARCHAR(10)  NOT NULL,
    FOREIGN KEY (FarmerID) REFERENCES Farmer(FarmerID)
);


CREATE TABLE VarietyInfo (
    VarietyName              VARCHAR(100) PRIMARY KEY,
    TypicalYieldKgPerHa      DECIMAL(10,2),
    ManagementPracticeNotes  TEXT
);


CREATE TABLE GeneticVariety (
    VarietyID   VARCHAR(10)  PRIMARY KEY,
    VarietyName VARCHAR(100) NOT NULL,
    FarmID      VARCHAR(10)  NOT NULL,
    FOREIGN KEY (VarietyName) REFERENCES VarietyInfo(VarietyName),
    FOREIGN KEY (FarmID)      REFERENCES Farm(FarmID)
);


CREATE TABLE Crop (
    CropID          VARCHAR(10)  PRIMARY KEY,
    FarmID          VARCHAR(10)  NOT NULL,
    CropName        VARCHAR(100) NOT NULL,
    PlantingDate    DATE,
    HarvestDate     DATE,
    GeneticVariety  VARCHAR(100),
    ManagementNotes TEXT,
    FOREIGN KEY (FarmID)         REFERENCES Farm(FarmID),
    FOREIGN KEY (GeneticVariety) REFERENCES VarietyInfo(VarietyName)
);


CREATE TABLE YieldRecord (
    YieldRecordID           VARCHAR(10)  PRIMARY KEY,
    FarmID                  VARCHAR(10)  NOT NULL,
    CropID                  VARCHAR(10)  NOT NULL,
    Yield                   DECIMAL(10,2),
    ManagementPracticeNotes TEXT,
    FOREIGN KEY (FarmID) REFERENCES Farm(FarmID),
    FOREIGN KEY (CropID) REFERENCES Crop(CropID)
);


CREATE TABLE WeatherStation (
    StationID VARCHAR(10)   PRIMARY KEY,
    Latitude  DECIMAL(9,6)  NOT NULL,
    Longitude DECIMAL(9,6)  NOT NULL,
    Elevation DECIMAL(8,2),
    UNIQUE (Latitude, Longitude)
);


CREATE TABLE ClimateObservation (
    ObservationID    VARCHAR(10)   PRIMARY KEY,
    StationID        VARCHAR(10)   NOT NULL,
    ObserveDate      DATETIME      NOT NULL,
    TemperatureC     DECIMAL(5,2),
    PrecipitationMm  DECIMAL(7,2),
    SolarRadiation   DECIMAL(7,2),
    IndPreseMMBs     DECIMAL(8,2),
    Notes            TEXT,
    FOREIGN KEY (StationID) REFERENCES WeatherStation(StationID),
    UNIQUE (StationID, ObserveDate)
);


CREATE TABLE SoilProfile (
    SoilProfileID    VARCHAR(10)  PRIMARY KEY,
    StationID        VARCHAR(10)  UNIQUE NOT NULL,
    FarmID           VARCHAR(10)  UNIQUE NOT NULL,
    pH               DECIMAL(4,2),
    OrganicMatterPct DECIMAL(5,2),
    Texture          VARCHAR(50),
    LastSampleDate   DATE,
    FOREIGN KEY (StationID) REFERENCES WeatherStation(StationID),
    FOREIGN KEY (FarmID)    REFERENCES Farm(FarmID)
);
