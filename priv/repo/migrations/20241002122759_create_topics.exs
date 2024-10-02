defmodule Galaxy.Repo.Migrations.CreateTopics do
  use Ecto.Migration

  def change do
    create table(:topics) do
      add :summary, :string

      timestamps(type: :utc_datetime)
    end
  end
end
