defmodule Galaxy.Polls do
  alias Galaxy.Repo
  alias Galaxy.Polls.Poll

  # List all polls
  def list_polls do
    Repo.all(Poll)
  end

  # Create a new poll
  def create_poll(attrs \\ %{}) do
    %Poll{}
    |> Poll.changeset(attrs)
    |> Repo.insert()
  end

  # Fetch a poll by ID
  def get_poll!(id) do
    Repo.get!(Poll, id)
  end

  # Change an existing poll
  def change_poll(%Poll{} = poll) do
    Poll.changeset(poll, %{})  # This is typically to prepare the poll for changes
  end

  # Increment yes votes
  def increment_yes_votes(%Poll{} = poll) do
    poll
    |> Ecto.Changeset.change(yes_votes: poll.yes_votes + 1)
    |> Repo.update()
  end

  # Increment no votes
  def increment_no_votes(%Poll{} = poll) do
    poll
    |> Ecto.Changeset.change(no_votes: poll.no_votes + 1)
    |> Repo.update()
  end
end
