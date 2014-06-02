//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require redactor
//= require admin_theme

$(function(){
  // enable rich text editing on the course description field
  $('#course_description').redactor();
  $('#question_stem').redactor();
  $('#question_explanation').redactor();
  $('#faq_content').redactor();
  $('#newsletter_body_content').redactor();
  $('#post_content').redactor();
});
