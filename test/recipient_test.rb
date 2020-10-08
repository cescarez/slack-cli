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
    let (:random_channel) { Recipient.new("C01BKRLQ4UF", "random") }
    let (:slackbot) { Recipient.new("USLACKBOT", "slackbot") }

    it "posts in a channel" do
      VCR.use_cassette("post in #random channel") do
        response = random_channel.send_message("test message to SlackBot")
        expect(response["ok"]).must_equal true
      end
    end

    it "sends message to user" do
      VCR.use_cassette("sends SlackBot a message") do
        response = slackbot.send_message("test post in #random")
        expect(response["ok"]).must_equal true
      end
    end

    it "expect error_message for nil `text` to a channel" do
      VCR.use_cassette("post message to channel -- nil message") do
        expect {
          random_channel.send_message(nil)
        }.must_raise SlackApiError
      end
    end

    it "expect error_message for nil `text` to a user" do
      VCR.use_cassette("post message to user -- nil message") do
        expect {
          slackbot.send_message(nil)
        }.must_raise SlackApiError
      end
    end

    it "expect error_message for bad recipient" do
      VCR.use_cassette("Exception for post message -- bad recipient") do
        bad_recipient = Recipient.new("failure", "still a failure")
        expect {
          bad_recipient.send_message(@message)
        }.must_raise SlackApiError
      end
    end

  end

  describe "conversation_history" do
    let (:random_channel) { Recipient.new("C01BKRLQ4UF", "random") }
    let (:slackbot) { Recipient.new("USLACKBOT", "slackbot") }

    #User conversation history doesn't work -- possible need conversation.replies or user.conversations
    it "shows conversation history of user" do
      VCR.use_cassette("conversation history of slackbot") do
        response = slackbot.conversation_history
        expect(response["ok"]).must_equal true
      end
    end

    it "shows conversation history of channel" do
      VCR.use_cassette("conversation history of #random") do
        response = random_channel.conversation_history
        expect(response["ok"]).must_equal true
      end
    end

  end

end