
# 🌐 Guía para Configurar Nginx como Balanceador de Carga con SSL en Docker

Esta guía proporciona los pasos necesarios para configurar Nginx como un balanceador de carga con soporte para SSL, utilizando Docker y Docker Compose. Este enfoque garantiza una distribución eficiente del tráfico entre varios servidores backend mientras se protege la comunicación con SSL. 🚀

---

## 📋 Tabla de Contenidos
- [📖 Introducción](#📖-introducción)
- [✅ Requisitos Previos](#✅-requisitos-previos)
- [💻 Comandos Básicos de Nginx](#💻-comandos-básicos-de-nginx)
- [⚙️ Configuración del Balanceador de Carga](#⚙️-configuración-del-balanceador-de-carga)
  - [🔗 Definir Servidores Backend](#🔗-definir-servidores-backend)
  - [🔒 Habilitar SSL en Nginx](#🔒-habilitar-ssl-en-nginx)
- [🐳 Docker Setup](#🐳-docker-setup)
  - [📝 Dockerfile](#📝-dockerfile)
  - [🗂️ Docker Compose](#🗂️-docker-compose)
- [🔍 Verificación y Recarga](#🔍-verificación-y-recarga)
- [🎯 Conclusión](#🎯-conclusión)

---

## 📖 Introducción

Nginx es un servidor web versátil que puede actuar como un balanceador de carga eficiente. Con esta configuración, puedes distribuir el tráfico entre varios servidores backend y asegurar las conexiones con SSL, protegiendo así los datos de tus usuarios. 🔐

---

## ✅ Requisitos Previos

Antes de comenzar, asegúrate de tener:

1. **Docker** y **Docker Compose** instalados en tu servidor.
2. Un servidor con **Nginx** configurado como balanceador de carga.
3. Certificados SSL válidos o autofirmados para pruebas.
4. Acceso administrativo para modificar configuraciones y reiniciar Nginx.

---

## 💻 Comandos Básicos de Nginx

Aquí están algunos comandos clave para administrar Nginx:

**Iniciar Nginx**  
```bash
nginx
```

**Reiniciar Nginx**  
```bash
nginx -s reload
```

**Detener Nginx**  
```bash
nginx -s stop
```

Ver logs de acceso en tiempo real:  
```bash
tail -f /usr/local/var/log/nginx/access.log
```

---

## ⚙️ Configuración del Balanceador de Carga

### 🔗 Definir Servidores Backend

Edita el archivo `nginx.conf` para definir los servidores backend. Ejemplo básico:

```nginx
http {
    upstream backend_servers {
        server 127.0.0.1:8080;
        server 127.0.0.1:8081;
    }

    server {
        listen 80;

        location / {
            proxy_pass http://backend_servers;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }
    }
}
```

**💡 Explicación**:

- **upstream backend_servers**: Lista de servidores backend que manejarán el tráfico. 📡
- **proxy_pass**: Redirige solicitudes al grupo de servidores backend. 🔀
- **proxy_set_header**: Envía encabezados como la IP y el host del cliente. 📥

### 🔒 Habilitar SSL en Nginx

Agrega soporte para SSL editando `nginx.conf`:

```nginx
server {
    listen 443 ssl;
    ssl_certificate /path/to/nginx-certs/nginx-selfsigned.crt;
    ssl_certificate_key /path/to/nginx-certs/nginx-selfsigned.key;

    location / {
        proxy_pass http://backend_servers;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

**🔐 Explicación**:

- **ssl_certificate**: Ruta al certificado SSL. 📂
- **ssl_certificate_key**: Ruta al archivo de clave privada. 🗝️

---

## 🐳 Docker Setup

### Comandos para Levantar las Instancias

Para ejecutar la configuración de Nginx y los servidores backend en contenedores Docker, puedes usar los siguientes comandos:

### 1. **Modo Detached** (sin salida de consola)

Este comando construirá las imágenes necesarias y levantará los contenedores en segundo plano (sin mostrar los logs en la terminal):

```bash
docker-compose up --build -d
```

- `--build`: Asegura que Docker reconstruya las imágenes si hay cambios en los archivos de configuración o el Dockerfile.
- `-d`: Ejecuta los contenedores en modo detached (en segundo plano).

### 2. **Modo Debug** (con salida en consola)

Si deseas ver los logs de los contenedores en tiempo real y ejecutar Docker Compose sin el flag `-d` para modo debug, usa el siguiente comando:

```bash
docker-compose up --build
```

Este comando construye las imágenes y ejecuta los contenedores en primer plano, mostrando los logs en la terminal. Puedes detener la ejecución con `Ctrl + C`.

### 3. **Levantar solo Nginx y Servidores Backend**

Si solo deseas levantar el servicio de Nginx y los servidores backend sin construir las imágenes nuevamente, puedes ejecutar:

```bash
docker-compose up -d
```

Este comando levanta los contenedores de los servicios definidos en el archivo `docker-compose.yml` sin reconstruir las imágenes, en caso de que ya hayan sido construidas previamente.

### 4. **Verificar el Estado de los Contenedores**

Para verificar que los contenedores están corriendo correctamente, usa:

```bash
docker-compose ps
```

Este comando te mostrará una lista de los contenedores activos con su estado actual.

### 5. **Detener los Contenedores**

Para detener todos los contenedores sin eliminarlos, usa:

```bash
docker-compose stop
```

Si quieres detener y eliminar los contenedores, redes y volúmenes, utiliza:

```bash
docker-compose down
```

---

## 🔍 Verificación y Recarga

Para verificar la configuración de Nginx y recargar los cambios, sigue estos pasos:

1. **Verificar la configuración de Nginx**:

```bash
nginx -t
```

2. **Recargar la configuración de Nginx**:

```bash
docker-compose exec nginx nginx -s reload
```

---

## 🎯 Conclusión

Con esta configuración, tendrás Nginx actuando como un balanceador de carga con soporte SSL, todo dentro de un entorno Docker. Ahora puedes iniciar los contenedores con `docker-compose up --build -d` para un entorno sin debug, o sin `-d` para ejecutarlo en modo debug. Esto te permitirá distribuir el tráfico de manera eficiente entre los servidores backend y proteger las conexiones con SSL.
