<?php
/**
 * API MouseFlow (JSON)
 * Requiere: api/bd.php -> define $pdo (PDO PostgreSQL, db mouse_flow)
 * Endpoints:
 *   GET  ?action=ping
 *   POST ?action=register        {name?, email, password}
 *   POST ?action=login           {email, password}
 *   GET  ?action=lessons
 *   GET  ?action=lesson&id=#
 *   GET  ?action=quizByLesson&lessonId=#
 *   POST ?action=saveResult      {userId, quizId, correct, total, duration?}
 *   GET  ?action=trophies&userId=#
 *   GET  ?action=profile&userId=#
 *   POST ?action=updateProfile   {userId, name?}
 */

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Headers: Content-Type');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') { http_response_code(200); exit; }

require_once __DIR__ . '/bd.php'; // Debe crear $pdo

// ============== Helpers ==============
function json_input(): array {
  $raw = file_get_contents('php://input');
  if ($raw === '' || $raw === false) return [];
  $data = json_decode($raw, true);
  if (json_last_error() !== JSON_ERROR_NONE) {
    // JSON inválido
    http_response_code(400);
    echo json_encode(['ok'=>false,'error'=>'JSON inválido','detail'=>json_last_error_msg()]);
    exit;
  }
  return is_array($data) ? $data : [];
}
function out($arr, int $code = 200) {
  http_response_code($code);
  echo json_encode($arr, JSON_UNESCAPED_UNICODE);
  exit;
}

// ---- DEBUG opcional (?debug=1) ----
$DEBUG = isset($_GET['debug']) && $_GET['debug'] == '1';

