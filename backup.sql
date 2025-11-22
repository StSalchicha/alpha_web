--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: mouse_flow squema; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "mouse_flow squema";


ALTER SCHEMA "mouse_flow squema" OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: answers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.answers (
    id integer NOT NULL,
    question_id integer NOT NULL,
    text text NOT NULL,
    is_correct boolean DEFAULT false NOT NULL
);


ALTER TABLE public.answers OWNER TO postgres;

--
-- Name: answers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.answers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.answers_id_seq OWNER TO postgres;

--
-- Name: answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.answers_id_seq OWNED BY public.answers.id;


--
-- Name: cuestionario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cuestionario (
    id_cuestionario integer NOT NULL,
    titulo character varying(100) NOT NULL
);


ALTER TABLE public.cuestionario OWNER TO postgres;

--
-- Name: cuestionario_id_cuestionario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cuestionario_id_cuestionario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cuestionario_id_cuestionario_seq OWNER TO postgres;

--
-- Name: cuestionario_id_cuestionario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cuestionario_id_cuestionario_seq OWNED BY public.cuestionario.id_cuestionario;


--
-- Name: glosario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.glosario (
    id_termino integer NOT NULL,
    termino character varying(100) NOT NULL,
    definicion text NOT NULL
);


ALTER TABLE public.glosario OWNER TO postgres;

--
-- Name: glosario_id_termino_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.glosario_id_termino_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.glosario_id_termino_seq OWNER TO postgres;

--
-- Name: glosario_id_termino_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.glosario_id_termino_seq OWNED BY public.glosario.id_termino;


--
-- Name: leccion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.leccion (
    id_leccion integer NOT NULL,
    temas character varying(100) NOT NULL,
    introduccion character varying(10000),
    id_cuestionario integer
);


ALTER TABLE public.leccion OWNER TO postgres;

--
-- Name: leccion_id_leccion_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.leccion_id_leccion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.leccion_id_leccion_seq OWNER TO postgres;

--
-- Name: leccion_id_leccion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.leccion_id_leccion_seq OWNED BY public.leccion.id_leccion;


--
-- Name: lecturas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lecturas (
    id_lectura integer NOT NULL,
    titulo character varying(100) NOT NULL,
    contenido text NOT NULL
);


ALTER TABLE public.lecturas OWNER TO postgres;

--
-- Name: lecturas_id_lectura_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lecturas_id_lectura_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lecturas_id_lectura_seq OWNER TO postgres;

--
-- Name: lecturas_id_lectura_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lecturas_id_lectura_seq OWNED BY public.lecturas.id_lectura;


--
-- Name: lessons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lessons (
    id integer NOT NULL,
    title text NOT NULL,
    content_html text NOT NULL,
    is_active boolean DEFAULT true NOT NULL
);


ALTER TABLE public.lessons OWNER TO postgres;

--
-- Name: lessons_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lessons_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lessons_id_seq OWNER TO postgres;

--
-- Name: lessons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lessons_id_seq OWNED BY public.lessons.id;


--
-- Name: logro; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.logro (
    id_logro integer NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion text
);


ALTER TABLE public.logro OWNER TO postgres;

--
-- Name: logro_id_logro_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.logro_id_logro_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.logro_id_logro_seq OWNER TO postgres;

--
-- Name: logro_id_logro_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.logro_id_logro_seq OWNED BY public.logro.id_logro;


--
-- Name: pregunta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pregunta (
    id_pregunta integer NOT NULL,
    texto text NOT NULL,
    id_cuestionario integer NOT NULL
);


ALTER TABLE public.pregunta OWNER TO postgres;

--
-- Name: pregunta_id_pregunta_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pregunta_id_pregunta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pregunta_id_pregunta_seq OWNER TO postgres;

--
-- Name: pregunta_id_pregunta_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pregunta_id_pregunta_seq OWNED BY public.pregunta.id_pregunta;


--
-- Name: progreso; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.progreso (
    id_progreso integer NOT NULL,
    id_usuario integer,
    id_leccion integer,
    completado boolean DEFAULT false,
    fecha_completado date
);


ALTER TABLE public.progreso OWNER TO postgres;

--
-- Name: progreso_id_progreso_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.progreso_id_progreso_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.progreso_id_progreso_seq OWNER TO postgres;

--
-- Name: progreso_id_progreso_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.progreso_id_progreso_seq OWNED BY public.progreso.id_progreso;


--
-- Name: questions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.questions (
    id integer NOT NULL,
    quiz_id integer NOT NULL,
    text text NOT NULL
);


ALTER TABLE public.questions OWNER TO postgres;

