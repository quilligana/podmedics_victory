(function(){
    // Listen for the ready event for any vimeo video players on the page
    var vimeoPlayers = document.querySelectorAll('iframe'), player;

    for (var i = 0, length = vimeoPlayers.length; i < length; i++) {
        player = vimeoPlayers[i];
        $f(player).addEvent('ready', ready);
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
    function ready(player_id) {

        var froogaloop = $f(player_id)     

        function setupEventListeners() {

            function onPlayProgress() {
                froogaloop.addEvent('playProgress', function(data) {
                    if (data.percent > 0.75) {
                        // ajax call to update Vimeo.completed attribute
                    };
                });
            };

            function onPause() {
                froogaloop.addEvent('pause', function(data) {
                    // ajax call to update Vimeo.progress attribute
                    // $.ajax({
                    //     alert("Ajax")
                    //     type: "POST", 
                    //     url: vimeos/paused, 
                    //     data: { progress: data.percent }
                    });
                });
            };

            onPlayProgress();
            onPause();
        };

        setupEventListeners();
    };

    // function createRequestObject() {
    //     var tmpXmlHttpObject;
        
    //     //depending on what the browser supports, use the right way to create the XMLHttpRequest object
    //     if (window.XMLHttpRequest) { 
    //         // Mozilla, Safari would use this method ...
    //         tmpXmlHttpObject = new XMLHttpRequest();
        
    //     } else if (window.ActiveXObject) { 
    //         // IE would use this method ...
    //         tmpXmlHttpObject = new ActiveXObject("Microsoft.XMLHTTP");
    //     }
        
    //     return tmpXmlHttpObject;
    // }

    // //call the above function to create the XMLHttpRequest object
    // var http = createRequestObject();

    // function makeGetRequest(percent) {
    //     //make a connection to the server ... specifying that you intend to make a GET request 
    //     //to the server. Specifiy the page name and the URL parameters to send
    //     http.open('get', 'definition.jsp?id=' + wordId);
        
    //     //assign a handler for the response
    //     http.onreadystatechange = processResponse;
        
    //     //actually send the request to the server
    //     http.send(null);
    // }

    // function processResponse() {
    //     //check if the response has been received from the server
    //     if(http.readyState == 4){
        
    //         //read and assign the response from the server
    //         var response = http.responseText;
    //         alert(response)
            
    //         //do additional parsing of the response, if needed
            
    //         //in this case simply assign the response to the contents of the <div> on the page. 
    //         // document.getElementById('description').innerHTML = response;
            
    //         //If the server returned an error message like a 404 error, that message would be shown within the div tag!!. 
    //         //So it may be worth doing some basic error before setting the contents of the <div>
    //     }
    // }
})();