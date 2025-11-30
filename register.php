<?php
session_start();
require_once '../db.php';

$error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $name     = trim($_POST['name']);
    $email    = trim($_POST['email']);
    $password = $_POST['password'];
    $role     = $_POST['role'];

    if (!$name || !$email || !$password || !$role) {
        $error = "All fields are required.";
    } elseif (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $error = "Invalid email format.";
    } else {
        $stmt = $mysqli->prepare("SELECT id FROM users WHERE email=?");
        $stmt->bind_param("s", $email);
        $stmt->execute();
        $stmt->store_result();
        if ($stmt->num_rows > 0) {
            $error = "Email already exists.";
        } else {
            $hashed_password = password_hash($password, PASSWORD_DEFAULT);
            $stmt = $mysqli->prepare("INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)");
            $stmt->bind_param("ssss", $name, $email, $hashed_password, $role);
            if ($stmt->execute()) {
                $_SESSION['user_id'] = $stmt->insert_id;
                $_SESSION['role']    = $role;
                if ($role === 'admin') header('Location: ../admin/dashboard.php');
                elseif ($role === 'staff') header('Location: ../staff/dashboard.php');
                else header('Location: ../customer/dashboard.php');
                exit;
            } else {
                $error = "Registration failed.";
            }
        }
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>CSMS - Register</title>
<style>
* { box-sizing: border-box; margin:0; padding:0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
body { background: #f2f2f2; display:flex; justify-content:center; align-items:center; min-height:100vh; }
.container { background:#fff; padding:40px 30px; border-radius:12px; box-shadow:0 8px 20px rgba(0,0,0,0.1); width:100%; max-width:400px; }
h2 { text-align:center; margin-bottom:30px; color:#333; }
.logo { text-align:center; margin-bottom:20px; font-size:28px; font-weight:bold; color:#FF4C60; }
form input, form select { width:100%; padding:12px; margin:8px 0 16px 0; border:1px solid #ccc; border-radius:8px; font-size:16px; }
form button { width:100%; padding:12px; background-color:#FF4C60; border:none; border-radius:8px; color:white; font-size:18px; cursor:pointer; transition:0.3s; }
form button:hover { background-color:#e04355; }
.error-message { color:red; text-align:center; margin-bottom:15px; }
.login-link { text-align:center; margin-top:15px; font-size:14px; }
.login-link a { color:#FF4C60; text-decoration:none; font-weight:500; }
.login-link a:hover { text-decoration:underline; }
</style>
</head>
<body>
<div class="container">
    <div class="logo">CSMS</div>
    <h2>Create Account</h2>
    <?php if ($error) echo "<p class='error-message'>$error</p>"; ?>
    <form method="post">
        <input type="text" name="name" placeholder="Full Name" required>
        <input type="email" name="email" placeholder="Email Address" required>
        <input type="password" name="password" placeholder="Password" required>
        <select name="role" required>
            <option value="" disabled selected>Select Role</option>
            <option value="customer">Customer</option>
            <option value="staff">Staff</option>
            <option value="admin">Admin</option>
        </select>
        <button type="submit">Register</button>
    </form>
    <div class="login-link">
        Already have an account? <a href="/CSMS/auth/login.php">Login</a>

    </div>
</div>
</body>
</html>
