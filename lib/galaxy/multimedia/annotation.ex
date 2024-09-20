defmodule Galaxy.Multimedia.Annotation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "annotations" do
    field :at, :integer
    field :body, :string
    field :user_id, :id
    field :video_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(annotation, attrs) do
    annotation
    |> cast(attrs, [:body, :at])
    |> validate_required([:body, :at])
  end
end
