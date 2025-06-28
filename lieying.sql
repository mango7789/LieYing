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
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session'),(25,'Can add 用户资料',7,'add_userprofile'),(26,'Can change 用户资料',7,'change_userprofile'),(27,'Can delete 用户资料',7,'delete_userprofile'),(28,'Can view 用户资料',7,'view_userprofile'),(29,'Can add resume',8,'add_resume'),(30,'Can change resume',8,'change_resume'),(31,'Can delete resume',8,'delete_resume'),(32,'Can view resume',8,'view_resume'),(33,'Can add 简历版本',9,'add_resumeversion'),(34,'Can change 简历版本',9,'change_resumeversion'),(35,'Can delete 简历版本',9,'delete_resumeversion'),(36,'Can view 简历版本',9,'view_resumeversion'),(37,'Can add 岗位负责人',10,'add_jobowner'),(38,'Can change 岗位负责人',10,'change_jobowner'),(39,'Can delete 岗位负责人',10,'delete_jobowner'),(40,'Can view 岗位负责人',10,'view_jobowner'),(41,'Can add 岗位',11,'add_jobposition'),(42,'Can change 岗位',11,'change_jobposition'),(43,'Can delete 岗位',11,'delete_jobposition'),(44,'Can view 岗位',11,'view_jobposition'),(45,'Can add upload record',12,'add_uploadrecord'),(46,'Can change upload record',12,'change_uploadrecord'),(47,'Can delete upload record',12,'delete_uploadrecord'),(48,'Can view upload record',12,'view_uploadrecord'),(49,'Can add 简历岗位匹配',13,'add_matching'),(50,'Can change 简历岗位匹配',13,'change_matching'),(51,'Can delete 简历岗位匹配',13,'delete_matching'),(52,'Can view 简历岗位匹配',13,'view_matching'),(53,'Can add django job',14,'add_djangojob'),(54,'Can change django job',14,'change_djangojob'),(55,'Can delete django job',14,'delete_djangojob'),(56,'Can view django job',14,'view_djangojob'),(57,'Can add django job execution',15,'add_djangojobexecution'),(58,'Can change django job execution',15,'change_djangojobexecution'),(59,'Can delete django job execution',15,'delete_djangojobexecution'),(60,'Can view django job execution',15,'view_djangojobexecution'),(61,'Can add job match task',16,'add_jobmatchtask'),(62,'Can change job match task',16,'change_jobmatchtask'),(63,'Can delete job match task',16,'delete_jobmatchtask'),(64,'Can view job match task',16,'view_jobmatchtask');
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'pbkdf2_sha256$1000000$hPdLtUTmhpHYq5y7SkUMJI$SvXI9vFHinzT6sdFNwbwHSS7BHEWq5ItZpYwfQKyslU=','2025-06-21 09:24:07.717254',1,'mango','','','981653507@qq.com',1,1,'2025-06-21 09:23:52.911285'),(2,'pbkdf2_sha256$600000$lqLsy3YFpYPqDWT5FgeB82$yrs7oIuzQi0Hzj5QhvjKO0RqFuNzDlw8LrDKS9gHa60=','2025-06-28 13:27:45.940903',0,'zhengxiang','','','',0,1,'2025-06-24 08:21:59.685835'),(3,'pbkdf2_sha256$600000$p3eUQldzPhOmJqcizglCUQ$zNbRkVRKDRuUgplftmpTmrOX+fDWUvH7NDYQOn9kFbQ=','2025-06-28 11:25:03.209535',0,'suwenyi','','','',0,1,'2025-06-24 09:16:45.291305'),(4,'pbkdf2_sha256$600000$RKR0W8TxNhMQh19yJdg4vu$6WsYaNVHSN7wMwccMoUWTr4MO0x7A1ME1ZwTlxwIDGk=','2025-06-28 11:13:00.520880',1,'lieying','','','',1,1,'2025-06-27 13:28:26.905855'),(5,'pbkdf2_sha256$600000$bAGDJwof4TTZ0REryrFSUt$QD4JW7qK3auGW+KVvOdPr98dK7hnaC4K/7AYQsIPYxc=','2025-06-28 11:42:09.068541',0,'Lwj','','','',0,1,'2025-06-28 11:42:08.827597'),(6,'pbkdf2_sha256$600000$kZIe1nOBMdUeevi2AiV7Ds$d+IPaCNmWFmD6Lmb9RSNg1Ey/EtpxQUGzHqQOgYKH4c=','2025-06-28 11:53:40.371572',0,'zhangchi','','','',0,1,'2025-06-28 11:53:40.120084');
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
-- Table structure for table `django_apscheduler_djangojob`
--

