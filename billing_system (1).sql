-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 29, 2025 at 07:26 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `billing_system`
--

-- --------------------------------------------------------

--
-- Table structure for table `bills`
--

CREATE TABLE `bills` (
  `id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `status` enum('pending','paid','cancelled') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bills`
--

INSERT INTO `bills` (`id`, `client_id`, `total`, `status`, `created_at`, `updated_at`) VALUES
(1, 2, 1000.00, 'pending', '2025-01-10 10:15:19', '2025-03-22 22:26:09'),
(2, 2, 158.00, 'pending', '2025-01-10 10:33:31', '2025-01-10 10:33:31'),
(3, 2, 200.00, 'pending', '2025-01-10 15:04:30', '2025-03-22 22:25:44'),
(4, 2, 1000.00, 'pending', '2025-03-11 05:05:16', '2025-03-11 05:05:16'),
(5, 2, 1000.00, 'pending', '2025-03-22 22:26:59', '2025-03-22 22:26:59');

-- --------------------------------------------------------

--
-- Table structure for table `bill_items`
--

CREATE TABLE `bill_items` (
  `id` int(11) NOT NULL,
  `bill_id` int(11) NOT NULL,
  `product_id` int(11) DEFAULT NULL,
  `quantity` int(11) NOT NULL,
  `custom_item_name` varchar(100) DEFAULT NULL,
  `qty` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bill_items`
--

INSERT INTO `bill_items` (`id`, `bill_id`, `product_id`, `quantity`, `custom_item_name`, `qty`, `price`) VALUES
(1, 2, NULL, 1, NULL, 0, 79.00),
(2, 2, NULL, 1, NULL, 0, 79.00),
(4, 4, 4, 10, NULL, 0, 100.00),
(5, 3, 4, 2, NULL, 0, 100.00),
(7, 1, 4, 10, NULL, 0, 100.00),
(8, 5, 4, 10, NULL, 0, 100.00);

-- --------------------------------------------------------

--
-- Table structure for table `branding`
--

CREATE TABLE `branding` (
  `id` int(11) NOT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `address` text NOT NULL,
  `phone` varchar(20) NOT NULL,
  `email` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `branding`
--

INSERT INTO `branding` (`id`, `logo`, `name`, `address`, `phone`, `email`, `created_at`, `updated_at`) VALUES
(1, 'Logo_SneakAPick.png', 'SneakAPick', 'Default Address Herer e', '8530869938', 'support@sneakapick.in', '2025-01-10 10:31:05', '2025-03-22 22:14:52');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `description`, `price`, `image`, `photo`, `created_at`, `updated_at`) VALUES
(4, 'Tshirt', '180 GSM Tshirt, Regular Fit, M', 100.00, '2.jpg', NULL, '2025-01-10 14:40:54', '2025-03-22 21:41:14'),
(5, 'Premium Cotton T-Shirt', '180 GSM, Regular Fit, multiple colors & sizes', 499.00, '2.jpg', NULL, '2025-03-29 06:17:46', '2025-03-29 06:18:12'),
(6, 'Custom Printed Hoodie', 'Soft fleece, unisex, customizable design', 999.00, '1.jpg', NULL, '2025-03-29 06:17:46', '2025-03-29 06:18:30'),
(7, 'Personalized Coffee Mug', 'High-quality ceramic, heat-resistant print', 299.00, NULL, NULL, '2025-03-29 06:17:46', '2025-03-29 06:17:46'),
(8, 'Customized Phone Case', 'Shockproof, available for various phone models', 399.00, NULL, NULL, '2025-03-29 06:17:46', '2025-03-29 06:17:46'),
(9, 'Printed Tote Bag', 'Eco-friendly cotton bag with custom designs', 349.00, NULL, NULL, '2025-03-29 06:17:46', '2025-03-29 06:17:46'),
(10, 'Personalized Cap', 'Adjustable snapback, embroidered or printed design', 449.00, '6.jpg', NULL, '2025-03-29 06:17:46', '2025-03-29 06:19:17'),
(11, 'Customized Notebook', 'Spiral-bound, premium pages, personalized cover', 299.00, NULL, NULL, '2025-03-29 06:17:46', '2025-03-29 06:17:46'),
(12, 'Printed Mouse Pad', 'Anti-slip rubber base, high-quality print surface', 249.00, NULL, NULL, '2025-03-29 06:17:46', '2025-03-29 06:17:46'),
(13, 'Custom Wall Poster', 'High-resolution print on thick, glossy paper', 199.00, NULL, NULL, '2025-03-29 06:17:46', '2025-03-29 06:17:46'),
(14, 'Personalized Keychain', 'Durable acrylic or metal with custom engraving', 149.00, NULL, NULL, '2025-03-29 06:17:46', '2025-03-29 06:17:46');

-- --------------------------------------------------------

--
-- Table structure for table `requests`
--

CREATE TABLE `requests` (
  `id` int(11) NOT NULL,
  `bill_id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `message` text NOT NULL,
  `request_type` enum('update_status','update_data') NOT NULL,
  `description` text DEFAULT NULL,
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `requests`
--

INSERT INTO `requests` (`id`, `bill_id`, `client_id`, `message`, `request_type`, `description`, `status`, `created_at`) VALUES
(1, 2, 2, 'Request to update products', 'update_status', NULL, 'approved', '2025-01-10 11:31:49'),
(2, 4, 2, 'add 1 more', 'update_status', NULL, 'approved', '2025-03-11 05:07:32'),
(3, 4, 2, 'Increase Qty by 1', 'update_status', NULL, 'pending', '2025-03-22 22:05:20');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','client') NOT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `role`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Abhishek Gade', 'gadeabhishek70@gmail.com', '$2y$10$P6Zz2NCXu60oXh1bzbiOwuK7Gy83rUuHVZgIAgTbzCnVwAcopaQMe', 'admin', 'active', '2025-01-10 08:38:50', '2025-01-10 08:41:56'),
(2, 'Abhishek G', 'gadeabhishek71@gmail.com', '$2y$10$HzBqSjn76LvYODxZ7PAfeOgZi/gHK4PmcfRhyYQFhvosf9LTHIlG2', 'client', 'active', '2025-01-10 09:22:41', '2025-01-10 09:22:41');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bills`
--
ALTER TABLE `bills`
  ADD PRIMARY KEY (`id`),
  ADD KEY `client_id` (`client_id`);

--
-- Indexes for table `bill_items`
--
ALTER TABLE `bill_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `bill_id` (`bill_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `branding`
--
ALTER TABLE `branding`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `requests`
--
ALTER TABLE `requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `bill_id` (`bill_id`),
  ADD KEY `client_id` (`client_id`);

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
-- AUTO_INCREMENT for table `bills`
--
ALTER TABLE `bills`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `bill_items`
--
ALTER TABLE `bill_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `branding`
--
ALTER TABLE `branding`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `requests`
--
ALTER TABLE `requests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bills`
--
ALTER TABLE `bills`
  ADD CONSTRAINT `bills_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `bill_items`
--
ALTER TABLE `bill_items`
  ADD CONSTRAINT `bill_items_ibfk_1` FOREIGN KEY (`bill_id`) REFERENCES `bills` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `bill_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `requests`
--
ALTER TABLE `requests`
  ADD CONSTRAINT `requests_ibfk_1` FOREIGN KEY (`bill_id`) REFERENCES `bills` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `requests_ibfk_2` FOREIGN KEY (`client_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
