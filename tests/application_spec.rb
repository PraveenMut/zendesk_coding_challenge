require 'rspec'
require './model/application_server.rb'
require './controller/application_controller.rb'
require './view/application_view.rb'

RSpec.describe RequestHandler do
  describe '#api_requester' do
    it 'returns a 200 response for 1 request' do
      expect(RequestHandler.api_requester(nil, 1)).not_to eq("Authentication failed, check your credentials" ||
      "API endpoint access failure" || "Cannot access API" || "API unavailable at this time, check again later")
    end
  end
end

RSpec.describe RequestHandler do
  describe '#api_requester' do
    it 'returns a 200 response for all ticket requests' do
      expect(RequestHandler.api_requester(true)).not_to eq("Authentication failed, check your credentials" ||
      "API endpoint access failure" || "Cannot access API" || "API unavailable at this time, check again later")
    end
  end
end

RSpec.describe RequestHandler do
  describe '#api_requester' do
    it 'populates a response successfully for controller to work on' do
      expect(RequestHandler.api_requester).not_to be_empty
    end
  end
end

