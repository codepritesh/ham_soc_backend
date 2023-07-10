const express = require('express');
const http = require('http');

const app = express();
const server = http.createServer(app);
const io = require('socket.io')(server, {
    cors: {
      origin: '*',
    }
  });

app.use(express.static('client/build'));

app.get('/', (req, res) => {
    console.log('app works')
  res.sendFile(__dirname + '/client/build/index.html');
});

io.on('connection', socket => {
  socket.on('offer', offer => {
    socket.broadcast.emit('offer', offer);
  });

  socket.on('answer', answer => {
    socket.broadcast.emit('answer', answer);
  });

  socket.on('iceCandidate', candidate => {
    console.log('iceCandidate1')
    socket.broadcast.emit('iceCandidate', candidate);
  });
});

const port = process.env.PORT || 5000;
server.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});
