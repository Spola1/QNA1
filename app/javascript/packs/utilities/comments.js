$(document).on('turbolinks:load', function(){
   $('.add-comment-link').on('click', addComment)
})

function addComment(event){
  event.preventDefault()
  $(this).addClass('d-none')

  var commentableId = $(this).data('commentableId')
  $('.comments-form-' + commentableId).removeClass('d-none')
}
