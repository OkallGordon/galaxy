defmodule GalaxyWeb.VideoHTMLTest do
  use GalaxyWeb.ConnCase, async: true
  import Phoenix.ConnTest

  # Helper function to log in a user
  defp login_user(conn) do
    user = %Galaxy.Accounts.User{id: 1, name: "Test User"}  # Mocked user
    assign(conn, :current_user, user)
  end

 @doc """

 test "renders index.html", %{conn: conn} do
    videos = [
      %Galaxy.Multimedia.Video{id: "1", title: "dogs"},
      %Galaxy.Multimedia.Video{id: "2", title: "cats"}
    ]

    # Log in the user before making the request
    conn = login_user(conn)

    conn = assign(conn, :videos, videos)
    conn = get(conn, ~p"/videos")

    content = conn.resp_body  # Access the raw response body

    assert content =~ "Listing Videos"

    for video <- videos do
      assert content =~ video.title
    end
  end
"""
  test "renders new.html", %{conn: conn} do
    changeset = Galaxy.Multimedia.change_video(%Galaxy.Multimedia.Video{})
    categories = [%Galaxy.Multimedia.Category{id: 123, name: "dogs"}]

    # Log in the user before making the request
    conn = login_user(conn)

    conn = assign(conn, :changeset, changeset)
    conn = assign(conn, :categories, categories)
    conn = get(conn, ~p"/videos/new")

    content = conn.resp_body  # Access the raw response body

    assert content =~ "New Video"
  end
end
