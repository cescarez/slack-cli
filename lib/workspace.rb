require_relative '../test/test_helper'
require_relative 'user'
require_relative 'channel'

USERS_LIST_URL = "https://slack.com/api/users.list"

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

  def error_message(response)
    if response.code != 200 || response["ok"] != true
      return "API request failed with error code #{response.code} and #{response["error"]}."
    else
      return response
    end
  end

end


