-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 30, 2025 at 02:53 PM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.1.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `csms`
--

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `added_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `total` decimal(10,2) DEFAULT 0.00,
  `payment_method` varchar(50) DEFAULT 'cash',
  `status` enum('pending','preparing','ready','completed','cancelled') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `total_amount` decimal(10,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `total`, `payment_method`, `status`, `created_at`, `total_amount`) VALUES
(1, 3, '0.00', 'cash', 'cancelled', '2025-11-17 03:31:56', '660.00'),
(2, 3, '0.00', 'cash', 'pending', '2025-11-17 03:35:08', '165.00'),
(3, 3, '0.00', 'cash', 'completed', '2025-11-17 03:46:16', '165.00'),
(4, 9, '0.00', 'cash', 'completed', '2025-11-22 12:09:52', '700.00'),
(5, 9, '0.00', 'cash', 'completed', '2025-11-25 07:13:26', '700.00');

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `price` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `product_id`, `quantity`, `price`) VALUES
(1, 1, 2, 4, '165.00'),
(2, 2, 2, 1, '165.00'),
(3, 3, 2, 1, '165.00'),
(4, 4, 9, 1, '700.00'),
(5, 5, 9, 1, '700.00');

-- --------------------------------------------------------

--
-- Table structure for table `parcels`
--

CREATE TABLE `parcels` (
  `id` int(11) NOT NULL,
  `ranch_id` int(11) NOT NULL,
  `parcel_code` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `parcel_tracks`
--

CREATE TABLE `parcel_tracks` (
  `id` int(11) NOT NULL,
  `parcel_id` int(11) NOT NULL,
  `status` varchar(100) NOT NULL,
  `location` varchar(255) DEFAULT NULL,
  `remarks` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `stock` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `category` varchar(50) DEFAULT 'Uncategorized'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `description`, `price`, `image`, `stock`, `created_at`, `category`) VALUES
(2, '\"Snowflake Crystal Mermaid Gown\"', NULL, '750.00', '6921988af29b6.jpg', 3, '2025-11-17 03:18:00', 'Haute Couture Gown  / Evening Wear'),
(3, '\"Silver Mirrored Mosaic Gown,\"', NULL, '30000.00', '6921998cd76a6.jpg', 1, '2025-11-22 11:07:56', 'Haute Couture / High-End Eveningwear / Red Carpet'),
(4, '\"Ombre Petal Gown,\"', NULL, '20000.00', '69219b10dd9a7.jpg', 5, '2025-11-22 11:14:24', 'Bridal / Quinceañera / High-End Eveningwear / Cout'),
(5, '\"Black Tulle Goddess Gown,\"', NULL, '200.00', '69219c064dfd1.jpg', 10, '2025-11-22 11:18:30', 'Formal Eveningwear / Ball Gown /'),
(6, '\"Black and White Bow Minidress,\"', NULL, '500.00', '6921a1752db14.jpg', 14, '2025-11-22 11:41:41', 'Cocktail Dress / Party Dress / Designer Mini'),
(7, '\"Gold Embroidered Cheongsam Gown.\"', NULL, '8000.00', '6921a1d47191a.jpg', 4, '2025-11-22 11:43:16', 'Haute Couture / High-End Formal Eveningwear / Thea'),
(8, '\"Geometric Illusion Dress,\"', NULL, '15000.00', '6921a245ebd95.jpg', 5, '2025-11-22 11:45:09', 'Haute Couture / Theatrical Eveningwear /'),
(9, '\"One-Shoulder Ruffle High-Low Dress,\"', NULL, '700.00', '6921a2e289a13.jpg', 4, '2025-11-22 11:47:46', 'Cocktail / Semi-Formal Eveningwear / Bridal Shower'),
(10, 'Black Feather Ombre Gown', NULL, '15000.00', '6921a41f21bf6.jpg', 8, '2025-11-22 11:53:03', 'White/Black Ombre Skirt, Off-shoulder neckline, Bl'),
(11, '\"Ocean Wave Taffeta Gown,\"', NULL, '1500.00', '6921a4f4406b2.jpg', 15, '2025-11-22 11:56:36', 'High-End Eveningwear / Couture / Pageant Gown'),
(12, '\"Rose Texture Cocktail Dress,\"', NULL, '750.00', '6921a56cca45c.jpg', 9, '2025-11-22 11:58:36', 'Cocktail / Party Dress / Semi-Formal'),
(13, '\"Sweetheart Ruffled Mini-Ball Gown.\"', NULL, '400.00', '6921a5c26c546.jpg', 10, '2025-11-22 12:00:02', 'Cocktail / Party Dress / Vintage-Inspired Formalwe'),
(14, 'Red Taffeta Bow Ruffle Dress', NULL, '400.00', '6921a659b705e.jpg', 4, '2025-11-22 12:02:33', 'Cocktail / Semi-Formal'),
(15, '\"The Empress Ball Gown', NULL, '300000.00', '6921a74e9bf50.jpg', 6, '2025-11-22 12:04:46', 'Haute Couture / Theatrical Ball Gown / Bespoke For'),
(16, '\"Ruby Ruffle Mermaid Gown,\"', NULL, '6000.00', '6921a7af37398.jpg', 9, '2025-11-22 12:08:15', 'Formal Eveningwear / Pageant Gown / Specialty Even'),
(17, '\"Deep Sea Ruffle Ball Gown.\"', NULL, '25000.00', '6921a9538b1e9.jpg', 10, '2025-11-22 12:15:15', 'Haute Couture / Theatrical Gown / High-End Bridal'),
(18, '\"Emerald Forest Ombre Gown,\"', NULL, '20000.00', '6921a9b5ab6a3.jpg', 15, '2025-11-22 12:16:53', 'Haute Couture / Theatrical Ball Gown / Bespoke Eve'),
(19, 'Regal Gold-Embroidered Velvet Gown', NULL, '20000.00', '6921afee10766.jpg', 12, '2025-11-22 12:43:26', 'Haute Couture / Theatrical Formalwear / Bespoke Go'),
(20, '\"Purple Amaryllis Sculptural Dress,\"', NULL, '29000.00', '6921b061e8f2a.jpg', 8, '2025-11-22 12:45:21', 'Haute Couture / Theatrical Gown / Artwear'),
(21, 'Crystal Rosé Hi-Lo Dress,', NULL, '17000.00', '6921b0d7b5ad1.jpg', 8, '2025-11-22 12:47:19', 'Designer Cocktail / Pageant Eveningwear / Bridal R'),
(22, 'Rose Crystal Drop Minidress', NULL, '5000.00', '6921b20c083ae.jpg', 15, '2025-11-22 12:52:28', 'Couture Cocktail / High-End Party Dress / Pageant '),
(23, '\"Rose Diamond Corset Dress\"', NULL, '800.00', '6921b315ebe6e.jpg', 20, '2025-11-22 12:56:53', 'Designer Cocktail Wear / Statement Party Dress / M'),
(24, 'Orange Sequin Off-the-Shoulder', NULL, '1200.02', '6921b3f8f251c.jpg', 12, '2025-11-22 13:00:40', 'Designer Cocktail Dress, Evening Wear, or Formal G');

-- --------------------------------------------------------

--
-- Table structure for table `ranches`
--

CREATE TABLE `ranches` (
  `id` int(11) NOT NULL,
  `ranch_name` varchar(150) NOT NULL,
  `location` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `system_settings`
--

CREATE TABLE `system_settings` (
  `id` int(11) NOT NULL,
  `setting_key` varchar(150) NOT NULL,
  `setting_value` text DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('customer','staff','admin') DEFAULT 'customer',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `address` varchar(255) DEFAULT NULL,
  `contact` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `role`, `created_at`, `address`, `contact`) VALUES
(1, 'admin1', 'admin1@gmail.com', '$2y$10$yXgDnJxXp95lOuWhHEbJCe.rJAArPozvsOclZNGtCdo6a0WTbgLs2', 'admin', '2025-11-17 02:45:12', '', ''),
(3, 'kyla', 'kyla@gmail.com', '$2y$10$/j8KtVlxf/kGhqVHoOhtIeX61uHnaUWyvw1L9PTBHnVKvfbWR1uki', 'customer', '2025-11-17 02:59:26', NULL, NULL),
(4, 'staff1', 'staff1@gmail.com', '$2y$10$jqwym/R2u/jtl6tDQYWwQ.a0KsL9dytj7VkiI2rWBlxGlXrhQVWaq', 'staff', '2025-11-17 03:33:59', NULL, NULL),
(5, 'kylarobiso1', 'kylarobiso11234@gmail.com', '$2y$10$/QPuYc3ZLET3kzpIN6k3vuK1AZ6o.Wgng2CJfaow47snwC8079N6K', 'customer', '2025-11-22 10:01:53', NULL, NULL),
(6, 'kylarobiso1', 'kylarobiso1234@gmail.com', '$2y$10$HJFT6znG6mBsYUJKa0mb8OKDn3yFrsrx4mixsHiFI6hLXiVWfFNzq', 'customer', '2025-11-22 10:02:28', NULL, NULL),
(7, 'kylarobiso1', 'kylarobiso1@gmail.com', '$2y$10$LdH7U288WLsMF6PJrqdC6.FwR7DCnt23pZoDcYTwwor3kwJehgjBm', 'customer', '2025-11-22 10:03:11', NULL, NULL),
(8, 'kylarobiso1', 'kylarobiso@gmail.com', '$2y$10$XxKdghhZAX/tWZY5xj9MbuJok.M/XZQ5QFtdO30IaUoBYt3COCLHm', 'customer', '2025-11-22 10:04:53', NULL, NULL),
(9, 'kyle1', 'kyle1@gmail.com', '$2y$10$v8SADI4tQlUVvhuIWhj8WOjZcM7IPjcqv8uMCkVZMBnTUOBvqPr1m', 'customer', '2025-11-22 10:05:29', NULL, NULL),
(10, 'kalix1', 'kalix1@gmail.com', '$2y$10$ksVaR2zsk6kqHB5Zgf9L3.p/rsmBGyvc69YHBk2mb2UBR3GccgZ5i', 'customer', '2025-11-22 10:10:00', NULL, NULL),
(11, 'kalix1', 'kalix@gmail.com', '$2y$10$bVDp3gDIr9Q./KvZ6wWaX.cgHzCprhA9Ra.m9lzWjp4mCBjG1ndQK', 'customer', '2025-11-22 10:12:56', NULL, NULL),
(12, 'john1', 'john@gmail.com', '$2y$10$3/nvsR1zK.15vnruImda9uD/GRCEKS5uSDZ0bXjA1NiAYKKhEGvB6', 'customer', '2025-11-22 10:16:18', NULL, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `parcels`
--
ALTER TABLE `parcels`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `parcel_code` (`parcel_code`),
  ADD KEY `ranch_id` (`ranch_id`);

--
-- Indexes for table `parcel_tracks`
--
ALTER TABLE `parcel_tracks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `parcel_id` (`parcel_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ranches`
--
ALTER TABLE `ranches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `system_settings`
--
ALTER TABLE `system_settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `setting_key` (`setting_key`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `parcels`
--
ALTER TABLE `parcels`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `parcel_tracks`
--
ALTER TABLE `parcel_tracks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `ranches`
--
ALTER TABLE `ranches`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `system_settings`
--
ALTER TABLE `system_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `parcels`
--
ALTER TABLE `parcels`
  ADD CONSTRAINT `parcels_ibfk_1` FOREIGN KEY (`ranch_id`) REFERENCES `ranches` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `parcel_tracks`
--
ALTER TABLE `parcel_tracks`
  ADD CONSTRAINT `parcel_tracks_ibfk_1` FOREIGN KEY (`parcel_id`) REFERENCES `parcels` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
