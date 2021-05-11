$(document).on('turbolinks:load', function(){
   $('.answers').on('click', '.edit-answer-link', editAnswer )
})

function editAnswer(event){
  event.preventDefault()

  $(this).hide()
  var answerId = $(this).data('answerId')
  $('form#edit-answer-' + answerId).removeClass('hidden')
}
