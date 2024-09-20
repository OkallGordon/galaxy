defmodule GalaxyWeb.VideoController do
  use GalaxyWeb, :controller

  alias Galaxy.Multimedia
  alias Galaxy.Multimedia.Video

  plug GalaxyWeb.Auth, :authenticate_user when action in [:index, :show, :new, :create, :edit, :update, :delete]
  plug :load_categories when action in [:new, :create, :edit, :update]

  def index(conn, _params, current_user) do
    videos = Multimedia.list_user_videos(current_user)
    render(conn, "index.html", videos: videos)
  end

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def new(conn, _params, _current_user) do
    categories = Multimedia.list_alphabetical_categories()
    IO.inspect(categories, label: "Categories")
    changeset = Multimedia.change_video(%Video{})
    render(conn, :new, changeset: changeset, categories: categories)
  end

  def create(conn, %{"video" => video_params}, current_user) do
    case Multimedia.create_video(current_user, video_params) do
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
    annotations = Multimedia.get_annotations(video.id)  # Fetch annotations for the video
    render(conn, :show, video: video, annotations: annotations)  # Pass annotations to the view
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

  defp load_categories(conn, _) do
    assign(conn, :categories, Multimedia.list_alphabetical_categories())
  end
end
