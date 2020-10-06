#!/usr/bin/env ruby
require_relative 'workspace'
def main
  puts "Welcome to the Ada Slack CLI!"
  workspace = Workspace.new

  puts "1. list users/n 2. list channels/n 3. quit"



  puts "Thank you for using the Ada Slack CLI"
end

main if __FILE__ == $PROGRAM_NAME