require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:question) { create(:question) }
  let(:user)      { create(:user) }

  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:awards) }

  describe '#author?' do
    context 'true if author of object' do
      it { expect(question.user).to be_author(question) }
    end

    context 'false if not author of object' do
      it { expect(user).to_not be_author(question) }
    end
  end
end
