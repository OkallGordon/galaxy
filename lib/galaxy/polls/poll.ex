defmodule Galaxy.Polls.Poll do
  use Ecto.Schema
  import Ecto.Changeset

  schema "polls" do
    field :question, :string
    field :yes_votes, :integer, default: 0
    field :no_votes, :integer, default: 0

    timestamps()
  end

  @doc false
  def changeset(poll, attrs) do
    poll
    |> cast(attrs, [:question, :yes_votes, :no_votes])
    |> validate_required([:question])
  end
end
