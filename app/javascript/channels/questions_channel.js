import consumer from "./consumer"

$(document).on('turbolinks:load', function(){

  if($('.questions').length == 1 ) {
    consumer.subscriptions.create('QuestionsChannel',{
      received(data){
        var result = this.createTemplate(data.question)
        $('.questions').append(result)
      },

      createTemplate(question){
        return `
        <div class = "question-${question.id}">
          <a  title = ${question.title} href = 'questions/${question.id}'> ${question.title}</a>
        </div>
        `
      }
    })
  }
})