// ============== Bootstrap (split por sentencias) ==============
$defaultLessons = [
  [
    'title' => 'Sintaxis Básica',
    'content_html' => '<h2>Lección 1: Sintaxis Básica</h2>
<p>Antes de poder construir algoritmos complejos, es fundamental entender cómo escribir correctamente en pseudocódigo. En esta lección aprenderás las reglas básicas de sintaxis, muy similares a las de lenguajes como C, que nos ayudarán a organizar nuestras ideas de forma clara y ordenada.</p>

<h3>Conceptos Fundamentales</h3>
<p>Conocerás cómo declarar variables indicando su tipo (como <code>entero</code>, <code>cadena</code>, etc.), cómo asignarles valores, y cómo usar los comentarios para explicar lo que hace el código. También aprenderás que los nombres de variables distinguen entre mayúsculas y minúsculas, por lo que usar <code>edad</code> no es lo mismo que usar <code>Edad</code>.</p>

<h3>Ejercicios Prácticos</h3>
<p>Además, practicarás identificando estructuras correctas a través de ejercicios como:</p>
<ul>
<li><strong>Ejercicio 1</strong>: que refuerza las reglas clave de escritura.</li>
<li><strong>Ejercicio 2</strong>: donde deberás completar fragmentos de código reales.</li>
<li><strong>Ejercicio 3</strong>: en el que seleccionarás la imagen que mejor representa la declaración y asignación de variables.</li>
</ul>

<p>Esta lección te dará las bases que necesitas para comenzar a escribir tus propios algoritmos de forma correcta y comprensible.</p>'
  ],
  [
    'title' => 'Estructuras de Control',
    'content_html' => '<h2>Lección 2: Estructura de Programa - Main, Return, Condicionales y Bucles</h2>
<p>En esta lección nos adentraremos en la estructura esencial que da vida a cualquier algoritmo en pseudocódigo, comenzando con el punto de entrada del programa: la función <code>inicio()</code> (equivalente a <code>main</code> en lenguajes como C). Aquí aprenderás cómo organizar correctamente tu código dentro de bloques delimitados por llaves <code>{}</code> y cómo usar la instrucción <code>retornar</code> para indicar el final de una ejecución o devolver un valor.</p>

<h3>Estructuras Condicionales</h3>
<p>Una vez entendido el flujo principal del programa, trabajaremos con las estructuras condicionales, que nos permiten tomar decisiones en base a condiciones lógicas. Aprenderás a usar <code>si</code>, <code>entonces</code> y <code>sino</code> para que el programa responda de manera distinta según los valores de entrada. Esto se ejemplifica en el <strong>Ejercicio 1</strong>, donde deberás completar un algoritmo que determina si una persona es mayor de edad.</p>

<h3>Bucles</h3>
<p>Finalmente, conocerás los bucles, estructuras que repiten acciones automáticamente mientras se cumpla una condición. Son esenciales para automatizar tareas repetitivas. En el <strong>Ejercicio 2</strong>, pondrás a prueba tu comprensión seleccionando la imagen que represente correctamente un bucle que muestra los números del 1 al 5.</p>

<p>Con esta lección, desarrollarás la capacidad de construir algoritmos con un flujo claro, capaces de tomar decisiones y repetir acciones eficientemente, sentando las bases para resolver problemas más complejos en pseudocódigo.</p>'
  ],
  [
    'title' => 'Funciones Avanzadas',
    'content_html' => '<h2>Lección 3: Funciones, Manejo de Archivos y Recursividad</h2>
<p>En esta lección exploraremos tres conceptos fundamentales que llevan el pseudocódigo a un nivel más avanzado y práctico: funciones, archivos y recursividad.</p>

<h3>Funciones</h3>
<p>Comenzamos con las funciones, una herramienta clave para dividir el código en partes reutilizables. Aprenderás cómo se definen con un nombre, parámetros de entrada y un bloque de instrucciones. Las funciones ayudan a organizar mejor los programas, reducir repeticiones y facilitar la resolución de problemas complejos. En el <strong>Ejercicio 1</strong> (cuestionario) reforzarás este conocimiento reconociendo sus características principales.</p>

<h3>Manejo de Archivos</h3>
<p>Luego, abordaremos el manejo de archivos, lo que permite a tus algoritmos guardar o leer información externa, como textos, listas o resultados. Esta habilidad es útil cuando necesitas que los datos persistan más allá de la ejecución del programa. En el <strong>Ejercicio 1</strong> (completar código), practicarás cómo abrir un archivo, escribir contenido en él y cerrarlo correctamente.</p>

<h3>Recursividad</h3>
<p>Finalmente, conocerás la recursividad, una técnica poderosa donde una función se llama a sí misma para resolver un problema en partes más pequeñas. Este concepto, aunque avanzado, es muy útil en situaciones como el cálculo de factoriales, recorridos en árboles o resolución de acertijos lógicos. En el <strong>Ejercicio 2</strong> (cuestionario) analizarás el ejemplo de una función recursiva y cómo se asegura de no caer en un ciclo infinito.</p>

<p>Con esta lección, serás capaz de construir programas más organizados, eficientes y capaces de trabajar con datos dinámicos, acercándote al pensamiento algorítmico de un desarrollador real.</p>'
  ]
];
$defaultQuizzes = [
  [
    'lesson_title' => 'Sintaxis Básica',
    'quiz_title'   => 'Quiz Unidad 1',
    'questions' => [
      [
        'text' => 'Ejercicio 1: Cuestionario\n\nEn pseudocódigo orientado a C, una instrucción termina en punto y coma (;). Las variables deben declararse con su tipo antes de usarse. Los comentarios permiten explicar el código y se escriben con doble diagonal (//). Los nombres de variables distinguen entre mayúsculas y minúsculas, por lo que edad y Edad son diferentes.',
        'answers' => [
          ['text' => 'entero edad;', 'is_correct' => true],
          ['text' => 'Edad = 5;', 'is_correct' => false],
          ['text' => '// Esto es un comentario', 'is_correct' => false],
          ['text' => 'edad entero;', 'is_correct' => false],
        ]
      ],
      [
        'text' => 'Ejercicio 2: Completar código\n\nInstrucción: Completa el siguiente pseudocódigo con las partes faltantes.\n\n// Declaracion de variables\n_________ nombre;\n_________ edad;\n//Asignacion de valores\nnombre = "Carlos";\nedad = ____;\n//Mostrar resultados\nmostrar(_____);',
        'answers' => [
          ['text' => 'entero, cadena, mostrar(nombre), 20', 'is_correct' => false],
          ['text' => 'cadena, entero, 20, nombre', 'is_correct' => true],
          ['text' => 'mostrar, cadena, nombre, 20', 'is_correct' => false],
          ['text' => 'entero, edad, 20, edad', 'is_correct' => false],
        ]
      ],
      [
        'text' => 'Ejercicio 3: Seleccionar la imagen correcta\n\nInstrucción: Selecciona la imagen que representa correctamente una declaración de variables y asignación de valor.',
        'answers' => [
          ['text' => 'cadena nombre;\nnombre = Carlos;', 'is_correct' => false],
          ['text' => 'nombre: cadena;\nnombre = "Carlos"', 'is_correct' => false],
          ['text' => 'cadena nombre;\nnombre = "Carlos";', 'is_correct' => true],
        ]
      ],
    ]
  ],
  [
    'lesson_title' => 'Estructuras de Control',
    'quiz_title'   => 'Quiz Unidad 2',
    'questions' => [
      [
        'text' => 'Ejercicio 1: main\n\nEn pseudocódigo estilo C, el punto de inicio de un programa es la función principal, usualmente llamada main. Se escribe como inicio() { ... } y puede devolver un valor con retornar. Aunque en pseudocódigo no siempre se usa un tipo de retorno explícito, entender return es esencial para la lógica del programa.',
        'answers' => [
          ['text' => 'funcion principal()', 'is_correct' => false],
          ['text' => 'inicio()', 'is_correct' => true],
          ['text' => 'comienzo()', 'is_correct' => false],
          ['text' => 'start()', 'is_correct' => false],
        ]
      ],
      [
        'text' => 'Ejercicio 2: Completar código\n\nInstrucción: Completa el siguiente fragmento de pseudocódigo que evalúa si una persona es mayor de edad.\n\nentero edad;\nedad = 17;\n\nsi (edad____18) entonces {\nmostrar("Eres mayor de edad"):\n}sino{\nmostrar("Eres menor de edad");\n}',
        'answers' => [
          ['text' => '>=', 'is_correct' => true],
          ['text' => '==', 'is_correct' => false],
          ['text' => '<', 'is_correct' => false],
          ['text' => '>', 'is_correct' => false],
        ]
      ],
      [
        'text' => 'Ejercicio 3: Seleccionar la opción correcta\n\nInstrucción: ¿Cuál imagen representa correctamente un bucle que muestra los números del 1 al 5?',
        'answers' => [
          ['text' => 'para (i = 1; i <= 5; i = i + 1) {\nmostrar(i);\n}', 'is_correct' => true],
          ['text' => 'por i desde 5 hasta 1 paso -1{\nmostrar(i);\n}', 'is_correct' => false],
          ['text' => 'mientras (i <= 5) {\nmostrar(i);\ni++;\n}', 'is_correct' => false],
        ]
      ],
    ]
  ],
  [
    'lesson_title' => 'Funciones Avanzadas',
    'quiz_title'   => 'Quiz Unidad 3',
    'questions' => [
      [
        'text' => 'Ejercicio 1: Cuestionario\n\nLas funciones permiten reutilizar código. Una función puede recibir parámetros y devolver un valor. Se definen con un nombre, parámetros entre paréntesis y un bloque de instrucciones.',
        'answers' => [
          ['text' => 'inicio() { a + b; }', 'is_correct' => false],
          ['text' => 'funcion resta(a, b) retornar a - b;', 'is_correct' => false],
          ['text' => 'funcion mostrar() { mostrar("Hola"); }', 'is_correct' => true],
          ['text' => 'funcion suma(a + b)', 'is_correct' => false],
        ]
      ],
      [
        'text' => 'Ejercicio 2: Completar código\n\nInstrucción: Completa el pseudocódigo que abre un archivo y escribe un mensaje.\n\narchivo f;\nf = abrir("salida.txt" , " "____");\nescribir(f, "Hola mundo");\ncerrar(f);',
        'answers' => [
          ['text' => 'lectura', 'is_correct' => false],
          ['text' => 'escritura', 'is_correct' => false],
          ['text' => 'w', 'is_correct' => true],
          ['text' => 'leer', 'is_correct' => false],
        ]
      ],
      [
        'text' => 'Ejercicio 3: Cuestionario\n\nUna función recursiva es aquella que se llama a sí misma. Se usa para resolver problemas que pueden dividirse en subproblemas similares. Para evitar llamadas infinitas, se necesita una condición de parada. Un ejemplo clásico es el cálculo del factorial:\n\nfuncion factorial(entero n) {\nsi (n==0) retornar 1;\nretornar n * factorial(n - 1);\n}',
        'answers' => [
          ['text' => 'Contiene un bucle dentro.', 'is_correct' => false],
          ['text' => 'Se llama a sí misma', 'is_correct' => true],
          ['text' => 'Solo se ejecuta una vez', 'is_correct' => false],
          ['text' => 'No necesita retornar valores', 'is_correct' => false],
        ]
      ],
    ]
  ],
];
$seedSelectLesson = $pdo->prepare('SELECT id, content_html FROM lessons WHERE title = :title LIMIT 1');
$seedUpdateLesson = $pdo->prepare('UPDATE lessons SET content_html = :html, is_active = TRUE WHERE id = :id');
$seedInsertLesson = $pdo->prepare('INSERT INTO lessons (title, content_html, is_active) VALUES (:title, :html, TRUE)');
$seedFindLessonId = $pdo->prepare('SELECT id FROM lessons WHERE title = :title LIMIT 1');
$seedFindQuizByLesson = $pdo->prepare('SELECT id FROM quizzes WHERE lesson_id = :lesson_id LIMIT 1');
$seedInsertQuiz = $pdo->prepare('INSERT INTO quizzes (lesson_id, title) VALUES (:lesson_id, :title) RETURNING id');
$seedInsertQuestion = $pdo->prepare('INSERT INTO questions (quiz_id, text) VALUES (:quiz_id, :text) RETURNING id');
$seedInsertAnswer = $pdo->prepare('INSERT INTO answers (question_id, text, is_correct) VALUES (:question_id, :text, :is_correct)');

