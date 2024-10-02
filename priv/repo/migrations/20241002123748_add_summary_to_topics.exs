defmodule Galaxy.Repo.Migrations.AddSummaryToTopics do
  use Ecto.Migration

  def change do
    execute("""
    DO $$
    BEGIN
      IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_name = 'topics'
        AND column_name = 'summary'
      ) THEN
        ALTER TABLE topics ADD COLUMN summary text;
      END IF;
    END $$;
    """)
  end
end
