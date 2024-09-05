defmodule GalaxyWeb.VideoController do
  use GalaxyWeb, :controller

  plug GalaxyWeb.Auth, :authenticate_user when action in [:index, :show, :new, :create, :edit, :update, :delete]

  alias Galaxy.Multimedia
  alias Galaxy.Multimedia.Video

  def index(conn, _params, current_user) do
    videos = Multimedia.list_user_videos(current_user)
    render(conn, :index, videos: videos)
  end

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def new(conn, _params, _current_user) do
    changeset = Multimedia.change_video(%Video{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"video" => video_params}, _current_user) do
    case Multimedia.create_video(conn.assigns.current_user, video_params) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Your video has been created successfully.")
        |> redirect(to: ~p"/videos/#{video}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    video = Multimedia.get_user_video!(current_user, id)
    render(conn, :show, video: video)
  end

  def edit(conn, %{"id" => id}, current_user) do
    video = Multimedia.get_user_video!(current_user, id)
    changeset = Multimedia.change_video(video)
    render(conn, :edit, video: video, changeset: changeset)
  end

  def update(conn, %{"id" => id, "video" => video_params}, current_user) do
    video = Multimedia.get_user_video!(current_user, id)

    case Multimedia.update_video(video, video_params) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video updated successfully.")
        |> redirect(to: ~p"/videos/#{video}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, video: video, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    video = Multimedia.get_user_video!(current_user, id)
    {:ok, _video} = Multimedia.delete_video(video)

    conn
    |> put_flash(:info, "Video deleted successfully.")
    |> redirect(to: ~p"/videos")
  end
end
