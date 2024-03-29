#!/bin/bash

### 准备环境
/okapi/init-env.sh
sleep 5;

### 启动 okapi
java -jar \
 -Dstorage=postgres \
 -Dpostgres_host=${OKAPI_DB_HOST-"postgres"} \
 -Dpostgres_port=${OKAPI_DB_PORT-"5432"} \
 -Dpostgres_database=${OKAPI_DB_DATABASE-"okapi"} \
 -Dpostgres_username=${OKAPI_DB_USERNAME-"okapi"} \
 -Dpostgres_password=${OKAPI_DB_PASSWORD-"okapi25"} \
 -Dpostgres_db_init=0 \
 /okapi/okapi-core-fat.jar dev > /okapi/logs/okapi.log &

while ! echo exit | nc localhost 9130; do
	sleep 1;
done

mods="mod-users mod-login mod-permissions"

for mod in $mods
do
     curl -X POST -s \
          -H "Content-type:application/json" \
          -d @/okapi/lib/$mod/ModuleDescriptor.json \
          http://localhost:9130/_/proxy/modules
     curl -X POST -s \
          -H "Content-type:application/json" \
          -d @/okapi/lib/$mod/DeploymentDescriptor.json \
          http://localhost:9130/_/discovery/modules
done

### 租客初始化
curl -X POST -s \
     -H "Content-type:application/json" \
     -d @/okapi/init.d/tenant.json \
     http://localhost:9130/_/proxy/tenants

### 租客授权
for mod in $mods
do
     id=`cat /okapi/lib/$mod/id`
     curl -X POST -s \
          -H "Content-type:application/json" \
          -d "{\"id\":\"$id\"}" \
          http://localhost:9130/_/proxy/tenants/testlib/modules
done

### 初始化管理员
curl -X POST -s \
     -H "Content-type:application/json" \
     -H "X-Okapi-Tenant:testlib" \
     -d @/okapi/init.d/users.json \
     http://localhost:9130/users

curl -X POST -s \
     -H "Content-type:application/json" \
     -H "X-Okapi-Tenant:testlib" \
     -d @/okapi/init.d/credential.json \
     http://localhost:9130/authn/credentials

curl -X POST -s \
     -H "Content-type:application/json" \
     -H "X-Okapi-Tenant:testlib" \
     -d @/okapi/init.d/permissions.json \
     http://localhost:9130/perms/users

### 增加认证
curl -X POST -s \
     -H "Content-type:application/json" \
     -d @/okapi/lib/mod-authtoken/ModuleDescriptor.json \
     http://localhost:9130/_/proxy/modules
curl -X POST -s \
     -H "Content-type:application/json" \
     -d @/okapi/lib/mod-authtoken/DeploymentDescriptor.json \
     http://localhost:9130/_/discovery/modules
id=`cat /okapi/lib/mod-authtoken/id`
curl -X POST -s \
     -H "Content-type:application/json" \
     -d "{\"id\":\"$id\"}" \
     http://localhost:9130/_/proxy/tenants/testlib/modules

### 环境初始化完成

time=$(date "+%Y%m%d-%H%M%S")
echo "${time}"

while true; do
	sleep 1000;
done
