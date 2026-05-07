DROP DATABASE IF EXISTS triggers_test;
CREATE DATABASE triggers_test;
USE triggers_test;

CREATE TABLE alumnos(
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido1 VARCHAR(50) NOT NULL,
    apellido2 VARCHAR(50),
    nota FLOAT
);

DELIMITER $$
DROP TRIGGER IF EXISTS trigger_check_nota_before_insert$$
CREATE TRIGGER trigger_check_nota_before_insert
BEFORE INSERT ON alumnos FOR EACH ROW 
BEGIN
	IF NEW.nota < 0 THEN
		set NEW.nota = 0;
	ELSEIF NEW.nota > 10 THEN
		set NEW.nota = 10;
	END IF;
END$$

DELIMITER ;
INSERT INTO alumnos VALUES (1, 'Juan', 'Ruiz', 'Ramírez', -1);
INSERT INTO alumnos VALUES (2, 'Jose', 'Ruiz', 'Ramírez', 7);
INSERT INTO alumnos VALUES (3, 'Pilar', 'Ruiz', 'Ramírez', 8);
INSERT INTO alumnos VALUES (4, 'María', 'Ruiz', 'Espartero', 12);

SELECT * FROM alumnos;

DELIMITER $$
DROP TRIGGER IF EXISTS trigger_check_nota_before_update$$
CREATE TRIGGER trigger_check_nota_before_update
BEFORE UPDATE ON alumnos FOR EACH ROW
BEGIN
	IF NEW.nota < 0 THEN
		set NEW.nota = 0;
	ELSEIF NEW.nota > 10 THEN
		set NEW.nota = 10;
	END IF;
END$$

DELIMITER ;
UPDATE alumnos SET nota = -4 WHERE id = 1;
UPDATE alumnos SET nota = 14 WHERE id = 2;
UPDATE alumnos SET nota = 9.5 WHERE id = 3;
UPDATE alumnos SET nota = 9.8 WHERE id = 4;

SELECT * FROM alumnos;



SET GLOBAL log_bin_trust_function_creators = 1;



DELIMITER $$
DROP FUNCTION IF EXISTS calcular_dia$$
CREATE FUNCTION calcular_dia(dia INT)
RETURNS VARCHAR(50) 
deterministic
BEGIN
DECLARE nombre_dia VARCHAR(50);
CASE dia
WHEN 1 THEN SET nombre_dia = 'Lunes';
WHEN 2 THEN SET nombre_dia = 'Martes';
WHEN 3 THEN SET nombre_dia = 'Miércoles';
WHEN 4 THEN SET nombre_dia = 'Jueves';
WHEN 5 THEN SET nombre_dia = 'Viernes';
WHEN 6 THEN SET nombre_dia = 'Sábado';
WHEN 7 THEN SET nombre_dia = 'Domingo';
ELSE SET nombre_dia = 'Valor no válido';
END CASE;
RETURN nombre_dia;
END$$
DELIMITER ;
SELECT calcular_dia(4);


CREATE DATABASE funciones_test;
USE funciones_test;
CREATE TABLE producto (
codigo INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(100) NOT NULL,
precio DOUBLE NOT NULL,
codigo_fabricante INT UNSIGNED NOT NULL
);
INSERT INTO producto VALUES(1, 'Disco duro SATA3 1TB',
86.99, 1);
INSERT INTO producto VALUES(2, 'Memoria RAM DDR4 8GB',
120, 2);
INSERT INTO producto VALUES(3, 'Disco SSD 1 TB', 150.99,
3);

DELIMITER $$
DROP FUNCTION IF EXISTS
calcular_numero_total_productos$$
CREATE FUNCTION calcular_numero_total_productos()
RETURNS INT
BEGIN
DECLARE total INT;
SET total = (SELECT COUNT(*) FROM producto);
RETURN total;
END$$
DELIMITER ;
SELECT calcular_numero_total_productos();


DELIMITER $$
DROP FUNCTION IF EXISTS calcular_precio_medio$$
CREATE FUNCTION calcular_precio_medio(Fcodigo INT)
RETURNS FLOAT
BEGIN
DECLARE media FLOAT;
SET media = (SELECT AVG(precio)
FROM producto
WHERE codigo_fabricante = codigo);
RETURN media;
END$$
DELIMITER ;
SELECT calcular_precio_medio(1);

