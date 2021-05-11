$(document).on('turbolinks:load', function(){
  $('.vote').on('ajax:success', function(e) {

    var id = e.detail[0].id
    var rating = e.detail[0].rating
    var voted = e.detail[0].voted

    $('.rating-' + id).html('<p> Rating:' + rating + '</p>')

    if (voted){
      $('.link-cancel-'+ id ).removeClass('d-none')
      $('.link-vote-' + id ).addClass('d-none')
    }
    else{
      $('.link-cancel-'+ id ).addClass('d-none')
      $('.link-vote-' + id ).removeClass('d-none')
    }

  })
})
