require 'rspec'
require './model/application_server.rb'
require './controller/application_controller.rb'
require './view/application_view.rb'
require_relative 'helpers'

# Describes the api requester handling requests
RSpec.describe RequestHandler do
  describe '#api_requester' do
    it ': returns a 200 response for all requests' do
      expect(RequestHandler.api_requester(nil, 1)).not_to eq(401 || 404 || 503 || 400)
      expect(RequestHandler.api_requester(true)).not_to eq(401 || 404 || 503 || 400)
    end
  end
end

# Tests if the next_page_requester successfully pushes tickets into the existing array
# of hashes
RSpec.describe RequestHandler do
  describe '#next_page_requester' do
    context ': it successfully returns an hashes of new tickets' do
      before(:each) { ApplicationModel.sanitised_response = [{}, {}, {}] }
        specify { expect(RequestHandler.next_page_requester(2)).to be_truthy }
      after(:all) do
        expect(ApplicationModel.retrieve_tickets_data.length).to eq(103)
      end
    end
  end
end

# Tests whether an invalid input does not result in an catastrophic failure
# of the application and instead returns an empty array which gets appended to
# master
RSpec.describe RequestHandler do
  describe '#next_page_requester' do
    it ': returns a an empty array when an page an invalid id is inputted' do
      expect(RequestHandler.next_page_requester('J').class).to eq(Array)
      expect(RequestHandler.next_page_requester('J').length).to eq(0)
    end
  end
end

# ensures that api requester does not result in a nil response
# for happy paths
RSpec.describe RequestHandler do
  describe '#api_requester' do
    it ': populates a response successfully for controller to work on' do
      expect(RequestHandler.api_requester(true)).not_to be_falsey
      expect(RequestHandler.api_requester(nil, 1)).not_to be_falsey
      expect(RequestHandler.api_requester(true)[:tickets].length).to eq(100)
      expect(RequestHandler.api_requester(nil, 1)).to include(:ticket)
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

# ensures that tickets that are requested do have the tickets key
RSpec.describe RequestHandler do
  describe "#retrieve_all_tickets" do
    it ": ensures that all tickets are retrieved safely without handling issues" do
      expect(RequestHandler.retrieve_all_tickets).to include(:tickets)
    end
  end
end

RSpec.describe RequestHandler do
  describe "#retrieve_single_ticket" do
    it ": ensures that a single ticket is retrieved safely without handling issues" do
      expect(RequestHandler.retrieve_single_ticket(1)).to include(:ticket) # happy path test
      expect(RequestHandler.retrieve_single_ticket(100)).to include(:ticket) # happy path test
      expect(RequestHandler.retrieve_single_ticket(5000)).to eq(404) # sad path test
    end
  end
end

RSpec.describe ApplicationView do
  describe "#error_handler" do
    it ": handles errors correctly" do
      expect(ApplicationView.error_handler("Cannot access API", 400)).to eq(1)
      expect(ApplicationView.error_handler("Authentication failed, please check your credentials", 401)).to eq(1)
      expect(ApplicationView.error_handler(nil, nil)).to eq(-1) # ensures for no catastrophic failures
    end
  end
end

# application view test to see if the error handler does indeed actually output errors
RSpec.describe ApplicationView do
  describe "#error_handler" do
    context ": displays errors correctly to screen" do
      specify { expect { ApplicationView.error_handler("Cannot Access API", 400) }.to output.to_stdout }
      specify { expect { ApplicationView.error_handler("Bad Request. Cannot Access API", 400) }.to output(/Access API/).to_stdout }
      specify { expect { ApplicationView.error_handler("Authentication failed, please check your credentials", 401) }.to output(/(Authentication)/).to_stdout }
      specify { expect { ApplicationView.error_handler("API unavailable at this time, check again later", 503)}.to output(/(unavailable)/).to_stdout }
      specify { expect { ApplicationView.error_handler(nil, nil)}.to output(/unknown/).to_stdout }
    end
  end
end

