/**
 * @version 0.1.01 Uninstall script to reverse sql-template.sql.
 *  NOTE! This outputs to tmp/data-uninstall.sql.  It is not used in provisioning but should clean all dtaabase touches
 *  made by data-install.sql
 */

DROP DATABASE IF EXISTS compasspoint_saas;

DROP DATABASE IF EXISTS cpmsaas_{nwventures-database};

DROP DATABASE IF EXISTS cpmsaas_{user-account-database};

DROP DATABASE IF EXISTS z_public;

DROP USER IF EXISTS z_public@localhost;

DROP USER IF EXISTS {master-mysql-username}@localhost;

DROP USER IF EXISTS {saas-account-username}@localhost;

DROP USER IF EXISTS {nwventures-username}@localhost;

DROP USER IF EXISTS {user-account-username}@localhost;
