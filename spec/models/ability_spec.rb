require 'rails_helper'
require "cancan/matchers"

describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user)           { create :user }
    let(:other)          { create :user }
    let(:question)       { create(:question, user: user) }
    let(:other_question) { create(:question, user: other) }
    let(:subscription)   { create(:subscription, question: question, user: user) }
    let(:question_with_file) { create(:question_with_file, user: user) }
    let(:other_question_with_file) { create(:question_with_file, user: other) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, question }
    it { should_not be_able_to :update, other_question }

    it { should be_able_to :update, create(:answer, user: user) }
    it { should_not be_able_to :update, create(:answer, user: other) }

    it { should be_able_to :destroy, question }
    it { should_not be_able_to :destroy, other_question }

    it { should be_able_to :destroy, create(:answer, user: user) }
    it { should_not be_able_to :destroy, create(:answer, user: other) }

    it { should be_able_to :destroy, create(:link, linkable: question) }
    it { should_not be_able_to :destroy, create(:link, linkable: other_question) }

    it { should be_able_to :destroy, create(:award, question: question) }
    it { should_not be_able_to :destroy, create(:award, question: other_question) }

    it { should be_able_to :destroy, question_with_file.files.first }
    it { should_not be_able_to :destroy, other_question_with_file.files.first }

    it { should be_able_to :vote_up, create(:answer, user: other) }
    it { should_not be_able_to :vote_up, create(:answer, user: user) }

    it { should be_able_to :vote_down, create(:answer, user: other) }
    it { should_not be_able_to :vote_down, create(:answer, user: user) }

    it { should be_able_to :vote_cancel, create(:answer, user: other) }
    it { should_not be_able_to :vote_cancel, create(:answer, user: user) }

    it { should be_able_to :vote_up, other_question }
    it { should_not be_able_to :vote_up, question }

    it { should be_able_to :vote_down, other_question }
    it { should_not be_able_to :vote_down, question }

    it { should be_able_to :vote_cancel, other_question }
    it { should_not be_able_to :vote_cancel, question }

    it { should be_able_to :best, create(:answer, question: question, user: other) }
    it { should_not be_able_to :best, create(:answer, question: other_question, user: user) }
    it { should_not be_able_to :best, create(:answer, question: other_question, user: other) }

    it { should be_able_to :create, subscription}
    it { should be_able_to :destroy, subscription }
    it { should_not be_able_to :destroy, create(:subscription, question: question, user: other) }
  end
end
