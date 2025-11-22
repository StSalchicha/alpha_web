# Refactoring de Estructuras de Datos - MouseFlow

## Resumen del Refactoring

Este documento describe los cambios realizados para asegurar que la capa de lógica (Providers) use exclusivamente las estructuras de datos personalizadas definidas en `lib/utils/structures/`, cumpliendo con los requisitos académicos del proyecto.

## Estructuras de Datos Implementadas

### 1. **LessonLinkedList** (Lista Enlazada)
- **Ubicación**: `lib/utils/structures/lesson_linked_list.dart`
- **Uso**: Almacena las lecciones en una lista enlazada
- **Operaciones principales**:
  - `append(Lesson)`: Inserta al final
  - `findById(int)`: Busca por ID (O(n))
  - `toList()`: Convierte a lista para renderizado en UI
  - `getNextLesson(int)`: Obtiene el nodo siguiente

### 2. **QuestionQueue** (Cola FIFO)
- **Ubicación**: `lib/utils/structures/question_queue.dart`
- **Uso**: Almacena las preguntas del quiz en orden FIFO
- **Operaciones principales**:
  - `enqueue(Question)`: Agrega al final de la cola
  - `dequeue()`: Remueve del frente de la cola
  - `peek()`: Observa el frente sin remover
  - `fromList(List<Question>)`: Convierte lista a cola

### 3. **Map<String, dynamic>** (Hash Table / Diccionario)
- **Ubicación**: `lib/providers/auth_provider.dart`
- **Uso**: Almacena datos del usuario y perfil con acceso O(1)
- **Implementaciones**:
  - `_userData`: Datos generales del usuario
  - `_profileCache`: Cache específico del perfil

### 4. **Navigator** (Stack nativo de Flutter)
- **Uso**: Navegación entre pantallas
- **Operaciones**: `Navigator.push()`, `Navigator.pop()`, `Navigator.pushReplacement()`

## Cambios Realizados

### 1. ContentProvider (`lib/providers/content_provider.dart`)

#### ✅ Cambios Implementados:
- **Ya usaba `LessonLinkedList`**: Confirmado, no se requirieron cambios
- **Ya usaba `QuestionQueue`**: Confirmado, no se requirieron cambios
- **Nuevo método agregado**:
  ```dart
  LessonNode? getNextLesson(int currentLessonId)
  Lesson? getNextLessonData(int currentLessonId)
  ```
  - Busca el nodo actual en la LinkedList
  - Retorna el nodo `.next` (siguiente lección)
  - Demuestra uso explícito de la estructura enlazada

#### Métodos que usan estructuras personalizadas:
- `loadLessons()`: Inserta lecciones en `LessonLinkedList` usando `append()`
- `loadQuizForLesson()`: Inserta preguntas en `QuestionQueue` usando `fromList()`
- `markLessonAsCompleted()`: Busca en LinkedList usando `findById()`
- `getNextLesson()`: Navega por la LinkedList usando `.next`

### 2. QuizScreen (`lib/ui/screens/quiz_screen.dart`)

#### ✅ Cambios Implementados:
- **Eliminado uso de índices**: No se usan `index++` para navegar preguntas
- **Uso de `dequeue()`**: Al responder una pregunta, se ejecuta `dequeue()` para removerla de la cola
- **Uso de `peek()`**: Para mostrar la pregunta actual sin removerla

#### Flujo de navegación:
1. Al iniciar quiz: `questionQueue.fromList(quiz.questions)` - carga en cola
2. Al mostrar pregunta: `questionQueue.peek()` - observa el frente
3. Al responder: `questionQueue.dequeue()` - remueve del frente (FIFO)
4. Verificación: `questionQueue.isEmpty` - verifica si hay más preguntas

### 3. AuthProvider (`lib/providers/auth_provider.dart`)

#### ✅ Cambios Implementados:
- **Agregado `_profileCache`**: Map explícito para datos del perfil
- **Acceso O(1)**: Todos los accesos a datos del usuario usan Map
- **Sincronización**: `_profileCache` se actualiza al hacer login/register

