require 'usmu/sitemap/sitemap_configuration'

RSpec.describe Usmu::Sitemap::SitemapConfiguration do
  it 'can index the constructor parameter' do
    conf = described_class.new(test: 'foo')
    expect(conf[:test]).to eq('foo')
  end
end
