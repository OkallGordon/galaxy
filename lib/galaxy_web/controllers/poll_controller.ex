defmodule GalaxyWeb.PollController do
  use GalaxyWeb, :controller
  alias Galaxy.Polls
  alias Galaxy.Polls.Poll

  # Index: List all polls
  def index(conn, _params) do
    polls = Polls.list_polls()
    render(conn, :index, polls: polls)
  end

  # Show a form for creating a new poll
  def new(conn, _params) do
    changeset = Polls.change_poll(%Poll{})  # For creating a new poll
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"poll" => poll_params}) do
    case Polls.create_poll(poll_params) do
      {:ok, _poll} ->
        conn
        |> put_flash(:info, "Poll created successfully.")
        |> redirect(to: ~p"/polls")  # Using ~p sigil for path
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end


  # Show a specific poll
  def show(conn, %{"id" => id}) do
    poll = Polls.get_poll!(id)
    render(conn, "show.html", poll: poll)
  end

  # Handle voting (Yes/No)
  def vote(conn, %{"id" => id, "vote" => vote}) do
    poll = Polls.get_poll!(id)

    case vote do
      "yes" -> Polls.increment_yes_votes(poll)
      "no" -> Polls.increment_no_votes(poll)
    end

    conn
    |> put_flash(:info, "Thank you for voting!")
    |> redirect(to: ~p"/polls/#{poll.id}") # Redirect to the poll show page after voting
  end
end
