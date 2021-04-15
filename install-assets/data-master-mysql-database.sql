
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


CREATE TABLE `__compasspoint_saas` (
  `comment` char(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `__compasspoint_saas` WRITE;
/*!40000 ALTER TABLE `__compasspoint_saas` DISABLE KEYS */;

INSERT INTO `__compasspoint_saas` (`comment`)
VALUES
	('This table is simply here to identify the \"real\" name of this database for convenience.  It is not designed to be used and may be deleted.');

/*!40000 ALTER TABLE `__compasspoint_saas` ENABLE KEYS */;
UNLOCK TABLES;


CREATE TABLE `sys_account` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` char(100) DEFAULT NULL,
  `system_username` char(20) DEFAULT NULL,
  `identifier` char(16) DEFAULT NULL,
  `unique_identifier` char(32) DEFAULT NULL,
  `comments` text,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `edit_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `system_username` (`system_username`),
  UNIQUE KEY `identifier` (`identifier`),
  UNIQUE KEY `unique_identifier` (`unique_identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `sys_account` WRITE;
/*!40000 ALTER TABLE `sys_account` DISABLE KEYS */;

-- note that `master-mysql-database` doesn't really exist but exists here for consistency with the other records, and for possible sub-
-- domain URL or path usage in the future similar to Slack URLs
INSERT INTO `sys_account` (`id`, `name`, `system_username`, `identifier`, `unique_identifier`, `comments`, `create_time`, `edit_time`)
VALUES
	(1,'CompassPoint SAAS Admin','{saas-account-username}','admin','{master-mysql-database}','<strong style=\"color:darkred;\">NEVER DELETE THIS!!</strong>\nThis is the record defining the main database control.  It is required to administer accounts and global user privileges, and interact with MYSQL','2021-04-05 10:04:26',null),
	(2,'Northwest Ventures, Inc.','{nwventures-username}','nwventures','{nwventures-database}','This is a fictitious sample account with some actual configured tables and data','2020-12-12 01:07:29',null),
	(3,'{accountName}','{user-account-username}','{accountIdentifier}','{user-account-database}','This is your account with no sample data set up.','2020-11-26 13:15:57',null);

/*!40000 ALTER TABLE `sys_account` ENABLE KEYS */;
UNLOCK TABLES;


CREATE TABLE `sys_account_password` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `account_id` int(11) NOT NULL,
  `system_password` char(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `account_id` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `sys_account_password` WRITE;
/*!40000 ALTER TABLE `sys_account_password` DISABLE KEYS */;

INSERT INTO `sys_account_password` (`id`, `account_id`, `system_password`)
VALUES
	(1,1,'{saas-account-password}'),
	(2,2,'{nwventures-password}'),
	(3,3,'{user-account-password}');

/*!40000 ALTER TABLE `sys_account_password` ENABLE KEYS */;
UNLOCK TABLES;


CREATE TABLE `sys_account_user_role` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `account_id` int(11) unsigned DEFAULT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `role_id` int(11) unsigned NOT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `edit_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `account_id` (`account_id`,`user_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `sys_account_user_role` WRITE;
/*!40000 ALTER TABLE `sys_account_user_role` DISABLE KEYS */;

INSERT INTO `sys_account_user_role` (`id`, `account_id`, `user_id`, `role_id`, `create_time`, `edit_time`)
VALUES
	(1,3,1,32,'2020-12-10 13:47:41',NULL),
	(2,NULL,1,256,'2020-12-11 02:50:42',NULL),
	(3,NULL,1,4096,'2020-12-11 02:51:18',NULL),
	(4,2,1,32,'2020-12-12 01:15:10',NULL),
	(5,1,1,4096,'2021-04-05 10:07:17',NULL);

/*!40000 ALTER TABLE `sys_account_user_role` ENABLE KEYS */;
UNLOCK TABLES;


CREATE TABLE `sys_changelog` (
  `id` int(15) unsigned NOT NULL AUTO_INCREMENT,
  `object_name` char(100) DEFAULT NULL COMMENT 'Reference table',
  `object_key` int(11) DEFAULT NULL COMMENT 'Reference table id',
  `data_source` enum('system','user') DEFAULT NULL COMMENT 'Source of entry (system or human)',
  `type` enum('value change','comment','insert record','delete record') DEFAULT NULL,
  `creator` char(50) DEFAULT NULL,
  `affected_element` char(128) DEFAULT NULL COMMENT 'Specifies field(s) affected',
  `change_from` text,
  `change_to` text,
  `comment` text,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `edit_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Auto-update; do not touch for normal non-system updates',
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  KEY `object_key` (`object_key`),
  KEY `create_time` (`create_time`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


CREATE TABLE `sys_data_group` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `data_group_id` int(11) unsigned DEFAULT NULL COMMENT 'parent data group',
  `table_id` int(11) unsigned DEFAULT NULL,
  `group_key` char(16) DEFAULT NULL,
  `group_label` char(64) DEFAULT NULL COMMENT 'e.g. employee-payroll',
  `title` char(128) NOT NULL DEFAULT '',
  `description` text,
  `default` tinyint(1) unsigned DEFAULT '1' COMMENT 'default data_group for a specified data_object',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `creator_id` int(11) unsigned DEFAULT NULL,
  `edit_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `editor_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `group_key` (`group_key`),
  UNIQUE KEY `group_label` (`group_label`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `sys_data_group` WRITE;
/*!40000 ALTER TABLE `sys_data_group` DISABLE KEYS */;

INSERT INTO `sys_data_group` (`id`, `data_group_id`, `table_id`, `group_key`, `group_label`, `title`, `description`, `default`, `create_time`, `creator_id`, `edit_time`, `editor_id`)
VALUES
	(1,NULL,NULL,'tg0001seed','system-admin-tables','System Admin Tables','account, user, password, roles, login; without these the SAAS application will not run',1,'2021-04-01 05:30:24',NULL,'2021-04-01 05:30:56',NULL),
	(2,NULL,NULL,'tg0002seed','control-tables','Control Tables','sys data_group, data_group_xref, data_object (this table), data_object_config, data_object_group',1,'2021-04-01 05:48:11',NULL,NULL,NULL);

/*!40000 ALTER TABLE `sys_data_group` ENABLE KEYS */;
UNLOCK TABLES;


CREATE TABLE `sys_data_group_xref` (
  `data_group_id` int(11) unsigned NOT NULL,
  `child_object_type` enum('sys_data_object','sys_table','sys_data_group','sys_data_group_xref') NOT NULL DEFAULT 'sys_table',
  `child_object_id` int(11) unsigned NOT NULL,
  `child_object_relationship` enum('user-defined','root table','dependent table','to be defined') NOT NULL DEFAULT 'to be defined',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `creator_id` int(11) unsigned DEFAULT NULL,
  `edit_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `editor_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`data_group_id`,`child_object_type`,`child_object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



CREATE TABLE `sys_data_object` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `group_id` int(11) unsigned DEFAULT NULL,
  `title` char(75) NOT NULL DEFAULT '',
  `description` text,
  `table_name` char(128) NOT NULL DEFAULT '',
  `table_key` char(12) DEFAULT NULL,
  `table_label` char(128) DEFAULT NULL COMMENT 'e.g. employee-payroll-category',
  `table_access` mediumint(6) unsigned DEFAULT '16',
  `enable_auditing` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `primary_key_reserved` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `control_fields_system_managed` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `version` char(20) DEFAULT 'v0.1 prototype',
  `initial_config` text COMMENT 'PHP array from user creation',
  `css_config_main` text,
  `create_method` char(30) DEFAULT 'unspecified',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `creator_id` int(11) DEFAULT NULL,
  `edit_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `editor_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `table_name` (`table_name`),
  UNIQUE KEY `table_key` (`table_key`),
  UNIQUE KEY `table_label` (`table_label`),
  KEY `group_id` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `sys_data_object` WRITE;
/*!40000 ALTER TABLE `sys_data_object` DISABLE KEYS */;

INSERT INTO `sys_data_object` (`id`, `group_id`, `title`, `description`, `table_name`, `table_key`, `table_label`, `table_access`, `enable_auditing`, `primary_key_reserved`, `control_fields_system_managed`, `version`, `initial_config`, `css_config_main`, `create_method`, `create_time`, `creator_id`, `edit_time`, `editor_id`)
VALUES
	(1,1,'CompassPoint SAAS Accounts','Master list of accounts in the system','sys_account','sys0001','sys-account',4096,1,1,1,'v0.1 prototype',NULL,NULL,'unspecified','2021-04-01 05:33:30',NULL,'2021-04-01 05:36:39',NULL),
	(2,1,'CompassPoint SAAS SQL Passwords','Maps passwords one-to-one in a separate physical table','sys_account_password','sys0002','sys-account-password',4096,1,1,1,'v0.1 prototype',NULL,NULL,'unspecified','2021-04-01 05:38:24',NULL,NULL,NULL),
	(3,1,'CompassPoint SAAS Account User and Roles','Compound primary key of account, user and role','sys_account_user_role','sys0003','sys-account-user-role',4096,1,1,1,'v0.1 prototype',NULL,NULL,'unspecified','2021-04-01 05:40:24',NULL,'2021-04-01 05:42:19',NULL),
	(4,1,'CompassPoint SAAS Login History','List of all logins into the system','sys_login','sys0004','sys-login',4096,1,1,1,'v0.1 prototype',NULL,NULL,'unspecified','2021-04-01 05:42:02',NULL,NULL,NULL),
	(5,1,'CompassPoint SAAS Roles','Master list of roles.  DO NOT change this unless understand the consequences!!!','sys_role','sys0005','sys-role',4096,1,1,1,'v0.1 prototype',NULL,NULL,'unspecified','2021-04-01 05:44:20',NULL,NULL,NULL),
	(6,1,'CompassPoint SAAS Users','Master list of users, including username, email and encrypted password','sys_user','sys0006','sys-user',4096,1,1,1,'v0.1 prototype',NULL,NULL,'unspecified','2021-04-01 05:45:14',NULL,NULL,NULL),
	(7,2,'Main Data Object Storage Table','A data object is nominally a table but intended to be broader in concept.','sys_data_object','ctrl0001','sys-data-object',32,1,1,1,'v0.1 prototype',NULL,NULL,'unspecified','2021-04-01 05:49:50',NULL,NULL,NULL),
	(8,2,'Data Object Configuration Settings','Designed to create javascript settings for the CVT component','sys_data_object_config','ctrl0002','sys-data-object-config',32,1,1,1,'v0.1 prototype',NULL,NULL,'unspecified','2021-04-01 05:51:11',NULL,NULL,NULL),
	(9,2,'Grouping for Data Objects','Allows data objects to be grouped; any data object can belong to one and only one of these groups; this is different from sys_data_object_group which creates applications, or Application Definitions (AD) and might span several of the groups referenced here.','sys_data_group','ctrl0003','sys-data-group',32,1,1,1,'v0.1 prototype',NULL,NULL,'unspecified','2021-04-01 05:52:58',NULL,'2021-04-01 05:54:05',NULL),
	(10,2,'Application Groups Cross-Reference','This allows for a system of extending an existing application by additional settings.','sys_data_group_xref','ctrl0004','sys-data-group-xref',32,1,1,1,'v0.1 prototype',NULL,NULL,'unspecified','2021-04-01 05:55:59',NULL,NULL,NULL);

/*!40000 ALTER TABLE `sys_data_object` ENABLE KEYS */;
UNLOCK TABLES;


CREATE TABLE `sys_data_object_config` (
  `id` int(14) unsigned NOT NULL AUTO_INCREMENT,
  `object_id` int(11) unsigned DEFAULT NULL COMMENT 'polymorphic on multiple tables',
  `object_type` enum('sys_data_object','sys_table','sys_data_group','sys_data_group_xref') NOT NULL DEFAULT 'sys_data_object' COMMENT 'polymorphic on multiple tables',
  `user_id` int(11) unsigned DEFAULT NULL COMMENT 'Null value means global value',
  `locked` tinyint(1) unsigned DEFAULT NULL,
  `item_type` char(50) DEFAULT NULL,
  `active` tinyint(1) unsigned DEFAULT '1' COMMENT 'Normally active; a way to turn a feature off',
  `config_id` int(11) unsigned DEFAULT NULL COMMENT 'In case we want hierarchy of some type',
  `node` char(32) DEFAULT NULL,
  `path` char(128) DEFAULT NULL,
  `field_name` char(64) DEFAULT NULL,
  `attribute` char(64) DEFAULT NULL,
  `value` text,
  `comments` text,
  `creator_id` int(11) unsigned DEFAULT NULL COMMENT 'CF Set manual',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'CF Set manual',
  `editor_id` int(11) unsigned DEFAULT NULL COMMENT 'CF Set manual',
  `edit_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT 'CF Set manual',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Account tables used by root';



CREATE TABLE `sys_data_object_group` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` char(30) NOT NULL DEFAULT '',
  `identifier` char(30) NOT NULL DEFAULT '',
  `description` text,
  `css_config_main` text,
  `create_method` char(30) DEFAULT 'unspecified',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `creator_id` int(11) unsigned DEFAULT NULL,
  `edit_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `editor_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `sys_data_object_group` WRITE;
/*!40000 ALTER TABLE `sys_data_object_group` DISABLE KEYS */;

INSERT INTO `sys_data_object_group` (`id`, `name`, `identifier`, `description`, `css_config_main`, `create_method`, `create_time`, `creator_id`, `edit_time`, `editor_id`)
VALUES
	(1,'Main System Tables','sys','Reserved for CompassPoint SAAS usage',NULL,'unspecified','2021-04-05 10:51:22',NULL,NULL,NULL);

/*!40000 ALTER TABLE `sys_data_object_group` ENABLE KEYS */;
UNLOCK TABLES;


CREATE TABLE `sys_login` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `account_id` int(11) DEFAULT NULL,
  `device_id` int(11) DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



CREATE TABLE `sys_role` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` char(80) NOT NULL DEFAULT '',
  `name_constant` char(80) NOT NULL DEFAULT '',
  `level` int(11) unsigned NOT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `edit_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `name_constant` (`name_constant`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `sys_role` WRITE;
/*!40000 ALTER TABLE `sys_role` DISABLE KEYS */;

INSERT INTO `sys_role` (`id`, `name`, `name_constant`, `level`, `create_time`, `edit_time`)
VALUES
	(1,'God Permissions','PERM_GOD',65356,'2020-11-29 12:51:52',NULL),
	(2,'System Administrator I','PERM_SYSTEM_ADMIN',4096,'2020-11-29 12:52:31',NULL),
	(3,'System User I','PERM_SYSTEM_USER',256,'2020-11-29 12:52:48',NULL),
	(4,'SAAS Administrator I','PERM_SAAS_ADMIN',32,'2020-11-29 12:53:12',NULL),
	(5,'SAAS User I','PERM_SAAS_USER',16,'2020-11-29 12:54:30',NULL),
	(6,'SAAS Guest I','PERM_SAAS_GUEST',4,'2020-11-29 12:59:34',NULL),
	(7,'SAAS Acolyte','PERM_CPM_SAAS_ACOLYTE',2,'2020-11-29 13:00:31','2021-04-05 10:08:39');

/*!40000 ALTER TABLE `sys_role` ENABLE KEYS */;
UNLOCK TABLES;


CREATE TABLE `sys_user` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `email` char(80) NOT NULL DEFAULT '',
  `first_name` char(80) NOT NULL DEFAULT '',
  `last_name` char(100) NOT NULL DEFAULT '',
  `username` char(30) NOT NULL DEFAULT '',
  `unique_identifier` char(32) NOT NULL DEFAULT '',
  `password` char(100) NOT NULL DEFAULT '',
  `password_version` tinyint(3) DEFAULT NULL COMMENT '1=md5',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `edit_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `unique_identifier` (`unique_identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;

INSERT INTO `sys_user` (`id`, `email`, `first_name`, `last_name`, `username`, `unique_identifier`, `password`, `password_version`, `create_time`, `edit_time`)
VALUES
	(1,'{email}','{firstName}','{lastName}','{username}','{user-unique-identifier-primary}','{passwordMd5}',1,NOW(),null);

/*!40000 ALTER TABLE `sys_user` ENABLE KEYS */;
UNLOCK TABLES;


CREATE TABLE `v1_menu_items` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL DEFAULT '',
  `title` varchar(255) NOT NULL,
  `url` varchar(400) NOT NULL DEFAULT '',
  `nav_id` varchar(25) DEFAULT NULL,
  `display_order` int(2) DEFAULT NULL,
  `img_source` char(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `v1_menu_items` WRITE;
/*!40000 ALTER TABLE `v1_menu_items` DISABLE KEYS */;

INSERT INTO `v1_menu_items` (`id`, `name`, `title`, `url`, `nav_id`, `display_order`, `img_source`)
VALUES
	(158,'Database Engineering','','','3',NULL,NULL),
	(159,'Middleware Engineering','','','3',NULL,NULL),
	(160,'Compute Engineering','','','3',NULL,NULL),
	(273,'Automated Deployments','','','2',5,'/asset/img/apps/deploy_64_64.png'),
	(277,'Change Tracking','','/data/view/change-tracking','2',8,'/asset/img/apps/changes_64_64.png'),
	(270,'Enterprise Server Inventory','','','2',2,'/asset/img/apps/servers_64_64.png'),
	(271,'JAVA Inventory','','','2',3,'/asset/img/apps/jboss_64.png'),
	(269,'Legacy Server Inventory','','','2',1,'/asset/img/apps/servers_64_64.png'),
	(276,'Request Tracking','','/data/view/request-tracking','2',0,'/asset/img/apps/requests_64_64.png'),
	(274,'Splunk Search','','','2',6,'/asset/img/apps/splunk-logo-sm.png'),
	(272,'Web Inventory','','','2',4,'/asset/img/apps/web_64.png'),
	(278,'Provision Tracking','','/data/view/provision-tracking','2',0,'/asset/img/apps/provisioning_64_64.png');

/*!40000 ALTER TABLE `v1_menu_items` ENABLE KEYS */;
UNLOCK TABLES;


CREATE TABLE `v1_menu_navbar` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '',
  `title` varchar(255) DEFAULT NULL,
  `url` varchar(100) DEFAULT NULL,
  `display_order` int(3) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

LOCK TABLES `v1_menu_navbar` WRITE;
/*!40000 ALTER TABLE `v1_menu_navbar` DISABLE KEYS */;

INSERT INTO `v1_menu_navbar` (`id`, `name`, `title`, `url`, `display_order`)
VALUES
	(1,'Home','SAAS App Main Page','/',1),
	(2,'Main',NULL,'/sample/main',2),
	(3,'Departments',NULL,'/sample/departments',3),
	(4,'Data Objects',NULL,'/data/manage',4);

/*!40000 ALTER TABLE `v1_menu_navbar` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
