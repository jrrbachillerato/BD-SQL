/* 1. Crear un procedimiento que calcule el número de libros editados en el año 1992. Posteriormente habrá que almacenar en una cadena de caracteres el texto "En el año 1992 se editaron <n> libros.", donde <n> es el número de libros editados en 1992. */

DELIMITER $$
DROP PROCEDURE IF EXISTS calculo_libros$$
CREATE PROCEDURE calculo_libros(OUT salida VARCHAR(100))
BEGIN
	DECLARE n INT;
    SET n = (SELECT count(*) FROM tlibro WHERE nAnyoPublicacion = 1992);
    SET salida = CONCAT("En el año 1992 se editaron " , n, " libros.");
END$$
DELIMITER ;

CALL calculo_libros(@resultado);

SELECT @resultado;


/* 2. Crear un procedimiento en el que se declare una variable vcTexto de tipo cadena de caracteres. Se comprobará si el libro de código 342 tiene uno o varios autores. En el primer caso, asignar a la variable el texto "Tiene un autor"; en el segundo, asignar "Tiene varios autores". */

DELIMITER $$

DROP PROCEDURE IF EXISTS numAutores$$
CREATE PROCEDURE numero_Autores()
BEGIN
	DECLARE vcTexto VARCHAR(50);
    DECLARE numAutores INT;
    
    SET numAutores = (SELECT count(*) FROM TlibroAutor WHERE nLibroID = 342);
    
	IF numAutores = 0 THEN 
		SET vcTexto = "El libro no tiene autores";
    ELSEIF numAutores = 1 THEN  
		SET vcTexto = "El libro tiene un autor";  
    ELSE
		SET vcTexto = "El libro tiene varios autores";
    END IF;
    
    SELECT vcTexto;
    
END $$

DELIMITER ;

CALL numero_Autores();



/* 3. Modificar el código de la actividad anterior para que a la variable vcTexto se le asigne el valor "Tiene un autor", "Tiene dos autores", "Tiene tres autores", "Tiene cuatro autores" y "Tiene más de cuatro autores" si el libro de código 342 tiene uno, dos, tres, cuatro o más de cuatro autores, respectivamente. */
DELIMITER $$

DROP PROCEDURE IF EXISTS numero_Autores $$
CREATE PROCEDURE numero_Autores()
BEGIN
	DECLARE vcTexto VARCHAR(50);
    DECLARE numAutores INT;
    
    SET numAutores = (SELECT count(*) FROM TlibroAutor WHERE nLibroID = 342);
    
	IF numAutores = 0 THEN 
		SET vcTexto = "El libro no tiene autores";
    ELSEIF numAutores = 1 THEN  
		SET vcTexto = "El libro tiene un autor";
    ELSEIF numAutores = 2 THEN  
		SET vcTexto = "El libro tiene dos autores";
    ELSEIF numAutores = 3 THEN  
		SET vcTexto = "El libro tiene tres autores";
    ELSEIF numAutores = 4 THEN  
		SET vcTexto = "El libro tiene cuatro autores";  
    ELSE
		SET vcTexto = "El libro tiene más de cuatro autores";
    END IF;
    
    SELECT vcTexto;
    
END $$

DELIMITER ;

CALL numero_Autores();


/* 4. Crear un procedimiento (actualizar_editorial) sin parámetros que actualice el campo cNombre de todos los registros de la tabla TEditorial con el valor del campo cNombre, la concatenación de cNombre + ' 2021'. Llama al procedimiento para comprobar que funciona. */

DELIMITER $$

DROP PROCEDURE IF EXISTS actualizar_editorial$$
CREATE PROCEDURE actualizar_editorial()

BEGIN
	UPDATE TEditorial SET cNombre = CONCAT(cNombre, '2021');
END $$

DELIMITER ;

CALL actualizar_editorial();


