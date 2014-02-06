require 'spec_helper'

describe "Options" do
    before { options "/"}
    it { last_response.header["Allow"].should include("POST") }
    it { last_response.header["Access-Control-Allow-Headers"].should include("Content-Type") }
end