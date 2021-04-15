/**
 * @version 0.1.01 See interview version in install.php.  Creates the control database, a Northwest Ventures account and a
 *  clean user account
 */

CREATE DATABASE compasspoint_saas;

CREATE DATABASE cpmsaas_{nwventures-database};

CREATE DATABASE cpmsaas_{user-account-database};

CREATE DATABASE z_public;


-- this is the Master User which can access the control database; it is stored in private/config.php and not in the control database;
-- this should make sense.
GRANT ALL PRIVILEGES ON compasspoint_saas.* TO {master-mysql-username}@localhost IDENTIFIED BY '{master-mysql-password}';

-- this MYSQL user also has access to all account databases
GRANT ALL PRIVILEGES ON `cpmsaas\_%`.* TO {master-mysql-username}@localhost;

-- also, write access to the z_public data storage db
GRANT ALL PRIVILEGES ON z_public.* TO {master-mysql-username}@localhost;

-- these three MYSQL users are the god privilege to their respective database, and can also read z_public
GRANT ALL PRIVILEGES ON `compasspoint_saas`.* TO {saas-account-username}@localhost IDENTIFIED BY '{saas-account-password}';
GRANT SELECT ON z_public.* TO {saas-account-username}@localhost;

GRANT ALL PRIVILEGES ON `cpmsaas_{nwventures-database}`.* TO {nwventures-username}@localhost IDENTIFIED BY '{nwventures-password}';
GRANT SELECT ON z_public.* TO {nwventures-username}@localhost;

GRANT ALL PRIVILEGES ON `cpmsaas_{user-account-database}`.* TO {user-account-username}@localhost IDENTIFIED BY '{user-account-password}';
GRANT SELECT ON z_public.* TO {user-account-username}@localhost;


USE z_public;

-- @todo, create basic data for this for general use!
-- import data-z_public.sql

USE compasspoint_saas;

-- import data-master-mysql-database.sql

USE cpmsaas_{nwventures-database};

-- import data-nwventures-database.sql

USE cpmsaas_{user-account-database};

-- import data-user-account-database.sql

-- Optional import if requested by installer
-- import data-additional-user.sql
