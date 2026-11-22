require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "invalid email and password show a temporary error" do
    get login_path
    post login_path, params: { session: { email: "", password: "" } }
    assert_response :unprocessable_entity
    assert_template "sessions/new"
    assert_not is_logged_in?
    assert_select "div.alert-danger", "Invalid email/password combination"
    get root_path
    assert flash.empty?
    assert_select "div.alert-danger", count: 0
  end

  test "valid email with wrong password does not log in" do
    post login_path, params: { session: { email: @user.email, password: "wrong" } }
    assert_response :unprocessable_entity
    assert_not is_logged_in?
    assert_select "div.alert-danger"
  end

  test "unknown email does not log in" do
    post login_path, params: { session: { email: "missing@example.com", password: "password" } }
    assert_response :unprocessable_entity
    assert_not is_logged_in?
  end

  test "valid login changes navigation and persists across requests" do
    get root_path
    assert_select "a[href=?]", login_path
    post login_path, params: { session: { email: @user.email.upcase, password: "password" } }
    assert is_logged_in?
    assert_equal @user.id, session[:user_id]
    assert_redirected_to @user
    follow_redirect!
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?][data-turbo-method=delete]", logout_path
    assert_select "a[href=?]", user_path(@user)
    assert_select "#account[aria-controls=dropdown-menu]"
    get help_path
    assert is_logged_in?
    assert_select "a[href=?]", user_path(@user)
  end

  test "logout clears the session and restores anonymous navigation" do
    post login_path, params: { session: { email: @user.email, password: "password" } }
    delete logout_path
    assert_response :see_other
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
    get help_path
    assert_not is_logged_in?
  end

  test "repeated logout is safe" do
    2.times do
      delete logout_path
      assert_response :see_other
      assert_not is_logged_in?
    end
  end

  test "a session pointing to a deleted user is treated as anonymous" do
    post login_path, params: { session: { email: @user.email, password: "password" } }
    @user.destroy!
    get root_path
    assert_response :success
    assert_select "a[href=?]", login_path
    assert_select "#account", count: 0
  end
end
