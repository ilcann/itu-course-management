<?php
// Public portfolio deployment only. The original university setup is unchanged.
if (getenv('DEMO_READ_ONLY') !== 'false') {
    $method = isset($_SERVER['REQUEST_METHOD']) ? $_SERVER['REQUEST_METHOD'] : 'GET';
    $path = parse_url(isset($_SERVER['REQUEST_URI']) ? $_SERVER['REQUEST_URI'] : '/', PHP_URL_PATH);
    $read = preg_match('#^/ilcan21/api/public/(auth/me|announcements/index|courses/(index|info|materials|students|attendance|grades|available|enrolled|instructors))\.php$#', $path);
    $auth = preg_match('#^/ilcan21/api/public/auth/(login|logout)\.php$#', $path);
    if (!(($read && in_array($method, array('GET', 'HEAD'), true)) || ($auth && $method === 'POST'))) {
        http_response_code(403);
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(array('success' => false, 'message' => 'This public demo is read-only.'));
        exit;
    }
}
