module Comatose

  def self.config
    @@config ||= Configuration.new
  end

  def self.configure(&block)
    raise "#configure must be sent a block" unless block_given?
    yield config
    config.validate!
    config.include!
  end
  
  # All of the 'mount' points for Comatose
  def self.mount_points
    @@mount_points ||= []
  end

  # Adds a 'mount' point to the list of known roots...
  def self.add_mount_point(path, info={:index=>''})
    path = "/#{path}" unless path.starts_with? '/'
    info[:root]=path
    mount_points << info
  end

  class Configuration

    attr_accessor_with_default :admin_editor,         :editor
    attr_accessor_with_default :admin_includes,       []
    attr_accessor_with_default :admin_helpers,        []
    attr_accessor_with_default :admin_sub_title,      'The Micro CMS'
    attr_accessor_with_default :admin_title,          'Comatose'
    attr_accessor_with_default :content_type,         'utf-8'
    attr_accessor_with_default :default_filter,       'None'
    attr_accessor_with_default :default_processor,    :liquid
    attr_accessor_with_default :default_tree_level,   2
    attr_accessor_with_default :disable_caching,      false
    attr_accessor_with_default :hidden_meta_fields,   []
    attr_accessor_with_default :helpers,              []
    attr_accessor_with_default :includes,             []
    attr_accessor_with_default :mount_points,         []
    attr_accessor_with_default :allow_import_export,  true
    attr_accessor_with_default :page_finder,          :find_by_path

    # 'Blockable' setters
    blockable_attr_accessor    :authorization
    blockable_attr_accessor    :admin_authorization
    blockable_attr_accessor    :admin_get_author
    blockable_attr_accessor    :admin_get_root_page
    blockable_attr_accessor    :after_setup


    def initialize
      # Default procs for blockable attrs....
      @authorization       = Proc.new { true }
      @admin_authorization = Proc.new { true }
      @admin_get_author    = Proc.new { request.env['REMOTE_ADDR'] }
      @admin_get_root_page = Proc.new { Page.root }
      @after_setup         = Proc.new { true }
    end

    
    def validate!
      Comatose.logger.debug "Validating!"
      raise Comatose::ConfigurationError.new( "admin_get_author must be a Proc or Symbol" ) unless @admin_get_author.is_a? Proc or @admin_get_author.is_a? Symbol
      #raise ConfigurationError.new( "admin_authorization must be a Proc or Symbol" ) unless @admin_authorization.is_a? Proc or @admin_authorization.is_a? Symbol
      #raise ConfigurationError.new( "authorization must be a Proc or Symbol" ) unless @authorization.is_a? Proc or @authorization.is_a? Symbol
      true
    end


    def include!
      Comatose.logger.debug "Including!: #{@includes.to_s}"
      @includes.each do |include_this|
        begin
          Comatose.logger.debug "including #{include_this.to_s}"
          Comatose.send(:include, include_this)
        rescue => e
          Comatose.logger.debug "Unable to include config item: #{include_this.to_s}"
          Comatose.logger.debug e.message
        end
      end
    end

    
  end

end
