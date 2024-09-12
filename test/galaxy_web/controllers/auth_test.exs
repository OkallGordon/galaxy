defmodule GalaxyWeb.AuthTest do
  use GalaxyWeb.ConnCase, async: true
  alias GalaxyWeb.Auth

  setup %{conn: conn} do

    conn =
      conn
      |> bypass_through(GalaxyWeb.Router, :browser)
      |> get("/")

  {:ok, %{conn: conn}}
  end

  test "authenticate_user halts when no current_user exists", %{conn: conn} do
    conn = Auth.authenticate_user(conn, [])
    assert conn.halted
  end

  test "authenticate_user for existing current_user", %{conn: conn} do
    conn =
      conn
      |> assign(:current_user, %Galaxy.Accounts.User{})
      |> Auth.authenticate_user([])

  refute conn.halted
  end
  end
