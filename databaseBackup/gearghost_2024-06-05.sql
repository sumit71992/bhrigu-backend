-- MySQL dump 10.13  Distrib 8.3.0, for macos14.2 (x86_64)
--
-- Host: localhost    Database: gearghost
-- ------------------------------------------------------
-- Server version	8.3.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `AddedCharge`
--

DROP TABLE IF EXISTS `AddedCharge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `AddedCharge` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `orderId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `chargeType` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` decimal(65,30) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `AddedCharge_orderId_fkey` (`orderId`),
  CONSTRAINT `AddedCharge_orderId_fkey` FOREIGN KEY (`orderId`) REFERENCES `Order` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AddedCharge`
--

LOCK TABLES `AddedCharge` WRITE;
/*!40000 ALTER TABLE `AddedCharge` DISABLE KEYS */;
/*!40000 ALTER TABLE `AddedCharge` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `AuthorizedPerson`
--

DROP TABLE IF EXISTS `AuthorizedPerson`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `AuthorizedPerson` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `userId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `orderId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mobileNumber` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `AuthorizedPerson_userId_fkey` (`userId`),
  KEY `AuthorizedPerson_orderId_fkey` (`orderId`),
  CONSTRAINT `AuthorizedPerson_orderId_fkey` FOREIGN KEY (`orderId`) REFERENCES `Order` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `AuthorizedPerson_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AuthorizedPerson`
--

LOCK TABLES `AuthorizedPerson` WRITE;
/*!40000 ALTER TABLE `AuthorizedPerson` DISABLE KEYS */;
/*!40000 ALTER TABLE `AuthorizedPerson` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Cart`
--

DROP TABLE IF EXISTS `Cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Cart` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `totalItemCost` decimal(65,30) NOT NULL,
  `totalCost` decimal(65,30) NOT NULL,
  `communityCost` decimal(65,30) DEFAULT NULL,
  `insuranceCost` decimal(65,30) DEFAULT NULL,
  `insuranceNames` json DEFAULT NULL,
  `totalExtraCharges` decimal(65,30) DEFAULT NULL,
  `userId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `extraCharges` json DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `endDate` datetime(3) NOT NULL,
  `startDate` datetime(3) NOT NULL,
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Cart_userId_key` (`userId`),
  CONSTRAINT `Cart_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Cart`
--

LOCK TABLES `Cart` WRITE;
/*!40000 ALTER TABLE `Cart` DISABLE KEYS */;
/*!40000 ALTER TABLE `Cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Chat`
--

DROP TABLE IF EXISTS `Chat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Chat` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `admin` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lastMessage` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `participants` json NOT NULL,
  `deletedBy` json DEFAULT NULL,
  `notificationMuted` json DEFAULT NULL,
  `type` enum('PRIVACY','COMMUNITY','TERMS') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PRIVACY',
  `description` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Chat_admin_fkey` (`admin`),
  CONSTRAINT `Chat_admin_fkey` FOREIGN KEY (`admin`) REFERENCES `User` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Chat`
--

LOCK TABLES `Chat` WRITE;
/*!40000 ALTER TABLE `Chat` DISABLE KEYS */;
/*!40000 ALTER TABLE `Chat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ContactUs`
--

DROP TABLE IF EXISTS `ContactUs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ContactUs` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `firstName` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `lastName` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subjectId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `userId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ContactUs_subjectId_fkey` (`subjectId`),
  KEY `ContactUs_userId_fkey` (`userId`),
  CONSTRAINT `ContactUs_subjectId_fkey` FOREIGN KEY (`subjectId`) REFERENCES `Subject` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `ContactUs_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ContactUs`
--

LOCK TABLES `ContactUs` WRITE;
/*!40000 ALTER TABLE `ContactUs` DISABLE KEYS */;
/*!40000 ALTER TABLE `ContactUs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FeesAndCharges`
--

DROP TABLE IF EXISTS `FeesAndCharges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `FeesAndCharges` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `vendorId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `chargeType` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` decimal(65,30) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FeesAndCharges_vendorId_fkey` (`vendorId`),
  CONSTRAINT `FeesAndCharges_vendorId_fkey` FOREIGN KEY (`vendorId`) REFERENCES `Vendor` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FeesAndCharges`
--

LOCK TABLES `FeesAndCharges` WRITE;
/*!40000 ALTER TABLE `FeesAndCharges` DISABLE KEYS */;
/*!40000 ALTER TABLE `FeesAndCharges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `HelpDesk`
--

DROP TABLE IF EXISTS `HelpDesk`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `HelpDesk` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `helpDeskTypeId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `question` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `answer` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `HelpDesk_helpDeskTypeId_fkey` (`helpDeskTypeId`),
  CONSTRAINT `HelpDesk_helpDeskTypeId_fkey` FOREIGN KEY (`helpDeskTypeId`) REFERENCES `HelpDeskType` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `HelpDesk`
--

LOCK TABLES `HelpDesk` WRITE;
/*!40000 ALTER TABLE `HelpDesk` DISABLE KEYS */;
/*!40000 ALTER TABLE `HelpDesk` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `HelpDeskType`
--

DROP TABLE IF EXISTS `HelpDeskType`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `HelpDeskType` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `HelpDeskType`
--

LOCK TABLES `HelpDeskType` WRITE;
/*!40000 ALTER TABLE `HelpDeskType` DISABLE KEYS */;
/*!40000 ALTER TABLE `HelpDeskType` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `IncludedKit`
--

DROP TABLE IF EXISTS `IncludedKit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `IncludedKit` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `IncludedKit_name_key` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `IncludedKit`
--

LOCK TABLES `IncludedKit` WRITE;
/*!40000 ALTER TABLE `IncludedKit` DISABLE KEYS */;
/*!40000 ALTER TABLE `IncludedKit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Inventory`
--

DROP TABLE IF EXISTS `Inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Inventory` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` int NOT NULL,
  `availableQuantity` int NOT NULL,
  `includedKitId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Inventory_includedKitId_fkey` (`includedKitId`),
  CONSTRAINT `Inventory_includedKitId_fkey` FOREIGN KEY (`includedKitId`) REFERENCES `IncludedKit` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Inventory`
--

LOCK TABLES `Inventory` WRITE;
/*!40000 ALTER TABLE `Inventory` DISABLE KEYS */;
/*!40000 ALTER TABLE `Inventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Log`
--

DROP TABLE IF EXISTS `Log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Log` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `userId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `route` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `method` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ipAddress` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `browser` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `device` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `os` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `message` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Log_userId_fkey` (`userId`),
  CONSTRAINT `Log_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Log`
--

LOCK TABLES `Log` WRITE;
/*!40000 ALTER TABLE `Log` DISABLE KEYS */;
/*!40000 ALTER TABLE `Log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Message`
--

DROP TABLE IF EXISTS `Message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Message` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sender` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `chatId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `message` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `readStatus` tinyint(1) NOT NULL DEFAULT '0',
  `media` json NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Message_sender_fkey` (`sender`),
  KEY `Message_chatId_fkey` (`chatId`),
  CONSTRAINT `Message_chatId_fkey` FOREIGN KEY (`chatId`) REFERENCES `Chat` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Message_sender_fkey` FOREIGN KEY (`sender`) REFERENCES `User` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Message`
--

LOCK TABLES `Message` WRITE;
/*!40000 ALTER TABLE `Message` DISABLE KEYS */;
/*!40000 ALTER TABLE `Message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Notification`
--

DROP TABLE IF EXISTS `Notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Notification` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `senderId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `receiverId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `message` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` json DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Notification_senderId_fkey` (`senderId`),
  KEY `Notification_receiverId_fkey` (`receiverId`),
  CONSTRAINT `Notification_receiverId_fkey` FOREIGN KEY (`receiverId`) REFERENCES `User` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Notification_senderId_fkey` FOREIGN KEY (`senderId`) REFERENCES `User` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Notification`
--

LOCK TABLES `Notification` WRITE;
/*!40000 ALTER TABLE `Notification` DISABLE KEYS */;
/*!40000 ALTER TABLE `Notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Order`
--

DROP TABLE IF EXISTS `Order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Order` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `communityCost` decimal(65,30) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `discounts` json DEFAULT NULL,
  `extraCharges` json DEFAULT NULL,
  `insuranceCost` decimal(65,30) DEFAULT NULL,
  `insuranceNames` json DEFAULT NULL,
  `items` json NOT NULL,
  `status` enum('PENDING','COMPLETED','PAID','CANCELLED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING',
  `totalCost` decimal(65,30) NOT NULL,
  `totalExtraCharges` decimal(65,30) DEFAULT NULL,
  `totalItemCost` decimal(65,30) NOT NULL,
  `updatedAt` datetime(3) NOT NULL,
  `insuranceData` json DEFAULT NULL,
  `insuranceId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `paymentMethod` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `userId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vendorId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Order_userId_fkey` (`userId`),
  KEY `Order_vendorId_fkey` (`vendorId`),
  CONSTRAINT `Order_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Order_vendorId_fkey` FOREIGN KEY (`vendorId`) REFERENCES `Vendor` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Order`
--

LOCK TABLES `Order` WRITE;
/*!40000 ALTER TABLE `Order` DISABLE KEYS */;
/*!40000 ALTER TABLE `Order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `OrderCheckIn`
--

DROP TABLE IF EXISTS `OrderCheckIn`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `OrderCheckIn` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `userId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `orderId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `feedback` json NOT NULL,
  `missingItems` json DEFAULT NULL,
  `totalmissingItemCost` decimal(65,30) DEFAULT NULL,
  `images` json DEFAULT NULL,
  `type` enum('CHECKIN','PICKUP') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PICKUP',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `OrderCheckIn_userId_fkey` (`userId`),
  KEY `OrderCheckIn_orderId_fkey` (`orderId`),
  CONSTRAINT `OrderCheckIn_orderId_fkey` FOREIGN KEY (`orderId`) REFERENCES `Order` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `OrderCheckIn_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `OrderCheckIn`
--

LOCK TABLES `OrderCheckIn` WRITE;
/*!40000 ALTER TABLE `OrderCheckIn` DISABLE KEYS */;
/*!40000 ALTER TABLE `OrderCheckIn` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Otp`
--

DROP TABLE IF EXISTS `Otp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Otp` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `userId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `otp` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('FORGOTPASSWORD','SIGNUP','LOGIN') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'SIGNUP',
  `status` enum('ACTIVE','INACTIVE','INPROGRESS') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ACTIVE',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Otp_userId_key` (`userId`),
  CONSTRAINT `Otp_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Otp`
--

LOCK TABLES `Otp` WRITE;
/*!40000 ALTER TABLE `Otp` DISABLE KEYS */;
INSERT INTO `Otp` VALUES ('7086d93b-ac0a-47aa-8dbd-c2a84cd0ef60','f634c890-c3c9-4e5f-a24e-793979d29ca0','8890','SIGNUP','INACTIVE','2024-06-03 12:36:29.746','2024-06-04 06:11:06.101'),('7211835b-ea86-4353-9ea7-9fa351e87fdc','1ec5b771-f8ce-46f4-a0e9-9424db68469d','5078','FORGOTPASSWORD','INACTIVE','2024-06-04 06:43:10.881','2024-06-04 08:54:38.635');
/*!40000 ALTER TABLE `Otp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Payout`
--

DROP TABLE IF EXISTS `Payout`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Payout` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `userId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vendorId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bankName` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `accountOwnerName` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `accountType` enum('SAVING','CURRENT') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'SAVING',
  `routingNumber` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `accountNumber` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Payout_userId_fkey` (`userId`),
  KEY `Payout_vendorId_fkey` (`vendorId`),
  CONSTRAINT `Payout_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Payout_vendorId_fkey` FOREIGN KEY (`vendorId`) REFERENCES `Vendor` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Payout`
--

LOCK TABLES `Payout` WRITE;
/*!40000 ALTER TABLE `Payout` DISABLE KEYS */;
/*!40000 ALTER TABLE `Payout` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Plan`
--

DROP TABLE IF EXISTS `Plan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Plan` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('MONTHLY','YEARLY','DAILY','WEEKLY') COLLATE utf8mb4_unicode_ci NOT NULL,
  `features` json DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Plan`
--

LOCK TABLES `Plan` WRITE;
/*!40000 ALTER TABLE `Plan` DISABLE KEYS */;
/*!40000 ALTER TABLE `Plan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Privacy`
--

DROP TABLE IF EXISTS `Privacy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Privacy` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('PRIVACY','COMMUNITY','TERMS') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PRIVACY',
  `description` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Privacy`
--

LOCK TABLES `Privacy` WRITE;
/*!40000 ALTER TABLE `Privacy` DISABLE KEYS */;
/*!40000 ALTER TABLE `Privacy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Product`
--

DROP TABLE IF EXISTS `Product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Product` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `userId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `venderId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `productCategoryId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `title` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `media` json NOT NULL,
  `document` json NOT NULL,
  `visibility` enum('PRIVATE','PUBLIC','DRAFT','CLOSED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PUBLIC',
  `specification` json NOT NULL,
  `sellPrice` decimal(65,30) DEFAULT NULL,
  `sellOfferPrice` json DEFAULT NULL,
  `sellDiscount` decimal(65,30) DEFAULT NULL,
  `dailyRentalPrice` decimal(65,30) DEFAULT NULL,
  `dailyRentalDiscount` decimal(65,30) DEFAULT NULL,
  `weeklyRentalPrice` decimal(65,30) DEFAULT NULL,
  `weeklyRentalDiscount` decimal(65,30) DEFAULT NULL,
  `rapidBook` tinyint(1) NOT NULL,
  `charge` json DEFAULT NULL,
  `type` enum('RENT','SELL','BOTH') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'RENT',
  `organizationCategory` json DEFAULT NULL,
  `tags` json DEFAULT NULL,
  `disableSameDayRental` tinyint(1) NOT NULL,
  `status` enum('AVAILABLE','OUTOFSTOCK','NOTAVAILABLE') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'AVAILABLE',
  `availableQuantity` int NOT NULL,
  `totalQuantity` int NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `replaceMentPrice` decimal(65,30) DEFAULT NULL,
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Product_userId_fkey` (`userId`),
  KEY `Product_venderId_fkey` (`venderId`),
  KEY `Product_productCategoryId_fkey` (`productCategoryId`),
  CONSTRAINT `Product_productCategoryId_fkey` FOREIGN KEY (`productCategoryId`) REFERENCES `ProductCategory` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Product_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Product_venderId_fkey` FOREIGN KEY (`venderId`) REFERENCES `Vendor` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Product`
--

LOCK TABLES `Product` WRITE;
/*!40000 ALTER TABLE `Product` DISABLE KEYS */;
/*!40000 ALTER TABLE `Product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ProductCategory`
--

DROP TABLE IF EXISTS `ProductCategory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ProductCategory` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `totalOrders` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `ProductCategory_name_key` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ProductCategory`
--

LOCK TABLES `ProductCategory` WRITE;
/*!40000 ALTER TABLE `ProductCategory` DISABLE KEYS */;
/*!40000 ALTER TABLE `ProductCategory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ProductIncludedKit`
--

DROP TABLE IF EXISTS `ProductIncludedKit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ProductIncludedKit` (
  `productId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `includedKitId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`productId`,`includedKitId`),
  KEY `ProductIncludedKit_includedKitId_fkey` (`includedKitId`),
  CONSTRAINT `ProductIncludedKit_includedKitId_fkey` FOREIGN KEY (`includedKitId`) REFERENCES `IncludedKit` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `ProductIncludedKit_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `Product` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ProductIncludedKit`
--

LOCK TABLES `ProductIncludedKit` WRITE;
/*!40000 ALTER TABLE `ProductIncludedKit` DISABLE KEYS */;
/*!40000 ALTER TABLE `ProductIncludedKit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Promotion`
--

DROP TABLE IF EXISTS `Promotion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Promotion` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price` decimal(65,30) NOT NULL,
  `days` int NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Promotion`
--

LOCK TABLES `Promotion` WRITE;
/*!40000 ALTER TABLE `Promotion` DISABLE KEYS */;
/*!40000 ALTER TABLE `Promotion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ReportOrderIssue`
--

DROP TABLE IF EXISTS `ReportOrderIssue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ReportOrderIssue` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `orderId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `userId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reason` json NOT NULL,
  `images` json DEFAULT NULL,
  `issues` json DEFAULT NULL,
  `description` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ReportOrderIssue_orderId_fkey` (`orderId`),
  KEY `ReportOrderIssue_userId_fkey` (`userId`),
  CONSTRAINT `ReportOrderIssue_orderId_fkey` FOREIGN KEY (`orderId`) REFERENCES `Order` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `ReportOrderIssue_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ReportOrderIssue`
--

LOCK TABLES `ReportOrderIssue` WRITE;
/*!40000 ALTER TABLE `ReportOrderIssue` DISABLE KEYS */;
/*!40000 ALTER TABLE `ReportOrderIssue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ReturnOrder`
--

DROP TABLE IF EXISTS `ReturnOrder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ReturnOrder` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `orderId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `userId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `images` json NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ReturnOrder_orderId_fkey` (`orderId`),
  KEY `ReturnOrder_userId_fkey` (`userId`),
  CONSTRAINT `ReturnOrder_orderId_fkey` FOREIGN KEY (`orderId`) REFERENCES `Order` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `ReturnOrder_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ReturnOrder`
--

LOCK TABLES `ReturnOrder` WRITE;
/*!40000 ALTER TABLE `ReturnOrder` DISABLE KEYS */;
/*!40000 ALTER TABLE `ReturnOrder` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Review`
--

DROP TABLE IF EXISTS `Review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Review` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `userId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vendorId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `productId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `orderId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rating` int NOT NULL,
  `text` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `images` json DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Review_userId_fkey` (`userId`),
  KEY `Review_vendorId_fkey` (`vendorId`),
  KEY `Review_productId_fkey` (`productId`),
  KEY `Review_orderId_fkey` (`orderId`),
  CONSTRAINT `Review_orderId_fkey` FOREIGN KEY (`orderId`) REFERENCES `Order` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Review_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `Product` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Review_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Review_vendorId_fkey` FOREIGN KEY (`vendorId`) REFERENCES `Vendor` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Review`
--

LOCK TABLES `Review` WRITE;
/*!40000 ALTER TABLE `Review` DISABLE KEYS */;
/*!40000 ALTER TABLE `Review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Role`
--

DROP TABLE IF EXISTS `Role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Role` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Role_name_key` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Role`
--

LOCK TABLES `Role` WRITE;
/*!40000 ALTER TABLE `Role` DISABLE KEYS */;
INSERT INTO `Role` VALUES ('1101ecc6-c606-4e50-be82-f7f86cdc786d','user');
/*!40000 ALTER TABLE `Role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Social`
--

DROP TABLE IF EXISTS `Social`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Social` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `userId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vendorId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Social_userId_fkey` (`userId`),
  KEY `Social_vendorId_fkey` (`vendorId`),
  CONSTRAINT `Social_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Social_vendorId_fkey` FOREIGN KEY (`vendorId`) REFERENCES `Vendor` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Social`
--

LOCK TABLES `Social` WRITE;
/*!40000 ALTER TABLE `Social` DISABLE KEYS */;
INSERT INTO `Social` VALUES ('01787683-d121-4c06-a720-afc44335cfa5','1ec5b771-f8ce-46f4-a0e9-9424db68469d','999ba098-cf02-4637-944a-9cf440d378bc','fb','fb.com'),('f780c0f3-01c6-495f-95d3-41c7ccc5e27f','1ec5b771-f8ce-46f4-a0e9-9424db68469d','999ba098-cf02-4637-944a-9cf440d378bc','tiktok','tiktok.com');
/*!40000 ALTER TABLE `Social` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `storeAmenties`
--

DROP TABLE IF EXISTS `storeAmenties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `storeAmenties` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `storeAmenties`
--

LOCK TABLES `storeAmenties` WRITE;
/*!40000 ALTER TABLE `storeAmenties` DISABLE KEYS */;
/*!40000 ALTER TABLE `storeAmenties` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Subject`
--

DROP TABLE IF EXISTS `Subject`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Subject` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Subject`
--

LOCK TABLES `Subject` WRITE;
/*!40000 ALTER TABLE `Subject` DISABLE KEYS */;
/*!40000 ALTER TABLE `Subject` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SubProductCategory`
--

DROP TABLE IF EXISTS `SubProductCategory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SubProductCategory` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `totalOrders` int NOT NULL DEFAULT '0',
  `productCategoryId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `SubProductCategory_name_key` (`name`),
  KEY `SubProductCategory_productCategoryId_fkey` (`productCategoryId`),
  CONSTRAINT `SubProductCategory_productCategoryId_fkey` FOREIGN KEY (`productCategoryId`) REFERENCES `ProductCategory` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SubProductCategory`
--

LOCK TABLES `SubProductCategory` WRITE;
/*!40000 ALTER TABLE `SubProductCategory` DISABLE KEYS */;
/*!40000 ALTER TABLE `SubProductCategory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Subscription`
--

DROP TABLE IF EXISTS `Subscription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Subscription` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `vendorId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `productId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `storePromotionId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `productPromotionId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `autoProductRenew` tinyint(1) NOT NULL,
  `autoStoreRenew` tinyint(1) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `expiryDate` datetime(3) NOT NULL,
  `planId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `subscriptionDate` datetime(3) NOT NULL,
  `updatedAt` datetime(3) NOT NULL,
  `userId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Subscription_vendorId_key` (`vendorId`),
  UNIQUE KEY `Subscription_productId_key` (`productId`),
  UNIQUE KEY `Subscription_userId_key` (`userId`),
  KEY `Subscription_storePromotionId_fkey` (`storePromotionId`),
  KEY `Subscription_productPromotionId_fkey` (`productPromotionId`),
  KEY `Subscription_planId_fkey` (`planId`),
  CONSTRAINT `Subscription_planId_fkey` FOREIGN KEY (`planId`) REFERENCES `Plan` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Subscription_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `Product` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Subscription_productPromotionId_fkey` FOREIGN KEY (`productPromotionId`) REFERENCES `Promotion` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Subscription_storePromotionId_fkey` FOREIGN KEY (`storePromotionId`) REFERENCES `Promotion` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Subscription_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Subscription_vendorId_fkey` FOREIGN KEY (`vendorId`) REFERENCES `Vendor` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Subscription`
--

LOCK TABLES `Subscription` WRITE;
/*!40000 ALTER TABLE `Subscription` DISABLE KEYS */;
/*!40000 ALTER TABLE `Subscription` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SuggestedProduct`
--

DROP TABLE IF EXISTS `SuggestedProduct`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SuggestedProduct` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `productId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `SuggestedProduct_productId_fkey` (`productId`),
  CONSTRAINT `SuggestedProduct_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `Product` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SuggestedProduct`
--

LOCK TABLES `SuggestedProduct` WRITE;
/*!40000 ALTER TABLE `SuggestedProduct` DISABLE KEYS */;
/*!40000 ALTER TABLE `SuggestedProduct` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `User`
--

DROP TABLE IF EXISTS `User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `User` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `firstName` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `isVisible` tinyint(1) NOT NULL DEFAULT '1',
  `lastName` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `middleName` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mobileNumber` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `roleId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `updatedAt` datetime(3) NOT NULL,
  `userName` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `online` tinyint(1) NOT NULL DEFAULT '0',
  `totalOrders` int NOT NULL DEFAULT '0',
  `totalSpent` decimal(65,30) NOT NULL DEFAULT '0.000000000000000000000000000000',
  `status` enum('ACTIVE','INACTIVE','EMAILOTPREQUIRED','MOBILEOTPREQUIRED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'EMAILOTPREQUIRED',
  `bio` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `coverPic` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `deviceToken` longtext COLLATE utf8mb4_unicode_ci,
  `jwtToken` longtext COLLATE utf8mb4_unicode_ci,
  `profilePic` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `User_email_key` (`email`),
  UNIQUE KEY `User_userName_key` (`userName`),
  UNIQUE KEY `User_mobileNumber_key` (`mobileNumber`),
  KEY `User_roleId_fkey` (`roleId`),
  CONSTRAINT `User_roleId_fkey` FOREIGN KEY (`roleId`) REFERENCES `Role` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User`
--

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
INSERT INTO `User` VALUES ('1ec5b771-f8ce-46f4-a0e9-9424db68469d','gearghost1@yopmail.com','$2b$10$B1AAR3fh2NaBE1KglrRPRetktk5UpWIRMo.K4XTBdH6bryBpoNuvO','2024-06-03 12:13:24.382','Sumit',1,'Singh',NULL,NULL,'1101ecc6-c606-4e50-be82-f7f86cdc786d','2024-06-04 09:07:25.354','sumit',0,0,0.000000000000000000000000000000,'ACTIVE',NULL,NULL,NULL,NULL,NULL),('f634c890-c3c9-4e5f-a24e-793979d29ca0','gearghost@yopmail.com','$2b$10$hRDlESdqrwXJQXPf4dEsA.EO/kc/StMHwX51wnCd1dFMIWbzDLixW','2024-06-03 12:36:29.746','Sumit',1,'Singh',NULL,NULL,'1101ecc6-c606-4e50-be82-f7f86cdc786d','2024-06-04 06:38:51.082','sumit123',0,0,0.000000000000000000000000000000,'ACTIVE',NULL,NULL,NULL,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiJmNjM0Yzg5MC1jM2M5LTRlNWYtYTI0ZS03OTM5NzlkMjljYTAiLCJlbWFpbCI6ImdlYXJnaG9zdEB5b3BtYWlsLmNvbSIsImlhdCI6MTcxNzQ4MzEzMSwiZXhwIjoxNzE4Nzc5MTMxfQ.PCvg0GRYzEjQHwxSLH0-RF0fBKctXrYNSFjhDwvdxYY',NULL);
/*!40000 ALTER TABLE `User` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UserFavoriteRentProduct`
--

DROP TABLE IF EXISTS `UserFavoriteRentProduct`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `UserFavoriteRentProduct` (
  `userId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `productId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`userId`,`productId`),
  KEY `UserFavoriteRentProduct_productId_fkey` (`productId`),
  CONSTRAINT `UserFavoriteRentProduct_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `Product` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `UserFavoriteRentProduct_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UserFavoriteRentProduct`
--

LOCK TABLES `UserFavoriteRentProduct` WRITE;
/*!40000 ALTER TABLE `UserFavoriteRentProduct` DISABLE KEYS */;
/*!40000 ALTER TABLE `UserFavoriteRentProduct` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UserFavoriteSellProduct`
--

DROP TABLE IF EXISTS `UserFavoriteSellProduct`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `UserFavoriteSellProduct` (
  `userId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `productId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`userId`,`productId`),
  KEY `UserFavoriteSellProduct_productId_fkey` (`productId`),
  CONSTRAINT `UserFavoriteSellProduct_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `Product` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `UserFavoriteSellProduct_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UserFavoriteSellProduct`
--

LOCK TABLES `UserFavoriteSellProduct` WRITE;
/*!40000 ALTER TABLE `UserFavoriteSellProduct` DISABLE KEYS */;
/*!40000 ALTER TABLE `UserFavoriteSellProduct` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UserFavoriteVendors`
--

DROP TABLE IF EXISTS `UserFavoriteVendors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `UserFavoriteVendors` (
  `userId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `vendorId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`userId`,`vendorId`),
  KEY `UserFavoriteVendors_vendorId_fkey` (`vendorId`),
  CONSTRAINT `UserFavoriteVendors_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `UserFavoriteVendors_vendorId_fkey` FOREIGN KEY (`vendorId`) REFERENCES `Vendor` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UserFavoriteVendors`
--

LOCK TABLES `UserFavoriteVendors` WRITE;
/*!40000 ALTER TABLE `UserFavoriteVendors` DISABLE KEYS */;
/*!40000 ALTER TABLE `UserFavoriteVendors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Vendor`
--

DROP TABLE IF EXISTS `Vendor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Vendor` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `userId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `storeName` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mobileNumber` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `isContactVisible` tinyint(1) NOT NULL,
  `storeHours` json NOT NULL,
  `vacationDates` json DEFAULT NULL,
  `bussinessName` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bussinessIdNumber` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `businessState` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `socialsecurityNumber` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bannerPic` json NOT NULL,
  `profilePic` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `charge` json DEFAULT NULL,
  `city` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `country` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `isAddressVisible` tinyint(1) NOT NULL,
  `prepSpace` json DEFAULT NULL,
  `state` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('ACTIVE','INACTIVE','CREATED','IDVERIFIED','PAYMENTDONE') COLLATE utf8mb4_unicode_ci NOT NULL,
  `street` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `studioSpace` json DEFAULT NULL,
  `updatedAt` datetime(3) NOT NULL,
  `zipCode` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Vendor_email_key` (`email`),
  UNIQUE KEY `Vendor_mobileNumber_key` (`mobileNumber`),
  KEY `Vendor_userId_fkey` (`userId`),
  CONSTRAINT `Vendor_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Vendor`
--

LOCK TABLES `Vendor` WRITE;
/*!40000 ALTER TABLE `Vendor` DISABLE KEYS */;
INSERT INTO `Vendor` VALUES ('999ba098-cf02-4637-944a-9cf440d378bc','1ec5b771-f8ce-46f4-a0e9-9424db68469d','store1','gearghost@yopmail.com','+91-9387787865','popular store',1,'{\"friday\": {\"open\": \"09:00\", \"close\": \"23:00\"}, \"monday\": {\"open\": \"09:00\", \"close\": \"23:00\"}, \"sunday\": {\"open\": \"09:00\", \"close\": \"23:00\"}, \"tuesday\": {\"open\": \"09:00\", \"close\": \"23:00\"}, \"saturday\": {\"open\": \"09:00\", \"close\": \"23:00\"}, \"thursday\": {\"open\": \"09:00\", \"close\": \"23:00\"}, \"wednesday\": {\"open\": \"09:00\", \"close\": \"23:00\"}}',NULL,'store1','4556777','punjab',NULL,'[\"1\", \"2\"]','hi',NULL,'mohali','india','2024-06-04 12:26:11.949',1,NULL,'punjab','CREATED','mohali',NULL,'2024-06-04 12:26:11.949','807789');
/*!40000 ALTER TABLE `Vendor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `VendorDocuments`
--

DROP TABLE IF EXISTS `VendorDocuments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `VendorDocuments` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `vendorId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `street` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `state` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `zipCode` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` enum('RENTAL','PICKUP','COI') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'RENTAL',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `VendorDocuments_vendorId_fkey` (`vendorId`),
  CONSTRAINT `VendorDocuments_vendorId_fkey` FOREIGN KEY (`vendorId`) REFERENCES `Vendor` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `VendorDocuments`
--

LOCK TABLES `VendorDocuments` WRITE;
/*!40000 ALTER TABLE `VendorDocuments` DISABLE KEYS */;
/*!40000 ALTER TABLE `VendorDocuments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `VendorStoreAmenties`
--

DROP TABLE IF EXISTS `VendorStoreAmenties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `VendorStoreAmenties` (
  `vendorId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `storeAmentiesId` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`vendorId`,`storeAmentiesId`),
  KEY `VendorStoreAmenties_storeAmentiesId_fkey` (`storeAmentiesId`),
  CONSTRAINT `VendorStoreAmenties_storeAmentiesId_fkey` FOREIGN KEY (`storeAmentiesId`) REFERENCES `storeAmenties` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `VendorStoreAmenties_vendorId_fkey` FOREIGN KEY (`vendorId`) REFERENCES `Vendor` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `VendorStoreAmenties`
--

LOCK TABLES `VendorStoreAmenties` WRITE;
/*!40000 ALTER TABLE `VendorStoreAmenties` DISABLE KEYS */;
/*!40000 ALTER TABLE `VendorStoreAmenties` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Verification`
--

DROP TABLE IF EXISTS `Verification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Verification` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `userId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vendorId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `idVerification` tinyint(1) NOT NULL DEFAULT '0',
  `backgroundCheck` tinyint(1) NOT NULL DEFAULT '0',
  `phoneVerification` tinyint(1) NOT NULL DEFAULT '0',
  `emailVerification` tinyint(1) NOT NULL DEFAULT '0',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Verification_userId_fkey` (`userId`),
  KEY `Verification_vendorId_fkey` (`vendorId`),
  CONSTRAINT `Verification_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Verification_vendorId_fkey` FOREIGN KEY (`vendorId`) REFERENCES `Vendor` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Verification`
--

LOCK TABLES `Verification` WRITE;
/*!40000 ALTER TABLE `Verification` DISABLE KEYS */;
/*!40000 ALTER TABLE `Verification` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-06-05 10:06:00
