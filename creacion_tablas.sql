DROP TABLE IF EXISTS VivenEn;
DROP TABLE IF EXISTS Involucrados;
DROP TABLE IF EXISTS Dinosaurios;
DROP TABLE IF EXISTS Recintos;
DROP TABLE IF EXISTS ZonasDelParque;
DROP TABLE IF EXISTS Incidentes;
DROP TABLE IF EXISTS Victimas;

CREATE TABLE Dinosaurios(
    id_dinosaurio INTEGER primary key NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    especie VARCHAR(100) NOT NULL,
    genero VARCHAR(100) NOT NULL,
    altura FLOAT(2) NOT NULL,
    peso FLOAT(2) NOT NULL
);

CREATE TABLE ZonasDelParque(
    id_zona INTEGER primary key NOT NULL,
    epoca VARCHAR(100) NOT NULL,
    CHECK (epoca IN ('Triásico', 'Jurásico', 'Cretácico'))
);

CREATE TABLE Recintos(
    id_recinto INTEGER primary key NOT NULL,
    id_zona INTEGER NOT null,
    FOREIGN KEY (id_zona) REFERENCES ZonasDelParque(id_zona),
    area_m2 INTEGER NOT NULL,
    tipo VARCHAR(100) NOT NULL CHECK IN ('Carnívoro', 'Herbívoro'),
    estado VARCHAR(100) NOT NULL CHECK IN ('Óptimo', 'Subóptimo', 'Comprometido', 'Peligroso')
    -- CHECK (tipo IN ('Carnívoro', 'Herbívoro')),
    -- CHECK (estado IN ('Óptimo', 'Subóptimo', 'Comprometido', 'Peligroso'))
);


CREATE TABLE Incidentes(
    id_incidente INTEGER primary key NOT NULL,
    tipo VARCHAR(100) NOT null,
    fecha DATE NOT NULL,
    hora TIME NOT NULL
);

CREATE TABLE Victimas(
    dni INTEGER primary key NOT NULL,
    tipo VARCHAR(100) NOT null,
    nombre VARCHAR(100) NOT NULL,
    herida VARCHAR(100) NOT NULL,
    CHECK (tipo IN ('Visitante', 'Empleado', 'CEO'))
);

CREATE TABLE VivenEn(
    id_dinosaurio INTEGER primary key NOT NULL,
    id_recinto INTEGER NOT null,
    id_zona INTEGER NOT null,
    FOREIGN KEY (id_dinosaurio) REFERENCES Dinosaurios(id_dinosaurio),
    FOREIGN KEY (id_recinto) REFERENCES Recintos(id_recinto),
    FOREIGN KEY (id_zona) REFERENCES ZonasDelParque(id_zona)
);

CREATE TABLE Involucrados(
    id_dinosaurio INTEGER NOT NULL,
    dni INTEGER NOT null,
    id_incidente INTEGER NOT null,
    PRIMARY KEY (id_dinosaurio, dni, id_incidente),
    FOREIGN KEY (id_dinosaurio) REFERENCES Dinosaurios(id_dinosaurio),
    FOREIGN KEY (dni) REFERENCES Victimas(dni),
    FOREIGN KEY (id_incidente) REFERENCES Incidentes(id_incidente)
);





