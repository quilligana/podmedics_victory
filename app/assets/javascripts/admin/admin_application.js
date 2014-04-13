//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require redactor

$(function(){
  // enable rich text editing on the course description field
  $('#course_description').redactor();
  $('#question_stem').redactor();
  $('#question_explanation').redactor();
});
