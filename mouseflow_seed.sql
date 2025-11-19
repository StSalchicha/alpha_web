-- mouseflow_seed.sql
BEGIN;

INSERT INTO users (email, password_hash, name)
VALUES (
  'demo@mouseflow.local',
  '$2y$10$0Vv3C8o7iQ.1kzvQyYpY7e7k1x9JrV1dQb3Q0dVZrZ8fM3Qe3nO5y',
  'Usuario Demo'
) ON CONFLICT DO NOTHING;

INSERT INTO lessons (title, content_html) VALUES
('Sintaxis Básica', '<h4>Introducción</h4><p>Elementos básicos: variables, tipos, operadores.</p>'),
('Estructuras de Control', '<h4>Control de flujo</h4><p>if/else, for, while, do-while, return.</p>'),
('Funciones Avanzadas', '<h4>Funciones y Recursividad</h4><p>Funciones, recursión, manejo de archivos.</p>')
ON CONFLICT DO NOTHING;

INSERT INTO quizzes (lesson_id, title) VALUES
((SELECT id FROM lessons WHERE title='Sintaxis Básica'), 'Quiz Unidad 1'),
((SELECT id FROM lessons WHERE title='Estructuras de Control'), 'Quiz Unidad 2'),
((SELECT id FROM lessons WHERE title='Funciones Avanzadas'), 'Quiz Unidad 3')
ON CONFLICT DO NOTHING;

WITH q1 AS ( SELECT id FROM quizzes WHERE title='Quiz Unidad 1' LIMIT 1 )
INSERT INTO questions (quiz_id, text) VALUES
((SELECT id FROM q1), '¿Qué es una variable?'),
((SELECT id FROM q1), 'Operador de igualdad común'),
((SELECT id FROM q1), '¿Qué ejecuta código condicionalmente?');

WITH qs AS (
  SELECT id, ROW_NUMBER() OVER(ORDER BY id) rn
  FROM questions WHERE quiz_id = (SELECT id FROM quizzes WHERE title='Quiz Unidad 1' LIMIT 1)
)
INSERT INTO answers (question_id, text, is_correct) VALUES
((SELECT id FROM qs WHERE rn=1), 'Un valor inmutable', FALSE),
((SELECT id FROM qs WHERE rn=1), 'Un contenedor de datos', TRUE),
((SELECT id FROM qs WHERE rn=1), 'Un bucle', FALSE),
((SELECT id FROM qs WHERE rn=1), 'Un error', FALSE),

((SELECT id FROM qs WHERE rn=2), '=', FALSE),
((SELECT id FROM qs WHERE rn=2), '==', TRUE),
((SELECT id FROM qs WHERE rn=2), '===', FALSE),
((SELECT id FROM qs WHERE rn=2), '!=', FALSE),

((SELECT id FROM qs WHERE rn=3), 'for', FALSE),
((SELECT id FROM qs WHERE rn=3), 'while', FALSE),
((SELECT id FROM qs WHERE rn=3), 'if', TRUE),
((SELECT id FROM qs WHERE rn=3), 'function', FALSE);

COMMIT;