--
-- Name: questions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.questions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.questions_id_seq OWNER TO postgres;

--
-- Name: questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.questions_id_seq OWNED BY public.questions.id;


--
-- Name: quizzes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.quizzes (
    id integer NOT NULL,
    lesson_id integer NOT NULL,
    title text NOT NULL
);


ALTER TABLE public.quizzes OWNER TO postgres;

--
-- Name: quizzes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.quizzes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.quizzes_id_seq OWNER TO postgres;

--
-- Name: quizzes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.quizzes_id_seq OWNED BY public.quizzes.id;


--
-- Name: respuesta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.respuesta (
    id_respuesta integer NOT NULL,
    texto text NOT NULL,
    es_correcta boolean NOT NULL,
    id_pregunta integer NOT NULL
);


ALTER TABLE public.respuesta OWNER TO postgres;

--
-- Name: respuesta_id_respuesta_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.respuesta_id_respuesta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.respuesta_id_respuesta_seq OWNER TO postgres;

--
-- Name: respuesta_id_respuesta_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.respuesta_id_respuesta_seq OWNED BY public.respuesta.id_respuesta;


--
-- Name: resultado_cuestionario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resultado_cuestionario (
    id_resultado integer NOT NULL,
    id_usuario integer,
    id_cuestionario integer,
    puntaje integer,
    fecha_evaluacion date DEFAULT CURRENT_DATE
);


ALTER TABLE public.resultado_cuestionario OWNER TO postgres;

--
-- Name: resultado_cuestionario_id_resultado_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.resultado_cuestionario_id_resultado_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.resultado_cuestionario_id_resultado_seq OWNER TO postgres;

--
-- Name: resultado_cuestionario_id_resultado_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.resultado_cuestionario_id_resultado_seq OWNED BY public.resultado_cuestionario.id_resultado;


