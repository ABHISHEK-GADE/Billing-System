<?php
require_once '../../config/database.php';
require_once '../../includes/auth.php';

session_start(); // Ensure session is started before using $_SESSION

if ($_SERVER['REQUEST_METHOD'] === 'GET' && isset($_GET['id'])) {
    $id = intval($_GET['id']);

    // Prepare the DELETE statement
    $stmt = $pdo->prepare("DELETE FROM users WHERE id = :id");
    $stmt->bindParam(':id', $id, PDO::PARAM_INT);

    if ($stmt->execute()) {
        $_SESSION['success'] = "User deleted successfully.";
    } else {
        $_SESSION['error'] = "Failed to delete user. Please try again.";
    }

    // Redirect to the correct page
    header("Location: manage_users.php");
    exit;
} else {
    $_SESSION['error'] = "Invalid request.";
    header("Location: manage_users.php");
    exit;
}
?>
