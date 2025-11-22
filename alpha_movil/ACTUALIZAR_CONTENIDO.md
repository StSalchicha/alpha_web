# Instrucciones para Actualizar el Contenido

## Problemas Corregidos

1. ✅ **Overflow en MenuScreen** - Agregado SingleChildScrollView
2. ✅ **Error 400 en quizzes** - Corregida construcción de URL para mantener parámetro `action`
3. ✅ **Contenido HTML vacío** - Seed actualizado para siempre actualizar el contenido
4. ✅ **Quizzes sin preguntas** - Seed actualizado para reinsertar preguntas

## Pasos para Aplicar el Contenido

### 1. Reiniciar el Servidor PHP

**IMPORTANTE**: Debes reiniciar el servidor PHP para que el seed se ejecute y actualice el contenido.

```bash
# Detén el servidor actual (Ctrl+C)
# Luego ejecuta:
php -S 0.0.0.0:8080 -t .
```

El seed se ejecutará automáticamente al iniciar el servidor y:
- Actualizará el contenido HTML de las 3 lecciones con el contenido completo
- Creará/actualizará los 3 quizzes con todas sus preguntas y respuestas

### 2. Verificar que el Contenido se Actualizó

Abre en tu navegador:
- `http://TU_IP:8080/api/index.php?action=lessons` - Debe mostrar las 3 lecciones
- `http://TU_IP:8080/api/index.php?action=lesson&id=1` - Debe mostrar el contenido HTML completo
- `http://TU_IP:8080/api/index.php?action=quizByLesson&lessonId=1` - Debe mostrar el quiz con preguntas

### 3. Reconstruir la App Flutter

```bash
cd alpha_movil
flutter clean
flutter run
```

## Contenido que se Agregará

### Lecciones:
1. **Sintaxis Básica** - Contenido completo sobre variables, tipos, comentarios, etc.
2. **Estructuras de Control** - Contenido sobre main, condicionales y bucles
3. **Funciones Avanzadas** - Contenido sobre funciones, archivos y recursividad

### Quizzes:
1. **Quiz Unidad 1** (Sintaxis Básica) - 3 ejercicios con respuestas
2. **Quiz Unidad 2** (Estructuras de Control) - 3 ejercicios con respuestas  
3. **Quiz Unidad 3** (Funciones Avanzadas) - 3 ejercicios con respuestas

## Nota

Si después de reiniciar el servidor el contenido aún no aparece, verifica:
1. Que PostgreSQL esté ejecutándose
2. Que las credenciales en `api/bd.php` sean correctas
3. Que la base de datos `mouse` exista y tenga las tablas correctas

