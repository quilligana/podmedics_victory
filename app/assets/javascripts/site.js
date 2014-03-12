var ready;
ready = function() {

  // Tabs
  $('#tabs').tabulous({
    effect: 'scale',
    mainDiv: '#tabs_container'
  });

  // Flash alert
  $(".flash_alert").delay(8000).slideUp(400);


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
    $(".main_nav_wrapper.medicine_speciality, .main_nav_wrapper.surgery_speciality, .main_nav_wrapper.clinical_speciality_list, .main_nav_wrapper.clinical_sciences_speciality").removeClass('animated fadeInRight').hide();
    $(".main_search_wrapper").removeClass('fadeInRight animated fadeInLeft').addClass('animated fadeInLeft').show();
  });

  $(".main_nav_wrapper.speciality a.medicine_speciality_link").click(function(){
    $(".main_search_wrapper").removeClass('animated fadeInRight').hide();
    $(".main_nav_wrapper.medicine_speciality").addClass('animated fadeInRight').show();
  });

  $(".main_nav_wrapper.speciality a.surgery_speciality_link").click(function(){
    $(".main_search_wrapper").removeClass('animated fadeInRight').hide();
    $(".main_nav_wrapper.surgery_speciality").addClass('animated fadeInRight').show();
  });

  $(".main_nav_wrapper.speciality a.clinical_speciality_link").click(function(){
    $(".main_search_wrapper").removeClass('animated fadeInRight').hide();
    $(".main_nav_wrapper.clinical_speciality_list").addClass('animated fadeInRight').show();
  });

  $(".main_nav_wrapper.speciality a.clinical_sciences_speciality_link").click(function(){
    $(".main_search_wrapper").removeClass('animated fadeInRight').hide();
    $(".main_nav_wrapper.clinical_sciences_speciality").addClass('animated fadeInRight').show();
  });

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
  $(".close_notification").click(function(){
    $(this).parents("div.notification").fadeOut(400);
  });

  // Tooltip
  $(".lecture_icons_wrapper .lecture_icon").hover(function(){
    $( this ).find( '.tooltip' ).show();
  },function(){
    $( this ).find( '.tooltip' ).hide();
  });

  // Library panels
  $('.library_button').on('click', function(e){
    $(event.target).toggleClass('active');
    $(event.target).next('.library_tab').delay(50).slideToggle(400);
  });

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
