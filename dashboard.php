<?php
session_start();
require_once __DIR__ . '/../db.php';

// Only allow Staff
if(!isset($_SESSION['role']) || $_SESSION['role'] !== 'staff') {
    header('Location: ../auth/login.php');
    exit;
}

$staffId = $_SESSION['user_id'];
$staffName = $_SESSION['name'] ?? 'Staff';

// --- Quick Stats ---
$totalOrders = $mysqli->query("SELECT COUNT(*) as cnt FROM orders")->fetch_assoc()['cnt'];
$pendingOrders = $mysqli->query("SELECT COUNT(*) as cnt FROM orders WHERE status='pending'")->fetch_assoc()['cnt'];
$completedOrders = $mysqli->query("SELECT COUNT(*) as cnt FROM orders WHERE status='completed'")->fetch_assoc()['cnt'];

// --- Fetch Orders ---
$ordersList = [];
$ordersResult = $mysqli->query("
    SELECT o.id, o.user_id, u.name as customer_name, o.total_amount, o.status, o.created_at
    FROM orders o
    JOIN users u ON o.user_id = u.id
    ORDER BY o.created_at DESC
");
if($ordersResult) $ordersList = $ordersResult->fetch_all(MYSQLI_ASSOC);

// Handle status update
if($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['order_id'], $_POST['status'])){
    $orderId = (int)$_POST['order_id'];
    $newStatus = $_POST['status'];
    if(in_array($newStatus, ['pending','completed','cancelled'])){
        $stmt = $mysqli->prepare("UPDATE orders SET status=? WHERE id=?");
        $stmt->bind_param('si', $newStatus, $orderId);
        $stmt->execute();
        header("Location: ".$_SERVER['PHP_SELF']);
        exit;
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Staff Dashboard</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<style>
/* ---------- Base ---------- */
body {
    margin:0; font-family:'Poppins', sans-serif; background:#f7f9fc;
}
header {
    background:#36b9cc; color:#fff;
    padding:18px 25px;
    display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap;
    box-shadow:0 4px 15px rgba(0,0,0,0.1);
}
header a { color:#fff; text-decoration:none; font-weight:600; transition:0.3s; }
header a:hover { text-decoration:underline; }
.container { max-width:1200px; margin:30px auto; padding:0 20px; }
h2 { margin-bottom:20px; color:#333; font-size:1.4em; }

/* ---------- Quick Stats ---------- */
.stats { display:flex; gap:20px; flex-wrap:wrap; margin-bottom:35px; }
.card {
    flex:1; background:#fff; padding:25px; border-radius:15px;
    box-shadow:0 10px 25px rgba(0,0,0,0.08); text-align:center; min-width:150px;
    transition:0.3s;
}
.card:hover { transform:translateY(-5px); box-shadow:0 15px 30px rgba(0,0,0,0.12); }
.card h3 { margin-bottom:10px; color:#555; font-weight:500; font-size:1.05rem; }
.card span { font-size:2rem; font-weight:700; color:#36b9cc; }

/* ---------- Orders Table ---------- */
.table {
    width:100%; border-collapse:collapse; background:#fff; border-radius:12px;
    overflow:hidden; box-shadow:0 10px 25px rgba(0,0,0,0.08); margin-bottom:50px;
}
.table th, .table td {
    padding:12px 15px; border-bottom:1px solid #eee; text-align:left;
    vertical-align: middle; font-size:0.9rem;
}
.table th { background:#f1f3f6; color:#555; font-weight:600; }
.table tr:hover { background:#f9f9f9; }

/* ---------- Status Badges ---------- */
.status-pending { color:#fff; background:#f0ad4e; padding:6px 12px; border-radius:20px; font-weight:500; font-size:0.85rem; }
.status-completed { color:#fff; background:#1cc88a; padding:6px 12px; border-radius:20px; font-weight:500; font-size:0.85rem; }
.status-cancelled { color:#fff; background:#e74a3b; padding:6px 12px; border-radius:20px; font-weight:500; font-size:0.85rem; }

/* ---------- Status Form ---------- */
.status-form {
    display:flex; gap:6px; align-items:center;
}
.status-form select {
    padding:6px 10px; border-radius:8px; border:1px solid #ccc; font-size:0.85rem; outline:none;
    transition:0.3s;
}
.status-form select:focus { border-color:#36b9cc; box-shadow:0 0 6px rgba(54,185,204,0.3); }
.status-form button {
    padding:6px 10px; border:none; border-radius:8px; background:#36b9cc;
    color:#fff; font-weight:500; cursor:pointer; transition:0.3s;
}
.status-form button:hover { background:#2c9faf; }

/* ---------- Responsive ---------- */
@media(max-width:768px){
    .stats { flex-direction:column; }
    .table th, .table td { font-size:0.8rem; padding:8px 10px; }
}
@media(max-width:480px){
    header { flex-direction:column; gap:10px; text-align:center; }
    .status-form { flex-direction:column; }
    .status-form button { width:100%; }
}
</style>
</head>
<body>
<header>
    <span><i class="fas fa-user"></i> Welcome, <?= htmlspecialchars($staffName) ?></span>
    <a href="../auth/logout.php"><i class="fas fa-sign-out-alt"></i> Logout</a>
</header>

<div class="container">

<h2>Quick Stats</h2>
<div class="stats">
    <div class="card"><h3>Total Orders</h3><span><?= $totalOrders ?></span></div>
    <div class="card"><h3>Pending Orders</h3><span><?= $pendingOrders ?></span></div>
    <div class="card"><h3>Completed Orders</h3><span><?= $completedOrders ?></span></div>
</div>

<h2>Manage Orders</h2>
<table class="table">
<thead>
<tr>
<th>ID</th><th>Customer</th><th>Total Amount</th><th>Status</th><th>Ordered At</th><th>Action</th>
</tr>
</thead>
<tbody>
<?php foreach($ordersList as $o): ?>
<tr>
<td><?= htmlspecialchars($o['id']) ?></td>
<td><?= htmlspecialchars($o['customer_name']) ?></td>
<td>$<?= htmlspecialchars($o['total_amount']) ?></td>
<td>
<?php
switch(strtolower($o['status'])){
    case 'pending': echo '<span class="status-pending">Pending</span>'; break;
    case 'completed': echo '<span class="status-completed">Completed</span>'; break;
    case 'cancelled': echo '<span class="status-cancelled">Cancelled</span>'; break;
}
?>
</td>
<td><?= htmlspecialchars($o['created_at']) ?></td>
<td>
<form method="post" class="status-form">
    <input type="hidden" name="order_id" value="<?= $o['id'] ?>">
    <select name="status">
        <option value="pending" <?= $o['status']=='pending'?'selected':'' ?>>Pending</option>
        <option value="completed" <?= $o['status']=='completed'?'selected':'' ?>>Completed</option>
        <option value="cancelled" <?= $o['status']=='cancelled'?'selected':'' ?>>Cancelled</option>
    </select>
    <button type="submit"><i class="fas fa-check"></i></button>
</form>
</td>
</tr>
<?php endforeach; ?>
</tbody>
</table>

</div>
</body>
</html>
