/*
1. Devolver el nombre y DNI de las personas que recibieron heridas fatales en algún incidente.
*/
SELECT v.nombre, v.dni
FROM (Victimas v INNER JOIN Involucrados inv ON v.dni=inv.dni) INNER JOIN Incidentes I ON i.id_incidente=inv.id_incidente
WHERE v.herida = 'Fatal';

/*
2. Devolver el nombre y estado de los diferentes recintos en los que viven los 'Eoraptor'.
*/
SELECT distinct r.id_recinto, r.estado
FROM (Dinosaurios d INNER JOIN VivenEn ve ON d.id_dinosaurio=ve.id_dinosaurio) INNER JOIN
    Recintos r ON ve.id_recinto = r.id_recinto
WHERE d.especie = 'Eoraptor';

/*
3. Devolver los incidentes del año 2020.
*/
SELECT *
FROM Incidentes i
WHERE EXTRACT(YEAR FROM i.fecha) = 2020;

/*
4. Obtener los id_recinto de los recintos en estado 'Peligroso' con la cantidad de dinosaurios
en cada uno (orden descendente).
*/
SELECT r.id_recinto, COUNT(ve.id_dinosaurio) AS cantidad_dinosaurios
FROM Recintos r INNER JOIN VivenEn ve ON r.id_recinto = ve.id_recinto
WHERE r.estado = 'Peligroso'
GROUP BY r.id_recinto
ORDER BY cantidad_dinosaurios DESC;

/*
5. Obtener incidentes de tipo 'Accidente de empleado' con la especie del dinosaurio, la era de la zona y el nombre del empleado.
*/
SELECT i.id_incidente, d.especie, z.epoca, v.nombre AS nombre_empleado
FROM ((((Incidentes i INNER JOIN Involucrados iv ON i.id_incidente = iv.id_incidente) 
	INNER JOIN Dinosaurios d ON iv.id_dinosaurio = d.id_dinosaurio)  INNER JOIN VivenEn ve ON d.id_dinosaurio = ve.id_dinosaurio)
	INNER JOIN ZonasDelParque z ON ve.id_zona = z.id_zona) INNER JOIN Victimas v ON iv.dni = v.dni
WHERE i.tipo = 'Accidente de empleado';

/*
6. Devolver la especie y la cantidad de veces que participó esa especie en un incidente, en forma descendente.
*/
SELECT d.especie, COUNT(DISTINCT ic.id_incidente) as cuenta_incidentes
FROM (Dinosaurios d INNER JOIN Involucrados i ON d.id_dinosaurio=i.id_dinosaurio) INNER JOIN
    Incidentes ic ON i.id_incidente=ic.id_incidente
GROUP BY d.especie
ORDER BY cuenta_incidentes DESC;

/*
7. Obtener los dinosaurios de género 'Hembra' en la zona de época 'Jurásico' que estuvieron en algún incidente.
*/
SELECT DISTINCT d.id_dinosaurio, d.especie, d.genero
FROM ((Dinosaurios d INNER JOIN VivenEn ve ON d.id_dinosaurio = ve.id_dinosaurio) INNER JOIN ZonasDelParque z ON ve.id_zona = z.id_zona) 
	INNER JOIN Involucrados iv ON d.id_dinosaurio = iv.id_dinosaurio
WHERE d.genero = 'Hembra' AND z.epoca = 'Jurásico';

/*
8. Obtener los nombres de dinosaurios herbívoros que pesen más de 2000 kg, ordenados ascendentemente.
*/ 
SELECT d.especie, d.peso
FROM (Dinosaurios d INNER JOIN VivenEn ve ON d.id_dinosaurio = ve.id_dinosaurio) INNER JOIN Recintos r ON ve.id_recinto = r.id_recinto
WHERE d.peso > 2000 AND r.tipo = 'Herbívoro'
ORDER BY d.peso ASC;

/*
9. Obtener los recintos en estado 'Comprometido' con su área, cantidad de dinosaurios y epoca de la zona.
*/
SELECT r.id_recinto, r.area_m2, COUNT(ve.id_dinosaurio) AS cantidad_dinosaurios, z.epoca
FROM (Recintos r INNER JOIN VivenEn ve ON r.id_recinto = ve.id_recinto) INNER JOIN ZonasDelParque z ON r.id_zona = z.id_zona
WHERE r.estado = 'Comprometido'
GROUP BY r.id_recinto, r.area_m2, z.epoca;

/*
10. Devolver el id y la epoca de la zona en la que residen la mayor cantidad de dinosaurios involucrados en 
algún incidente, con la cantidad de dinosaurios. Si la cantidad es igual para varias zonas, devolver todas.
*/
SELECT z.id_zona, z.epoca,  COUNT(DISTINCT d.id_dinosaurio) AS cantidad_dinosaurios
FROM ((((ZonasDelParque z INNER JOIN Recintos r ON z.id_zona=r.id_zona) INNER JOIN
    VivenEn ve ON r.id_recinto = ve.id_recinto) INNER JOIN 
    Dinosaurios d ON ve.id_dinosaurio = d.id_dinosaurio) INNER JOIN
    Involucrados i ON d.id_dinosaurio = i.id_dinosaurio) INNER JOIN
    Incidentes ic ON i.id_incidente=ic.id_incidente
GROUP BY z.id_zona
HAVING COUNT(DISTINCT d.id_dinosaurio) = (
    SELECT MAX(incidentes_dinosaurios)
    FROM(
        SELECT z2.id_zona, COUNT(DISTINCT d2.id_dinosaurio) AS incidentes_dinosaurios
        FROM ((((ZonasDelParque z2 INNER JOIN Recintos r2 ON z2.id_zona=r2.id_zona) INNER JOIN
        VivenEn ve2 ON r2.id_recinto = ve2.id_recinto) INNER JOIN 
        Dinosaurios d2 ON ve2.id_dinosaurio = d2.id_dinosaurio) INNER JOIN
        Involucrados i2 ON d2.id_dinosaurio = i2.id_dinosaurio) INNER JOIN
        Incidentes ic2 ON i2.id_incidente=ic2.id_incidente
        GROUP BY z2.id_zona
        )
    );