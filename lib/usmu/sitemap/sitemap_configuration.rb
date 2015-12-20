
module Usmu
  class Sitemap
    class SitemapConfiguration
      include Usmu::Helpers::Indexer

      indexer :@config

      def initialize(config)
        @config = config
      end
    end
  end
end
