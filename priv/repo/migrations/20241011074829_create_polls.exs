defmodule Galaxy.Repo.Migrations.CreatePolls do
  use Ecto.Migration

  def change do
    create table(:polls) do
      add :question, :string, null: false
      add :yes_votes, :integer, default: 0
      add :no_votes, :integer, default: 0

      timestamps()
    end
  end
end
