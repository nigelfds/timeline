require 'spec_helper'

describe 'csv data export' do
  let(:activity1) { { 'staffInvolved' => ['s1', 's2' ], 'itSystems' => [ 'sys A', 'sys B'], 'paperRecords' => [ 'paper A', 'paper B', 'paper C', 'paper D'] } }
  let(:activity2) { { 'staffInvolved' => ['s1', 's3' ], 'itSystems' => [ 'sys C', 'sys B'], 'paperRecords' => [ 'paper C', 'paper E'] } }
  let(:activity3) { { 'itSystems' => [ 'sys A', nil] } }
  let(:activity4) { { 'staffInvolved' => ['s4', nil], 'paperRecords' => ['paper C', nil] } }

  let(:activities) { [ activity1, activity2, activity3, activity4 ] }

  describe '#num_updates_and_uniq' do
    it "should calculalte the number of updates and the number of unique it system" do
      num_updates, uniq_it_sys = num_updates_and_uniq(activities, 'itSystems')
      num_updates.should eq 5
      uniq_it_sys.should eq 3
    end

    it "should calculalte the number of updates and the number of unique paper record" do
      num_updates, uniq_paper_record = num_updates_and_uniq(activities, 'paperRecords')
      num_updates.should eq 7
      uniq_paper_record.should eq 5
    end
  end

  describe '#num_uniq' do
    it "should calculalte the number uniq staff involved" do
      num_uniq(activities, 'staffInvolved').should eq 4
    end
  end

  describe '#count_occurrance' do

    let(:activity1) { { 'fieldA' => true } }
    let(:activity2) { { 'fieldA' => nil  } }
    let(:activity3) { { 'fieldA' => false } }
    let(:activity4) { { 'fieldA' => true } }

    it "should count only the true value" do
      count_occurrance(activities, 'fieldA').should eq 2
    end
  end

  describe '#count_combined_occurrance' do

    let(:activity1) { { 'fieldA' => true, 'fieldB' => true } }
    let(:activity2) { { 'fieldA' => nil,  'fieldB' => true } }
    let(:activity3) { { 'fieldA' => false, 'fieldB' => nil } }
    let(:activity4) { { 'fieldA' => true, 'fieldB' => false } }

    it "should count only the true value" do
      count_combined_occurrance(activities, 'fieldA', 'fieldB').should eq 1
    end
  end
end
