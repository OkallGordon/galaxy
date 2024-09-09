defmodule Galaxy.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Galaxy.Repo

  alias Galaxy.Accounts.User

  alias Pbkdf2
  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  def get_user_by_email(email) do
    from(u in User, where: u.email == ^email)
    |> Repo.one()
  end


  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)


  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """

  # Function to fetch a user by email

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def change_registration(%User{} = user, params) do
    User.registration_changeset(user, params)
  end

 @doc """
  Registers a new user.
  """
  def register_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> put_password_hash()
    |> Repo.insert()
  end

  def authenticate_by_email_and_pass(email, given_password) do
    user = Repo.get_by(User, email: email)

    case user do
      nil -> {:error, "Invalid email or password"}
      %User{password_hash: nil} -> {:error, "Invalid email or password"}
      %User{password_hash: password_hash} ->
        if Pbkdf2.verify_pass(given_password, password_hash) do
          {:ok, user}
        else
          {:error, "Invalid email or password"}
        end
    end
  end

  defp put_password_hash(changeset) do
    case changeset do
    %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
   Ecto.Changeset.put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(pass))
    _ ->
    changeset
    end
  end
end
