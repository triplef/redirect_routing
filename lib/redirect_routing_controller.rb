class RedirectRoutingController < ActionController::Base
  def redirect
    options = params[:args].extract_options!
    options.delete(:conditions)
    status = options.delete(:permanent) == true ? :moved_permanently : :found
    query = options.delete(:query) == true
    url_options = params[:args].first || options

    # parse named params only when dealing with a string.
    # also add a slash, so you can specify something like
    # map.redirect 'old', 'new' with setting the initial slash
    if url_options.kind_of?(String)
      url_options = parse_url_options(url_options)

      # ignore paths with initial slash and with a protocol
      url_options = "/#{url_options}" unless url_options =~ /^(\/|[\w\d]+:\/\/)/i
    end

    # redirect query string
    url_options = parse_query_string(url_options) if query

    # finally redirect to the new url
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

      if url.kind_of?(Hash)
        url.merge!(options)
      else
        connector = url =~ /\?/ ? '&' : '?'
        url << connector
        url << options.collect {|n,v| v.to_query(n) } * '&'
      end

      url
    rescue
      url
    end
end
