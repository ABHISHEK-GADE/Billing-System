<?php
$host = '127.0.0.1';
$dbname = 'billing_system';
$username = 'root'; // Adjust as needed for your MySQL setup
$password = ''; // Leave blank if no password is set for root

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;port=3308", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Database connection failed: " . $e->getMessage());
}
?>
