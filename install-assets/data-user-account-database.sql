
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


CREATE TABLE `__{accountIdentifier}` (
  `comment` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `__{accountIdentifier}` WRITE;
/*!40000 ALTER TABLE `__{accountIdentifier}` DISABLE KEYS */;

INSERT INTO `__{accountIdentifier}` (`comment`)
VALUES
	('This table is simply here to identify the \"real\" name of this database for convenience.  It is not designed to be used and may be deleted.');

/*!40000 ALTER TABLE `__{accountIdentifier}` ENABLE KEYS */;
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
	(152,4,'Data Object Changelog','A git diff-like storage device for field changes from multiple changes, as well as inserts and deletes','sys_changelog','qn2774cd',NULL,16,1,1,1,'v0.1 prototype',NULL,NULL,'unspecified','2020-12-24 06:26:03',NULL,'2021-01-09 07:05:04',NULL),
	(262,4,'Data Object Configurator','sys_table_config holds JavaScript configurations for field and display elements of data objects','sys_data_object_config','sy0999ef','sys-table-config',32,1,1,1,'v0.1 prototype',NULL,NULL,'unspecified','2020-12-24 17:41:20',NULL,'2021-01-09 06:31:18',NULL),
	(263,4,'Data Object Tables','sys_table holds all registered tables including itself for system management','sys_data_object','sy0998ef','sys-table',32,1,1,1,'v0.1 prototype',NULL,NULL,'unspecified','2020-12-28 06:29:19',NULL,'2021-01-09 06:31:18',NULL),
	(264,4,'Data Object Groups','Grouping table for data objects','sys_data_object_group','sy9997fg','data-group',16,1,1,1,'v0.1 prototype','','','unspecified','2021-01-09 08:09:34',0,'2021-01-09 08:12:29',0);

/*!40000 ALTER TABLE `sys_data_object` ENABLE KEYS */;
UNLOCK TABLES;


CREATE TABLE `sys_data_object_config` (
  `id` int(14) unsigned NOT NULL AUTO_INCREMENT,
  `data_object` char(40) DEFAULT 'default',
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
	(1,'default',262,'sys_data_object',0,1,'configuration',1,0,'layout','columns','table_id','label','Table','This is my first pre-history entry of a configuration data piece on the first field of the table itself.  Here is what I want to do:\n1. change the label to \"Table\" (this entry here)\n2. change the with to something\n3. add a relational dropdown - which will be rather complex\n4. hide config_id - we will probably never use it\n5. change locked to a checkbox\n6. change item type to a dropdown list with a complete list of the \"observer\" functions I have created\n7. add a custom Vue component which gets included on the page\n8. make Create Time be uneditable on insert, maybe say (creating new record), and then also on update but show the time - I know I have done this before\n9. hide data object (default) field - not useful for now\n10. change the width of this Comments field\n11. Actually, no, hide this comments too, make it a widget that shows on mouseover\n\nThe list of observer hooks:\nobserverPostDataLoad\nobserverPostDataReload\nobserverPostLocalSort\nobserverTransformDataset\nobserverLoadRecord\nobserverLoadRecord\nobserverPostLoadRecord\nobserverInsertOrUpdateParameters\nobserverInsertOrUpdateApplicationParameters\nobserverBeforeCancelRecord\nobserverPostInsertOrUpdateRecord\nobserverGridClass\nobserverPostResizeColumn\nobserverUpdateRequest\n\n\nThat should do it!\n\nI am now testing if I can do an update after a LOT of cleanup in the data: node, if so everything probably works correctly and function mergeDeep(native, injector) is working properly.',1,'2020-12-24 17:58:22',NULL,'2021-01-04 07:29:09'),
	(2,'default',262,'sys_data_object',0,0,'configuration',1,0,'layout','columns','table_id','width','200','this satisfies an item in comments for row 1',1,'2020-12-24 19:55:39',0,'2021-01-04 07:29:09'),
	(3,'default',262,'sys_data_object',0,0,'configuration',1,0,'layout','columns','data_object','hideColumn','1','here I have set the value to 1, it should be false but there is a problem with JSON encoding wrapping that',1,'2020-12-24 20:58:54',0,'2021-01-04 07:29:09'),
	(4,'default',262,'sys_data_object',0,0,'configuration',1,0,'lazy','','','','[\n	\'layout.columns\',\n	function(data) {\n		var hideable = [ \'locked\', \'active\', \'config_id\', \'creator_id\', \'create_time\', \'editor_id\', \'edit_time\', \'comments\', \'data_object\',\'table_id\' ]\n		var columns = [];\n		for(var i in data.focus){\n			if (!in_array(i, hideable)) continue;\n			if (typeof data.layout.columns[i] === \'undefined\') {\n				data.layout.columns[i] = {};\n			}\n			columns.push(i);\n		}\n		return columns;\n	},\n	{hideColumn : true}\n]','First instance of re-vitalizing `lazy`.  It\'s a difficult method to grasp at first, and probably is really lousy amateur JS, but it is a useful concept.',0,'2020-12-24 21:44:44',0,'2021-01-04 09:05:16'),
	(5,'default',262,'sys_data_object',0,0,'configuration',1,0,'lazy','','','','[\n	\'layout.columns\',\n	function(data) {\n		var hideableFromEdit = [ \'locked\', \'active\', \'config_id\', \'creator_id\', \'editor_id\', \'data_object\' ], columns = [];\n		for(var i in data.focus){\n			if (! in_array(i, hideableFromEdit)) continue;\n			if (typeof data.layout.columns[i] === \'undefined\') {\n				data.layout.columns[i] = {};\n			}\n			columns.push(i);\n		}\n		return columns;\n	},\n	{hideFromEdit : true}\n]','Second use of lazy, I want to see if hideFromEdit and hideFromInsert are two different things',0,'2020-12-24 22:41:34',0,'2021-01-04 07:29:09'),
	(6,'default',262,'sys_data_object',0,0,'configuration',1,0,'layout','columns','user_id','label','For User','',0,'2020-12-24 22:49:51',0,'2021-01-04 07:29:09'),
	(7,'default',262,'sys_data_object',0,0,'configuration',1,0,'layout','columns','item_type','label','Type','',0,'2020-12-24 22:55:04',0,'2021-01-04 07:29:09'),
	(8,'default',262,'sys_data_object',0,0,'configuration',1,0,'layout','columns','field_name','label','Field','',0,'2020-12-24 22:56:11',0,'2021-01-04 07:29:09'),
	(15,'default',262,'sys_data_object',0,0,'configuration',1,0,'layout','columns','value','width','250','',0,'2020-12-28 05:17:35',0,'2021-01-04 07:29:09'),
	(16,'default',262,'sys_data_object',0,0,'configuration',1,0,'layout','columns','object_id','relation','[\n	{\n		identifier: \'sys-table\',\n		handle: \'default\',          // Optional if only one label is specified\n		format: \'default\',          // TBD - depending on the user prefs; intended to hook into locale settings\n		label: \'r.table_name\'\n	}\n]','This is the first entry of a relation.  This is a new thing where the FE can dictate a relation that the backend might not possess.',0,'2020-12-28 06:36:12',0,'2021-01-09 07:14:20'),
	(23,'default',263,'sys_data_object',0,0,'configuration',1,0,'layout','columns','css_config_main','hideColumn','1','configured for CPMSAAS-12',0,'2021-01-04 07:28:18',0,'0000-00-00 00:00:00'),
	(24,'default',263,'sys_data_object',0,0,'configuration',1,0,'lazy','','','','[\n	\'layout.columns\',\n	function(data) {\n		var hideable = [ \'version\', \'create_method\', \'initial_config\', \'creator_id\', \'create_time\', \'editor_id\', \'edit_time\', \'comments\', \'data_object\',\'table_id\' ]\n		var columns = [];\n		for(var i in data.focus){\n			if (!in_array(i, hideable)) continue;\n			if (typeof data.layout.columns[i] === \'undefined\') {\n				data.layout.columns[i] = {};\n			}\n			columns.push(i);\n		}\n		return columns;\n	},\n	{hideColumn : true}\n]','copied and pasted over; how I would love a copy feature',0,'2021-01-04 09:08:33',0,'0000-00-00 00:00:00'),
	(25,'default',265,'sys_data_object',0,0,'configuration',1,0,'lazy','','','','[\n	\'layout.columns\',\n	function(data) {\n		var hideableFromEdit = [ \'creator_id\', \'editor_id\', \'edit_time\' ], columns = [];\n		for(var i in data.focus){\n			if (! in_array(i, hideableFromEdit)) continue;\n			if (typeof data.layout.columns[i] === \'undefined\') {\n				data.layout.columns[i] = {};\n			}\n			columns.push(i);\n		}\n		return columns;\n	},\n	{hideFromEdit : true, hideColumn: true}\n]','',0,'2021-01-10 21:10:28',0,'2021-01-10 21:18:21');

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
	(2,'Financial Accounting','financial','Developed by Compass Point Media for e-commerce clients',NULL,'unspecified','2020-12-23 19:19:11',NULL,'2021-01-09 06:14:36',NULL),
	(3,'Relatebase Tables','relatebase',NULL,NULL,'unspecified','2020-12-24 06:26:03',NULL,'2021-01-09 06:14:41',NULL),
	(4,'System Objects','sys','Reserved for CompassPoint SAAS usage',NULL,'unspecified','2020-12-24 17:41:20',NULL,'2021-01-09 06:13:57',NULL);

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
