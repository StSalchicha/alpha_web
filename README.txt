MouseFlow API + Synthwave CSS (JSON)
========================================

1) Edita api/bd.php y reemplaza TU_CONTRASEÑA_AQUI por tu clave real.
2) Sirve la carpeta por HTTP (php -S 127.0.0.1:8080 -t .).
3) Probar: /api/index.php?action=ping -> {"ok":true,"db":true}
4) Endpoints:
   - POST /api/index.php?action=register  {name?, email, password}
   - POST /api/index.php?action=login     {email, password}
   - GET  /api/index.php?action=lessons
   - GET  /api/index.php?action=lesson&id=#
   - GET  /api/index.php?action=quizByLesson&lessonId=#
   - POST /api/index.php?action=saveResult {userId, quizId, correct, total, duration?}
   - GET  /api/index.php?action=trophies&userId=#
   - GET  /api/index.php?action=profile&userId=#
   - POST /api/index.php?action=updateProfile {userId, name?}
