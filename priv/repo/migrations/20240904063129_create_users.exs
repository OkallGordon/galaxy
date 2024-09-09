defmodule Galaxy.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
  create table(:users) do
    add :name, :string
    add :email, :string
    add :password_hash, :string
    add :user_id, references(:users, on_delete: :delete_all)
    create unique_index(:users, [:email])

    timestamps(type: :utc_datetime)

  end
end
end
