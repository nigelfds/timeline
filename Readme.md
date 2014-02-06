# To get up and running

1. Install required gems (if you don't yet have bundler installed then go [here](http://bundler.io) to find out how to do that)

		bundle install
		
2. Run the server

		bundle exec middleman
		
3. You can now view the website in your browser

		open http://localhost:4567


#### Running the tests (frontend)

1. Install Node.js

		brew install node
		
2. Install Phantomjs

		brew install phantomjs
		
3. Install required packages

		npm install
		
4. Start Karma test server (tests will run whenever files are updated)

		./node_modules/.bin/karma start karma.conf.coffee

#### Running the tests (backend)

1. Create .env file containing

		MONGO_HOST=localhost
		MONGO_PORT=27017
		MONGO_DB_NAME=dandb

2. Run the tests

		foreman run rspec