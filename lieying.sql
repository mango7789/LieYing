-- MySQL dump 10.13  Distrib 8.0.42, for Linux (x86_64)
--
-- Host: localhost    Database: lieying
-- ------------------------------------------------------
-- Server version	8.0.42

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
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session'),(25,'Can add 用户资料',7,'add_userprofile'),(26,'Can change 用户资料',7,'change_userprofile'),(27,'Can delete 用户资料',7,'delete_userprofile'),(28,'Can view 用户资料',7,'view_userprofile'),(29,'Can add resume',8,'add_resume'),(30,'Can change resume',8,'change_resume'),(31,'Can delete resume',8,'delete_resume'),(32,'Can view resume',8,'view_resume'),(33,'Can add 简历版本',9,'add_resumeversion'),(34,'Can change 简历版本',9,'change_resumeversion'),(35,'Can delete 简历版本',9,'delete_resumeversion'),(36,'Can view 简历版本',9,'view_resumeversion'),(37,'Can add 岗位负责人',10,'add_jobowner'),(38,'Can change 岗位负责人',10,'change_jobowner'),(39,'Can delete 岗位负责人',10,'delete_jobowner'),(40,'Can view 岗位负责人',10,'view_jobowner'),(41,'Can add 岗位',11,'add_jobposition'),(42,'Can change 岗位',11,'change_jobposition'),(43,'Can delete 岗位',11,'delete_jobposition'),(44,'Can view 岗位',11,'view_jobposition'),(45,'Can add upload record',12,'add_uploadrecord'),(46,'Can change upload record',12,'change_uploadrecord'),(47,'Can delete upload record',12,'delete_uploadrecord'),(48,'Can view upload record',12,'view_uploadrecord');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'pbkdf2_sha256$1000000$hPdLtUTmhpHYq5y7SkUMJI$SvXI9vFHinzT6sdFNwbwHSS7BHEWq5ItZpYwfQKyslU=','2025-06-21 09:24:07.717254',1,'mango','','','981653507@qq.com',1,1,'2025-06-21 09:23:52.911285'),(2,'pbkdf2_sha256$600000$lqLsy3YFpYPqDWT5FgeB82$yrs7oIuzQi0Hzj5QhvjKO0RqFuNzDlw8LrDKS9gHa60=','2025-06-26 07:36:34.543708',0,'zhengxiang','','','',0,1,'2025-06-24 08:21:59.685835'),(3,'pbkdf2_sha256$600000$p3eUQldzPhOmJqcizglCUQ$zNbRkVRKDRuUgplftmpTmrOX+fDWUvH7NDYQOn9kFbQ=','2025-06-24 09:16:45.531805',0,'suwenyi','','','',0,1,'2025-06-24 09:16:45.291305');
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(3,'auth','group'),(2,'auth','permission'),(4,'auth','user'),(5,'contenttypes','contenttype'),(10,'jobs','jobowner'),(11,'jobs','jobposition'),(8,'resumes','resume'),(9,'resumes','resumeversion'),(12,'resumes','uploadrecord'),(6,'sessions','session'),(7,'users','userprofile');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2025-06-21 04:10:09.934565'),(2,'auth','0001_initial','2025-06-21 04:10:10.247759'),(3,'admin','0001_initial','2025-06-21 04:10:10.339909'),(4,'admin','0002_logentry_remove_auto_add','2025-06-21 04:10:10.345223'),(5,'admin','0003_logentry_add_action_flag_choices','2025-06-21 04:10:10.349709'),(6,'contenttypes','0002_remove_content_type_name','2025-06-21 04:10:10.419624'),(7,'auth','0002_alter_permission_name_max_length','2025-06-21 04:10:10.468481'),(8,'auth','0003_alter_user_email_max_length','2025-06-21 04:10:10.485170'),(9,'auth','0004_alter_user_username_opts','2025-06-21 04:10:10.489132'),(10,'auth','0005_alter_user_last_login_null','2025-06-21 04:10:10.514605'),(11,'auth','0006_require_contenttypes_0002','2025-06-21 04:10:10.516005'),(12,'auth','0007_alter_validators_add_error_messages','2025-06-21 04:10:10.520791'),(13,'auth','0008_alter_user_username_max_length','2025-06-21 04:10:10.570800'),(14,'auth','0009_alter_user_last_name_max_length','2025-06-21 04:10:10.631386'),(15,'auth','0010_alter_group_name_max_length','2025-06-21 04:10:10.648593'),(16,'auth','0011_update_proxy_permissions','2025-06-21 04:10:10.653261'),(17,'auth','0012_alter_user_first_name_max_length','2025-06-21 04:10:10.680702'),(18,'sessions','0001_initial','2025-06-21 04:10:10.697653'),(19,'jobs','0001_initial','2025-06-21 08:57:35.121741'),(20,'resumes','0001_initial','2025-06-21 08:57:35.237709'),(21,'users','0001_initial','2025-06-21 08:57:35.284485'),(22,'resumes','0002_remove_resume_current_version_alter_resume_options_and_more','2025-06-22 08:30:04.441073'),(23,'resumes','0003_uploadrecord','2025-06-23 00:38:06.473264'),(24,'resumes','0004_uploadrecord_parse_status_uploadrecord_resume_and_more','2025-06-23 01:32:49.184761'),(25,'resumes','0005_alter_uploadrecord_options_and_more','2025-06-24 08:12:01.399766');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('2ee5a7sjgbcmt6ylp4prxurd7kkiw1aa','.eJxVjMsOwiAQRf-FtSFkeAx16d5vIMwAUjWQlHZl_Hdt0oVu7znnvkSI21rDNvIS5iTOQovT70aRH7ntIN1ju3XJva3LTHJX5EGHvPaUn5fD_TuocdRvXVJEYshaGUUOXOJSOGsAU4CS9d4gk3VoGFAhIRFZnrxn5TLZCcX7AwXuOGs:1uTzll:CpHkN73gcPywy1caClowctPWCwUR0gdWPCqUHrHcS-g','2025-07-08 09:16:45.534645'),('8pvji9dgz4rh6zd9wlnu4pg2uth51xkt','.eJxVjEsOwjAMBe-SNYrqqHESluw5Q2XHLimgROpnhbg7VOoCtm9m3ssMtK1l2Badh0nM2YA5_W5M-aF1B3Knems2t7rOE9tdsQdd7LWJPi-H-3dQaCnfOnhMvZcQ0oiIAtxLyrH3MHrKBNpBJHHQcYfOKQXWmBDH7Bwn50HN-wPNIzd6:1uSuSF:ESpDVhJDLAbTb6tWGPa4rOL39qZCHretJvQrtmxWj6A','2025-07-05 09:24:07.587905'),('m1t65psb7upwfbraqo86hn8i6f8cq2ij','.eJxVjMsOwiAQRf-FtSFQylC6dO83kBkeFjVgSptojP-uTbrp9p5z7oe5FlvLtbj4eub5zUbZCQtCnJjDdZnc2uLscmAj69hhI_T3WDYQbliulftaljkT3xS-08YvNcTHeXcPBxO26V8PViH1pI3VCrwBI7TWIBApQUJAmUh7IDuQVFJCL70wcYi9TwGj6BT7_gD6t0A8:1uUh9u:jTFtbHyCIETmjJIUSP_2yVjpnDPk0lrY7mu2Payyl-Q','2025-07-10 07:36:34.546627'),('nr7kwhoa41ch085w8rqitc2tderh8otz','.eJxVjEsOwjAMBe-SNYrqqHESluw5Q2XHLimgROpnhbg7VOoCtm9m3ssMtK1l2Badh0nM2YA5_W5M-aF1B3Knems2t7rOE9tdsQdd7LWJPi-H-3dQaCnfOnhMvZcQ0oiIAtxLyrH3MHrKBNpBJHHQcYfOKQXWmBDH7Bwn50HN-wPNIzd6:1uSuSF:ESpDVhJDLAbTb6tWGPa4rOL39qZCHretJvQrtmxWj6A','2025-07-05 09:24:07.719922');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs_jobowner`
--

