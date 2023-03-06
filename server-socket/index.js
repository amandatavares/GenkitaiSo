var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);

var userList = [];

var playerBottom = null;
var playerTop = null;

app.get('/', function(req, res){
  res.send('');
});


http.listen(3000, function(){
  console.log('Listening on port: 3000');
});


io.on('connection', function(clientSocket){
  console.log('a user connected');

   //if both players connect, starts the match
   var message = "no user"
   if (playerBottom == null) {
    playerBottom = clientSocket.id;
    io.emit("player", "playerBottom");
    message = "User playerBottom was connected.";
  } else if (playerTop == null) {
    playerTop = clientSocket.id;
    io.emit("player", "playerTop");
    message = "User playerTop was connected.";
  }
  console.log(message);

  if (playerBottom != null && playerTop != null) {
    console.log("GAME START!");
    io.emit("startGame");
  }
  
    // if user disconnect, call it
  clientSocket.on('disconnect', function(){
    console.log('user disconnected');
      
      if (playerBottom == clientSocket.id) {
        console.log('user disconnected: playerBottom');
        playerBottom = null;
      } else if (playerTop == clientSocket.id) {
        console.log('user disconnected: playerTop');
        playerTop = null;
      }
    
  });

    // receive and send all pieces movements, how moved, from and to where
  clientSocket.on('playerMove', function(clientNickname, originIndexRow, originIndexColumn, newIndexRow, newIndexColumn){
    io.emit('playerMove', clientNickname, originIndexRow, originIndexColumn, newIndexRow, newIndexColumn);
  });

    
    // on receive a new tur, define current turn for the player and emit
  clientSocket.on("newTurn", function(clientNickname){
    io.emit("currentTurn", clientNickname)
  });

    // if the player give up, define winner and loser and the match ends
  clientSocket.on("giveUp", function(clientNickname){

    if (clientNickname === "playerBottom") {
      io.to(playerBottom).emit("lose", "playerBottom")
      io.to(playerTop).emit("win", "playerTop")
    } else {
      io.to(playerBottom).emit("win", "playerBottom")
      io.to(playerTop).emit("lose", "playerTop")
    }
    playerBottom = null;
    playerTop = null;
  });

    // on every message, get name and message, add the time and send
  clientSocket.on('chatMessage', function(clientNickname, message){
    var currentDateTime = new Date().toLocaleString();
    io.emit('newChatMessage', clientNickname, message, currentDateTime);
  });

});
