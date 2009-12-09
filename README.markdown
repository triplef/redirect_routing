RedirectRouting
===============

This plugin lets you do simple redirects straight from your routes.rb file:

    map.redirect '', :controller => 'events'

This will make the root of your site redirect to the events controller, typically at /events.

You can redirect any URL to any set of options, or event a string URL, like this:

    map.redirect 'test', 'http://pinds.com'

GET /test, and you'll be redirected to my blog.

You can also set the status to be a 301 permanent redirect instead of a temporary 302:

    map.redirect 'oldurl', 'newurl', :permanent => true
    map.redirect 'oldurl', :controller => 'new_controller', :action => 'new_action', :permanent => true

You can specify that all query string will be redirected as well:

	map.redirect 'oldurl', 'newurl', :query => true

If someone request `oldurl?a=1&b=2` then the request will be redirected to `newurl?a=1&b=2`.

You can use parameters name to the redirection:

	map.redirect 'oldurl/:name', 'newurl/:name'
	map.redirect 'search/:term/:page', 'http://google.com/search?q=:term'

Motivation
----------

Why this plugin?

Because if Rails Routing is supposed to be a Ruby replacement for mod_rewrite, then at least some redirect capability is called for.

But more concretely, because there's no good alternative unless you're using Apache. The alternative options that I've been able to figure out are:

* Configure your web server to do the redirect for you, which is trivial with mod_rewrite in Apache, but not so trivial with Mongrel, or
* Manually create a controller for the sole purpose of redirecting, or
* Tack the redirect onto another controller, which isn't very RESTful

If you know of a simpler way to do this, please let me know.

Compatibility
-------------

I recently tested this plugin on Rails 2.3.5, but it may work on older versions.

Credits
-------

Written by Lars Pind

<http://pinds.com>

Changelog
---------
* Updated to Rails Edge - *Manfred Stienstra*
* Support for 301 redirects - *Gioele Barabucci*
* Silence warning about missing helper - *Tim Connor*
* Gobble up options[:conditions], so it doesn't get included in the URL redirected to - *guillaumegentil*
* Added support for redirection with params name - *Nando Vieira*
* Added support for query string redirection - *Nando Vieira*