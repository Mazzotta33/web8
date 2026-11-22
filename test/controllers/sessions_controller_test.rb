require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get login form" do
    get login_path
    assert_response :success
    assert_select "title", full_title("Log in")
    assert_select "form[action=?][method=post]", login_path
    assert_select "input[name='session[email]'][type=email]"
    assert_select "input[name='session[password]'][type=password]"
    assert_select "a[href=?]", signup_path
  end
end
