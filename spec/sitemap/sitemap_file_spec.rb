require 'usmu/sitemap/sitemap_file'
require 'usmu/sitemap/sitemap_configuration'
require 'usmu/template/static_file'

RSpec.describe Usmu::Sitemap::SitemapFile do
  context '#valid_entry?' do
    let(:file) { described_class.new(nil, 'sitemap.xml') }

    it 'defaults to false if the entry is a StaticFile' do
      entry = Usmu::Template::StaticFile.new(nil, nil, nil)
      expect(file.valid_entry? entry).to eq(false)
    end

    it 'defaults to true if the entry is not a StaticFile' do
      entry = Usmu::Template::GeneratedFile.new(nil, 'test.foo')
      expect(file.valid_entry? entry).to eq(true)
    end

    it 'validates files that set the sitemap/include metadata value to that value' do
      # noinspection RubyStringKeysInHashInspection
      entry = Usmu::Template::GeneratedFile.new(nil, 'test.foo', {'sitemap' => {'include' => false}})
      expect(file.valid_entry? entry).to eq(false)
    end
  end

  context '#to_url' do
    it 'returns a loc and lastmod element with no metadata' do
      configuration = Usmu::Sitemap::SitemapConfiguration.new({})
      file = described_class.new(nil, 'sitemap.xml', configuration)
      entry = Usmu::Template::GeneratedFile.new(nil, 'test.foo')
      expect(entry).to receive(:mtime).and_return(1450584842)

      xml = Ox.parse(<<-XML)
<url>
  <loc>/test.foo</loc>
  <lastmod>2015-12-20T04:14:02Z</lastmod>
</url>
      XML

      expect(file.to_url entry).to eq(xml)
    end

    it 'prepends the base url to loc' do
      configuration = Usmu::Sitemap::SitemapConfiguration.new({'base url' => 'http://google.com/'})
      file = described_class.new(nil, 'sitemap.xml', configuration)
      entry = Usmu::Template::GeneratedFile.new(nil, 'test.foo')
      expect(entry).to receive(:mtime).and_return(1450584842)

      xml = Ox.parse(<<-XML)
<url>
  <loc>http://google.com/test.foo</loc>
  <lastmod>2015-12-20T04:14:02Z</lastmod>
</url>
      XML

      expect(file.to_url entry).to eq(xml)
    end

    it 'returns a changefreq element if a "sitemap/change frequency" metadata element is provided' do
      configuration = Usmu::Sitemap::SitemapConfiguration.new({})
      file = described_class.new(nil, 'sitemap.xml', configuration)
      # noinspection RubyStringKeysInHashInspection
      entry = Usmu::Template::GeneratedFile.new(nil, 'test.foo', {'sitemap' => {'change frequency' => 'monthly'}})
      expect(entry).to receive(:mtime).and_return(1450584842)

      xml = Ox.parse(<<-XML)
<url>
  <loc>/test.foo</loc>
  <lastmod>2015-12-20T04:14:02Z</lastmod>
  <changefreq>monthly</changefreq>
</url>
      XML

      expect(file.to_url entry).to eq(xml)
    end

    it 'returns a changefreq element if a "change frequency" configuration element is provided' do
      # noinspection RubyStringKeysInHashInspection
      configuration = Usmu::Sitemap::SitemapConfiguration.new({'change frequency' => 'monthly'})
      file = described_class.new(nil, 'sitemap.xml', configuration)
      entry = Usmu::Template::GeneratedFile.new(nil, 'test.foo')
      expect(entry).to receive(:mtime).and_return(1450584842)

      xml = Ox.parse(<<-XML)
<url>
  <loc>/test.foo</loc>
  <lastmod>2015-12-20T04:14:02Z</lastmod>
  <changefreq>monthly</changefreq>
</url>
      XML

      expect(file.to_url entry).to eq(xml)
    end

    it 'returns a priority element if a "sitemap/priority" metadata element is provided' do
      configuration = Usmu::Sitemap::SitemapConfiguration.new({})
      file = described_class.new(nil, 'sitemap.xml', configuration)
      # noinspection RubyStringKeysInHashInspection
      entry = Usmu::Template::GeneratedFile.new(nil, 'test.foo', {'sitemap' => {'priority' => 0.7}})
      expect(entry).to receive(:mtime).and_return(1450584842)

      xml = Ox.parse(<<-XML)
<url>
  <loc>/test.foo</loc>
  <lastmod>2015-12-20T04:14:02Z</lastmod>
  <priority>0.7</priority>
</url>
      XML

      expect(file.to_url entry).to eq(xml)
    end

    it 'returns a priority element if a "priority" configuration element is provided' do
      # noinspection RubyStringKeysInHashInspection
      configuration = Usmu::Sitemap::SitemapConfiguration.new({'priority' => 0.7})
      file = described_class.new(nil, 'sitemap.xml', configuration)
      entry = Usmu::Template::GeneratedFile.new(nil, 'test.foo')
      expect(entry).to receive(:mtime).and_return(1450584842)

      xml = Ox.parse(<<-XML)
<url>
  <loc>/test.foo</loc>
  <lastmod>2015-12-20T04:14:02Z</lastmod>
  <priority>0.7</priority>
</url>
      XML

      expect(file.to_url entry).to eq(xml)
    end
  end
end
