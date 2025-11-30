<?php
session_start();
require_once __DIR__ . '/../db.php';

// Only allow Customers
if(!isset($_SESSION['role']) || $_SESSION['role'] !== 'customer') {
    header('Location: ../auth/login.php');
    exit;
}

$userId = $_SESSION['user_id'];

// Fetch cart items
$cartResult = $mysqli->query("SELECT c.product_id, c.quantity, p.price, p.stock 
                              FROM cart c 
                              JOIN products p ON c.product_id = p.id
                              WHERE c.user_id = $userId");

$cartItems = [];
$totalAmount = 0;

if($cartResult && $cartResult->num_rows > 0){
    $cartItems = $cartResult->fetch_all(MYSQLI_ASSOC);
    foreach($cartItems as $item){
        if($item['quantity'] > $item['stock']){
            die("Cannot place order. Product stock insufficient.");
        }
        $totalAmount += $item['price'] * $item['quantity'];
    }
} else {
    die("Your cart is empty.");
}

// Begin transaction
$mysqli->begin_transaction();

try {
    // Insert order
    $stmt = $mysqli->prepare("INSERT INTO orders (user_id, total_amount, status, created_at) VALUES (?, ?, 'pending', NOW())");
    $stmt->bind_param("id", $userId, $totalAmount);
    $stmt->execute();
    $orderId = $stmt->insert_id;

    // Insert order items & reduce stock
    $stmtItem = $mysqli->prepare("INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)");
    foreach($cartItems as $item){
        $stmtItem->bind_param("iiid", $orderId, $item['product_id'], $item['quantity'], $item['price']);
        $stmtItem->execute();

        $mysqli->query("UPDATE products SET stock = stock - {$item['quantity']} WHERE id = {$item['product_id']}");
    }

    // Clear cart
    $mysqli->query("DELETE FROM cart WHERE user_id = $userId");

    $mysqli->commit();
    header("Location: dashboard.php?order_success=1");
    exit;

} catch(Exception $e){
    $mysqli->rollback();
    die("Error placing order: " . $e->getMessage());
}
