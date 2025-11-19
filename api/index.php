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
    'content_html' => '<h3>Variables y Tipos</h3><p>Repasa cómo declarar variables, tipos primitivos y reglas de nombrado.</p><h3>Operadores</h3><p>Incluye operadores aritméticos, comparación y lógicos con ejemplos cortos.</p>'
  ],
  [
    'title' => 'Estructuras de Control',
    'content_html' => '<h3>Condicionales</h3><p>Uso de <code>if</code>, <code>else if</code> y <code>switch</code> con ejemplos.</p><h3>Bucles</h3><p>Presenta <code>for</code>, <code>while</code>, <code>do...while</code> y cuándo utilizar cada uno.</p><h3>Buenas prácticas</h3><ul><li>Evita bucles infinitos.</li><li>Usa <code>break</code>/<code>continue</code> con moderación.</li></ul>'
  ],
  [
    'title' => 'Funciones Avanzadas',
    'content_html' => '<h3>Funciones</h3><p>Parámetros, retorno y sobrecarga.</p><h3>Recursividad</h3><p>Estrategias para dividir problemas y considerar casos base.</p><h3>Manejo de archivos</h3><p>Lectura y escritura con ejemplos breves.</p>'
  ]
];
$defaultQuizzes = [
  [
    'lesson_title' => 'Estructuras de Control',
    'quiz_title'   => 'Quiz Unidad 2',
    'questions' => [
      [
        'text' => '&#191;Qué instrucción se usa para evaluar múltiples casos en una sola expresión?',
        'answers' => [
          ['text' => 'switch',  'is_correct' => true],
          ['text' => 'goto',    'is_correct' => false],
          ['text' => 'foreach', 'is_correct' => false],
          ['text' => 'assert',  'is_correct' => false],
        ]
      ],
      [
        'text' => '&#191;Qué condición mantiene la ejecución de un bucle while?',
        'answers' => [
          ['text' => 'Que la condición sea verdadera', 'is_correct' => true],
          ['text' => 'Que la condición sea falsa',     'is_correct' => false],
          ['text' => 'Que la variable sea negativa',   'is_correct' => false],
          ['text' => 'Depende del número de iteraciones', 'is_correct' => false],
        ]
      ],
      [
        'text' => '&#191;Qué palabra clave termina inmediatamente un bucle?',
        'answers' => [
          ['text' => 'break',    'is_correct' => true],
          ['text' => 'continue', 'is_correct' => false],
          ['text' => 'stop',     'is_correct' => false],
          ['text' => 'halt',     'is_correct' => false],
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
      if (trim((string)$current['content_html']) === '') {
        $seedUpdateLesson->execute([
          ':html' => $lesson['content_html'],
          ':id' => $current['id']
        ]);
      }
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
    $seedFindLessonId->execute([':title' => $quizDef['lesson_title']]);
    $lesson = $seedFindLessonId->fetch(PDO::FETCH_ASSOC);
    if (!$lesson || empty($lesson['id'])) continue;

    $seedFindQuizByLesson->execute([':lesson_id' => $lesson['id']]);
    $existing = $seedFindQuizByLesson->fetch(PDO::FETCH_ASSOC);
    if ($existing) continue;

    $seedInsertQuiz->execute([':lesson_id' => $lesson['id'], ':title' => $quizDef['quiz_title']]);
    $quizId = $seedInsertQuiz->fetchColumn();
    if (!$quizId) continue;

    foreach ($quizDef['questions'] as $qDef) {
      $seedInsertQuestion->execute([':quiz_id' => $quizId, ':text' => $qDef['text']]);
      $questionId = $seedInsertQuestion->fetchColumn();
      if (!$questionId) continue;
      foreach ($qDef['answers'] as $ans) {
        $seedInsertAnswer->execute([
          ':question_id' => $questionId,
          ':text' => $ans['text'],
          ':is_correct' => $ans['is_correct'] ? 1 : 0
        ]);
      }
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

      $qs = $pdo->prepare('SELECT id, text FROM questions WHERE quiz_id = :q ORDER BY id ASC');
      $qs->execute([':q'=>$quiz['id']]);
      $questions = $qs->fetchAll(PDO::FETCH_ASSOC);

      $qa = $pdo->prepare('SELECT id, text, is_correct FROM answers WHERE question_id = :qid ORDER BY id ASC');
      foreach ($questions as &$q) {
        $qa->execute([':qid'=>$q['id']]);
        $ans = $qa->fetchAll(PDO::FETCH_ASSOC);
        foreach ($ans as &$a) { $a['is_correct'] = (bool)$a['is_correct']; }
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
      out(['ok'=>false,'error'=>'Acción no válida','hint'=>'ping | register | login | lessons | lesson | quizByLesson | saveResult | trophies | profile | updateProfile'],400);
  }

} catch (Throwable $e) {
  out(['ok'=>false,'error'=>'Error interno','detail'=>$e->getMessage()],500);
}
