require 'rails_helper'

describe 'votable' do
  with_model :WithVotable do
    table do |t|
      t.bigint :user_id
    end

    model do
      include Votable
    end
  end

  let(:users)  { create_list(:user, 3) }
  let(:object) { WithVotable.create! }

  describe '#rating' do
    it 'have zero rating after create' do
      expect(WithVotable.new.rating).to eq 0
    end
  end

  describe '#vote' do
    it 'increase rating by voting up' do
      users.each do |user|
        object.vote(user, 1)
      end
      expect(object.rating).to eq users.count
    end

    it 'changes rating after canceling voting' do
      users.each do |user|
        object.vote(user, 1)
      end

      object.vote(users.first, 0)
      expect(object.rating).to eq users.count - 1
    end

    it 'reduces rating by voting down' do
      users.each do |user|
        object.vote(user, 1)
      end
      expect(object.rating).to eq users.count

      object.vote(users.first, -1)
      expect(object.rating).to eq users.count - 1
    end
  end
end
