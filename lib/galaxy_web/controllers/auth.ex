defmodule GalaxyWeb.Auth do
  import Plug.Conn
  import Phoenix.Controller
  alias Phoenix.Token
  alias GalaxyWeb.Endpoint
  alias Galaxy.Accounts


  @token_salt "user socket salt"

  # Plug init
  def init(opts), do: opts

  # Plug call, to fetch the current user and assign them to the connection
  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)
    user_token = get_session(conn, :user_token)

    user =
      cond do
        conn.assigns[:current_user] ->
          conn.assigns[:current_user]

        user_id && Accounts.get_user(user_id) ->
          Accounts.get_user(user_id)

        user_token && verify_user_token(user_token) ->
          case verify_user_token(user_token) do
            {:ok, user} -> user
            _ -> nil
          end

        true ->
          nil
      end

    assign(conn, :current_user, user)
    |> assign(:user_token, user_token)
  end

  # Function to handle user login
  def login(conn, user) do
    token = generate_user_token(user)  # Generate token for the user
     IO.inspect(token, label: "Generated token")

    conn
    |> put_session(:user_id, user.id)      # Store user ID in the session
    |> put_session(:user_token, token)      # Store the user token in the session
    |> assign(:current_user, user)          # Assign the current user
    |> configure_session(renew: true)       # Renew the session
  end

  # Function to log the user out
  def logout(conn) do
    configure_session(conn, drop: true)
  end

  # Authentication check for protected routes
  def authenticate_user(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "Sorry, you must be logged in to access this page")
      |> redirect(to: "/sessions/new")
      |> halt()
    end
  end

  # Generate token for a user to be used in WebSocket authentication
  defp generate_user_token(user) do
    Token.sign(Endpoint, @token_salt, user.id)
  end

  # Verify the token when connecting via WebSocket
  def verify_user_token(token) do
    IO.inspect(token, label: "Verifying token")
    case Token.verify(Endpoint, @token_salt, token, max_age: 86400) do
      {:ok, user_id} ->
        IO.inspect(user_id, label: "User ID extracted from token")
        case Accounts.get_user(user_id) do
          nil ->
            IO.puts("User not found for ID: #{user_id}")
            {:error, :user_not_found}
          user ->
            {:ok, user}
        end
      _error ->
        IO.puts("Token verification failed")
        {:error, :invalid_token}
    end
  end

  def get_user_by_token(token) do
    case verify_user_token(token) do
      {:ok, user} -> user  # Return the user directly
      _ ->
        IO.puts("Failed to get user by token: #{token}")
        nil
    end
  end
end
