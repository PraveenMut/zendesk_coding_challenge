# Introduction
Zendesk CLi is a lightweight & highly performant viewer client that shows all tickets that an agent has in their account. In addition, it has the ability to show pertinent details of a single ticket. The application interfaces with ZenDesk’s tickets API as the ‘source of truth’ to provide the associated tickets for the viewer to process and show. 

# Contents:
- Installation
- Execution
- Architecture
- Choosing CLi
- Process
  - API Requests
  - Pagination methods (Scalability)
  - Testing
  - Challenges
- Requirement checklist
- Future updates


# Installation
This application has been tested to run on MacOS X/UNIX based machines. However, due to the cross platform nature of Ruby (as it is an interpreted language), the application may work on other operating systems. 

Due to the nature of dependencies and file systems between operating systems, <b>it is strongly recommended that you run Zendesk CLi on MacOS based systems</b>. 

## Prerequisites:
 - Ruby 2.5.3 or over

To check what version of Ruby you have installed, in the terminal, enter:

```
ruby -v
```
If you do not have Ruby installed:
```
brew install ruby
```

For further information, please refer to the installation guides of Ruby:
- <a href="https://www.ruby-lang.org/en/documentation/installation" target="_blank">Installation Guide</a>

Afterwards, `git clone` the repository into your preferred directory. 

This application is designed to run with minimal dependencies for portability. The dependencies are as follows:
- HTTP
- JSON
- Formatador
- Pry (for debugging only)

The rubygems HTTP & JSON should be preinstalled with most installations of Ruby. To check whether they exist:
```
gem list | grep -E “http|json” 
```
If either only one or none appear, please install these gems:
```
gem install ‘http’
```
```
gem install ‘json’
```
Afterwards, install:
```
gem install formatador
```

# Execution

To run the program, please navigate to the git cloned repository in your terminal application. Once inside the root folder, enter:

```
ruby controller/application_controller.rb
```

Violia!

# Choosing CLi

I opted to build the application entirely in the command line as I have a deep affinity towards to the backend side of software development. I enjoy the elegance of well constructed systems and building an application through the command line allows to show the intracacies of software architecture. In addition, as I'm currently studying at a bootcamp that primarily uses Ruby, I decided to further hone down on my ruby skills. 

Due to the elegant simplicity of the project, I decided to challenge myself by attempting to undertake the project in a BDD (TDD) fashion while using RSpec, a popular testing DSL for Ruby for the first time. This later return to a more unit testing style of development due to a mis-step during coding.


# Architecture
The architecture of any software application or system is crucial and provides the foundation to build off. Poor software architecture often leads to substantial technical debt and the inability to add future features in an agile fashion. 

I considered multiple options, 

- MVP (Model View Presenter)
- MVC (Model View Controller)
- MVC with Passive View
- Event driven Architecture

I eventually chose the Model-View-Controller with Passive View. The architecture diagram is as follows:

<img src="./img/mvc-diagram.png">

The reasoning behind this choice is that the MVC architectural pattern is one of the widely used patterns and provides effective decoupling between the business logic, data retrieval and the presentation of such information to the user. However, the main reason behind the passive view was to further decouple the view from the model to ensure that the view has no ability to mutate to model, which allows for more room for error. 

This does involve additional work as data binding is done at the controller side as the view has minimal logic as possible.

Other patterns like the Event Driven architecture required substantially higher complexity and seemed to over-complicate the project of this size. Therefore, the MVC with passive view remained the clear choice. 

In summary:
- The MVC model allows for effective decoupling of business logic, data and presentation. This ensures that the structure of the program is well organised, there is a clear separation of concerns and testing can done effectively without affecting other functions.

In the Zendesk CLi: 
- Model - handles server requests and the treatment & processing of data. Statefulness through storing responses similar to a database. This is Similar to rails, node or go server.

- Controller - Queries the model and ultimately drives the program from user input. It maintains statefulness through state containers (similar to redux).

- Presentation - Presents the views to the user. Little logic as possible, completely decoupled from the model. Controller feeds in the view to show.
