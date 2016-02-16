/*
 Module for tracking server message frequency
 //Suggested config
 {
 msgRecvCounter: $('#msg-count'),
 avgLatencyCounter: $('#avg-latency')
 }
 */
var MPSMeter = (function ($) {
    function messageMeter(config) {
        this.config = config;
        this.profile = {
            start: 0,
            messagesReceived: 0,
            latency: 0
        }
    }

    messageMeter.prototype = {
        setContainer: function (containerSelector) {
            this.containerSelector = containerSelector;
        },

        update: function () {
            var now = new Date().getTime();
            if (this.profile.start === 0) {
                this.profile.start = now;
                this.config['msgRecvCounter'] = $(this.config.msgRecvSelector);
                this.config['avgLatencyCounter'] = $(this.config.avgLatencySelector);
            }
            this.profile.messagesReceived++;
            this.profile.latency += now - this.profile.start;
            this.profile.start = now;
            this.config.msgRecvCounter.html(this.profile.messagesReceived);
            this.config.avgLatencyCounter.html((this.profile.latency / this.profile.messagesReceived).toFixed(3));
        }
    };

    return messageMeter;
}(jQuery));
