defmodule GalaxyWeb.SessionController do
  use GalaxyWeb, :controller

  alias Galaxy.Accounts

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Accounts.authenticate_by_email_and_pass(email, password) do
      {:ok, user} ->
        greeting = get_greeting()
        token = Phoenix.Token.sign(conn, "user socket", user.id)

        conn
        |> put_session(:user_token, token)  # Store the token in the session
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "#{greeting}, #{user.name}, Welcome Back!")
        |> assign(:user_token, token)  # Assign the user token
        |> redirect(to: ~p"/")

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid email or password")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> put_flash(:info, "It's sad to see you leave. Welcome Back next time!")
    |> redirect(to: ~p"/")
  end

  defp get_greeting do
    current_hour = :calendar.local_time() |> elem(1) |> elem(0)

    cond do
      current_hour < 12 -> "Good morning"
      current_hour < 18 -> "Good afternoon"
      true -> "Good evening"
    end
  end
end
