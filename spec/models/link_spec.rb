require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  it { should validate_url_of :url }

  let(:gist_link) { create(:link, url: 'https://gist.github.com/HelenRaven/b98553ef55c033f7c37e7596f6da3151') }
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