--
-- Name: results; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.results (
    id integer NOT NULL,
    user_id integer NOT NULL,
    quiz_id integer NOT NULL,
    correct_count integer NOT NULL,
    total integer NOT NULL,
    duration_sec integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.results OWNER TO postgres;

--
-- Name: results_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.results_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.results_id_seq OWNER TO postgres;

--
-- Name: results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.results_id_seq OWNED BY public.results.id;


--
-- Name: simbologia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.simbologia (
    id_simbolo integer NOT NULL,
    simbolo character varying(50) NOT NULL,
    nombre character varying(50),
    significado text NOT NULL
);


ALTER TABLE public.simbologia OWNER TO postgres;

--
-- Name: simbologia_id_simbolo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.simbologia_id_simbolo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.simbologia_id_simbolo_seq OWNER TO postgres;

--
-- Name: simbologia_id_simbolo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.simbologia_id_simbolo_seq OWNED BY public.simbologia.id_simbolo;


--
-- Name: trophies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trophies (
    id integer NOT NULL,
    code text NOT NULL,
    title text NOT NULL,
    description text
);


ALTER TABLE public.trophies OWNER TO postgres;

--
-- Name: trophies_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.trophies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.trophies_id_seq OWNER TO postgres;

--
-- Name: trophies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.trophies_id_seq OWNED BY public.trophies.id;


--
-- Name: user_trophies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_trophies (
    user_id integer NOT NULL,
    trophy_id integer NOT NULL,
    awarded_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.user_trophies OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email text NOT NULL,
    password_hash text NOT NULL,
    name text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: usuario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuario (
    id_usuario integer NOT NULL,
    nombre character varying(50) NOT NULL,
    correo character varying(100) NOT NULL,
    contra character varying(100) NOT NULL
);


ALTER TABLE public.usuario OWNER TO postgres;

--
-- Name: usuario_id_usuario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuario_id_usuario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuario_id_usuario_seq OWNER TO postgres;

--
-- Name: usuario_id_usuario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuario_id_usuario_seq OWNED BY public.usuario.id_usuario;


--
-- Name: answers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answers ALTER COLUMN id SET DEFAULT nextval('public.answers_id_seq'::regclass);


--
-- Name: cuestionario id_cuestionario; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cuestionario ALTER COLUMN id_cuestionario SET DEFAULT nextval('public.cuestionario_id_cuestionario_seq'::regclass);


--
-- Name: glosario id_termino; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.glosario ALTER COLUMN id_termino SET DEFAULT nextval('public.glosario_id_termino_seq'::regclass);


--
-- Name: leccion id_leccion; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leccion ALTER COLUMN id_leccion SET DEFAULT nextval('public.leccion_id_leccion_seq'::regclass);


--
-- Name: lecturas id_lectura; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lecturas ALTER COLUMN id_lectura SET DEFAULT nextval('public.lecturas_id_lectura_seq'::regclass);


--
-- Name: lessons id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lessons ALTER COLUMN id SET DEFAULT nextval('public.lessons_id_seq'::regclass);


--
-- Name: logro id_logro; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logro ALTER COLUMN id_logro SET DEFAULT nextval('public.logro_id_logro_seq'::regclass);


--
-- Name: pregunta id_pregunta; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pregunta ALTER COLUMN id_pregunta SET DEFAULT nextval('public.pregunta_id_pregunta_seq'::regclass);


--
-- Name: progreso id_progreso; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.progreso ALTER COLUMN id_progreso SET DEFAULT nextval('public.progreso_id_progreso_seq'::regclass);


--
-- Name: questions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions ALTER COLUMN id SET DEFAULT nextval('public.questions_id_seq'::regclass);


--
-- Name: quizzes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quizzes ALTER COLUMN id SET DEFAULT nextval('public.quizzes_id_seq'::regclass);


--
-- Name: respuesta id_respuesta; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.respuesta ALTER COLUMN id_respuesta SET DEFAULT nextval('public.respuesta_id_respuesta_seq'::regclass);


--
-- Name: resultado_cuestionario id_resultado; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resultado_cuestionario ALTER COLUMN id_resultado SET DEFAULT nextval('public.resultado_cuestionario_id_resultado_seq'::regclass);


--
-- Name: results id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.results ALTER COLUMN id SET DEFAULT nextval('public.results_id_seq'::regclass);


--
-- Name: simbologia id_simbolo; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.simbologia ALTER COLUMN id_simbolo SET DEFAULT nextval('public.simbologia_id_simbolo_seq'::regclass);


--
-- Name: trophies id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trophies ALTER COLUMN id SET DEFAULT nextval('public.trophies_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: usuario id_usuario; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario ALTER COLUMN id_usuario SET DEFAULT nextval('public.usuario_id_usuario_seq'::regclass);


--
-- Data for Name: answers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.answers (id, question_id, text, is_correct) FROM stdin;
1	1	Un valor inmutable	f
2	1	Un contenedor de datos	t
3	1	Un bucle	f
4	1	Un error	f
5	2	=	f
6	2	==	t
7	2	===	f
8	2	!=	f
9	3	for	f
10	3	while	f
11	3	if	t
12	3	function	f
\.


--
-- Data for Name: cuestionario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cuestionario (id_cuestionario, titulo) FROM stdin;
1	Cuestionario 1: Lección 1
2	Cuestionario 2: Lección 2
3	Cuestionario 3: Lección 3
\.


--
-- Data for Name: glosario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.glosario (id_termino, termino, definicion) FROM stdin;
1	Pseudocódigo	Forma simplificada de escribir algoritmos, sin usar la sintaxis exacta de un lenguaje.
2	Algoritmo	Conjunto de pasos ordenados para resolver un problema.
3	Variable	Espacio donde se guarda información (como un número o texto).
4	entero	Tipo de variable que almacena números sin decimales.
5	cadena	Tipo de variable que almacena texto.
6	mostrar()	Instrucción que imprime o enseña información al usuario.
7	leer()	Instrucción que permite ingresar datos desde el teclado.
8	retornar	Devuelve un valor desde una función al lugar donde fue llamada.
9	funcion	Bloque de código reutilizable que puede recibir datos y devolver un resultado.
10	si (...) entonces	Estructura condicional que ejecuta algo si se cumple una condición.
11	sino	Parte opcional de una condición que se ejecuta si no se cumple lo anterior.
12	para	Bucle que repite acciones un número definido de veces.
13	mientras	Bucle que repite mientras se cumpla una condición.
14	archivo	Objeto que permite guardar o leer información de un archivo externo.
15	abrir()	Abre un archivo para leer o escribir.
16	cerrar()	Cierra un archivo abierto.
17	escribir()	Guarda información dentro de un archivo.
18	condición de parada	Regla que detiene una función recursiva para que no se llame infinitamente.
19	recursividad	Técnica donde una función se llama a sí misma.
20	comentario	Texto que explica el código pero que no se ejecuta; empieza con //.
21	sintaxis	Conjunto de reglas para escribir correctamente el pseudocódigo o código.
22	estructura	Forma o formato que debe tener el código (por ejemplo, una función, bucle, etc.).
\.


--
-- Data for Name: leccion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.leccion (id_leccion, temas, introduccion, id_cuestionario) FROM stdin;
1	Lección 1	Lección 1: Sintaxis Básica\n\nAntes de poder construir algoritmos complejos, es fundamental entender cómo escribir\ncorrectamente en pseudocódigo. En esta lección aprenderás las reglas básicas de sintaxis, muy\nsimilares a las de lenguajes como C, que nos ayudarán a organizar nuestras ideas de forma clara y \nordenada.\n\nConocerás cómo declarar variables indicando su tipo (como entero, cadena, etc.), cómo asignarles \nvalores, y cómo usar los comentarios para explicar lo que hace el código. También aprenderás que \nlos nombres de variables distinguen entre mayúsculas y minúsculas, por lo que usar edad no es lo \nmismo que usar Edad.\n\n\nAdemás, practicarás identificando estructuras correctas a través de ejercicios como:\n\n-Ejercicio 1, que refuerza las reglas clave de escritura.\n\n-Ejercicio 2, donde deberás completar fragmentos de código reales.\n\n-Ejercicio 3, en el que seleccionarás la imagen que mejor representa la declaración y asignación de \nvariables.\n\nEsta lección te dará las bases que necesitas para comenzar a escribir tus propios algoritmos de \nforma correcta y comprensible.	1
2	Lección 2	Lección 2: Estructura de Programa -- Main, Return, Condicionales y Bucles\n\nEn esta lección nos adentraremos en la estructura esencial que da vida a cualquier algoritmo en \npseudocódigo, comenzando con el punto de entrada del programa: la función inicio() (equivalente \na main en lenguajes como C). Aquí aprenderás cómo organizar correctamente tu código dentro de \nbloques delimitados por llaves {} y cómo usar la instrucción retornar para indicar el final de una \nejecución o devolver un valor.\n\n\nUna vez entendido el flujo principal del programa, trabajaremos con las estructuras condicionales, \nque nos permiten tomar decisiones en base a condiciones lógicas. Aprenderás a usar si, entonces y \nsino para que el programa responda de manera distinta según los valores de entrada. Esto se \nejemplifica en el Ejercicio 1, donde deberás completar un algoritmo que determina si una persona \nes mayor de edad.\n\nFinalmente, conocerás los bucles, estructuras que repiten acciones automáticamente mientras se \ncumpla una condición. Son esenciales para automatizar tareas repetitivas. En el Ejercicio 2, \npondrás a prueba tu comprensión seleccionando la imagen que represente correctamente un \nbucle que muestra los números del 1 al 5.\n\nCon esta lección, desarrollarás la capacidad de construir algoritmos con un flujo claro, capaces de \ntomar decisiones y repetir acciones eficientemente, sentando las bases para resolver problemas \nmás complejos en pseudocódigo.	2
3	Lección 3	Lección 3: Funciones, Manejo de Archivos y Recursividad\n\nEn esta lección exploraremos tres conceptos fundamentales que llevan el pseudocódigo a un nivel \nmás avanzado y práctico: funciones, archivos y recursividad.\n\nComenzamos con las funciones, una herramienta clave para dividir el código en partes \nreutilizables. Aprenderás cómo se definen con un nombre, parámetros de entrada y un bloque de \ninstrucciones. Las funciones ayudan a organizar mejor los programas, reducir repeticiones y \nfacilitar la resolución de problemas complejos. En el Ejercicio 1 (cuestionario) reforzarás este \nconocimiento reconociendo sus características principales.\n\nLuego, abordaremos el manejo de archivos, lo que permite a tus algoritmos guardar o leer \ninformación externa, como textos, listas o resultados. Esta habilidad es útil cuando necesitas que \nlos datos persistan más allá de la ejecución del programa. En el Ejercicio 1 (completar código), \npracticarás cómo abrir un archivo, escribir contenido en él y cerrarlo correctamente.\n\nFinalmente, conocerás la recursividad, una técnica poderosa donde una función se llama a sí \nmisma para resolver un problema en partes más pequeñas. Este concepto, aunque avanzado, es \nmuy útil en situaciones como el cálculo de factoriales, recorridos en árboles o resolución de \nacertijos lógicos. En el Ejercicio 2 (cuestionario) analizarás el ejemplo de una función recursiva y \ncómo se asegura de no caer en un ciclo infinito.\n\nCon esta lección, serás capaz de construir programas más organizados, eficientes y capaces de \ntrabajar con datos dinámicos, acercándote al pensamiento algorítmico de un desarrollador real.	3
\.


--
-- Data for Name: lecturas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lecturas (id_lectura, titulo, contenido) FROM stdin;
1	Lectura 1: Introducción al Pseudocódigo y sus Fundamentos	El pseudocódigo es una forma de \nescribir algoritmos que se parece a un lenguaje de programación, pero sin seguir reglas tan \nestrictas. Se usa para explicar ideas lógicas sin necesidad de escribir código exacto. En nuestro \ncaso, el pseudocódigo está inspirado en el lenguaje C, por lo que verás estructuras como inicio(),\n entero, si, para, y retornar.\n\n¿Por qué aprenden pseudocódigo primero? Porque te permite pensar como programador: dividir \nproblemas, ordenar instrucciones, y entender cómo fluye un programa. Es como practicar el dibujo \ncon bocetos antes de pasar a la tinta final.\n\nEjemplo:\ninicio() {\n    entero edad;\n    edad = 18;\n    si (edad >= 18) entonces {\n        mostrar("Eres mayor de edad");\n    }\n}\nPartes:\n-Entrada\n-Condición\n-Salida
2	Lectura 2: Proceso de Resolución de Problemas con Pseudocódigo	Antes de programar, hay que \npensar. Resolver un problema con pseudocódigo sigue estos pasos:\n1. Entender el problema (¿Qué se pide?).\n2. Identificar entradas y salidas.\n3. Diseñar el algoritmo paso a paso.\n4. Escribirlo en pseudocódigo.\n\nEl pensamiento algorítmico consiste en dividir un problema grande en partes pequeñas y \nmanejables, resolver cada una por separado y luego unirlas.\n\nEn el siguiente ejemplo se pide calcular el doble de un numero:\ninicio() {  \n    entero n;  \n    leer(n);  \n    mostrar(n * 2);  \n}
3	Lectura 3: Comparación entre Pseudocódigo y Lenguaje C	El pseudocódigo que usamos en esta \napp se basa en el lenguaje C, pero es más amigable para principiantes. Aquí hay una tabla \ncomparativa:\n\nCONCEPTO|PSEUDOCÓDIGO|LENGUAJE C\nDeclarar entero|entero edad;|int edad;\nMostrar texto|mostrar("Hola");|printf("Hola");\nInstrucción IF|si (...) entonces|if (...) {\nComentarios|// esto|// esto\nFunción principal|inicio()|int main()
\.


--
-- Data for Name: lessons; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lessons (id, title, content_html, is_active) FROM stdin;
1	Sintaxis Básica	<h4>Introducción</h4><p>Elementos básicos: variables, tipos, operadores.</p>	t
2	Estructuras de Control	<h4>Control de flujo</h4><p>if/else, for, while, do-while, return.</p>	t
3	Funciones Avanzadas	<h4>Funciones y Recursividad</h4><p>Funciones, recursión, manejo de archivos.</p>	t
\.


--
-- Data for Name: logro; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.logro (id_logro, nombre, descripcion) FROM stdin;
1	Primer logro	Has completado tu primera lección.
2	Maestro del cuestionario	Obtuviste 100% en un cuestionario.
3	Aprendiz	Completa 3 lecciones.
\.


--
-- Data for Name: pregunta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pregunta (id_pregunta, texto, id_cuestionario) FROM stdin;
1	Ejercicio 1: Cuestionario\nEn pseudocódigo orientado a C, una instrucción termina en punto y coma (;). Las variables deben \ndeclararse con su tipo antes de usarse. Los comentarios permiten explicar el código y se escriben \ncon doble diagonal (//). Los nombres de variables distinguen entre mayúsculas y minúsculas, por lo \nque edad y Edad son diferentes.	1
2	Ejercicio 2: Completar código\n\nInstrucción: Completa el siguiente pseudocódigo con las partes faltantes.\n\n// Declaracion de variables\n_________ nombre;\n_________ edad;\n//Asignacion de valores\nnombre = "Carlos";\nedad = ____;\n//Mostrar resultados\nmostrar(_____);	1
3	Ejercicio 3: Seleccionar la imagen correcta\nInstrucción: Selecciona la imagen que representa correctamente una declaración de variables y \nasignación de valor.	1
4	Ejercicio 1: main\nEn pseudocódigo estilo C, el punto de inicio de un programa es la función principal, usualmente \nllamada main. Se escribe como inicio() { ... } y puede devolver un valor con retornar. Aunque en \npseudocódigo no siempre se usa un tipo de retorno explícito, entender return es esencial para la \nlógica del programa.	2
5	Ejercicio 2: Completar código\nInstrucción: Completa el siguiente fragmento de pseudocódigo que evalúa si una persona es mayor \nde edad.\n\nentero edad;\nedad = 17;\n\nsi (edad____18) entonces {\nmostrar("Eres mayor de edad"):\n}sino{\nmostrar("Eres menor de edad");\n}	2
6	Ejercicio 3: Seleccionar la opción correcta\nInstrucción: ¿Cuál imagen representa correctamente un bucle que muestra los números del 1 al \n5?	2
7	Ejercicio 1: Cuestionario\nLas funciones permiten reutilizar código. Una función puede recibir parámetros y devolver un \nvalor. Se definen con un nombre, parámetros entre paréntesis y un bloque de instrucciones.	3
8	Ejercicio 2: Completar código\nInstrucción: Completa el pseudocódigo que abre un archivo y escribe un mensaje.\n\narchivo f;\nf = abrir("salida.txt" , " "____");\nescribir(f, "Hola mundo");\ncerrar(f);	3
9	Ejercicio 3: Cuestionario\nUna función recursiva es aquella que se llama a sí misma. Se usa para resolver problemas que \npueden dividirse en subproblemas similares. Para evitar llamadas infinitas, se necesita una \ncondición de parada. Un ejemplo clásico es el cálculo del factorial:\n\nfuncion factorial(entero n) {\nsi (n==0) retornar 1;\nretornar n * factorial(n - 1);\n}	3
\.


--
-- Data for Name: progreso; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.progreso (id_progreso, id_usuario, id_leccion, completado, fecha_completado) FROM stdin;
1	1	1	t	2025-07-15
2	2	2	t	2025-07-12
3	2	2	f	\N
\.


--
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.questions (id, quiz_id, text) FROM stdin;
1	1	¿Qué es una variable?
2	1	Operador de igualdad común
3	1	¿Qué ejecuta código condicionalmente?
\.


--
-- Data for Name: quizzes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.quizzes (id, lesson_id, title) FROM stdin;
1	1	Quiz Unidad 1
2	2	Quiz Unidad 2
3	3	Quiz Unidad 3
\.


--
-- Data for Name: respuesta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.respuesta (id_respuesta, texto, es_correcta, id_pregunta) FROM stdin;
1	entero edad;	t	1
2	Edad = 5;	f	1
3	// Esto es un comentario	f	1
4	edad entero;	f	1
5	entero, cadena, mostrar(nombre), 20	f	2
6	cadena, entero, 20, nombre	t	2
7	mostrar, cadena, nombre, 20	f	2
8	entero, edad, 20, edad	f	2
9	cadena nombre;\nnombre = Carlos;	f	3
10	nombre: cadena;\nnombre = "Carlos"	f	3
11	cadena nombre;\nnombre = "Carlos";	t	3
12	funcion principal()	f	4
13	inicio()	t	4
14	comienzo()	f	4
15	start()	f	4
16	>=	t	5
17	==	f	5
18	<	f	5
19	>	f	5
20	para (i = 1; i <= 5; i = i + 1) {\nmostrar(i);\n}	t	6
21	por i desde 5 hasta 1 paso -1{\nmostrar(i);\n}	f	6
22	mientras (i <= 5) {\nmostrar(i);\ni++;\n}	f	6
23	inicio() { a + b; }	f	7
24	funcion resta(a, b) retornar a - b;	f	7
25	funcion mostrar() { mostrar("Hola"); }	t	7
26	funcion suma(a + b)	f	7
27	lectura	f	8
28	escritura	f	8
29	w	t	8
30	leer	f	8
31	Contiene un bucle dentro.	t	9
32	Se llama a sí misma	f	9
33	Solo se ejecuta una vez	f	9
34	No necesita retornar valores	f	9
\.


--
-- Data for Name: resultado_cuestionario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resultado_cuestionario (id_resultado, id_usuario, id_cuestionario, puntaje, fecha_evaluacion) FROM stdin;
1	1	1	90	2025-07-23
2	2	2	100	2025-07-23
3	1	2	80	2025-07-23
\.


--
-- Data for Name: results; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.results (id, user_id, quiz_id, correct_count, total, duration_sec, created_at) FROM stdin;
1	3	1	1	3	0	2025-11-12 12:45:29.809084
2	3	1	1	3	0	2025-11-12 12:46:13.534289
3	3	1	2	3	0	2025-11-12 12:46:39.135811
4	3	1	3	3	0	2025-11-12 12:46:48.56947
5	3	1	1	3	0	2025-11-12 12:56:27.80187
6	3	1	2	3	0	2025-11-12 12:56:30.472746
7	3	1	2	3	0	2025-11-12 12:56:31.690436
8	3	1	2	3	0	2025-11-12 13:18:56.790441
9	3	1	0	3	0	2025-11-12 13:19:08.150331
10	3	1	3	3	0	2025-11-12 13:22:34.835059
\.


--
-- Data for Name: simbologia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.simbologia (id_simbolo, simbolo, nombre, significado) FROM stdin;
1	()	Llaves	Agrupan bloques de instrucciones (por ejemplo: dentro de funciones, condicionales o bucles).
2	()	Paréntesis	Encierran condiciones, parámetros de funciones o argumentos de funciones.
3	;	Punto y coma	Indica el fin de una instrucción o línea de código.
4	==	Igualdad lógica	Compara si dos valores son iguales.
5	=	Asignación	Asigna un valor a una variable.
6	!=	Diferente	Compara si dos valores son distintos.
7	>	Mayor que	Compara si un valor es mayor que otro.
8	<	Menor que	Compara si un valor es menor que otro.
9	>=	Mayor o igual que	Compara si un valor es mayor o igual a otro.
10	<=	Menor o igual que	Compara si un valor es menor o igual a otro.
11	+	Suma	Suma dos valores numéricos.
12	-	Resta	Resta un valor de otro.
13	*	Multiplicación	Multiplica dos valores.
14	/	División	Divide un valor entre otro.
15	//	Comentario	Indica una línea de comentario que no se ejecuta.
16	""	Comillas	Delimitan cadenas de texto (por ejemplo: "Hola").
17	,	Coma	Separa parámetros dentro de una función.
\.


--
-- Data for Name: trophies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.trophies (id, code, title, description) FROM stdin;
1	perfect	Puntaje perfecto	Completaste un cuestionario con 100%
\.


--
-- Data for Name: user_trophies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_trophies (user_id, trophy_id, awarded_at) FROM stdin;
3	1	2025-11-12 12:46:48.596372
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, password_hash, name, created_at) FROM stdin;
1	demo@mouseflow.local	$2y$10$0Vv3C8o7iQ.1kzvQyYpY7e7k1x9JrV1dQb3Q0dVZrZ8fM3Qe3nO5y	Usuario Demo	2025-11-12 12:03:58.285737-06
2	test@example.com	$2y$12$IHoRTSW0aFPpFywHLWFlruSf6dGWMlyY7SW7imsRN9RsIKXTmlJgO	Test	2025-11-12 12:31:43.538806-06
3	caca@gmail.com	$2y$12$jGBlfvE6rKl9OXKA/0rwSuPOd3zHH9P.hLCtDvhmA61CfzhEs/OSe	caca	2025-11-12 12:32:09.157092-06
\.


--
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuario (id_usuario, nombre, correo, contra) FROM stdin;
1	Luis Ochoa	luis@gmail.com	1234
2	Adrián	adrian@gmail.com	5678
3	Arturo	arturociro@gmail.com	2468
4	Misa	misael@gmail.com	1010
5	Juan Guerrero	juan@gmail.com	abcd
6	tamarindo	a	1234
\.


--
-- Name: answers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.answers_id_seq', 12, true);


--
-- Name: cuestionario_id_cuestionario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cuestionario_id_cuestionario_seq', 3, true);


--
-- Name: glosario_id_termino_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.glosario_id_termino_seq', 22, true);


--
-- Name: leccion_id_leccion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.leccion_id_leccion_seq', 3, true);


--
-- Name: lecturas_id_lectura_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lecturas_id_lectura_seq', 3, true);


--
-- Name: lessons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lessons_id_seq', 3, true);


--
-- Name: logro_id_logro_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.logro_id_logro_seq', 3, true);


--
-- Name: pregunta_id_pregunta_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pregunta_id_pregunta_seq', 9, true);


--
-- Name: progreso_id_progreso_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.progreso_id_progreso_seq', 3, true);


--
-- Name: questions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.questions_id_seq', 3, true);


--
-- Name: quizzes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.quizzes_id_seq', 3, true);


--
-- Name: respuesta_id_respuesta_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.respuesta_id_respuesta_seq', 34, true);


--
-- Name: resultado_cuestionario_id_resultado_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.resultado_cuestionario_id_resultado_seq', 3, true);


--
-- Name: results_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.results_id_seq', 10, true);


--
-- Name: simbologia_id_simbolo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.simbologia_id_simbolo_seq', 17, true);


--
-- Name: trophies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.trophies_id_seq', 2, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 3, true);


--
-- Name: usuario_id_usuario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuario_id_usuario_seq', 6, true);


--
-- Name: answers answers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT answers_pkey PRIMARY KEY (id);


--
-- Name: cuestionario cuestionario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cuestionario
    ADD CONSTRAINT cuestionario_pkey PRIMARY KEY (id_cuestionario);


--
-- Name: glosario glosario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.glosario
    ADD CONSTRAINT glosario_pkey PRIMARY KEY (id_termino);


--
-- Name: leccion leccion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leccion
    ADD CONSTRAINT leccion_pkey PRIMARY KEY (id_leccion);


--
-- Name: lecturas lecturas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lecturas
    ADD CONSTRAINT lecturas_pkey PRIMARY KEY (id_lectura);


--
-- Name: lessons lessons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lessons
    ADD CONSTRAINT lessons_pkey PRIMARY KEY (id);


--
-- Name: logro logro_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logro
    ADD CONSTRAINT logro_pkey PRIMARY KEY (id_logro);


--
-- Name: pregunta pregunta_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pregunta
    ADD CONSTRAINT pregunta_pkey PRIMARY KEY (id_pregunta);


--
-- Name: progreso progreso_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.progreso
    ADD CONSTRAINT progreso_pkey PRIMARY KEY (id_progreso);


--
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: quizzes quizzes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quizzes
    ADD CONSTRAINT quizzes_pkey PRIMARY KEY (id);


--
-- Name: respuesta respuesta_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.respuesta
    ADD CONSTRAINT respuesta_pkey PRIMARY KEY (id_respuesta);


--
-- Name: resultado_cuestionario resultado_cuestionario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resultado_cuestionario
    ADD CONSTRAINT resultado_cuestionario_pkey PRIMARY KEY (id_resultado);


--
-- Name: results results_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.results
    ADD CONSTRAINT results_pkey PRIMARY KEY (id);


--
-- Name: simbologia simbologia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.simbologia
    ADD CONSTRAINT simbologia_pkey PRIMARY KEY (id_simbolo);


--
-- Name: trophies trophies_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trophies
    ADD CONSTRAINT trophies_code_key UNIQUE (code);


--
-- Name: trophies trophies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trophies
    ADD CONSTRAINT trophies_pkey PRIMARY KEY (id);


--
-- Name: user_trophies user_trophies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_trophies
    ADD CONSTRAINT user_trophies_pkey PRIMARY KEY (user_id, trophy_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: usuario usuario_correo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_correo_key UNIQUE (correo);


--
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id_usuario);


--
-- Name: idx_answers_question_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_answers_question_id ON public.answers USING btree (question_id);


--
-- Name: idx_questions_quiz_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_questions_quiz_id ON public.questions USING btree (quiz_id);


--
-- Name: idx_quizzes_lesson_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_quizzes_lesson_id ON public.quizzes USING btree (lesson_id);


--
-- Name: idx_results_quiz_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_results_quiz_id ON public.results USING btree (quiz_id);


--
-- Name: idx_results_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_results_user_id ON public.results USING btree (user_id);


--
-- Name: answers answers_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT answers_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.questions(id) ON DELETE CASCADE;


--
-- Name: pregunta pregunta_id_cuestionario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pregunta
    ADD CONSTRAINT pregunta_id_cuestionario_fkey FOREIGN KEY (id_cuestionario) REFERENCES public.cuestionario(id_cuestionario);


--
-- Name: progreso progreso_id_leccion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.progreso
    ADD CONSTRAINT progreso_id_leccion_fkey FOREIGN KEY (id_leccion) REFERENCES public.leccion(id_leccion);


--
-- Name: progreso progreso_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.progreso
    ADD CONSTRAINT progreso_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario);


--
-- Name: questions questions_quiz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_quiz_id_fkey FOREIGN KEY (quiz_id) REFERENCES public.quizzes(id) ON DELETE CASCADE;


--
-- Name: quizzes quizzes_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quizzes
    ADD CONSTRAINT quizzes_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lessons(id) ON DELETE CASCADE;


--
-- Name: respuesta respuesta_id_pregunta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.respuesta
    ADD CONSTRAINT respuesta_id_pregunta_fkey FOREIGN KEY (id_pregunta) REFERENCES public.pregunta(id_pregunta);


--
-- Name: resultado_cuestionario resultado_cuestionario_id_cuestionario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resultado_cuestionario
    ADD CONSTRAINT resultado_cuestionario_id_cuestionario_fkey FOREIGN KEY (id_cuestionario) REFERENCES public.cuestionario(id_cuestionario);


--
-- Name: resultado_cuestionario resultado_cuestionario_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resultado_cuestionario
    ADD CONSTRAINT resultado_cuestionario_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario);


--
-- Name: results results_quiz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.results
    ADD CONSTRAINT results_quiz_id_fkey FOREIGN KEY (quiz_id) REFERENCES public.quizzes(id) ON DELETE CASCADE;


--
-- Name: results results_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.results
    ADD CONSTRAINT results_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_trophies user_trophies_trophy_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_trophies
    ADD CONSTRAINT user_trophies_trophy_id_fkey FOREIGN KEY (trophy_id) REFERENCES public.trophies(id) ON DELETE CASCADE;


--
-- Name: user_trophies user_trophies_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_trophies
    ADD CONSTRAINT user_trophies_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

