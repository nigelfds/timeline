require 'spec_helper'

describe ApplicationHelper do

  describe '#is_valid_activity' do
    it 'should return true when activity has date and description' do
      activity = { "date" => "this is a date",
                         "description" => 'this activity is valid' }
      is_valid_activity(activity).should be_true
    end

    it 'should return false when activity does not has date' do
      activity = { "description" => 'this activity is invalid' }
      is_valid_activity(activity).should be_false
    end

    it 'should return false when activity does not has description' do
      activity = { "date" => "this is a date" }
      is_valid_activity(activity).should be_false
    end
  end

end
