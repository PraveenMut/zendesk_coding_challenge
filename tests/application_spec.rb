require 'rspec'
require './model/application_server.rb'
require './controller/application_controller.rb'
require './view/application_view.rb'

RSpec.describe RequestHandler do
  describe '#api_requester' do
    it 'returns a 200 response for 1 request' do
      expect(RequestHandler.api_requester(nil, 1)).not_to eq(401 || 404 || 503 || 400)
    end
  end
end

RSpec.describe RequestHandler do
  describe '#api_requester' do
    it 'returns a 200 response for all ticket requests' do
      expect(RequestHandler.api_requester(true)).not_to eq(401 || 404 || 503 || 400)
    end
  end
end

RSpec.describe RequestHandler do
  describe '#api_requester' do
    it 'populates a response successfully for controller to work on' do
      expect(RequestHandler.api_requester(true)).not_to be_falsey
      expect(RequestHandler.api_requester(nil, 1)).not_to be_falsey
    end
  end
end

RSpec.describe RequestHandler do
  describe "#api_requester" do
    it 'ensures that errorenous ticket id requests are handled' do
      expect(RequestHandler.api_requester(nil, 5000)).to eq(404)
    end
  end
end

RSpec.describe RequestHandler do
  describe "#retrieve_all_tickets" do
    it "ensures that all tickets are retrieved safely without handling issues" do
      expect(RequestHandler.retrieve_all_tickets).to include("tickets")
    end
  end
end

RSpec.describe RequestHandler do
  describe "#retrieve_single_ticket" do
    it "ensures that a single ticket is retrieved safely without handling issues" do
      expect(RequestHandler.retrieve_single_ticket(1)).to include("ticket")
      expect(RequestHandler.retrieve_single_ticket(100)).to include("ticket")
      expect(RequestHandler.retrieve_single_ticket(5000)).to eq(404)
    end
  end
end

RSpec.describe ApplicationController do
  let(:error_santiser_handling) { RequestHandler.retrieve_single_ticket(5000) }
  subject { error_santiser_handling }

  describe "#sanitiser" do
    context "the data is successfully retrieved from the model" do
      expect(ApplicationController.santiser).to be_truthy
    end

    context "the data is an error response as a mock test" do
      expect(subject()).to eq(404)
    end

    context "the data isn't an error response" do
      expect(ApplicationController.santiser).to include("ticket")
    end 

    context "the data is a valid array and is subdivided" do
      expect(ApplicationController.santiser.length).to eq(4)
    end
  end
end