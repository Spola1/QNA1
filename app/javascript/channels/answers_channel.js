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
        var links = ''

        $.each(data.links, function(index, value) {
          links += `<p><a href = ${value.url}> ${value.name} </a></p>`
        })

        var comments = `
          <div class="card-text text-left">
            <div class="comments-${data.answer.id}">
            </div>
            <small>
              <a class="add-comment-link" id="${data.answer.id}" data-commentable-id="${data.answer.id}" href="#">
                Add comment
              </a>
            </small>
            <div class="comments-form-${data.answer.id} d-none">
              <form class="new_comment" id="add-comment-${data.answer.id}" action="/answers/${data.answer.id}/comments" accept-charset="UTF-8" data-remote="true" method="post">
                <div class="mb-3 row">
                  <label class="col-sm-2 col-form-label" for="comment_body">Body</label>
                  <div class="col-sm-10">
                    <textarea class="form-control" name="comment[body]" id="comment_body"></textarea>
                  </div>
                </div>
                <input type="submit" name="commit" value="Create comment" data-disable-with="Create comment">
              </form>
            </div>
          </div>
        `

        var result =  `
        <div class="answer-${data.answer.id}">
          <div class="card mb-2">
            <div class="card-header text-right">
              <small class="text-muted">
                answered: ${data.date} ${data.user}
              </small>
            </div>
            <div class="row g-0">
              <div class="col-md-2">
                <div class="vote">
                  <div class="vote-answer-${data.answer.id} text-center">
                    <div class="rating-answer-${data.answer.id}">
                      <h1 class="text-center">
                        <span class="badge bg-secondary text-white"> 0 </span>
                      </h1>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col-md-10">
                <div class="card-body">
                  <div class="card-text">
                    ${data.answer.body}
                  </div>
                  <div class="card-text">
                    ${links}
                  </div>
                  ${comments}
                </div>
              </div>
            </div>
          </div>
        </div>
        `

        return result
      }
    })
  }
})
