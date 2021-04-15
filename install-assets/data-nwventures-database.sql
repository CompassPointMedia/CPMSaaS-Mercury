
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


CREATE TABLE `__nwventures` (
  `comment` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `__nwventures` WRITE;
/*!40000 ALTER TABLE `__nwventures` DISABLE KEYS */;

INSERT INTO `__nwventures` (`comment`)
VALUES
	('This table is simply here to identify the \"real\" name of this database for convenience.  It is not designed to be used and may be deleted.');

/*!40000 ALTER TABLE `__nwventures` ENABLE KEYS */;
UNLOCK TABLES;


CREATE TABLE `public_common_hours` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `activity` enum('','Work','Professional Development','Aviation','Investment','Admin and Paperwork','Misc') DEFAULT '',
  `user_id` int(11) DEFAULT NULL COMMENT 'System Variable User-Selectable',
  `start_time` datetime DEFAULT NULL,
  `stop_time` datetime DEFAULT NULL,
  `hours` float(7,3) DEFAULT NULL,
  `client` char(100) DEFAULT NULL,
  `description` text CHARACTER SET utf8,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'System Variable',
  `creator_id` int(11) DEFAULT NULL COMMENT 'System Variable',
  `edit_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT 'System Variable',
  `editor_id` int(11) DEFAULT NULL COMMENT 'System Variable',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `public_common_ideas` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `category` char(30) DEFAULT NULL,
  `name` char(80) DEFAULT NULL,
  `description` text,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `creator_id` int(11) unsigned DEFAULT NULL,
  `edit_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `editor_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `public_common_request_tracking` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `itsm_source` enum('ITSM','BRCC') DEFAULT NULL,
  `itsm_number` char(20) DEFAULT NULL,
  `itsm_instance_id` varchar(100) DEFAULT NULL,
  `itsm_details` text,
  `itsm_description` text,
  `itsm_status` char(20) DEFAULT NULL,
  `itsm_priority` char(20) DEFAULT NULL,
  `itsm_create_time` bigint(20) DEFAULT NULL,
  `itsm_modifier` varchar(100) DEFAULT NULL,
  `itsm_edit_time` bigint(15) DEFAULT NULL,
  `itsm_template_name` varchar(100) DEFAULT NULL,
  `itsm_template_id` varchar(40) DEFAULT NULL,
  `auto_job_name` varchar(100) DEFAULT NULL,
  `auto_job_id` varchar(100) DEFAULT NULL,
  `auto_start` varchar(20) DEFAULT NULL,
  `auto_stop` varchar(20) DEFAULT NULL,
  `auto_status` enum('N/A','PENDING','EXECUTING','COMPLETED') NOT NULL DEFAULT 'N/A',
  `customer_first_name` char(128) DEFAULT NULL,
  `customer_last_name` char(128) DEFAULT NULL,
  `customer_phone_number` char(35) DEFAULT NULL,
  `customer_group` char(128) DEFAULT NULL,
  `customer_login` char(100) DEFAULT NULL,
  `assignee_name` char(100) DEFAULT NULL,
  `assignee_login` varchar(100) DEFAULT NULL,
  `assignee_group` char(128) DEFAULT NULL,
  `record_create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `record_edit_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Auto-update; do not touch \nfor normal non-system updates',
  PRIMARY KEY (`id`),
  UNIQUE KEY `NODUPS` (`itsm_source`,`itsm_number`),
  KEY `data_source` (`itsm_source`),
  KEY `itsm_number` (`itsm_number`),
  KEY `department` (`customer_group`),
  KEY `status` (`itsm_status`),
  KEY `priority` (`itsm_priority`),
  KEY `assigned_to` (`assignee_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Request tracker header entry table';


CREATE TABLE `public_common_todo` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `activity` enum('','Work','Professional Development','Aviation','Investment','Admin and Paperwork','Misc') DEFAULT '',
  `item` text,
  `description` text,
  `status` char(20) DEFAULT NULL,
  `project` char(128) DEFAULT NULL,
  `tickets` char(128) DEFAULT NULL,
  `category` char(128) DEFAULT NULL,
  `page` char(255) DEFAULT NULL COMMENT 'path to the "page" will be good I''d think',
  `entry_date` date DEFAULT NULL,
  `complete_date` date DEFAULT NULL,
  `comments` text,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `edit_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `project` (`project`),
  KEY `category` (`category`),
  KEY `statusindicator` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


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
  `table_access` tinyint(3) unsigned DEFAULT '16',
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
	(1,1,'Hours Tracking I','First table for hours tracking to replace what I have done in Google sheets; eventually to integrate in with timesheets and invoicing.  Needs dependencies on project and user','public_common_hours','ec1893aq4103','hours-tracking',16,1,1,1,'v0.1 prototype',NULL,NULL,'unspecified','2020-12-02 10:29:15',1,'2021-01-09 06:31:06',NULL),
	(3,1,'Project Todo List','For organizing the many todo items I write but never complete by project, category and page','public_common_todo','em4336gm9018','project-todo',16,1,1,1,'v0.1 prototype',NULL,NULL,'unspecified','2020-12-22 13:50:36',1,'2021-01-09 06:31:06',NULL),
	(152,4,'Data Object Changelog','A git diff-like storage device for field changes from multiple changes, as well as inserts and deletes','sys_changelog','qn2774cd',NULL,16,1,1,1,'v0.1 prototype',NULL,NULL,'unspecified','2020-12-24 06:26:03',NULL,'2021-01-09 07:05:04',NULL),
	(262,4,'Data Object Configurator','sys_table_config holds JavaScript configurations for field and display elements of data objects','sys_data_object_config','sy0999ef','sys-table-config',32,1,1,1,'v0.1 prototype',NULL,NULL,'unspecified','2020-12-24 17:41:20',NULL,'2021-01-09 06:31:18',NULL),
	(263,4,'Data Object Tables','sys_table holds all registered tables including itself for system management','sys_data_object','sy0998ef','sys-table',32,1,1,1,'v0.1 prototype',NULL,NULL,'unspecified','2020-12-28 06:29:19',NULL,'2021-01-09 06:31:18',NULL),
	(264,4,'Data Object Groups','Grouping table for data objects','sys_data_object_group','sy9997fg','data-group',16,1,1,1,'v0.1 prototype','','','unspecified','2021-01-09 08:09:34',0,'2021-01-09 08:12:29',0),
	(265,1,'Ideas Business & Otherwise','Summary of any chunk-worthy idea I have had, especially business ideas that have the potential of making money but also just processes that are innovative and needed','public_common_ideas','id8790gz','ideas',16,1,1,1,'v0.1 prototype',NULL,NULL,'unspecified','2021-01-10 20:55:20',NULL,NULL,NULL);

/*!40000 ALTER TABLE `sys_data_object` ENABLE KEYS */;
UNLOCK TABLES;


CREATE TABLE `sys_data_object_config` (
  `id` int(14) unsigned NOT NULL AUTO_INCREMENT,
  `data_object` char(40) DEFAULT 'default' COMMENT 'DELETE THIS',
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
  KEY `data_object` (`data_object`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Created by Data::create() December 24th, 2020 at 5:14:23PM';

LOCK TABLES `sys_data_object_config` WRITE;
/*!40000 ALTER TABLE `sys_data_object_config` DISABLE KEYS */;

INSERT INTO `sys_data_object_config` (`id`, `data_object`, `object_id`, `object_type`, `user_id`, `locked`, `item_type`, `active`, `config_id`, `node`, `path`, `field_name`, `attribute`, `value`, `comments`, `creator_id`, `create_time`, `editor_id`, `edit_time`)
VALUES
	(1,'default',262,'sys_data_object',0,1,'configuration',1,0,'layout','columns','table_id','label','Table','',1,'2020-12-24 17:58:22',NULL,'2021-03-17 13:47:12'),
	(2,'default',262,'sys_data_object',0,0,'configuration',1,0,'layout','columns','table_id','width','200','',1,'2020-12-24 19:55:39',0,'2021-03-17 13:47:12'),
	(3,'default',262,'sys_data_object',0,0,'configuration',1,0,'layout','columns','data_object','hideColumn','1','',1,'2020-12-24 20:58:54',0,'2021-03-17 13:47:12'),
	(4,'default',262,'sys_data_object',0,0,'configuration',1,0,'lazy','','','','[\n	\'layout.columns\',\n	function(data) {\n		var hideable = [ \'locked\', \'active\', \'config_id\', \'creator_id\', \'create_time\', \'editor_id\', \'edit_time\', \'comments\', \'data_object\',\'table_id\' ]\n		var columns = [];\n		for(var i in data.focus){\n			if (!in_array(i, hideable)) continue;\n			if (typeof data.layout.columns[i] === \'undefined\') {\n				data.layout.columns[i] = {};\n			}\n			columns.push(i);\n		}\n		return columns;\n	},\n	{hideColumn : true}\n]','',0,'2020-12-24 21:44:44',0,'2021-03-17 13:47:12'),
	(5,'default',262,'sys_data_object',0,0,'configuration',1,0,'lazy','','','','[\n	\'layout.columns\',\n	function(data) {\n		var hideableFromEdit = [ \'locked\', \'active\', \'config_id\', \'creator_id\', \'editor_id\', \'data_object\' ], columns = [];\n		for(var i in data.focus){\n			if (! in_array(i, hideableFromEdit)) continue;\n			if (typeof data.layout.columns[i] === \'undefined\') {\n				data.layout.columns[i] = {};\n			}\n			columns.push(i);\n		}\n		return columns;\n	},\n	{hideFromEdit : true}\n]','',0,'2020-12-24 22:41:34',0,'2021-03-17 13:47:12'),
	(6,'default',262,'sys_data_object',0,0,'configuration',1,0,'layout','columns','user_id','label','For User','',0,'2020-12-24 22:49:51',0,'2021-01-04 07:29:09'),
	(7,'default',262,'sys_data_object',0,0,'configuration',1,0,'layout','columns','item_type','label','Type','',0,'2020-12-24 22:55:04',0,'2021-01-04 07:29:09'),
	(8,'default',262,'sys_data_object',0,0,'configuration',1,0,'layout','columns','field_name','label','Field','',0,'2020-12-24 22:56:11',0,'2021-01-04 07:29:09'),
	(10,'default',3,'sys_data_object',0,0,'configuration',1,0,'lazy','','','','[\n	\'layout.columns\',\n	function(data) {\n		var hideable = [ \'page\', \'tickets\', \'comments\', \'data_object\' ]\n		var columns = [];\n		for(var i in data.focus){\n			if (!in_array(i, hideable)) continue;\n			if (typeof data.layout.columns[i] === \'undefined\') {\n				data.layout.columns[i] = {};\n			}\n			columns.push(i);\n		}\n		return columns;\n	},\n	{hideColumn : true}\n]','',0,'2020-12-24 23:04:41',0,'2021-03-17 13:47:12'),
	(11,'default',3,'sys_data_object',0,0,'configuration',1,0,'layout','columns','description','width','425','',0,'2020-12-24 23:06:07',0,'2021-01-04 07:29:09'),
	(12,'default',3,'sys_data_object',0,0,'configuration',1,0,'layout','columns','item','width','200','',0,'2020-12-24 23:07:28',0,'2021-01-04 07:29:09'),
	(13,'default',62,'sys_data_object',0,0,'configuration',1,0,'layout','columns','Terms_ID','hideColumn','1','',0,'2020-12-26 20:40:20',0,'2021-03-17 13:47:12'),
	(15,'default',262,'sys_data_object',0,0,'configuration',1,0,'layout','columns','value','width','250','',0,'2020-12-28 05:17:35',0,'2021-01-04 07:29:09'),
	(16,'default',262,'sys_data_object',0,0,'configuration',1,0,'layout','columns','object_id','relation','[\n	{\n		identifier: \'sys-table\',\n		handle: \'default\',          // Optional if only one label is specified\n		format: \'default\',          // TBD - depending on the user prefs; intended to hook into locale settings\n		label: \'r.table_name\'\n	}\n]','',0,'2020-12-28 06:36:12',0,'2021-03-17 13:47:12'),
	(21,'default',1,'sys_data_object',0,0,'configuration',1,0,'lazy','','','','[\n	\'layout.columns\',\n	function(data) {\n		var hideable = [ \'creator_id\', \'create_time\', \'editor_id\', \'edit_time\' ]\n		var columns = [];\n		for(var i in data.focus){\n			if (!in_array(i, hideable)) continue;\n			if (typeof data.layout.columns[i] === \'undefined\') {\n				data.layout.columns[i] = {};\n			}\n			columns.push(i);\n		}\n		return columns;\n	},\n	{hideColumn : true}\n]','',0,'2021-01-01 15:25:05',0,'2021-03-17 13:47:12'),
	(22,'default',263,'sys_data_object',0,0,'configuration',1,0,'layout','columns','description','hideColumn','1','',0,'2021-01-04 07:01:22',0,'2021-03-17 13:47:12'),
	(23,'default',263,'sys_data_object',0,0,'configuration',1,0,'layout','columns','css_config_main','hideColumn','1','',0,'2021-01-04 07:28:18',0,'2021-03-17 13:47:12'),
	(24,'default',263,'sys_data_object',0,0,'configuration',1,0,'lazy','','','','[\n	\'layout.columns\',\n	function(data) {\n		var hideable = [ \'version\', \'create_method\', \'initial_config\', \'creator_id\', \'create_time\', \'editor_id\', \'edit_time\', \'comments\', \'data_object\',\'table_id\' ]\n		var columns = [];\n		for(var i in data.focus){\n			if (!in_array(i, hideable)) continue;\n			if (typeof data.layout.columns[i] === \'undefined\') {\n				data.layout.columns[i] = {};\n			}\n			columns.push(i);\n		}\n		return columns;\n	},\n	{hideColumn : true}\n]','',0,'2021-01-04 09:08:33',0,'2021-03-17 13:47:12'),
	(25,'default',265,'sys_data_object',0,0,'configuration',1,0,'lazy','','','','[\n	\'layout.columns\',\n	function(data) {\n		var hideableFromEdit = [ \'creator_id\', \'editor_id\', \'edit_time\' ], columns = [];\n		for(var i in data.focus){\n			if (! in_array(i, hideableFromEdit)) continue;\n			if (typeof data.layout.columns[i] === \'undefined\') {\n				data.layout.columns[i] = {};\n			}\n			columns.push(i);\n		}\n		return columns;\n	},\n	{hideFromEdit : true, hideColumn: true}\n]','',0,'2021-01-10 21:10:28',0,'2021-01-10 21:18:21'),
	(26,'default',3,'sys_data_object',0,0,'configuration',1,0,'layout','orderBy','','id','DESC','',0,'2021-01-13 05:50:10',0,'2021-03-17 13:47:12');

/*!40000 ALTER TABLE `sys_data_object_config` ENABLE KEYS */;
UNLOCK TABLES;


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
	(1,'Main Tables','common','All uncategorized tables',NULL,'unspecified','2020-12-02 10:29:15',NULL,'2021-01-09 06:15:07',NULL),
	(4,'System Objects','sys','Reserved for SAAS usage',NULL,'unspecified','2020-12-24 17:41:20',NULL,'2021-03-17 13:45:45',NULL);

/*!40000 ALTER TABLE `sys_data_object_group` ENABLE KEYS */;
UNLOCK TABLES;


CREATE TABLE `sys_user` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `label` char(255) DEFAULT NULL,
  `firstname` char(50) DEFAULT NULL,
  `lastname` char(70) DEFAULT NULL,
  `email` char(80) DEFAULT NULL,
  `notes` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;

INSERT INTO `sys_user` (`id`, `label`, `firstname`, `lastname`, `email`, `notes`)
VALUES
	(1,'{firstName} {lastName}','{firstName}','{lastName}','{email}','Added via install script');

/*!40000 ALTER TABLE `sys_user` ENABLE KEYS */;
UNLOCK TABLES;

/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
