defmodule Galaxy.Topics.Topic do
  use Ecto.Schema
  import Ecto.Changeset

  schema "topics" do
    field :summary, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(topic, attrs) do
    topic
    |> cast(attrs, [:summary])
    |> validate_required([:summary])
  end
end
