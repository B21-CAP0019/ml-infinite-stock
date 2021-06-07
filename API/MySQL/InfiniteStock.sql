-- MySQL dump 10.13  Distrib 8.0.25, for Win64 (x86_64)
--
-- Host: localhost    Database: infinitestock
-- ------------------------------------------------------
-- Server version	8.0.25

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `demandprediction`
--

DROP TABLE IF EXISTS `demandprediction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `demandprediction` (
  `deman_prediction_id` int NOT NULL AUTO_INCREMENT,
  `goods_id` int NOT NULL,
  `user_id` int NOT NULL,
  `day_1` float NOT NULL,
  `day_2` float NOT NULL,
  `day_3` float NOT NULL,
  `day_4` float NOT NULL,
  `day_5` float NOT NULL,
  `day_6` float NOT NULL,
  `day_7` float NOT NULL,
  `start_date_prediction` datetime NOT NULL,
  PRIMARY KEY (`deman_prediction_id`),
  KEY `goods_id` (`goods_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `demandprediction_ibfk_1` FOREIGN KEY (`goods_id`) REFERENCES `goods` (`goods_id`),
  CONSTRAINT `demandprediction_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `demandprediction`
--

LOCK TABLES `demandprediction` WRITE;
/*!40000 ALTER TABLE `demandprediction` DISABLE KEYS */;
INSERT INTO `demandprediction` VALUES (1,5,3,40,79.6,50,70,50,70,70,'2021-06-01 13:26:47'),(2,5,3,40,81,50,70,50,70,70,'2021-06-01 13:44:05'),(3,5,3,40,80.2,50,70,50,70,70,'2021-06-02 00:06:20'),(4,5,3,70,40,80,20,50,50,100,'2021-06-02 10:04:37'),(5,5,3,50,100,70,50,100,80,40,'2021-06-02 17:37:49');
/*!40000 ALTER TABLE `demandprediction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `goods`
--

DROP TABLE IF EXISTS `goods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `goods` (
  `goods_id` int NOT NULL AUTO_INCREMENT,
  `goods_name` varchar(150) NOT NULL,
  `goods_quantity` float NOT NULL,
  `goods_unit` varchar(30) DEFAULT NULL,
  `goods_price` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`goods_id`),
  UNIQUE KEY `goods_id` (`goods_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `goods_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `goods`
--

LOCK TABLES `goods` WRITE;
/*!40000 ALTER TABLE `goods` DISABLE KEYS */;
INSERT INTO `goods` VALUES (1,'Masako',40,'pcs',500,2),(2,'Tepung Ayam Sasa',600,'pcs',2000,2),(3,'Gula Jawa',5,'kg',3000,2),(4,'Tepung maizena',5,'kg',5000,2),(5,'Tepung Bumbu Sasa',680,'pcs',4000,3),(6,'Tepung Maizena',10,'kg',5000,9),(7,'Micin Ajinomoto',25,'pcs',700,2);
/*!40000 ALTER TABLE `goods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `historygoodsin`
--

