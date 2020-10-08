require_relative 'test_helper'
require_relative '../lib/recipient'

describe "Recipient class" do

  describe "constructor" do

    before do
      @new_recipient = Recipient.new("test_id", "test_name")
    end

    it "is an instance of Recipent" do
      expect(@new_recipient).must_be_instance_of Recipient
    end

    it "establishes the base data structures when instantiated" do
      expect(@new_recipient.slack_id).must_be_kind_of String
      expect(@new_recipient.name).must_be_kind_of String
    end

    it "correctly assigns instance variables" do
      expect(@new_recipient.slack_id).must_equal "test_id"
      expect(@new_recipient.name).must_equal "test_name"
    end

  end

  describe "self.get" do

    it "calls Slack API users.list" do
      VCR.use_cassette("get users list") do
        Recipient.get("https://slack.com/api/users.list")
      end
    end

    it  "calls Slack API conversations.list" do
      VCR.use_cassette("get conversations list") do
        Recipient.get("https://slack.com/api/conversations.list")
      end

    end

    it "will raise an exception if the request fails" do
      VCR.use_cassette("Exception for false API URL") do
        expect {
          Recipient.get("https://slack.com/api/some_incorrect_endpoint")
        }.must_raise SlackApiError
      end
    end

  end

  describe "details" do

    before do
      @new_recipient = Recipient.new("test_id", "test_name")
    end

    it "raises error when called" do
      expect{ @new_recipient.details }.must_raise NotImplementedError
    end
  end

  describe "self.list_all" do
    it "raises error when called" do
      expect { Recipient.list_all }.must_raise NotImplementedError
    end
  end

  describe "self.send_message" do
    it "posts in a channel" do
      VCR.use_cassette("post in #random channel") do
        random_channel = Recipient.new("C01BKRLQ4UF", "random")
        random_channel.send_message("test message to SlackBot")
      end
    end

    it "sends message to user" do
      VCR.use_cassette("sends SlackBot a message") do
        slackbot = Recipient.new("USLACKBOT", "slackbot")
        slackbot.send_message("test post in #random")
      end
    end
  end

end