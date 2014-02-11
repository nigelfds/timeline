# To get up and running

#### Install and run an instance of [MongoDB](http://www.mongodb.org)

1. Update [Homebrew](http://brew.sh)

		brew update
	
2. Install MongoDB

		brew install mongo
		
3. Make a folder for the MongoDB data (recommended to use a path outside of the codebase)

		mkdir -p [path to data]
		
4. Run Mongo

		mongod --dbpath [path to data]

#### Run the server

2. Install required gems (if you don't yet have bundler installed then go [here](http://bundler.io) to find out how to do that)

		bundle install
		
3. Run the server

		middleman
		
4. You can now view the website in your browser

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

1. Create .env file containing (Optional if Mongo isn't running under this configuration)

		MONGO_HOST=localhost
		MONGO_PORT=27017
		MONGO_DB_NAME=dandb

2. Run the tests)

		foreman run rspec