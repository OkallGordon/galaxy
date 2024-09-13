defmodule GalaxyWeb.AuthTest do
  use GalaxyWeb.ConnCase, async: true
  alias GalaxyWeb.Auth

  import Galaxy.TestHelpers


  setup %{conn: conn} do
    user = user_fixture()  # Create a user dynamically with a fixture or factory

    conn =
      conn
      |> bypass_through(GalaxyWeb.Router, :browser)
      |> get("/")

    {:ok, %{conn: conn, user: user}}
  end

  test "authenticate_user halts when no current_user exists", %{conn: conn} do
    conn = Auth.authenticate_user(conn, [])
    assert conn.halted
  end

  test "authenticate_user for existing current_user", %{conn: conn, user: user} do
    conn =
      conn
      |> assign(:current_user, user)  # Use dynamically created user
      |> Auth.authenticate_user([])

    refute conn.halted
  end

  test "login puts the user in the session", %{conn: conn, user: user} do
    login_conn =
      conn
      |> Auth.login(user)  # Use dynamically created user
      |> send_resp(:ok, "")

    next_conn = get(login_conn, "/")
    assert get_session(next_conn, :user_id) == user.id  # Assert dynamic user ID
  end

  test "logout drops the session", %{conn: conn, user: user} do
    logout_conn =
      conn
      |> put_session(:user_id, user.id)  # Use dynamically created user ID
      |> Auth.logout()
      |> send_resp(:ok, "")

    next_conn = get(logout_conn, "/")
    refute get_session(next_conn, :user_id)
  end

  test "call places user from session into assigns", %{conn: conn, user: user} do
    conn =
      conn
      |> put_session(:user_id, user.id)  # Use dynamically created user ID
      |> Auth.call(Auth.init([]))

    assert conn.assigns.current_user.id == user.id
  end

  test "call with no session sets current_user assign to nil", %{conn: conn} do
    conn = Auth.call(conn, Auth.init([]))
    assert conn.assigns.current_user == nil
  end
end
