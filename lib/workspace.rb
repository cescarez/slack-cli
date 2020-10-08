require_relative '../test/test_helper'
require_relative 'user'
require_relative 'channel'


class Workspace
  attr_reader :users, :channels

  def initialize
    @users = []
    @channels = []
  end

  def load_channels
    @channels = Channel.list_all
  end

  def load_users
    @users = User.list_all
  end

  def select_channel(search_term)
    return @channels.find{|channel| channel.name == search_term.downcase || channel.slack_id == search_term.upcase}
  end

  def select_user(search_term)
    return @users.find{|user| user.name == search_term.downcase || user.slack_id == search_term.upcase}
  end

  def show_details(recipient)
    if recipient
      return recipient.details
    else
      return "Invalid recipient. Unable to display details"
    end
  end

end


