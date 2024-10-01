defmodule Galaxy.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset



  @primary_key {:id, :id, autogenerate: true}

  schema "comments" do
    field :comment, :string
    field :topic, :string

    belongs_to :user, Galaxy.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:comment, :topic, :user_id])
    |> validate_required([:comment, :topic, :user_id])
    |> assoc_constraint(:user)
  end
end
