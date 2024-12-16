defmodule Lepatriinu.Repo.Migrations.CreateVotes do
  use Ecto.Migration

  def change do
    create table(:votes) do
      add :user_id, references(:users)
      add :poll_id, references(:polls)
      add :selected_option, :string

      timestamps()
    end

    create unique_index(:votes, [:user_id, :poll_id], name: :unique_user_vote_per_poll)
  end
end
