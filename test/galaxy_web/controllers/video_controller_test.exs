defmodule GalaxyWeb.VideoControllerTest do
  use GalaxyWeb.ConnCase, async: true

  import Galaxy.TestHelpers
  alias Galaxy.Multimedia

  @create_attrs %{
    url: "http://youtu.be",
    title: "vid",
    description: "a vid"
  }

  @invalid_attrs %{title: "invalid"}

  defp video_count, do: Enum.count(Multimedia.list_videos())

  setup %{conn: conn} do
    conn = conn |> delete_session(:user_id)
    {:ok, conn: conn}
  end

  describe "when no user is logged in" do
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

        assert conn.status == 302
        assert redirected_to(conn) == ~p"/sessions/new"
      end)
    end
  end

  describe "for logged-in users" do
    setup %{conn: conn, login_as: email} do
      user = user_fixture(email: email)
      conn = assign(conn, :current_user, user)
      {:ok, conn: conn, user: user}
    end

    @tag login_as: "test@example.com"
    test "lists all user's videos", %{conn: conn, user: user} do
      # Create a video associated with the logged-in user
      user_video = video_fixture(user, title: "funny cats")
      other_user = user_fixture(email: "other@example.com")
      other_video = video_fixture(other_user, title: "another video")

      # Fetch the videos for the logged-in user
      conn = get(conn, ~p"/videos")

      # Assertions
      assert html_response(conn, 200) =~ "Listing Videos"
      assert String.contains?(conn.resp_body, user_video.title)
      refute String.contains?(conn.resp_body, other_video.title)
    end

    @tag login_as: "max@example.com"
    test "creates user video and redirects", %{conn: conn, user: user} do
      create_conn =
        post(conn, ~p"/videos", video: @create_attrs)

      assert %{id: id} = redirected_params(create_conn)
      assert redirected_to(create_conn) == ~p"/videos/#{id}"

      conn = get(conn, ~p"/videos/#{id}")
      assert html_response(conn, 200) =~ "Show Video"
      assert Multimedia.get_video!(id).user_id == user.id
    end

    @tag login_as: "max@example.com"
    test "does not create video, renders errors when invalid", %{conn: conn} do
      count_before = video_count()

      conn =
        post(conn, ~p"/videos", video: @invalid_attrs)

      assert html_response(conn, 200) =~ "check the errors"
      assert video_count() == count_before
    end
  end

  describe "authorization cases" do
    test "authorizes actions against access by other users", %{conn: conn} do
      owner = user_fixture(email: "owner@example.com")
      video = video_fixture(owner, @create_attrs)
      non_owner = user_fixture(email: "sneaky@example.com")
      conn = assign(conn, :current_user, non_owner)

      assert_error_sent :not_found, fn ->
        get(conn, ~p"/videos/#{video.id}")
      end

      assert_error_sent :not_found, fn ->
        get(conn, ~p"/videos/#{video.id}/edit")
      end

      assert_error_sent :not_found, fn ->
        put(conn, ~p"/videos/#{video.id}", video: @create_attrs)
      end

      assert_error_sent :not_found, fn ->
        delete(conn, ~p"/videos/#{video.id}")
      end
    end
  end
end
