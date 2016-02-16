var Messenger = (function ($) {
    function gameCore(options) {

        this.game = {
            id: rand(),
            input: [],
            serverMessages: [],
            options: options
        };

        $.ajaxSetup({
            headers: {
                'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
            }
        });

    }

    gameCore.prototype = {
        update: function () {
            var f = function (game) {
                handleInput(game);
            };
            createInterval(f, this.game, 100);
        },

        addInput: function (input, prioritize) {
            //console.log("Adding input to queue:");
            //console.log(input);
            if (prioritize) {
                this.game.input.splice(0, 0, input);
            } else {
                this.game.input.push(input);
            }
        },

        getInput: function () {
            return this.game.input;
        },

        addServerMessage: function (msg) {
            this.game.serverMessages.push(msg);
        },

        getServerMessages: function () {
            var messages = [];
            var message;
            while (this.game.serverMessages.length > 0) {
                message = this.game.serverMessages.shift();
                messages.push(JSON.parse(message.message));
                //console.log("Removing message from serverMessages: ");
                //console.log(message);
            }
            return messages;
        }
    };

    function handleInput(game) {
        var input = undefined;
        //console.log("Input length: " + game.input.length);
        input = game.input.shift();

        while (input != undefined) {
            //console.log("Input:");
            //console.log(input);
            var time = new Date();
            var request = {
                type: "POST",
                url: game.options.server.queue,
                data: {
                    message: {
                        message: JSON.stringify({
                            timeStamp: time.getTime,
                            message: input
                        })
                    }
                },
                success: function (data) {
                    //console.log(data);
                },
                dataType: 'json'
            };
            $.ajax(request);
            input = game.input.shift();
        }
    }

    function rand() {
        return Math.round(Math.random() * 1000000);
    }

    function createInterval(f, dynamicParameter, interval) {
        setInterval(function () {
            f(dynamicParameter);
        }, interval);
    }

    return gameCore;
}(jQuery));