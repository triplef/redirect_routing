class RedirectRoutingController < ActionController::Base
  def redirect
    options = params[:args].extract_options!
    options.delete(:conditions)
    status = options.delete(:permanent) == true ? :moved_permanently : :found
    query = options.delete(:query) == true
    url_options = params[:args].first || options
    
    if url_options.is_a?(String)
      url_options = parse_url_options(url_options)
    end
    
    if query
      url_options = parse_query_string(url_options)
    end
    
    redirect_to url_options, :status => status
  end
  
  private
    def parse_url_options(url)
      url.gsub(/:([a-z0-9_]+)/mi) do |m|
        CGI.escape(params[$1].to_s)
      end
    end
    
    def parse_query_string(url)
      options = params.except(:controller, :action, :args)
      
      if url.is_a?(Hash)
        url.merge!(options)
      elsif !options.empty?
        connector = url =~ /\?/ ? '&' : '?'
        url << connector
        url << options.collect {|n,v| v.to_query(n) } * '&'
      end
      
      url
    rescue
      url
    end
end
