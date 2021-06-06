$(document).on('turbolinks:load', function(){
   $('.question').on('click', '.edit-question-link', editQuestion)
   $('.questions').on('click', '.edit-question-link', editQuestion)
})

function editQuestion(event){
  event.preventDefault()
  $(this).hide()

  var questionId = $(this).data('questionId')
  $('.edit-question-' + questionId).removeClass('d-none')
}
