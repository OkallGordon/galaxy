defmodule Galaxy.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pbkdf2


  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :version, :integer, default: 1

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :version])
    |> validate_required([:email, :name])
    |> validate_length(:name, min: 4, max: 10)
    |> validate_length(:email, max: 20)
    |> validate_format(:email, ~r/@/, message: "Email must contain @")
    |> unique_constraint(:email)

  end


@doc """
  Creates a changeset for registration with password hashing.
  """
  def registration_changeset(user, attrs) do
    user
    |> changeset(attrs)
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 6,  max: 20)
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    case get_change(changeset, :password) do
      nil -> changeset
      password ->
        put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(password))
    end
  end

  # other functions like `changeset/2` if needed

  end
