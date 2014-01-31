require 'spec_helper'

describe "my first test" do
  subject { page }

  describe "Home page" do
    before { visit '/' }
  end

  describe "Patient" do
  	before {
  		$db["patients"].insert(:name => "Bob")
  		visit "/patient"
  	}
  	it { should have_content('Bob') }
  	after(:each) do
		$db["patients"].remove
	end
  end


end