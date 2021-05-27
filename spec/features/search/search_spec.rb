require 'rails_helper'

shared_examples_for "searchable" do
  background { visit questions_path }

  scenario 'fill form and match result' do
    ThinkingSphinx::Test.run do
      fill_in 'query', with: searching_param
      select resource_name, from: 'resource'
      click_on 'Find it!'

      expect(page).to have_content expecting_result
    end
  end
end

feature 'User can search for information', "
  In order to find needed info
  As a User
  I'd like to be able to search
" do
  given!(:user)     { create(:user, email: 'test@mail.com') }
  given!(:question) { create(:question, body: 'test 123', user: user) }
  given!(:answer)   { create(:answer, body: 'test 456', question: question) }
  given!(:comment)  { create(:comment, body: 'test 789', commentable: answer) }

  context 'search from questions' do
    it_should_behave_like "searchable" do
      let(:resource_name)   { 'question' }
      let(:searching_param) { question.title }
      let(:expecting_result) { question.title }
    end

    it_should_behave_like "searchable" do
      let(:resource_name)   { 'question' }
      let(:searching_param) { question.body }
      let(:expecting_result) { question.title }
    end
  end

  context 'search from answers' do
    it_should_behave_like "searchable" do
      let(:resource_name)   { 'answer' }
      let(:searching_param) { answer.body }
      let(:expecting_result) { answer.body }
    end
  end

  context 'search from comments' do
    it_should_behave_like "searchable" do
      let(:resource_name)   { 'comment' }
      let(:searching_param) { comment.body }
      let(:expecting_result) { comment.body }
    end
  end

  context 'search from users' do
    it_should_behave_like "searchable" do
      let(:resource_name)   { 'user' }
      let(:searching_param) { 'test' }
      let(:expecting_result) { user.email }
    end
  end

  context 'search from all' do
    background { visit questions_path }

    scenario 'fill form and match result' do
      ThinkingSphinx::Test.run do
        fill_in 'query', with: 'test'
        select 'all', from: 'resource'
        click_on 'Find it!'

        expect(page).to have_content('test').exactly(3).times
      end
    end
  end
end
