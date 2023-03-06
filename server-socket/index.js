var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);

var userList = [];

var playerBottom = "";
var playerTop = "";

app.get('/', function(req, res){
  res.send('');
});


http.listen(3000, function(){
  console.log('Listening on *:3000');
});


io.on('connection', function(clientSocket){
  console.log('a user connected');

   //verifica se é o primeiro player
   var message = "sem user"
   if (playerBottom == "") {
    playerBottom = clientSocket.id;
    io.emit("player", "playerBottom");
    message = "User playerBottom was connected.";
  } else if (playerTop == "") {
    playerTop = clientSocket.id;
    io.emit("player", "playerTop");
    message = "User playerTop was connected.";
  } 
  console.log(message);

  if (playerBottom != "" && playerTop != "") {
    console.log("GAME START!");
    io.emit("startGame");
  }
  
  

  clientSocket.on('disconnect', function(){
    console.log('user disconnected');
      
      if (playerBottom == clientSocket.id) {
        console.log('user desconectado: playerBottom');
        playerBottom = "";
      } else if (playerTop == clientSocket.id) {
        console.log('user desconectado: playerTop');
        playerTop = "";
      }
    
  });

  clientSocket.on('playerMove', function(clientNickname, originIndexRow, originIndexColumn, newIndexRow, newIndexColumn){
    io.emit('playerMove', clientNickname, originIndexRow, originIndexColumn, newIndexRow, newIndexColumn);
  });

  clientSocket.on("newTurn", function(clientNickname){
    io.emit("currentTurn", clientNickname)
  });

  clientSocket.on("surrender", function(clientNickname){

    if (clientNickname === "playerBottom") {
      io.to(playerBottom).emit("lose", "playerBottom")
      io.to(playerTop).emit("win", "playerTop")
    } else {
      io.to(playerBottom).emit("win", "playerBottom")
      io.to(playerTop).emit("lose", "playerTop")
    }
    
  });

  clientSocket.on('chatMessage', function(clientNickname, message){
    var currentDateTime = new Date().toLocaleString();
    io.emit('newChatMessage', clientNickname, message, currentDateTime);
  });

  clientSocket.on("ctUser", function() {
    var message = "sem user"
    //verifica se é o primeiro player
    if (userList[0] == null) {
      userList[0] = clientSocket.id;
      io.emit("player", "playerBottom");
      message = "User playerBottom was connected.";
    } else if (userList[1] == null) {
      userList[1] = clientSocket.id;
      io.emit("player", "playerTop");
      message = "User playerTop was connected.";
    } 

    if (userList.length = 2) {
      io.emit("startGame", userList);
    }

    
    console.log(message);

    //io.emit("uList", clientNickname);
});

});