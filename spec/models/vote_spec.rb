require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :user }
  it { should belong_to :votable }

  describe 'uniqueness of user scoped to votable' do
    let(:user)     { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:voted)   { create(:vote, user: user, votable: question, value: 1) }

    it { should validate_uniqueness_of(:user).scoped_to(%i[votable_id votable_type]) }
  end
end