DROP TABLE IF EXISTS `jobs_jobowner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobs_jobowner` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `start_time` datetime(6) NOT NULL,
  `end_time` datetime(6) DEFAULT NULL,
  `user_id` int NOT NULL,
  `job_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `jobs_jobowner_job_id_user_id_start_time_2c56f361_uniq` (`job_id`,`user_id`,`start_time`),
  KEY `jobs_jobowner_user_id_235ac337_fk_auth_user_id` (`user_id`),
  CONSTRAINT `jobs_jobowner_job_id_3989ae98_fk_jobs_jobposition_id` FOREIGN KEY (`job_id`) REFERENCES `jobs_jobposition` (`id`),
  CONSTRAINT `jobs_jobowner_user_id_235ac337_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs_jobowner`
--

LOCK TABLES `jobs_jobowner` WRITE;
/*!40000 ALTER TABLE `jobs_jobowner` DISABLE KEYS */;
/*!40000 ALTER TABLE `jobs_jobowner` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs_jobposition`
--

DROP TABLE IF EXISTS `jobs_jobposition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobs_jobposition` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `company` varchar(100) NOT NULL,
  `city` varchar(50) NOT NULL,
  `salary` varchar(50) NOT NULL,
  `work_experience` varchar(50) NOT NULL,
  `education` varchar(50) NOT NULL,
  `language` varchar(50) NOT NULL,
  `responsibilities` longtext NOT NULL,
  `requirements` longtext NOT NULL,
  `created_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs_jobposition`