function seed_default_lessons(PDO $pdo) {
  global $defaultLessons, $seedSelectLesson, $seedUpdateLesson, $seedInsertLesson;
  foreach ($defaultLessons as $lesson) {
    $seedSelectLesson->execute([':title' => $lesson['title']]);
    $current = $seedSelectLesson->fetch(PDO::FETCH_ASSOC);
    if ($current) {
      // Siempre actualizar el contenido HTML con el contenido completo
      $seedUpdateLesson->execute([
        ':html' => $lesson['content_html'],
        ':id' => $current['id']
      ]);
    } else {
      $seedInsertLesson->execute([
        ':title' => $lesson['title'],
        ':html' => $lesson['content_html']
      ]);
    }
  }
}
function seed_default_quizzes(PDO $pdo) {
  global $defaultQuizzes, $seedFindLessonId, $seedFindQuizByLesson, $seedInsertQuiz, $seedInsertQuestion, $seedInsertAnswer;
  foreach ($defaultQuizzes as $quizDef) {
    try {
      $seedFindLessonId->execute([':title' => $quizDef['lesson_title']]);
      $lesson = $seedFindLessonId->fetch(PDO::FETCH_ASSOC);
      if (!$lesson || empty($lesson['id'])) {
        error_log("Seed: Lección '{$quizDef['lesson_title']}' no encontrada");
        continue;
      }

      $seedFindQuizByLesson->execute([':lesson_id' => $lesson['id']]);
      $existing = $seedFindQuizByLesson->fetch(PDO::FETCH_ASSOC);
      
      $quizId = null;
      if ($existing) {
        $quizId = $existing['id'];
        // Eliminar preguntas y respuestas existentes para reinsertar
        $pdo->prepare('DELETE FROM answers WHERE question_id IN (SELECT id FROM questions WHERE quiz_id = :qid)')->execute([':qid' => $quizId]);
        $pdo->prepare('DELETE FROM questions WHERE quiz_id = :qid')->execute([':qid' => $quizId]);
      } else {
        // Crear nuevo quiz
        $seedInsertQuiz->execute([':lesson_id' => $lesson['id'], ':title' => $quizDef['quiz_title']]);
        $quizId = $seedInsertQuiz->fetchColumn();
        if (!$quizId) {
          error_log("Seed: Error al crear quiz para lección {$lesson['id']}");
          continue;
        }
      }

      // Insertar preguntas y respuestas
      $questionsInserted = 0;
      foreach ($quizDef['questions'] as $qDef) {
        $seedInsertQuestion->execute([':quiz_id' => $quizId, ':text' => $qDef['text']]);
        $questionId = $seedInsertQuestion->fetchColumn();
        if (!$questionId) {
          error_log("Seed: Error al insertar pregunta en quiz $quizId");
          continue;
        }
        $answersInserted = 0;
        foreach ($qDef['answers'] as $ans) {
          try {
            $seedInsertAnswer->execute([
              ':question_id' => $questionId,
              ':text' => $ans['text'],
              ':is_correct' => $ans['is_correct'] ? 1 : 0
            ]);
            $answersInserted++;
          } catch (Exception $e) {
            error_log("Seed: Error al insertar respuesta: " . $e->getMessage());
          }
        }
        if ($answersInserted > 0) {
          $questionsInserted++;
        }
      }
      error_log("Seed: Quiz '{$quizDef['quiz_title']}' creado/actualizado con $questionsInserted preguntas");
    } catch (Exception $e) {
      error_log("Seed: Error procesando quiz '{$quizDef['quiz_title']}': " . $e->getMessage());
    }
  }
}