/* 5. Crear un trigger (calcular_ano_publicacion_before_insert) que se ejecuta sobre la tabla TLibro antes de realizar una operación de inserción. Si el año de publicación a guardar es inferior a 1999 guardará 2000. Además concatenará al final del cNombre asignado la cadena "_act". Inserta un par de registros para comprobar el funcionamiento del trigger. */

DELIMITER $$

DROP TRIGGER IF EXISTS calcular_ano_publicacion_before_insert $$
CREATE TRIGGER calcular_ano_publicacion_before_insert
BEFORE INSERT ON TLibro
FOR EACH ROW
BEGIN
	IF NEW.nAnyoPublicacion < 1999 THEN
		SET NEW.nAnyoPublicacion = 2000;
        SET NEW.cTitulo = CONCAT(NEW.cTitulo, " _act");
	END IF;
END $$
DELIMITER ;
    
DESCRIBE TLibro;

INSERT INTO TLibro (nLibroID, cTitulo, nAnyoPublicacion, nEditorialID) 
VALUES (99, 'HOLA', 1888, 10);


/* 6. Crea una función (calcular_libros_publicados) que devuelva el número de libros de un determinado autor que se recibirá como parámetro de entrada. El parámetro de entrada será el nombre del autor. Llama a la función para comprobar su funcionamiento. */

DELIMITER $$
DROP FUNCTION IF EXISTS ejercicio6 $$
CREATE FUNCTION ejercicio6(nombre_autor VARCHAR(100))
RETURNS INT DETERMINISTIC
BEGIN
	RETURN (SELECT count(*) FROM tlibroautor WHERE nAutorID IN
    (SELECT nAutorID FROM tautor WHERE cNombre = nombre_autor));
END $$
DELIMITER ;

SET @prueba = ejercicio6("ada");
SELECT @prueba AS Número_Autores;


/* 7. Escribe un procedimiento que reciba un número entero de entrada, que representa el año de publicación de un libro, y un parámetro de salida, con una cadena de texto indicando si fueron suficientes libros publicados o no teniendo en cuenta las siguientes condiciones:
[0, 5) = Insuficientes
[5, 10) = Pocos
[10, 15) = Suficientes
+15 = Excelente
Llama al procedimiento para probar su funcionamiento. */

DELIMITER $$

DROP PROCEDURE IF EXISTS ejercicio7 $$
CREATE PROCEDURE ejercicio7(IN año INT, OUT salida VARCHAR(100))

BEGIN
	DECLARE totalLibros INT;
    SET totalLibros = (SELECT * FROM Tlibro WHERE nAnyoPublicacion = año);
    
    CASE totalLibros
		WHEN totalLibros>0 AND totalLibros<5 THEN SET salida ="Insuficientes";
		WHEN totalLibros>5 AND totalLibros<10 THEN SET salida ="Pocos";
		WHEN totalLibros>10 AND totalLibros<15 THEN SET salida ="Suficientes";
		WHEN totalLibros>15 THEN SET salida ="Insuficientes";
	END CASE;
END $$

DELIMITER ;



/* 8. Crea una función (calcular_socios_jovenes) que devuelva el número de socios con edades menores a 30 años. La función no necesitará parámetros de entrada. Llama a la función para comprobar su funcionamiento. */

/* 9. Escribir un trigger que lleve a cabo la siguiente tarea sobre los borrados de la tabla tlibro. Cada vez que se borre un libro se comprobará si era el único libro de su editorial. */

DELIMITER $$
DROP TRIGGER IF EXISTS ejercicio9 $$
CREATE TRIGGER ejercicio9
AFTER DELETE ON tlibro
FOR EACH ROW
BEGIN
	DECLARE num_libros INT;
    SET num_libros = (SELECT COUNT(*) FROM tlibro WHERE nEditorialID = OLD.nEditorialID);
    
    IF(num_libros = 0) THEN
		DELETE FROM nEditorialID WHERE nEditorialID = OLD.nEditorialID;
	END IF;
END $$

DELIMITER ;

DELETE FROM tlibro WHERE libroID = 4;