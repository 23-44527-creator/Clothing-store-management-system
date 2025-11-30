<?php
session_start();
require_once '../db.php';

$error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email    = trim($_POST['email']);
    $password = $_POST['password'];

    if (!$email || !$password) {
        $error = "All fields are required.";
    } else {
        $stmt = $mysqli->prepare("SELECT id, password, role FROM users WHERE email=?");
        $stmt->bind_param("s", $email);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result->num_rows === 1) {
            $user = $result->fetch_assoc();
            if (password_verify($password, $user['password'])) {
                $_SESSION['user_id'] = $user['id'];
                $_SESSION['role']    = $user['role'];
                if ($user['role'] === 'admin') header('Location: ../admin/dashboard.php');
                elseif ($user['role'] === 'staff') header('Location: ../staff/dashboard.php');
                else header('Location: ../customer/dashboard.php');
                exit;
            } else {
                $error = "Incorrect password.";
            }
        } else {
            $error = "Email not found.";
        }
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>CSMS - Login</title>
<style>
* { box-sizing:border-box; margin:0; padding:0; font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
body { background:#f2f2f2; display:flex; justify-content:center; align-items:center; min-height:100vh; }
.container { background:#fff; padding:40px 30px; border-radius:12px; box-shadow:0 8px 20px rgba(0,0,0,0.1); width:100%; max-width:400px; }
h2 { text-align:center; margin-bottom:30px; color:#333; }
.logo { text-align:center; margin-bottom:20px; font-size:28px; font-weight:bold; color:#FF4C60; }
form input { width:100%; padding:12px; margin:8px 0 16px 0; border:1px solid #ccc; border-radius:8px; font-size:16px; }
form button { width:100%; padding:12px; background-color:#FF4C60; border:none; border-radius:8px; color:white; font-size:18px; cursor:pointer; transition:0.3s; }
form button:hover { background-color:#e04355; }
.error-message { color:red; text-align:center; margin-bottom:15px; }
.register-link { text-align:center; margin-top:15px; font-size:14px; }
.register-link a { color:#FF4C60; text-decoration:none; font-weight:500; }
.register-link a:hover { text-decoration:underline; }
</style>
</head>
<body>
<div class="container">
    <div class="logo">CSMS</div>
    <h2>Login</h2>
    <?php if ($error) echo "<p class='error-message'>$error</p>"; ?>
    <form method="post">
        <input type="email" name="email" placeholder="Email Address" required>
        <input type="password" name="password" placeholder="Password" required>
        <button type="submit">Login</button>
    </form>
    <div class="register-link">
        Don't have an account? <a href="/CSMS/auth/register.php">Register</a>

    </div>
</div>
</body>
</html>
