-- CREATE USER class_backend; 
-- ALTER USER class_backend WITH PASSWORD '123';


-- CREATE TABLESPACE curso_backend_1_2022 LOCATION 'C:\data';


CREATE DATABASE academia WITH  
OWNER = 'class_backend' 
ENCODING = 'UTF8' 
TABLESPACE = curso_backend_1_2022;



-- CREATE DATABASE academia WITH 
-- ENCODING = 'UTF8';


CREATE SCHEMA main; 
CREATE SCHEMA admin;



-- Eliminación de tablas
DROP TABLE IF EXISTS asistencias_sesiones;
DROP TABLE IF EXISTS sesiones_clases;
DROP TABLE IF EXISTS clases;
DROP TABLE IF EXISTS integrantes_grupos;
DROP TABLE IF EXISTS actores;
DROP TABLE IF EXISTS tipo_actores;
DROP TABLE IF EXISTS estado_actores;
DROP TABLE IF EXISTS instituciones_educativas;
DROP TABLE IF EXISTS tipo_documento;
DROP TABLE IF EXISTS modulos;
DROP TABLE IF EXISTS grupos;

-- Eliminación de secuencias
DROP SEQUENCE IF EXISTS actores_seq; 
DROP SEQUENCE IF EXISTS tipo_actores_seq;
DROP SEQUENCE IF EXISTS estado_actores_seq;
DROP SEQUENCE IF EXISTS instituciones_educativas_seq;
DROP SEQUENCE IF EXISTS modulos_seq;
DROP SEQUENCE IF EXISTS grupos_seq;
DROP SEQUENCE IF EXISTS integrantes_grupos_seq;
DROP SEQUENCE IF EXISTS clases_seq;
DROP SEQUENCE IF EXISTS sesiones_clases_seq;
DROP SEQUENCE IF EXISTS asistencias_sesiones_seq;

-- Eliminación de enumeracíon
DROP TYPE IF EXISTS enum_genero;


CREATE SEQUENCE tipo_actores_seq;

-- Creación de tablas e inserción de datos
CREATE TABLE tipo_actores  (
  id INT4 NOT NULL DEFAULT NEXTVAL('tipo_actores_seq'), 
  perfil varchar(100) NULL DEFAULT NULL,
  PRIMARY KEY (id)
);

INSERT INTO tipo_actores (perfil) VALUES ('Estudiante');
INSERT INTO tipo_actores VALUES (DEFAULT, 'Docente');
INSERT INTO tipo_actores VALUES (NEXTVAL ('tipo_actores_seq'), 'Asesor');
INSERT INTO tipo_actores VALUES (NEXTVAL ('tipo_actores_seq'), 'Coordinadora');


CREATE SEQUENCE estado_actores_seq;

CREATE TABLE estado_actores  (
  id int NOT NULL DEFAULT NEXTVAL ('estado_actores_seq'),
  estado varchar(30) NULL DEFAULT NULL,
  PRIMARY KEY (id)
);

INSERT INTO estado_actores VALUES (NEXTVAL ('estado_actores_seq'), 'Activo');
INSERT INTO estado_actores VALUES (NEXTVAL ('estado_actores_seq'), 'Inactivo');
INSERT INTO estado_actores VALUES (NEXTVAL ('estado_actores_seq'), 'Retirado');

CREATE SEQUENCE instituciones_educativas_seq;

CREATE TABLE instituciones_educativas  (
  id int NOT NULL DEFAULT NEXTVAL ('instituciones_educativas_seq'),
  nombre_ie varchar(300) NOT NULL,
  docente_encargado_mt varchar(300) NOT NULL,
  pagina_web varchar(100) NULL DEFAULT NULL,
  direccion varchar(100) NOT NULL,
  foto_ie varchar(100) NULL DEFAULT NULL,
  descripcion_ie text NULL,
  telefono_institucional varchar(20) NULL DEFAULT NULL,
  correo_institucional varchar(100) NULL DEFAULT NULL,
  PRIMARY KEY (id)
);

