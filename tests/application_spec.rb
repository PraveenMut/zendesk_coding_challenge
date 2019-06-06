require 'rspec'
require './model/application_server.rb'
require './controller/application_controller.rb'
require './view/application_view.rb'

class RequestHandlerTest < RequestHandler
end

class ApplicationControllerTest < ApplicationController
  attr_accessor :input_test
  def initialize
    @input_test = @@input
  end
end

class ApplicationViewTest < ApplicationView
end

RSpec.describe RequestHandler do
  describe '#api_requester' do
    it ': returns a 200 response for all requests' do
      expect(RequestHandler.api_requester(nil, 1)).not_to eq(401 || 404 || 503 || 400)
      expect(RequestHandler.api_requester(true)).not_to eq(401 || 404 || 503 || 400)
    end
  end
end

RSpec.describe RequestHandler do
  describe '#api_requester' do
    it ': populates a response successfully for controller to work on' do
      expect(RequestHandler.api_requester(true)).not_to be_falsey
      expect(RequestHandler.api_requester(nil, 1)).not_to be_falsey
      expect(RequestHandler.api_requester(true)["tickets"].length).to eq(100)
      expect(RequestHandler.api_requester(nil, 1)).to include("ticket")
    end
  end
end

RSpec.describe RequestHandler do
  describe "#api_requester" do
    it ': ensures that errorenous ticket id requests are handled' do
      expect(RequestHandler.api_requester(nil, 5000)).to eq(404)
    end
  end
end

RSpec.describe RequestHandler do
  describe "#retrieve_all_tickets" do
    it ": ensures that all tickets are retrieved safely without handling issues" do
      expect(RequestHandler.retrieve_all_tickets).to include("tickets")
    end
  end
end

RSpec.describe RequestHandler do
  describe "#retrieve_single_ticket" do
    it ": ensures that a single ticket is retrieved safely without handling issues" do
      expect(RequestHandler.retrieve_single_ticket(1)).to include("ticket")
      expect(RequestHandler.retrieve_single_ticket(100)).to include("ticket")
      expect(RequestHandler.retrieve_single_ticket(5000)).to eq(404)
    end
  end
end

RSpec.describe ApplicationView do
  describe "#error_handler" do
    it ": handles errors correctly" do
      expect(ApplicationView.error_handler("Cannot access API", 400)).to eq(1)
      expect(ApplicationView.error_handler("Authentication failed, please check your credentials", 401)).to eq(1)
      expect(ApplicationView.error_handler(nil, nil)).to eq(-1)
    end
  end
end

RSpec.describe ApplicationView do
  describe "error_handler" do
    context "displays errors correctly to screen" do
      specify { expect { ApplicationView.error_handler("Cannot Access API", 400) }.to output.to_stdout }
      specify { expect { ApplicationView.error_handler("Bad Request. Cannot Access API", 400) }.to output(/Access API/).to_stdout }
      specify { expect { ApplicationView.error_handler("Authentication failed, please check your credentials", 401) }.to output(/(Authentication)/).to_stdout }
      specify { expect { ApplicationView.error_handler("API unavailable at this time, check again later", 503)}.to output(/(unavailable)/).to_stdout }
      specify { expect { ApplicationView.error_handler(nil, nil)}.to output(/unknown/).to_stdout }
    end
  end
end

# RSpec.describe ApplicationController do
#   let(:input_tester) { ApplicationControllerTest.new }
#   subject( { input_tester })
#   describe "#menu_control" do
#     context "correct inputs leads to either an error response or getAllTickets or getSingleTickets method" do
#       specify { expect { input_tester.input_test = 'v' }.to output(/^.*(subject|id|401|404|400|503).*$/).to_stdout }
#       specify { expect { input_tester.input_test = "s"}.to output(/(Enter)/).to_stdout }
#       specify { expect { input_tester.input_test = "q"}.to output(/(Goodbye)/).to_stdout }
#     end

#     context "invalid input leads to a please try again error" do
#       specify { expect {input_tester.input_test = 'viewer'}.to output(/Invalid/).to_stdout }
#       specify { expect {input_tester.input_test = 'shdfj'}.to output(/Invalid/).to_stdout }
#       specify { expect {input_tester.input_test = nil}.to output(/Invalid/).to_stdout }
#     end
#   end
# end

RSpec.describe ApplicationModel do
  let(:page_limit) { 25 }
  describe "#paginator" do
    context "expect the resultant parent array length to be 4" do
      specify { expect(ApplicationModel.paginator((1..100).to_a, page_limit).length).to eq(4) }
    end

    context "expect the resultant parent array length to be 8" do
      specify { expect(ApplicationModel.paginator((1..200).to_a, page_limit).length).to eq(8) }
    end

    context "expect the resultant parent array length to be empty" do
      specify { expect(ApplicationModel.paginator([], page_limit).length).to eq(0) }
    end

    context "expect an invalid input to return an empty array" do
      specify { expect(ApplicationModel.paginator("error_input", page_limit).length).to eq(0) }
    end
  end
end

