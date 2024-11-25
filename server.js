// Importar módulos necesarios
const express = require('express');
const path = require('path');
const app = express();

const testApp = process.env.APP_NAME

// Definir el puerto
const PORT = 3000;

// Middleware para servir archivos estáticos desde el directorio "public"
app.use(express.static(path.join(__dirname, 'public')));

// Ruta principal
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
    console.log("Request served by ${testApp}")
});

// Iniciar el servidor
app.listen(PORT, () => {
    console.log(`Servidor escuchando en http://localhost:${PORT}`);
});