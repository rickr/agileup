defmodule Agileup.SessionControllerTest do
  use Agileup.ConnCase

  @tag :skip
  test "displays the login page", %{conn: conn} do
    conn = get conn, session_path(conn, :new)
    assert html_response(conn, 200) =~ "Login"
  end

  @tag :skip
  test "new users are redirected to settings" do
  end

  @tag :skip
  test "new users are added to the db" do
  end

  @tag :skip
  test "existing users are redirected to settings" do
  end

end
