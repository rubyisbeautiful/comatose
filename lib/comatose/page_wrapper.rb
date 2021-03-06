# Giving direct access to the AR model is disconcerting, so this wraps the AR
# Model to prevent access to certain, destructive behavior
module Comatose
  class PageWrapper

    @@allowed_methods   = %w( id full_path uri slug keywords title to_html filter_type author updated_at created_at )
    @@custom_methods    = %w( link content parent next previous children rchildren first_child last_child has_keyword current_user )

    attr_accessor :page, :current_user
    #private :page

    def initialize(page, locals={}, system={})
      @current_user = system[:current_user]
      @page         = page
      @keyword_lst  = []
      @keyword_hsh  = {}
      unless page.nil?
        @keyword_lst = (page.keywords || '').downcase.split(',').map{ |k| k.strip }
        @keyword_lst.each { |kw| @keyword_hsh[kw] = true }
      end
      @locals = locals
    rescue => e
      Comatose.logger.debug e.message
      Comatose.logger.debug e.backtrace.join("\n")
    end



    def has_keyword?(keyword)
      @page.has_keyword?(keyword)
    end


    def has_keyword
      @keyword_hsh
    end


    def next
      @next_page ||= begin
        if @page.lower_item.nil?
          nil
        else
          Comatose::PageWrapper.new( @page.lower_item )
        end
      end
    end


    def previous
      @prev_page ||= begin
        if @page.higher_item.nil?
          nil
        else
          Comatose::PageWrapper.new( @page.higher_item )
        end
      end
    end


    def first_child
      children.first
    end


    def def last_child
      children.last
    end


    # Generates a link to this page... You can pass in the link text,
    # otherwise it will default to the page title.
    def link(title=nil)
      title = @page.title if title.nil?
      TextFilters[@page.filter_type].create_link(title, @page.uri)
    end


    def content
      @page.to_html( @locals )
    end


    def parent
      @parent ||= begin
        if @page.parent.nil?
          nil
        else
          Comatose::PageWrapper.new( @page.parent )
        end
      end
    end


    def children
      # Cache the results so that you can have multiple calls to #children without a penalty
      @children ||= @page.children.to_a.collect {|child| Comatose::PageWrapper.new( child, @locals )}
    end


    # Children, in reverse order
    def rchildren
      children.reverse
    end


    def [](key)
      Comatose.logger.debug "using [] to find key: #{key}"
      if @@allowed_methods.include? key.to_s #or page.attributes.has_key? key.to_s
        page.send(key)
      elsif @@custom_methods.include? key
        self.send(key.to_sym)
      end
    end


    def has_key?(key)
      @@allowed_methods.include? key or @@custom_methods.include? key
    end


    def to_s
      @page.title
    end


    def to_liquid
      self
    end


    def method_missing(method_id, *args)
      #Comatose.logger.debug "Looking for method: #{method_id} (#{method_id.class.to_s}) in [#{@@allowed_methods.join(', ')}] or [#{page.attributes.keys.join(', ')}]"
      if @@allowed_methods.include? method_id.to_s or page.attributes.has_key? method_id.to_s
        #Comatose.logger.debug "sending method_id to page"
        page_value = page.send(method_id, *args)
        #Comatose.logger.debug "page returned: #{page_value}"
        return page_value
      else
        # Access nazi says: NO ACCESS FOR YOU!!
        # but he says it silently...
        Comatose.logger.debug("PageWrapper#method_missing: could not find #{method_id}")
      end
    end

  end
end
