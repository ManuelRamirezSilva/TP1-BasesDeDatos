DROP TABLE IF EXISTS VivenEn;
DROP TABLE IF EXISTS Involucrados;
DROP TABLE IF EXISTS Dinosaurios;
DROP TABLE IF EXISTS Recintos;
DROP TABLE IF EXISTS ZonasDelParque;
DROP TABLE IF EXISTS Incidentes;
DROP TABLE IF EXISTS Victimas;

CREATE TABLE ZonasDelParque(
    id_zona INTEGER PRIMARY KEY NOT NULL CHECK (id_zona >= 0),
    epoca VARCHAR(100) NOT NULL CHECK (epoca IN ('Triásico', 'Jurásico', 'Cretácico'))
);

CREATE TABLE Recintos(
    id_recinto INTEGER PRIMARY KEY NOT NULL CHECK (id_recinto >= 0),
    id_zona INTEGER NOT NULL,
    FOREIGN KEY (id_zona) REFERENCES ZonasDelParque(id_zona),
    area_m2 INTEGER NOT NULL,
    tipo VARCHAR(100) NOT NULL CHECK (tipo IN ('Carnívoro', 'Herbívoro')),
    estado VARCHAR(100) NOT NULL CHECK (estado IN ('Óptimo', 'Subóptimo', 'Comprometido', 'Peligroso'))
);

CREATE TABLE Dinosaurios(
    id_dinosaurio INTEGER PRIMARY KEY NOT NULL CHECK (id_dinosaurio >= 0),
    fecha_nacimiento DATE NOT NULL,
    especie VARCHAR(100) NOT NULL,
    genero VARCHAR(100) NOT NULL,
    altura FLOAT(2) NOT NULL CHECK (altura > 0),
    peso FLOAT(2) NOT NULL CHECK (peso > 0)
);

CREATE TABLE VivenEn(
    id_dinosaurio INTEGER PRIMARY KEY NOT NULL,
    id_recinto INTEGER NOT NULL,
    id_zona INTEGER NOT NULL,
    FOREIGN KEY (id_dinosaurio) REFERENCES Dinosaurios(id_dinosaurio),
    FOREIGN KEY (id_recinto) REFERENCES Recintos(id_recinto),
    FOREIGN KEY (id_zona) REFERENCES ZonasDelParque(id_zona)
);

CREATE TABLE Victimas(
    dni INTEGER PRIMARY KEY NOT NULL CHECK (dni >= 0),
    tipo VARCHAR(100) NOT NULL CHECK (tipo IN ('Visitante', 'Empleado', 'CEO')),
    nombre VARCHAR(100) NOT NULL,
    herida VARCHAR(100) NOT NULL
);

CREATE TABLE Incidentes(
    id_incidente INTEGER PRIMARY KEY NOT NULL CHECK (id_incidente >= 0),
    tipo VARCHAR(100) NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL
);

CREATE TABLE Involucrados(
    id_dinosaurio INTEGER NOT NULL,
    dni INTEGER NOT NULL,
    id_incidente INTEGER NOT NULL,
    PRIMARY KEY (id_dinosaurio, dni, id_incidente),
    FOREIGN KEY (id_dinosaurio) REFERENCES Dinosaurios(id_dinosaurio),
    FOREIGN KEY (dni) REFERENCES Victimas(dni),
    FOREIGN KEY (id_incidente) REFERENCES Incidentes(id_incidente)
);