$bootstrap = [
  "CREATE TABLE IF NOT EXISTS users (
     id SERIAL PRIMARY KEY,
     name TEXT,
     email TEXT UNIQUE NOT NULL,
     password_hash TEXT NOT NULL,
     created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
   )",
  "CREATE TABLE IF NOT EXISTS lessons (
     id SERIAL PRIMARY KEY,
     title TEXT NOT NULL,
     content_html TEXT,
     is_active BOOLEAN NOT NULL DEFAULT TRUE,
     created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
   )",
  "CREATE TABLE IF NOT EXISTS quizzes (
     id SERIAL PRIMARY KEY,
     lesson_id INTEGER NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
     title TEXT NOT NULL
   )",
  "CREATE TABLE IF NOT EXISTS questions (
     id SERIAL PRIMARY KEY,
     quiz_id INTEGER NOT NULL REFERENCES quizzes(id) ON DELETE CASCADE,
     text TEXT NOT NULL
   )",
  "CREATE TABLE IF NOT EXISTS answers (
     id SERIAL PRIMARY KEY,
     question_id INTEGER NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
     text TEXT NOT NULL,
     is_correct BOOLEAN NOT NULL DEFAULT FALSE
   )",
  "CREATE TABLE IF NOT EXISTS results (
     id SERIAL PRIMARY KEY,
     user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
     quiz_id INTEGER NOT NULL REFERENCES quizzes(id) ON DELETE CASCADE,
     correct_count INTEGER NOT NULL,
     total INTEGER NOT NULL,
     duration_sec INTEGER NOT NULL DEFAULT 0,
     created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
   )",
  "CREATE TABLE IF NOT EXISTS trophies (
     id SERIAL PRIMARY KEY,
     code TEXT UNIQUE,
     title TEXT NOT NULL,
     description TEXT
   )",
  "CREATE TABLE IF NOT EXISTS user_trophies (
     id SERIAL PRIMARY KEY,
     user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
     trophy_id INTEGER NOT NULL REFERENCES trophies(id) ON DELETE CASCADE,
     awarded_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
     UNIQUE (user_id, trophy_id)
   )",
  "ALTER TABLE lessons ADD COLUMN IF NOT EXISTS is_active BOOLEAN NOT NULL DEFAULT TRUE",
  "DO $$ BEGIN
     IF EXISTS (
       SELECT 1 FROM information_schema.columns
       WHERE table_schema='public' AND table_name='results' AND column_name='correct'
     ) THEN
       EXECUTE 'ALTER TABLE results RENAME COLUMN correct TO correct_count';
     END IF;
     IF EXISTS (
       SELECT 1 FROM information_schema.columns
       WHERE table_schema='public' AND table_name='results' AND column_name='duration_seconds'
     ) THEN
       EXECUTE 'ALTER TABLE results RENAME COLUMN duration_seconds TO duration_sec';
     END IF;
   END $$"
];