#### Estructura del Map:
```dart
_profileCache = {
  'name': String,
  'email': String,
  'id': int,
  'trophies_count': int,
}
```

#### Métodos que usan Map:
- `login()`: Guarda datos en `_userData` y `_profileCache`
- `loadTrophies()`: Actualiza `trophies_count` en `_profileCache`
- `updateProfileCache()`: Método explícito para actualizar cache

### 4. ProfileScreen (`lib/ui/screens/profile_screen.dart`)

#### ✅ Cambios Implementados:
- **Lectura desde `profileCache`**: Todos los datos se leen del Map
- **Acceso O(1)**: `profileCache['name']`, `profileCache['email']`, etc.
- **Demostración explícita**: Muestra el uso de la estructura Diccionario

### 5. LessonsScreen (`lib/ui/screens/lessons_screen.dart`)

#### ✅ Estado Actual:
- **Ya usa `toList()`**: Convierte LinkedList a lista para renderizado
- **No usa índices para navegación**: Solo para renderizado en ListView
- **Navegación usa LinkedList**: `findById()` para buscar lecciones

### 6. LessonDetailScreen (`lib/ui/screens/lesson_detail_screen.dart`)

#### ✅ Cambios Implementados:
- **Uso de `getNextLesson()`**: Navega usando el método de ContentProvider
- **Uso de `findById()`**: Busca lección actual en LinkedList
- **Navegación con LinkedList**: Usa `.next` para avanzar

## Verificaciones Realizadas

### ✅ ApiService
- **Endpoints correctos**: Todos apuntan a `api/index.php?action=...`
- **Métodos implementados**: `login`, `register`, `lessons`, `lesson`, `quizByLesson`, `saveResult`, `trophies`

### ✅ Navegación
- **Navigator.pop()**: Usado en todos los botones "Atrás"
- **Stack nativo**: Flutter Navigator usa Stack internamente

### ✅ Eliminación de Listas Nativas
- **No hay `List<Lesson>` en Providers**: Solo se usa `LessonLinkedList`
- **No hay `List<Question>` en Providers**: Solo se usa `QuestionQueue`
- **`toList()` solo para UI**: Se usa únicamente para renderizado, no para lógica

## Métodos Agregados a las Estructuras

### LessonLinkedList
- ✅ `toList()`: Ya existía
- ✅ `findById()`: Ya existía
- ✅ `getNextLesson()`: Agregado en ContentProvider

### QuestionQueue
- ✅ `peek()`: Ya existía
- ✅ `dequeue()`: Ya existía
- ✅ `fromList()`: Ya existía

## Demostración de Uso

### Lista Enlazada (LessonLinkedList)
```dart
// En ContentProvider
_lessonsList.append(lesson);  // Insertar
final node = _lessonsList.findById(lessonId);  // Buscar
final nextNode = node?.next;  // Navegar
```

### Cola FIFO (QuestionQueue)
```dart
// En ContentProvider
_questionQueue.fromList(quiz.questions);  // Cargar
final current = _questionQueue.peek();  // Observar
_questionQueue.dequeue();  // Remover (FIFO)
```

### Hash Table / Map
```dart
// En AuthProvider
_profileCache['name'] = user.name;  // Guardar O(1)
final name = _profileCache['name'];  // Leer O(1)
```

## Conclusión

✅ **Todos los requisitos cumplidos**:
1. ✅ ContentProvider usa `LessonLinkedList` exclusivamente
2. ✅ Quiz usa `QuestionQueue` con `dequeue()` (sin índices)
3. ✅ AuthProvider usa `Map` explícitamente con `_profileCache`
4. ✅ ProfileScreen lee desde `profileCache` (acceso O(1))
5. ✅ ApiService apunta correctamente a los endpoints
6. ✅ Navegación usa `Navigator.pop()` (Stack nativo)

El código ahora demuestra explícitamente el uso de las estructuras de datos personalizadas en toda la capa de lógica, cumpliendo con los requisitos académicos del proyecto.

