require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

    def setup
      @user = users(:michael)
      @other_user = users(:archer)
      @micropost = @user.microposts.build(context:"Lorem ipsum" )
    end

    test "should be valid" do
      assert @micropost.valid?
    end

    test "user_id should present" do
      @micropost.user_id = nil
      assert_not @micropost.valid?
    end

    test "context should be presence" do
      @micropost.context = " "
      assert_not @micropost.valid?
    end

    test "context should not be too long" do
      @micropost.context = "a" * 141
      assert_not @micropost.valid?
    end

    test "order should be most recent" do
      assert_equal microposts(:most_recent), Micropost.first
    end

end
