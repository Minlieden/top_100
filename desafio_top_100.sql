--Crear base de datos llamada películas (1 punto)
CREATE DATABASE peliculas;
--Revisar los archivos peliculas.csv y reparto.csv para crear las tablas correspondientes,determinando la relación entre ambas tablas. (2 puntos)
CREATE TABLE pelicula ( id SERIAL, pelicula VARCHAR(70), ano_estreno SMALLINT,  director VARCHAR(50), PRIMARY KEY(id));
CREATE TABLE reparto(peliculas_id SMALLINT, reparto VARCHAR(50), CONSTRAINT fk_pelicula FOREIGN KEY(peliculas_id) REFERENCES pelicula(id));
--Cargar ambos archivos a su tabla correspondiente (1 punto)
COPY pelicula(id,pelicula,ano_estreno,director) FROM '/home/aratan/Desktop/Fullstack/postgres/desafio2/peliculas.csv' DELIMITER ',' CSV HEADER;
ALTER SEQUENCE pelicula_id_seq RESTART;
COPY reparto(peliculas_id,reparto) FROM '/home/aratan/Desktop/Fullstack/postgres/desafio2/reparto.csv' DELIMITER ',' CSV HEADER;

--Listar todos los actores que aparecen en la película "Titanic", indicando el título de la película,año de estreno, director y todo el reparto. (0.5 puntos)
SELECT pelicula, ano_estreno AS "año estreno", director, reparto FROM pelicula LEFT JOIN reparto ON reparto.peliculas_id = pelicula.id WHERE id = 2;

--Listar los titulos de las películas donde actúe Harrison Ford.(0.5 puntos)
SELECT reparto_pelicula.pelicula FROM (SELECT pelicula, reparto FROM pelicula LEFT JOIN reparto ON reparto.peliculas_id = pelicula.id) AS reparto_pelicula WHERE reparto_pelicula.reparto = 'Harrison Ford';

--Listar los 10 directores mas populares, indicando su nombre y cuántas películas aparecen en el top 100.(1 puntos)
SELECT director, count(*) as "numero de peliculas" FROM pelicula GROUP BY director ORDER BY "numero de peliculas" DESC LIMIT 10;

--Indicar cuantos actores distintos hay (1 puntos)
SELECT COUNT(DISTINCT reparto) FROM reparto;

--Indicar las películas estrenadas entre los años 1990 y 1999 (ambos incluidos) ordenadas por título de manera ascendente.(1 punto)
SELECT rango_peliculas.pelicula FROM (SELECT pelicula, ano_estreno AS "año estreno" FROM pelicula WHERE pelicula.ano_estreno BETWEEN 1990 AND 1999) AS rango_peliculas ORDER BY rango_peliculas.pelicula ASC;

--Listar el reparto de las películas lanzadas el año 2001 (1 punto)
SELECT pelicula, ano_estreno, reparto FROM pelicula LEFT JOIN reparto ON reparto.peliculas_id = pelicula.id WHERE pelicula.ano_estreno = 2001

--Listar los actores de la película más nueva (1 punto)

SELECT ultima_pelicula.reparto FROM (SELECT peliculas_nuevas.reparto,peliculas_nuevas.pelicula FROM (SELECT pelicula, ano_estreno, reparto FROM pelicula LEFT JOIN reparto ON reparto.peliculas_id = pelicula.id WHERE pelicula.ano_estreno = 2008 ) AS peliculas_nuevas WHERE peliculas_nuevas.pelicula = 'El caballero oscuro') AS ultima_pelicula;