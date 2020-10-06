require_relative 'test_helper'

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
      @new_workspace = Workspace.new
      @new_workspace.load_channels
      @channel_list = @new_workspace.channels
    end

    it "populates the array" do
      expect(@channel_list).wont_be_empty
    end

    it "@channels is an array of hashes" do
      expect(@channel_list).must_be_kind_of Array
      expect(@channel_list.all? { |channel| channel.class == Hash }).must_equal true
    end

    it "correctly loads list of channels" do
      current_channels = ["general", "random", "slackcli"]
      expect(@channel_list.each { |channel| current_channels.include?(channel[:name]) })
      expect(@channel_list.length).must_equal 3
    end

  end
  describe "load users" do
    before do
      @new_workspace = Workspace.new
      @new_workspace.load_users
      @user_list = @new_workspace.users
    end
    it "populates the array" do
      expect(@user_list).wont_be_empty
    end

    it "@users is an array of hashes" do
      expect(@user_list).must_be_kind_of Array
      expect(@user_list.all? { |user| user.class == Hash }).must_equal true
    end

    it "correctly loads list of channels" do
      current_users = ["slackbot", "gomezrc1220", "water_christabel_slac", "christabel.escarez", "waterrachaelapi_proje",  ]
      expect(@user_list.each { |user| current_users.include?(user[:name]) })
      expect(@user_list.length).must_equal 5
    end

  end
end