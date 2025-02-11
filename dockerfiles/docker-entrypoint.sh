#!/bin/bash

command=${1}
otherArgs=${@: 2}

if [ -z $DB_URL ]; then
    echo "Required env variable DB_URL should be set to reach pgsql backend"
    exit 1
fi

echo "Executing ${command} command"

case $command in
"install")
    psql -d $DB_URL -f ./db/00_init.sql
    ;;
"init")
    npm run project:update $otherArgs
    ./db/09_project_update_tmp.sh $otherArgs
    npm run features:update $otherArgs
    ./db/21_features_update_tmp.sh init
    ;;
"run")
    npm run project:update $otherArgs
    npm run start
    ;;
"update_project")
    npm run project:update $otherArgs
    ./db/09_project_update_tmp.sh $otherArgs
    ;;
"update_features")
    npm run features:update $otherArgs
    ./db/21_features_update_tmp.sh $otherArgs
    ;;
"uninstall")
    npm run features:update $otherArgs

    psql -d $DB_URL -f ./db/91_project_uninstall_tmp.sql
    psql -d $DB_URL -f ./db/90_uninstall.sql
    ;;
*)
    echo "Command $command unknown"
    exit 2
    ;;
esac
