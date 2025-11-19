<?php
// bd.php — conexión sencilla a PostgreSQL (MouseFlow)
header('Content-Type: application/json; charset=utf-8');

try {
    $pdo = new PDO(
        'pgsql:host=127.0.0.1;port=5432;dbname=mouse',
        'postgres',            // <-- cambia si usas otro usuario
        'madoka',  // <-- tu contraseña real
        [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES => false,
        ]
    );
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode([
        'ok' => false,
        'error' => 'Error al conectar con la base de datos',
        'detail' => $e->getMessage()
    ]);
    exit;
}
