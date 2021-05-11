import consumer from "./consumer"

$(document).on('turbolinks:load', function(){
  var path = $(location).attr('pathname').split('/')

  if(path[1] == 'questions' && path.length > 2 ) {

    consumer.subscriptions.create({channel: 'AnswersChannel', question: path[2]},{
      received(data){

        if (gon.current_user_id != data.answer.user_id){
          var result = this.createTemplate(data)
          $('.answers').append(result)
        }
      },

      createTemplate(data){
        var result =  `
        <div class = "answer-${data.answer.id}">
          <p> ${data.answer.body}</p>
          <p> Rating: 0 </p>
          <div class = "comments-${data.answer.id}"></div>
        </div>
        `
        $.each(data.links, function(index, value) {
          result += `<a href = ${value.url}> ${value.name} </a>`
        })

        return result
      }
    })
  }
})
