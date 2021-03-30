#!/bin/bash
set -e

db_host=${MODULE_DB_HOST-"postgres"}
db_port=${MODULE_DB_PORT-"5432"}
db_database=${MODULE_DB_DATABASE-"okapi_modules"}
db_username=${MODULE_DB_USERNAME-"folio_admin"}
db_password=${MODULE_DB_PASSWORD-"folio_admin"}



mods="mod-users mod-login mod-permissions"

for mod in $mods
do
     template="lib/$mod/template/DeploymentDescriptor.json"
     descriptor="lib/$mod/DeploymentDescriptor.json"

     cat $template > $descriptor

     sed -i "s/\${db_host}/${db_host}/g" $descriptor
     sed -i "s/\${db_port}/${db_port}/g" $descriptor
     sed -i "s/\${db_database}/${db_database}/g" $descriptor
     sed -i "s/\${db_username}/${db_username}/g" $descriptor
     sed -i "s/\${db_password}/${db_password}/g" $descriptor
done