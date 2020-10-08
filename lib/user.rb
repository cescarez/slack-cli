require_relative 'recipient'

USERS_LIST_URL = "https://slack.com/api/users.list"

class User < Recipient
  attr_reader :real_name, :status_text, :status_emoji
  def initialize(slack_id, name, real_name, status_text, status_emoji)
    super(slack_id, name)
    @real_name = real_name
    @status_text = status_text
    @status_emoji = status_emoji
  end

  def details
    return "User id: #{@slack_id}\nUsername: #{@name}\nReal name: #{@real_name}\nStatus text: #{@status_text}\nStatus emoji: #{@status_emoji}"
  end

  def self.list_all
    query = {token: ENV['SLACK_TOKEN']}

    request = self.get(USERS_LIST_URL, query: query)

    @users = request["members"].map do |user|
      self.new(user["id"],user["name"],user["real_name"],user["profile"]["status_text"],user["profile"]["status_emoji"])
      
    end
  end
end