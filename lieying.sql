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
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session'),(25,'Can add 用户资料',7,'add_userprofile'),(26,'Can change 用户资料',7,'change_userprofile'),(27,'Can delete 用户资料',7,'delete_userprofile'),(28,'Can view 用户资料',7,'view_userprofile'),(29,'Can add resume',8,'add_resume'),(30,'Can change resume',8,'change_resume'),(31,'Can delete resume',8,'delete_resume'),(32,'Can view resume',8,'view_resume'),(33,'Can add 简历版本',9,'add_resumeversion'),(34,'Can change 简历版本',9,'change_resumeversion'),(35,'Can delete 简历版本',9,'delete_resumeversion'),(36,'Can view 简历版本',9,'view_resumeversion'),(37,'Can add 岗位负责人',10,'add_jobowner'),(38,'Can change 岗位负责人',10,'change_jobowner'),(39,'Can delete 岗位负责人',10,'delete_jobowner'),(40,'Can view 岗位负责人',10,'view_jobowner'),(41,'Can add 岗位',11,'add_jobposition'),(42,'Can change 岗位',11,'change_jobposition'),(43,'Can delete 岗位',11,'delete_jobposition'),(44,'Can view 岗位',11,'view_jobposition'),(45,'Can add upload record',12,'add_uploadrecord'),(46,'Can change upload record',12,'change_uploadrecord'),(47,'Can delete upload record',12,'delete_uploadrecord'),(48,'Can view upload record',12,'view_uploadrecord'),(49,'Can add 简历岗位匹配',13,'add_matching'),(50,'Can change 简历岗位匹配',13,'change_matching'),(51,'Can delete 简历岗位匹配',13,'delete_matching'),(52,'Can view 简历岗位匹配',13,'view_matching'),(53,'Can add django job',14,'add_djangojob'),(54,'Can change django job',14,'change_djangojob'),(55,'Can delete django job',14,'delete_djangojob'),(56,'Can view django job',14,'view_djangojob'),(57,'Can add django job execution',15,'add_djangojobexecution'),(58,'Can change django job execution',15,'change_djangojobexecution'),(59,'Can delete django job execution',15,'delete_djangojobexecution'),(60,'Can view django job execution',15,'view_djangojobexecution');
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'pbkdf2_sha256$1000000$hPdLtUTmhpHYq5y7SkUMJI$SvXI9vFHinzT6sdFNwbwHSS7BHEWq5ItZpYwfQKyslU=','2025-06-21 09:24:07.717254',1,'mango','','','981653507@qq.com',1,1,'2025-06-21 09:23:52.911285'),(2,'pbkdf2_sha256$600000$lqLsy3YFpYPqDWT5FgeB82$yrs7oIuzQi0Hzj5QhvjKO0RqFuNzDlw8LrDKS9gHa60=','2025-06-28 08:13:36.726096',0,'zhengxiang','','','',0,1,'2025-06-24 08:21:59.685835'),(3,'pbkdf2_sha256$600000$p3eUQldzPhOmJqcizglCUQ$zNbRkVRKDRuUgplftmpTmrOX+fDWUvH7NDYQOn9kFbQ=','2025-06-24 09:16:45.531805',0,'suwenyi','','','',0,1,'2025-06-24 09:16:45.291305'),(4,'pbkdf2_sha256$600000$RKR0W8TxNhMQh19yJdg4vu$6WsYaNVHSN7wMwccMoUWTr4MO0x7A1ME1ZwTlxwIDGk=','2025-06-28 07:23:42.033593',1,'lieying','','','',1,1,'2025-06-27 13:28:26.905855');
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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(3,'auth','group'),(2,'auth','permission'),(4,'auth','user'),(5,'contenttypes','contenttype'),(14,'django_apscheduler','djangojob'),(15,'django_apscheduler','djangojobexecution'),(10,'jobs','jobowner'),(11,'jobs','jobposition'),(13,'match','matching'),(8,'resumes','resume'),(9,'resumes','resumeversion'),(12,'resumes','uploadrecord'),(6,'sessions','session'),(7,'users','userprofile');
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
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2025-06-21 04:10:09.934565'),(2,'auth','0001_initial','2025-06-21 04:10:10.247759'),(3,'admin','0001_initial','2025-06-21 04:10:10.339909'),(4,'admin','0002_logentry_remove_auto_add','2025-06-21 04:10:10.345223'),(5,'admin','0003_logentry_add_action_flag_choices','2025-06-21 04:10:10.349709'),(6,'contenttypes','0002_remove_content_type_name','2025-06-21 04:10:10.419624'),(7,'auth','0002_alter_permission_name_max_length','2025-06-21 04:10:10.468481'),(8,'auth','0003_alter_user_email_max_length','2025-06-21 04:10:10.485170'),(9,'auth','0004_alter_user_username_opts','2025-06-21 04:10:10.489132'),(10,'auth','0005_alter_user_last_login_null','2025-06-21 04:10:10.514605'),(11,'auth','0006_require_contenttypes_0002','2025-06-21 04:10:10.516005'),(12,'auth','0007_alter_validators_add_error_messages','2025-06-21 04:10:10.520791'),(13,'auth','0008_alter_user_username_max_length','2025-06-21 04:10:10.570800'),(14,'auth','0009_alter_user_last_name_max_length','2025-06-21 04:10:10.631386'),(15,'auth','0010_alter_group_name_max_length','2025-06-21 04:10:10.648593'),(16,'auth','0011_update_proxy_permissions','2025-06-21 04:10:10.653261'),(17,'auth','0012_alter_user_first_name_max_length','2025-06-21 04:10:10.680702'),(18,'sessions','0001_initial','2025-06-21 04:10:10.697653'),(19,'jobs','0001_initial','2025-06-21 08:57:35.121741'),(20,'resumes','0001_initial','2025-06-21 08:57:35.237709'),(21,'users','0001_initial','2025-06-21 08:57:35.284485'),(22,'resumes','0002_remove_resume_current_version_alter_resume_options_and_more','2025-06-22 08:30:04.441073'),(23,'resumes','0003_uploadrecord','2025-06-23 00:38:06.473264'),(24,'resumes','0004_uploadrecord_parse_status_uploadrecord_resume_and_more','2025-06-23 01:32:49.184761'),(25,'resumes','0005_alter_uploadrecord_options_and_more','2025-06-24 08:12:01.399766'),(26,'resumes','0006_uploadrecord_error_message','2025-06-26 12:48:10.555070'),(27,'match','0001_initial','2025-06-26 13:08:50.201727'),(28,'resumes','0005_alter_uploadrecord_options','2025-06-27 00:34:04.423914'),(29,'resumes','0007_merge_20250627_0833','2025-06-27 00:34:04.428532'),(30,'django_apscheduler','0001_initial','2025-06-27 12:16:01.437108'),(31,'django_apscheduler','0002_auto_20180412_0758','2025-06-27 12:16:01.465957'),(32,'django_apscheduler','0003_auto_20200716_1632','2025-06-27 12:16:01.484519'),(33,'django_apscheduler','0004_auto_20200717_1043','2025-06-27 12:16:01.612336'),(34,'django_apscheduler','0005_migrate_name_to_id','2025-06-27 12:16:01.629614'),(35,'django_apscheduler','0006_remove_djangojob_name','2025-06-27 12:16:01.653260'),(36,'django_apscheduler','0007_auto_20200717_1404','2025-06-27 12:16:01.684592'),(37,'django_apscheduler','0008_remove_djangojobexecution_started','2025-06-27 12:16:01.724856'),(38,'django_apscheduler','0009_djangojobexecution_unique_job_executions','2025-06-27 12:16:01.743533'),(39,'jobs','0002_jobposition_updated_at','2025-06-28 01:28:13.000275'),(40,'resumes','0008_resume_related_jobs','2025-06-28 07:46:27.832913');
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
INSERT INTO `django_session` VALUES ('2ee5a7sjgbcmt6ylp4prxurd7kkiw1aa','.eJxVjMsOwiAQRf-FtSFkeAx16d5vIMwAUjWQlHZl_Hdt0oVu7znnvkSI21rDNvIS5iTOQovT70aRH7ntIN1ju3XJva3LTHJX5EGHvPaUn5fD_TuocdRvXVJEYshaGUUOXOJSOGsAU4CS9d4gk3VoGFAhIRFZnrxn5TLZCcX7AwXuOGs:1uTzll:CpHkN73gcPywy1caClowctPWCwUR0gdWPCqUHrHcS-g','2025-07-08 09:16:45.534645'),('8pvji9dgz4rh6zd9wlnu4pg2uth51xkt','.eJxVjEsOwjAMBe-SNYrqqHESluw5Q2XHLimgROpnhbg7VOoCtm9m3ssMtK1l2Badh0nM2YA5_W5M-aF1B3Knems2t7rOE9tdsQdd7LWJPi-H-3dQaCnfOnhMvZcQ0oiIAtxLyrH3MHrKBNpBJHHQcYfOKQXWmBDH7Bwn50HN-wPNIzd6:1uSuSF:ESpDVhJDLAbTb6tWGPa4rOL39qZCHretJvQrtmxWj6A','2025-07-05 09:24:07.587905'),('nr7kwhoa41ch085w8rqitc2tderh8otz','.eJxVjEsOwjAMBe-SNYrqqHESluw5Q2XHLimgROpnhbg7VOoCtm9m3ssMtK1l2Badh0nM2YA5_W5M-aF1B3Knems2t7rOE9tdsQdd7LWJPi-H-3dQaCnfOnhMvZcQ0oiIAtxLyrH3MHrKBNpBJHHQcYfOKQXWmBDH7Bwn50HN-wPNIzd6:1uSuSF:ESpDVhJDLAbTb6tWGPa4rOL39qZCHretJvQrtmxWj6A','2025-07-05 09:24:07.719922'),('ucon56hayyyc31ex3d45qrm110bax4uw','.eJxVjMsOwiAQRf-FtSFQylC6dO83kBkeFjVgSptojP-uTbrp9p5z7oe5FlvLtbj4eub5zUbZCQtCnJjDdZnc2uLscmAj69hhI_T3WDYQbliulftaljkT3xS-08YvNcTHeXcPBxO26V8PViH1pI3VCrwBI7TWIBApQUJAmUh7IDuQVFJCL70wcYi9TwGj6BT7_gD6t0A8:1uVQgq:atmXAFjJbU5QxB0K-Oi6f34-Xg_Y3boc2IztDF2Lg2k','2025-07-12 08:13:36.728416'),('zqo1jns6ohovlklis5o5fwp7pxift0ki','.eJxVjMsOwiAQRf-FtSFQylC6dO83kBkeFjVgSptojP-uTbrp9p5z7oe5FlvLtbj4eub5zUbZCQtCnJjDdZnc2uLscmAj69hhI_T3WDYQbliulftaljkT3xS-08YvNcTHeXcPBxO26V8PViH1pI3VCrwBI7TWIBApQUJAmUh7IDuQVFJCL70wcYi9TwGj6BT7_gD6t0A8:1uUx6l:IVs1OQqUIuiqhT7K9oWTG4U1W1y0HW_94joBE396yPQ','2025-07-11 00:38:23.740476');
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs_jobposition`
--

LOCK TABLES `jobs_jobposition` WRITE;
/*!40000 ALTER TABLE `jobs_jobposition` DISABLE KEYS */;
INSERT INTO `jobs_jobposition` VALUES (1,'算法工程师','阿里','不限','','','不限','','','','2025-06-27 23:56:15.874277','2025-06-28 02:54:02.614632'),(2,'算法工程师','字节跳动','上海','','不限','985','','1、支持快速增长的抖音生活服务业务的算法支持工作；职责范围包括提高决策信息覆盖，提升转化效率，改善用户体验，探索更高效的商业模式，提升内容理解程度等；\r\n2、利用海量数据搭建业内领先的机器学习算法和架构建模用户反馈，提升用户体验；\r\n3、应用先进的机器学习技术，解决各种内容理解相关性，在线/离线，大数据量/小数据量，长期/短期信号等不同场景中遇到的各种挑战；\r\n4、对用户、作者、商家的行为做深入的理解和分析，制定针对的算法策略促进生态良性发展。','1、本科及以上学历在读；\r\n2、具备优秀的编码能力，扎实的数据结构和算法功底；\r\n3、优秀的分析问题和解决问题的能力，对解决具有挑战性问题充满激情；\r\n4、对技术有热情，有良好的沟通表达能力和团队精神；\r\n5、熟悉机器学习、计算机视觉、自然语言处理、数据挖掘中一项或多项。','2025-06-28 07:40:13.982821','2025-06-28 07:40:13.982862');
/*!40000 ALTER TABLE `jobs_jobposition` ENABLE KEYS */;
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
  PRIMARY KEY (`id`),
  UNIQUE KEY `match_matching_resume_id_job_id_5167a41f_uniq` (`resume_id`,`job_id`),
  KEY `match_matching_job_id_dfd0344f_fk_jobs_jobposition_id` (`job_id`),
  CONSTRAINT `match_matching_job_id_dfd0344f_fk_jobs_jobposition_id` FOREIGN KEY (`job_id`) REFERENCES `jobs_jobposition` (`id`),
  CONSTRAINT `match_matching_resume_id_977226f7_fk_resumes_resume_resume_id` FOREIGN KEY (`resume_id`) REFERENCES `resumes_resume` (`resume_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `match_matching`