DROP TABLE IF EXISTS `historygoodsin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historygoodsin` (
  `history_id` int NOT NULL AUTO_INCREMENT,
  `goods_id` int NOT NULL,
  `qty` float NOT NULL,
  `timeseries` datetime NOT NULL,
  PRIMARY KEY (`history_id`),
  UNIQUE KEY `history_id` (`history_id`),
  KEY `goods_id` (`goods_id`),
  CONSTRAINT `historygoodsin_ibfk_1` FOREIGN KEY (`goods_id`) REFERENCES `goods` (`goods_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historygoodsin`
--

LOCK TABLES `historygoodsin` WRITE;
/*!40000 ALTER TABLE `historygoodsin` DISABLE KEYS */;
INSERT INTO `historygoodsin` VALUES (1,2,50,'2021-06-07 15:07:47'),(2,2,60,'2021-06-07 15:15:46'),(3,2,110,'2021-06-07 15:15:52'),(4,2,280,'2021-06-07 15:15:59'),(5,5,200,'2021-06-07 15:19:40'),(6,5,80,'2021-06-07 15:19:46'),(7,5,200,'2021-06-07 15:19:49'),(8,3,3,'2021-06-07 15:24:27');
/*!40000 ALTER TABLE `historygoodsin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `public_id` varchar(80) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(200) NOT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `shop_name` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `public_id` (`public_id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `password` (`password`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'5f7f20c6-8bf2-4897-8620-2fec54fe4b0e','caca_handika@gmail.com','sha256$z44pu7Do$d4fda4dc1556234596a8f567fccb54f7c7d3110d56a230f8e26286d06bfd515d',NULL,NULL),(2,'fb6e58f7-f53b-4da5-b0e4-6e697203cbcc','junior_aldi@gmail.com','sha256$rdOKtQpv$b6d7a1035c6d3cb6c145327212888ae7fcf5b5f888c3ae15ea9e2cbcfbb26fe3',NULL,NULL),(3,'c434ab5f-6ad6-49b4-8303-348f6975bbf4','rakha_wisesa@yaya.com','sha256$CrSGuIpA$c4773641fa404dc38dd40ffd7dfe17810662c0c5d1bded07ccc505f581a4c99a',NULL,NULL),(4,'77543bc2-c51d-4402-aac2-faeb5a29d1dd','suryono@gmail.com','sha256$G5OD9K9K$2cebc2100388b995f79888a99d258ae02b175e98289f178e769d6cc4d839943d',NULL,NULL),(5,'e04aae95-763a-46b2-91e5-1037894e8bda','filma_augustine@gmail.com','sha256$AciJiZ1F$ff1f1f2744ae40dcf61685910669133af125971d9536acf10c69a1a336c925cd',NULL,NULL),(6,'9eb7242b-e37b-4759-8752-22687a97805f','maesaroh@gmail.com','sha256$oxNRW17V$5226346ee79fafd6c602102737952088a0318888873a5b4deb48d8305d194da5',NULL,NULL),(7,'879c709a-e0d8-485c-9cd0-a865910024f4','jono_junu@yaya.com','sha256$zL825jNn$6322344e41ba4b5f14e5143d1c6f4e99c290903733a66ef402809bfe369226b3',NULL,NULL),(8,'9008e44c-916a-4e5a-8072-92f4a684041c','thony_yaya@gmail.com','sha256$AfP9IuEw$43c9e748d398aad024e84df98cacdb2bdb7fcbb335a5b1726ea7183bc804cd01',NULL,NULL),(9,'0c8cb527-dda9-42b6-838e-480e74bbc913','surya_julio@yaya.com','sha256$hHC68Vie$de3239c34945d5fed1669c0cca9913c24bae94b2ea0c1dfb0f2a41834fd2c944',NULL,NULL),(13,'ba6420a3-596d-4c1d-853d-3fa091ecd1a8','rakha_wisesa@juman.com','sha256$TXQm1mxD$75047e54d41978e78296e6a2e0640d745a83b60374ff68c1c1a0629ea8d02ade',NULL,NULL);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `warehousedemand`
--

DROP TABLE IF EXISTS `warehousedemand`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `warehousedemand` (
  `demand_id` int NOT NULL AUTO_INCREMENT,
  `goods_id` int NOT NULL,
  `qty` float NOT NULL,
  `timeseries` datetime NOT NULL,
  PRIMARY KEY (`demand_id`),
  UNIQUE KEY `demand_id` (`demand_id`),
  KEY `goods_id` (`goods_id`),
  CONSTRAINT `warehousedemand_ibfk_1` FOREIGN KEY (`goods_id`) REFERENCES `goods` (`goods_id`)
) ENGINE=InnoDB AUTO_INCREMENT=164 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `warehousedemand`
--

LOCK TABLES `warehousedemand` WRITE;
/*!40000 ALTER TABLE `warehousedemand` DISABLE KEYS */;
INSERT INTO `warehousedemand` VALUES (1,1,100,'2021-06-01 02:25:10'),(2,1,50,'2021-06-01 02:25:36'),(3,1,80,'2021-06-01 02:25:53'),(4,1,100,'2021-06-01 02:26:24'),(5,1,40,'2021-06-01 02:26:37'),(6,1,60,'2021-06-01 02:26:58'),(7,1,120,'2021-06-01 02:27:25'),(8,1,60,'2021-06-01 02:27:40'),(9,1,80,'2021-06-01 02:27:45'),(10,5,100,'2021-06-01 12:58:26'),(11,5,40,'2021-06-01 12:58:49'),(12,5,60,'2021-06-01 12:59:16'),(13,5,100,'2021-06-01 12:59:21'),(14,5,50,'2021-06-01 12:59:30'),(15,5,60,'2021-06-01 12:59:37'),(16,5,90,'2021-06-01 12:59:42'),(17,5,100,'2021-06-01 12:59:46'),(18,5,40,'2021-06-01 12:59:56'),(19,5,60,'2021-06-01 13:00:07'),(20,5,60,'2021-06-01 13:00:14'),(21,5,40,'2021-06-01 13:00:20'),(22,5,100,'2021-06-01 13:00:27'),(23,5,91,'2021-06-01 13:00:43'),(24,5,59,'2021-06-01 13:00:52'),(25,5,60,'2021-06-01 13:01:01'),(26,5,90,'2021-06-01 13:01:05'),(27,5,100,'2021-06-01 13:01:12'),(28,5,50,'2021-06-01 13:01:18'),(29,5,70,'2021-06-01 13:01:24'),(30,5,180,'2021-06-01 13:01:46'),(31,5,50,'2021-06-01 13:02:05'),(32,5,100,'2021-06-01 13:02:10'),(33,5,150,'2021-06-01 13:02:17'),(34,5,50,'2021-06-01 13:03:53'),(35,5,150,'2021-06-01 13:04:13'),(36,5,70,'2021-06-01 13:04:21'),(37,5,30,'2021-06-01 13:04:25'),(38,5,20,'2021-06-01 13:04:40'),(39,5,80,'2021-06-01 13:04:44'),(40,5,50,'2021-06-01 13:04:49'),(41,5,50,'2021-06-01 13:04:54'),(42,5,100,'2021-06-01 13:04:59'),(43,5,50,'2021-06-01 13:05:04'),(44,5,50,'2021-06-01 13:05:08'),(45,5,80,'2021-06-01 13:05:14'),(46,5,20,'2021-06-01 13:05:19'),(47,5,100,'2021-06-01 13:05:27'),(48,5,20,'2021-06-01 13:05:36'),(49,5,80,'2021-06-01 13:05:40'),(50,5,70,'2021-06-01 13:05:48'),(51,5,100,'2021-06-01 13:05:56'),(52,5,30,'2021-06-01 13:06:00'),(53,5,50,'2021-06-01 13:06:18'),(54,5,30,'2021-06-01 13:06:24'),(55,5,20,'2021-06-01 13:06:33'),(56,5,50,'2021-06-01 13:06:40'),(57,5,50,'2021-06-01 13:06:45'),(58,5,100,'2021-06-01 13:06:56'),(59,5,50,'2021-06-01 13:07:12'),(60,5,70,'2021-06-01 13:07:18'),(61,5,80,'2021-06-01 13:07:21'),(62,5,80,'2021-06-01 13:07:27'),(63,5,20,'2021-06-01 13:07:31'),(64,5,50,'2021-06-01 13:07:38'),(65,5,50,'2021-06-01 13:07:43'),(66,5,80,'2021-06-01 13:07:50'),(67,5,70,'2021-06-01 13:07:58'),(68,5,70,'2021-06-01 13:08:12'),(69,5,80,'2021-06-01 13:08:18'),(70,5,100,'2021-06-01 13:08:26'),(71,5,40,'2021-06-01 13:08:38'),(72,5,90,'2021-06-01 13:08:45'),(73,5,70,'2021-06-01 13:08:52'),(74,5,70,'2021-06-01 13:08:58'),(75,5,30,'2021-06-01 13:09:02'),(76,5,70,'2021-06-01 13:09:08'),(77,5,70,'2021-06-01 13:09:15'),(78,5,60,'2021-06-01 13:09:21'),(79,5,100,'2021-06-01 13:09:27'),(80,5,50,'2021-06-01 13:09:32'),(81,5,70,'2021-06-01 13:09:39'),(82,5,40,'2021-06-01 13:09:47'),(83,5,90,'2021-06-01 13:10:01'),(84,5,50,'2021-06-01 13:10:06'),(85,5,50,'2021-06-01 13:10:16'),(86,5,50,'2021-06-01 13:10:21'),(87,5,100,'2021-06-01 13:10:26'),(88,5,50,'2021-06-01 13:10:32'),(89,5,50,'2021-06-01 13:10:37'),(90,5,60,'2021-06-01 13:10:43'),(91,5,60,'2021-06-01 13:10:52'),(92,5,80,'2021-06-01 13:10:58'),(93,5,80,'2021-06-01 13:11:02'),(94,5,40,'2021-06-01 13:11:37'),(95,5,40,'2021-06-01 13:11:41'),(96,5,60,'2021-06-01 13:11:47'),(97,5,30,'2021-06-01 13:11:53'),(98,5,50,'2021-06-01 13:11:58'),(99,5,20,'2021-06-01 13:12:06'),(100,5,50,'2021-06-01 13:12:11'),(101,5,30,'2021-06-01 13:12:15'),(102,5,100,'2021-06-01 13:12:26'),(103,5,50,'2021-06-01 13:12:32'),(104,5,130,'2021-06-01 13:12:40'),(105,5,70,'2021-06-01 13:12:48'),(106,5,50,'2021-06-01 13:12:54'),(107,5,100,'2021-06-01 13:12:59'),(108,5,80,'2021-06-01 13:13:18'),(109,5,40,'2021-06-01 13:13:31'),(110,5,80,'2021-06-01 13:13:35'),(111,5,80,'2021-06-01 13:13:41'),(112,5,70,'2021-06-01 13:13:47'),(113,5,50,'2021-06-01 13:13:50'),(114,5,80,'2021-06-01 13:13:59'),(115,5,50,'2021-06-01 13:14:25'),(116,5,70,'2021-06-01 13:14:29'),(117,5,50,'2021-06-01 13:15:43'),(118,5,70,'2021-06-01 13:15:50'),(119,5,80,'2021-06-01 13:15:55'),(120,5,50,'2021-06-01 13:16:02'),(121,5,60,'2021-06-01 13:16:09'),(122,5,90,'2021-06-01 13:16:13'),(123,5,70,'2021-06-01 13:16:22'),(124,5,30,'2021-06-01 13:16:26'),(125,5,60,'2021-06-01 13:16:33'),(126,5,70,'2021-06-01 13:16:39'),(127,5,70,'2021-06-01 13:16:43'),(128,5,30,'2021-06-01 13:16:51'),(129,5,70,'2021-06-01 13:16:55'),(130,5,20,'2021-06-01 13:17:01'),(131,5,80,'2021-06-01 13:22:28'),(132,5,50,'2021-06-02 09:59:54'),(133,5,90,'2021-06-02 10:00:14'),(134,5,40,'2021-06-02 10:00:18'),(135,5,70,'2021-06-02 10:00:25'),(136,5,50,'2021-06-02 10:00:29'),(137,5,70,'2021-06-02 10:00:35'),(138,5,10,'2021-06-02 10:00:40'),(139,5,90,'2021-06-02 10:00:45'),(140,5,30,'2021-06-02 10:00:49'),(141,5,40,'2021-06-02 10:00:56'),(142,5,60,'2021-06-02 10:01:01'),(143,5,70,'2021-06-02 10:01:10'),(144,5,30,'2021-06-02 10:01:15'),(145,5,60,'2021-06-02 10:01:20'),(146,5,40,'2021-06-02 10:01:24'),(147,5,50,'2021-06-02 10:01:30'),(148,5,90,'2021-06-02 10:01:38'),(149,5,40,'2021-06-02 10:01:43'),(150,5,60,'2021-06-02 10:01:49'),(151,5,30,'2021-06-02 10:01:53'),(152,5,30,'2021-06-02 10:01:57'),(153,5,100,'2021-06-02 10:02:02'),(154,5,40,'2021-06-02 10:02:07'),(155,5,60,'2021-06-02 10:02:11'),(156,5,50,'2021-06-02 10:02:16'),(157,5,30,'2021-06-02 10:02:20'),(158,5,60,'2021-06-02 10:02:27'),(159,5,60,'2021-06-02 10:02:31'),(160,5,40,'2021-06-02 10:02:37'),(161,5,40,'2021-06-02 10:02:40'),(162,5,300,'2021-06-02 16:30:42'),(163,3,3,'2021-06-07 13:13:23');
/*!40000 ALTER TABLE `warehousedemand` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-06-07 15:52:49
