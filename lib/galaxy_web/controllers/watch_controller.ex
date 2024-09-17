defmodule GalaxyWeb.WatchController do
  use GalaxyWeb, :controller

  alias Galaxy.Multimedia

  def show(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]
    video = Multimedia.get_user_video!(current_user, id)

    render(conn, "show.html", video: video)
  end
end
