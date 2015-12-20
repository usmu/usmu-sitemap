%w{
  logging
  usmu/sitemap/sitemap_configuration
  usmu/sitemap/sitemap_file
  usmu/sitemap/version
}.each {|f| require f }

module Usmu
  class Sitemap
    def initialize
      @log = Logging.logger[self]
      @log.debug("Initializing usmu-sitemap v#{VERSION}")
    end

    def commands(ui, c)
      @ui = ui
    end

    def renderables_alter(renderables, generator)
      configuration = SitemapConfiguration.new(@ui.configuration['plugin', 'sitemap', default: {}])
      renderables << SitemapFile.new(generator, configuration['filename', default: 'sitemap.xml'], configuration)
    end

    private

    attr_reader :log
  end
end
