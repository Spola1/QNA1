require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:question) { create(:question) }
  let(:answer)   { create(:answer, question: question) }

  it { should belong_to :question }
  it { should belong_to :user }
  it { should validate_presence_of :body }

  describe '#mark_as_best' do
    before do
      answer.mark_as_best
    end
    it { expect(question.best_answer).to eq answer }
  end
end
