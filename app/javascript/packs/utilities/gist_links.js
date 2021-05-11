const GistClient = require("gist-client")
const gistClient = new GistClient()

document.addEventListener('turbolinks:load', function(){
  var gistLinks = $('.gist-link')

  if (gistLinks){
    drawGist(gistLinks)
  }
})

function drawGist(gistLinks){
//  gistLinks.each(function(i, link){
//    var id = link.data('gistId')
//    gistClient.getOneById(id)
//      .then(response => {
//        console.log(response)
//      })
//  })
}
