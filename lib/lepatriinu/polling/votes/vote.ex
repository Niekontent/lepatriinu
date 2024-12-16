defmodule Lepatriinu.Votes.Vote do
  use Ecto.Schema
  import Ecto.Changeset

  alias Lepatriinu.Accounts.User
  alias Lepatriinu.Polls.Poll

  @type t :: %__MODULE__{
          id: integer(),
          poll_id: integer(),
          user_id: integer(),
          selected_option: String.t(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  schema "votes" do
    belongs_to :poll, Poll
    belongs_to :user, User
    field :selected_option, :string

    timestamps()
  end

  @required ~w(user_id poll_id selected_option)a

  def changeset(vote, attrs) do
    vote
    |> cast(attrs, @required)
    |> validate_required(@required)
    |> unique_constraint([:user_id, :poll_id], name: :unique_user_vote_per_poll)
  end
end
