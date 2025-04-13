<?php
require_once '../../config/database.php';
require_once '../../includes/auth.php';

// Validate and fetch the user ID
if (!isset($_GET['id']) || empty($_GET['id'])) {
    die("Invalid or missing User ID.");
}

$id = intval($_GET['id']);

// Fetch the user details
$stmt = $pdo->prepare("SELECT * FROM users WHERE id = :id");
$stmt->execute(['id' => $id]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$user) {
    die("User not found.");
}

// Process form submission
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $name = trim($_POST['name']);
    $email = trim($_POST['email']);
    $status = trim($_POST['status']);

    // Update user details
    try {
        $stmt = $pdo->prepare("UPDATE users SET name = :name, email = :email, status = :status WHERE id = :id");
        $stmt->execute([
            'name' => $name,
            'email' => $email,
            'status' => $status,
            'id' => $id
        ]);

        $_SESSION['success'] = "User updated successfully.";
        header("Location: ../../templates/admin/manage_users.php");
        exit;
    } catch (PDOException $e) {
        $error = "An error occurred while updating the user: " . $e->getMessage();
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit User</title>
    <link rel="stylesheet" href="../../assets/css/admin.css">
</head>
<body>
    <div class="dashboard">
        <!-- Header -->
        <header class="dashboard-header">
            <h1>Edit User</h1>
            <a href="manage_users.php" class="btn btn-primary">Back to User List</a>
        </header>

        <!-- Sidebar -->
        <?php include 'sidebar.php'; ?>

        <!-- Main Content -->
        <div class="dashboard-content">
            <h2>Edit User</h2>

            <?php if (!empty($error)): ?>
                <div class="alert alert-error"><?= htmlspecialchars($error) ?></div>
            <?php endif; ?>

            <?php if (!empty($_SESSION['success'])): ?>
                <div class="alert alert-success"><?= htmlspecialchars($_SESSION['success']) ?></div>
                <?php unset($_SESSION['success']); ?>
            <?php endif; ?>

            <!-- Edit User Form -->
            <form method="POST" action="edit_user.php?id=<?= htmlspecialchars($id) ?>">
                <input type="hidden" name="id" value="<?= htmlspecialchars($id) ?>">
                <table class="user-table">
                    <thead>
                        <tr>
                            <th>Field</th>
                            <th>Input</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><label for="name">Full Name</label></td>
                            <td><input type="text" id="name" name="name" value="<?= htmlspecialchars($user['name']) ?>" required></td>
                        </tr>
                        <tr>
                            <td><label for="email">Email Address</label></td>
                            <td><input type="email" id="email" name="email" value="<?= htmlspecialchars($user['email']) ?>" required></td>
                        </tr>
                        <tr>
                            <td><label for="status">Status</label></td>
                            <td>
                                <select id="status" name="status" required>
                                    <option value="active" <?= $user['status'] === 'active' ? 'selected' : '' ?>>Active</option>
                                    <option value="inactive" <?= $user['status'] === 'inactive' ? 'selected' : '' ?>>Inactive</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" style="text-align: center;">
                                <button type="submit" class="btn btn-primary">Save Changes</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </form>
        </div>
    </div>
</body>
</html>