DROP TABLE IF EXISTS `django_apscheduler_djangojob`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_apscheduler_djangojob` (
  `id` varchar(255) NOT NULL,
  `next_run_time` datetime(6) DEFAULT NULL,
  `job_state` longblob NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_apscheduler_djangojob_next_run_time_2f022619` (`next_run_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_apscheduler_djangojob`
--

LOCK TABLES `django_apscheduler_djangojob` WRITE;
/*!40000 ALTER TABLE `django_apscheduler_djangojob` DISABLE KEYS */;
INSERT INTO `django_apscheduler_djangojob` VALUES ('resume_job_matching','2025-06-28 07:47:16.050368',_binary '��4\0\0\0\0\0\0}�(�version�K�id��resume_job_matching��func��&match.services:run_resume_job_matching��trigger��apscheduler.triggers.interval��IntervalTrigger���)��}�(hK�timezone��builtins��getattr����zoneinfo��ZoneInfo����	_unpickle���R��\rAsia/Shanghai�K��R��\nstart_date��datetime��datetime���C\n\�*\0\���h��R��end_date�N�interval�h\Z�	timedelta���K\0M,K\0��R��jitter�Nub�executor��default��args�)�kwargs�}��overwrite_existing��s�name��run_resume_job_matching��misfire_grace_time�K�coalesce���\rmax_instances�K�\rnext_run_time�hC\n\�/\0\���h��R�u.');
/*!40000 ALTER TABLE `django_apscheduler_djangojob` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_apscheduler_djangojobexecution`
--

DROP TABLE IF EXISTS `django_apscheduler_djangojobexecution`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_apscheduler_djangojobexecution` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `status` varchar(50) NOT NULL,
  `run_time` datetime(6) NOT NULL,
  `duration` decimal(15,2) DEFAULT NULL,
  `finished` decimal(15,2) DEFAULT NULL,
  `exception` varchar(1000) DEFAULT NULL,
  `traceback` longtext,
  `job_id` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_job_executions` (`job_id`,`run_time`),
  KEY `django_apscheduler_djangojobexecution_run_time_16edd96b` (`run_time`),
  CONSTRAINT `django_apscheduler_djangojobexecution_job_id_daf5090a_fk` FOREIGN KEY (`job_id`) REFERENCES `django_apscheduler_djangojob` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_apscheduler_djangojobexecution`
--

LOCK TABLES `django_apscheduler_djangojobexecution` WRITE;
/*!40000 ALTER TABLE `django_apscheduler_djangojobexecution` DISABLE KEYS */;
INSERT INTO `django_apscheduler_djangojobexecution` VALUES (1,'Executed','2025-06-28 02:34:51.670871',61.16,1751078152.83,NULL,NULL,'resume_job_matching'),(2,'Executed','2025-06-28 03:00:16.322192',83.41,1751079699.73,NULL,NULL,'resume_job_matching'),(3,'Executed','2025-06-28 07:07:02.222544',59.99,1751094482.21,NULL,NULL,'resume_job_matching'),(4,'Executed','2025-06-28 07:12:02.222544',55.11,1751094777.34,NULL,NULL,'resume_job_matching'),(5,'Executed','2025-06-28 07:17:02.222544',55.18,1751095077.40,NULL,NULL,'resume_job_matching'),(6,'Executed','2025-06-28 07:22:02.222544',0.02,1751095322.24,NULL,NULL,'resume_job_matching'),(7,'Executed','2025-06-28 07:27:02.222544',0.04,1751095622.26,NULL,NULL,'resume_job_matching'),(8,'Executed','2025-06-28 07:42:16.050368',173.66,1751096709.71,NULL,NULL,'resume_job_matching');
/*!40000 ALTER TABLE `django_apscheduler_djangojobexecution` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(3,'auth','group'),(2,'auth','permission'),(4,'auth','user'),(5,'contenttypes','contenttype'),(14,'django_apscheduler','djangojob'),(15,'django_apscheduler','djangojobexecution'),(10,'jobs','jobowner'),(11,'jobs','jobposition'),(16,'match','jobmatchtask'),(13,'match','matching'),(8,'resumes','resume'),(9,'resumes','resumeversion'),(12,'resumes','uploadrecord'),(6,'sessions','session'),(7,'users','userprofile');
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
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2025-06-21 04:10:09.934565'),(2,'auth','0001_initial','2025-06-21 04:10:10.247759'),(3,'admin','0001_initial','2025-06-21 04:10:10.339909'),(4,'admin','0002_logentry_remove_auto_add','2025-06-21 04:10:10.345223'),(5,'admin','0003_logentry_add_action_flag_choices','2025-06-21 04:10:10.349709'),(6,'contenttypes','0002_remove_content_type_name','2025-06-21 04:10:10.419624'),(7,'auth','0002_alter_permission_name_max_length','2025-06-21 04:10:10.468481'),(8,'auth','0003_alter_user_email_max_length','2025-06-21 04:10:10.485170'),(9,'auth','0004_alter_user_username_opts','2025-06-21 04:10:10.489132'),(10,'auth','0005_alter_user_last_login_null','2025-06-21 04:10:10.514605'),(11,'auth','0006_require_contenttypes_0002','2025-06-21 04:10:10.516005'),(12,'auth','0007_alter_validators_add_error_messages','2025-06-21 04:10:10.520791'),(13,'auth','0008_alter_user_username_max_length','2025-06-21 04:10:10.570800'),(14,'auth','0009_alter_user_last_name_max_length','2025-06-21 04:10:10.631386'),(15,'auth','0010_alter_group_name_max_length','2025-06-21 04:10:10.648593'),(16,'auth','0011_update_proxy_permissions','2025-06-21 04:10:10.653261'),(17,'auth','0012_alter_user_first_name_max_length','2025-06-21 04:10:10.680702'),(18,'sessions','0001_initial','2025-06-21 04:10:10.697653'),(19,'jobs','0001_initial','2025-06-21 08:57:35.121741'),(20,'resumes','0001_initial','2025-06-21 08:57:35.237709'),(21,'users','0001_initial','2025-06-21 08:57:35.284485'),(22,'resumes','0002_remove_resume_current_version_alter_resume_options_and_more','2025-06-22 08:30:04.441073'),(23,'resumes','0003_uploadrecord','2025-06-23 00:38:06.473264'),(24,'resumes','0004_uploadrecord_parse_status_uploadrecord_resume_and_more','2025-06-23 01:32:49.184761'),(25,'resumes','0005_alter_uploadrecord_options_and_more','2025-06-24 08:12:01.399766'),(26,'resumes','0006_uploadrecord_error_message','2025-06-26 12:48:10.555070'),(27,'match','0001_initial','2025-06-26 13:08:50.201727'),(28,'resumes','0005_alter_uploadrecord_options','2025-06-27 00:34:04.423914'),(29,'resumes','0007_merge_20250627_0833','2025-06-27 00:34:04.428532'),(30,'django_apscheduler','0001_initial','2025-06-27 12:16:01.437108'),(31,'django_apscheduler','0002_auto_20180412_0758','2025-06-27 12:16:01.465957'),(32,'django_apscheduler','0003_auto_20200716_1632','2025-06-27 12:16:01.484519'),(33,'django_apscheduler','0004_auto_20200717_1043','2025-06-27 12:16:01.612336'),(34,'django_apscheduler','0005_migrate_name_to_id','2025-06-27 12:16:01.629614'),(35,'django_apscheduler','0006_remove_djangojob_name','2025-06-27 12:16:01.653260'),(36,'django_apscheduler','0007_auto_20200717_1404','2025-06-27 12:16:01.684592'),(37,'django_apscheduler','0008_remove_djangojobexecution_started','2025-06-27 12:16:01.724856'),(38,'django_apscheduler','0009_djangojobexecution_unique_job_executions','2025-06-27 12:16:01.743533'),(39,'jobs','0002_jobposition_updated_at','2025-06-28 01:28:13.000275'),(40,'resumes','0008_resume_related_jobs','2025-06-28 07:46:27.832913'),(41,'match','0002_matching_task_status','2025-06-28 10:00:42.420255'),(42,'match','0003_jobmatchtask','2025-06-28 10:54:50.314428'),(43,'match','0004_alter_jobmatchtask_last_processed_resume_id','2025-06-28 14:30:53.984521');
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
INSERT INTO `django_session` VALUES ('2ee5a7sjgbcmt6ylp4prxurd7kkiw1aa','.eJxVjMsOwiAQRf-FtSFkeAx16d5vIMwAUjWQlHZl_Hdt0oVu7znnvkSI21rDNvIS5iTOQovT70aRH7ntIN1ju3XJva3LTHJX5EGHvPaUn5fD_TuocdRvXVJEYshaGUUOXOJSOGsAU4CS9d4gk3VoGFAhIRFZnrxn5TLZCcX7AwXuOGs:1uTzll:CpHkN73gcPywy1caClowctPWCwUR0gdWPCqUHrHcS-g','2025-07-08 09:16:45.534645'),('5am2yy67ns7f9l0hyncwcpao1d2g1nhe','.eJxVjMsOwiAQRf-FtSFQylC6dO83kBkeFjVgSptojP-uTbrp9p5z7oe5FlvLtbj4eub5zUbZCQtCnJjDdZnc2uLscmAj69hhI_T3WDYQbliulftaljkT3xS-08YvNcTHeXcPBxO26V8PViH1pI3VCrwBI7TWIBApQUJAmUh7IDuQVFJCL70wcYi9TwGj6BT7_gD6t0A8:1uVVar:dRAKQEEBK5TvAeSJNHdTCvBVysxSC8QoO2hCIe-XJu0','2025-07-12 13:27:45.943680'),('8pvji9dgz4rh6zd9wlnu4pg2uth51xkt','.eJxVjEsOwjAMBe-SNYrqqHESluw5Q2XHLimgROpnhbg7VOoCtm9m3ssMtK1l2Badh0nM2YA5_W5M-aF1B3Knems2t7rOE9tdsQdd7LWJPi-H-3dQaCnfOnhMvZcQ0oiIAtxLyrH3MHrKBNpBJHHQcYfOKQXWmBDH7Bwn50HN-wPNIzd6:1uSuSF:ESpDVhJDLAbTb6tWGPa4rOL39qZCHretJvQrtmxWj6A','2025-07-05 09:24:07.587905'),('b7ublwuyarxjjfk524t8psugdx3o91a4','.eJxVjMsOwiAQRf-FtSFQylC6dO83kBkeFjVgSptojP-uTbrp9p5z7oe5FlvLtbj4eub5zUbZCQtCnJjDdZnc2uLscmAj69hhI_T3WDYQbliulftaljkT3xS-08YvNcTHeXcPBxO26V8PViH1pI3VCrwBI7TWIBApQUJAmUh7IDuQVFJCL70wcYi9TwGj6BT7_gD6t0A8:1uVUmT:PnOOP_4qZdDNEY3-_xgPEgpeDTKHk1piGjP03mOP8jw','2025-07-12 12:35:41.664499'),('bukjo3tf561vvq0gf0o3x4fojf2isrbb','.eJxVjMsOwiAQRf-FtSEUGB4u3fsNZJihUjU0Ke3K-O_apAvd3nPOfYmE21rT1suSJhZn4cTpd8tIj9J2wHdst1nS3NZlynJX5EG7vM5cnpfD_Tuo2Ou3Vh6UYmeDV4HIW2sGR5AdjZ7ZgQEdTYTCfrBu5GBNiagxa4taQwYS7w-5KTcb:1uVU7o:oYEsCZlfaiyxTW-H_JELHtP9lvxQeOnPNhVn5I_GEPc','2025-07-12 11:53:40.374368'),('c87lg5cwzim4mh1v9n9jerz739ofyvey','.eJxVjEEOwiAQRe_C2hCgwBSX7j0DAWZGqoYmpV0Z765NutDtf-_9l4hpW2vcOi1xQnEWTpx-t5zKg9oO8J7abZZlbusyZbkr8qBdXmek5-Vw_w5q6vVbM2alLXMouoSAzjLA4DBnJGMc-nHApFBRADLWQ7EctAXW5McMCVG8PwVROKw:1uVTwf:Lw_WUndfV0D9CfB0jeOWuiAP6eJ6m8zxWSIAzUW7vbE','2025-07-12 11:42:09.071548'),('hy5x94a1g9gh166ygoxk9bwu1819yezm','.eJxVjMsOwiAQRf-FtSFIebVL934DYYbBogaa0iYa479rk266veec-2G-UWu5Fk-vKc9vNpyl6I0QJ-bDuox-bTT7HNnAOnbYIOCDygbiPZRb5VjLMmfgm8J32vi1RnpedvdwMIY2_usUgwWU1AklwEgTMSWkTkqVJETtnLII2liF0goLFgA09s6hMAS6t-z7AyzGQNo:1uVTg7:q-6DPeUb-73gZA7FZqkTZ0IybVGx8x33tcH_apYftm4','2025-07-12 11:25:03.212076'),('nr7kwhoa41ch085w8rqitc2tderh8otz','.eJxVjEsOwjAMBe-SNYrqqHESluw5Q2XHLimgROpnhbg7VOoCtm9m3ssMtK1l2Badh0nM2YA5_W5M-aF1B3Knems2t7rOE9tdsQdd7LWJPi-H-3dQaCnfOnhMvZcQ0oiIAtxLyrH3MHrKBNpBJHHQcYfOKQXWmBDH7Bwn50HN-wPNIzd6:1uSuSF:ESpDVhJDLAbTb6tWGPa4rOL39qZCHretJvQrtmxWj6A','2025-07-05 09:24:07.719922'),('ucon56hayyyc31ex3d45qrm110bax4uw','.eJxVjMsOwiAQRf-FtSFQylC6dO83kBkeFjVgSptojP-uTbrp9p5z7oe5FlvLtbj4eub5zUbZCQtCnJjDdZnc2uLscmAj69hhI_T3WDYQbliulftaljkT3xS-08YvNcTHeXcPBxO26V8PViH1pI3VCrwBI7TWIBApQUJAmUh7IDuQVFJCL70wcYi9TwGj6BT7_gD6t0A8:1uVQgq:atmXAFjJbU5QxB0K-Oi6f34-Xg_Y3boc2IztDF2Lg2k','2025-07-12 08:13:36.728416'),('zqo1jns6ohovlklis5o5fwp7pxift0ki','.eJxVjMsOwiAQRf-FtSFQylC6dO83kBkeFjVgSptojP-uTbrp9p5z7oe5FlvLtbj4eub5zUbZCQtCnJjDdZnc2uLscmAj69hhI_T3WDYQbliulftaljkT3xS-08YvNcTHeXcPBxO26V8PViH1pI3VCrwBI7TWIBApQUJAmUh7IDuQVFJCL70wcYi9TwGj6BT7_gD6t0A8:1uUx6l:IVs1OQqUIuiqhT7K9oWTG4U1W1y0HW_94joBE396yPQ','2025-07-11 00:38:23.740476');
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
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs_jobposition`
--

LOCK TABLES `jobs_jobposition` WRITE;
/*!40000 ALTER TABLE `jobs_jobposition` DISABLE KEYS */;
INSERT INTO `jobs_jobposition` VALUES (1,'算法工程师','阿里巴巴','杭州','','应届生','不限','不限','','','2025-06-27 23:56:15.874277','2025-06-28 09:41:33.352967'),(2,'算法工程师','字节跳动','上海','','不限','985','','1、支持快速增长的抖音生活服务业务的算法支持工作；职责范围包括提高决策信息覆盖，提升转化效率，改善用户体验，探索更高效的商业模式，提升内容理解程度等；\r\n2、利用海量数据搭建业内领先的机器学习算法和架构建模用户反馈，提升用户体验；\r\n3、应用先进的机器学习技术，解决各种内容理解相关性，在线/离线，大数据量/小数据量，长期/短期信号等不同场景中遇到的各种挑战；\r\n4、对用户、作者、商家的行为做深入的理解和分析，制定针对的算法策略促进生态良性发展。','1、本科及以上学历在读；\r\n2、具备优秀的编码能力，扎实的数据结构和算法功底；\r\n3、优秀的分析问题和解决问题的能力，对解决具有挑战性问题充满激情；\r\n4、对技术有热情，有良好的沟通表达能力和团队精神；\r\n5、熟悉机器学习、计算机视觉、自然语言处理、数据挖掘中一项或多项。','2025-06-28 07:40:13.982821','2025-06-28 08:59:53.257490'),(3,'后端开发','字节跳动','北京','','3-5年','本科','英语','','','2025-06-28 10:29:06.647653','2025-06-28 10:29:06.647679');
/*!40000 ALTER TABLE `jobs_jobposition` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `match_jobmatchtask`
--

DROP TABLE IF EXISTS `match_jobmatchtask`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `match_jobmatchtask` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `status` varchar(10) NOT NULL,
  `last_processed_resume_id` varchar(32) DEFAULT NULL,
  `updated_at` datetime(6) NOT NULL,
  `job_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `job_id` (`job_id`),
  CONSTRAINT `match_jobmatchtask_job_id_923eb492_fk_jobs_jobposition_id` FOREIGN KEY (`job_id`) REFERENCES `jobs_jobposition` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `match_jobmatchtask`
--

LOCK TABLES `match_jobmatchtask` WRITE;
/*!40000 ALTER TABLE `match_jobmatchtask` DISABLE KEYS */;
INSERT INTO `match_jobmatchtask` VALUES (1,'已完成',NULL,'2025-06-28 14:21:20.896205',3),(2,'匹配中',NULL,'2025-06-28 11:07:36.040159',2),(3,'匹配中',NULL,'2025-06-28 14:09:09.594638',1);
/*!40000 ALTER TABLE `match_jobmatchtask` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `match_matching`
--

DROP TABLE IF EXISTS `match_matching`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `match_matching` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `status` varchar(20) NOT NULL,
  `score` double DEFAULT NULL,
  `score_source` varchar(100) NOT NULL,
  `scored_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `job_id` bigint NOT NULL,
  `resume_id` varchar(32) NOT NULL,
  `task_status` varchar(10) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `match_matching_resume_id_job_id_5167a41f_uniq` (`resume_id`,`job_id`),
  KEY `match_matching_job_id_dfd0344f_fk_jobs_jobposition_id` (`job_id`),
  CONSTRAINT `match_matching_job_id_dfd0344f_fk_jobs_jobposition_id` FOREIGN KEY (`job_id`) REFERENCES `jobs_jobposition` (`id`),
  CONSTRAINT `match_matching_resume_id_977226f7_fk_resumes_resume_resume_id` FOREIGN KEY (`resume_id`) REFERENCES `resumes_resume` (`resume_id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `match_matching`
--

LOCK TABLES `match_matching` WRITE;
/*!40000 ALTER TABLE `match_matching` DISABLE KEYS */;
INSERT INTO `match_matching` VALUES (1,'进入初筛',7,'自动打分器','2025-06-28 00:00:27.323134','2025-06-28 07:17:57.391032',1,'8be599659cV971a5d7b4b10','已完成'),(2,'进入初筛',6,'自动打分器','2025-06-28 00:00:54.665109','2025-06-28 07:12:57.332008',1,'8ee0936898eaD911c5a794717','已完成'),(3,'未过分数筛选',0,'自动打分器','2025-06-28 00:01:22.001643','2025-06-28 03:01:05.243422',1,'memory','已完成'),(4,'进入初筛',6,'自动打分器','2025-06-28 07:43:15.793861','2025-06-28 07:43:15.793920',2,'8be599659cV971a5d7b4b10','已完成'),(6,'未过分数筛选',2,'自动打分器','2025-06-28 07:44:11.979180','2025-06-28 07:44:11.979242',2,'8ee0936898eaD911c5a794717','已完成'),(8,'未过分数筛选',3,'自动打分器','2025-06-28 07:45:08.123043','2025-06-28 07:45:08.123103',2,'memory','已完成'),(10,'未过分数筛选',4,'自动打分器','2025-06-28 14:04:34.732332','2025-06-28 14:04:34.732572',3,'87e2966590ebE931f5f714a19','已完成'),(11,'进入初筛',6,'自动打分器','2025-06-28 14:05:01.452334','2025-06-28 14:05:01.452408',3,'87ed9a6499K91185b714712','已完成'),(12,'未过分数筛选',5,'自动打分器','2025-06-28 14:05:28.207979','2025-06-28 14:05:28.208046',3,'88e09b649debH9a1c507c4611','已完成'),(13,'未过分数筛选',3,'自动打分器','2025-06-28 14:05:54.984543','2025-06-28 14:05:54.984616',3,'88e1926e96X941b587f4912','已完成'),(14,'进入初筛',6,'自动打分器','2025-06-28 14:06:22.332353','2025-06-28 14:06:22.332414',3,'88e2986f94M941f597e4914','已完成'),(15,'进入初筛',6,'自动打分器','2025-06-28 14:06:49.136297','2025-06-28 14:06:49.136356',3,'88e5976499W941a58794912','已完成'),(16,'进入初筛',7,'自动打分器','2025-06-28 14:07:16.044111','2025-06-28 14:07:16.044154',3,'88e7926897ebI9a1d59794f18','已完成'),(17,'进入初筛',7,'自动打分器','2025-06-28 14:07:43.064736','2025-06-28 14:07:43.064809',3,'88ee966992H94165f7b4d12','已完成'),(18,'进入初筛',7,'自动打分器','2025-06-28 14:08:10.159844','2025-06-28 14:08:10.159918',3,'89e1926497H9a1b58794e16','已完成'),(19,'进入初筛',6,'自动打分器','2025-06-28 14:08:37.050399','2025-06-28 14:08:37.050456',3,'89e7926394F9a1d59784817','已完成'),(20,'未过分数筛选',5,'自动打分器','2025-06-28 14:09:03.940909','2025-06-28 14:09:03.940966',3,'89ee956c98B9a16507a4718','已完成'),(21,'进入初筛',6,'自动打分器','2025-06-28 14:09:31.045917','2025-06-28 14:09:31.045974',3,'8be09c679bQ971c5b7c4b14','已完成'),(22,'未过分数筛选',5,'自动打分器','2025-06-28 14:09:57.828716','2025-06-28 14:09:57.828779',3,'8be193669eeeN921b5a7f4a10','已完成'),(23,'未过分数筛选',5,'自动打分器','2025-06-28 14:10:24.640837','2025-06-28 14:10:24.640890',3,'8be194689eG971b5c7c4e14','已完成'),(24,'进入初筛',7,'自动打分器','2025-06-28 14:10:51.514045','2025-06-28 14:10:51.514097',3,'8be599659cV971a5d7b4b10','已完成'),(25,'未过分数筛选',5,'自动打分器','2025-06-28 14:11:18.323710','2025-06-28 14:11:18.323750',3,'8be59a649ee7C921a5b7c4c13','已完成'),(26,'进入初筛',6,'自动打分器','2025-06-28 14:11:45.141430','2025-06-28 14:11:45.141487',3,'8be7996395e7L921d5d7a4d16','已完成'),(27,'进入初筛',6,'自动打分器','2025-06-28 14:12:11.937294','2025-06-28 14:12:11.937344',3,'8be79f6a9aO971d5e784b14','已完成'),(28,'进入初筛',7,'自动打分器','2025-06-28 14:12:38.725951','2025-06-28 14:12:38.726013',3,'8be89a6992K971e5c7c4f16','已完成'),(29,'进入初筛',6,'自动打分器','2025-06-28 14:13:05.491056','2025-06-28 14:13:05.491100',3,'8bed956597H9718507a4e16','已完成'),(30,'进入初筛',6,'自动打分器','2025-06-28 14:13:32.276580','2025-06-28 14:13:32.276624',3,'8bee9d6693Y97165e784a12','已完成'),(31,'未过分数筛选',4,'自动打分器','2025-06-28 14:13:59.046745','2025-06-28 14:13:59.046800',3,'8ce79d6697e7R971d5e7f4819','已完成'),(32,'未过分数筛选',4,'自动打分器','2025-06-28 14:14:25.824983','2025-06-28 14:14:25.825027',3,'8ce9956d9ae9C9717517e4b15','已完成'),(33,'进入初筛',6,'自动打分器','2025-06-28 14:14:52.621303','2025-06-28 14:14:52.621365',3,'8ee0936898eaD911c5a794717','已完成'),(34,'未过分数筛选',0,'自动打分器','2025-06-28 14:15:19.363213','2025-06-28 14:15:19.363258',3,'memory','已完成');
/*!40000 ALTER TABLE `match_matching` ENABLE KEYS */;
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
INSERT INTO `resumes_resume` VALUES ('87e2966590ebE931f5f714a19','2025-06-28 12:51:42.589279','2025-06-28 12:51:42.589338','[]','匹配中','[]','','[{\"salary\": \"25-30k×15薪\", \"location\": \"上海\", \"position\": \"基金/证券资产管理\"}]','贾**','方便联系时间：随时联系 | 男 27岁 上海 硕士 工作3年 25k · 14薪 | 量化与衍生品交易 中国国际金融股份有限公司','','[]','计算机和金融工程背景，热爱金融行业，专长量化选股及衍生品的设计与交易','[]','在职，看看新机会','[]','[{\"company\": \"中国国际金融股份有限公司\", \"job_name\": \"量化与衍生品交易\", \"职责业绩\": \"•\\t使用Wind、Python和VBA等工具，进行个股和宽基的量价数据导出、清洗和处理，量化多因子和波动率策略模型的搭建、回测和优化，分析预测标的中短期变动趋势，挖掘相应衍生品市场的定价偏差；对筛选后的核心标的池及期权进行密切监测，日频收集、整理并更新相关市场信息和数据 •\\t开发量化选股+衍生品投资策略，根据模型所预测的目标板块走势，遵循期权费和保证金使用率最优原则，在不同市场情况下分别进行宽基指数的Buy Put、Sell Call和宽跨式期权卖出（Short Strangle）交易及核心池内信号最强个股的场内双融、场外安全气囊（Airbag）和7095结构交易，策略实现5年最大回撤7.32%，总收益率87.75%（年化13.43%），年化波动率6.82%，夏普比率1.53 •\\t负责搭建并维护公司场外期权交易台的风险管理体系，对各类创新型奇异期权，根据其希腊字母等特性，进行对冲策略制定、盘中仓位实时监控和盘后梳理、追保及强平框架体系的持续迭代优化\", \"employment_period\": \"（2022.03 - 至今, 3年3个月）\"}]'),('87ed9a6499K91185b714712','2025-06-28 12:51:42.877208','2025-06-28 12:51:42.877245','[\'CFA特许金融分析师三级\', \'FRM金融风险管理师二级\']','匹配中','[]','','[{\"salary\": \"18-30k×24薪\", \"location\": \"上海\", \"position\": \"固定收益业务\"}]','张**','方便联系时间：随时联系 | 男 28岁 上海 硕士 工作2年 保密 | 资金管理总部 投资交易岗 海通证券','','[{\"project_name\": \"华创金工团队量化策略开发培训\", \"项目描述\": \"团队首席王小川老师全程教学，采用Python来写股票、商品策略的回测，学习多因子、CTA、市场中性、资产配置等策略。 项目目标为培养学生达到业界做量化1年的成手水平。\", \"项目职务\": \"学生\", \"employment_period\": \"（2020.12 - 2021.04）\"}]','积极进取，学习能力强。善于观察及沟通，对数字敏感，执行力强。能与周围人良好相处，社交能力较强。\n对于金融行业有高度的热情，有较强的自我驱动力、学习能力和责任感。\n热爱运动、健身，善于负荷管理，能承受较大的工作压力。\n热爱阅读，能够自发学习，充分利用碎片时间提升工作能力，年均阅读量50+。','[]','在职，看看新机会','[]','[{\"company\": \"海通证券\", \"job_name\": \"资金管理总部 投资交易岗\", \"职责业绩\": \"发挥前期积累的风险控制经验和流动性研究优势，灵活运用各种交易工具，实现公司流动性储备运作的安全有效，包括但不限于利率债券、信用拆借、银行间质押式回购、交易所回购、基金理财的申赎等方式；建立和维护与主要银行间流动性提供者的关系；帮助管理公司的流动性风险；执行交易经理的投资指令，完成每日的头寸管理。\", \"employment_period\": \"（2023.04 - 至今, 2年2个月）\"}, {\"company\": \"海通证券\", \"job_name\": \"资金管理总部 流动性投资研究岗\", \"职责业绩\": \"深度挖掘市场流动性特点，进行一系列投资策略研究。通过对宏观经济走势、行业动态及金融市场流动性的研究，完成部门交代的日度、周度、月度、季度、年度投资策略展望以及各类不定期的研究课题，更好地把握市场脉络，并制定投资配置策略。\", \"employment_period\": \"（2023.03 - 2023.04, 1个月）\"}, {\"company\": \"海通证券\", \"job_name\": \"资金管理总部 风险控制岗\", \"所在部门\": \"全球投资部\", \"职责业绩\": \"严格遵循公司的风险管理政策和流程，参与我部每日资金运作交易的风险评估和审批工作，确保公司流动性资产运作的安全性。通过定期的数据监控与报送和更新部门的各类管理办法，有效降低了潜在投资风险。协助完成部门的合规管理有效性评估及运行有效性测试，对我部投资业务进行合规自查，确保业务推进的合规有效。\", \"employment_period\": \"（2022.09 - 2023.03, 6个月）\"}]'),('88e09b649debH9a1c507c4611','2025-06-28 12:51:43.159004','2025-06-28 12:51:43.159024','[]','匹配中','[]','','[{\"salary\": \"13-16k×14薪\", \"location\": \"上海\", \"position\": \"风险管理/控制\"}]','李**','方便联系时间：随时联系 | 男 27岁 上海 硕士 工作2年 12k · 14薪 | 咨询顾问 中证数智科技(深圳)有限公司','','[{\"project_name\": \"中泰证券同一客户二期项目\", \"项目描述\": \"作为项目组核心成员，参与中泰证券机构限额、产品限额管理现状调研环节，对标同业金融机构同一客户、同一产品限额实践，参照商业银行资本管理办法，在限额模型中考虑违约概率、期限因子、违约相关性等参数，为客户建立机构限额方案、产品限额方案，在为公司限额管理提供量化依据的同时，更好的公司实现精细化风险管理的需求。\", \"项目职务\": \"咨询顾问\", \"employment_period\": \"（2023.10 - 2023.12）\"}, {\"project_name\": \"东吴证券内评体系建设二期项目\", \"项目描述\": \"1. 深入参与金融机构的项目，主导交易对手风险评估打分卡的优化，提升了风险管理的精准度。 2. 独立承担工商企业量化模型的咨询与开发，为企业的风险决策提供科学依据。 3. 成功建立并优化了项目内评体系，提高了团队的整体评估效率和准确性。\", \"项目职务\": \"咨询顾问-信用风险\", \"项目职责\": \"1. 对东吴证券的交易对手模型进行全面评估，进行指标分析与数据验证，调整指标权重和参数，以提升模型的准确性和适应性。 2. 利用申万和中证行业分类，创新性地对未覆盖公开主体进行行业敞口划分，增强了风险敞口管理的全面性。 3. 独立开发了房地产等五大行业及通用模型的专家打分卡，有效提升了信用评级的针对性和专业性。 4. 撰写模型方法论，建立主标尺开发流程，对量化模型的排序结果进行校准，推动内评结果在单一客户限额管理中的实际应用。\", \"employment_period\": \"（2023.03 - 2023.07）\"}]','个人总结\n通过了CPA考试科目：会计、公司战略与风险管理，熟练掌握财务分析、会计审计、公司风险管理知识。\n在职期间为多家头部金融机构提供过咨询支持，对相关的业务流程有较为深入系统的了解。\n具有团队协作精神，能够承受工作压力，具有较高的执行力。目标导向，具有对新知识、新技能不断探索的能力，具有良好的逻辑思维能力和分析能力。','[]','离职，正在找工作','[]','[{\"company\": \"中证数智科技(深圳)有限公司\", \"job_name\": \"咨询顾问\", \"所在部门\": \"信用风险管理方案部\", \"职位类别\": \"咨询顾问\", \"职责业绩\": \"1. 深度参与并成功助力中金公司等五家知名金融机构的信用风险管理项目，提升了其内部评级体系的效率与准确性。 2. 精通R语言和Python，负责信用风险建模，通过精准计算和验证，推动模型的升级迭代，提高了风险控制水平。 3.通过指标体系优化，提升了风险评估体系的全面性和精细化，有效降低了潜在的信用风险。\", \"薪　　资\": \"12k · 14薪\", \"employment_period\": \"（2022.07 - 2024.01, 1年6个月）\"}, {\"company\": \"安永\", \"job_name\": \"审计实习生\", \"所在部门\": \"金融审计\", \"职责业绩\": \"参与项目：徽商银行年度财务报表审计、哈啰单车、日照钢铁集团中期财务报表审阅 实习期间主要工作职责： ①独立负责项目中关联方的审计，针对关联交易实施检查、函证等审计程序、得出审计结论并完成审计报告中关联方的披露，同时协助审计师完成其他科目的工作底稿。 ②查询并整理被审计单位工商信息的变更情况，完成验资程序，通过查阅以前年度的审计工作底稿和被审计单位的提供的内部资料，验证被审计单位针对关联方的披露是否准确完整。 ③协助审计人员检查账务凭证，绘制穿透测试流程图，对业务发生的商业合理性、金额、数量、原始单据，涉及第三方（包括关联方）、业务流程进行梳理。 ④负责将被审计客户的审计工作底稿归类至所属科目，并负责将整理好的工作底稿上传至云平台，根据审计人员针对工作底稿的修改，完成底稿的归档更新工作。\", \"employment_period\": \"（2021.07 - 2022.04, 9个月）\"}]'),('88e1926e96X941b587f4912','2025-06-28 12:51:43.483712','2025-06-28 12:51:43.483748','[]','匹配中','[]','','[{\"salary\": \"23-25k×15薪\", \"location\": \"济南\", \"position\": \"IT项目管理\"}]','陈**','方便联系时间：随时联系 | 男 35岁 济南 本科 工作11年 | 软件项目经理 亚信科技(中国)有限公司','','[]','11年通信行业经验，其中5年项目现场研发团队管理经验，3年研发项目管理经验，具备运营商综合代维/运维、集客业务开通、综合资源管理、数据中台、DICT数字乡村、无线运维智能体、烟草洞察分析等项目经验，长期在项目现场与客户合作，具备较强的沟通、分析问题和解决问题的能力；2018财年S级优秀员工。','[]','在职，看看新机会','[]','[{\"company\": \"亚信科技(中国)有限公司\", \"job_name\": \"软件项目经理\", \"职责业绩\": \"主要负责山东移动DICT数字乡村项目、烟草洞察分析平台、域外某所数据治理等项目的项目管理工作以及中移金科大数据平台项目的软件开发管理工作。 1、担任山东移动DICT数字乡村项目经理，协助客户完成数字乡村一期平台建设与推广。 2、担任烟草洞察分析平台项目项目经理，协助客户完成一期平台建设与推广。 3、担任域外某所数据治理项目项目经理，在人力资源有限、对域外某所行业经验欠缺的情况下，克服困难，带领项目团队，取得项目重大进展。 4、担任中移金科大数据平台项目研发经理，在Java开发组长离职、人员缺口较大的情况下，迎难而上，紧急支撑Java开发管理工作，在支撑用户需求开发、研发团队管理上取的重大进展，客户满意度有显著提升。\", \"employment_period\": \"（2022.05 - 至今, 3年1个月）\"}, {\"company\": \"浪潮通信信息系统有限公司\", \"job_name\": \"技术/研发经理\", \"职责业绩\": \"项目现场研发团队管理，获得2018财年S级优秀员工评优。 主要负责运营商O域项目，协同项目经理细化用户需求进行软件设计和研发管理交付工作。业务涵盖O域资源管理、集客支撑、代维管理、权限管理等方面。对流程引擎工作流和权限管理有深入理解。  移动侧：人力资源管理、权限管理、综合代维、综合资源、资源配置、集客支撑、集客一体化、集客预覆盖等系统 铁塔侧：权限管理、铁塔两资一产、铁塔在线、发电取信、设计监理、资源储备管理等系统 联通侧：短信客服支撑系统以及权限管理\", \"employment_period\": \"（2015.09 - 2022.05, 6年8个月）\"}]'),('88e2986f94M941f597e4914','2025-06-28 12:51:43.748761','2025-06-28 12:51:43.748787','[\'证券从业资格证\', \'基金从业资格证\']','匹配中','[]','','[{\"salary\": \"22-30k×18薪\", \"location\": \"上海\", \"position\": \"量化研究\"}]','洪**','方便联系时间：随时联系 | 男 30岁 北京-朝阳区 硕士 工作4年 保密 | 量化风控工程师 嘉实基金','','[{\"project_name\": \"ETF销售端平台开发\", \"项目描述\": \"独立开发ETF销售端分析平台，包括机构、个人、日报、周报看板，系统开发技术结合Flask框架和Redis日之缓存服务，为Smart-Beta指数投资部提供数据支持\", \"项目职务\": \"\", \"employment_period\": \"（2024.06 - 至今）\"}, {\"project_name\": \"策略回测平台开发\", \"所在公司\": \"嘉实基金\", \"项目描述\": \"主导设计和开发量化策略回测框架并嵌入基于3秒快照数据的撮合算法为股票交易提供量化支持;同时使用框架编 写网格交易策略，赋能ETF销售端的业务分析\", \"项目职务\": \"独立负责人\", \"employment_period\": \"（2024.04 - 至今）\"}]','技能优势：\n精通和熟练主流编程：Python, C++, Oracle, MySQL \n熟悉：GitLab, Spark, JAVA, Web Crawler, Linux and Shell Scripts, \n熟练掌握其他业务工具：WIND, Bloomberg, 机器学习机器算法工具包 sklearn/keras \n业务能力优势：\n具有两年对接业务和各平台的经验，具有较强的沟通和问题解决的实操能力；应届生免实习直接录用，对各业务的学习和理解有很强的吸收运用能力','[\"机器学习\"]','在职，看看新机会','[]','[{\"company\": \"嘉实基金\", \"job_name\": \"量化风控工程师\", \"职责业绩\": \"于2021年6月3日就职于嘉实基金风险部门的风险科技组，主要的工作内容是量化分析和开发，主要方向在固收方向，熟悉转债、纯债、利率互换、国债期货等；负责项目包括但不限于模型研究（其中包括因子模型、可转债组合的业绩拆解模型、关键久期和利率结构模型）、定制和维护各业务线上基金业绩相关的风险报告，合作开发绩效风控平台功能，如业绩落后和非标项目投资监控、数据挖掘计算各类风控指标、资配模型研究和结构化产品的定价和市场调研。\", \"employment_period\": \"（2021.06 - 至今, 4年）\"}, {\"company\": \"8B Education Investments\", \"job_name\": \"数据分析师\", \"职责业绩\": \"1. 准备数据和机器学习模型来预测非洲在美毕业生的薪水，以投资某些目标人群达到短期收益最大化 2. 应用scrapy进行网页数据爬取，再利用Python和MySQL正则表达式清洗数据，重新设计表格以标准化和映射数据，并将所有标准化数据归一化为一张表，以进行模型特征设计 3. 对数据进行特征工程，深入探索特征值和有效数据，研究并设计模型方案，利用Python的机器学习进行进一步的分析、改进和预测\", \"employment_period\": \"（2020.07 - 2020.09, 2个月）\"}, {\"company\": \"华福证券\", \"job_name\": \"其他基金/证券/期货/投资\", \"下属人数\": \"0\", \"工作地点\": \"泉州\", \"所在部门\": \"市场经理部\", \"职责业绩\": \"1. 通过对中国 A 股市场指数分析（MACD，VIX），用 100 万模拟资金进行模拟投资 2. 设计课题并针对 20 名客户进行期权市场培训并获得 100%的通过率 3. 跟踪学习对于客户的投资政策声明（IPS）的制定\", \"employment_period\": \"（2018.07 - 2018.08, 1个月）\"}]'),('88e5976499W941a58794912','2025-06-28 12:51:44.106484','2025-06-28 12:51:44.106508','[]','匹配中','[]','','[{\"salary\": \"15-25k×16薪\", \"location\": \"上海\", \"position\": \"基金/证券资产管理\"}]','王**','方便联系时间：随时联系 | 男 31岁 上海 博士 工作2年 保密 | 量化研究员 海证期货','','[]','奖学金，资历证书及技能\n• 研究生毕业论文项目获2500英镑奖学金\n• 通过CFA一级考试，基金从业资格证，期货从业资格证\n• 精通Python编程，熟练使⽤SQL数据库语言\n发表⽂章\n• Azarbar, A., Wang, Y. and Nadarajah, S., 2019. Simultaneous Bayesian modeling of longitudinal and survival data in breast cancer patients. Communications in Statistics-Theory and Methods, pp.1-15.','[\"cfa\", \"海外教育背景\"]','在职，看看新机会','[]','[{\"company\": \"海证期货\", \"job_name\": \"量化研究员\", \"职责业绩\": \"1. 负责A股二级市场数据挖掘、处理，建立本地金融数据库，为量化策略开发提供数据支持。 2. 建立因子有效性测试框架，负责股票市场因子数据挖掘以及因子测试。 3. 搭建多因子回测框架和持续跟进优化量化策略。 4. 负责开发股指强弱对冲套利策略和商品趋势策略。 5. 负责CTA、套利类策略私募基金的调研工作，通过基金管理人访谈、基金经理投资策略分析、产品业绩归因与风险分析等多个角度，综合评价基金管理人情况，出具相关分析报告 6. 负责商品板块部分品种的市场跟踪和分析。 7. 负责撰写部门策略周报。内容涵盖每周市场表现、基金产品业绩追踪、资管FOF的业绩表现以及市场展望等多个方面。\", \"employment_period\": \"（2024.02 - 至今, 1年4个月）\"}, {\"company\": \"海证期货有限公司，资产管理总部，上海\", \"job_name\": \"量化研究员\", \"职责业绩\": \"• 1. 负责A股二级市场数据挖掘、处理，建立本地金融数据库，为量化策略开发提供数据支持。 • 2. 建立因子有效性测试框架，负责股票市场因子数据挖掘以及因子测试。 • 3. 搭建多因子回测框架和持续跟进优化量化策略。 • 4. 负责开发股指强弱对冲套利策略和商品趋势策略。 • 5. 负责CTA、套利类策略私募基金的调研工作，通过基金管理人访谈、基金经理投资策略分析、产品业绩归因与风险分析等多个角度，综合评价基金管理人情况，出具相关分析报告 • 6. 负责商品板块部分品种的市场跟踪和分析。 • 7. 负责撰写部门策略周报。内容涵盖每周市场表现、基⾦产品业绩追踪、资管FOF的业绩表现以及市场展望 等多个方面。\", \"employment_period\": \"（2023.02 - 至今, 2年4个月）\"}, {\"company\": \"山西证券，贸易金融部，上海\", \"job_name\": \"量化策略研究实习生\", \"职责业绩\": \"• 完成CTA策略课题《捕捉大宗商品低波放大的趋势跟踪策略》\", \"employment_period\": \"（2022.08 - 2022.11, 3个月）\"}, {\"company\": \"山西证券\", \"job_name\": \"量化研究员实习生\", \"职责业绩\": \"暑期实习项目，完成课题《捕捉低波动率放大形态并追踪趋势》 策略概述--回顾期货市场行情，我们总能观测到行情风格在强波动率和弱波动率之间不停转换。这种强弱波动率的交替转换具有一定的普遍性和持续性。 策略的目的在于探索价格的低波动率区间，布局波动率由弱变强的节点，以一定的试错成本，来赚取未来趋势行情中可观的收益。\", \"employment_period\": \"（2022.08 - 2022.11, 3个月）\"}, {\"company\": \"申万宏源证券研究所，非银金融组，上海\", \"job_name\": \"实习⽣\", \"职责业绩\": \"• 收集行业数据，建立上市券商财务预测模型 • 撰写上市券商季度、半年度业绩点评\", \"employment_period\": \"（2016.01 - 2016.07, 6个月）\"}, {\"company\": \"申万宏源证券研究所\", \"job_name\": \"实习生\", \"所在部门\": \"非银金融组\", \"职责业绩\": \"1. 收集行业数据，建立财务数据预测模型 2. 协助撰写上市券商季度及半年度业绩点评 3. 协助撰写拟上市券商的分析报告\", \"employment_period\": \"（2016.01 - 2016.07, 6个月）\"}, {\"company\": \"上海证大资产管理有限公司\", \"job_name\": \"实习⽣\", \"职责业绩\": \"• 收集整理拟投资标的公司数据，进行行业对比，出具投资建议报告 • 协助校对公司私募基⾦产品合同\", \"employment_period\": \"（2015.08 - 2015.12, 4个月）\"}, {\"company\": \"上海证大投资发展有限公司\", \"job_name\": \"实习生\", \"工作地点\": \"上海\", \"职责业绩\": \"1.协助校对公司私募基金产品合同 2.收集整理拟投资标的公司数据，进行行业对比，出具投资建议报告\", \"employment_period\": \"（2015.08 - 2015.12, 4个月）\"}]'),('88e7926897ebI9a1d59794f18','2025-06-28 12:51:44.325144','2025-06-28 12:51:44.325161','[\'大学英语四级\', \'大学英语六级\', \'证券从业资格证\', \'期货从业资格证\', \'CFA特许金融分析师一级\', \'CFA特许金融分析师二级\', \'FRM金融风险管理师一级\']','匹配中','[]','','[{\"salary\": \"11-22k×12薪\", \"location\": \"上海\", \"position\": \"金融研究\"}]','赵**',' | 男 25岁 上海 本科 工作3年 16.5k | 金融工程师 上海文华财经资讯股份有限公司','','[]','金融学学士（绩点专业前3%），通过CFA二级、FRM一级，兼具扎实的金融理论与量化实践能力。\n主导多因子策略开发（期限结构、库存、量价等因子库）、高频订单流模型、趋势策略及参数优化算法（遗传算法），成功构建商品一致性预期指数与油脂链多维分析体系，融合产业供需、市场情绪与宏观经济数据。\n擅长Python量化开发（API设计、策略移植）、期权策略（对冲/套利）及数据管理（爬虫、情感分析、数据库搭建）。具备大宗商品全链条研究经验（供需平衡表、基差分析、期货定价），深度参与跨部门协作（客户需求提炼、内部培训讲座），输出标准化需求文档并降低沟通成本。\n持有期货投资分析、期货从业资格、证券从业资格，英语流利（六级609、中级口译），可高效支持国际化业务与复杂场景咨询。','[\"cfa\", \"frm\", \"行业研究\", \"量化分析\", \"模型搭建\", \"统计分析\", \"数据分析\", \"量化投资\", \"期货交易\"]','离职，正在找工作','[]','[{\"company\": \"上海文华财经资讯股份有限公司\", \"job_name\": \"金融工程师\", \"职位类别\": \"金融研究\", \"职责业绩\": \"•油脂链基本面与量化研究 主导油脂板块的产业分析功能研究，整合内外部数据，构建、维护可视化多维分析看板（供需平衡表、供应端、需求端、现货、库存、基差、龙虎榜、二级市场、资讯链）。 拆解商品价格的形成过程，识别关键价格驱动因素，运用产业、市场情绪、宏观经济等数据编写量化因子，量化市场参与者的决策依据，有机融合了多因子量化方法和商品定价理论。 •商品价格预测模型 开发基于时间序列模型（GARCH、ARIMA、VARMA、BVAR）和基本面因子的商品价格预测模型，代码提交Bitbucket管理模型迭代。通过梳理行业研究逻辑，挖掘需求、成本、供应、利润、期货、产业链等维度的潜在价格影响因子，运用皮尔逊相关系数、信息增益比例、最大信息系数量化评估因子重要性，筛选出关键影响因子输入模型，成功构建面向大宗商品未来价格的量化预测工具。 •价格与订单流分析 基于Level2数据构建高频订单流分析模型，识别交易订单的规模、方向、分布及大单行为，监测持仓波动与资金流向，分析影响订单流的因素，为交易团队提供日内交易决策支持。 •数据管理与建模基础 与数据工程团队合作，搭建大宗商品数据库，使用SQLServer清洗、标准化及整合内外部来源的数据，进行查询与数据聚合，提取出结构化数据集，为商品基本面分析、量化因子构建、价格预测模型提供可靠的输入。 爬取28家期货公司的品种研报，通过文本情感分析量化涨跌观点，构建商品一致性预期数据库。 •跨部门协作 对接营销团队完成客户访谈，收集、提炼客户在期权量化交易中的核心需求及使用场景，输出标准化需求文档提交开发团队。 通过开展基差、波动率、期权等知识的内部培训与宣讲，搭建开发团队金融知识体系，降低需求沟通返工率。 •商品多因子策略 设计商品多因子量化功能，开发农产品价格驱动因子库，包含期限结构、库存、宏观经济、会员持仓、量价等关键指标，支持交易团队制定套利策略。 •工具开发 基于Python开发参数优化遗传算法，大幅提升参数优化计算速度，为小周期策略、策略组合的参数优化提供了前置条件。\", \"薪　　资\": \"16.5k\", \"employment_period\": \"（2022.04 - 2025.06, 3年2个月）\"}]'),('88ee966992H94165f7b4d12','2025-06-28 12:51:44.582093','2025-06-28 12:51:44.582114','[\'基金从业资格证\', \'CFA特许金融分析师三级\', \'FRM金融风险管理师二级\']','匹配中','[]','','[{\"salary\": \"20-21k×12薪\", \"location\": \"上海\", \"position\": \"量化研究\"}]','吕**',' | 男 30岁 上海 硕士 工作5年 保密 | 风险管理 交银施罗德基金管理有限公司','','[{\"project_name\": \"交银施罗德统一终端平台风控模块\", \"所在公司\": \"交银施罗德基金管理有限公司\", \"项目描述\": \"1、项目背景：公司传统风险管理系统主要依赖外部采购，存在功能分散、效率低、灵活性差等痛点，同时隐含较大的外包风险； 2、项目目标：基于公司自研的统一终端平台，将依赖于外部风险管理系统的功能集成到自研系统的风险管理模块内，达到提升风控效率，减少外包风险的目的； 3、项目概述：项目初期，主要负责梳理外部风控系统功能、总结系统使用痛点、设计系统优化方案。系统测试期，主要负责测试、验证数据准确性、系统稳定性以及功能完整性。功能上线后，主要负责数据准确性的跟踪校验、个性化需求的设计和沟通，以及版本迭代的测试和验证； 4、项目成果：风控模块上线后，集成静态风控、量化风控等主要功能，成功替代衡泰等外购系统，大幅提升风控效率和灵活性。该自研平台荣获央行“金融科技发展奖”。\", \"项目职务\": \"风险管理\", \"employment_period\": \"（2022.06 - 2024.03）\"}, {\"project_name\": \"太保产险智能分析预测平台\", \"所在公司\": \"中国太平洋财产保险股份有限公司\", \"项目描述\": \"1、项目背景：传统产险销售方式成本高、效率低，无法挖掘中高档客户的消费潜力。 2、项目目标：基于太保车险业务的行业领先地位，通过机器学习、人工智能等科技手段，加大对非车险产品的辐射带动，以达到降本增效的目的。 3、项目概述：首先对6000万+车险客户特征的分析，其次基于车险客户的个人特征、行为偏好等特点对数据进行处理，通过逻辑回归、XGBOOST、LGBM等模型算法，最终输出存量客户以及潜在客户对非车险产品的购买概率，帮助销售部门精准定位潜在客户。 4、项目成果：模型率先在太保湖北分公司上线使用，半年结果回顾显示有效降低营销费用近20%。\", \"项目职务\": \"分析与建模\", \"employment_period\": \"（2020.09 - 2020.12）\"}]','1、数学和金融复合背景，研究生就读于UCL的金融风险管理（金融工程类）专业；\n2、CFA、FRM，本科曾获得国际学生奖学金；\n3、熟练掌握市场风险、信用风险、操作性风险、流动性风险等主要风险的计量模型和管理框架；\n4、丰富数据建模经验，能够熟练使用SQL、Python等编程工具实现量化模型开发与建设；\n5、对于债券、股票、外汇以及各类衍生品的估值模型、VaR、ES等计量分析有扎实理论基础。','[\"量化分析\", \"数据统计分析\", \"数据建模\"]','在职，看看新机会','[]','[{\"company\": \"交银施罗德基金管理有限公司\", \"job_name\": \"风险管理\", \"职责业绩\": \"1、负责落实投资合规事前、事中和事后风险管理工作，包括恒生交易系统的合规风控阈值设置和维护、事后对于风控指标的监测以及对投资合规遵守情况的跟踪和提示等； 2、主导公募产品压力测试流程重构，基于公募组合持仓及Wind数据，使用Python开发压力测试框架，实现流程自动化，提升整体压测效率达95%以上； 3、协助建设公司自研系统的风险管理模块，梳理、设计系统需求文档，测试、验证及优化风控模块功能，保障新老系统过渡及自研系统迭代升级，提升风控效率50%以上； 4、负责搭建基金主题池校验机制，基于主题基金的投资目的和策略要求，使用Python构建基金持仓风格多维度校验逻辑，实现校验机制的0到1突破，降低风格漂移导致的合规和声誉风险； 5、负责建设基金产品业绩归因框架，基于估值凭证数据，拆解基金持仓收益率及业绩贡献，追踪分析业绩贡献排名靠后标的市场和舆情风险，有效降低投资风险。\", \"employment_period\": \"（2022.06 - 至今, 3年）\"}, {\"company\": \"中国太平洋财产保险股份有限公司\", \"job_name\": \"分析与建模\", \"下属人数\": \"0\", \"职责业绩\": \"1、负责精算准备金的月度结算、精算模型的系统开发和日常维护，通过管理内外部模型需求，优化数据处理程序，以及协调团队项目资源，提升精算准备金月结时效近30%； 2、协助建立产险智能分析预测平台，基于6000万+车险客户特征数据，使用Python和SQL语言，运用逻辑回归、LGBM等模型算法，识别潜在高档客户，降低营销费用近20%； 3、推动建设产险经营管理分析平台（驾驶舱），分析精算与财务风险指标，追踪资产负债端决策影响，维护月度、季度、年度关键风险指标（KRI），提升财精管理决策效率40%以上； 4、协助推进车险创新产品-UBI的测试与落地，监测驾驶行为数据，优化车险定价因子，管理精算风险模型，实现UBI在分公司上线试点时间提前近3个月。\", \"employment_period\": \"（2020.06 - 至今, 5年）\"}]'),('89e1926497H9a1b58794e16','2025-06-28 12:51:44.814342','2025-06-28 12:51:44.814361','[]','匹配中','[]','','[{\"salary\": \"20-30k×12薪\", \"location\": \"上海\", \"position\": \"行业研究\"}]','刘**','方便联系时间：随时联系 | 男 33岁 上海-浦东新区 博士 工作3年 保密 | 证券分析师 西部证券','','[{\"project_name\": \"琴澳综合发展指数体系研究\", \"项目描述\": \"一、简介：        该项目为本人在珠海市横琴智慧金融研究院任研究员时所负责的项目。本项目构建了横琴珠海横琴新区和澳门特别行政区两地综合发展情况的指标体系。指标体系主要分为三个大方面：        第一是琴澳综合发展指数体系，侧重构建琴澳两地综合性发展的指数评价体系；        第二是琴澳产业发展与创新指数体系，主要构建能够衡量琴澳两地的重点产业发展以及科技创新能力的指数体系；        第三是琴澳金融指数体系，侧重于构建多个能够衡量琴澳两地金融体系发展的指标。       本人为项目主要实际负责人，负责琴澳综合发展指数体系中各指标的构建与度量，对横琴新区和澳门特别行政区进行实地考察，以除导师第一作者身份撰写《琴澳综合发展指数体系研究》专著。 二、成果：        项目成果为专著《琴澳综合发展指数体系研究》，目前清华大学出版社已经排版完成，等待书号审批后印刷。\", \"项目职务\": \"实际负责人\", \"employment_period\": \"（2019.05 - 2020.05）\"}, {\"project_name\": \"大数据背景下股市泡沫预警体系研究\", \"项目描述\": \"一、简介： 本项目在大数据背景下构建完整有效的预警体系，用多维方法对股市泡沫预警。以股市不同行业板块的泡沫作为预警对象，采用指标预警、文本预警、统计预警、模型预警并行的多维方法，对破灭概率较大的泡沫进行事前预警，通过行为金融学、泡沫形成机理等方面挖掘泡沫形成原因并提出科学合理、 操作性较强的防范对策。 二、成果 该项目主要成果为研究报告，运用大数据详细构建了股市泡沫预警体系\", \"项目职务\": \"主要参加人员\", \"employment_period\": \"（2017.04 - 2019.12）\"}]','本人具备3年投研工作经验，在功能性粉体材料、水泥等新材料和传统周期建材板块均具备丰富的研究经验，深度研究能力强，勤奋、积极主动，能够持续通过增量研究和公司跟踪挖掘投资机会。所在团队曾荣获新财富第四名（2022、2023）等奖项。','[\"行业研究\", \"证券分析师\"]','在职，看看新机会','[]','[{\"company\": \"西部证券\", \"job_name\": \"证券分析师\", \"职责业绩\": \"担任化工新材料分析师\", \"employment_period\": \"（2024.04 - 至今, 1年2个月）\"}, {\"company\": \"中泰证券\", \"job_name\": \"行业研究\", \"职责业绩\": \"本人在中泰证券研究所建材&新材料团队任助理分析师、分析师，深度覆盖功能性粉体新材料、水泥、减隔震、铝模板、消费建材等板块及个股。 团队2022年荣获：新财富最佳分析师第4；卖方分析师水晶球奖总榜单第5、公募榜单第3；新浪金麒麟最佳分析师第4；中证报金牛奖第3；Wind金牌分析师第3；Choice最佳分析师团队奖第3、个人奖第2。\", \"employment_period\": \"（2021.07 - 2024.04, 2年9个月）\"}, {\"company\": \"吉林大学量化金融研究中心\", \"job_name\": \"研究员实习\", \"职责业绩\": \"1. 担任吉林大学量化金融研究中心兼职研究员，协助导师管理资金账户，投资 A 股; 2. 负责定增策略、多因子模型策略、ETF 策略等量化策略的开发; 3. 组织举办策略分享会，学习 Python 在金融投资领域的应用，探讨国外投资相关文章。\", \"employment_period\": \"（2016.02 - 2021.06, 5年4个月）\"}, {\"company\": \"珠海市横琴新区智慧金融研究院\", \"job_name\": \"研究院\", \"所在部门\": \"金融研究部\", \"职责业绩\": \"1. 担任研究院研究员，负责月度及季度研究报告的撰写; 2. 构建评价横琴新区和澳门经济金融发展指标评价体系，定期向政府部门发布指标结果; 3. 组织学术论坛，参与粤港澳大湾区各类论坛并进行相关研究成果汇报演讲; 4. 与横琴新区管委会、金融服务局开展研讨会，通过交流沟通，深入了解本地金融需求，并完成相关研究报告。\", \"employment_period\": \"（2019.02 - 2019.08, 6个月）\"}]'),('89e7926394F9a1d59784817','2025-06-28 12:51:45.100287','2025-06-28 12:51:45.100303','[]','匹配中','[]','','[{\"salary\": \"18-25k×12薪\", \"location\": \"北京\", \"position\": \"ERP实施顾问\"}]','德**','方便联系时间：随时联系 | 女 39岁 北京-石景山区 本科 工作16年 保密 | 软件项目经理 京北方信息技术股份有限公司','','[{\"project_name\": \"Saas公有云ERP系统项目\", \"项目描述\": \"1.熟悉用友BIP、YS公有云项目运营模式、实施、支持 2.覆盖模块范围广泛，包含财务、费控、财资、供应链、生产、协同、人力等\", \"项目职务\": \"\", \"employment_period\": \"（2019.01 - 至今）\"}, {\"project_name\": \"资金系统项目\", \"所在公司\": \"远光软件股份有限公司\", \"项目描述\": \"该项目为资金业务系统项目，主要规范客户在资金上的使用流程，实现资金统一管理以及资金总体动向的一个监控分析。\", \"项目职务\": \"ERP实施顾问\", \"项目职责\": \"系统配置、测试、用户培训以及系统运行维护。\", \"employment_period\": \"（2013.10 - 至今）\"}]','1.10余年大型软件公司实施经验，精通财务ERP、SaaS产品实施交付，主导多个央企级项目，兼具甲乙方项目经验；\n2.熟悉基础财务、财务共享、全面预算、费控管理、供应链等领域，擅长需求调研与系统落地规划；\n3.持有软考中级、ITIL、计算机高新技术认证，具备多领域系统集成能力；\n4.逻辑清晰，沟通高效，具备跨部门协作与项目管理经验。','[]','在职，急寻新工作','[]','[{\"company\": \"京北方信息技术股份有限公司\", \"job_name\": \"软件项目经理\", \"职责业绩\": \"1.负责工银Saas产品的人力领域、财资预算领域项目的实施交付和上线支持工作； 2.结合客户的信息化目标，梳理业务场景，规划系统落地，完成需求调研。 3.按需求完成配合完成产品售前讲解等。\", \"employment_period\": \"（2024.10 - 至今, 8个月）\"}, {\"company\": \"用友网络科技股份有限公司\", \"job_name\": \"客户成功CSM\", \"职责业绩\": \"1.担任客户成功经理，负责分公司重点客户的财务相关Saas项目上线后支持服务，以及实施工作； 2.主要负责业务领域包含财务，费控，资金，预算，供应链，人力，生产制造，协同等； 3.负责监控项目进展、协调项目资源，按期汇报项目进度。\", \"employment_period\": \"（2021.01 - 2024.08, 3年7个月）\"}, {\"company\": \"北京首钢自动化信息技术有限公司\", \"job_name\": \"项目经理\", \"职责业绩\": \"1.负责首钢集团财务一体化项目的实施管理，业务领域包含总涨、资金、全面预算、税务、BI展示； 2.负责内部用户需求整理，方案编写； 3.协助完成项目组及实施人员绩效考核； 4.负责与外部软件商对接协调；集团内工作汇报\", \"employment_period\": \"（2019.02 - 2022.02, 3年）\"}, {\"company\": \"远光软件股份有限公司\", \"job_name\": \"项目经理\", \"下属人数\": \"0\", \"工作地点\": \"北京\", \"职责业绩\": \"1、贯彻执行包括项目管理制度在内的公司各项规章制度。 2、合理调度资源，控制项目成本，实现项目经营管理目标。 3、负责编制项目实施计划，协调资源并按计划推进项目实施工作，按时按质交付实施成果。 4、负责客户关系发展与维护，协助公司开展商务工作。 5、负责与项目相关事项的跨部门及外部协调与处理。\", \"employment_period\": \"（2016.01 - 2019.01, 3年）\"}, {\"company\": \"远光软件股份有限公司\", \"job_name\": \"ERP实施顾问\", \"下属人数\": \"0\", \"工作地点\": \"北京\", \"职责业绩\": \"1.负责财务及相关延伸项目系统的配置  2.负责系统上线前的客户培训、项目文档总结等；  3.负责运维过程中的程序报错跟踪及问题解决 4.负责分配组内资源，安排实施计划\", \"employment_period\": \"（2009.07 - 2015.12, 6年5个月）\"}]'),('89ee956c98B9a16507a4718','2025-06-28 12:51:45.348115','2025-06-28 12:51:45.348131','[]','匹配中','[]','','[{\"salary\": \"12-24k×15薪\", \"location\": \"上海\", \"position\": \"Java\"}]','施**','方便联系时间：随时联系 | 女 27岁 上海 硕士 工作3年 保密 | 基金研究 中欧基金','','[{\"project_name\": \"校园商铺秒杀项目\", \"项目描述\": \"项目描述：本项目主要针对秒杀的场景进行的开发工作，其中包含用户登陆、商品的功能模块、秒杀下单等模块，用户可以在商城页面内浏览商品，在秒杀时间段内进行下单支付等操作，管理员可以对商城内的商品列表进行增删改查操作。 技术架构：SpringBoot+SpringMVC+Mybatis+MySQL+Redis 项目内容：1. 基于 session 辅助用户完成注册登录等操作；  2. 订单系统负责商品订单的产生，调用 Mybatis 的注解开发完成对数据库的查询；  3. 秒杀接口优化，采用 redis 预减库存及内存标记，减少数据库和缓存压力，实现 MQ 异步下单。\", \"项目职务\": \"组长\", \"项目职责\": \"本项目主要负责人，负责项目开发\", \"employment_period\": \"（2021.11 - 2022.02）\"}]','拥有扎实的专业知识，较强的学习能力\n能迅速适应各种环境并完成挑战性工作','[]','离职，正在找工作','[]','[{\"company\": \"中欧基金\", \"job_name\": \"基金研究\", \"职责业绩\": \"1 搭建基金分析框架，负责单只基金的页面原型设计，深入挖掘持仓信息进行风格识别和业绩归因； 2 构建基金经理分析框架，挖掘基金经理评价指标，对基金经理的投资能力进行刻画； 3.连接wind数据库api接口，对后端数据进行指标建模，并在前端界面上进行可视化呈现。\", \"employment_period\": \"（2022.07 - 2022.08, 1个月）\"}, {\"company\": \"中国平安\", \"job_name\": \"量化研究员\", \"职责业绩\": \"1. 日常进行数据库的维护更新，为其他部门提供量化分析、数据分析与挖掘技术支持，模型算法等服务； 2. 独立完成了基于K线图的技术曲线分析模型，基于历史上不同技术形态出现的数据计算相关胜率赔率，并被用作部门晨会量化分析技术指标的重要部分； 3. 参与负责基本面中财务因子的挖掘工作，熟悉相关财务指标开发新的预测信号，并运用深度学习进行量化投资策略和深度神经网络的设计、开发和管理； 4. 利用遗传算法进行价量因子的挖掘，对IC值和第一分组超额收益进行回测，筛选得到近10个相关性较低的有效因子； 5. 参与公司量化交易系统、回测平台、数据平台的开发、优化与维护工作；\", \"employment_period\": \"（2021.09 - 2022.06, 9个月）\"}, {\"company\": \"上海兆前投资管理公司\", \"job_name\": \"数据分析\", \"职责业绩\": \"1. 负责每日期权相关交易数据收集、清洗、整理，进行可视化分析，撰写形成研究报告； 2. 编制隐含波动率计算程序，构建波动率择时模型，挖掘出了有效因子，并成功应用于实盘操作中； 3. 以theta最小为目标函数，其他风险因子暴露约束为条件，构建最优持仓组合模型，得到程序化期权投资策略，并进行模拟回测，效果甚好； 4. 对于雪球产品进行研究，利用蒙特卡洛模拟法对收益路径进行模拟，清楚地剖析了雪球产品的结构，构建了雪球产品中隐含奇异期权的定价模型，并通过计算其delta来进行风险衡量。\", \"employment_period\": \"（2021.05 - 2021.09, 4个月）\"}, {\"company\": \"赢彻科技（上海）有限公司\", \"job_name\": \"Python开发工程师\", \"职责业绩\": \"1. 负责数据的挖掘分析、算法建模与数据结果可视化等工作； 2. 针对不同无人驾驶道路状况，构建模型对车辆数据进行分析，判别车辆是否处于安全驾驶中。\", \"employment_period\": \"（2021.02 - 2021.04, 2个月）\"}]'),('8be09c679bQ971c5b7c4b14','2025-06-28 11:58:02.485530','2025-06-28 11:58:02.485555','[\'托福91-100分\', \'CFA特许金融分析师二级\', \'FRM金融风险管理师二级\']','匹配中','[]','','[{\"salary\": \"13-15k×12薪\", \"location\": \"上海\", \"position\": \"量化研究\"}]','周**','方便联系时间：随时联系 | 男 27岁 杭州 硕士 工作3年 8k | 风险管理岗 国海良时期货有限公司','','[{\"project_name\": \"期货市场量化研究\", \"项目描述\": \"独立构建系统化的研究框架，涵盖数据获取、清洗、特征工程、模型构建、策略优化等多个环节。主要工作包括： • 研究框架搭建与数据管理：目前搭建了基于期货有色品种的基本面和量化研究数据库，涵盖 行情、宏观经济指标及上下游基本面数据，实现自动化更新与预处理。 • 量化策略开发及应用：基于供给、需求、库存、价差及宏观五大维度，设计系统化量化基本 面研究框架。运用 Python 编程语言，结合 XGBoost、遗传规划等先进算法构建量化模型，以 优化交易策略的效果。设计并实施多层次的回测验证，确保策略在不同市场环境下的稳健性 和可靠性。 • 完整策略搭建及研究报告输出：具备独立撰写详尽研究报告的能力，精细分析市场动态并提 供深入见解， 目前建有《基于 XGboost 的期货单品种研究报告》《遗传规划在 CTA 信号挖掘 中的应用》《基于期权隐含波动率的交易策略研究》《价差因子及其套利应用》\", \"项目职务\": \"\", \"employment_period\": \"（2024.02 - 至今）\"}, {\"project_name\": \"worldquant（世坤）alpha研究\", \"所在公司\": \"世坤投资咨询\", \"项目描述\": \"参加世坤（worldquant）alpha challenge 项目并获取成为顾问资格，已提交 60 余个涉及国内和国外市场因子， 因子覆盖动量反转因子、优加换手率因子、跳跃因子等方面。\", \"项目职务\": \"\", \"employment_period\": \"（2024.01 - 至今）\"}]','具备较强的自我驱动：虽然目前工作内容主要在期货全面风险管理方面，但自身保持对量化领域的热爱，利用业余时间尝试挖掘可交易量化因子，搭建量化模型，力求通过不断学习与实践提升自己的研究水平。熟练的计算机语言方面：基于学生时期主修课程涉及金工相关计算机语言学习，并保持每日进行一定量的代码编写确保，熟练掌握 Python 等主流量化工具。具备扎实的金融知识储备。已通过多项国际认可的金融证书考试，，进一步巩固了我在金融衍生品领域的专业能力。这些经验使我在量化研究与金融市场分析中能够保持敏锐洞察力，并持续为研究工作注入新思路','[\"风险管理\", \"cfa\", \"frm\"]','在职，急寻新工作','[]','[{\"company\": \"国海良时期货有限公司\", \"job_name\": \"风险管理岗\", \"下属人数\": \"0\", \"职位类别\": \"风险管理/控制\", \"职责业绩\": \"1. 定期报告：撰写公司风险监测月报、管理月报、协同报告等，并按母公司及其他监管部门的要求出具风险管理报告； 2. 全面风险管理：组织并开展全公司范围内的压力测试共计八次，期间也曾参与公司风险限额指标的制定工作，主要负责公司风险自评估以及资管、自有资金投资业务中信用、操作风险自查等风险控制工作； 3. 量化风控：每日核对场外组合头寸的对冲情况及敞口状况，通过敞口监控及 VAR 模型对场外业务的市场风险进行日度风险监控，定期开展基于市场行情、波动率变动假定的情景分析\", \"薪　　资\": \"8k\", \"employment_period\": \"（2021.10 - 至今, 3年8个月）\"}]'),('8be193669eeeN921b5a7f4a10','2025-06-28 12:37:18.814706','2025-06-28 12:37:18.814725','[]','匹配中','[]','','[{\"salary\": \"14-22k×14薪\", \"location\": \"上海\", \"position\": \"Golang\"}]','罗**','方便联系时间：随时联系 | 男 27岁 上海-浦东新区 本科 工作5年 14k · 14薪 | Cocos2d-x客户端开发 汉堂软件工程(上海)有限公司','','[{\"project_name\": \"个人开源项目\", \"项目描述\": \"个人博客 http://www.ionasal.online/ https://github.com/Spirild/jpstudy-back/tree/jpback：日语单词本后端 https://github.com/Spirild/jpstudy-front：日语单词本前端 近期有日语学习的需求，顺手完成的项目，网页端。后端 golang，前端vue，普通mvc（数据层、展现层、控制层）结构。个人代码风格展现一环。\", \"项目职务\": \"\", \"employment_period\": \"（2024.03 - 至今）\"}]','一位坚持不懈且涉猎广泛的玩家，需求到哪学到哪的性格。对新技术的学习相当积极，上手极快。力图将\n实用技术高效地投入日常实践中；将这些惊喜分享至生活中的种种。','[]','在职，暂无跳槽打算','[]','[{\"company\": \"汉堂软件工程(上海)有限公司\", \"job_name\": \"Cocos2d-x客户端开发\", \"下属人数\": \"0\", \"职责业绩\": \"网易互娱客户端开发；\", \"employment_period\": \"（2024.09 - 至今, 9个月）\"}, {\"company\": \"外企德科\", \"job_name\": \"Python开发工程师\", \"职责业绩\": \"工作内容为华为devops一环，保证上线产品合规安全。使用python对jenkins等流水线产品进行解包与分析；使用docker以在容器中运行测试，来对各架构linux进行兼容。最终保证各产品线高效低漏洞交付产品。\", \"employment_period\": \"（2024.07 - 至今, 11个月）\"}, {\"company\": \"赫鲁丝网络\", \"job_name\": \"游戏服务端开发工程师\", \"职责业绩\": \"职责：签到、匹配一类的功能开发，对上线内容维护、debug；gm工具测试开发，提升测试环节效率；内部技术文档搭建，对历史代码优化整合； 技术栈：golang, websocket, mongodb+redis，c#； 结果：推动项目从开发期到买量测试期；测试流程每天节约2小时；后来者可以在3天内熟悉项目架构；\", \"employment_period\": \"（2023.08 - 2024.01, 5个月）\"}, {\"company\": \"上海联恩互联网公司\", \"job_name\": \"Python数据开发工程师\", \"职责业绩\": \"b端业务，参与公司数仓ETL从无到有的搭建过程 职责：通过rpa、阿里提供权限的api中获取数据于mongodb中；根据业务需求创建细化的mysql表，将数据加工洗入；通过django提供数据查看的窗口，并用nginx部署于linux服务器上；通过vue、powerbi等展示数据，或是通过odbc直接导出至excel中； 技术栈：python, django, mysql，clickhouse, vue 结果：数仓从无到有，对早期技术栈、表结构等进行确定；极大精简人力做表时间，原先大促期间需花数小时处理的百万级账单数据，优化至5分钟内完成。\", \"employment_period\": \"（2020.06 - 2023.06, 3年）\"}]'),('8be194689eG971b5c7c4e14','2025-06-28 12:37:19.097958','2025-06-28 12:37:19.097976','[]','匹配中','[]','','[{\"salary\": \"16-22k×14薪\", \"location\": \"上海\", \"position\": \"Python\"}]','叶**','方便联系时间：随时联系 | 男 29岁 厦门 硕士 工作5年 18k · 15薪 | 量化研究 国贸期货','','[]','','[\"c++\", \"python\"]','在职，看看新机会','[]','[{\"company\": \"国贸期货\", \"job_name\": \"量化研究\", \"职位类别\": \"量化研究\", \"职责业绩\": \"1、负责量化交易策略的研究与开发，利用统计学及机器学习方法分析市场数据，寻找交易机会。 2、持续跟踪并评估交易策略的执行效果，根据市场变化进行策略优化。 3、构建并维护高效的量化交易平台，确保交易流程的自动化与准确性。 4、深入研究金融市场动态，探索新的量化模型和技术应用。\", \"薪　　资\": \"18k · 15薪\", \"employment_period\": \"（2023.03 - 至今, 2年3个月）\"}, {\"company\": \"正保教育集团\", \"job_name\": \"研究院\", \"所在部门\": \"财税大数据与人工智能平台研发中心\", \"职责业绩\": \"负责 python 大数据基础、机器学习、深度学习等领域的平台开发及线下课程支持。\", \"employment_period\": \"（2022.06 - 2023.03, 9个月）\"}, {\"company\": \"天健咨询\", \"job_name\": \"研究助理\", \"所在部门\": \"财务舞弊中心\", \"职责业绩\": \"利用机器学习算法评估公司及公司债券财务舞弊概率预测。\", \"employment_period\": \"（2021.05 - 2022.05, 1年）\"}, {\"company\": \"福州理工学院\", \"job_name\": \"经济系教师\", \"职责业绩\": \"负责微观经济学和计量经济学相关课程教学。\", \"employment_period\": \"（2020.07 - 2021.05, 10个月）\"}]'),('8be599659cV971a5d7b4b10','2025-06-27 13:48:27.041364','2025-06-28 08:19:29.728628','[]','匹配中','[{\"time\": \"2014.09-2018.06\", \"school\": \"北京理工大学\", \"details\": \"电子信息\"}]','','[{\"salary\": \"55-60k×15薪\", \"location\": \"上海\", \"position\": \"产品经理\"}]','方**','方便联系时间：随时联系 | 男 29岁 上海 硕士 工作6年 保密 | 数据科学经理，搜索与推荐 Coupang','','[{\"project_name\": \"搜索推荐流量策略优化\", \"employment_period\": \"（2023.05 - 至今）\"}, {\"project_name\": \"搜索数据基建和产品分析\", \"employment_period\": \"（2023.05 - 至今）\"}]','1. 互联网国际化出海行业及外企咨询背景，具备跨国团队协作与团队管理能力。\r\n\r\n2. 7年数据科学与管理咨询工作经验，在搜索推荐、用户增长、金融科技成功推动多个项目并取得显著成果。\r\n\r\n3. 在ToB企业服务领域有丰富的AI解决方案交付经验，领导从需求诊断、模型开发到客户关系维护的全周期管理。','[\"sql\", \"咨询\", \"人工智能\", \"机器学习\", \"数据分析\"]','在职，急寻新工作','[]','[{\"company\": \"Coupang\", \"job_name\": \"数据科学经理，搜索与推荐\", \"employment_period\": \"（2024.03 - 至今, 1年3个月）\"}, {\"company\": \"Coupang\", \"job_name\": \"数据科学经理\", \"employment_period\": \"（2024.03 - 至今, 1年3个月）\"}, {\"company\": \"字节跳动\", \"job_name\": \"数据科学家\", \"employment_period\": \"（2022.04 - 至今, 3年2个月）\"}, {\"company\": \"字节跳动\", \"job_name\": \"数据科学家，TikTok电商数据科学\", \"employment_period\": \"（2022.04 - 2024.02, 1年10个月）\"}, {\"company\": \"Opera Solutions\", \"job_name\": \"分析主管，数据科学\", \"employment_period\": \"（2018.08 - 2022.04, 3年8个月）\"}]'),('8be59a649ee7C921a5b7c4c13','2025-06-28 11:58:02.763424','2025-06-28 11:58:02.763441','[]','匹配中','[]','','[{\"salary\": \"12-13k×12薪\", \"location\": \"上海\", \"position\": \"证券交易员\"}]','孟**','方便联系时间：随时联系 | 女 27岁 上海 硕士 工作3年 | 销售交易 华福证券','','[{\"project_name\": \"量化策略开发\", \"所在公司\": \"国信证券股份有限公司\", \"项目业绩\": \"1）分析国债期货小时线数据，构建量化交易策略；在不同的价格波动率下，运用MACD, 布林线等多项技术指标执行趋势捕捉，反向做多/做空等不同交易指令，该策略2018-2021回测累计收益41倍 2）针对国债期货十分钟线数据，构建ARIMA, EGARCH模型来预测收盘价格和其波动率；将价格和波动率预测值与MLF, 同业存单等其他因子结合，构建XGB等机器学习交易策略，2020-2021回测累计收益达到108倍，夏普比率6.4\", \"项目描述\": \"运用历史数据构建机器学习模型，为固收交易提供投资交易策略 对数据处理分析，运用Python Backtrader库构建量化模型，优化回测框架以及评估量化策略 跟踪并熟悉整个债券市场；搜集数据并分析利率债和信用债行情；结合宏观经济基本面等因素，提供投资策略的建议；\", \"项目职务\": \"策略开发助理\", \"employment_period\": \"（2021.04 - 2021.07）\"}, {\"project_name\": \"业务流程优化\", \"所在公司\": \"AGL Energy\", \"项目描述\": \"1）与公司客户沟通调研，与组员协调沟通，进行任务分配，制定工作框架和任务时间表 2）预处理，清洁，可视化系统日志数据， 构建机器学习模型对异常业务进行分类；找出主要异常业务的行为模式。 3）搜集查找相关业务资料，结合资料定性分析产生异常的原因，针对性给出建议，并将其汇总成研究报告向员工展示讲解；结论帮助AGL减少5%人工成本\", \"项目职务\": \"数据分析员\", \"employment_period\": \"（2020.09 - 2020.12）\"}]','1）三年货币市场以及现券交易经验，有较强的交易执行能力和应变能力，熟练解决交易问题\n2）具备丰富的交易对手资源, 擅于挖掘拓展维护交易对手和客户\n3）结合传统市场分析和量化方法，持续构建并完善投资交易框架，具有良好的市场分批判断能力和应变能力\n4）团队合作经验丰富，有很强的协调沟通，语言表达能力\n5）有韧性，抗压能力强，适应性强，有较强的时间管理能力，能够快速学习新知识和新业务\n6）性格外向，开朗，乐观，喜欢与他人打交道；热爱团体运动比如网球，飞盘\n7）精通汉语，英语；精通Python, R, SQL, Excel, MS Office, SAS, Matlab, Tableau','[]','在职，看看新机会','[]','[{\"company\": \"华福证券\", \"job_name\": \"销售交易\", \"职责业绩\": \"* 执行全品种债券二级撮合交易，执行银行间交易，平均月度成交额5亿元 * 自主开发50+家机构黏性客户（含银行、资管机构、农商行等）发展成为长期交易对手，成为其固收产品核心流动性服务商 * 设计客户分层服务体系，通过定制化对冲策略与实时市场解读，提升客户复购交易频率40% * 搭建机构客户地方债二级撮合解决方案，运用python绘制收益率曲线图，帮助客户复盘，提供投资建议，降低客户交易成本 * 研究量化交易策略，结合国债期货数据，为客户提供利率活跃券走势预测，达到年化收益18% * 撰写风控日报，协助部门进行合规风控自检 * 与一级市场部门和客需部门联动，协助进行分销、募集、一级半等业务\", \"employment_period\": \"（2025.02 - 至今, 4个月）\"}, {\"company\": \"上海国际货币经纪有限责任公司\", \"job_name\": \"经纪人\", \"工作地点\": \"上海\", \"职责业绩\": \"* 协助银行进行存单一级发行的询价，询量，募集；针对不同机构推销存单并帮助客户进行存单一级直投，代投和一级半交易； * 帮助客户进行资金回购，拆借；依据丰富的交易对手资源为客户借到价格合适资金，持续跟踪并更新货币市场资金面； * 对接各金融机构进行存单二级询价，报价，撮合达成交易；提前预判市场价格走势，为经理提供买卖建议；针对不同交易盘和配置盘需求进行个性化询价和推券； * 协助构建货币市场农商组，为部门拓展挖掘并激活超过100家农商行及中小型机构，将多家机构从无交易转变为黏性客户并多次帮助化解交易问题；持续拓展维护不同交易对手，保持客户活跃度； * 承担存单一级二级市场80%过券做市和代付业务，与超过10家做市商紧密合作互帮互助，依据不同机构交易对手和交易需求熟练安排过券，每日催发前后台，多次在紧急时刻解决交易问题；  * 承担货币市场跨部门合作业务，与利率债、信用债、资本中介等部门合作交易，依据客户的需求推荐或挂出现券，为客户提供更丰富的产品，提高机构和同事的交易效率； * 结合不同固收产品进行市场分析，持续跟踪固收市场动态，收集最新市场信息及情绪，把握价格走势，撰写日评分析供客户参考，提出投资交易建议并构建投资交易框架； * 负责部门新入职员工的培养，帮助其熟悉固收市场交易并迅速适应经纪人工作节奏；协助举行公司工会及同业活动，提高团队合作效率，并持续拓展同业交易对手\", \"employment_period\": \"（2021.11 - 2025.02, 3年3个月）\"}, {\"company\": \"国信证券股份有限公司\", \"job_name\": \"策略开发助理\", \"工作地点\": \"上海\", \"所在部门\": \"证券投资总部\", \"职责业绩\": \"对数据处理分析，运用Python Backtrader库构建量化模型，优化回测框架并评估量化策略 跟踪并熟悉整个债券市场；搜集数据并分析利率债和信用债行情；结合宏观经济基本面等因素，提供投资策略的建议； 分析国债期货数据，构建量化交易策略；运用MACD, 布林线等多项技术指标执行趋势捕捉，结合不同因子，构建ARIMA, EGARCH模型来 预测收盘价格和其波动率，达到2018-2021回测累计收益41倍，夏普比率6.4\", \"employment_period\": \"（2021.04 - 2021.07, 3个月）\"}, {\"company\": \"AGL Energy\", \"job_name\": \"数据分析员\", \"所在部门\": \"业务部\", \"职责业绩\": \"与公司客户沟通调研，与组员协调沟通，进行任务分配，制定工作框架和任务时间表 处理并可视化系统日志大数据， 构建机器学习模型；结合资料定性分析产生异常的原因，并将其汇总成研究报告向员工展示讲解；结论帮助AGL减少5%人工成本\", \"employment_period\": \"（2020.09 - 2020.12, 3个月）\"}, {\"company\": \"浙商证券股份有限公司\", \"job_name\": \"量化分析员\", \"工作地点\": \"上海\", \"所在部门\": \"Ficc事业部\", \"职责业绩\": \"搜集并阅读相关研究报告和资料文献，找出潜在有用因子；收集历史数据并运用回归分析构建多因子模型进行条件选股 测评并帮助其余员工运用QuantOS, Backtrader等量化开源系统，整体提升10%工作效率 每日搜集固收市场信息，跟踪债券市场情绪，协助构建投资交易框架；将信息整理汇报；发放会议通知，准备会议文件，协助每周会议顺利\", \"employment_period\": \"（2018.06 - 2018.09, 3个月）\"}]'),('8be7996395e7L921d5d7a4d16','2025-06-28 12:37:19.496662','2025-06-28 12:37:19.496683','[]','匹配中','[]','','[{\"salary\": \"23-26k×13薪\", \"location\": \"上海\", \"position\": \"Java\"}]','于**','方便联系时间：随时联系 | 男 27岁 上海 硕士 工作3年 保密 | 数据中台-软件开发工程师 宁波森浦融讯科技有限公司','','[{\"project_name\": \"SpringBoot自动化转档系统\", \"项目业绩\": \"SpringBoot自动化转档系统\", \"项目描述\": \"基于SpringBoot的开发，根据表配置和请求到的债券数据定时写入到数据库；实现零硬编码，使用类反射实现根据配置自动写入数据，使用JDBC实现批量插入提高写入效率\", \"项目职务\": \"\", \"employment_period\": \"（2025.02 - 至今）\"}, {\"project_name\": \"基于SpringBoot+Dubbo分布式债券数据实时计算引擎\", \"项目业绩\": \"基于SpringBoot+Dubbo分布式债券数据实时计算引擎\", \"项目描述\": \"实时计算平台的指标和报表开发，基于分布式架构开发高性能指标计算引擎，实现单次10万条债券数据在100ms内完成复合指标计算；设计基于SQL-like DSL的指标定义语言，支持动态指标配置与分布式执行计划生成，通过语法树解析优化查询效率；主导性能调优：通过对象池技术减少60%临时对象创建；消除包装类自动装箱操作降低30%GC频率；建立慢查询监控系统（Prometheu s+Grafana）定位优化瓶颈；优化MySQL索引策略，针对债券期限结构、信用评级等关键维度建立组合索引，复杂条件查询性能提升\", \"项目职务\": \"\", \"employment_period\": \"（2024.02 - 至今）\"}]','专业技能\n精通JAVA、Python、Kotlin语言，擅长Web开发和容器开发; 熟悉消息中间件RabbitMQ、Kafka\n熟悉分布式框架Dubbo、Zookeeper等组件\n熟悉Restful开发规范、Linux系统使用。熟悉Docker、Nginx等部署工具\n熟悉医疗影像DICOM相关的数据结构，并熟悉DICOMweb传输协议\n熟悉债券、股票、基金等金融产品的数据管理\n了解人工智能，机器学习，知识表达方法，数据挖掘，爬虫等技术\n了解gRPC、多线程、虚拟化技术','[]','在职，看看新机会','[]','[{\"company\": \"宁波森浦融讯科技有限公司\", \"job_name\": \"数据中台-软件开发工程师\", \"下属人数\": \"0\", \"工作地点\": \"上海\", \"职责业绩\": \"实时计算平台的指标和报表开发，分布式架构开发高性能指标计算引擎，实现单次10万条债券数据在100ms内完成复合指标计算；性能调优：通过对象池技术减少60%临时对象创建；消除包装类自动装箱操作降低30%GC频率；建立慢查询监控系统（Prometheus+Grafana）定位优化瓶颈，使用Druid组件监控连接池；优化MySQL索引策略，针对债券期限结构、信用评级等关键维度建立组合索引，复杂条件查询性能提升\", \"employment_period\": \"（2024.02 - 至今, 1年4个月）\"}, {\"company\": \"宁波森浦融讯科技有限公司\", \"job_name\": \"数据中台-软件开发工程师\", \"职责业绩\": \"负责债券相关的指标和报表等数据接口的开发\", \"employment_period\": \"（2024.02 - 至今, 1年4个月）\"}, {\"company\": \"上海志御软件信息有限公司\", \"job_name\": \"后端开发工程师\", \"下属人数\": \"0\", \"工作地点\": \"上海\", \"职责业绩\": \"负责公司Web项目后端的接口开发和容器化部署，维护公司核心项目运行；配合算法工程师，处理医疗影像算法相关的功能开发，例如图像的预处理、预测结果的后处理；开发PyQt转档数据客户端、开发轻量化本地Web服务用于预测结构的3D模型的展示；开发gRPC容器调用算法代码，实现运行预测代码的环境隔离和拓展优化\", \"employment_period\": \"（2021.11 - 2024.01, 2年2个月）\"}, {\"company\": \"浙江移动杭州分公司\", \"job_name\": \"产品经理-轮岗\", \"职责业绩\": \"试用期轮岗，主要对接移动卡、宽带业务\", \"employment_period\": \"（2021.07 - 2021.10, 3个月）\"}]'),('8be79f6a9aO971d5e784b14','2025-06-28 11:58:03.085309','2025-06-28 11:58:03.085382','[]','匹配中','[]','','[{\"salary\": \"25-35k×24薪\", \"location\": \"上海\", \"position\": \"基金/证券资产管理\"}]','刘**','方便联系时间：随时联系 | 男 32岁 北京 博士 工作4年 保密 | 资产配置研究员 华富基金','','[{\"project_name\": \"实习\", \"所在公司\": \"中国国际金融有限公司\", \"项目描述\": \"中国国际金融有限公司实习\", \"项目职务\": \"资产管理部权益组实习生\", \"项目职责\": \"1、对光伏、风电行业进行深度研究，独立撰写行业研究报告 2、完成若干份科创板上市企业简报，并协助完成其他的数据搜集、整理等日常工作\", \"employment_period\": \"（2019.02 - 2019.05）\"}, {\"project_name\": \"实习\", \"所在公司\": \"中国证监会\", \"项目描述\": \"中国证券监督管理委员会实习\", \"项目职务\": \"研究中心宏观部实习生\", \"项目职责\": \"1、参与我国资本市场直接融资、债券市场刚性兑付2项课题，协助撰写《上市公司债券违约的特点、原因及分析》、《关于直接融资的深入思考与实证分析》等3份研究报告 2、参与A股IPO制度、中美贸易战、欧元区债务危机3项课题，负责相关数据的搜集、计算与分析\", \"employment_period\": \"（2018.04 - 2018.07）\"}]','1、具备编程能力，熟练使用Python、R语言、WindAPI\n2、具备国内外学术文献的阅读和研究能力','[\"资产配置\", \"编程\", \"fof\"]','在职，暂无跳槽打算','[]','[{\"company\": \"华富基金\", \"job_name\": \"资产配置研究员\", \"工作地点\": \"上海-浦东新区\", \"所在部门\": \"FOF投资部\", \"职责业绩\": \"1、进行全球资产配置研究：跟踪海内外宏观情况，对海内外市场（中国、美国、日本、印度等）的股、债、商品（黄金、原油）等各类资产进行跟踪和研究，给出资产配置建议。 2、根据研究成果形成投资策略、开发量化配置模型等，并管理自身模拟组合。\", \"employment_period\": \"（2023.06 - 至今, 2年）\"}, {\"company\": \"民生加银基金管理有限公司\", \"job_name\": \"宏观与资产配置研究员\", \"下属人数\": \"0\", \"所在部门\": \"资产配置部\", \"职责业绩\": \"1、搭建风险预算、Nowcasting等量化模型，对经济数据预测与资产配置提供量化参考；建立宏观分析体系，形成“周期论+政策目标”的宏观分析与配置框架；搭建中观分析体系，形成围绕基本面、政策面、技术面的风格分析和行业选择框架；构建国内外宏观、中观、情绪等多个指标监测数据库。综合以上模型、框架以及日常跟踪，形成大势判断和资产配置建议。成果方面，重点提示到了2022年年初的系统性下跌、年末的疫情政策转变和风格切换，以及看多2023年行情等一系列事件和机会。 2、负责研究跟踪宏观与市场动态并提供策略建议：对海内外宏观情况进行跟踪研究，及时汇报重要的市场动态和市场变化；每周组会进行一周市场回顾和点评，汇报后续大盘、风格以及行业配置观点，每月投决会汇报资产配置观点（股、债、商品），每月讨论会进行研究成果分享，并形成篇研究报告。 3、研究跟踪部分行业并提供相关配置建议：根据投资需求，对部分行业进行一定的研究和跟踪，目前已跟踪过整车、地产、计算机等行业，同时对新能源、煤炭、军工、医药、养殖等也有了解。成果方面，2022年重点提示到了年底信创的布局机会，以及新能源车的下跌风险。 4、协助完成其他事务性工作：配合市场部门完成直播、路演，协助基金经理撰写基金季报、市场观点、组合标的监控等。\", \"employment_period\": \"（2021.11 - 2023.06, 1年7个月）\"}, {\"company\": \"上海东方证券资产管理有限公司\", \"job_name\": \"宏观战略和产品研究\", \"下属人数\": \"0\", \"所在部门\": \"产品部\", \"职责业绩\": \"1、负责宏观与战略研究：围绕宏观环境及政策变化，以公司发展为落脚点提供发展布局策略和建议，具体针对QDII、短债基金、固收+、公募C类份额、量化对冲基金等方面撰写了多篇研究分析报告。 2、负责基金业绩和基金经理风格研究：独自构建基金经理“四风格”模型、对基金经理季度调仓情况实现程序可视化、搭建全市场偏股基金持仓数据库等。 3、参与内部基金经理调研：定量、定性的对本公司以及全市场基金进行分析对比，判断和提炼本公司基金产品特点和基金经理投资风格，为公司在多个产品的宣传推介方面提供研究支持。\", \"employment_period\": \"（2020.07 - 2021.10, 1年3个月）\"}]'),('8be89a6992K971e5c7c4f16','2025-06-28 12:37:18.556852','2025-06-28 12:37:18.556878','[\'FRM金融风险管理师二级\', \'大学英语六级\', \'证券从业资格证\', \'基金从业资格证\', \'期货从业资格证\', \'会计初级职称\', \'AQF\', \'CDA\']','匹配中','[]','','[{\"salary\": \"10-15k×12薪\", \"location\": \"上海\", \"position\": \"数据分析师\"}]','刘**','方便联系时间：随时联系 | 男 27岁 上海 硕士 工作2年 | 数据分析师 上海尚投信息服务有限公司','','[{\"project_name\": \"终端分期产品潜客挖掘模型\", \"所在公司\": \"上海硕恩网络科技股份有限公司\", \"项目描述\": \"项目概述：将目前只在运营商政企大客户实施的产品推广到小客户上，旨在扩大运营商的产品营销范围与营业收入。 项目职责： 1. 数据获取与数据探查：综合运营商、资方、支付公司等提供的数据，筛选可以用于建模的数据。 2. 特征构建：构建受企业规模影响较低的比例型变量100+，使用IV值筛选得到对企业规模影响低的变量，最终选出38个变量。 3. 模型构建：构建PSM技术与重采样技术的样本匹配模型，最终从100w+客户中选出了9.3w客户适合发展终端分期产品。模型AUC为0.97，KS为0.85。构建基于平衡样本的逻辑回归模型，结合评分卡技术，进一步挑选优质潜客发展终端分期产品。模型AUC为0.8，KS为0.52。 4. 模型实施：为运营商提供优质潜客清单，模型已取得运营商江苏省、山东省分公司认可。\", \"项目职务\": \"项目负责人\", \"employment_period\": \"（2024.10 - 2024.12）\"}, {\"project_name\": \"客户信用评级模型\", \"所在公司\": \"上海硕恩网络科技股份有限公司\", \"项目描述\": \"项目概述：通过政企客户的欠费、工商、业务等维度的表现，分析不同客群未来6个月内发生M2+（有效逾期）的概率，旨在优化运营商对存量客户的业务管理能力。 项目职责： 1. 特征工程：基于运营商特征变量库（1000+个）与目标变量，使用WOE+IV进行变量加工与变量筛选，最终选定11个入模变量 2. 模型构建：基于平衡样本的逻辑回归模型，结合评分卡技术，为大、小客户分别制定一套评分卡，用于评估客户的信用评分，模型AUC均在0.87以上，KS均在0.55以上 3. 模型实施：为运营商提供存量客户信用评级清单，与运营商内部评级结果比对后，运营商已将模型结果合并入内部风控模型。\", \"项目职务\": \"项目负责人\", \"employment_period\": \"（2024.08 - 2024.10）\"}]','1.统计学基础扎实：熟悉常用机器学习/深度学习模型，如线性回归、决策树、随机森林、Transformer等，并具备项目中的应用经历；掌握参数调优、模型融合、超参数搜索等技巧，能根据业务场景调整模型底层代码。\n2. 掌握多种数据分析工具：掌握Python、mySQL等编程语言，掌握常用的库和分析框架，如NumPy、Pandas、sklearn、TensorFlow、PyTorch等；可以熟练使用Office、Tableau、FineBI等工具制作可视化报表。\n3. 具备良好的沟通能力和表达能力，能够独立开展数据分析工作。','[\"python\", \"sql\", \"机器学习\", \"深度学习\", \"量化投资\"]','在职，急寻新工作','[]','[{\"company\": \"上海尚投信息服务有限公司\", \"job_name\": \"数据分析师\", \"职责业绩\": \"持续搭建信贷产品风控看板\", \"employment_period\": \"（2025.04 - 至今, 2个月）\"}, {\"company\": \"上海硕恩网络科技有限公司\", \"job_name\": \"数据分析师\", \"下属人数\": \"3\", \"工作地点\": \"上海-黄浦区\", \"所在部门\": \"技术研发部\", \"汇报对象\": \"技术总监\", \"职责业绩\": \"1. 模型研发：作为主要建模技术负责人，带领团队已完成了5个项目的全流程技术研发与上线，为10+项目提供技术指导，主要技术研发方向如下： a. 运营商评分卡项目研发，如：存量客户信用评级模型、逾期欠费客户催缴模型等； b. 运营商潜客挖掘项目研发，如：终端分期产品潜客挖掘模型等； c. 为公司项目提供技术指导与底层代码优化，如：特征变量衍生算法优化（基于OpenFE的自动化特征变量衍生算法优化）、广告推荐算法设计（基于GCN、wide&deep深度学习的模型设计）等； 2. 技术培训：作为对内项目培训负责人，负责整合公司内部项目材料，制作对内培训文档，分批次对内部技术人员进行培训。\", \"employment_period\": \"（2024.04 - 2025.04, 1年）\"}, {\"company\": \"上海赢仕投资管理有限公司\", \"job_name\": \"量化研究员\", \"下属人数\": \"0\", \"工作地点\": \"上海-长宁区\", \"所在部门\": \"量化投资部\", \"汇报对象\": \"投资总监\", \"职责业绩\": \"1. FOF研究： a. 参与股票类、期货套利类、债券类基金尽调,生成尽调报告； b. 使用mysql搭建并维护FOF基金数据库； c 使用pyecharts、FineBI等工具进行可视化分析,并制作分析报告； 2. 量化模型开发: a 以机器学习(浅学习)的方式挖掘股票、可转债的非线性因子; b 搭建股指期货、股指期权合成期货、etf期权合成期货的基差监控系统，并根据基差套利（约1000w资金，年化5%收益）； c 复现并验证机器学习方向的研报与论文；\", \"employment_period\": \"（2023.04 - 2024.04, 1年）\"}]'),('8bed956597H9718507a4e16','2025-06-28 12:37:19.769672','2025-06-28 12:37:19.769687','[]','匹配中','[]','','[{\"salary\": \"8-13k×12薪\", \"location\": \"上海\", \"position\": \"C++\"}]','陶**','方便联系时间：随时联系 | 女 25岁 上海-宝山区 本科 工作3年 | 软件开发工程师（C++） 上海泓科晟睿软件技术有限公司','','[{\"project_name\": \"CSCAD Launcher 界面\", \"所在公司\": \"上海泓科晟睿软件技术有限公司\", \"项目描述\": \"为国产 CAD 软件 CSCAD 开发了启动器\", \"项目职务\": \"客户端开发\", \"项目职责\": \"维护已有的 Launcher 界面 实现了获取用户信息的弹窗界面（C#，html，JavaScript，css），调用后端提供的接口，把数据发送到服务器 实现了用户信息埋点的获取，调用后端提供的接口，把数据发送到服务器\", \"employment_period\": \"（2023.03 - 2023.09）\"}, {\"project_name\": \"CSCAD 智慧钢构插件\", \"所在公司\": \"上海泓科晟睿软件技术有限公司\", \"项目业绩\": \"在把 Qt 嵌入到 MFC 时，解决了 Qt 输入框在副屏上不可点击的问题，Qt 下拉框在副屏上错位的问题\", \"项目描述\": \"为国产 CAD 软件 CSCAD 开发了一个插件：它可以在 CSCAD 中自动生成梁、板、柱、节点\", \"项目职务\": \"C++开发\", \"项目职责\": \"使用 Qt 负责智慧钢构客户端的界面开发（以 Qt 绘制界面，把界面嵌入到 MFC 中，在 CSCAD 弹出 MFC 对话框），包括但不仅限于界面的绘制，支持多选/单选的差别化显示，弹出模态对话框\", \"employment_period\": \"（2022.08 - 2023.03）\"}]','熟悉 C/C++，C++11，STL库，C++多线程开发，Qt 开发，python 开发，MySQL，CMake，socket编程\n熟悉 Linux 命令 • 熟悉常见的开发工具如：QtCreator，Visual Studio，VSCode，git等\n熟悉敏捷开发流程\n英语四级 cet4 546分','[\"python\", \"c++\"]','离职，正在找工作','[]','[{\"company\": \"上海泓科晟睿软件技术有限公司\", \"job_name\": \"软件开发工程师（C++）\", \"职责业绩\": \"使用 Qt 开发 CAD 二次开发中的客户端部分并且修复相关 bug 编写 python 脚本来提高内部的办公效率 维护已有的打包程序的 PowerShell 脚本 维护已有的 Launcher 界面（C#，html，JavaScript，css）\", \"employment_period\": \"（2022.06 - 2023.09, 1年3个月）\"}, {\"company\": \"上海纯达资产管理有限公司\", \"job_name\": \"量化开发\", \"职责业绩\": \"使用 python 采集、清洗公司部分业务数据并分析 使用 python 管理部分MySQL研究数据并更新、编写数据字典 使用 python 在华泰证券MATIC环境中进行数据处理和交易测试 使用 C++ 进行期货CTP接口开发\", \"employment_period\": \"（2021.11 - 2022.05, 6个月）\"}]'),('8bee9d6693Y97165e784a12','2025-06-28 12:37:20.064496','2025-06-28 12:37:20.064515','[]','匹配中','[]','','[{\"salary\": \"20-30k×24薪\", \"location\": \"上海\", \"position\": \"金融研究\"}]','关**','方便联系时间：18点以后及节假日 | 女 29岁 上海 硕士 工作5年 2k | 基金研究员 宁波银行理财子','','[]','本人性格上负责踏实，开朗乐观，善于沟通，热爱金融行业；工作期间负责权益基金和公募对冲基金调研访谈、报告撰写、入库跟踪和专题研究工作，具有理工和金融复合背景，擅长定量工具的应用和编程。','[\"证券分析\", \"量化分析\"]','在职，看看新机会','[]','[{\"company\": \"宁波银行理财子\", \"job_name\": \"基金研究员\", \"下属人数\": \"0\", \"工作地点\": \"上海\", \"职责业绩\": \"2021年-2022年搭建公募权益基金定量研究数据库、定量风格标签、搭建公募量化基金研究框架并辅助投资 ◼ 权益基金的定量研究，使用Python落地基金研究数据库和定量模型开发：2021年负责权益基金定量研究框架搭建研究课题，并进行基金研究数据库搭建和定期更新，数据库包括业绩数据、股票因子数据、基金持仓数据等，并基于基金数据库开发基金评价定量模板，识别基金风格标签，构建基金风格指数，筛选优秀基金标的。 ◼ 权益基金的风格标签课题：2021年负责权益基金风格标签研究课题，基于对基金经理投资方法的理解，从A股市场基金经理投资方法出发自定义五类投资风格，并对三种选股风格使用持仓定义相应的定量风格标签，定期更新风格标签并形成策略曲线，用以进行基金经理风格判断、基金经理业绩跟踪、FOF组合构建。 ◼ 公募指数增强和量化对冲基金研究和投资策略：2021年负责公募量化基金定量及定性研究课题，定性评价侧重团队模型的完备性，定量评价基于业绩稳定性、风格暴露、业绩归因，标的选择更为依靠定量判断。开发公募对冲策略TAA择时模型，协助理财产品内对冲策略的投资管理，2022年对冲策略投资建议为10%对冲策略中枢产品贡献增厚20BP。 2023年担任另类策略研究组长，搭建私募基金研究框架，完成MOM组合投前工作并制定投资计划，获得当年优秀研究员 ◼ 私募基金研究和投资策略：2023年担任部门私募另类策略负责人，牵头理财子私募投资流程落地和管理人筛选，访谈私募管理人30余家，负责搭建部门私募量化对冲、量化CTA的基金研究框架，负责优选管理人成立MOM专户并进行投后管理，构建包含2家管理人的MOM专户。通过收益来源分解开发私募量化对冲、CTA策略的TAA择时模型，基于TAA模型可规避24年初私募量化策略回撤。 2024年担任公募股基研究组长，优化股基跟踪框架，完成A股市场风格策略研究 ◼ 权益基金的定性研究：对所覆盖的基金公司内基金经理进行尽调访谈并形成研究报告，对基金经理具体的投资方法，过往投资操作进行分析，并结合定量结果得出最终评价。访谈并形成报告的权益基金经理超过200余位，2024年开始担任部门股基研究组长，带领组员优化跟踪体系，所构建研究员推荐组合2025年相比于偏股基金指数超额1%。 ◼ A股权益市场风格策略研究：通过构建包含基本面、流动性、情绪三大类低频因子，对市场大小盘、价值成长风格做出定量判断，月频调仓模型，大小盘择时相比于大小盘等权指数年化超额约12%，价值成长相比于价值成长等权指数择时年化超额约8%。 ◼ 专业技能：CFA level II Candidate ◼ 计算机：Python熟练 ◼ 语言：CET-6; 良好的文献阅读能力\", \"employment_period\": \"（2020.07 - 至今, 4年11个月）\"}]'),('8ce79d6697e7R971d5e7f4819','2025-06-28 12:37:20.362351','2025-06-28 12:37:20.362374','[]','匹配中','[]','','[{\"salary\": \"21-22k×12薪\", \"location\": \"上海\", \"position\": \"量化研究\"}]','找**','方便联系时间：随时联系 | 男 28岁 上海 硕士 工作2年 20k · 15薪 | 投资助理/研究员(资管部→研究所) 国泰君安期货','','[]',' 职业背景：金融数学与计算机工程复合型学术背景，头部券商及跨国金融机构的双重实战经历，掌握智能投研系统开发、买方框架研究、多因子量化建模等专业能力，精通机器学习与高维数据处理。\n 行业优势：深度理解全球大类资产运用规律，具备宏观周期驱动下策略开发能力，曾基于期权组合动态对冲及跨资产相关性分析，对大多国内商品基本面有深入的了解，有海外大类资产的交易经验，对国内私募市场了解深入。\n 综合特质：强逻辑，强执行，中英双语流利，适配国际化团队协作，持续迭代策略认知，保持对前沿量化技术的敏感度。','[]','在职，看看新机会','[]','[{\"company\": \"国泰君安期货\", \"job_name\": \"投资助理/研究员(资管部→研究所)\", \"职责业绩\": \"根据公司战略重组规划，原资管/自营/研究所资产研究团队整体划转至研究所，统筹跨业务条线资产配置研究，聚焦经济周期驱动的全天候策略框架构建，支持自营、资管及机构客户战术配置需求。 【资管类业务】  项目管理：主导银行委外项目全生命周期管理，涵盖资方需求对接、资产推荐、系统开发定制、产品过会备案全流程协调，协同合规、运营、交易部门完成定制化需求落地。  策略评估：完成 200+私募策略尽调，覆盖策略类型包含量化股票、量化/主观 CTA、套利、期权、宏观对冲等，建立策略分类标签库，为 FOF 组合、场外衍生品及债券投资提供适配性分析。  资产池管理：构建并维护公司动态调整的核心资产池，结合经济周期轮动逻辑输出战术配置建议，支撑自营、资 管、高净值客户定制化资产配置方案设计。  产品设计：参与持仓返还、货基增强现金管理类产品设计以及雪球产品结构挑选，并协助测算以上产品的申赎流动性管理，设定产品开放期以及流动性预警。  系统开发：主导建设委外业务绩效归因系统底层开发，实现策略收益拆解、风格因子暴露、Brinson 归因等功能的底层代码开发及动态评估，协助前端实现系统上线，并牵头绩效归因系统的对外/对内路演，突出展示策略穿透式分析能力。  自动化建设：研发委外业务条线自动化脚本，利用 Python 实现监管报表生成、资管产品周报/月报、定期报告输出等核心功能自动化，并及时响应资方对运行中产品的临时需求。 【投资研究类业务】  全天候策略研究框架：融合风险平价模型等模型进行改良或框架调整，对基金组合提供资产配置权重参考，适配不同经济周期下的股、债、商品、衍生品配置需求。  大类资产配置研究：基于客户及研究需求，自上而下分析宏观经济数据与量价指标，挖掘 A 股、国债、商品、美股等大类资产配置机会，并延伸至小微盘股拥挤度观测、商品板块趋势延续性观测等细分领域，对各类资产进行风险预警以及交易机会提示。  宏观经济分析：收集海内外宏观经济数据，含国债期货数据，对中美经济日常观测及分析，寻找有赔率的交易。  单一资产分析：对单一资产搭建择时/预警指标，如使用优化后的 Husrt 及 ATR 结合对量化 CTA 策略的趋势延续性进行观测，复合市场成交占比等对 ETF 拥挤度进行观测，用 TSMOM 因子对中性策略进行收益拆解等，用于寻找单一资产的择时机会。  投研工具开发：构建量化策略评估体系，开发定量/定性评估指标，基于 Python 实现数据清洗（2024 年 8 月后全量数据）、持续更新数据及多因子绩效归因指标计算，构建市场观测、资产分析工具、资产组合模型，集成 DeepSeek API 实现非结构化数据处理，自动化提取私募尽调报告关键信息，生成策略标签并构建智能筛选系统。  回测框架开发：基于 vectorbt 开发量化策略逐笔回测分析框架，可以支持预测类、规则类策略的逐笔回测，并实现对因子的预处理、回测、绩效归因的完整链路  机构客户服务支持：为资方提供全天候策略逻辑下的多资产配置方案，设计商品、债券负相关性对冲组合，协助完成海内外中英文路演，输出大类资产配置观点及策略落地路径。\", \"employment_period\": \"（2022.07 - 至今, 2年11个月）\"}, {\"company\": \"G1ANT Ltd（英国伦敦）\", \"job_name\": \"软件开发\", \"职责业绩\": \"协助用户完成软件中保险保单、财报数据、销售管理等多维度数据库的构建预更新，基于自研领域专用编程语言，实现覆盖项目管理、时间表优化等多项统计测试的自动化功能。  系统迭代：完成多家公司 RPA 竞品软件技术对标分析，主导 G1ANT.robot 核心模块功能改进，并负责软件测试与 BUG 修复，确保系统稳定性提升。\", \"employment_period\": \"（2017.05 - 2018.08, 1年3个月）\"}, {\"company\": \"摩根大通（俄亥俄州哥伦布市）\", \"job_name\": \"数据分析师\", \"职责业绩\": \" 数据治理：清洗摩根大通于俄亥俄州的 500 台 ATM 机 13 年历史取款数据，修复字段缺失、逻辑冲突等异常数据 100+项，开发 ATM 现金存量动态调仓补足算法模型，成功被公司采纳并一直延用至今。  预测建模：建立 SARIMA 时间序列模型，进行短期取款额预测，精准识别赛事周期因子等非对称季节性规律。\", \"employment_period\": \"（2016.04 - 2016.09, 5个月）\"}, {\"company\": \"Shadowbox live\", \"job_name\": \"量化分析\", \"职责业绩\": \" 模型开发：构建集成学习框架，处理购票记录/用户画像/区域消费水平等多源异构数据，完成用户分层，通过提取关键预测因子，实现优惠券智能分发。  效能评估：使用回归模型以及过往用户数据对特定演出进行用户喜好预测，持续优化最初模型。  价值转化：通过部署预测系统及优惠券发放，目标场次上座率较区域基准提升 30%，剧院票房收入增长 28%。\", \"employment_period\": \"（2015.08 - 2015.12, 4个月）\"}]'),('8ce9956d9ae9C9717517e4b15','2025-06-28 12:37:20.833309','2025-06-28 12:37:20.833328','[\'大学英语四级\', \'基金从业资格证\', \'期货从业资格证\', \'银行间交易员证书\']','匹配中','[]','','[{\"salary\": \"20-30k×14薪\", \"location\": \"上海\", \"position\": \"证券交易员\"}]','李**','方便联系时间：随时联系 | 男 29岁 合肥 硕士 工作4年 保密 | 交易员 华安期货有限责任公司','','[]','本人有扎实的数学基础，掌握Python、MATLAB、R等建模软件，熟练掌握各种证券期货交易软件、银行间债券的交易软件，并且担任期货资产管理部交易员已三年，有丰富的交易经验、风控意识和合规意识，参与4亿的资管产品管理规模，债券业务方面有广泛的人脉与同业合作，目前持有期货从业资格证、基金从业资格证、银行间交易员资格证.','[\"数据分析\"]','在职，看看新机会','[]','[{\"company\": \"华安期货有限责任公司\", \"job_name\": \"交易员\", \"职责业绩\": \"工作职责： 1.盘前登录各产品的交易软件，检查网络是否通畅 2.盘中根据交易指令，快速精准的完成交易指令 3.及时反馈持仓、资金、行情的变化，并报告给投资经理 4.盘后统计当天的交易情况，并制作报表，进行分析总结 5.根据当天交易情况，对策略进行一定的优化\", \"employment_period\": \"（2021.09 - 至今, 3年9个月）\"}, {\"company\": \"安粮期货\", \"job_name\": \"量化研究员\", \"职责业绩\": \"1.在期货研究所轮岗期间对期货品种进行研究，开发期货期权量化策略，参与过大商所“保险+期货”项目申请与跟踪 2.在资产管理部轮岗期间参与fof基金的尽调，对fof子基金的选择有一定的了解 3.在结算部期间了解并参与交易所的盘后结算工作\", \"employment_period\": \"（2021.02 - 2021.08, 6个月）\"}, {\"company\": \"安徽省信息产业投资控股有限公司\", \"job_name\": \"投资助理\", \"职责业绩\": \"1 . 配合完成有关项目的宏观政策、行业及市场研究工作，收集相关信息；  2.筛选投资机会，负责项目立项；对项目的数据整理及投资价值与风险进行初步评估； 3.协助领导建立维护投资项目的寻找、评估、立项、尽职调查、估值、回报分析、谈判、交易及退出，并参与被投企业的投后管理工作.\", \"employment_period\": \"（2019.09 - 2019.11, 2个月）\"}]'),('8ee0936898eaD911c5a794717','2025-06-27 13:48:27.340927','2025-06-28 08:00:31.867092','[\'大学英语四级\', \'大学英语六级\']','匹配中','[]','','[{\"salary\": \"20-35k×12薪\", \"location\": \"上海\", \"position\": \"售前技术支持\"}]','王**',' | 男 33岁 上海 本科 工作9年 | 售前技术支持 苏州科达科技股份有限公司','','[]','1. 国内外大型项目规划、设计、落地支撑经验，伴随行业信息化、智慧城市、数字政府改革一路成长，具备各层级政府部门项目的实践经验。\n2. 项目管理、售前支持、解决方案孵化、规划设计等多岗位的从业与管理经验，拥有优秀的政策解读能力、商机挖掘能力、规划引导能力、解决方案培育能力和知识体系构建能力。\n3. 政策解读能力：通过工作积累，具备政策解读能力，能够准确把握行业发展趋势，判断发展阶段，明确发展方向，输出潜在商机。\n4. 知识体系构建能力：在行业信息的基础上总结行业知识，形成思路输出想法，并进行实践检验。\n5. 项目管理能力：通过大型项目锻炼，具备较强的现场组织梳理、团队管理、进度管理、资源调配的能力。\n6. 文档编写能力：掌握规划、设计方案、汇报材料、标准、论文等不同文档资料的编写方法，能够准确输出对应的文档材料。\n7. 沟通表达能力：日常工作积累丰富的对外交流沟通经验，能够应对口述交流、宣讲、汇报等不同沟通场景，准确表达。','[\"售前工程师\"]','离职，正在找工作','[]','[{\"company\": \"苏州科达科技股份有限公司\", \"job_name\": \"售前技术支持\", \"下属人数\": \"0\", \"职责业绩\": \"主要工作范围： 1、负责全国范围内大型重点项目的售前技术支持，包括雪亮工程、智慧警务、智慧城市、社会治理等政府信息化项目的全流程管理，涵盖需求、规划、设计、招投标及实施阶段。   2、开拓行业新市场，从0到1打磨行业解决方案，提升公司业务覆盖范围。   3、参与国家、地方及行业标准的编制工作，推动行业规范化发展。   4、组织内外部培训，针对新员工、分公司及合作伙伴、用户进行技术推广与知识传递。   5、作为技术负责人进行多个省、市、区县等不同层级的项目全生命周期管理。  项目分阶段工作内容： （1）需求阶段—项目前期与各业务部门用户进行需求沟通、实地调研，输出调研报告。 （2）规划阶段—根据调研报告结果，结合地方政策、工作报告、行动计划，形成本领域的规划方案。 （3）设计阶段—拉通公司各团队力量，牵头设计编写整体项目可行性研究报告、项目设计方案。 （4）招投标阶段-招标文件处理、投标文件编制、协助投标与述标。 （5）实施阶段—结合前期规划蓝图、设计方案，与项目交付团队技术交底，保障项目顺利交付。\", \"employment_period\": \"（2018.04 - 至今, 7年2个月）\"}, {\"company\": \"上海天道科技有限公司\", \"job_name\": \"售前技术支持\", \"下属人数\": \"0\", \"职责业绩\": \"1、负责公安、交通、金融等行业的售前技术支持，涵盖需求、规划、设计、招投标及实施阶段。   2、组织内外部培训，针对新员工及合作伙伴、用户进行技术推广与知识传递。   3、在项目需求阶段进行用户调研并输出调研报告，规划阶段制定规划方案，设计阶段牵头编写可行性研究报告及设计方案，招投标阶段进行招投标材料编制及投标述标工作，实施阶段保障项目顺利交付。 4、作为技术负责人进行多个行业项目的全生命周期管理。\", \"employment_period\": \"（2016.03 - 2018.04, 2年1个月）\"}, {\"company\": \"浙江宇视科技有限公司\", \"job_name\": \"售前技术支持\", \"下属人数\": \"0\", \"职责业绩\": \"1、负责公安、司法等行业的售前技术支持，涵盖需求、规划、设计、招投标及实施阶段。   2、组织内外部培训，针对新员工、合作伙伴、用户进行技术推广与知识传递。   3、在项目需求阶段进行用户调研并输出调研报告，规划阶段制定规划方案，设计阶段牵头编写可行性研究报告及设计方案，招投标阶段进行招投标材料编制及投标述标工作，实施阶段保障项目顺利交付。 4、获得全部四项工程师认证，同期入职的近百名同事中仅三人全部通过（宇视认证网络技术工程师、宇视认证智能交通系统工程师、宇视认证视频监控技术工程师、宇视认证商业监控系统工程师）。\", \"employment_period\": \"（2015.08 - 2016.03, 7个月）\"}]'),('memory','2025-06-27 23:54:55.016633','2025-06-27 23:56:56.888655','[]','匹配中','[]','981653507@qq.com','[]','mango','','[]','[]','','[]','在职，暂无跳槽打算','[]','[]');
/*!40000 ALTER TABLE `resumes_resume` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `resumes_resume_related_jobs`
--

DROP TABLE IF EXISTS `resumes_resume_related_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `resumes_resume_related_jobs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `resume_id` varchar(32) NOT NULL,
  `jobposition_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `resumes_resume_related_j_resume_id_jobposition_id_3af898ca_uniq` (`resume_id`,`jobposition_id`),
  KEY `resumes_resume_relat_jobposition_id_4837c7ad_fk_jobs_jobp` (`jobposition_id`),
  CONSTRAINT `resumes_resume_relat_jobposition_id_4837c7ad_fk_jobs_jobp` FOREIGN KEY (`jobposition_id`) REFERENCES `jobs_jobposition` (`id`),
  CONSTRAINT `resumes_resume_relat_resume_id_c3e026b3_fk_resumes_r` FOREIGN KEY (`resume_id`) REFERENCES `resumes_resume` (`resume_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resumes_resume_related_jobs`
--

LOCK TABLES `resumes_resume_related_jobs` WRITE;
/*!40000 ALTER TABLE `resumes_resume_related_jobs` DISABLE KEYS */;
INSERT INTO `resumes_resume_related_jobs` VALUES (1,'8ee0936898eaD911c5a794717',1),(2,'8ee0936898eaD911c5a794717',2);
/*!40000 ALTER TABLE `resumes_resume_related_jobs` ENABLE KEYS */;
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
  `error_message` longtext,
  PRIMARY KEY (`id`),
  KEY `resumes_uploadrecord_resume_id_7187b1c3_fk_resumes_r` (`resume_id`),
  KEY `resumes_uploadrecord_user_id_2187a373_fk_auth_user_id` (`user_id`),
  CONSTRAINT `resumes_uploadrecord_resume_id_7187b1c3_fk_resumes_r` FOREIGN KEY (`resume_id`) REFERENCES `resumes_resume` (`resume_id`),
  CONSTRAINT `resumes_uploadrecord_user_id_2187a373_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=78 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resumes_uploadrecord`
--

LOCK TABLES `resumes_uploadrecord` WRITE;
/*!40000 ALTER TABLE `resumes_uploadrecord` DISABLE KEYS */;
INSERT INTO `resumes_uploadrecord` VALUES (1,'一卡通每日消费.xlsx','2025-06-23 00:39:18.693868',1,'fail',NULL,NULL),(2,'一卡通每日消费.xlsx','2025-06-23 01:24:47.939448',1,'fail',NULL,NULL),(3,'DeepSeek_V3.pdf','2025-06-23 01:24:57.169002',1,'fail',NULL,NULL),(4,'SPS.pdf','2025-06-23 02:16:25.837796',1,'success',NULL,NULL),(5,'一卡通每日消费.xlsx','2025-06-23 06:17:26.122332',1,'success',NULL,NULL),(6,'SPS.pdf','2025-06-24 08:48:24.700547',2,'success',NULL,NULL),(7,'NO.8ee0936898eaD911c5a794717.html','2025-06-26 02:57:34.974307',2,'success',NULL,NULL),(8,'NO.8be599659cV971a5d7b4b10.html','2025-06-26 03:03:32.461533',2,'success',NULL,NULL),(9,'SPS.pdf','2025-06-26 03:07:19.437046',2,'success',NULL,NULL),(10,'DeepSeek_V3.pdf','2025-06-26 03:07:30.767093',2,'success',NULL,NULL),(11,'NO.88e8996197V941e5d704c18.html','2025-06-26 03:07:36.682662',2,'success',NULL,NULL),(12,'NO.8be599659cV971a5d7b4b10.html','2025-06-26 07:36:41.128692',2,'success',NULL,NULL),(13,'NO.8ee0936898eaD911c5a794717.html','2025-06-26 10:57:10.276532',2,'success',NULL,NULL),(14,'NO.8be599659cV971a5d7b4b10.html','2025-06-26 11:00:50.133622',2,'success',NULL,NULL),(15,'NO.8ee0936898eaD911c5a794717.html','2025-06-26 11:00:50.316893',2,'success',NULL,NULL),(16,'NO.88e8996197V941e5d704c18.html','2025-06-26 11:00:50.464384',2,'fail',NULL,NULL),(17,'SPS.pdf','2025-06-26 11:00:50.627930',2,'success',NULL,NULL),(18,'NO.8ee0936898eaD911c5a794717.html','2025-06-26 11:17:11.940212',2,'success',NULL,NULL),(19,'一卡通每日消费.xlsx','2025-06-26 11:17:30.863631',2,'fail',NULL,NULL),(20,'DeepSeek_V3.pdf','2025-06-26 11:18:09.345152',2,'success',NULL,NULL),(21,'NO.8be599659cV971a5d7b4b10.html','2025-06-26 11:18:09.745863',2,'success',NULL,NULL),(22,'NO.8ee0936898eaD911c5a794717.html','2025-06-26 11:18:09.916618',2,'success',NULL,NULL),(23,'NO.88e8996197V941e5d704c18.html','2025-06-26 11:18:10.093196',2,'fail',NULL,NULL),(24,'NO.8ee0936898eaD911c5a794717.html','2025-06-26 11:31:01.887276',2,'success',NULL,NULL),(25,'Vue.js Up and Running (Callum Macrae) (Z-Library).pdf','2025-06-27 00:45:42.204913',2,'success',NULL,NULL),(26,'DeepSeek_V3.pdf','2025-06-27 13:48:26.223276',4,'success',NULL,NULL),(27,'memory.pdf','2025-06-27 13:48:26.800840',4,'success',NULL,NULL),(28,'NO.8be599659cV971a5d7b4b10.html','2025-06-27 13:48:26.983818',4,'success','8be599659cV971a5d7b4b10',NULL),(29,'NO.8ee0936898eaD911c5a794717.html','2025-06-27 13:48:27.292988',4,'success','8ee0936898eaD911c5a794717',NULL),(30,'NO.88e8996197V941e5d704c18.html','2025-06-27 13:48:27.588373',4,'fail',NULL,'(1406, \"Data too long for column \'status\' at row 1\")'),(31,'SPS.pdf','2025-06-27 13:48:27.801035',4,'success',NULL,NULL),(32,'一卡通每日消费.xlsx','2025-06-27 13:48:27.990338',4,'fail',NULL,'cannot access local variable \'data\' where it is not associated with a value'),(33,'memory.pdf','2025-06-27 23:54:54.050133',2,'success','memory',NULL),(34,'NO.8be599659cV971a5d7b4b10.html','2025-06-28 02:27:51.019829',2,'success','8be599659cV971a5d7b4b10',NULL),(35,'NO.8ee0936898eaD911c5a794717.html','2025-06-28 02:31:05.018545',2,'success','8ee0936898eaD911c5a794717',NULL),(36,'NO.88e8996197V941e5d704c18.html','2025-06-28 02:33:27.240696',2,'fail',NULL,'(1406, \"Data too long for column \'status\' at row 1\")'),(37,'NO.8be599659cV971a5d7b4b10.html','2025-06-28 07:12:55.570459',2,'success','8be599659cV971a5d7b4b10',NULL),(38,'NO.8ee0936898eaD911c5a794717.html','2025-06-28 07:12:55.817788',2,'success','8ee0936898eaD911c5a794717',NULL),(39,'NO.88e8996197V941e5d704c18.html','2025-06-28 07:12:56.014132',2,'fail',NULL,'(1406, \"Data too long for column \'status\' at row 1\")'),(40,'NO.8be599659cV971a5d7b4b10.html','2025-06-28 07:43:03.257861',4,'success','8be599659cV971a5d7b4b10',NULL),(41,'NO.8ee0936898eaD911c5a794717.html','2025-06-28 07:43:03.442464',4,'success','8ee0936898eaD911c5a794717',NULL),(42,'NO.88e8996197V941e5d704c18.html','2025-06-28 07:43:03.586140',4,'fail',NULL,'(1406, \"Data too long for column \'status\' at row 1\")'),(43,'NO.8be599659cV971a5d7b4b10.html','2025-06-28 07:46:45.831002',4,'success','8be599659cV971a5d7b4b10',NULL),(44,'NO.8ee0936898eaD911c5a794717.html','2025-06-28 07:46:46.049309',4,'success','8ee0936898eaD911c5a794717',NULL),(45,'NO.88e8996197V941e5d704c18.html','2025-06-28 07:46:46.234017',4,'fail',NULL,'(1406, \"Data too long for column \'status\' at row 1\")'),(46,'DeepSeek_V3.pdf','2025-06-28 07:49:09.315002',4,'fail',NULL,NULL),(47,'DeepSeek_V3.pdf','2025-06-28 07:49:11.983545',4,'fail',NULL,NULL),(48,'NO.8ee0936898eaD911c5a794717.html','2025-06-28 07:49:49.281365',4,'success','8ee0936898eaD911c5a794717',NULL),(49,'NO.88e8996197V941e5d704c18.html','2025-06-28 07:49:49.420464',4,'fail',NULL,'(1406, \"Data too long for column \'status\' at row 1\")'),(50,'NO.8be599659cV971a5d7b4b10.html','2025-06-28 07:50:40.914957',4,'success','8be599659cV971a5d7b4b10',NULL),(51,'NO.8ee0936898eaD911c5a794717.html','2025-06-28 07:51:29.761963',4,'success','8ee0936898eaD911c5a794717',NULL),(52,'NO.8ee0936898eaD911c5a794717.html','2025-06-28 07:53:44.499514',4,'success','8ee0936898eaD911c5a794717',NULL),(53,'NO.8ee0936898eaD911c5a794717.html','2025-06-28 07:57:00.149868',4,'success','8ee0936898eaD911c5a794717',NULL),(54,'NO.8be599659cV971a5d7b4b10.html','2025-06-28 07:57:54.127425',4,'success','8be599659cV971a5d7b4b10',NULL),(55,'NO.8ee0936898eaD911c5a794717.html','2025-06-28 08:00:31.826635',4,'success','8ee0936898eaD911c5a794717',NULL),(56,'NO.8be09c679bQ971c5b7c4b14.html','2025-06-28 11:58:02.439667',2,'success','8be09c679bQ971c5b7c4b14',NULL),(57,'NO.8be59a649ee7C921a5b7c4c13.html','2025-06-28 11:58:02.718346',2,'success','8be59a649ee7C921a5b7c4c13',NULL),(58,'NO.8be79f6a9aO971d5e784b14.html','2025-06-28 11:58:03.041053',2,'success','8be79f6a9aO971d5e784b14',NULL),(59,'NO.8be89a6992K971e5c7c4f16.html','2025-06-28 12:37:18.500395',2,'success','8be89a6992K971e5c7c4f16',NULL),(60,'NO.8be193669eeeN921b5a7f4a10.html','2025-06-28 12:37:18.771597',2,'success','8be193669eeeN921b5a7f4a10',NULL),(61,'NO.8be194689eG971b5c7c4e14.html','2025-06-28 12:37:19.055897',2,'success','8be194689eG971b5c7c4e14',NULL),(62,'NO.8be7996395e7L921d5d7a4d16.html','2025-06-28 12:37:19.420261',2,'success','8be7996395e7L921d5d7a4d16',NULL),(63,'NO.8bed956597H9718507a4e16.html','2025-06-28 12:37:19.729005',2,'success','8bed956597H9718507a4e16',NULL),(64,'NO.8bee9d6693Y97165e784a12.html','2025-06-28 12:37:20.029270',2,'success','8bee9d6693Y97165e784a12',NULL),(65,'NO.8ce79d6697e7R971d5e7f4819.html','2025-06-28 12:37:20.319905',2,'success','8ce79d6697e7R971d5e7f4819',NULL),(66,'NO.8ce9956d9ae9C9717517e4b15.html','2025-06-28 12:37:20.794790',2,'success','8ce9956d9ae9C9717517e4b15',NULL),(67,'NO.87e2966590ebE931f5f714a19.html','2025-06-28 12:51:42.545399',2,'success','87e2966590ebE931f5f714a19',NULL),(68,'NO.87ed9a6499K91185b714712.html','2025-06-28 12:51:42.829713',2,'success','87ed9a6499K91185b714712',NULL),(69,'NO.88e09b649debH9a1c507c4611.html','2025-06-28 12:51:43.115723',2,'success','88e09b649debH9a1c507c4611',NULL),(70,'NO.88e1926e96X941b587f4912.html','2025-06-28 12:51:43.441736',2,'success','88e1926e96X941b587f4912',NULL),(71,'NO.88e2986f94M941f597e4914.html','2025-06-28 12:51:43.703666',2,'success','88e2986f94M941f597e4914',NULL),(72,'NO.88e5976499W941a58794912.html','2025-06-28 12:51:44.056568',2,'success','88e5976499W941a58794912',NULL),(73,'NO.88e7926897ebI9a1d59794f18.html','2025-06-28 12:51:44.289513',2,'success','88e7926897ebI9a1d59794f18',NULL),(74,'NO.88ee966992H94165f7b4d12.html','2025-06-28 12:51:44.542600',2,'success','88ee966992H94165f7b4d12',NULL),(75,'NO.89e1926497H9a1b58794e16.html','2025-06-28 12:51:44.769025',2,'success','89e1926497H9a1b58794e16',NULL),(76,'NO.89e7926394F9a1d59784817.html','2025-06-28 12:51:45.057077',2,'success','89e7926394F9a1d59784817',NULL),(77,'NO.89ee956c98B9a16507a4718.html','2025-06-28 12:51:45.306753',2,'success','89ee956c98B9a16507a4718',NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_userprofile`
--

LOCK TABLES `users_userprofile` WRITE;
/*!40000 ALTER TABLE `users_userprofile` DISABLE KEYS */;
INSERT INTO `users_userprofile` VALUES (1,'猎头',1),(2,'猎头',2),(3,'猎头',3),(4,'猎头',4),(5,'猎头',5),(6,'猎头',6);
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

-- Dump completed on 2025-06-28 14:31:14