INSERT INTO instituciones_educativas VALUES (NEXTVAL ('instituciones_educativas_seq'), 'Colegios EDU – S.E. Nuestra Señora de las Nieves – Medellín', 'Carlos', 'https://ielasnieves.edu.co', 'Calle 82 No 39- 69 Barrio Santa Inés', 'https://arquiniel.com/wp-content/uploads/2019/02/destacada_0004_NUESTRA-SEÑORA-1920x1200.jpg', 'El proyecto se ubica al nororiente de la ciudad de Medellín, Colombia, barrio Manrique central.', '571-00-70', 'ie.lasnieves@medellin.gov.co');
INSERT INTO instituciones_educativas VALUES (NEXTVAL ('instituciones_educativas_seq'), 'Institución Educativa Concejo De Medellín (I.E.C.M)', 'Lina Vásquez', 'http://www.concejodemedellin.edu.co/', 'Cra 82 # 47A - 65,rnBarrio Floresta', 'https://pbs.twimg.com/media/Df6SVMQXUAArdor.jpg', '2002: Por resolución No. 16290 de noviembre del 2002 y para dar cumplimiento a la Ley General de Educación se da término a la fusión con las escuelas destinadas por la Secretaria de Educación Departamental: Clodomiro Ramírez, Juan XXIII, y la Escuela Pichincha.', '(4) 4119115 - 411921', 'ie.concejodemellin@medellin.gov.co');


CREATE TABLE tipo_documento  (
  codigo varchar(3) NOT NULL,
  descripcion varchar(100) NULL DEFAULT NULL,
  PRIMARY KEY (codigo)
);

INSERT INTO tipo_documento VALUES ('CC', 'cedula de ciudadania');
INSERT INTO tipo_documento VALUES ('CE', 'cedula de extranjeria');
INSERT INTO tipo_documento VALUES ('NIP', 'numero de identificacion personal');
INSERT INTO tipo_documento VALUES ('NIT', 'numero de identificacion tributaria');
INSERT INTO tipo_documento VALUES ('PAP', 'pasaporte');
INSERT INTO tipo_documento VALUES ('TI', 'tarjeta de identidad');

-- Creación de enumeraciones 
CREATE TYPE enum_genero AS ENUM ('hombre', 'mujer');

CREATE SEQUENCE actores_seq;

CREATE TABLE actores  (
    id INTEGER NOT NULL DEFAULT NEXTVAL('actores_seq'),
    documento VARCHAR(20) NOT NULL,
    tipo_documento VARCHAR(3) NULL DEFAULT NULL,
    nombres VARCHAR(255) NOT NULL,
    apellidos VARCHAR(255) NOT NULL,
    contrasena VARCHAR(80) NULL DEFAULT NULL,
    correo VARCHAR(100) NULL DEFAULT NULL,
    telefono_celular VARCHAR(30) NULL DEFAULT NULL,
    numero_expediente VARCHAR(255) NULL DEFAULT NULL,
    genero enum_genero NULL,
    fecha_nacimiento date NULL DEFAULT NULL,
    estado_actor_id INTEGER NOT NULL DEFAULT 1,
    institucion_id INTEGER NULL DEFAULT NULL,
    tipo_actor_id INTEGER NULL DEFAULT 1,
    fecha_creacion timestamp NULL DEFAULT current_timestamp,
    fecha_actualizacion timestamp NULL DEFAULT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_tipo_actor 
        FOREIGN KEY (tipo_actor_id) REFERENCES tipo_actores (id) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE
);

