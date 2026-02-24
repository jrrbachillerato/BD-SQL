DROP DATABASE IF EXISTS clinica_db;
CREATE DATABASE clinica_db;
USE clinica_db;

CREATE TABLE medicos(
	medico_id int PRIMARY KEY auto_increment,
    dni char(9) UNIQUE,
    nombre varchar(40) NOT NULL,
    apellidos varchar(60) NOT NULL,
    telefono char(9) COMMENT "8 letras y un número"
);
CREATE TABLE pacientes(
	paciente_id int PRIMARY KEY,
    nombre varchar(40) NOT NULL,
    apellidos varchar(60) NOT NULL,
    direccion varchar(60),
    fecha_nacimiento date,
    sexo char(1) CHECK (sexo IN("H","M")),
    peso int COMMENT "Como el peso es en gramos el formato es entero",
    altura int
);
ALTER TABLE pacientes ADD medico int;
ALTER TABLE pacientes ADD CONSTRAINT FK_pacientes FOREIGN KEY(medico)REFERENCES medicos(medico_id) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE pacientes MODIFY altura int CHECK(altura IN(altura>9 and altura>301));
CREATE TABLE analisis(
	paciente int,
    fecha date NOT NULL,
    tipo varchar(30) CHECK (tipo IN("Sangre","Orina","Mixto")),
    CONSTRAINT PK PRIMARY KEY(paciente,fecha)
);
ALTER TABLE analisis ADD CONSTRAINT FK_analisis FOREIGN KEY (paciente)REFERENCES pacientes(paciente_id) ON DELETE NO ACTION ON UPDATE CASCADE;

