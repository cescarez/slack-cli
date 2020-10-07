class Recipient
  attr_reader :slack_id, :name

  def initialize(slack_id, name)
    @slack_id = slack_id
    @name = name
  end
  # def send_meassage(message)
  #
  # end
  def self.get(url, params)
    return error_message(HTTParty.get(url,params))
  end

  def details
    raise NotImplementedError, 'Implement me in a child class!'
  end
  def self.list_all
    raise NotImplementedError, 'Implement me in a child class!'
  end

  private

  def self.error_message(response)
    if response.code != 200 || response["ok"] != true
      raise ArgumentError, "API request failed with error code #{response.code} and #{response["error"]}."
    else
      return response
    end
  end
end