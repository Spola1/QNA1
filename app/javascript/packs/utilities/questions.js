$(document).on('turbolinks:load', function(){
   $('.questions').on('click', '.edit-question-link', editQuestion)
})

function editQuestion(event){
  event.preventDefault()
  $(this).hide()

  var questionId = $(this).data('questionId')
  $('form#edit-question-' + questionId).removeClass('hidden')
  $('.attachments-' + questionId).removeClass('hidden')
  $('.links-' + questionId).removeClass('hidden')
  $('.award-' + questionId).removeClass('hidden')
}

