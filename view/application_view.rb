class ApplicationView

  def self.welcome_screen
    print "\n\n"
    print "_____                  __          __  \n"
    print "/__  /  ___  ____  ____/ /__  _____/ /__\n"
    print "  / /  / _ \/ __ \/ __  / _ \/ ___/ //_/\n"
    print " / /__/  __/ / / / /_/ /  __(__  ) ,<   \n"
    print "/____/\___/_/ /_/\__,_/\___/____/_/|_|  \n"
    print "\n\n"
    print "Welcome to the Zendesk Ticket Viewer!\n\n"
    print "This program is a lightweight ticket viewer.\n"
    print "It show you how many tickets you have as agent.\n"
    print "To continue, please select one of the options:\n\n"
  end

  def self.print_main_menu
    print "\nInput Options:\n"
    print "\n[v] Enter V to access all tickets\n"
    print "[s] Enter S to show a single ticket by its id\n"
    print "[q] Enter Q to quit the program\n\n"
  end

  def self.load_all_tickets
    print "\nThank you. Loading all tickets"
    sleep(0.5)
    print "."
    sleep(0.25)
    print "."
    sleep(0.175)
    print ".\n"
  end

  def self.load_single_ticket(ticket_id)
    print "\nThank you. Loading Ticket ID##{ticket_id}"
    sleep(0.5)
    print " ."
    sleep(0.25)
    print "."
    sleep(0.175)
    print ".\n"
  end

  def self.show_all_tickets
  end

  def self.show_single_ticket
  end

  def self.error_handler(message, error_code)
    if !message.nil? || !error_code.nil?
      print "\nSorry! We have encountered an error: #{message} the error code is #{error_code}\n"
      return 1
    else
      print "\nSorry! An unknown error has occured. Please restart the program.\n"
      return -1
    end
  end
end