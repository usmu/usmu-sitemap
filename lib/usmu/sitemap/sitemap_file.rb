require 'usmu/template/generated_file'

module Usmu
  class Sitemap
    class SitemapFile < Usmu::Template::GeneratedFile
      def initialize(generator, name, metadata = {}, type = nil, content = nil)
        super(nil, name, metadata, type, content)
        @generator = generator
      end

      def render
        <<-XML
<?xml version="1.0">
<sitemap>
</sitemap>
        XML
      end
    end
  end
end
