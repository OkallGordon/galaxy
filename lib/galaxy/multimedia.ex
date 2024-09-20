defmodule Galaxy.Multimedia do
  @moduledoc """
  The Multimedia context.
  """

  import Ecto.Query, warn: false
  alias Galaxy.Repo
  alias Galaxy.Multimedia.{Video, Annotation, Category}
  alias Galaxy.Accounts

  @doc """
  Returns the list of videos.

  ## Examples

      iex> list_user_videos(user)
      [%Video{}, ...]
  """
  def list_user_videos(%Accounts.User{} = user) do
    Video
    |> user_videos_query(user)
    |> Repo.all()
  end

  @doc """
  Gets a single video.

  Raises `Ecto.NoResultsError` if the Video does not exist.

  ## Examples

      iex> get_user_video!(user, 123)
      %Video{}

      iex> get_user_video!(user, 456)
      ** (Ecto.NoResultsError)
  """
  def get_user_video!(current_user, id) do
    Video
    |> where(user_id: ^current_user.id)
    |> preload(:annotations)  # Preload annotations here if you want to fetch them directly
    |> Repo.get!(id)
  end


  defp user_videos_query(query, %Accounts.User{id: user_id}) do
    from(v in query, where: v.user_id == ^user_id)
  end

  @doc """
  Creates a video.

  ## Examples

      iex> create_video(user, %{field: value})
      {:ok, %Video{}}

      iex> create_video(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def create_video(%Accounts.User{} = user, attrs \\ %{}) do
    %Video{}
    |> Video.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  @doc """
  Updates a video.

  ## Examples

      iex> update_video(video, %{field: new_value})
      {:ok, %Video{}}

      iex> update_video(video, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def update_video(%Video{} = video, attrs) do
    video
    |> Video.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a video.

  ## Examples

      iex> delete_video(video)
      {:ok, %Video{}}

      iex> delete_video(video)
      {:error, %Ecto.Changeset{}}
  """
  def delete_video(%Video{} = video) do
    Repo.delete(video)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking video changes.

  ## Examples

      iex> change_video(video, attrs)
      %Ecto.Changeset{data: %Video{}}
  """
  def change_video(%Video{} = video, attrs \\ %{}) do
    Video.changeset(video, attrs)
  end

  @doc """
  Gets all annotations for a specific video.

  ## Examples

      iex> get_annotations(video_id)
      [%Annotation{}, ...]
  """
  def get_annotations(video_id) do
    Repo.all(from a in Annotation, where: a.video_id == ^video_id)
  end

  @doc """
  Returns the list of annotations for a specific video.

  ## Examples

      iex> list_annotations_for_video(video_id)
      [%Annotation{}, ...]
  """
  def list_annotations_for_video(video_id) do
    Annotation
    |> where(video_id: ^video_id)
    |> Repo.all()
  end

  def create_annotation(attrs) do
    changeset = %Annotation{}
    |> Annotation.changeset(attrs)

    case Repo.insert(changeset) do
      {:ok, annotation} ->
        {:ok, annotation}
      {:error, _changeset} ->
        {:error, :failed_to_create_annotation}
    end
  end

  def create_category!(name) do
    Repo.insert!(%Category{name: name}, on_conflict: :nothing)
  end

  def list_alphabetical_categories do
    Category
    |> Category.alphabetical()
    |> Repo.all()
  end
end
