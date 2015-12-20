%w{
  logging
  usmu/sitemap/sitemap_file
  usmu/sitemap/version
}.each {|f| require f }

module Usmu
  class Sitemap
    def initialize
      @log = Logging.logger[self]
      @log.debug("Initializing usmu-sitemap v#{VERSION}")
    end

    def renderables_alter(renderables, generator)
      renderables << SitemapFile.new(generator, 'sitemap.xml')
    end

    private

    attr_reader :log
  end
end
