var LiveLeaderboard = (function ($) {
  function leaderboard(options) {
    this.list = {};
  }

  leaderboard.prototype = {
    addToList: function (playerId, username, size) {
      if(playerId in this.list){
        this.list[playerId].username = username;
          this.list[playerId].size = size;
           if(this.list[playerId].dead === true){
//will reset longest time on leaderboard per a match rather than session
              longestTimeOnLead = 0;
              dead = false;
            }
      }
      else{
        this.list[playerId] = {id: playerId, username: username, size: size, 
        topLead: undefined, timeAddedToLead: undefined, longestTimeOnLead: 0, dead: false};
      }
    },

    playerDeath: function(playerId){
      var d1 = new Date();
      if(this.list[playerId].timeAddedToLead !== undefined){
        timeOnLead = d1.getTime() - this.list[playerId].timeAddedToLead;
        if(this.list[playerId].longestTimeOnLead < timeOnLead){
          this.list[playerId].longestTimeOnLead = timeOnLead;
        }
        this.list[playerId].timeAddedToLead = undefined;
      }
      dead = true;
    },

    removeFromList: function (playerId) {
//console.log(this.list);
      delete this.list[playerId];
    },

    update: function (playerId, username, size) {
      var array;
//add player to hash table
      this.addToList(playerId, username, size);

            /*****test data***/
//                this.addToList(100, "100", 100);
//                this.addToList(101, "101", 101);
//                this.addToList(102, "102", 102);
//               this.addToList(103, "103", 103);
//               this.addToList(104, "104", 104);
//                this.addToList(105, "105", 105);
//                this.addToList(106, "106", 106);
//              this.addToList(107, "107", 107);
//                this.addToList(108, "108", 108);
//              //  this.addToList(109, "109", 109);
              // this.addToList(10, "10", 10);
      array = sort(this.list);
      array = updateTop10(array);
      this.list = updateList(this.list, array);
      updateLeaderboard(array);
      console.log(this.list);

      return this.list[playerId];
    }
  };

    //simple bubble sort
  function sort(list) {
    keys = Object.keys(list);
    var swap;
    var listArray = [];
    
    for (var id in list) {
      listArray.push(list[id]);
    }
    for (var i = 0; i < listArray.length; i++) {
      for (var j = 0; j < listArray.length - 1; j++) {
        if (listArray[j].size < listArray[j + 1].size) {
          swap = listArray[j];
          listArray[j] = listArray[j + 1];
          listArray[j + 1] = swap;
        }
      }
    }
    return listArray;
  }

  function updateList(list, array){
    for(var i = 0; i < array.length; i++){
      list[array[i].id] = array[i];
    }
    return list;
  }

//clear/update orderedlist on html page
  function updateLeaderboard(array) {
  	var div = $("#liveLeaderboard ol");
    div.empty();
    for (var i = 0; i < 10; i++) {
      if (array[i] != undefined) {
        div.append('<li class="list">' + array[i].username + '</li>');
      }
    }
  }

//retrieve the top 10 names on the leaderboard
  function updateTop10(array, list) {
//get 11 spots, last name got kicked off
//0-10
    for (var i = 0; i < array.length && i < 11; i++) {
      checkLeadStatus(array[i], i);
    }
    return array;
  }

  function checkLeadStatus(player, newPos){
    var d1 = new Date();
    if(newPos === 10){
//if position is 10 that means no longer on leaderboard
//if timeAddedToLead is undefined then never added to leaderboard
    if(player.timeAddedToLead !== undefined){
      timeOnLead = d1.getTime() - player.timeAddedToLead;
      if(player.longestTimeOnLead < timeOnLead){
        player.longestTimeOnLead = timeOnLead;
      }
      player.timeAddedToLead = undefined;
      }
    }
    else{
//check if player moved in rank
//check if player was just added to leaderboard
      if(player.topLead === undefined || player.topLead > newPos){
        player.topLead = newPos;
      }
        if(player.timeAddedToLead === undefined){
         player.timeAddedToLead = d1.getTime();
        }
      }
      return player;
    }
  return leaderboard;
}(jQuery));