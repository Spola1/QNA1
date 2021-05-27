require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  it { should validate_url_of :url }

  let(:gist_link) { create(:link, url: 'https://gist.github.com/Spola1/4e8cf7a8bcb1f5987cbc42cf8b234efd') }
  let(:link) { create(:link) }

  describe '#gist?' do
    context 'true if links to gist' do
      it { expect(gist_link).to be_gist }
    end

    context 'false if not links to gist' do
      it { expect(link).to_not be_gist }
    end
  end
end
