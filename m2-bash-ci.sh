#!/usr/bin/env bash

export SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ ! -z "$1" ] && [ -f "$1" ]; then
    echo "Loading environment variables from $1..."
    source "$1"
fi;

function mysql_cli {
    if [ "${MYSQL_CLI_CREDENTIALS}" = true ] ; then
        mysql -h ${DB_HOST} -u ${DB_USER} --password=${DB_PASS} -e "$1"
    else
        mysql -e "$1"
    fi;
}

MAGENTO_INSTALL_DB_PASSWORD="--db-password=${DB_PASS}"
if [ -z "${DB_PASS}" ]; then
    MAGENTO_INSTALL_DB_PASSWORD=""
fi;

mysql_cli "DROP DATABASE IF EXISTS \`${DB_NAME}\`;"
mysql_cli "DROP DATABASE IF EXISTS \`${DB_TEST}\`;"
mysql_cli "CREATE DATABASE \`${DB_NAME}\` CHARACTER SET utf8;"
mysql_cli "CREATE DATABASE \`${DB_TEST}\` CHARACTER SET utf8;"
php bin/magento setup:install --db-host="${DB_HOST}" --db-name="${DB_NAME}" --db-user="${DB_USER}" \
${MAGENTO_INSTALL_DB_PASSWORD} --admin-firstname="Magento" --admin-lastname="User" --admin-email="user@example.com" \
--admin-user="admin" --admin-password="admin123" --use-rewrites="1" --base-url="${BASE_URL}"
php bin/magento deploy:mode:set developer
rm -f ${SCRIPT_DIR}/dev/tests/integration/etc/install-config-mysql.php
cp -f ${SCRIPT_DIR}/dev/tests/integration/etc/install-config-mysql.php.dist ${SCRIPT_DIR}/dev/tests/integration/etc/install-config-mysql.php
sed -i -e  "s/'db-host' => '.*'/'db-host' => '${DB_HOST}'/" ${SCRIPT_DIR}/dev/tests/integration/etc/install-config-mysql.php
sed -i -e  "s/'db-user' => '.*'/'db-user' => '${DB_USER}'/" ${SCRIPT_DIR}/dev/tests/integration/etc/install-config-mysql.php
sed -i -e  "s/'db-password' => '.*'/'db-password' => '${DB_PASS}'/" ${SCRIPT_DIR}/dev/tests/integration/etc/install-config-mysql.php
sed -i -e  "s/'db-name' => '.*'/'db-name' => '${DB_TEST}'/" ${SCRIPT_DIR}/dev/tests/integration/etc/install-config-mysql.php
