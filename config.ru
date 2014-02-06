require 'bundler'

Bundler.require

require 'rack/contrib/try_static'
require './backend'

# use our backend
use Backend

# try the static site
use Rack::TryStatic, 
    root: "build",  # static files root dir
    urls: %w[/],     # match all requests 
    try: ['.html', 'index.html', '/index.html'] # try these postfixes sequentially

# otherwise 404 NotFound
run lambda{ |env|
  not_found_page = File.expand_path("./tmp/404/index.html", __FILE__)
  if File.exist?(not_found_page)
    [ 404, { 'Content-Type'  => 'text/html'}, [File.read(not_found_page)] ]
  else
    [ 404, { 'Content-Type'  => 'text/html' }, ['404 - page not found'] ]
  end
}