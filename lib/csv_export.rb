def csv_header
  [ 'Name', 'UR', 'Age (DOB)', 'Gender',

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

def journey_summary user_id
  activities = db["activities"].find(:user_id => user_id).to_a

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
