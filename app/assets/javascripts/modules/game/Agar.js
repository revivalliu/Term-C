var Agar = (function ($, Pusher, Phaser, Messenger, MPSMeter, LiveLeaderboard) {
    // Enable pusher logging - don't include this in production
    //Pusher.log = function(message) {
    //    if (window.console && window.console.log) {
    //        window.console.log(message);
    //    }
    //};

    // Open connection to Pusher
    //var primaryKey = 'e415bc2547e9d73f06a2';
    var alternateKey = '758478f53f799323df26';
    var pusher = new Pusher(alternateKey, {
        encrypted: true
    });

    var options = {
        viewport: '#viewport',
        server: {
            queue: "/messages.json"
        },
        game: {
            width: 2400,
            height: 2400,
            renderer: Phaser.AUTO,
            foodCount: 20,
            foodScale: 0.1,
            playerScale: 0.2,
            assets: {
                images: [
                    // Rendered in the order they appear below
                    {name: 'player', path: '/assets/images/red-circle.png'},
                    {name: 'food', path: '/assets/images/orange-circle.png'}
                ]
            },
            physics: {
                system: Phaser.ARCADE,
                movement: {
                    speed: 160,
                    pointer: Phaser.Input.activePointer,
                    maxTime: 0
                }
            },
            messageRate: 2    // maximum number of messages to send per second
        }
    };

    var protoGame = new Messenger(options);
    var liveLeaderboard = new LiveLeaderboard();

    var gameFunctions = {
        preload: preload,
        create: create,
        update: update,
        render: render
    };

    var game;
    var player, food, foods, mouse, time;
    const SECOND = 1000;
    var msgFreq = SECOND / options.game.messageRate;
    var playerId = undefined;
    var playerVelocity = options.game.physics.movement.speed;
    var players; // other players
    var endOfMatchFlag = false;

    var opts = {
         message : 'Hey~ have fun in Agar.io! Can you do better? Come and play! ',
         name : 'Term-C Dev Test User',
         link : 'https://intense-anchorage-6860.herokuapp.com/',
         description : 'Term-C Final Project for CSC 746',
         picture : 'https://i.ytimg.com/vi/qR7CZ4JZjXA/maxresdefault.jpg'
    };

    $(document).ready(function () {

        // Subscribe to the test channel
        var pusherChannel = $('#channel').data('channel');
        console.log("Subscribed to channel: " + pusherChannel);
        var channel = pusher.subscribe(pusherChannel);

        var leaderboard = new LiveLeaderboard();

        // Initialize message frequency meter
        var mpsMeter = new MPSMeter({
            msgRecvSelector: '#msg-count',
            avgLatencySelector: '#avg-latency'
        });

        // Listen for events on the channel
        channel.bind('my_event', function (data) {
            // console.log("Message from pusher: ");
            // console.log(data);
            mpsMeter.update();
            protoGame.addServerMessage(data);
        });

        playerId = $('#userId').data('id');
        game = new Phaser.Game(options.game.width, options.game.height, options.game.renderer, '', gameFunctions);

        endGame();
    });

    function endGame() {
        var m = newMessage();
        m.playerId = playerId;
        m.endGame = 1;
        protoGame.addInput(m, true);
    }

    function preload() {
        $(options.game.assets.images).each(function (i, asset) {
            game.load.image(asset.name, asset.path)
        });
    }

    function create() {
        //this.game.stage.backgroundColor = '#00FF00';
        time = new Date().getTime();

        //  We're going to be using physics, so enable the Arcade Physics system
        game.physics.startSystem(options.game.physics);

        game.world.setBounds(0, 0, options.game.width, options.game.height);

        players = game.add.physicsGroup();
        players.enableBody = true;  // Enable physics for all group members

        foods = game.add.physicsGroup();
        foods.enableBody = true;

        // End of match modal button handlers
        newMatchClickHandler();
    }

    function spawnPlayer() {
        var createCellOptions = {
            name: playerId,
            assetName: 'player',
            x: randomXPosition(game.world.width),
            y: randomYPosition(game.world.height),
            size: 20,
            type: 'primary'
        };

        // camera follow the player when it's primary - done
        if (createCellOptions.type == 'primary') {
            player = createPlayer(createCellOptions);
            players.add(player);

            game.camera.setSize(game.world.width / 4, game.world.height / 4);
            game.camera.follow(player);
            game.physics.enable(player);
        } else {
            player = createPlayer(createCellOptions);
            players.add(player);
        }

        mouse = new Phaser.Mouse(game);
        mouse.start();
    }

    function createPlayer(createCellOptions) {
        var newPlayer = createCell(createCellOptions, options.game.playerScale);
        newPlayer.body.collideWorldBounds = true;
        return newPlayer;
    }

    function createCell(createCellOptions, scale) {
        // FOR TESTING, should come from server
        var newCell = game.add.sprite(createCellOptions.x, createCellOptions.y, createCellOptions.assetName);
        newCell.name = createCellOptions.name;
        // Scale the cell
        newCell.scale.setTo(scale, scale);
        game.physics.arcade.enable(newCell);
        newCell.body.allowGravity = false;
        return newCell;
    }

    function createFood(message) {
        for (var i = 0; i < message.foods.length; i++) {
            var createCellOptions = {
                name: message.foods[i].id,
                assetName: 'food',
                x: message.foods[i].x,
                y: message.foods[i].y,
                size: message.foods[i].size,
                type: 'food'
            };

            var name = message.foods[i].id;
            var match = foods.iterate('name', name, Phaser.Group.RETURN_CHILD);

            if (match == null) {
                newFood = createCell(createCellOptions, options.game.foodScale);
                newFood.body.immovable = true;
                foods.add(newFood);
            }
        }
    }

    function removeFood(message) {
        if (message.remove_foods != undefined) {
            for (var i = 0; i < message.remove_foods.length; i++) {
                var name = message.remove_foods[i];
                var match = foods.iterate('name', name, Phaser.Group.RETURN_CHILD);

                if (match != null) {
                    foods.removeChild(match);
                }
            }
        }
    }

    function randomXPosition(worldWidth) {
        return Math.random() * worldWidth;
    }

    function randomYPosition(worldHeight) {
        return Math.random() * worldHeight;
    }

    function debug(i, x) {
        if ((i % 100) == 0) {
            console.log(x);
        }
    }

    function newMessage() {
        return {
            playerId: playerId,
            position: player == undefined ? {x: 0, y: 0} : player.body.position,
            collisions: []
        };
    }

    var i = 0;

    function update() {
        // process messages from the server
        handleGameServerMessages();

        if (player == undefined) {
            if (foods.length > 0) {
                spawnPlayer();
            }
        } else {
            game.physics.arcade.moveToPointer(player, playerVelocity);
        }

        if (playerId != undefined) {
            var message = newMessage();

            game.physics.arcade.collide(player, foods, function (_player, _food) {
                message.collisions.push([
                    {type: 'player', object: reduce(_player)},
                    {type: 'food', object: reduce(_food)}
                ]);
                _food.kill();
                //foods.removeChild(_food);
            }, null, this);

            var prioritize = false;
            game.physics.arcade.collide(player, players, function (_player, _other_player) {
                var msg = [
                    {type: 'player', object: reduce(_player)},
                    {type: 'player', object: reduce(_other_player)}
                ];
                if (!collisionMessageExistsInMessageQueue(msg)) {
                    prioritize = true;
                    message.collisions.push(msg);
                }
                //players.removeChild(_other_player);
            }, null, this);

            if (canSendMessage() || message.collisions.length > 0) {
                protoGame.addInput(message, prioritize);
            }
        }
        i++;
    }

    function collisionMessageExistsInMessageQueue(collisionMessage) {
        var messageQueue = protoGame.getInput();
        for (var i = 0; i < messageQueue.length; i++) {
            var queueMessage = messageQueue[i];
            for (var j = 0; j < queueMessage.collisions.length; j++) {
                if (queueMessage.collisions[j][0].object.id == collisionMessage[0].object.id
                    && queueMessage.collisions[j][1].object.id == collisionMessage[1].object.id
                    && queueMessage.collisions[j][0].type == collisionMessage[0].type
                    && queueMessage.collisions[j][1].type == collisionMessage[1].type
                ) {
                    return true;
                }
            }
        }
        return false;
    }


    function handleGameServerMessages() {
        var gameServerMessages = protoGame.getServerMessages();
        // console.log("Game server messages fetched from Messanger:");
        // console.log(gameServerMessages);

        for (var i = 0; i < gameServerMessages.length; i++) {
            var message = gameServerMessages[i];

            /***************** LIVELEADERBOARD CODE *****************************************/
            liveLeaderboard.update(message.player.id, message.username, message.player.size);
            /***************** LIVELEADERBOARD CODE *****************************************/

            checkEndOfMatch(message);

            if (isThisPlayer(message)) {
                handleThisPlayerMessage(message);
                createFood(message);
                removeFood(message);
            } else {
                handleOtherPlayerMessage(message);
            }
            //console.log(isThisPlayer(m));
        }

    }

    function isThisPlayer(message) {
        return playerId == message.playerId;
    }

    function handleThisPlayerMessage(m) {
        if (player != undefined) {
            scalePlayer(player, m);
            changePlayerVelocity(player, m);
            //updateLeaderboard(m);
        }
    }

    function scalePlayer(sprite, message) {
        //console.log("Scale");
        //console.log(sprite);
        //console.log(message);
        //console.log();
        var newScale = options.game.playerScale + message.player.size / 100;
        sprite.scale.setTo(newScale, newScale);
    }

    function changePlayerVelocity(sprite, message) {
        if (playerVelocity > 4) {
            playerVelocity = options.game.physics.movement.speed - message.player.size;
        }
    }

    function checkEndOfMatch(m) {
        for (var i = 0; i < m.end_match.length; i++) {
            var end_match = m.end_match[i];
            var match = players.iterate('name', end_match.id, Phaser.Group.RETURN_CHILD);
            if (match != null) {
                match.kill();
            }
            liveLeaderboard.removeFromList(playerId);
            if (end_match.id == playerId && end_match.data != undefined) {

                openEndOfMatchModal(end_match.data);
            }
        }
    }

    function openEndOfMatchModal(endOfMatchData) {
        if(endOfMatchFlag == true) return;  // prevent multiple updates of the end of match modal - hack

        var data = JSON.parse(endOfMatchData);
        console.log("END OF MATCH DATA:");
        console.log(data);
        var atLeastOneField = false;
        for (attribute in data) {
            console.log(attribute);
            console.log(data[attribute]);
            var modalField = $('#' + attribute);
            if (modalField.length > 0) {
                atLeastOneField = true;
                modalField.text(data[attribute]);
                opts.message += attribute + " : " + data[attribute] + " ";
            }
        }

        if (atLeastOneField) {
            endOfMatchFlag = true;
            $('#matchResultModal').addClass('show');
            $('#fbShare').click(function(){
              console.log("share your score on Facebook.");
              FB.login(function(response){
                if (response.authResponse){
                  console.log(response.authResponse.accessToken);

                  /* SHARE STYLE POST TO WALL - START */
                  FB.api('/me/feed', 'post', opts, function(response){
                   if (!response || response.error){
                     console.log(response.error);
                     alert('Posting error occured');
                   }else{
                     console.log('Success - Post ID: ' + response.id);
                   }
                  });
                  /* SHARE STYLE POST TO WALL - END */

                }else{
                  console.log('Not logged in');
                }
              }, { scope : 'publish_stream, user_photos, photo_upload, publish_actions' });
            });
        }
    }

    function newMatchClickHandler() {
        attachClickHandler('new_match', function () {
            player = undefined;
            $('#matchResultModal').removeClass('show');
            endOfMatchFlag = false;
        });
    }

    function attachClickHandler(id, f) {
        $('#' + id).click(f);
    }

    function handleOtherPlayerMessage(message) {
        var otherPlayer = players.iterate('name', message.playerId, Phaser.Group.RETURN_CHILD);
        if (otherPlayer == null) {
            var createCellOptions = {
                name: message.playerId,
                assetName: 'player',
                x: message.position.x,
                y: message.position.y,
                size: 20,
                type: 'otherPlayer'
            };
            players.add(createPlayer(createCellOptions));
        } else {
            otherPlayer.x = message.position.x;
            otherPlayer.y = message.position.y;
            scalePlayer(otherPlayer, message);
        }
    }

    // For converting Phaser objects to a json representaton with a small footprint
    function reduce(object) {
        return {
            id: object.name,
            position: object.position
        };
        return object.position;
    }

    function canSendMessage() {
        var t = new Date().getTime();
        if ((t - time) > msgFreq) {
            time = t;
            return true;
        } else {
            return false;
        }
    }

    function render() {
        if (player != undefined) {
            //game.debug.cameraInfo(game.camera, 32, 32);
            //game.debug.spriteCoords(player, 32, 580);
        }
    }

    protoGame.update();

}(jQuery, Pusher, Phaser, Messenger, MPSMeter, LiveLeaderboard));