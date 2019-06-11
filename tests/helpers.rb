require 'JSON'

# class RequestHandlerTest < RequestHandler
# end

# class ApplicationControllerTest < ApplicationController
# end

# class ApplicationViewTest < ApplicationView
# end

def extract_mock_data
  raw_json_data = File.read(File.join(Dir.pwd, 'tests', 'example.json'))
  processed_json_data = JSON.parse(raw_json_data).to_s
end