ALTER TABLE actores ADD CONSTRAINT fk_estado_actor FOREIGN KEY (estado_actor_id) 
    REFERENCES estado_actores (id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE actores ADD CONSTRAINT fk_institucion_estudiante FOREIGN KEY (institucion_id) 
    REFERENCES instituciones_educativas (id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE actores ADD CONSTRAINT fk_tipo_documento FOREIGN KEY (tipo_documento) 
    REFERENCES tipo_documento (codigo) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE actores ADD CONSTRAINT uq_documento UNIQUE(documento);
ALTER TABLE actores ADD CONSTRAINT uq_numero_expediente UNIQUE(numero_expediente);

CREATE INDEX fk_estado_actor ON actores USING btree (estado_actor_id);
CREATE INDEX fk_tipo_actor ON actores USING btree (tipo_actor_id);
CREATE INDEX fk_institucion_estudiante ON actores USING btree (institucion_id);
CREATE INDEX fk_tipo_documento ON actores USING btree (tipo_documento);

INSERT INTO actores 
    VALUES (1, '1152188863', 'CC', 'Oscar', 'Mesa', '34c958e8afa723e3806b37fffa2d64d2ee0ceef9', 'oscarmesa.elpoli@elpoli.edu.co', '3023458976', NULL, 'hombre', '1999-10-09', 1, NULL, 2, '2020-10-09 00:31:57', NULL);
INSERT INTO actores 
    VALUES (2, '11348473389', 'TI', 'Carlos', 'Meneses', '047cf3044503d764a4e8ccf00edb03fb67454986', 'carlosmeneses@gmail.com', '3013984758', 'EXP-9038-2A', 'hombre', '2020-07-09', 1, 1, 1, '2020-10-09 01:12:23', NULL);
INSERT INTO actores 
    VALUES (3, '11437382974', 'TI', 'Maria Victoria', 'Diaz Granados', '9039449fca7dd913d746909bafc3861e616d093c', 'victoriadiaz@gmail.com', '3093283274', 'KW-9803-A3C', 'mujer', '1999-07-01', 1, 2, 1, '2020-10-09 01:12:11', NULL);
INSERT INTO actores 
    VALUES (4, '30948394823', 'PAP', 'David', 'Cadavid', '9f6397db432e1f6c33556b029b9900158804f885', 'davidcadavid@outlook.com', '3884773732', 'KQ-PU987-CE', 'hombre', '2002-11-21', 1, 2, 1, '2020-10-09 01:15:56', NULL);
INSERT INTO actores 
    VALUES (5, '83974732638', 'TI', 'Diana', 'Patiño', 'f3812ab06e685886f615b6a8c38533f11fc0311b', 'dianapatiño@outlook.co', '3012938475', 'KI-EDU900-PAT', 'mujer', '2003-03-29', 1, 1, 1, '2020-10-09 01:25:53', NULL);
INSERT INTO actores 
    VALUES (6, '45679483', 'CC', 'Juan', 'Perez', 'f08791d5049311667aaa321342da7d662a25ac29', 'juan123@gmail.com', '3012938473', NULL, 'hombre', '1989-02-14', 1, NULL, 2, '2020-10-09 02:49:07', NULL);

CREATE SEQUENCE modulos_seq;

CREATE TABLE modulos  (
  id int NOT NULL DEFAULT NEXTVAL ('modulos_seq'),
  modulo VARCHAR(255) NULL DEFAULT NULL,
  mod VARCHAR(10) NULL DEFAULT NULL,
  PRIMARY KEY (id)
);

ALTER TABLE modulos ADD CONSTRAINT uq_mod UNIQUE(mod);

INSERT INTO modulos VALUES (NEXTVAL ('modulos_seq'), 'Cocnstrucción de Elementos de Software 1', 'CES1');
INSERT INTO modulos VALUES (NEXTVAL ('modulos_seq'), 'Taller de Base de Datos', 'BD');
INSERT INTO modulos VALUES (NEXTVAL ('modulos_seq'), 'Interpretación de Requisitos', 'IR');
INSERT INTO modulos VALUES (NEXTVAL ('modulos_seq'), 'Construcción de Elementos de Software Web 1', 'CESW1');


CREATE SEQUENCE grupos_seq;

CREATE TABLE grupos  (
  id int NOT NULL DEFAULT NEXTVAL('grupos_seq'),
  institucion_id int NOT NULL,
  grado int NOT NULL,
  letra char(1) NULL DEFAULT NULL,
  a_formacion int NULL DEFAULT NULL ,
  descripcion varchar(30) NULL DEFAULT NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_ie_grupo FOREIGN KEY (institucion_id) 
    REFERENCES instituciones_educativas (id) 
    ON DELETE RESTRICT 
    ON UPDATE CASCADE
);

ALTER TABLE grupos ADD CONSTRAINT uq_ie_grado UNIQUE(institucion_id, grado, a_formacion);

COMMENT ON CONSTRAINT uq_ie_grado ON grupos IS 'Un grado, de una institucion educativa solo puede estar presente una sola vez en un año';

INSERT INTO grupos VALUES (NEXTVAL('grupos_seq'), 1, 11, '1', 2020, '11-1 del año 2020');
INSERT INTO grupos VALUES (NEXTVAL('grupos_seq'), 2, 11, 'B', 2020, '11-B del año 2020');

CREATE SEQUENCE integrantes_grupos_seq;

CREATE TABLE integrantes_grupos  (
  id int NOT NULL DEFAULT NEXTVAL('integrantes_grupos_seq'),
  estudiante_id int NOT NULL,
  grupo_id int NOT NULL,
  observaciones text NULL, 
  PRIMARY KEY (id),
  CONSTRAINT fk_estudiante_integrante FOREIGN KEY (estudiante_id) 
    REFERENCES actores (id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_grupo_integrantes FOREIGN KEY (grupo_id) 
    REFERENCES grupos (id) ON DELETE RESTRICT ON UPDATE CASCADE
);

ALTER TABLE integrantes_grupos ADD CONSTRAINT uq_grupo_estudiante UNIQUE(estudiante_id, grupo_id);

CREATE INDEX fk_grupo_integrantes ON integrantes_grupos(grupo_id);

ALTER SEQUENCE integrantes_grupos_seq RESTART WITH 2;

INSERT INTO integrantes_grupos VALUES (NEXTVAL('integrantes_grupos_seq'), 2, 1, 'Estudiante inscrito');
INSERT INTO integrantes_grupos VALUES (NEXTVAL('integrantes_grupos_seq'), 5, 1, 'Estudiante inscrito');
INSERT INTO integrantes_grupos VALUES (NEXTVAL('integrantes_grupos_seq'), 3, 2, 'Estudiante inscrito');
INSERT INTO integrantes_grupos VALUES (NEXTVAL('integrantes_grupos_seq'), 4, 2, 'Estudiante inscrito');

CREATE SEQUENCE clases_seq;

CREATE TABLE clases  (
  id int NOT NULL DEFAULT NEXTVAL ('clases_seq'),
  grupo_id int NULL DEFAULT NULL,
  modulo_id int NULL DEFAULT NULL,
  docente_id int NULL DEFAULT NULL,
  fecha_creacion timestamp NULL DEFAULT current_timestamp,
  fecha_actualizacion timestamp NULL DEFAULT NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_clases_docente FOREIGN KEY (docente_id) 
    REFERENCES actores (id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_clases_grupo FOREIGN KEY (grupo_id) 
    REFERENCES grupos (id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_clases_modulo FOREIGN KEY (modulo_id) 
    REFERENCES modulos (id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE INDEX fk_clases_modulo ON clases(modulo_id);
CREATE INDEX fk_clases_docente ON clases(docente_id);

ALTER TABLE clases ADD CONSTRAINT uq_clase UNIQUE(grupo_id, modulo_id, docente_id);

INSERT INTO clases VALUES (NEXTVAL ('clases_seq'), 1, 3, 1, '2020-10-09 01:52:17', NULL);
INSERT INTO clases VALUES (NEXTVAL ('clases_seq'), 1, 1, 1, '2020-10-09 01:54:10', NULL);
INSERT INTO clases VALUES (NEXTVAL ('clases_seq'), 2, 2, 6, '2020-10-09 02:49:46', NULL);
INSERT INTO clases VALUES (NEXTVAL ('clases_seq'), 2, 4, 6, '2020-10-09 02:49:53', NULL);

CREATE SEQUENCE sesiones_clases_seq;

CREATE TABLE sesiones_clases  (
  id int NOT NULL DEFAULT NEXTVAL ('sesiones_clases_seq'),
  clase_id int NOT NULL,
  fecha_sesion date NOT NULL,
  observacion text NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_clase_sesion FOREIGN KEY (clase_id) REFERENCES clases (id) 
    ON DELETE RESTRICT ON UPDATE CASCADE
);

ALTER TABLE sesiones_clases ADD CONSTRAINT uq_sesion_clase_fecha UNIQUE(clase_id, fecha_sesion);
COMMENT ON CONSTRAINT uq_sesion_clase_fecha ON sesiones_clases IS 'La sesión de una clase solo puede ser una por fecha';

INSERT INTO sesiones_clases VALUES (NEXTVAL ('sesiones_clases_seq'), 1, '2020-07-14', 'Clase de IR');
INSERT INTO sesiones_clases VALUES (NEXTVAL ('sesiones_clases_seq'), 2, '2020-09-08', 'Clase de CES1');
INSERT INTO sesiones_clases VALUES (NEXTVAL ('sesiones_clases_seq'), 3, '2020-09-17', 'Clase de BD');
INSERT INTO sesiones_clases VALUES (NEXTVAL ('sesiones_clases_seq'), 4, '2020-08-21', 'Clase de CESW1');


CREATE SEQUENCE asistencias_sesiones_seq;

CREATE TABLE asistencias_sesiones  (
  id int NOT NULL DEFAULT NEXTVAL ('asistencias_sesiones_seq'),
  sesion_clase_id int NULL DEFAULT NULL,
  integrante_grupo_id int NULL DEFAULT NULL,
  asiste int NULL DEFAULT 0 ,
  observaciones text NULL,
  fecha_creacion timestamp NULL DEFAULT current_timestamp,
  PRIMARY KEY (id),
  CONSTRAINT fk_integrante_grupo FOREIGN KEY (integrante_grupo_id) 
    REFERENCES integrantes_grupos (id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_sesion_clase FOREIGN KEY (sesion_clase_id) 
    REFERENCES sesiones_clases (id) ON DELETE RESTRICT ON UPDATE CASCADE
);

ALTER TABLE asistencias_sesiones ADD CONSTRAINT uq_sesion_integrante UNIQUE(sesion_clase_id, integrante_grupo_id);
COMMENT ON CONSTRAINT uq_sesion_integrante ON asistencias_sesiones IS 'Un integrante solo puede asistir una vez por sesion';

CREATE INDEX fk_integrante_grupo ON clases(docente_id);

INSERT INTO asistencias_sesiones VALUES (NEXTVAL('asistencias_sesiones_seq'), 1, 2, 1, NULL, '2020-10-09 02:22:59');
INSERT INTO asistencias_sesiones VALUES (NEXTVAL('asistencias_sesiones_seq'), 1, 3, 1, 'Entro tarde a clase', '2020-10-09 02:23:28');
INSERT INTO asistencias_sesiones VALUES (NEXTVAL('asistencias_sesiones_seq'), 2, 2, 0, 'No asistio a clase', '2020-10-09 02:39:13');
INSERT INTO asistencias_sesiones VALUES (NEXTVAL('asistencias_sesiones_seq'), 2, 3, 1, NULL, '2020-10-09 02:39:21');
INSERT INTO asistencias_sesiones VALUES (NEXTVAL('asistencias_sesiones_seq'), 3, 4, 1, NULL, '2020-10-09 02:56:25');
INSERT INTO asistencias_sesiones VALUES (NEXTVAL('asistencias_sesiones_seq'), 3, 5, 1, NULL, '2020-10-09 02:56:33');
INSERT INTO asistencias_sesiones VALUES (NEXTVAL('asistencias_sesiones_seq'), 4, 4, 0, 'Estaba enfermo', '2020-10-09 02:56:49');
INSERT INTO asistencias_sesiones VALUES (NEXTVAL('asistencias_sesiones_seq'), 4, 5, 1, NULL, '2020-10-09 02:56:56');