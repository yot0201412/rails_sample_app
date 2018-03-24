require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get hom" do
    get static_pages_hom_url
    assert_response :success
  end

end
