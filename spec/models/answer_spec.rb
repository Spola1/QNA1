require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:question)    { create(:question, :with_award) }
  let(:answer)      { create(:answer, question: question) }
  let(:best_answer) { create(:answer, question: question) }

  it { should belong_to :question }
  it { should belong_to :user }
  it { should validate_presence_of :body }

  it 'has many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#mark_as_best' do
    before do
      answer.mark_as_best
    end
    it { expect(question.best_answer).to eq answer }
    it { expect(question.award.user).to eq answer.user }
  end

  describe '#unmark_as_best' do
    before do
      answer.mark_as_best
      answer.unmark_as_best
    end
    it { expect(question.best_answer).to eq nil }
    it { expect(question.award.user).to eq nil }
  end

  describe '#best?' do
    before { best_answer.mark_as_best }

    context 'true if answer is best' do
      it { expect(best_answer).to be_best }
    end

    context 'false if not best answer' do
      it { expect(answer).to_not be_best }
    end
  end
end
