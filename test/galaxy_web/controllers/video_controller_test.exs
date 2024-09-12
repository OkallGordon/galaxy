defmodule GalaxyWeb.VideoControllerTest do
  use GalaxyWeb.ConnCase, async: true

  setup %{conn: conn} do
    # Ensure no user is authenticated in the test setup
    conn = conn |> delete_session(:user_id)
    {:ok, conn: conn}
  end

  test "requires user authentication on all actions", %{conn: conn} do
    paths_and_methods = [
      {"/videos/new", :get, nil},
      {"/videos", :get, nil},
      {"/videos/123", :get, nil},
      {"/videos/123/edit", :get, nil},
      {"/videos/123", :put, %{}},
      {"/videos", :post, %{}},
      {"/videos/123", :delete, nil}
    ]

    Enum.each(paths_and_methods, fn {path, method, params} ->
      conn = case {method, params} do
        {:get, _} -> get(conn, path)
        {:put, params} -> put(conn, path, params)
        {:post, params} -> post(conn, path, params)
        {:delete, _} -> delete(conn, path)
      end

      # Assert that the response is a redirect
      assert conn.status == 302

      # Assert that the redirect location is the login page
      assert redirected_to(conn) == ~p"/sessions/new"
    end)
  end
end
