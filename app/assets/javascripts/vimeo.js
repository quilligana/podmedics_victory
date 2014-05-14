$(document).ready(function(){
    // Listen for the ready event for any vimeo video players on the page
    var vimeoPlayers = document.querySelectorAll('iframe'), player;

    for (var i = 0, length = vimeoPlayers.length; i < length; i++) {
        player = vimeoPlayers[i];
        $f(player).addEvent('ready', vid_ready);
    }

    /**
     * Utility function for adding an event. Handles the inconsistencies
     * between the W3C method for adding events (addEventListener) and
     * IE's (attachEvent).
     */
    function addEvent(element, eventName, callback) {
        if (element.addEventListener) {
            element.addEventListener(eventName, callback, false);
        }
        else {
            element.attachEvent(eventName, callback, false);
        }
    };

    /**
     * Called once a vimeo player is loaded and ready to receive
     * commands. You can add events and make api calls only after this
     * function has been called.
     */
    function vid_ready(player_id) {

        var froogaloop = $f(player_id);

        function seekToPreviousViewing() {
            
            var progJSON = $("#progress_json").html(), 
                viewProgress = $.parseJSON(progJSON);

            if(viewProgress!=0) {
                froogaloop.api('seekTo', viewProgress);
                viewProgress = 0;
            };
            return false;
        };

        function setupEventListeners() {

            function onPlayProgress() {
                froogaloop.addEvent('playProgress', function(data) {
                    if (data.percent > 0.75) {
                        var video_url = $(location).attr('pathname');
                        $.ajax({
                            type: 'GET',
                            url: '/vimeos/completed',
                            data: {'path': video_url},
                        });
                        froogaloop.removeEvent('playProgress');
                    };
                });
            };

            function onPause() {
                var elapsed;
                froogaloop.addEvent('pause', function(data) {
                    froogaloop.api('getCurrentTime', function(value, player_id) {
                        elapsed = value;
                        var video_url = $(location).attr('pathname');
                        $.ajax({
                            type: 'GET',
                            url: '/vimeos/paused',
                            data: {'path': video_url, 'progress': elapsed},
                        }); 
                    });                   
                });
            };

            onPlayProgress();
            onPause();
        };

        setupEventListeners();
        seekToPreviousViewing();
    };
});