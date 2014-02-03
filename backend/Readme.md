# To get up and running

#### Install and run an instance of [MongoDB](http://www.mongodb.org)
1. Make sure you have [Homebrew](http://brew.sh) installed first)

		brew update
		brew install mongo
		mkdir -p data/db
		mongod --dbpath data/db

2. Install required gems for the server (if you don't yet have bundler installed then go [here](http://bundler.io) to find out how to do that)

		bundle install

3. Run the server

		rackup



##### Running the tests
1. Just run rspec

		rspec

