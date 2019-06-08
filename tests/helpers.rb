require 'JSON'

raw_json_data = File.read(File.join(Dir.pwd, 'tests','example_ticket.json'))
processed_json_data = JSON.parse(raw_json_data, :symbolize_names => true)
tickets_data = processed_json_data[:tickets]
test_tickets = []

tickets_data.each do |hash|
  test_tickets << hash
end
