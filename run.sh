#!/bin/bash
echo "Inicio de script."

SELF_PATH=$(pwd)

if [ ! -f "$SELF_PATH/.env" ]; then
    echo "Archivo (self) .env no encontrado!"
    exit 1
fi

if [ ! -f "$SELF_PATH/docker-compose.yml" ]; then
    echo "Archivo (self) docker-compose.yml no encontrado!"
    exit 1
fi

set -a
source .env
source "${LARAVEL_PATH}/.env"
set +a

LARAVEL_PATH=$(realpath $LARAVEL_PATH)
NUXT_PATH=$(realpath $NUXT_PATH)

if [ ! -d "$LARAVEL_PATH" ]; then
    echo "Directorio del proyecto Laravel no encontrado!"
    exit 1
fi

if [ ! -f "$LARAVEL_PATH/vendor/bin/sail" ]; then
    echo "Archivo sail no encontrado en el directorio vendor/bin!"
    exit 1
fi

cp ./front/Dockerfile $NUXT_PATH

if [ $# -eq 0 ]; then
    echo "Por favor, proporciona un argumento: up o down"
    exit 1
fi

cat ${LARAVEL_PATH}/.env ${SELF_PATH}/.env > merged.env

if [ "$1" == "artisan" ]; then
    shift 1
    CMD="${LARAVEL_PATH}/vendor/bin/sail artisan $@"
else
    CMD="${LARAVEL_PATH}/vendor/bin/sail --file ${SELF_PATH}/docker-compose.yml --env-file merged.env $@"
fi

$CMD

if [ -f "$NUXT_PATH/Dockerfile" ]; then
    rm $NUXT_PATH/Dockerfile
fi

echo "Fin de script."
exit 0
