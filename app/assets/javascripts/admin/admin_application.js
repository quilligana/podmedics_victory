//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require bootstrap
//= require redactor
//= require admin_theme
//= require pace
//= require turbolinks


// Enable Turbolinks transitio cache
Turbolinks.enableTransitionCache();

$(function(){
  // enable rich text editing on the course description field
  $('#course_description').redactor();
  $('#question_stem').redactor();
  $('#question_explanation').redactor();
  $('#faq_content').redactor();
  $('#newsletter_body_content').redactor();
  $('#post_content').redactor();
  $('#flashcard_epidemiology').redactor();
  $('#flashcard_pathology').redactor();
  $('#flashcard_causes').redactor();
  $('#flashcard_signs').redactor();
  $('#flashcard_symptoms').redactor();
  $('#flashcard_inv_cultures').redactor();
  $('#flashcard_inv_bloods').redactor();
  $('#flashcard_inv_imaging').redactor();
  $('#flashcard_inv_scopic').redactor();
  $('#flashcard_inv_functional').redactor();
  $('#flashcard_treat_cons').redactor();
  $('#flashcard_treat_medical').redactor();
  $('#flashcard_treat_surgical').redactor();
});

$(document).on('page:fetch', function(){
    Pace.restart();
});

$(document).on('page:change', function(){
    Pace.restart();
});
