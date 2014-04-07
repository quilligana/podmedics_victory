var ready;
ready = function() {

  // Tabs
  $('#tabs').tabulous({
    effect: 'scale',
    mainDiv: '#tabs_container'
  });

  // Flash alert
  $(".flash_alert").delay(8000).slideUp(400);

  // Comment reply function
  (function($){
    $.fn.setCursorToTextEnd = function() {
        $initialVal = this.val();
        this.val($initialVal + ' ');
        this.val($initialVal);
    };
  })(jQuery);

  $(document).on("click", ".comment_reply_link a", function(){
    var comment_info = $(this).parents(".comment_info")
    var comment_username = $(comment_info).find("h3.comment_username")[0].innerHTML;
    $(".comments_textarea").val('@' + comment_username).focus().setCursorToTextEnd();
    $(window).scrollTop($("#comment_reply_textarea").offset().top);
    $("#comment_commentable_type").val('Comment');
    $("#comment_commentable_id").val(this.id);
  });

  $(document).on("click", ".no_questions_reply_wrapper a", function(){
    $(".comments_textarea").focus().setCursorToTextEnd();
    $(window).scrollTop($("#comment_reply_textarea").offset().top);
  });

  // Questions finished - fire modal
  $( "#questions_complete_modal_click" ).click();




  $('#change_profile_image_button').click(function() {
    $('.profile_avatar_upload_wrapper').fadeToggle(400);
   });

    // Navigation
  $("#menu_action").click(function(){
    $("body").addClass('cbp-spmenu-push-toleft');
    $(".cbp-spmenu-right").addClass('active_menu');
    $(".navigation_outer_overlay").fadeIn(200);
  });

  $(".inner.questions_answers_page .page .speciality_left_column .lectures_speciality_outer_wrapper #tabs #tabs_container #tabs-2 .questions_answers_list").click(function(){
    $(".questions_answers_list").hide();
    $(".questions_answers_main_question").show();
  });

  $(".navigation_outer_overlay").click(function(){
    $(this).fadeOut(200);
    $("body").removeClass('cbp-spmenu-push-toleft').addClass('default_body');
    $(".cbp-spmenu-right").removeClass('active_menu');
  });

  $(".notes_saved_button").click(function(){
    $( this ).toggleClass('active_notes_saved_button');
    $("#speciality_default_right_column").toggleClass('animated fadeOutRight').fadeToggle(1);
    $(".main_notes_right_column_wrapper").addClass('animated fadeInRight').fadeToggle(1);
  });

  $("#read_note_one").click(function(){
    $(".main_notes_right_column_wrapper").removeClass('animated fadeInRight').addClass('animated fadeInRight').fadeToggle(1);
    $(".full_note_outer_wrapper").show();
    $("#full_note_one").addClass('animated fadeInRight').fadeIn(1);
  });

  $("#back_to_notes_button").click(function(){
    $(".main_notes_right_column_wrapper").removeClass('animated fadeInRight').addClass('animated fadeInRight').fadeToggle(1);
    $(".full_note_outer_wrapper").hide();
  });


  // Navigation inner
  $(".nav-lectures").click(function(){
    $("#main_navigation").removeClass('fadeInRight animated').hide();
    $(".main_search_wrapper").addClass('animated fadeInRight').show();
  });

  $(".main_nav_inner_lectures_back_link").click(function(){
    $(".main_search_wrapper").removeClass('animated fadeInRight').hide();
    $("#main_navigation").removeClass('animated fadeOutLeft').addClass('animated fadeInLeft').show()
  });

  $(".speciality_nav_back_button").click(function(){
    $('.main_nav_wrapper.speciality').removeClass('animated fadeInRight').hide();
    $(".main_search_wrapper").removeClass('fadeInRight animated fadeInLeft').addClass('animated fadeInLeft').show();
  });

  $(".main_nav_wrapper.category a.category_link").on('click', function(){
    $(".main_search_wrapper").removeClass('animated fadeInRight').hide();
    var category = $(this).data('category');
    var target = ".main_nav_wrapper." + category + "_specialty"
    $(target).addClass('animated fadeInRight').show();
  })

  // Billing options radio buttons
  $(".billing_options label, .iradio_minimal-red").click(function(){
    $(".billing_options label").removeClass('active_label');
    $(".iradio_minimal-red").removeClass('checked');
    $(this).addClass('checked');
    $(this).addClass('active_label');
  });


  // Forgot password link
  $("#forgot_password_link").click(function(){
    $("#members_login_form").fadeOut(200);
    $("#members_reset_password_form").delay(200).fadeIn(200);
  });

  // Forgot password back link
  $("#forgot_password_back_link").click(function(){
    $("#members_reset_password_form").fadeOut(200);
    $("#members_login_form").delay(200).fadeIn(200);
  });

  // Close Notification
  $(document).on("click", ".close_notification", function(){
    $(this).parents("div.notification").fadeOut(400);
    var tab_container = $("#tabs_container");
    var height =  tab_container.height() - 
                  $(this).parents("div.notification").outerHeight(true);
    tab_container.height(height);
  });

  // Tooltip
  $(".lecture_icons_wrapper .lecture_icon").hover(function(){
    $( this ).find( '.tooltip' ).show();
  },function(){
    $( this ).find( '.tooltip' ).hide();
  });

  // Library panels
  $('a.library_button').on('click', function(e){
    $(this).toggleClass('active');
    $(this).next('.library_tab').slideToggle(400);
  });

//  $('a.library_button').on('click', function(e){
//    $(event.target).toggleClass('active');
//    $(event.target).next('.library_tab').delay(50).slideToggle(400);
//  });

  // iCheck 
  $('input').iCheck({
    checkboxClass: 'icheckbox_minimal-red',
    radioClass: 'iradio_minimal-red',
    increaseArea: '20%' // optional
  });

};
//- end of ready function
	
