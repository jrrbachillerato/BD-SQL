/*1. Mostrar los nombres de los empleados del departamento PERSONAL.*/
SELECT Nomem FROM empleados WHERE Numde = (SELECT Numde FROM departamentos WHERE Nomde = 'PERSONAL');
SELECT Nomem FROM empleados WHERE Numde in (SELECT Numde FROM departamentos WHERE Nomde like '%PERSONAL%');

/*2. Mostrar el nombre y salario del empleado que más cobra en la empresa. */
SELECT Nomem, Salar FROM empleados WHERE Salar = (SELECT max(Salar) FROM empleados);

/*3. Mostrar el nombre del departamento donde hay empleados con más de 2 hijos. */
SELECT Nomde FROM departamentos WHERE Numde IN (SELECT Numde FROM empleados WHERE Numhi >2) ORDER BY Nomde;

/*4. Mostrar el nombre del departamento donde no hay empleados que cobren más de 2000 €.*/
SELECT Nomde FROM departamentos WHERE Numde NOT IN (SELECT Numde FROM empleados WHERE Salar> 2000);

/*5. Mostrar el nombre de empleado y el sueldo de los empleados que cobran más que todos los 
empleados que tienen hijos. */
SELECT Nomem, Salar AS 'Salar' FROM empleados WHERE Salar > (SELECT max(Salar) FROM empleados WHERE Numhi > 0);
SELECT Nomem, Salar AS 'Salar' FROM empleados WHERE Salar > ALL (SELECT Salar FROM empleados WHERE Numhi > 0);

/*6. Mostrar el nombre y el sueldo del empleado que más cobra de los empleados que tienen no 
tienen hijos. 
*/
SELECT Nomem, Salar+ifnull(Comis,0) AS 'Salar' FROM empleados WHERE Salar+ifnull(Comis,0) = 
(SELECT MAX(Salar+ifnull(Comis,0)) FROM empleados WHERE Numhi = 0) AND Numhi = 0;

/*7. Mostrar el nombre del departamento que tiene al empleado que más cobra de la empresa.*/
SELECT Nomde FROM departamentos WHERE Numde IN 
(SELECT Numde FROM empleados WHERE Salar+ifnull(Comis,0) = 
(SELECT MAX(Salar+ifnull(Comis,0)) FROM empleados));

/*8. Mostrar por orden alfabético los nombres de los empleados cuyos sueldos igualan o superan 
al de CESAR.*/
SELECT Nomem FROM empleados WHERE Salar >= ALL
(SELECT Salar FROM empleados WHERE Nomem = 'CESAR') AND  Nomem != 'CESAR' ORDER BY Nomem ASC;

/*9. Mostrar por orden alfabético los nombres de los empleados cuyo salario supera al máximo 
salario de los empleados del departamento 111. */
SELECT Nomem FROM empleados WHERE Salar > 
(SELECT MAX(Salar) FROM empleados WHERE Numde = 111) ORDER BY Nomem ASC;

/*10. Mostrar por orden alfabético los nombres de los empleados que trabajan en el mismo 
departamento que CESAR o MARIO. */
SELECT Nomem FROM empleados WHERE Numde IN 
(SELECT Numde FROM empleados WHERE Nomem = 'CESAR' OR Nomem = 'MARIO')
 ORDER BY Nomem ASC;

/*11. Mostrar por orden alfabético los nombres de los departamentos cuyo tipo de director es el 
mismo que el del departamento: DIRECC.COMERCIAL o el del departamento: PERSONAL. */
SELECT Nomde, tidir FROM departamentos WHERE tidir IN 
(SELECT tidir FROM departamentos WHERE Nomde = 'DIRECC.COMERCIAL' OR 
Nomde = 'PERSONAL') ORDER BY Nomde ASC; 

/*12. Mostrar los nombres de los centros de trabajo si hay alguno que esté en la calle ATOCHA.*/
SELECT Nomce FROM centros WHERE EXISTS  
(SELECT Numce FROM centros WHERE Dirce LIKE '%ATOCHA%');

SELECT Nomce, Dirce FROM centros WHERE Dirce LIKE '%ATOCHA%';

/*13. Obtener los nombres y el salario de los empleados del departamento 100 si en él hay alguno 
que gane más de 1300 €.*/
SELECT Nomem, Salar FROM empleados WHERE Numde IN 
(SELECT Numde FROM empleados WHERE Numde = 100 and Salar > 1300);

SELECT Nomem, Salar FROM empleados WHERE Numde = 100 AND EXISTS 
(SELECT Numde FROM empleados WHERE Numde = 100 and Salar > 1300);

/*14. Obtener por orden alfabético los nombres y comisiones de los empleados del departamento 
110 si en él hay algún empleado que tenga comisión. */
SELECT Nomem, ifnull(Comis,0) FROM empleados WHERE Numde IN 
(SELECT Numde FROM empleados WHERE Numde = 110 and  ifnull(Comis,0) > 0);

/*15. Obtener los nombres de los departamentos que no sean ni de DIRECCION ni de SECTORES. 
(no necesita subconsulta)*/
SELECT Nomde FROM departamentos WHERE Nomde NOT LIKE '%DIRECC%' 
and Nomde NOT LIKE 'SECTOR%';

/*16. Obtener, por orden alfabético, los nombres y salarios de los empleados del departamento 111 
que tienen comisión si hay alguno de ellos cuya comisión supere al 15% de su salario.*/
SELECT Nomem, Salar AS SALARIO FROM empleados WHERE  
Numde IN (SELECT Numde FROM empleados WHERE Numde = 111 and 
Comis > 0.15 * Salar) AND Comis > 0;

/*17. Obtener por orden alfabético los nombres y salarios de los empleados que o bien no tienen 
hijos y ganan más de 1.500 €, o bien tienen hijos y ganan menos de 1.000 € (no necesita 
subconsulta). */
SELECT Nomem, Salar FROM empleados WHERE 
Numhi = 0 AND Salar > 1500 OR 
Numhi > 0 and Salar < 1000 ORDER BY Nomem;

/*18. Hallar los nombres de departamentos, el tipo de director y su presupuesto, para aquellos 
departamentos que tienen directores en funciones, o bien en propiedad y su presupuesto anual 
excede a 30.000 € o no dependen de ningún otro (no necesita subconsulta).*/
SELECT Nomde, tidir, presu FROM departamentos WHERE 
(tidir = 'F') or (tidir = 'P' and presu > 30) or 
(DEPDE IS NULL);
