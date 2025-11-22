<?php
/**
 * Script de prueba para verificar que el seed funcione correctamente
 * Ejecutar: php test_seed.php
 */

require_once __DIR__ . '/bd.php';

// Preparar statements
$seedFindLessonId = $pdo->prepare('SELECT id FROM lessons WHERE title = :title LIMIT 1');
$seedFindQuizByLesson = $pdo->prepare('SELECT id FROM quizzes WHERE lesson_id = :lesson_id LIMIT 1');
$seedInsertQuiz = $pdo->prepare('INSERT INTO quizzes (lesson_id, title) VALUES (:lesson_id, :title) RETURNING id');
$seedInsertQuestion = $pdo->prepare('INSERT INTO questions (quiz_id, text) VALUES (:quiz_id, :text) RETURNING id');
$seedInsertAnswer = $pdo->prepare('INSERT INTO answers (question_id, text, is_correct) VALUES (:question_id, :text, :is_correct)');

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

echo "=== Iniciando seed de quizzes ===\n\n";

foreach ($defaultQuizzes as $quizDef) {
  echo "Procesando: {$quizDef['quiz_title']} para lección '{$quizDef['lesson_title']}'\n";
  
  $seedFindLessonId->execute([':title' => $quizDef['lesson_title']]);
  $lesson = $seedFindLessonId->fetch(PDO::FETCH_ASSOC);
  
  if (!$lesson || empty($lesson['id'])) {
    echo "  ERROR: Lección '{$quizDef['lesson_title']}' no encontrada\n\n";
    continue;
  }
  
  echo "  Lección encontrada: ID {$lesson['id']}\n";
  
  $seedFindQuizByLesson->execute([':lesson_id' => $lesson['id']]);
  $existing = $seedFindQuizByLesson->fetch(PDO::FETCH_ASSOC);
  
  $quizId = null;
  if ($existing) {
    $quizId = $existing['id'];
    echo "  Quiz existente encontrado: ID $quizId\n";
    // Eliminar preguntas y respuestas existentes
    $pdo->prepare('DELETE FROM answers WHERE question_id IN (SELECT id FROM questions WHERE quiz_id = :qid)')->execute([':qid' => $quizId]);
    $pdo->prepare('DELETE FROM questions WHERE quiz_id = :qid')->execute([':qid' => $quizId]);
    echo "  Preguntas anteriores eliminadas\n";
  } else {
    $seedInsertQuiz->execute([':lesson_id' => $lesson['id'], ':title' => $quizDef['quiz_title']]);
    $quizId = $seedInsertQuiz->fetchColumn();
    if (!$quizId) {
      echo "  ERROR: No se pudo crear el quiz\n\n";
      continue;
    }
    echo "  Quiz creado: ID $quizId\n";
  }

  // Insertar preguntas y respuestas
  $questionsInserted = 0;
  foreach ($quizDef['questions'] as $qIndex => $qDef) {
    $seedInsertQuestion->execute([':quiz_id' => $quizId, ':text' => $qDef['text']]);
    $questionId = $seedInsertQuestion->fetchColumn();
    if (!$questionId) {
      echo "  ERROR: No se pudo insertar pregunta " . ($qIndex + 1) . "\n";
      continue;
    }
    
    $answersInserted = 0;
    foreach ($qDef['answers'] as $aIndex => $ans) {
      try {
        $seedInsertAnswer->execute([
          ':question_id' => $questionId,
          ':text' => $ans['text'],
          ':is_correct' => $ans['is_correct'] ? 1 : 0
        ]);
        $answersInserted++;
      } catch (Exception $e) {
        echo "  ERROR al insertar respuesta " . ($aIndex + 1) . " de pregunta " . ($qIndex + 1) . ": " . $e->getMessage() . "\n";
      }
    }
    if ($answersInserted > 0) {
      $questionsInserted++;
      echo "  Pregunta " . ($qIndex + 1) . " insertada con $answersInserted respuestas\n";
    }
  }
  
  echo "  ✓ Quiz completado: $questionsInserted preguntas insertadas\n\n";
}

echo "=== Verificando resultados ===\n";
$allQuizzes = $pdo->query('SELECT q.id, q.lesson_id, q.title, l.title as lesson_title, 
                           (SELECT COUNT(*) FROM questions WHERE quiz_id = q.id) as question_count,
                           (SELECT COUNT(*) FROM answers WHERE question_id IN (SELECT id FROM questions WHERE quiz_id = q.id)) as answer_count
                           FROM quizzes q 
                           LEFT JOIN lessons l ON l.id = q.lesson_id 
                           ORDER BY q.id')->fetchAll(PDO::FETCH_ASSOC);

foreach ($allQuizzes as $q) {
  echo "Quiz ID {$q['id']}: {$q['title']} (Lección: {$q['lesson_title']}) - {$q['question_count']} preguntas, {$q['answer_count']} respuestas\n";
}

echo "\n=== Seed completado ===\n";