$(document).ready(ready);
$(document).on('page:load', ready);

var stats = [
    { value: 30, date: new Date("2011/12/20") },
    { value: 50, date: new Date("2011/12/21") },
    { value: 45, date: new Date("2011/12/22") },
    { value: 40, date: new Date("2011/12/23") },
    { value: 35, date: new Date("2011/12/24") },
    { value: 40, date: new Date("2011/12/25") },
    { value: 42, date: new Date("2011/12/26") },
    { value: 40, date: new Date("2011/12/27") },
    { value: 35, date: new Date("2011/12/28") },
    { value: 43, date: new Date("2011/12/29") },
    { value: 38, date: new Date("2011/12/30") },
    { value: 30, date: new Date("2011/12/31") },
    { value: 48, date: new Date("2012/01/01") },
    { value: 50, date: new Date("2012/01/02") },
    { value: 55, date: new Date("2012/01/03") },
    { value: 35, date: new Date("2012/01/04") },
    { value: 30, date: new Date("2012/01/05") }
];


function createChart() {
    $("#chart").kendoChart({
        chartArea: {
            background:"#F0F0F0",
        },

        dataSource: {
            data: stats
        },
        series: [{
            type: "line",
            aggregate: "avg",
            field: "value",
            categoryField: "date"
        }],
        categoryAxis: {

            baseUnit: "days"
        }
    });
}





function create_questionsChart() {


$("#questions_chart").kendoChart({
    title: {
        text: "Your score compared to others in the community"
    },
    legend: {
        visible: false
    },
    seriesDefaults: {
        type: "bubble"
    },
    series: [{
        data: [{
            x: 2500,
            y: 50000,
            size: 500000,
            category: "Microsoft"
        }, {
            x: 500,
            y: 110000,
            size: 7600000,
            category: "Starbucks"
        }, {
            x: 7000,
            y: 19000,
            size: 700000,
            category: "Google"
        }, {
            x: 1400,
            y: 150000,
            size: 700000,
            category: "Publix Super Markets"
        }, {
            x: 2400,
            y: 30000,
            size: 300000,
            category: "PricewaterhouseCoopers"
        }, {
            x: 2450,
            y: 34000,
            size: 90000,
            category: "Cisco"
        }, {
            x: 2700,
            y: 34000,
            size: 400000,
            category: "Accenture"
        }, {
            x: 2900,
            y: 40000,
            size: 450000,
            category: "Deloitte"
        }, {
            x: 3000,
            y: 55000,
            size: 900000,
            category: "Whole Foods Market"
        }]
    }],
    xAxis: {
        labels: {
            format: "{0:N0}",
            skip: 1
        },
        axisCrossingValue: 0,
        majorUnit: 2000,
        plotBands: [{
            from: 0,
            to: 2000,
            color: "#FF414E",
            opacity: 0.05
        }]
    },
    yAxis: {
        labels: {
            format: "{0:N0}"
        },

        line: {
            width: 0
        }
    },
    tooltip: {
        visible: true,
        format: "{3}: {2:N0} points",
        opacity: 1
    }
});
}



$(document).ready(createChart);
$(document).ready(create_questionsChart);


// Pie charts
$(window).bind("load", function() {
      Pizza.init();
});
