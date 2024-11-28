# Usar la imagen base de Node.js (versión 14)
FROM node:14

# Definir el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiar los archivos necesarios para construir la aplicación
COPY package.json package-lock.json ./

# Instalar dependencias
RUN npm install

# Crear la carpeta 'public' dentro del contenedor
RUN mkdir -p public

# Copiar los archivos del servidor y los recursos estáticos
COPY server.js ./
COPY public ./public

# Exponer el puerto 3000 para acceder a la aplicación
EXPOSE 3000

# Comando por defecto para iniciar el servidor
CMD ["node", "server.js"]
