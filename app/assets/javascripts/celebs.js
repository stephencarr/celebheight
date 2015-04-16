$(document).ready(function(){
    var liveSearchWidget = {

        settings: {
            delay: 800,
            minchar: 2,
            maxResults: 10,
            celebitem: '.celebitem',
            form: 'form.celebs-search--form',
            input: 'input#celebs-search-input',
            url: $('form.celebs-search--form').attr('action'),
            target: '#content',
            wrapper: '#wrap'
        },

        init: function(){

            s = this.settings;
            this.bindActions();
            $(document).on("page:fetch", this.startSpinner);
            $(document).on("page:receive", this.stopSpinner);

            if(!$(s.input).val().length){
                $(s.input).focus();
            }

            this.celebsizeup();

        },

        startSpinner: function(){
            var opts = {
                lines: 7, // The number of lines to draw
                length: 1, // The length of each line
                width: 2, // The line thickness
                radius: 4, // The radius of the inner circle
                corners: 1, // Corner roundness (0..1)
                rotate: 17, // The rotation offset
                direction: 1, // 1: clockwise, -1: counterclockwise
                color: '#000', // #rgb or #rrggbb or array of colors
                speed: 1, // Rounds per second
                trail: 36, // Afterglow percentage
                shadow: true, // Whether to render a shadow
                hwaccel: false, // Whether to use hardware acceleration
                className: 'spinner', // The CSS class to assign to the spinner
                zIndex: 2e9, // The z-index (defaults to 2000000000)
                top: 'auto', // Top position relative to parent in px
                left: 'auto' // Left position relative to parent in px
            };
            $(s.form).find('.glyphicon').css('opacity', 0);
            $(s.form).find('button.btn').spin(opts);
        },

        stopSpinner: function(){
            $(s.form).find('.glyphicon').css('opacity', 1);
            $(s.form).find('button.btn').spin(false);
        },

        bindActions: function(){

            $(s.input).unbind("keyup");
            $(s.input).keyup(function(event){

                switch (event.keyCode) {
                    case 38: event.preventDefault() // Up
                    case 40: event.preventDefault()// Down
                        break;

                    default:
                        liveSearchWidget.search();
                }

                event.preventDefault();
            });
            $(s.form).on('submit', function(event){
                liveSearchWidget.search();
                event.preventDefault();
            })
        },

        search: function(){
            $.doTimeout('text-type', s.delay, function(){
                if (!$(s.input).val()) {
                    $(s.target).html('');
                }
                // TODO: Find a cleaner way of detecting text selection in input
                if(($(s.input).val().length >= s.minchar) && (document.getElementById('celebs-search-input').selectionStart == document.getElementById('celebs-search-input').selectionEnd)){

                    var query = encodeURIComponent($(s.input).val().replace(/ /gi, '-'));
                    var urlPath = s.url + '/' + query;
                    liveSearchWidget.updateResults(urlPath, true, null);

                }
            });
        },

        /*
         The arguments are:
         url: The url to pull new content from
         doPushState: If a new state should be pushed to the browser, true on links and false on normal state changes such as forward and back.
         */
        updateResults: function(url, doPushState, defaultEvent)
        {
            if (!history.pushState) { //Compatability check
                return true; //pushState isn't supported, fallback to normal page load
            }

            if (defaultEvent != null) {
                defaultEvent.preventDefault(); //Someone passed in a default event, stop it from executing
            }

            if (doPushState) {  //If we are supposed to push the state or not
                var stateObj = { turbolinks: true, position: Date.now() };
                history.pushState(stateObj, "", url); //Push the new state to the browser
            }

            //Make a GET request to the url which was passed in
            $(document).trigger('page:fetch');
            $.get(url, function(response) {
                var newContent = $(response).find(s.target);      //Find the content section of the response
                var contentWrapper = $(s.wrapper);         //Find the content-wrapper where we are supposed to change the content.
                var oldContent = contentWrapper.find(s.target);   //Find the old content which we should replace.

                oldContent.fadeOut(300, function() { //Make a pretty fade out of the old content
                    oldContent.remove(); //Remove it once it is done
                    contentWrapper.append(newContent.hide()); //Add our new content, hidden
                    newContent.fadeIn(300); //Fade it in!
                    $(document).trigger('page:receive');
                    $(document).trigger('page:load');
                });

            });
        },

        celebsizeup: function(){
            var spacer = 180;
            var spacer_factor = 0.1;
            var maximum = $(s.target).data('maximum');
            $('.celebitem').each(function(){
                // var base = 3.1;
                var scale = $(this).data('scale');
                var search_box_height = Math.round(
                    $('.celebs-search').outerHeight() /
                        $('body').height() * 100
                );
                var height = Math.round(scale * 100 / maximum) - search_box_height;
                $(this).css({left: Math.round(spacer * spacer_factor), height: height + '%', opacity: 1});
                spacer_factor++;
            });

        }
    };

    // Trigger
    (function() {

        liveSearchWidget.init();
        $(document).on('page:load', function(){liveSearchWidget.init()});

    })();

});