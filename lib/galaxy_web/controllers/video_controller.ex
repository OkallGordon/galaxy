defmodule GalaxyWeb.VideoController do
  use GalaxyWeb, :controller

  plug GalaxyWeb.Auth, :authenticate_user when action in [:index, :show, :new, :create, :edit, :update, :delete]

  alias Galaxy.Multimedia
  alias Galaxy.Multimedia.Video

  def index(conn, _params) do
    videos = Multimedia.list_videos()
    render(conn, :index, videos: videos)
  end

  def new(conn, _params) do
    changeset = Multimedia.change_video(%Video{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"video" => video_params}) do
    case Multimedia.create_video(video_params) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video created successfully.")
        |> redirect(to: ~p"/videos/#{video}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    video = Multimedia.get_video!(id)
    render(conn, :show, video: video)
  end

  def edit(conn, %{"id" => id}) do
    video = Multimedia.get_video!(id)
    changeset = Multimedia.change_video(video)
    render(conn, :edit, video: video, changeset: changeset)
  end

  def update(conn, %{"id" => id, "video" => video_params}) do
    video = Multimedia.get_video!(id)

    case Multimedia.update_video(video, video_params) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video updated successfully.")
        |> redirect(to: ~p"/videos/#{video}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, video: video, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    video = Multimedia.get_video!(id)
    {:ok, _video} = Multimedia.delete_video(video)

    conn
    |> put_flash(:info, "Video deleted successfully.")
    |> redirect(to: ~p"/videos")
  end
end
