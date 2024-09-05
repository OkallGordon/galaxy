defmodule Galaxy.Multimedia do
  @moduledoc """
  The Multimedia context.
  """

  import Ecto.Query, warn: false
  alias Galaxy.Repo

  alias Galaxy.Multimedia.Video

  alias Galaxy.Accounts

  @doc """
  Returns the list of videos.

  ## Examples

      iex> list_videos()
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

      iex> get_video!(123)
      %Video{}

      iex> get_video!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_video!(%Accounts.User{} = user, id) do
    Video
    |> user_videos_query(user)
    |> Repo.get!(id)
  end

  defp user_videos_query(query, %Accounts.User{id: user_id}) do
    from(v in query, where: v.user_id ==^user_id)
  end

  @doc """
  Creates a video.

  ## Examples

      iex> create_video(%{field: value})
      {:ok, %Video{}}

      iex> create_video(%{field: bad_value})
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

      iex> change_video(video)
      %Ecto.Changeset{data: %Video{}}

  """
  def change_video(%Video{} = video, attrs \\ %{}) do
    Video.changeset(video, attrs)
  end
end
