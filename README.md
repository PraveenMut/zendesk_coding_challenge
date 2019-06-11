# Introduction
Zendesk CLi is a lightweight & highly performant viewer client that shows all tickets that an agent has in their account. In addition, it has the ability to show pertinent details of a single ticket. The application interfaces with ZenDesk’s tickets API as the ‘source of truth’ to provide the associated tickets for the viewer to process and show. 

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
