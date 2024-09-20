defmodule Galaxy.Multimedia.Video do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  @primary_key {:id, Galaxy.Multimedia.Permalink, autogenerate: true}

  schema "videos" do
    field :description, :string
    field :title, :string
    field :url, :string
    field :slug, :string

    belongs_to :user, Galaxy.Accounts.User
    belongs_to :category, Galaxy.Multimedia.Category
    has_many :annotations, Galaxy.Multimedia.Annotation  # Add this line

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(video, attrs) do
    video
    |> cast(attrs, [:url, :title, :description, :category_id])
    |> validate_required([:url, :title, :description])
    |> assoc_constraint(:category)
    |> slugify_title()
  end

  defp slugify_title(changeset) do
    case fetch_change(changeset, :title) do
      {:ok, new_title} -> put_change(changeset, :slug, slugify(new_title))
      :error -> changeset
    end
  end

  defp slugify(str) do
    str
    |> String.downcase()
    |> String.replace(~r/[^\w-]+/u, "-")
  end

  # Fetch annotations for a given video ID
  def get_annotations(video_id) do
    from(a in Galaxy.Multimedia.Annotation, where: a.video_id == ^video_id)
    |> Galaxy.Repo.all()
  end
end
