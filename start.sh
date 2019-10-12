#!/bin/bash

# 等待数据库启动
sleep 5;

# 部署 okapi
java -jar \
 -Dstorage=postgres \
 -Dpostgres_host=postgres \
 -Dpostgres_db_init=0 \
 /app/repo/okapi/okapi-core-fat.jar dev > okapi.log &

while ! echo exit | nc localhost 9130; do
	sleep 1;
done



# 部署依赖的 modules
required_mods=$(cat repo/required/mods)

for mod in $required_mods
do
     curl -X POST -s \
          -H "Content-type:application/json" \
          -d @/app/repo/required/$mod/ModuleDescriptor.json \
          http://localhost:9130/_/proxy/modules

     curl -X POST -s \
          -H "Content-type:application/json" \
          -d @/app/repo/required/$mod/DeploymentDescriptor.json \
          http://localhost:9130/_/discovery/modules
done

 
# 初始化 tenant

curl -X POST -s \
     -H "Content-type:application/json" \
     -d @/app/init.d/tenant.json \
     http://localhost:9130/_/proxy/tenants

for mod in $required_mods
do
     id=`cat repo/required/$mod/id`
     curl -X POST -s \
          -H "Content-type:application/json" \
          -d "{\"id\":\"$id\"}" \
          http://localhost:9130/_/proxy/tenants/testlib/modules
done

# 初始化 admin user

curl -X POST -s \
     -H "Content-type:application/json" \
     -H "X-Okapi-Tenant:testlib" \
     -d @/app/init.d/users.json \
     http://localhost:9130/users

curl -X POST -s \
     -H "Content-type:application/json" \
     -H "X-Okapi-Tenant:testlib" \
     -d @/app/init.d/credential.json \
     http://localhost:9130/authn/credentials

curl -X POST -s \
     -H "Content-type:application/json" \
     -H "X-Okapi-Tenant:testlib" \
     -d @/app/init.d/permissions.json \
     http://localhost:9130/perms/users


# 部署 mod-authtoken

curl -X POST -s \
     -H "Content-type:application/json" \
     -d @/app/repo/mod-authtoken/ModuleDescriptor.json \
     http://localhost:9130/_/proxy/modules

curl -X POST -s \
     -H "Content-type:application/json" \
     -d @/app/repo/mod-authtoken/DeploymentDescriptor.json \
     http://localhost:9130/_/discovery/modules

id=`cat repo/mod-authtoken/id`
curl -X POST -s \
     -H "Content-type:application/json" \
     -d "{\"id\":\"$id\"}" \
     http://localhost:9130/_/proxy/tenants/testlib/modules

##
# 基础环境 完成部署
##

# 部署 非必备modules
other_mods=$(cat repo/other/mods)

for mod in $other_mods
do
     curl -X POST -s \
          -H "Content-type:application/json" \
          -d @/app/repo/other/$mod/ModuleDescriptor.json \
          http://localhost:9130/_/proxy/modules

     curl -X POST -s \
          -H "Content-type:application/json" \
          -d @/app/repo/other/$mod/DeploymentDescriptor.json \
          http://localhost:9130/_/discovery/modules
done

for mod in $other_mods
do
     id=`cat repo/other/$mod/id`
     curl -X POST -s \
          -H "Content-type:application/json" \
          -d "{\"id\":\"$id\"}" \
          http://localhost:9130/_/proxy/tenants/testlib/modules
done

##
# 非基础环境 完成部署
##


while true; do
	sleep 1000;
done