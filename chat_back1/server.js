const express = require('express');
const admin = require('firebase-admin');
const http = require('http');
const { Server } = require('socket.io');
const cors = require('cors');
const serviceAccount = require('./firebase-config.json'); // Credenciales JSON

// 🔹 Configurar Firebase Admin SDK
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
});
const db = admin.firestore();
db.settings({ ignoreUndefinedProperties: true });
const messagesCollection = db.collection('messages');

// 🔹 Configurar Express y Socket.IO
const app = express();
const server = http.createServer(app);
const io = new Server(server, {
    cors: {
        origin: '*',
        methods: ['GET', 'POST'],
    },
});
app.use(cors());
app.use(express.json());

// 🔹 Endpoint para obtener mensajes desde Firestore
app.get('/messages', async (req, res) => {
    try {
        const snapshot = await messagesCollection.orderBy('timestamp').get();
        const messages = snapshot.docs.map(doc => doc.data());
        res.json(messages);
    } catch (error) {
        res.status(500).json({ error: 'Error al obtener mensajes' });
    }
});



// 🔹 WebSocket para manejar mensajes en tiempo real
io.on('connection', (socket) => {
    console.log('Usuario conectado');

    socket.on('sendMessage', async (data) => {
        try {
            const newMessage = {
                username: data.username,
                message: data.message,
                timestamp: new Date(),
            };
            await messagesCollection.add(newMessage);
            io.emit('receiveMessage', newMessage); // Enviar mensaje a todos
        } catch (error) {
            console.error('Error al guardar mensaje:', error);
        }
    });

    socket.on('disconnect', () => {
        console.log('Usuario desconectado');
    });
});

// 🔹 Iniciar el Servidor
server.listen(3000, () => {
    console.log('Servidor corriendo en http://localhost:3000');
});
