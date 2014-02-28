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

  describe '#clinical_outcome' do
    let(:outcome1) { { "k10"=>1, "honos"=>2, "demoralisation"=>3, "basis32"=>4,
                       "srs1"=>4, "srs2"=>5, "srs3"=>6, "srs4"=>7 } }
    let(:outcome2) { { "srs1"=>21,             "srs3"=>23, "srs4"=>24 } }
    let(:outcome3) { { "srs1"=>31, "srs2"=>32,             "srs4"=>34 } }
    let(:outcome4) { { "k10"=>9, "honos"=>8,                      "basis32"=>6,
                       "srs1"=>5, "srs2"=>4, "srs3"=>3, "srs4"=>nil } }

    let(:user) { {"name" => 'Teddy'} }

    context 'user with 4 appointments' do
      let(:user) {
        { "name" => 'Teddy',
          "clinicalOutcomes"=> { "1"=> outcome1, "2"=> outcome2, "3"=> outcome3, "4"=> outcome4 } }
      }

      it 'should get the clinical outcomes value in correct order' do
        expected_value = [ 1,2,3,4,4,5,6,7, 21,nil,23,24, 31,32,nil,34, 9,8,nil,6,5,4,3,nil ]
        clinical_outcome(user).should eq expected_value
      end
    end

    context 'user with one interim appointments' do
      let(:user) {
        { "name" => 'Teddy',
          "clinicalOutcomes"=> { "1"=> outcome1, "2" => outcome2, "4"=> outcome4 } }
      }

      it 'should only fill the start and final appointment column' do
        expected_value = [ 1,2,3,4,4,5,6,7, 21,nil,23,24, nil,nil,nil,nil, 9,8,nil,6,5,4,3,nil ]
        clinical_outcome(user).should eq expected_value
      end
    end
    context 'user without interim appointments' do
      let(:user) {
        { "name" => 'Teddy',
          "clinicalOutcomes"=> { "1"=> outcome1, "4"=> outcome4 } }
      }

      it 'should only fill the start and final appointment column' do
        expected_value = [ 1,2,3,4,4,5,6,7, nil,nil,nil,nil, nil,nil,nil,nil, 9,8,nil,6,5,4,3,nil ]
        clinical_outcome(user).should eq expected_value
      end
    end

    context 'user without clinicalOutcome' do
      it 'return empty array' do
        clinical_outcome(user).should eq []
      end
    end
  end
end
