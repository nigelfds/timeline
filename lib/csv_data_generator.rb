class CSVDataGenerator
  def header
    [ 'Name', 'UR', 'DOB', 'Gender',

      'Handoffs',
      'Direct contacts',
      'Staff involved',
      'Different IT Systems', 'Updates to IT Systems',
      'Paper records updated', 'Updates to paper records',
      'APM activities', 'APM activities that met purpose',

      'Initial appointment K10', 'Initial appointment HONOS', 'Initial appointment Demoralisation', 'Initial appointment Basis32',
      'Initial appointment SRS Q1', 'Initial appointment SRS Q2', 'Initial appointment SRS Q3', 'Initial appointment SRS Q4',

      'Interim appointment (2) SRS Q1', 'Interim appointment (2) SRS Q2', 'Interim appointment (2) SRS Q3', 'Interim appointment (2) SRS Q4',
      'Interim appointment (3) SRS Q1', 'Interim appointment (3) SRS Q2', 'Interim appointment (3) SRS Q3', 'Interim appointment (3) SRS Q4',

      'Final appointment K10', 'Final appointment HONOS', 'Final appointment Demoralisation', 'Final appointment Basis32',
      'Final appointment SRS Q1', 'Final appointment SRS Q2', 'Final appointment SRS Q3', 'Final appointment SRS Q4' ]

  end

  def data_for user, activities
    [
      demograpic_data(user),
      journey_summary(activities),
      clinical_outcome(user)
    ].flatten
  end

  def demograpic_data user
    [ user['name'], user['urNumber'], user['dob'], user['gender'] ]
  end

  def journey_summary activities
    num_handoffs = count_occurrance(activities, 'involveHandoff')
    num_direct_contacts = count_occurrance(activities, 'involveContact')
    num_staff_involved = num_uniq(activities, 'staffInvolved')

    num_updates_to_it_sys, num_diff_it_sys = num_updates_and_uniq(activities, 'itSystems')
    num_updates_to_paper_records, num_diff_paper_records = num_updates_and_uniq(activities, 'paperRecords')

    num_isAPM    = count_occurrance(activities, 'isAPM')
    num_therapeutic = count_combined_occurrance(activities, 'isAPM', 'contributesTherapeutically')

    [ num_handoffs,
      num_direct_contacts,
      num_staff_involved,
      num_diff_it_sys, num_updates_to_it_sys,
      num_diff_paper_records, num_updates_to_paper_records,
      num_isAPM, num_therapeutic ]
  end

  def clinical_outcome user
    if user["clinicalOutcomes"].nil?
      return []
    else
      [
        get_patient_outcome_and_srs(user["clinicalOutcomes"]["1"]),
        get_srs(user["clinicalOutcomes"]["2"]),
        get_srs(user["clinicalOutcomes"]["3"]),
        get_patient_outcome_and_srs(user["clinicalOutcomes"]["4"])
      ].flatten
    end

  end

  def num_updates_and_uniq activities, field
    all_values = activities.map { |activity| activity[field] }.flatten.compact

    num_updates     = all_values.length
    num_uniq_values = all_values.uniq.length

    [ num_updates, num_uniq_values ]
  end

  def num_uniq activities, field
    activities.map { |activity| activity[field] }.flatten.compact.uniq.length
  end

  def count_occurrance activities, field
    activities.map { |activity| activity[field] ? true : nil }.compact.length
  end

  def count_combined_occurrance activities, field_1, field_2
    activities.map { |activity| (activity[field_1] && activity[field_2]) ? true : nil }.compact.length
  end

  def get_patient_outcome_and_srs clinical_outcome
    if clinical_outcome.nil?
      Array.new(8, nil)
    else
      [ clinical_outcome['k10'], clinical_outcome['honos'],
        clinical_outcome['demoralisation'], clinical_outcome['basis32'],
        clinical_outcome['srs1'], clinical_outcome['srs2'],
        clinical_outcome['srs3'], clinical_outcome['srs4'] ]
    end
  end

  def get_srs clinical_outcome
    if clinical_outcome.nil?
      Array.new(4, nil)
    else
      [ clinical_outcome['srs1'], clinical_outcome['srs2'],
        clinical_outcome['srs3'], clinical_outcome['srs4'] ]
    end
  end

end
