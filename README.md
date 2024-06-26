# Configuraciones

1. Es necesario clonar los repositorios [redelockerservidorweb](https://bitbucket.org/prontometalingeniera/redelockerservidorweb) y [rl-web-vue](https://bitbucket.org/prontometalingeniera/rl-web-vue).

2. En ambos repositorios deben tener configurados/generados sus respectivos `.env`.

3. En el `.env` de `redelockerservidorweb`, asegúrate de colocar:

    ```bash
    DB_HOST=mysql # Nombre del servicio, por defecto 'mysql'.
    DB_PORT=3306 # Puerto por defecto.
    DB_DATABASE=redelockerservidorweb
    DB_USERNAME=develop # Se puede cambiar siempre y cuando no sea "root", esto solo aplica para el primer build.
    DB_PASSWORD=develop # Definir, tratar de no dejar vacío.
    ```

    Adicional sera necesario quitar las siguiente variables, para evitar error `Illuminate\Container\Container::bind(): Argument #2 ($concrete) must be of type Closure|string|null`:
    
    ```bash
    SERVICE_CLIENT=
    SERVICE_PASSWORD=
    SERVICE_USERNAME=
    SERVICE_SERVICE=
    CONTACT_CLIENT=
    ```

4. En el `.env` de `rl-web-vue`, asegúrate de colocar:

    ```bash
    API_URL=http://laravel.app.localhost/api/v2/
    ```

5. En el directorio `redelockerservidorweb`, es necesario correr el `composer install` al menos una vez. Esto lo necesitamos para que se instale la dependencia 'sail' necesaria para este proyecto.

   5.2. Si no se tiene instalado PHP ni Composer, se puede usar:

    ```bash

    #Paso 1. Desde la ruta `rededocker/composer`
    docker build -t mycomposer:latest .

    #Paso 2. Desde la ruta del proyecto laravel `redelockerservidorweb`
    docker run --rm \
        -u "$(id -u):$(id -g)" \
        -v "$(pwd):/var/www/html" \
        -v "composer_cache:/tmp" \
        -e COMPOSER_CACHE_DIR=/tmp \
        -w /var/www/html \
        mycomposer:latest \
        composer install
    ```
    *nota:* `mycomposer:latest` es una imagen custom de php 7.4 con todas las liberias necesarias por el proyecto para ejecutar un composer install sin problemas de compatibilidad por liberias.
   
   Este ejecuta el `composer install` desde un contenedor transitorio (se borra luego de su ejecución), la idea es que este genere la carpeta `vendor` con todas sus librerías (incluida `sail`).
   
   PD: Si tienes algún problema puedes reemplzar la imagen custom `mycomposer:latest` con `laravelsail/phpXX-composer`, puedes usar otra versión, como `74, 80, 81, 82, 83`, propias de laravel.

6. Clonar rededocker, entrar al directorio. (Lo ideal sería que este a la altura de los repositorios `redelockerservidorweb` y `rl-web-vue`).

7. En el directorio `rededocker`, ubicar el archivo `.env.example` y crear un `.env` partiendo de este. `cp .env.example .env`, en las variables de entorno `LARAVEL_PATH` y `NUXT_PATH`, debes actualizarlas como:

    ```bash
    LARAVEL_PATH=<tu-path-absoluto>/redelockerservidorweb
    NUXT_PATH=<tu-path-absoluto>/rl-web-vue
    ```

   Las demás variables no es necesario cambiarlas, en tal caso se haga, solo la `APP_SERVICE`, es relevante en el sentido de que si se cambia se debe cambiar también en el `docker-compose.yml`, puesto que es el nombre del servicio de Laravel.

8. Dar permisos al archivo de ejecución `run.sh`.

    ```bash
    chmod +x ./run.sh
    ```

9. Ejecutar: `./run.sh build --no-cache`.

   9.1. Ahora ejecutar `./run.sh up`.

   9.2. Si se desea mantener el servicio en segundo plano `./run.sh up -d`. 

   9.3. Para tener y borrar volumenes, `./run.sh dowm -v`

   9.4 Detener y borrar todas las imagenes construidas localmente `./run.sh down --rmi=local`
10. Ejecutar comandos de artisan `./run.sh artisan` deberia mostrar todos los comandos disponibles.
      
      10.1.  `./run.sh artisan key:generate`

      10.2. `./run.sh artisan migrate --seed` *nota:* Si se obteniene un error referente al schema dump o similar relacionado a permisos del usuario de mysql. Recomiendo modificar temporalmente en el archivo .env del repositorio [redelockerservidorweb] (Solo para la ejecucion del comando en particular) la variable de entorno `DB_USERNAME` y darle el valor `root`, quedando: ```DB_USERNAME=root``` todas las demas variables quedan igual.  

# Uso

1. Una vez se tenga todo configurado (`./run.sh up -d`), y si no lo has hecho aun, debes generar una key para laravel y correr migraciones. Todo esto se hace desde el directorio `rededocker`

```bash
./run.sh artisan key:generate
./run.sh artisan migrate --seed
```
2. 
* Visitar la url de la web [app.localhost](http://app.localhost)
* Visitar la url del admin [laravel.app.localhost](http://laravel.app.localhost)
* El api quedaria como [laravel.app.localhost/api/v2](http://laravel.app.localhost/api/v2/)

*nota:* 
- Solo se esta tomando en cuenta la /v2 del api, si se quiere cambiar esto, es necesario modificar el servicio de laravel en el label de traefik.
  - Si `app.localhost` no se detecta en el navegador, sera necesario registrarlo en el archivo hosts de tu SO. La ubicacion del archivo depende del sistema operativo, para el caso de Windows esta en `C:\Windows\System32\drivers\etc\hosts`, en Linux seria `/etc/hosts`
    - Colocar siguiendo este formato: 
    ```
        127.0.0.1      app.localhost
        127.0.0.1      example.localhost
        ...
    ```