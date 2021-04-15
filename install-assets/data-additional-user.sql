USE compasspoint_saas;

INSERT INTO `sys_user` (`id`, `email`, `first_name`, `last_name`, `username`, `unique_identifier`, `password`, `password_version`, `create_time`, `edit_time`)
VALUES
	(2,'{userEmail}','{userFirstName}','{userLastName}','{userUsername}','{user-unique-identifier-user}','{userPasswordMd5}',1,NOW(),null);

INSERT INTO `sys_account_user_role` (`id`, `account_id`, `user_id`, `role_id`, `create_time`, `edit_time`)
VALUES
	(6,3,3,16,'2020-12-10 13:47:41',NULL);



USE cpmsaas_{nwventures-database};

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;

INSERT INTO `sys_user` (`id`, `label`, `firstname`, `lastname`, `email`, `notes`)
VALUES
	(2,'{userFirstName} {userLastName}','{userFirstName}','{userLastName}','{userEmail}','Added via install script');

/*!40000 ALTER TABLE `sys_user` ENABLE KEYS */;
UNLOCK TABLES;



USE cpmsaas_{user-account-database};

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;

INSERT INTO `sys_user` (`id`, `label`, `firstname`, `lastname`, `email`, `notes`)
VALUES
	(2,'{userFirstName} {userLastName}','{userFirstName}','{userLastName}','{userEmail}','Added via install script');

/*!40000 ALTER TABLE `sys_user` ENABLE KEYS */;
UNLOCK TABLES;

