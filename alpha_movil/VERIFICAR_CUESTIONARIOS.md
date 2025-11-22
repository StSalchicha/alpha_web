# Verificación de Cuestionarios

## Pasos para Verificar

### 1. Reconstruir la App Flutter
```bash
cd alpha_movil
flutter clean
flutter run
```

### 2. Verificar en la App

1. **Ir a "VER CUESTIONARIOS"** - Deberías ver 3 cuestionarios listados
2. **Seleccionar un cuestionario** - Deberías ver la primera pregunta
3. **Verificar que aparezcan las respuestas** - Deberías ver 3-4 opciones de respuesta debajo de la pregunta

### 3. Si las Respuestas NO Aparecen

Revisa los logs de la consola de Flutter. Deberías ver mensajes como:
- `Quiz cargado: Quiz Unidad 1`
- `Total de preguntas: 3`
- `Pregunta 1: ...`
- `Respuestas: 4`
- `Answer.fromJson: id=..., questionId=..., text=..., isCorrect=...`

Si ves errores en los logs, compártelos para diagnosticar el problema.

### 4. Verificar el API Directamente

Abre en tu navegador:
```
http://TU_IP:8080/api/index.php?action=quizByLesson&lessonId=1
```

Deberías ver un JSON con:
- `id`: ID del quiz
- `lesson_id`: ID de la lección
- `title`: Título del quiz
- `questions`: Array con preguntas, cada una con:
  - `id`: ID de la pregunta
  - `quiz_id`: ID del quiz
  - `text`: Texto de la pregunta
  - `answers`: Array con respuestas, cada una con:
    - `id`: ID de la respuesta
    - `question_id`: ID de la pregunta
    - `text`: Texto de la respuesta
    - `is_correct`: true/false

## Problemas Comunes

### Las respuestas no aparecen
- **Causa**: El parseo de JSON está fallando
- **Solución**: Revisa los logs de debug en la consola

### Error "type 'Null' is not a subtype of type 'int'"
- **Causa**: El API no está devolviendo todos los campos necesarios
- **Solución**: Verifica que el servidor PHP esté corriendo y que el endpoint funcione

### "No hay cuestionarios disponibles"
- **Causa**: Los quizzes no se crearon en la base de datos
- **Solución**: Ejecuta `php test_seed.php` en la carpeta `api`

