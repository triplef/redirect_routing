require File.dirname(__FILE__) + '/test_helper'

class EventsController < ActionController::Base
end
ActionController::Routing::Routes.add_route('/:controller/:action/:id')

class RedirectRoutingTest < ActionController::TestCase

  def setup
    @controller = RedirectRoutingController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_redirect_routes
    with_routing do |set|
      set.draw do |map|
        map.redirect '', :controller => 'events'
        map.redirect 'test', 'http://pinds.com'
        map.redirect 'oldurl', 'newurl', :permanent => true
      end

      assert_recognizes({ :controller => "redirect_routing", :action => "redirect", :args => [{ 'controller' => "events" }] }, { :path => '/', :method => :get})
      assert_recognizes({ :controller => "redirect_routing", :action => "redirect", :args => ["http://pinds.com"] }, { :path => '/test', :method => :get})
      assert_recognizes({ :controller => "redirect_routing", :action => "redirect", :args => ["newurl", {'permanent' => true}] }, { :path => '/oldurl', :method => :get})
    end
  end

  def test_only_get_requests_are_allowed
    [:post, :put, :delete].each do |method|
      assert_raises(ActionController::RoutingError) do
        assert_recognizes({ :controller => "redirect_routing", :action => "redirect", :args => [{ 'controller' => "events" }] }, { :path => '/', :method => method})
      end
    end
  end

  def test_redirect_controller_with_hash
    get :redirect, :args => [{ :controller => "events" }]
    assert_redirected_to :controller => "events", :action => "index"
    assert_response 302
  end

  def test_redirect_controller_with_hash_and_conditions
    get :redirect, :args => [{ :controller => "events", :conditions => { :method => :get } }]
    assert_redirected_to :controller => "events", :action => "index"
    assert_response 302
  end

  def test_redirect_controller_with_string
    get :redirect, :args => ["http://pinds.com"]
    assert_redirected_to "http://pinds.com"
    assert_response 302
  end

  def test_permanent_redirect_controller_with_hash
    get :redirect, :args => [{ :controller => "events", :permanent => true }]
    assert_redirected_to :controller => "events", :action => "index"
    assert_response 301
  end

  def test_permanent_redirect_controller_with_hash_and_conditions
    get :redirect, :args => [{ :controller => "events", :conditions => { :method => :get }, :permanent => true }]
    assert_redirected_to :controller => "events", :action => "index"
    assert_response 301
  end

  def test_permanent_redirect_controller_with_string
    get :redirect, :args => ["http://pinds.com", { :permanent => true }]
    assert_redirected_to "http://pinds.com"
    assert_response 301
  end

  def test_redirect_with_params
    get :redirect, :args => ["http://google.com/search?q=:q&site=:site"], :q => 'foo', :site => 'http://foo.com'
    assert_redirected_to "http://google.com/search?q=foo&site=http%3A%2F%2Ffoo.com"
    assert_response 302
  end

  def test_redirect_with_params_as_permanent
    get :redirect, :args => ["http://google.com/search?q=:q&site=:site", { :permanent => true }], :q => 'foo bar', :site => 'http://foo.com'
    assert_redirected_to "http://google.com/search?q=foo+bar&site=http%3A%2F%2Ffoo.com"
    assert_response 301
  end

  def test_redirect_all_query_strings_with_string
    get :redirect, :args => ["http://foo.com/", { :query => true }], :a => 1, :b => 2
    assert_redirected_to "http://foo.com/?a=1&b=2"
    assert_response 302
  end

  def test_redirect_all_query_strings_with_hash
    get :redirect, :args => [{ :controller => "events", :query => true }], :a => 1, :b => 2
    assert_redirected_to :controller => "events", :action => "index", :a => "1", :b => "2"
    assert_response 302
  end

  def test_redirect_all_query_strings_as_permanent
    get :redirect, :args => ["http://foo.com/", { :query => true, :permanent => true }], :a => 1, :b => 2
    assert_redirected_to "http://foo.com/?a=1&b=2"
    assert_response 301
  end

  def test_redirect_with_anchor
    get :redirect, :args => ["http://foo.com/page#anchor", { :query => true }], :a => 1, :b => 2
    assert_redirected_to "http://foo.com/page?a=1&b=2#anchor"
    assert_response 302
  end
end
