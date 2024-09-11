defmodule Galaxy.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:categories, [:name])
  end

  def down do
    execute "DROP INDEX IF EXISTS  categories_name_index"
    drop table(:categories)
  end
end
