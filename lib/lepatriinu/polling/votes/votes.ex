defmodule Lepatriinu.Votes do
  @moduledoc """
  The Votes context.
  """

  import Ecto.Query

  alias Lepatriinu.Repo
  alias Lepatriinu.Votes.Vote

  @doc """
  Creates a vote with the given attributes.
  """
  @spec create(map()) :: {:ok, Vote.t()} | {:error, Ecto.Changeset.t()}
  def create(attrs \\ %{}) do
    %Vote{}
    |> Vote.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Counts poll votes.
  """
  @spec count_poll_votes(integer()) :: map()
  def count_poll_votes(poll_id) do
    from(v in Vote,
      where: v.poll_id == ^poll_id,
      group_by: v.selected_option,
      select: {v.selected_option, count(v.id)}
    )
    |> Repo.all()
    |> Enum.into(%{})
  end

  @doc """
  Checks if user voted in the poll.
  """
  @spec user_voted?(integer(), integer()) :: boolean()
  def user_voted?(user_id, poll_id) do
    from(v in Vote,
      where: v.user_id == ^user_id and v.poll_id == ^poll_id
    )
    |> Repo.exists?()
  end
end
