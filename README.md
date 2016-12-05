Magento2 Bash CI Script
=======================

Simple bash script for Continuous Integrations which automates Magento2 installation and integrations test setup.

Usage
-----

You can specify setup parameters through environment variables or you can pass config file as first argument.

Without config file:

	$ bash m2-bash-ci.sh
	
With config file:

	$ bash m2-bash-ci.sh path/to/file.conf
	
See an example config file directly in this repository file `envars.conf.dist`.
	
If the `MYSQL_CLI_CREDENTIALS` variable is set to `true` MySQL credentials are specified through the command line for MySQL related operations.

	