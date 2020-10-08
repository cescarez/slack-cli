require_relative 'test_helper'
require_relative '../lib/workspace'

# Is it most appropriate to create a whole set of false test data? Even for APIs???

describe "workspace class" do

  describe "workspace instantiation" do
    before do
      @new_workspace = Workspace.new
    end

    it "is an instance of workspace" do
      expect(@new_workspace).must_be_instance_of Workspace
    end

    it "establishes the base data structures when instantiated" do
      [:users, :channels].each do |keyword|
        expect(@new_workspace).must_respond_to keyword
      end

      expect(@new_workspace.users).must_be_kind_of Array
      expect(@new_workspace.channels).must_be_kind_of Array
    end

  end
  describe "load channels" do
    before do
      VCR.use_cassette("get conversations list") do
        @new_workspace = Workspace.new
        @new_workspace.load_channels
      end
    end
    it "populates the @channels instance variable" do
      expect(@new_workspace.channels).wont_be_empty
    end
  end

  describe "load users" do
    before do
      VCR.use_cassette("get users list") do
        @new_workspace = Workspace.new
        @new_workspace.load_users
      end
    end
    it "populates the @users instance variable" do
      expect(@new_workspace.users).wont_be_empty
    end
  end
  
  describe "select channel" do
    before do
      VCR.use_cassette("get conversations list") do
        @new_workspace = Workspace.new
        @new_workspace.load_channels
      end
    end
    it "returns a channel object" do
      found_channel = @new_workspace.select_channel("random")
      expect(found_channel).must_be_kind_of Channel
    end
    it "returns nil if object not found" do
      not_found_channel = @new_workspace.select_channel("bloop")
      expect(not_found_channel).must_be_nil
    end
  end

  describe "select user" do
    before do
      VCR.use_cassette("get users list") do
        @new_workspace = Workspace.new
        @new_workspace.load_users
      end
    end
    it "returns a user object" do
      found_user = @new_workspace.select_user("slackbot")
      expect(found_user).must_be_kind_of User
    end
    it "returns nil if object not found" do
      not_found_user = @new_workspace.select_user("bloop")
      expect(not_found_user).must_be_nil
    end
  end

  describe "show details" do
    before do
      @new_workspace = Workspace.new
      VCR.use_cassette("get users list") do
        @new_workspace.load_users
      end
      VCR.use_cassette("get conversations list") do
        @new_workspace.load_channels
      end
    end
    it "returns String for user object" do
      found_user = @new_workspace.select_user("slackbot")

      expect(@new_workspace.show_details(found_user)).must_be_kind_of String
    end
    it "returns String for channel object" do
      found_channel = @new_workspace.select_channel("random")

      expect(@new_workspace.show_details(found_channel)).must_be_kind_of String
    end
    it "returns message for no details available" do
      found_channel = @new_workspace.select_channel("nope")
      expect(@new_workspace.show_details(found_channel)).must_equal "No recipient available to display details"
    end
    it "returns message for no details available" do
      found_user = @new_workspace.select_user("nope2.0")
      expect(@new_workspace.show_details(found_user)).must_equal "No recipient available to display details"
    end
  end
end