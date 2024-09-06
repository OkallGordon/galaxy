defmodule Galaxy.Repo.Migrations.AddCategoryIdToVideos do
  use Ecto.Migration

  def change do
  alter table(:videos) do
    add :categpry_id, references(:categories, on_delete: :nothing)
  end

  create index(:videos, [:category_id])
  end
end