--

LOCK TABLES `jobs_jobposition` WRITE;
/*!40000 ALTER TABLE `jobs_jobposition` DISABLE KEYS */;
/*!40000 ALTER TABLE `jobs_jobposition` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `resumes_resume`
--

DROP TABLE IF EXISTS `resumes_resume`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `resumes_resume` (
  `resume_id` varchar(32) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `certificates` longtext NOT NULL,
  `current_status` varchar(20) NOT NULL,
  `education` json NOT NULL DEFAULT (_utf8mb4'[]'),
  `email` varchar(254) NOT NULL,
  `expected_positions` json NOT NULL DEFAULT (_utf8mb4'[]'),
  `name` varchar(10) NOT NULL,
  `personal_info` longtext NOT NULL,
  `phone` varchar(11) NOT NULL,
  `project_experiences` json NOT NULL DEFAULT (_utf8mb4'[]'),
  `self_evaluation` longtext NOT NULL,
  `skills` json NOT NULL DEFAULT (_utf8mb4'[]'),
  `status` varchar(20) NOT NULL,
  `tags` json NOT NULL DEFAULT (_utf8mb4'[]'),
  `working_experiences` json NOT NULL DEFAULT (_utf8mb4'[]'),
  PRIMARY KEY (`resume_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resumes_resume`
--

LOCK TABLES `resumes_resume` WRITE;
/*!40000 ALTER TABLE `resumes_resume` DISABLE KEYS */;
INSERT INTO `resumes_resume` VALUES ('8be599659cV971a5d7b4b10','2025-06-26 11:00:50.179822','2025-06-26 11:18:09.793817','[]','匹配中','[]','','\"职位: 产品经理 | 地点: 上海 | 薪资: 55-60k×15薪\"','','方便联系时间：随时联系 | 男 29岁 上海 硕士 工作6年 保密 | 数据科学经理，搜索与推荐 Coupang','','[{\"project_name\": \"搜索推荐流量策略优化\", \"所在公司\": \"字节跳动\", \"项目描述\": \"1. 流量效率优化 通过用户行为分析、数据源探索和特征工程等分析手段，增加召回支路并优化排序模型，将搜素opms提升6% 2. 商品供给和成长方向 挖掘商品冷启动流量扶持的提升机会点，优化商品准入、流量分配和退出机制，将北极星指标提升7% 建设搜索词缺货识别和分级模型，提高了缺货商品的识别准确度和招商效率，将搜索缺货pv占比降低5% 3. 用户体验 利用因果推断论证用户体验的表征指标和特征重要性，使用多因子模拟方法设计治理规则，将搜索差评率降低17%\", \"项目职务\": \"数据科学家\", \"employment_period\": \"（2023.05 - 至今）\"}, {\"project_name\": \"搜索数据基建和产品分析\", \"所在公司\": \"字节跳动\", \"项目描述\": \"建设搜索核心指标监控体系，开发数据看板和异动归因工具，有效支持业务团队进行问题分析和快速决策 设计AB实验并分析实验结果，论证产品功能和算法策略的有效性\", \"项目职务\": \"数据科学家\", \"employment_period\": \"（2023.05 - 至今）\"}]','1. 互联网国际化出海行业及外企咨询背景，具备跨国团队协作与团队管理能力。\n\n2. 7年数据科学与管理咨询工作经验，在搜索推荐、用户增长、金融科技成功推动多个项目并取得显著成果。\n\n3. 在ToB企业服务领域有丰富的AI解决方案交付经验，领导从需求诊断、模型开发到客户关系维护的全周期管理。','[\"sql\", \"咨询\", \"人工智能\", \"机器学习\", \"数据分析\"]','在职，急寻新工作','[]','[{\"company\": \"Coupang\", \"job_name\": \"数据科学经理，搜索与推荐\", \"下属人数\": \"0\", \"职责业绩\": \"挖掘召回、相关性、排序模块的增量机会，为优化用户搜索体验提供数据洞察和落地建议，推动转化率提 升30+%，线上相关性指标提升11+%。 主导LLM相关性大模型的数据标注-抽样-评估的闭环流程设计和实施，提升训练数据质量，模型准确率提升 10%，降低标注评估人力成本50% 开发搜索指标度量体系，主导70+ A/B实验的设计-多维分析-归因全流程管理，支持80%策略迭代决策，并 推动建设实验分析SOP，降低人为误差10% 搭建搜索冷启动的指标体系、流量扶持和退出机制，通过动态流量控制和退出阈值计算（CTR/转化率预 估），实现商品曝光效率提升15%，流量损耗降低20%\", \"employment_period\": \"（2024.03 - 至今, 1年3个月）\"}, {\"company\": \"Coupang\", \"job_name\": \"数据科学经理\", \"下属人数\": \"0\", \"所在部门\": \"搜索和推荐\", \"职责业绩\": \"- 负责搜索召回、相关性和排序模块策略分析 - 跨团队合作优化流量分配机制和产品供给 - LLM大模型数据标注和评估流程优化 - 搜索产品指标体系设计及开发 - AB实验方案设计和分析\", \"employment_period\": \"（2024.03 - 至今, 1年3个月）\"}, {\"company\": \"字节跳动\", \"job_name\": \"数据科学家\", \"下属人数\": \"0\", \"职责业绩\": \"负责Tiktok国际化电商搜索推荐产品和策略分析 搜索体验和治理 搜索供给和生态\", \"employment_period\": \"（2022.04 - 至今, 3年2个月）\"}, {\"company\": \"字节跳动\", \"job_name\": \"数据科学家，TikTok电商数据科学\", \"下属人数\": \"0\", \"职责业绩\": \"领导国际化电商搜索生态和流量机制优化产品分析 通过用户行为分析、数据源探索和特征工程等分析手段，增加召回支路并优化排序模型，将搜素转化率opms提升6% 建设搜索词缺货识别和分级模型，提高了缺货商品的识别准确度和招商效率，将搜索缺货曝光占比降低5% 利用因果推断论证用户体验的表征指标和特征重要性，使用多因子模拟方法设计治理规则，将搜索差评率降低17% 建设搜索核心指标监控体系，开发数据看板和异动归因工具，有效支持业务团队进行问题分析和快速决策\", \"employment_period\": \"（2022.04 - 2024.02, 1年10个月）\"}, {\"company\": \"Opera Solutions\", \"job_name\": \"分析主管，数据科学\", \"下属人数\": \"0\", \"工作地点\": \"上海\", \"职责业绩\": \"带领4人团队为FinTech、零售等世界500强企业提供端到端的AI解决方案，为客户增加千万级别的利润增长 领导大数据开发和机器学习建模平台的功能开发，并打造标准化的行业解决方案，推动与阿里云的战略合作 搭建信用卡APP用户行为模型，利用个性化推荐技术优化推荐功能，营销活动响应率提升3倍，激活10%的 睡眠客户 为某国有四大行信用卡中心提供数字化转型咨询服务，针对数据管理、营销、风控和客服制定三年实施路线图 为欧洲电影院线开发票房预测模型，支持影院经理一键生成排片，为客户创造超过400万英镑的利润\", \"employment_period\": \"（2018.08 - 2022.04, 3年8个月）\"}]'),('8ee0936898eaD911c5a794717','2025-06-26 10:57:10.316773','2025-06-26 11:31:01.925028','[\'大学英语四级\', \'大学英语六级\']','匹配中','[]','','\"职位: 售前技术支持 | 地点: 上海 | 薪资: 20-35k×12薪\"','',' | 男 33岁 上海 本科 工作9年 | 售前技术支持 苏州科达科技股份有限公司','','[]','1. 国内外大型项目规划、设计、落地支撑经验，伴随行业信息化、智慧城市、数字政府改革一路成长，具备各层级政府部门项目的实践经验。\n2. 项目管理、售前支持、解决方案孵化、规划设计等多岗位的从业与管理经验，拥有优秀的政策解读能力、商机挖掘能力、规划引导能力、解决方案培育能力和知识体系构建能力。\n3. 政策解读能力：通过工作积累，具备政策解读能力，能够准确把握行业发展趋势，判断发展阶段，明确发展方向，输出潜在商机。\n4. 知识体系构建能力：在行业信息的基础上总结行业知识，形成思路输出想法，并进行实践检验。\n5. 项目管理能力：通过大型项目锻炼，具备较强的现场组织梳理、团队管理、进度管理、资源调配的能力。\n6. 文档编写能力：掌握规划、设计方案、汇报材料、标准、论文等不同文档资料的编写方法，能够准确输出对应的文档材料。\n7. 沟通表达能力：日常工作积累丰富的对外交流沟通经验，能够应对口述交流、宣讲、汇报等不同沟通场景，准确表达。','[\"售前工程师\"]','离职，正在找工作','[]','[{\"company\": \"苏州科达科技股份有限公司\", \"job_name\": \"售前技术支持\", \"下属人数\": \"0\", \"职责业绩\": \"主要工作范围： 1、负责全国范围内大型重点项目的售前技术支持，包括雪亮工程、智慧警务、智慧城市、社会治理等政府信息化项目的全流程管理，涵盖需求、规划、设计、招投标及实施阶段。   2、开拓行业新市场，从0到1打磨行业解决方案，提升公司业务覆盖范围。   3、参与国家、地方及行业标准的编制工作，推动行业规范化发展。   4、组织内外部培训，针对新员工、分公司及合作伙伴、用户进行技术推广与知识传递。   5、作为技术负责人进行多个省、市、区县等不同层级的项目全生命周期管理。  项目分阶段工作内容： （1）需求阶段—项目前期与各业务部门用户进行需求沟通、实地调研，输出调研报告。 （2）规划阶段—根据调研报告结果，结合地方政策、工作报告、行动计划，形成本领域的规划方案。 （3）设计阶段—拉通公司各团队力量，牵头设计编写整体项目可行性研究报告、项目设计方案。 （4）招投标阶段-招标文件处理、投标文件编制、协助投标与述标。 （5）实施阶段—结合前期规划蓝图、设计方案，与项目交付团队技术交底，保障项目顺利交付。\", \"employment_period\": \"（2018.04 - 至今, 7年2个月）\"}, {\"company\": \"上海天道科技有限公司\", \"job_name\": \"售前技术支持\", \"下属人数\": \"0\", \"职责业绩\": \"1、负责公安、交通、金融等行业的售前技术支持，涵盖需求、规划、设计、招投标及实施阶段。   2、组织内外部培训，针对新员工及合作伙伴、用户进行技术推广与知识传递。   3、在项目需求阶段进行用户调研并输出调研报告，规划阶段制定规划方案，设计阶段牵头编写可行性研究报告及设计方案，招投标阶段进行招投标材料编制及投标述标工作，实施阶段保障项目顺利交付。 4、作为技术负责人进行多个行业项目的全生命周期管理。\", \"employment_period\": \"（2016.03 - 2018.04, 2年1个月）\"}, {\"company\": \"浙江宇视科技有限公司\", \"job_name\": \"售前技术支持\", \"下属人数\": \"0\", \"职责业绩\": \"1、负责公安、司法等行业的售前技术支持，涵盖需求、规划、设计、招投标及实施阶段。   2、组织内外部培训，针对新员工、合作伙伴、用户进行技术推广与知识传递。   3、在项目需求阶段进行用户调研并输出调研报告，规划阶段制定规划方案，设计阶段牵头编写可行性研究报告及设计方案，招投标阶段进行招投标材料编制及投标述标工作，实施阶段保障项目顺利交付。 4、获得全部四项工程师认证，同期入职的近百名同事中仅三人全部通过（宇视认证网络技术工程师、宇视认证智能交通系统工程师、宇视认证视频监控技术工程师、宇视认证商业监控系统工程师）。\", \"employment_period\": \"（2015.08 - 2016.03, 7个月）\"}]'),('DeepSeek_V3','2025-06-26 11:18:09.647992','2025-06-26 11:18:09.648023','[]','匹配中','[]','','[]','','','','[]','','[]','','[]','[]'),('demo123456','2025-06-23 02:16:25.865018','2025-06-26 07:56:20.136440','','匹配中','[]','','[]','mango','','','[]','','[]','在职，急寻新工作','[]','[]'),('SPS','2025-06-26 11:00:50.662884','2025-06-26 11:00:50.662902','[]','匹配中','[]','','[]','','','','[]','','[]','','[]','[]');
/*!40000 ALTER TABLE `resumes_resume` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `resumes_uploadrecord`
--

DROP TABLE IF EXISTS `resumes_uploadrecord`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `resumes_uploadrecord` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `filename` varchar(255) NOT NULL,
  `upload_time` datetime(6) NOT NULL,
  `user_id` int NOT NULL,
  `parse_status` varchar(10) NOT NULL,
  `resume_id` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `resumes_uploadrecord_resume_id_7187b1c3_fk_resumes_r` (`resume_id`),
  KEY `resumes_uploadrecord_user_id_2187a373_fk_auth_user_id` (`user_id`),
  CONSTRAINT `resumes_uploadrecord_resume_id_7187b1c3_fk_resumes_r` FOREIGN KEY (`resume_id`) REFERENCES `resumes_resume` (`resume_id`),
  CONSTRAINT `resumes_uploadrecord_user_id_2187a373_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resumes_uploadrecord`
--

LOCK TABLES `resumes_uploadrecord` WRITE;
/*!40000 ALTER TABLE `resumes_uploadrecord` DISABLE KEYS */;
INSERT INTO `resumes_uploadrecord` VALUES (1,'一卡通每日消费.xlsx','2025-06-23 00:39:18.693868',1,'fail',NULL),(2,'一卡通每日消费.xlsx','2025-06-23 01:24:47.939448',1,'fail',NULL),(3,'DeepSeek_V3.pdf','2025-06-23 01:24:57.169002',1,'fail',NULL),(4,'SPS.pdf','2025-06-23 02:16:25.837796',1,'success','demo123456'),(5,'一卡通每日消费.xlsx','2025-06-23 06:17:26.122332',1,'success','demo123456'),(6,'SPS.pdf','2025-06-24 08:48:24.700547',2,'success',NULL),(7,'NO.8ee0936898eaD911c5a794717.html','2025-06-26 02:57:34.974307',2,'success',NULL),(8,'NO.8be599659cV971a5d7b4b10.html','2025-06-26 03:03:32.461533',2,'success',NULL),(9,'SPS.pdf','2025-06-26 03:07:19.437046',2,'success',NULL),(10,'DeepSeek_V3.pdf','2025-06-26 03:07:30.767093',2,'success',NULL),(11,'NO.88e8996197V941e5d704c18.html','2025-06-26 03:07:36.682662',2,'success',NULL),(12,'NO.8be599659cV971a5d7b4b10.html','2025-06-26 07:36:41.128692',2,'success',NULL),(13,'NO.8ee0936898eaD911c5a794717.html','2025-06-26 10:57:10.276532',2,'success','8ee0936898eaD911c5a794717'),(14,'NO.8be599659cV971a5d7b4b10.html','2025-06-26 11:00:50.133622',2,'success','8be599659cV971a5d7b4b10'),(15,'NO.8ee0936898eaD911c5a794717.html','2025-06-26 11:00:50.316893',2,'success','8ee0936898eaD911c5a794717'),(16,'NO.88e8996197V941e5d704c18.html','2025-06-26 11:00:50.464384',2,'fail',NULL),(17,'SPS.pdf','2025-06-26 11:00:50.627930',2,'success','SPS'),(18,'NO.8ee0936898eaD911c5a794717.html','2025-06-26 11:17:11.940212',2,'success','8ee0936898eaD911c5a794717'),(19,'一卡通每日消费.xlsx','2025-06-26 11:17:30.863631',2,'fail',NULL),(20,'DeepSeek_V3.pdf','2025-06-26 11:18:09.345152',2,'success','DeepSeek_V3'),(21,'NO.8be599659cV971a5d7b4b10.html','2025-06-26 11:18:09.745863',2,'success','8be599659cV971a5d7b4b10'),(22,'NO.8ee0936898eaD911c5a794717.html','2025-06-26 11:18:09.916618',2,'success','8ee0936898eaD911c5a794717'),(23,'NO.88e8996197V941e5d704c18.html','2025-06-26 11:18:10.093196',2,'fail',NULL),(24,'NO.8ee0936898eaD911c5a794717.html','2025-06-26 11:31:01.887276',2,'success','8ee0936898eaD911c5a794717');
/*!40000 ALTER TABLE `resumes_uploadrecord` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_userprofile`
--

DROP TABLE IF EXISTS `users_userprofile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_userprofile` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `role` varchar(10) NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `users_userprofile_user_id_87251ef1_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_userprofile`
--

LOCK TABLES `users_userprofile` WRITE;
/*!40000 ALTER TABLE `users_userprofile` DISABLE KEYS */;
INSERT INTO `users_userprofile` VALUES (1,'猎头',1),(2,'猎头',2),(3,'猎头',3);
/*!40000 ALTER TABLE `users_userprofile` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-26 12:47:45
