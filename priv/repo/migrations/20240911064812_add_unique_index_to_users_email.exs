defmodule Galaxy.Repo.Migrations.AddUniqueIndexToUsersEmail do
  use Ecto.Migration


  def change do
    execute("""
      DO $$
      BEGIN
        IF NOT EXISTS (
          SELECT 1
          FROM pg_class c
          JOIN pg_namespace n ON n.oid = c.relnamespace
          WHERE c.relname = 'users_email_index'
        ) THEN
          CREATE UNIQUE INDEX users_email_index ON users(email);
        END IF;
      END$$;
    """)
  end
end