# paginator tests -- ensure that the paginator is working correctly and paginates
# any sort of array of arrays
RSpec.describe ApplicationModel do
  let(:page_limit) { 25 }
  describe "#paginator" do
    context "expect the resultant parent array length to be 4" do
      specify { expect(ApplicationModel.paginator((1..100).to_a, page_limit).length).to eq(4) }
    end

    context "expect the resultant parent array length to be 8" do
      specify { expect(ApplicationModel.paginator((1..200).to_a, page_limit).length).to eq(8) }
    end

    context "expect the resultant parent array length to be 5" do
      specify { expect(ApplicationModel.paginator((1..101).to_a, page_limit).length).to eq(5) }
    end

    context "expect the resultant parent array to be 40" do
      specify { expect(ApplicationModel.paginator((1..1000).to_a, page_limit).length).to eq(40) }
    end

    context "expect the resultant last child array to only have 1 element" do
      specify { expect(ApplicationModel.paginator((1..101).to_a, page_limit)[4].length).to eq(1) }
      specify { expect(ApplicationModel.paginator((1..1001).to_a, page_limit)[40].length).to eq(1) }
    end

    context "expect the resultant parent array length to be empty" do
      specify { expect(ApplicationModel.paginator([], page_limit).length).to eq(0) }
    end

    context "expect an invalid input to return an empty array" do
      specify { expect(ApplicationModel.paginator("error_input", page_limit).length).to eq(0) }
    end

    context "expect subarrays to have have the page limit number of elements" do
      specify { expect(ApplicationModel.paginator((1..100).to_a, page_limit)[0].length).to eq(page_limit) }
    end

    context "expect subarrays to have have the page limit number of elements" do
      specify { expect(ApplicationModel.paginator((1..100).to_a, page_limit)[1].length).to eq(page_limit) }
    end

    # context "expect subarrays to have have the page limit number of elements" do
    #   specify { expect { |e| ApplicationModel.paginator((1..100).to_a, page_limit).each(e.length).to yield_successive_args(25,25,25,75) }
    # end

  end
end

# happy path test to ensure that the date formatter works as expected
RSpec.describe ApplicationModel do
  let(:input) { [{:updated_at => "2019-06-03T08:19:28Z"}] }
  let(:input_hash) { {:updated_at => "2019-06-03T08:19:28Z", :created_at => "2019-06-03T08:19:28Z"} }
    it "returns the hash with a clean date and time without any letters" do
      expect(ApplicationModel.date_formatter(input)).to eq([{:updated_at => "2019-06-03 08:19:28"}])
    end
    it 'returns the hash with a clean date and time' do
      expect(ApplicationModel.date_formatter(input_hash)).to eq({:updated_at => "2019-06-03 08:19:28", :created_at => "2019-06-03 08:19:28"})
    end
end

# simulates user input essentially by having breakpoints
# this ensures that if errors do occur, they are handled gracefully 
RSpec.describe ApplicationController do
  describe '#select_ticket_menu' do
    it 'successfully returns to show single ticket method' do
      expect(ApplicationController.select_ticket_menu(true, 1)).to eq(0)
    end

    context 'successfully returns an error response to a 404 message' do
      specify { expect(ApplicationController.select_ticket_menu(true, 5000)).to eq(-1) }
    end

    context 'successfully a returns an error response to all other messages' do
      before(:each) { allow(RequestHandler).to receive(:retrieve_single_ticket).and_return(400) }

      specify { expect(ApplicationController.select_ticket_menu(true, 6)).to eq(1) }
    end

    context 'successfully a returns an error response to all other messages' do
      before(:each) { allow(RequestHandler).to receive(:retrieve_single_ticket).and_return(503) }

      specify { expect(ApplicationController.select_ticket_menu(true, 6)).to eq(1) }
    end

    context 'successfully a returns an error response to all other messages' do
      before(:each) { allow(RequestHandler).to receive(:retrieve_single_ticket).and_return(401) }

      specify { expect(ApplicationController.select_ticket_menu(true, 6)).to eq(1) }
    end
  end
end

## Test if the ticket gets displayed properly in the viewer
RSpec.describe ApplicationView do
  let(:input_data) { RequestHandler.retrieve_single_ticket(5)[:ticket] }
    describe '#show_single_ticket' do
      context 'it successfully shows a ticket' do  
      specify { expect { ApplicationView.show_single_ticket(input_data) }.to output(/(aliquip)/).to_stdout }
    end
  end
end


## Attempted to mock data and see if the show_single_ticket method 
## outputted with a 5.json
## Kept getting errors when attempting to use extract_mock_data. Aborted due to 
## time constraints.
# RSpec.describe ApplicationController do
#   context "setup tests" do
#     let(:expected_data) { extract_mock_data }
#     subject { expected_data }
#       describe "#show_single_ticket" do
#         context "the function returns the correct data" do
#           before(:each) { allow(ApplicationModel).to receive(:retrieve_tickets_data).and_return(subject) }
#           specify { expect(ApplicationController.show_single).to match(/(5.json)/) }
#       end
#     end
#   end
# end


