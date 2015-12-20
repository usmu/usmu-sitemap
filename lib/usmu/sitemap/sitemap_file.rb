require 'ox'
require 'time'
require 'usmu/template/generated_file'

module Usmu
  class Sitemap
    class SitemapFile < Usmu::Template::GeneratedFile
      def initialize(generator, name, metadata = {}, type = nil, content = nil)
        super(nil, name, metadata, type, content)
        @generator = generator
      end

      def render
        doc = Ox::Document.new(version: '1.0', encoding: 'UTF-8')

        urlset = Ox::Element.new('urlset')
        urlset[:xmlns] = 'http://www.sitemaps.org/schemas/sitemap/0.9'

        @generator.renderables.select(&method(:valid_entry?)).map(&method(:to_url)).each {|url| urlset << url }

        doc << urlset
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?>#{Ox.to_xml(doc, effort: :strict)}"
      end

      def valid_entry?(renderable)
        meta = renderable['sitemap', 'include']
        return meta unless meta.nil?

        !renderable.class.equal? Template::StaticFile
      end

      def to_url(renderable)
        url = Ox::Element.new('url')

        url << (Ox::Element.new('loc') << self['base url', default: '/'] + renderable.output_filename)
        url << (Ox::Element.new('lastmod') << Time.at(renderable.mtime).utc.iso8601)

        change_frequency = renderable['sitemap', 'change frequency', default: self['change frequency']]
        if change_frequency && !(%w{always hourly daily weekly monthly yearly never}.include? change_frequency)
          raise "Invalid change frequency '#{change_frequency}' for #{renderable.output_filename}"
        end
        url << (Ox::Element.new('changefreq') << change_frequency) if change_frequency

        priority = renderable['sitemap', 'priority', default: self['priority']]
        if priority && !(priority.is_a?(Float) && priority >= 0 && priority <= 1)
          raise "Invalid priority '#{priority}' for #{renderable.output_filename}"
        end
        url << (Ox::Element.new('priority') << priority.to_s) if priority

        url
      end
    end
  end
end
