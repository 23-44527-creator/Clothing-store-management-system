<?php
session_start();
require_once __DIR__ . '/../db.php';

// Only allow Customers
if(!isset($_SESSION['role']) || $_SESSION['role'] !== 'customer'){
    header('Location: ../auth/login.php');
    exit;
}

$userId = $_SESSION['user_id'];

if($_SERVER['REQUEST_METHOD'] === 'POST'){
    $productId = intval($_POST['product_id'] ?? 0);
    $quantity = intval($_POST['quantity'] ?? 1);

    if($productId > 0 && $quantity > 0){
        // Check if product exists
        $product = $mysqli->query("SELECT stock FROM products WHERE id=$productId")->fetch_assoc();
        if(!$product){
            $_SESSION['cart_error'] = "Product does not exist.";
            header('Location: dashboard.php');
            exit;
        }

        // Check if item is already in cart
        $existing = $mysqli->query("SELECT id, quantity FROM cart WHERE user_id=$userId AND product_id=$productId")->fetch_assoc();
        if($existing){
            $newQty = $existing['quantity'] + $quantity;
            if($newQty > $product['stock']) $newQty = $product['stock'];
            $stmt = $mysqli->prepare("UPDATE cart SET quantity=? WHERE id=?");
            $stmt->bind_param("ii", $newQty, $existing['id']);
            $stmt->execute();
        } else {
            if($quantity > $product['stock']) $quantity = $product['stock'];
            $stmt = $mysqli->prepare("INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)");
            $stmt->bind_param("iii", $userId, $productId, $quantity);
            $stmt->execute();
        }

        $_SESSION['cart_success'] = "Item added to cart!";
        header('Location: dashboard.php');
        exit;
    } else {
        $_SESSION['cart_error'] = "Invalid product or quantity.";
        header('Location: dashboard.php');
        exit;
    }
}
?>