--

LOCK TABLES `match_matching` WRITE;
/*!40000 ALTER TABLE `match_matching` DISABLE KEYS */;
INSERT INTO `match_matching` VALUES (1,'进入初筛',7,'自动打分器','2025-06-28 00:00:27.323134','2025-06-28 07:17:57.391032',1,'8be599659cV971a5d7b4b10'),(2,'进入初筛',6,'自动打分器','2025-06-28 00:00:54.665109','2025-06-28 07:12:57.332008',1,'8ee0936898eaD911c5a794717'),(3,'未过分数筛选',0,'自动打分器','2025-06-28 00:01:22.001643','2025-06-28 03:01:05.243422',1,'memory'),(4,'进入初筛',6,'自动打分器','2025-06-28 07:43:15.793861','2025-06-28 07:43:15.793920',2,'8be599659cV971a5d7b4b10'),(6,'未过分数筛选',2,'自动打分器','2025-06-28 07:44:11.979180','2025-06-28 07:44:11.979242',2,'8ee0936898eaD911c5a794717'),(8,'未过分数筛选',3,'自动打分器','2025-06-28 07:45:08.123043','2025-06-28 07:45:08.123103',2,'memory');
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
INSERT INTO `resumes_resume` VALUES ('8be599659cV971a5d7b4b10','2025-06-27 13:48:27.041364','2025-06-28 08:19:29.728628','[]','匹配中','[{\"time\": \"2014.09-2018.06\", \"school\": \"北京理工大学\", \"details\": \"电子信息\"}]','','[{\"salary\": \"55-60k×15薪\", \"location\": \"上海\", \"position\": \"产品经理\"}]','方**','方便联系时间：随时联系 | 男 29岁 上海 硕士 工作6年 保密 | 数据科学经理，搜索与推荐 Coupang','','[{\"project_name\": \"搜索推荐流量策略优化\", \"employment_period\": \"（2023.05 - 至今）\"}, {\"project_name\": \"搜索数据基建和产品分析\", \"employment_period\": \"（2023.05 - 至今）\"}]','1. 互联网国际化出海行业及外企咨询背景，具备跨国团队协作与团队管理能力。\r\n\r\n2. 7年数据科学与管理咨询工作经验，在搜索推荐、用户增长、金融科技成功推动多个项目并取得显著成果。\r\n\r\n3. 在ToB企业服务领域有丰富的AI解决方案交付经验，领导从需求诊断、模型开发到客户关系维护的全周期管理。','[\"sql\", \"咨询\", \"人工智能\", \"机器学习\", \"数据分析\"]','在职，急寻新工作','[]','[{\"company\": \"Coupang\", \"job_name\": \"数据科学经理，搜索与推荐\", \"employment_period\": \"（2024.03 - 至今, 1年3个月）\"}, {\"company\": \"Coupang\", \"job_name\": \"数据科学经理\", \"employment_period\": \"（2024.03 - 至今, 1年3个月）\"}, {\"company\": \"字节跳动\", \"job_name\": \"数据科学家\", \"employment_period\": \"（2022.04 - 至今, 3年2个月）\"}, {\"company\": \"字节跳动\", \"job_name\": \"数据科学家，TikTok电商数据科学\", \"employment_period\": \"（2022.04 - 2024.02, 1年10个月）\"}, {\"company\": \"Opera Solutions\", \"job_name\": \"分析主管，数据科学\", \"employment_period\": \"（2018.08 - 2022.04, 3年8个月）\"}]'),('8ee0936898eaD911c5a794717','2025-06-27 13:48:27.340927','2025-06-28 08:00:31.867092','[\'大学英语四级\', \'大学英语六级\']','匹配中','[]','','[{\"salary\": \"20-35k×12薪\", \"location\": \"上海\", \"position\": \"售前技术支持\"}]','王**',' | 男 33岁 上海 本科 工作9年 | 售前技术支持 苏州科达科技股份有限公司','','[]','1. 国内外大型项目规划、设计、落地支撑经验，伴随行业信息化、智慧城市、数字政府改革一路成长，具备各层级政府部门项目的实践经验。\n2. 项目管理、售前支持、解决方案孵化、规划设计等多岗位的从业与管理经验，拥有优秀的政策解读能力、商机挖掘能力、规划引导能力、解决方案培育能力和知识体系构建能力。\n3. 政策解读能力：通过工作积累，具备政策解读能力，能够准确把握行业发展趋势，判断发展阶段，明确发展方向，输出潜在商机。\n4. 知识体系构建能力：在行业信息的基础上总结行业知识，形成思路输出想法，并进行实践检验。\n5. 项目管理能力：通过大型项目锻炼，具备较强的现场组织梳理、团队管理、进度管理、资源调配的能力。\n6. 文档编写能力：掌握规划、设计方案、汇报材料、标准、论文等不同文档资料的编写方法，能够准确输出对应的文档材料。\n7. 沟通表达能力：日常工作积累丰富的对外交流沟通经验，能够应对口述交流、宣讲、汇报等不同沟通场景，准确表达。','[\"售前工程师\"]','离职，正在找工作','[]','[{\"company\": \"苏州科达科技股份有限公司\", \"job_name\": \"售前技术支持\", \"下属人数\": \"0\", \"职责业绩\": \"主要工作范围： 1、负责全国范围内大型重点项目的售前技术支持，包括雪亮工程、智慧警务、智慧城市、社会治理等政府信息化项目的全流程管理，涵盖需求、规划、设计、招投标及实施阶段。   2、开拓行业新市场，从0到1打磨行业解决方案，提升公司业务覆盖范围。   3、参与国家、地方及行业标准的编制工作，推动行业规范化发展。   4、组织内外部培训，针对新员工、分公司及合作伙伴、用户进行技术推广与知识传递。   5、作为技术负责人进行多个省、市、区县等不同层级的项目全生命周期管理。  项目分阶段工作内容： （1）需求阶段—项目前期与各业务部门用户进行需求沟通、实地调研，输出调研报告。 （2）规划阶段—根据调研报告结果，结合地方政策、工作报告、行动计划，形成本领域的规划方案。 （3）设计阶段—拉通公司各团队力量，牵头设计编写整体项目可行性研究报告、项目设计方案。 （4）招投标阶段-招标文件处理、投标文件编制、协助投标与述标。 （5）实施阶段—结合前期规划蓝图、设计方案，与项目交付团队技术交底，保障项目顺利交付。\", \"employment_period\": \"（2018.04 - 至今, 7年2个月）\"}, {\"company\": \"上海天道科技有限公司\", \"job_name\": \"售前技术支持\", \"下属人数\": \"0\", \"职责业绩\": \"1、负责公安、交通、金融等行业的售前技术支持，涵盖需求、规划、设计、招投标及实施阶段。   2、组织内外部培训，针对新员工及合作伙伴、用户进行技术推广与知识传递。   3、在项目需求阶段进行用户调研并输出调研报告，规划阶段制定规划方案，设计阶段牵头编写可行性研究报告及设计方案，招投标阶段进行招投标材料编制及投标述标工作，实施阶段保障项目顺利交付。 4、作为技术负责人进行多个行业项目的全生命周期管理。\", \"employment_period\": \"（2016.03 - 2018.04, 2年1个月）\"}, {\"company\": \"浙江宇视科技有限公司\", \"job_name\": \"售前技术支持\", \"下属人数\": \"0\", \"职责业绩\": \"1、负责公安、司法等行业的售前技术支持，涵盖需求、规划、设计、招投标及实施阶段。   2、组织内外部培训，针对新员工、合作伙伴、用户进行技术推广与知识传递。   3、在项目需求阶段进行用户调研并输出调研报告，规划阶段制定规划方案，设计阶段牵头编写可行性研究报告及设计方案，招投标阶段进行招投标材料编制及投标述标工作，实施阶段保障项目顺利交付。 4、获得全部四项工程师认证，同期入职的近百名同事中仅三人全部通过（宇视认证网络技术工程师、宇视认证智能交通系统工程师、宇视认证视频监控技术工程师、宇视认证商业监控系统工程师）。\", \"employment_period\": \"（2015.08 - 2016.03, 7个月）\"}]'),('memory','2025-06-27 23:54:55.016633','2025-06-27 23:56:56.888655','[]','匹配中','[]','981653507@qq.com','[]','mango','','[]','[]','','[]','在职，暂无跳槽打算','[]','[]');
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
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resumes_uploadrecord`
--

LOCK TABLES `resumes_uploadrecord` WRITE;
/*!40000 ALTER TABLE `resumes_uploadrecord` DISABLE KEYS */;
INSERT INTO `resumes_uploadrecord` VALUES (1,'一卡通每日消费.xlsx','2025-06-23 00:39:18.693868',1,'fail',NULL,NULL),(2,'一卡通每日消费.xlsx','2025-06-23 01:24:47.939448',1,'fail',NULL,NULL),(3,'DeepSeek_V3.pdf','2025-06-23 01:24:57.169002',1,'fail',NULL,NULL),(4,'SPS.pdf','2025-06-23 02:16:25.837796',1,'success',NULL,NULL),(5,'一卡通每日消费.xlsx','2025-06-23 06:17:26.122332',1,'success',NULL,NULL),(6,'SPS.pdf','2025-06-24 08:48:24.700547',2,'success',NULL,NULL),(7,'NO.8ee0936898eaD911c5a794717.html','2025-06-26 02:57:34.974307',2,'success',NULL,NULL),(8,'NO.8be599659cV971a5d7b4b10.html','2025-06-26 03:03:32.461533',2,'success',NULL,NULL),(9,'SPS.pdf','2025-06-26 03:07:19.437046',2,'success',NULL,NULL),(10,'DeepSeek_V3.pdf','2025-06-26 03:07:30.767093',2,'success',NULL,NULL),(11,'NO.88e8996197V941e5d704c18.html','2025-06-26 03:07:36.682662',2,'success',NULL,NULL),(12,'NO.8be599659cV971a5d7b4b10.html','2025-06-26 07:36:41.128692',2,'success',NULL,NULL),(13,'NO.8ee0936898eaD911c5a794717.html','2025-06-26 10:57:10.276532',2,'success',NULL,NULL),(14,'NO.8be599659cV971a5d7b4b10.html','2025-06-26 11:00:50.133622',2,'success',NULL,NULL),(15,'NO.8ee0936898eaD911c5a794717.html','2025-06-26 11:00:50.316893',2,'success',NULL,NULL),(16,'NO.88e8996197V941e5d704c18.html','2025-06-26 11:00:50.464384',2,'fail',NULL,NULL),(17,'SPS.pdf','2025-06-26 11:00:50.627930',2,'success',NULL,NULL),(18,'NO.8ee0936898eaD911c5a794717.html','2025-06-26 11:17:11.940212',2,'success',NULL,NULL),(19,'一卡通每日消费.xlsx','2025-06-26 11:17:30.863631',2,'fail',NULL,NULL),(20,'DeepSeek_V3.pdf','2025-06-26 11:18:09.345152',2,'success',NULL,NULL),(21,'NO.8be599659cV971a5d7b4b10.html','2025-06-26 11:18:09.745863',2,'success',NULL,NULL),(22,'NO.8ee0936898eaD911c5a794717.html','2025-06-26 11:18:09.916618',2,'success',NULL,NULL),(23,'NO.88e8996197V941e5d704c18.html','2025-06-26 11:18:10.093196',2,'fail',NULL,NULL),(24,'NO.8ee0936898eaD911c5a794717.html','2025-06-26 11:31:01.887276',2,'success',NULL,NULL),(25,'Vue.js Up and Running (Callum Macrae) (Z-Library).pdf','2025-06-27 00:45:42.204913',2,'success',NULL,NULL),(26,'DeepSeek_V3.pdf','2025-06-27 13:48:26.223276',4,'success',NULL,NULL),(27,'memory.pdf','2025-06-27 13:48:26.800840',4,'success',NULL,NULL),(28,'NO.8be599659cV971a5d7b4b10.html','2025-06-27 13:48:26.983818',4,'success','8be599659cV971a5d7b4b10',NULL),(29,'NO.8ee0936898eaD911c5a794717.html','2025-06-27 13:48:27.292988',4,'success','8ee0936898eaD911c5a794717',NULL),(30,'NO.88e8996197V941e5d704c18.html','2025-06-27 13:48:27.588373',4,'fail',NULL,'(1406, \"Data too long for column \'status\' at row 1\")'),(31,'SPS.pdf','2025-06-27 13:48:27.801035',4,'success',NULL,NULL),(32,'一卡通每日消费.xlsx','2025-06-27 13:48:27.990338',4,'fail',NULL,'cannot access local variable \'data\' where it is not associated with a value'),(33,'memory.pdf','2025-06-27 23:54:54.050133',2,'success','memory',NULL),(34,'NO.8be599659cV971a5d7b4b10.html','2025-06-28 02:27:51.019829',2,'success','8be599659cV971a5d7b4b10',NULL),(35,'NO.8ee0936898eaD911c5a794717.html','2025-06-28 02:31:05.018545',2,'success','8ee0936898eaD911c5a794717',NULL),(36,'NO.88e8996197V941e5d704c18.html','2025-06-28 02:33:27.240696',2,'fail',NULL,'(1406, \"Data too long for column \'status\' at row 1\")'),(37,'NO.8be599659cV971a5d7b4b10.html','2025-06-28 07:12:55.570459',2,'success','8be599659cV971a5d7b4b10',NULL),(38,'NO.8ee0936898eaD911c5a794717.html','2025-06-28 07:12:55.817788',2,'success','8ee0936898eaD911c5a794717',NULL),(39,'NO.88e8996197V941e5d704c18.html','2025-06-28 07:12:56.014132',2,'fail',NULL,'(1406, \"Data too long for column \'status\' at row 1\")'),(40,'NO.8be599659cV971a5d7b4b10.html','2025-06-28 07:43:03.257861',4,'success','8be599659cV971a5d7b4b10',NULL),(41,'NO.8ee0936898eaD911c5a794717.html','2025-06-28 07:43:03.442464',4,'success','8ee0936898eaD911c5a794717',NULL),(42,'NO.88e8996197V941e5d704c18.html','2025-06-28 07:43:03.586140',4,'fail',NULL,'(1406, \"Data too long for column \'status\' at row 1\")'),(43,'NO.8be599659cV971a5d7b4b10.html','2025-06-28 07:46:45.831002',4,'success','8be599659cV971a5d7b4b10',NULL),(44,'NO.8ee0936898eaD911c5a794717.html','2025-06-28 07:46:46.049309',4,'success','8ee0936898eaD911c5a794717',NULL),(45,'NO.88e8996197V941e5d704c18.html','2025-06-28 07:46:46.234017',4,'fail',NULL,'(1406, \"Data too long for column \'status\' at row 1\")'),(46,'DeepSeek_V3.pdf','2025-06-28 07:49:09.315002',4,'fail',NULL,NULL),(47,'DeepSeek_V3.pdf','2025-06-28 07:49:11.983545',4,'fail',NULL,NULL),(48,'NO.8ee0936898eaD911c5a794717.html','2025-06-28 07:49:49.281365',4,'success','8ee0936898eaD911c5a794717',NULL),(49,'NO.88e8996197V941e5d704c18.html','2025-06-28 07:49:49.420464',4,'fail',NULL,'(1406, \"Data too long for column \'status\' at row 1\")'),(50,'NO.8be599659cV971a5d7b4b10.html','2025-06-28 07:50:40.914957',4,'success','8be599659cV971a5d7b4b10',NULL),(51,'NO.8ee0936898eaD911c5a794717.html','2025-06-28 07:51:29.761963',4,'success','8ee0936898eaD911c5a794717',NULL),(52,'NO.8ee0936898eaD911c5a794717.html','2025-06-28 07:53:44.499514',4,'success','8ee0936898eaD911c5a794717',NULL),(53,'NO.8ee0936898eaD911c5a794717.html','2025-06-28 07:57:00.149868',4,'success','8ee0936898eaD911c5a794717',NULL),(54,'NO.8be599659cV971a5d7b4b10.html','2025-06-28 07:57:54.127425',4,'success','8be599659cV971a5d7b4b10',NULL),(55,'NO.8ee0936898eaD911c5a794717.html','2025-06-28 08:00:31.826635',4,'success','8ee0936898eaD911c5a794717',NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_userprofile`
--

LOCK TABLES `users_userprofile` WRITE;
/*!40000 ALTER TABLE `users_userprofile` DISABLE KEYS */;
INSERT INTO `users_userprofile` VALUES (1,'猎头',1),(2,'猎头',2),(3,'猎头',3),(4,'猎头',4);
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

-- Dump completed on 2025-06-28  8:44:48
