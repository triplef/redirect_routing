class RedirectRoutingController < ActionController::Base
  def redirect
    options = params[:args].extract_options!
    options.delete(:conditions)
    status = options.delete(:permanent) == true ? :moved_permanently : :found
    url_options = params[:args].first || options
    
    if url_options.is_a?(String)
      url_options = parse_url_options(url_options)
    end
    
    redirect_to url_options, :status => status
  end
  
  private
    def parse_url_options(url)
      url.gsub(/:([a-z0-9_]+)/mi) do |m|
        CGI.escape(params[$1].to_s)
      end
    end
end
