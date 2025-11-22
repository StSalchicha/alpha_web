# Guía de Solución de Problemas de Conexión API

## Error: Connection timed out

Si ves el error "Connection timed out" al intentar cargar lecciones, sigue estos pasos:

### 1. Verificar que el servidor PHP esté ejecutándose

Abre una terminal en la carpeta `alpha_web` y ejecuta:

```bash
php -S 0.0.0.0:8080 -t .
```

**IMPORTANTE**: Usa `0.0.0.0` en lugar de `127.0.0.1` para que el servidor escuche en todas las interfaces de red y sea accesible desde otros dispositivos.

### 2. Verificar tu IP local

En Windows, abre CMD o PowerShell y ejecuta:
```bash
ipconfig
```

Busca la IP en "Adaptador de Ethernet" o "Adaptador de LAN inalámbrica" (IPv4). Debería ser algo como `192.168.0.xxx` o `192.168.1.xxx`.

### 3. Actualizar la IP en el código

Edita `lib/config/environment.dart` y reemplaza `192.168.0.101` con tu IP real:

```dart
static const String apiBaseUrl = 'http://TU_IP_REAL:8080/api/index.php';
```

### 4. Probar la conexión desde el navegador

Abre en tu navegador (en la PC):
```
http://TU_IP:8080/api/index.php?action=ping
```

Deberías ver: `{"ok":true,"db":true}`

### 5. Probar desde el celular

Abre el navegador del celular (debe estar en la misma red WiFi) y visita:
```
http://TU_IP:8080/api/index.php?action=ping
```

Si funciona aquí pero no en la app, puede ser un problema de permisos de red en Android.

### 6. Configurar permisos de red en Android

Edita `android/app/src/main/AndroidManifest.xml` y asegúrate de tener:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
```

### 7. Configurar el firewall de Windows

1. Abre "Firewall de Windows Defender"
2. Click en "Configuración avanzada"
3. Click en "Reglas de entrada" → "Nueva regla"
4. Selecciona "Puerto" → Siguiente
5. TCP → Puerto específico: 8080 → Siguiente
6. "Permitir la conexión" → Siguiente
7. Marca todas las opciones → Siguiente
8. Nombre: "PHP Server 8080" → Finalizar

### 8. Verificar que PostgreSQL esté ejecutándose

El servidor PHP necesita conectarse a PostgreSQL. Asegúrate de que:
- PostgreSQL esté ejecutándose
- Las credenciales en `api/bd.php` sean correctas
- La base de datos `mouse` exista

### 9. Probar con un servidor web completo (alternativa)

Si el servidor PHP integrado no funciona, puedes usar XAMPP o WAMP:

1. Copia la carpeta `api` a `htdocs` (XAMPP) o `www` (WAMP)
2. Accede desde: `http://TU_IP/api/index.php?action=ping`

### 10. Verificar logs de error

Si el problema persiste, revisa:
- Los logs del servidor PHP
- Los logs de Flutter (ejecuta `flutter run -v` para ver más detalles)
- La consola de Chrome DevTools si estás probando en web

## Solución Rápida

1. **Detén el servidor actual** (Ctrl+C)
2. **Ejecuta**: `php -S 0.0.0.0:8080 -t .` (desde la carpeta alpha_web)
3. **Verifica tu IP**: `ipconfig` en CMD
4. **Actualiza** `lib/config/environment.dart` con tu IP
5. **Prueba** en el navegador del celular: `http://TU_IP:8080/api/index.php?action=ping`
6. **Reinicia** la app Flutter

## Nota sobre los puertos que ves en el error

Los puertos como `49170`, `37892` que aparecen en el error son **puertos locales del dispositivo móvil**, no del servidor. Esto es normal - cada conexión TCP usa un puerto aleatorio en el cliente. El problema es que no puede conectarse al servidor en `192.168.0.101:8080`.

