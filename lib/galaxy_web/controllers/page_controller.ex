defmodule GalaxyWeb.PageController do
  use GalaxyWeb, :controller

  def home(conn, _params) do
    user_token = get_session(conn, :user_token)

    render(conn, "home.html", user_token: user_token)
  end
end
