require 'rspec'
require './model/application_server.rb'
require './controller/application_controller.rb'
require './view/application_view.rb'
require_relative 'helpers.rb'

class RequestHandlerTest < RequestHandler
end

class ApplicationControllerTest < ApplicationController
  def self.retrieve_paginated_array
    @@paginated_array
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

# RSpec.describe ApplicationController do
#   describe '#menu_control' do
#     context ': leads to the get all tickets method when inputted "v"' do
#       before(:each) { allow(ApplicationController).to receive(:get_input).and_return('v') }

#       specify { expect { ApplicationController.menu_control }.to output(/(Loading)/).to_stdout }
#       # specify { expect { ApplicationController.menu_control }.to output(/^.*(subject|id|401|404|400|503).*$/).to_stdout }
#     end

#     context ': leads to the single ticket method when inputted s' do
#       before(:each) { allow(ApplicationController).to receive(:get_input).and_return('s') }

#       # specify { expect { ApplicationController.menu_control }.to output(/ID/).to_stdout }
#     end

#     context ': leads to the quit method when inputted "q"' do
#       before(:each) { allow(ApplicationController).to receive(:get_input).and_return('q') }

#       specify { expect { ApplicationController.menu_control }.to output(/Goodbye!/).to_stdout }
#     end

#     context ': leads to the invalid input method when inputted any other character' do
#       before(:each) { allow(ApplicationController).to receive(:get_input).and_return('k') }

#       specify { expect { ApplicationController.menu_control }.to output(/^.*(erroneous|input).*$/).to_stdout }
#     end

#     context ': leads to the error handler when receiving error responses ' do
#       before(:each) { allow(RequestHandler).to receive(:api_requester).and_return(401) }
#       before(:each) { allow(RequestHandler).to receive(:retrieve_all_tickets).and_return(401) }
#       before(:each) { allow(RequestHandler).to receive(:get_input).and_return('v') }

#       specify { expect { ApplicationController.menu_control }.to_output(/^.*(401).*$/) }
#     end

#     context ': leads to the error handler when receiving error responses ' do
#       before(:each) { allow(RequestHandler).to receive(:api_requester).and_return(404) }
#       before(:each) { allow(RequestHandler).to receive(:retrieve_all_tickets).and_return(404) }
#       before(:each) { allow(RequestHandler).to receive(:get_input).and_return('v') }

#       specify { expect { ApplicationController.menu_control }.to_output(/^.*(404).*$/) }
#     end
    
#     context ': leads to the error handler when receiving error responses ' do
#       before(:each) { allow(RequestHandler).to receive(:api_requester).and_return(503) }
#       before(:each) { allow(RequestHandler).to receive(:retrieve_all_tickets).and_return(503) }
#       before(:each) { allow(RequestHandler).to receive(:get_input).and_return('v') }

#       specify { expect { ApplicationController.menu_control }.to_output(/^.*(503).*$/) }
#     end

#     context ': leads to the error handler when receiving error responses ' do
#       before(:each) { allow(RequestHandler).to receive(:api_requester).and_return(400) }
#       before(:each) { allow(RequestHandler).to receive(:retrieve_all_tickets).and_return(400) }
#       before(:each) { allow(RequestHandler).to receive(:get_input).and_return('v') }

#       specify { expect { ApplicationController.menu_control }.to_output(/^.*(400).*$/) }
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


RSpec.describe ApplicationController do
  describe '#show_all' do
    # context 'shows the correct paginated array first' do
    #   before(:each) do 
    #     allow(ApplicationModel).to receive(:display_readifier).and_return(test_tickets) 
    #     ApplicationController.show_all
    #   end

    #   specify { expect(ApplicationControllerTest.retrieve_paginated_array).to eq(test_tickets) }
    # end  

    context 'shows the first paginated list when run' do
      specify { expect { ApplicationController.show_all }.to_output(/^.*(Sample|Ticket).*$/) }
    end
  end
end