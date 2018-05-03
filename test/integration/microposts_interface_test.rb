require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end


  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination' , count: 1
    # 無効な投稿
    assert_no_difference 'Micropost.count'  do
      post microposts_path, params: { micropost: { context: "" } }
    end
    assert_select 'div#error_explanation'

    #有効な投稿
    context  = "Foo Bar"
    assert_difference 'Micropost.count' , 1 do
      post microposts_path, params: { micropost: { context: context } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match context,response.body #投稿が表示されていることを確認

    assert_select 'a' , text:'delete'

    first_micropost = @user.microposts.paginate(page: 1).first

    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end

    # 違うユーザーのプロフィールにアクセス (削除リンクがないことを確認)
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
  end

  test "micropost sidebar count" do
   log_in_as(@user)
   get root_path
   assert_match "34 microposts", response.body
   # まだマイクロポストを投稿していないユーザー
   other_user = users(:malory)
   log_in_as(other_user)
   get root_path
   assert_match "0 microposts", response.body
   other_user.microposts.create!(context: "A micropost")
   get root_path
   assert_match "1 micropost", response.body
 end
end
