$(document).ready(function(){

    var iframe = $('#vimeoplayer')[0], 
        player = $f(iframe),
        progJSON = $("#progress_json").html(), 
        viewProgress = $.parseJSON(progJSON);

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

    // When the player is ready, add listeners for pause, finish, and playProgress
    player.addEvent('ready', function() {
        player.addEvent('pause', onPause);
        player.addEvent('playProgress', onPlayProgress);
        if(viewProgress!=0) {
            player.api('seekTo', viewProgress);
        };
    });

    function onPause(id) {
        var elapsed;
        player.api('getCurrentTime', function(value, player_id) {
            elapsed = value;
            var video_url = $(location).attr('pathname');
            $.ajax({
                type: 'GET',
                url: '/vimeos/paused',
                data: {'path': video_url, 'progress': elapsed},
            }); 
        });
    }

    function onPlayProgress(data, id) {
        if (data.percent > 0.75) {
            var video_url = $(location).attr('pathname');
            $.ajax({
                type: 'GET',
                url: '/vimeos/completed',
                data: {'path': video_url},
            });
            player.removeEvent('playProgress');
        };
    };
});