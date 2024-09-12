defmodule GalaxyWeb.Auth do
  import Plug.Conn

  import Phoenix.Controller


  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)

    cond do
      conn.assigns[:current_user] ->
        conn
    user = user_id && Galaxy.Accounts.get_user(user_id) ->
    assign(conn, :current_user, user)

    true ->
      assign(conn, :current_user, nil)
    end
  end

 def login(conn, user) do
   conn
   |> assign(:current_user, user)
   |> put_session(:user_id, user.id)
   |> configure_session(renew: true)
 end

 def logout(conn) do
   configure_session(conn, drop: true)
 end

 def authenticate_user(conn, _opts) do
   if conn.assigns.current_user do
     conn
   else
    conn
    |> put_flash(:error, "Sorry you must be logged in to access this page")
    |> redirect(to: "/sessions/new")
    |> halt()
   end
  end
end
