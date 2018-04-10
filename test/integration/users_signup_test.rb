require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post user_index_path ,params:{user:{ name: "" ,
                              email: "user@invalid" ,
                              password: "foo" ,
                              password_confirmation: "bar"
                              }}
    end
    assert_select 'form[action="/signup"]'
  end

  test "invalid signup information2" do
    get signup_path
    assert_no_difference 'User.count' do
      post user_index_path ,params:{user:{ name: "Test" ,
                              email: "" ,
                              password: "foo" ,
                              password_confirmation: "bar"
                              }}
    end
    assert_select 'form[action="/signup"]'
  end

  test "invalid signup information3" do
    get signup_path
    assert_no_difference 'User.count' do
      post user_index_path ,params:{user:{ name: "" ,
                              email: "user@invalid" ,
                              password: "bar" ,
                              password_confirmation: "bar"
                              }}
    end
    assert_select 'form[action="/signup"]'
  end

  test "signup information" do
    get signup_path
    assert_difference 'User.count' , 1 do
      post user_index_path ,params:{user:{ name: "Test" ,
                              email: "user@invalid.com" ,
                              password: "foobar" ,
                              password_confirmation: "foobar"
                              }}
    end
    follow_redirect!
    assert_template  'user/show'
    assert_not flash.empty?
  end


end
