defmodule GalaxyWeb.SessionController do
  use GalaxyWeb, :controller

  alias Galaxy.Accounts

  def new(conn, _params) do
    render(conn, "new.html")
  end


  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Accounts.authenticate_by_email_and_pass(email, password) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: ~p"/")

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid email or password")
        |> render("new.html")
    end
  end


 def delete(conn, _param) do
   conn
   |> configure_session( drop: true)
   |> put_flash(:info, "You are logged out successfully")
   |> redirect(to: ~p"/")
 end
end
