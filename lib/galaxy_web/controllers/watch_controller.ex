defmodule GalaxyWeb.WatchController do
  use GalaxyWeb, :controller

  alias Galaxy.Multimedia
  alias Galaxy.Repo
  alias Galaxy.Multimedia.Annotation
  import Ecto.Query

  def show(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]
    video = Multimedia.get_user_video!(current_user, id)

    annotations = Repo.all(from a in Annotation, where: a.video_id == ^video.id )

    render(conn, "show.html", video: video, annotations: annotations)

  end
end