try {
  foreach ($bootstrap as $sql) { $pdo->exec($sql); }

  seed_default_lessons($pdo);
  seed_default_quizzes($pdo);
} catch (Throwable $e) {
  out(['ok'=>false,'error'=>'Error creando tablas','detail'=>$e->getMessage()],500);
}

$action = $_GET['action'] ?? '';

try {
  switch ($action) {

    // ---------- Healthcheck ----------
    case 'ping': {
      $row = $pdo->query('SELECT 1 AS ok')->fetch(PDO::FETCH_ASSOC);
      out(['ok'=>true,'db'=>((int)($row['ok'] ?? 0) === 1)]);
    }

    // ---------- Debug: Listar todos los quizzes ----------
    case 'debugQuizzes': {
      $quizzes = $pdo->query('SELECT q.id, q.lesson_id, q.title, l.title as lesson_title, 
                              (SELECT COUNT(*) FROM questions WHERE quiz_id = q.id) as question_count
                              FROM quizzes q 
                              LEFT JOIN lessons l ON l.id = q.lesson_id 
                              ORDER BY q.id')->fetchAll(PDO::FETCH_ASSOC);
      out(['ok'=>true,'data'=>$quizzes]);
    }

    // ---------- Register (JSON) ----------
    case 'register': {
      if ($_SERVER['REQUEST_METHOD'] !== 'POST') out(['ok'=>false,'error'=>'Método no permitido'],405);
      $in = json_input();
      if ($DEBUG) out(['debug'=>['headers'=>getallheaders(),'input'=>$in]]);
      $name     = trim($in['name'] ?? '');
      $email    = trim($in['email'] ?? '');
      $password = (string)($in['password'] ?? '');

      if ($email === '' || $password === '') out(['ok'=>false,'error'=>'Email y contraseña son obligatorios'],400);
      if (!filter_var($email, FILTER_VALIDATE_EMAIL)) out(['ok'=>false,'error'=>'Email inválido'],400);

      $hash = password_hash($password, PASSWORD_DEFAULT);
      $stmt = $pdo->prepare('
        INSERT INTO users (name, email, password_hash)
        VALUES (:n, :e, :p)
        RETURNING id, name, email, created_at
      ');
      try {
        $stmt->execute([':n'=>$name, ':e'=>$email, ':p'=>$hash]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);
        out(['ok'=>true,'data'=>['user'=>$user]]);
      } catch (PDOException $e) {
        $msg = strtolower($e->getMessage());
        if (str_contains($msg,'unique') || str_contains($msg,'duplicate')) {
          out(['ok'=>false,'error'=>'Ese correo ya está registrado'],409);
        }
        out(['ok'=>false,'error'=>'SQL error','detail'=>$e->getMessage()],500);
      }
    }

    // ---------- Login ----------
  case 'login': {
  if ($_SERVER['REQUEST_METHOD'] !== 'POST') out(['ok'=>false,'error'=>'Método no permitido'],405);
  $in = json_input();
  $email    = trim($in['email'] ?? '');
  $password = (string)($in['password'] ?? '');
  if ($email==='' || $password==='') out(['ok'=>false,'error'=>'Email y contraseña son obligatorios'],400);

  // 1) ¿Existe columna legacy "password"?
  $chk = $pdo->prepare("
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name   = 'users'
      AND column_name  = 'password'
    LIMIT 1
  ");
  $chk->execute();
  $hasLegacy = (bool)$chk->fetchColumn();

  // 2) Trae usuario (con legacy_password solo si la columna existe)
  if ($hasLegacy) {
    $stmt = $pdo->prepare('
      SELECT id, name, email, password_hash, password AS legacy_password
      FROM users
      WHERE email = :e
      LIMIT 1
    ');
  } else {
    $stmt = $pdo->prepare('
      SELECT id, name, email, password_hash, NULL::text AS legacy_password
      FROM users
      WHERE email = :e
      LIMIT 1
    ');
  }
  $stmt->execute([':e'=>$email]);
  $row = $stmt->fetch(PDO::FETCH_ASSOC);
  if (!$row) out(['ok'=>false,'error'=>'Credenciales inválidas'],401);

  $ok = false;

  // 3) Verifica hash moderno
  if (!empty($row['password_hash']) && password_verify($password, $row['password_hash'])) {
    $ok = true;
    if (password_needs_rehash($row['password_hash'], PASSWORD_DEFAULT)) {
      $newHash = password_hash($password, PASSWORD_DEFAULT);
      $pdo->prepare('UPDATE users SET password_hash=:h WHERE id=:id')
          ->execute([':h'=>$newHash, ':id'=>$row['id']]);
    }
  } else if ($hasLegacy && !empty($row['legacy_password'])) {
    // 4) Compatibilidad con columna legacy en texto plano
    if (hash_equals($row['legacy_password'], $password)) {
      $ok = true;
      // migra a hash y limpia texto plano (si quieres conservarla, omite este UPDATE)
      try {
        $pdo->beginTransaction();
        $newHash = password_hash($password, PASSWORD_DEFAULT);
        $pdo->prepare('UPDATE users SET password_hash=:h WHERE id=:id')
            ->execute([':h'=>$newHash, ':id'=>$row['id']]);
        $pdo->prepare('UPDATE users SET password=NULL WHERE id=:id')
            ->execute([':id'=>$row['id']]);
        $pdo->commit();
      } catch (Throwable $e) {
        if ($pdo->inTransaction()) $pdo->rollBack();
        // no fallamos el login por esto
      }
    }
  }

  if (!$ok) out(['ok'=>false,'error'=>'Credenciales inválidas'],401);

  unset($row['password_hash'], $row['legacy_password']);
  out(['ok'=>true,'data'=>['user'=>$row]]);
}



    // ---------- Listado de lecciones ----------
    case 'lessons': {
      $rows = $pdo->query('SELECT id, title FROM lessons WHERE is_active = TRUE ORDER BY id ASC')->fetchAll(PDO::FETCH_ASSOC);
      out(['ok'=>true,'data'=>$rows]);
    }

    // ---------- Detalle de lección ----------
    case 'lesson': {
      $id = (int)($_GET['id'] ?? 0);
      if ($id <= 0) out(['ok'=>false,'error'=>'ID inválido'],400);
      $stmt = $pdo->prepare('SELECT id, title, content_html FROM lessons WHERE id = :id LIMIT 1');
      $stmt->execute([':id'=>$id]);
      $row = $stmt->fetch(PDO::FETCH_ASSOC);
      if (!$row) out(['ok'=>false,'error'=>'Lección no encontrada'],404);
      out(['ok'=>true,'data'=>$row]);
    }

    // ---------- Quiz por lección ----------
    case 'quizByLesson': {
      $lessonId = (int)($_GET['lessonId'] ?? 0);
      if ($lessonId <= 0) out(['ok'=>false,'error'=>'lessonId inválido'],400);

      $stmt = $pdo->prepare('SELECT id, title FROM quizzes WHERE lesson_id = :l LIMIT 1');
      $stmt->execute([':l'=>$lessonId]);
      $quiz = $stmt->fetch(PDO::FETCH_ASSOC);
      if (!$quiz) out(['ok'=>false,'error'=>'No hay cuestionario para esta lección'],404);

      $qs = $pdo->prepare('SELECT id, quiz_id, text FROM questions WHERE quiz_id = :q ORDER BY id ASC');
      $qs->execute([':q'=>$quiz['id']]);
      $questions = $qs->fetchAll(PDO::FETCH_ASSOC);

      $qa = $pdo->prepare('SELECT id, question_id, text, is_correct FROM answers WHERE question_id = :qid ORDER BY id ASC');
      foreach ($questions as &$q) {
        $qa->execute([':qid'=>$q['id']]);
        $ans = $qa->fetchAll(PDO::FETCH_ASSOC);
        foreach ($ans as &$a) { 
          $a['is_correct'] = (bool)$a['is_correct'];
          // Asegurar que question_id esté presente
          if (!isset($a['question_id'])) {
            $a['question_id'] = $q['id'];
          }
        }
        $q['answers'] = $ans;
      }

      out(['ok'=>true,'data'=>[
        'id'=>(int)$quiz['id'],
        'lesson_id'=>$lessonId,
        'title'=>$quiz['title'],
        'questions'=>$questions
      ]]);
    }

    // ---------- Guardar resultado ----------
    case 'saveResult': {
      if ($_SERVER['REQUEST_METHOD'] !== 'POST') out(['ok'=>false,'error'=>'Método no permitido'],405);
      $in = json_input();
      $userId  = (int)($in['userId'] ?? 0);
      $quizId  = (int)($in['quizId'] ?? 0);
      $correct = (int)($in['correct'] ?? 0);
      $total   = (int)($in['total'] ?? 0);
      $duration= (int)($in['duration'] ?? 0);

      if ($userId<=0 || $quizId<=0 || $total<0 || $correct<0) {
        out(['ok'=>false,'error'=>'Datos incompletos'],400);
      }

      $stmt = $pdo->prepare('
        INSERT INTO results (user_id, quiz_id, correct_count, total, duration_sec)
        VALUES (:u,:q,:c,:t,:d)
        RETURNING id, created_at
      ');
      $stmt->execute([':u'=>$userId, ':q'=>$quizId, ':c'=>$correct, ':t'=>$total, ':d'=>$duration]);
      $row = $stmt->fetch(PDO::FETCH_ASSOC);

      // Trofeo simple si obtiene 100%
      if ($total > 0 && $correct === $total) {
        $pdo->exec("INSERT INTO trophies (code, title, description)
                    VALUES ('perfect','Puntaje perfecto','Completaste un cuestionario con 100%')
                    ON CONFLICT (code) DO NOTHING");
        $pdo->exec("INSERT INTO user_trophies (user_id, trophy_id)
                    SELECT {$userId}, t.id FROM trophies t WHERE t.code='perfect'
                    ON CONFLICT DO NOTHING");
      }

      out(['ok'=>true,'data'=>['result_id'=>(int)$row['id'],'created_at'=>$row['created_at']]]);
    }

    // ---------- Trofeos ----------
    case 'trophies': {
      $userId = (int)($_GET['userId'] ?? 0);
      if ($userId<=0) out(['ok'=>false,'error'=>'userId inválido'],400);
      $stmt = $pdo->prepare('
        SELECT t.id, t.title, t.description, ut.awarded_at
        FROM user_trophies ut
        JOIN trophies t ON t.id = ut.trophy_id
        WHERE ut.user_id = :u
        ORDER BY ut.awarded_at DESC
      ');
      $stmt->execute([':u'=>$userId]);
      $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
      out(['ok'=>true,'data'=>$rows]);
    }

    // ---------- Perfil ----------
    case 'profile': {
      $userId = (int)($_GET['userId'] ?? 0);
      if ($userId<=0) out(['ok'=>false,'error'=>'userId inválido'],400);
      $stmt = $pdo->prepare('SELECT id, name, email, created_at FROM users WHERE id=:id');
      $stmt->execute([':id'=>$userId]);
      $row = $stmt->fetch(PDO::FETCH_ASSOC);
      if (!$row) out(['ok'=>false,'error'=>'Usuario no encontrado'],404);
      out(['ok'=>true,'data'=>$row]);
    }

    // ---------- Actualizar perfil ----------
    case 'updateProfile': {
      if ($_SERVER['REQUEST_METHOD'] !== 'POST') out(['ok'=>false,'error'=>'Método no permitido'],405);
      $in = json_input();
      $userId = (int)($in['userId'] ?? 0);
      $name   = trim($in['name'] ?? '');
      if ($userId<=0) out(['ok'=>false,'error'=>'userId inválido'],400);

      $stmt = $pdo->prepare('UPDATE users SET name=:n WHERE id=:id RETURNING id,name,email,created_at');
      $stmt->execute([':n'=>$name, ':id'=>$userId]);
      $row = $stmt->fetch(PDO::FETCH_ASSOC);
      out(['ok'=>true,'data'=>['user'=>$row]]);
    }

    default:
      out(['ok'=>false,'error'=>'Acción no válida','hint'=>'ping | register | login | lessons | lesson | quizByLesson | saveResult | trophies | profile | updateProfile | debugQuizzes'],400);
  }

} catch (Throwable $e) {
  out(['ok'=>false,'error'=>'Error interno','detail'=>$e->getMessage()],500);
}
