-- MariaDB dump 10.19-11.0.2-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: holonet
-- ------------------------------------------------------
-- Server version	11.0.2-MariaDB-1:11.0.2+maria~ubu2204

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `armament`
--

DROP TABLE IF EXISTS `armament`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `armament` (
  `armament_id` smallint(5) unsigned DEFAULT NULL,
  `ammo` smallint(5) unsigned DEFAULT NULL,
  `weapon_id` tinyint(3) unsigned DEFAULT NULL,
  KEY `weapon_id` (`weapon_id`),
  CONSTRAINT `armament_ibfk_1` FOREIGN KEY (`weapon_id`) REFERENCES `weapon` (`weapon_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `complement`
--

DROP TABLE IF EXISTS `complement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `complement` (
  `complement_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `alias` varchar(128) DEFAULT NULL,
  `is_crew` tinyint(3) unsigned DEFAULT NULL,
  `requirement_id` smallint(5) unsigned DEFAULT NULL,
  PRIMARY KEY (`complement_id`),
  KEY `requirement_id` (`requirement_id`),
  CONSTRAINT `complement_ibfk_1` FOREIGN KEY (`requirement_id`) REFERENCES `requirements` (`requirement_id`)
) ENGINE=InnoDB AUTO_INCREMENT=96 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mod_requirements`
--

DROP TABLE IF EXISTS `mod_requirements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mod_requirements` (
  `mod_id` smallint(5) unsigned NOT NULL,
  `requirement_id` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`mod_id`,`requirement_id`),
  KEY `requirement_id` (`requirement_id`),
  CONSTRAINT `mod_requirements_ibfk_1` FOREIGN KEY (`mod_id`) REFERENCES `modification` (`mod_id`),
  CONSTRAINT `mod_requirements_ibfk_2` FOREIGN KEY (`requirement_id`) REFERENCES `requirements` (`requirement_id`),
  CONSTRAINT `mod_requirements_ibfk_3` FOREIGN KEY (`mod_id`) REFERENCES `modification` (`mod_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `modification`
--

DROP TABLE IF EXISTS `modification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `modification` (
  `mod_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) DEFAULT NULL,
  `modslots` tinyint(3) unsigned DEFAULT NULL,
  `is_refit` tinyint(3) unsigned DEFAULT NULL,
  `price` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`mod_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `privilege`
--

DROP TABLE IF EXISTS `privilege`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `privilege` (
  `privilege_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `privilege` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`privilege_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `requirements`
--

DROP TABLE IF EXISTS `requirements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `requirements` (
  `requirement_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `value1` varchar(32) DEFAULT NULL,
  `comparator` char(2) DEFAULT NULL,
  `value2` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`requirement_id`),
  KEY `stat_id` (`value1`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shop`
--

DROP TABLE IF EXISTS `shop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shop` (
  `shop_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `shop_name` varchar(128) DEFAULT NULL,
  `access` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`shop_id`)
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `skill`
--

DROP TABLE IF EXISTS `skill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `skill` (
  `skill_id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `skill` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`skill_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `strength`
--

DROP TABLE IF EXISTS `strength`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `strength` (
  `strength_no` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `str_description` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`strength_no`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `unit`
--

DROP TABLE IF EXISTS `unit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `unit` (
  `unit_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `unit_type` smallint(5) unsigned DEFAULT NULL,
  `name` varchar(128) DEFAULT NULL,
  `alias` varchar(32) DEFAULT NULL,
  `price` bigint(20) unsigned DEFAULT NULL,
  `modslots` tinyint(3) unsigned DEFAULT NULL,
  `uc_limit` smallint(5) unsigned DEFAULT NULL,
  `length` float DEFAULT NULL,
  `height` float DEFAULT NULL,
  `width` float DEFAULT NULL,
  `hyperdrive` float DEFAULT NULL,
  `backup` float DEFAULT NULL,
  `mglt` tinyint(3) unsigned DEFAULT NULL,
  `kmh` smallint(5) unsigned DEFAULT NULL,
  `shield` tinyint(3) unsigned DEFAULT NULL,
  `hull` tinyint(3) unsigned DEFAULT NULL,
  `sbd` smallint(5) unsigned DEFAULT NULL,
  `ru` smallint(5) unsigned DEFAULT NULL,
  `points` float DEFAULT NULL,
  `is_special` tinyint(3) unsigned DEFAULT NULL,
  `notes` varchar(1024) DEFAULT NULL,
  `wiki_link` varchar(128) DEFAULT NULL,
  `max_height` float DEFAULT NULL,
  `access` int(10) unsigned DEFAULT NULL,
  `mass` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`unit_id`),
  KEY `unit_type` (`unit_type`),
  KEY `shield` (`shield`),
  KEY `hull` (`hull`),
  CONSTRAINT `unit_ibfk_1` FOREIGN KEY (`unit_type`) REFERENCES `unit_type` (`unit_type`),
  CONSTRAINT `unit_ibfk_2` FOREIGN KEY (`shield`) REFERENCES `strength` (`strength_no`),
  CONSTRAINT `unit_ibfk_3` FOREIGN KEY (`hull`) REFERENCES `strength` (`strength_no`)
) ENGINE=InnoDB AUTO_INCREMENT=1223 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `unit_armament`
--

DROP TABLE IF EXISTS `unit_armament`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `unit_armament` (
  `unit_id` smallint(5) unsigned DEFAULT NULL,
  `armament_id` smallint(5) unsigned DEFAULT NULL,
  `battery_size` tinyint(3) unsigned DEFAULT NULL,
  `weapon_range` smallint(5) unsigned DEFAULT NULL,
  `firelink` tinyint(3) unsigned DEFAULT NULL,
  `weapon_type` varchar(128) DEFAULT NULL,
  `quantity` smallint(5) unsigned DEFAULT NULL,
  `direction` varchar(32) DEFAULT NULL,
  KEY `unit_id` (`unit_id`),
  KEY `armament_id` (`armament_id`),
  CONSTRAINT `unit_armament_ibfk_1` FOREIGN KEY (`unit_id`) REFERENCES `unit` (`unit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `unit_complement`
--

DROP TABLE IF EXISTS `unit_complement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `unit_complement` (
  `complement_id` smallint(5) unsigned NOT NULL,
  `quantity` float DEFAULT NULL,
  `unit_id` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`unit_id`,`complement_id`),
  KEY `complement_id` (`complement_id`),
  CONSTRAINT `unit_complement_ibfk_1` FOREIGN KEY (`unit_id`) REFERENCES `unit` (`unit_id`),
  CONSTRAINT `unit_complement_ibfk_2` FOREIGN KEY (`complement_id`) REFERENCES `complement` (`complement_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `unit_skill`
--

DROP TABLE IF EXISTS `unit_skill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `unit_skill` (
  `unit_id` smallint(5) unsigned NOT NULL,
  `skill_id` tinyint(3) unsigned NOT NULL,
  `value` tinyint(3) unsigned DEFAULT NULL,
  PRIMARY KEY (`unit_id`,`skill_id`),
  KEY `skill_id` (`skill_id`),
  CONSTRAINT `unit_skill_ibfk_1` FOREIGN KEY (`unit_id`) REFERENCES `unit` (`unit_id`),
  CONSTRAINT `unit_skill_ibfk_2` FOREIGN KEY (`skill_id`) REFERENCES `skill` (`skill_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `unit_type`
--

DROP TABLE IF EXISTS `unit_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `unit_type` (
  `unit_type` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `type_description` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`unit_type`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `units_in_shop`
--

DROP TABLE IF EXISTS `units_in_shop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `units_in_shop` (
  `shop_id` smallint(5) unsigned NOT NULL,
  `unit_id` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`shop_id`,`unit_id`),
  KEY `unit_id` (`unit_id`),
  CONSTRAINT `units_in_shop_ibfk_1` FOREIGN KEY (`shop_id`) REFERENCES `shop` (`shop_id`),
  CONSTRAINT `units_in_shop_ibfk_2` FOREIGN KEY (`unit_id`) REFERENCES `unit` (`unit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `username` varchar(32) NOT NULL,
  `pass` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_privilege`
--

DROP TABLE IF EXISTS `user_privilege`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_privilege` (
  `username` varchar(32) NOT NULL,
  `privilege_id` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`username`,`privilege_id`),
  KEY `privilege_id` (`privilege_id`),
  CONSTRAINT `user_privilege_ibfk_1` FOREIGN KEY (`username`) REFERENCES `user` (`username`),
  CONSTRAINT `user_privilege_ibfk_2` FOREIGN KEY (`privilege_id`) REFERENCES `privilege` (`privilege_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `weapon`
--

DROP TABLE IF EXISTS `weapon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weapon` (
  `weapon_id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `weapon_type` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`weapon_id`)
) ENGINE=InnoDB AUTO_INCREMENT=96 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-07-20 13:27:48
