defmodule GalaxyWeb.WatchController do
  use GalaxyWeb, :controller

  alias Galaxy.Multimedia

  def show(conn, %{"id" => id}, current_user) do
    video = Multimedia.get_user_video!(current_user, id)
    render(conn, :show, video: video)
  end
end
