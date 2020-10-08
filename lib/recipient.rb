require_relative 'slack_api_error'

POST_MESSAGE_URL = "https://slack.com/api/chat.postMessage"

class Recipient
  attr_reader :slack_id, :name

  def initialize(slack_id, name)
    @slack_id = slack_id
    @name = name
  end

  def self.get(url)
    query = {token: get_slack_token}

    return error_message(HTTParty.get(url, query: query))
  end

  def details
    raise NotImplementedError, 'Implement me in a child class!'
  end

  def self.list_all
    raise NotImplementedError, 'Implement me in a child class!'
  end

  def send_message(message)
    sleep(1)
    params = {
      token: self.class.get_slack_token,
      channel: slack_id,
      text: message
    }
    HTTParty.post(POST_MESSAGE_URL, body: params)
  end

  private

  def self.get_slack_token
    return ENV["SLACK_TOKEN"]
  end

  def self.error_message(response)
    if response.code != 200 || response["ok"] != true
      raise SlackApiError, "API request failed with error code #{response.code} and #{response["error"]}."
    else
      return response
    end
  end

end