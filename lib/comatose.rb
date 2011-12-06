require 'acts_as_list'
require 'acts_as_tree_rails3'
require 'redcloth'
require 'liquid'
require 'i18n'


require 'comatose/logger'

module Comatose

  class <<self

    def logger
      comatose_logger = nil
      begin
        comatose_logger = Rails.logger
      rescue
      end

      if comatose_logger.blank?
        comatose_logger = Comatose::Logger.new(File.join(self.root, 'comatose.log'))
        comatose_logger.level = Logger::DEBUG
        comatose_logger.formatter = Logger::Formatter.new
      end
      return comatose_logger
    end


    def gem_root
      gem_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
    end


    def root
      comatose_root = nil
      begin
        comatose_root = Rails.root
      rescue
      end

      if comatose_root.blank?
        comatose_root = Comatose.gem_root
      end
      return comatose_root
    end

  end

  class ConfigurationError < StandardError; end

end

require 'comatose/engine'
require 'comatose/routes'
require 'comatose/locale_constraint'

require 'support/class_options'

require 'comatose/configuration'
require 'comatose/drop'
require 'comatose/page_wrapper'
require 'comatose/processing_context'
require 'comatose/text_filters'
require 'comatose/version'
require 'comatose/acts_as_versioned'

require 'support/inline_rendering'

Dir[File.join(File.dirname(__FILE__), 'text_filters', '*.rb')].each do |path|
  require "text_filters/#{File.basename(path)}"
end

Dir[File.join(File.dirname(__FILE__), 'comatose/filters', '*.rb')].each do |path|
  require "comatose/filters/#{File.basename(path)}"
end




#require 'support/route_mapper'
#
#
#
## BCT - TODO: some hook into the greater Rails events it seems
##::Dispatcher.to_prepare :comatose do
#    Comatose.config.after_setup.call
##end
