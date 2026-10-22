-- ========================================================
-- FlavorFleet Food Delivery Platform - Database Schema & Seed Data
-- Database Engine: MySQL 8.0+ / 9.0+
-- Database Name: flavorfleet
-- ========================================================

CREATE DATABASE IF NOT EXISTS `flavorfleet`
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE `flavorfleet`;

-- --------------------------------------------------------
-- 1. Table structure for table `users`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `orderitem`;
DROP TABLE IF EXISTS `orders`;
DROP TABLE IF EXISTS `menu`;
DROP TABLE IF EXISTS `restaurant`;
DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
    `userId` INT AUTO_INCREMENT PRIMARY KEY,
    `username` VARCHAR(100) NOT NULL,
    `password` VARCHAR(255) NOT NULL,
    `email` VARCHAR(150) NOT NULL UNIQUE,
    `phone` VARCHAR(20),
    `address` TEXT,
    `role` VARCHAR(50) DEFAULT 'Customer',
    `createdDate` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- 2. Table structure for table `restaurant`
-- --------------------------------------------------------
CREATE TABLE `restaurant` (
    `restaurantId` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(150) NOT NULL,
    `cuisineType` VARCHAR(100) NOT NULL,
    `deliveryTime` INT NOT NULL DEFAULT 30,
    `address` VARCHAR(255) NOT NULL,
    `adminUserId` INT DEFAULT 1,
    `rating` DECIMAL(3, 1) DEFAULT 4.5,
    `isActive` BOOLEAN DEFAULT TRUE,
    `imagePath` VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- 3. Table structure for table `menu`
-- --------------------------------------------------------
CREATE TABLE `menu` (
    `menuId` INT AUTO_INCREMENT PRIMARY KEY,
    `restaurantId` INT NOT NULL,
    `itemName` VARCHAR(150) NOT NULL,
    `description` TEXT,
    `price` DECIMAL(10, 2) NOT NULL,
    `isAvailable` BOOLEAN DEFAULT TRUE,
    `imagePath` VARCHAR(255),
    CONSTRAINT `fk_menu_restaurant`
        FOREIGN KEY (`restaurantId`) REFERENCES `restaurant` (`restaurantId`)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- 4. Table structure for table `orders`
-- --------------------------------------------------------
CREATE TABLE `orders` (
    `orderId` INT AUTO_INCREMENT PRIMARY KEY,
    `restaurantId` INT NOT NULL,
    `userId` INT NOT NULL,
    `totalAmount` DECIMAL(10, 2) NOT NULL,
    `status` VARCHAR(50) DEFAULT 'Placed',
    `paymentMode` VARCHAR(50) DEFAULT 'Cash On Delivery',
    `orderDate` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_orders_restaurant`
        FOREIGN KEY (`restaurantId`) REFERENCES `restaurant` (`restaurantId`)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `fk_orders_user`
        FOREIGN KEY (`userId`) REFERENCES `users` (`userId`)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- 5. Table structure for table `orderitem`
-- --------------------------------------------------------
CREATE TABLE `orderitem` (
    `orderItemId` INT AUTO_INCREMENT PRIMARY KEY,
    `orderId` INT NOT NULL,
    `menuId` INT NOT NULL,
    `quantity` INT NOT NULL DEFAULT 1,
    `itemTotal` DECIMAL(10, 2) NOT NULL,
    CONSTRAINT `fk_orderitem_orders`
        FOREIGN KEY (`orderId`) REFERENCES `orders` (`orderId`)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `fk_orderitem_menu`
        FOREIGN KEY (`menuId`) REFERENCES `menu` (`menuId`)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========================================================
-- Seed Data for Testing & Demonstration
-- Passwords are hashed with jBCrypt (default password: password123)
-- ========================================================

-- Insert Demo Users
INSERT INTO `users` (`username`, `password`, `email`, `phone`, `address`, `role`) VALUES
('John Doe', '$2a$12$C9IOqDEAEWqMTngJ.X6mouv0nRHk.bzzn4dCyDAe7PzxHBZzELe1C', 'john@example.com', '9876543210', 'BTM Layout 2nd Stage, Bengaluru', 'Customer'),
('Admin User', '$2a$12$C9IOqDEAEWqMTngJ.X6mouv0nRHk.bzzn4dCyDAe7PzxHBZzELe1C', 'admin@flavorfleet.com', '9876500000', 'MG Road, Bengaluru', 'Admin');

-- Insert Sample Restaurants
INSERT INTO `restaurant` (`restaurantId`, `name`, `cuisineType`, `deliveryTime`, `address`, `adminUserId`, `rating`, `isActive`, `imagePath`) VALUES
(1, 'Meghana Foods', 'Biryani, Andhra, South Indian', 30, 'Koramangala 5th Block, Bengaluru', 1, 4.8, 1, 'images/restaurants/meghana-foods.jpg'),
(2, 'Empire Restaurant', 'North Indian, Mughlai, Kebabs', 35, 'Church Street, Bengaluru', 1, 4.6, 1, 'images/restaurants/empire-restaurant.jpg'),
(3, 'Truffles', 'Burgers, American, Continental', 25, 'St. Marks Road, Bengaluru', 1, 4.7, 1, 'images/restaurants/truffles.jpg'),
(4, 'Udupi Grand', 'South Indian, Pure Veg, Breakfast', 20, 'BTM Layout, Bengaluru', 1, 4.5, 1, 'images/restaurants/udupi-grand.jpg'),
(5, 'Punjabi Tandoor', 'North Indian, Tandoori, Curries', 40, 'Indiranagar 100ft Road, Bengaluru', 1, 4.6, 1, 'images/restaurants/punjabi-tandoor.jpg'),
(6, 'Wok & Roll', 'Pan-Asian, Chinese, Thai', 30, 'HSR Layout Sector 3, Bengaluru', 1, 4.4, 1, 'images/restaurants/wok-and-roll.jpg');

-- Insert Sample Menu Items
INSERT INTO `menu` (`restaurantId`, `itemName`, `description`, `price`, `isAvailable`, `imagePath`) VALUES
(1, 'Meghana Special Chicken Biryani', 'Slow-cooked aromatic basmati rice layered with spicy boneless chicken pieces and rich Andhra spices.', 320.00, 1, 'images/menu/meghana-special-chicken-biryani.jpg'),
(1, 'Paneer Biryani', 'Fragrant biryani rice served with succulent marinated paneer cubes and fried onions.', 260.00, 1, 'images/menu/meghana-paneer-biryani.jpg'),
(1, 'Chicken 65', 'Crispy deep-fried chicken cubes tossed with curry leaves, green chillies and spicy red masala.', 240.00, 1, 'images/menu/meghana-chicken-65.jpg'),

(2, 'Empire Special Butter Chicken', 'Tender tandoori chicken simmered in rich, velvety tomato and butter gravy with fresh cream.', 310.00, 1, 'images/menu/empire-butter-chicken.jpg'),
(2, 'Chicken Tikka Kebab', 'Juicy boneless chicken marinated in yogurt and tandoori spices, char-grilled to perfection.', 260.00, 1, 'images/menu/empire-chicken-tikka.jpg'),
(2, 'Garlic Butter Naan', 'Soft clay-oven baked bread infused with roasted garlic and brushed with melted butter.', 55.00, 1, 'images/menu/empire-garlic-naan.jpg'),

(3, 'All American Cheese Burger', 'Juicy grilled patty topped with melted cheddar, lettuce, tomatoes, and house secret sauce.', 240.00, 1, 'images/menu/truffles-burger.jpg'),
(3, 'Crispy Peri Peri Fries', 'Golden french fries tossed with spicy peri peri seasoning, served with garlic mayo dip.', 130.00, 1, 'images/menu/truffles-fries.jpg'),
(3, 'Ferrero Rocher Shake', 'Decadent chocolate hazelnut milkshake topped with whipped cream and crushed wafers.', 190.00, 1, 'images/menu/truffles-shake.jpg'),

(4, 'Crispy Masala Dosa', 'Golden brown crepe made from fermented batter, smeared with spiced potato mash and served with chutneys.', 90.00, 1, 'images/menu/udupi-masala-dosa.jpg'),
(4, 'Medu Vada (2 Pcs)', 'Crispy on the outside, fluffy on the inside savoury lentil fritters served with hot sambar.', 70.00, 1, 'images/menu/udupi-meduvada.jpg'),
(4, 'South Indian Filter Coffee', 'Freshly brewed aromatic chicory blend frothed with hot milk in traditional brass dabara.', 45.00, 1, 'images/menu/udupi-coffee.jpg'),

(5, 'Paneer Tikka Masala', 'Char-grilled cottage cheese cubes simmered in a spiced onion-tomato gravy with capsicum.', 260.00, 1, 'images/menu/punjabi-tandoor-paneer-tikka-masala.jpg'),
(5, 'Dal Makhani', 'Slow-cooked whole black lentils and kidney beans enriched with butter and fresh cream.', 210.00, 1, 'images/menu/punjabi-tandoor-dal-makhani.jpg'),
(5, 'Amritsari Kulcha', 'Flaky stuffed flatbread baked in tandoor served with spicy chole and pickled onions.', 120.00, 1, 'images/menu/punjabi-tandoor-amritsari-kulcha.jpg'),

(6, 'Vegetable Hakka Noodles', 'Wok-tossed stir fry noodles with crunchy shredded vegetables and oriental seasonings.', 180.00, 1, 'images/menu/wok-vegetable-hakka-noodles.jpg'),
(6, 'Chilli Paneer Dry', 'Crispy fried cottage cheese cubes tossed with capsicum, spring onions and spicy soy sauce.', 220.00, 1, 'images/menu/wok-chilli-paneer.jpg'),
(6, 'Vegetable Spring Rolls', 'Crispy golden rolls filled with shredded glass noodles and julienned vegetables.', 160.00, 1, 'images/menu/wok-vegetable-spring-rolls.jpg');
