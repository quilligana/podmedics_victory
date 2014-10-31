//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require fresco
//= require jquery.validate
//= require addtohomescreen.min
//= require turbolinks
//= require trial-questions

// Enable Turbolinks transition cache
Turbolinks.enableTransitionCache();

$(document).ready(function(){

  // Add to homescreen function
  addToHomescreen();

  // form client side validations
  $("#user_email").validate({
      expression: "if (VAL.match(/^[^\\W][a-zA-Z0-9\\_\\-\\.]+([a-zA-Z0-9\\_\\-\\.]+)*\\@[a-zA-Z0-9_]+(\\.[a-zA-Z0-9_]+)*\\.[a-zA-Z]{2,4}$/)) return true; else return false;",
      message: "A valid Email is required"
  });

  $("#user_name").validate({
      expression: "if (VAL.length > 3 && VAL) return true; else return false;",
      message: "Please enter your full name"
  });

  $("#user_password").validate({
      expression: "if (VAL.length > 5 && VAL) return true; else return false;",
      message: "Please enter a valid Password"
  });

  $("#user_password_confirmation").validate({
      expression: "if ((VAL == jQuery('#user_password').val()) && VAL) return true; else return false;",
      message: "Confirm password field doesn't match the password field"
  });

    // Basic menu functions
  $("#menu_action").click(function(){
    $("body").addClass('cbp-spmenu-push-toleft');
    $(".cbp-spmenu-right").addClass('active_menu');
    $(".navigation_outer_overlay").fadeIn(200);
  });

  $(".navigation_outer_overlay").click(function(){
    $(this).fadeOut(200);
    $("body").removeClass('cbp-spmenu-push-toleft').addClass('default_body');
    $(".cbp-spmenu-right").removeClass('active_menu');
  });

  // Library dropdowns
  $('a.library_button').on('click', function(e){
    $(this).toggleClass('active');
    $(this).next('.library_tab').slideToggle(400);
  });

  // Forgot/reset password link
  $("#forgot_password_link, #forgot_password_link_notice").click(function(){
    $("#members_login_form").fadeOut(200);
    $("#members_reset_password_form").delay(200).fadeIn(200);
  });

  // Toggle mobile menu
  $("a.mobile_nav_icon").click(function(){
    $(".mobile_navigation").slideToggle(400);
    $(".mobile_nav_icon").toggleClass('active_nav');
  });
  // Forgot password back link
  $("#forgot_password_back_link").click(function(){
    $("#members_reset_password_form").fadeOut(200);
    $("#members_login_form").delay(200).fadeIn(200);
  });

});
