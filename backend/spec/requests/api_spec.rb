require 'spec_helper'

describe "My Sinatra API" do

  it "should allow accessing the home page" do
    get '/'
    last_response.should be_ok
  end
end
