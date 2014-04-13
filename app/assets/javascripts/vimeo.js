$(function(){
    // Listen for the ready event for any vimeo video players on the page
    var vimeoPlayers = document.querySelectorAll('iframe'), player;

    for (var i = 0, length = vimeoPlayers.length; i < length; i++) {
        player = vimeoPlayers[i];
        $f(player).addEvent('vid_ready', vid_ready);
    }

    /**
     * Utility function for adding an event. Handles the inconsistencies
     * between the W3C method for adding events (addEventListener) and
     * IE's (attachEvent).
     */
    $(function addEvent(element, eventName, callback) {
        if (element.addEventListener) {
            element.addEventListener(eventName, callback, false);
        }
        else {
            element.attachEvent(eventName, callback, false);
        }
    });

    /**
     * Called once a vimeo player is loaded and ready to receive
     * commands. You can add events and make api calls only after this
     * function has been called.
     */
    $(function vid_ready(player_id) {

        alert("ready")

        var froogaloop = $f(player_id)

        $(function setupEventListeners() {

            $(function onPlayProgress() {
                froogaloop.addEvent('playProgress', function(data) {
                    if (data.percent > 0.75) {
                        // ajax call to update Vimeo.completed attribute
                        alert("75")
                    };
                });
            });

            $(function onPause() {
                froogaloop.addEvent('pause', function(data) {
                    // an ajax call to update Vimeo.progress attribute
                    // alert("Paused")
                });
            });

            onPlayProgress();
            onPause();
        });
    });
});