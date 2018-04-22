require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

def setup
  @user = users(:michael)
end

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path ,params:{user:{ name: "" ,
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
      post users_path ,params:{user:{ name: "Test" ,
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
      post users_path ,params:{user:{ name: "" ,
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
      post users_path ,params:{user:{ name: "Test" ,
                              email: "user@invalid.com" ,
                              password: "foobar" ,
                              password_confirmation: "foobar"
                              }}
    end
    follow_redirect!
    assert_template  'users/show'
    assert_not flash.empty?
    assert is_logged_in?
  end

  test "login with valid information" do
    get login_path
    post login_path , params:{session: {email: @user.email, password: 'password'}}

    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path , count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)

    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path , count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
end
