$(document).on('turbolinks:load', function(){
   $('.questions').on('click', '.edit-question-link', editQuestion)
})

function editQuestion(event){
  event.preventDefault()
  $(this).hide()

  var questionId = $(this).data('questionId')
  $('form#edit-question-' + questionId).removeClass('d-none')
  $('.attachments-' + questionId).removeClass('d-none')
  $('.links-' + questionId).removeClass('d-none')
  $('.award-' + questionId).removeClass('d-none')
}
