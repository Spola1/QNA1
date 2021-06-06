import consumer from "./consumer"

$(document).on('turbolinks:load', function(){

  if($('.questions'>=1)) {
    consumer.subscriptions.create('QuestionsChannel',{
      received(data){
        var result = this.createTemplate(data)
        $('.questions').append(result)
      },

      createTemplate(data){
        return `
        <div class="question-${data.question.id}">
          <div class="card mb-2">
            <div class="row g-0">
              <div class="col-md-10">
                <div class="card-body">
                  <h5 class="card-title">
                    <a href="/questions/${data.question.id}">${data.question.title}</a>
                  </h5>
                  <div class="card-text">
                    ${data.question.body}
                  </div>
                </div>
              </div>
              <div class="col-md-2">
                <p>Rating
                  <span class="badge bg-success text-white">
                    0
                  </span>
                </p>
                <p> Answers
                  <span class="badge bg-warning text-white">
                    0
                  </span>
                </p>
              </div>
            </div>
            <div class="card-footer">
              <small class="text-muted">
                  ${data.created} ${data.user}
              </small>
            </div>
          </div>
        </div>
        `
      }
    })
  }
})
