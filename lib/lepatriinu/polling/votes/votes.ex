defmodule Lepatriinu.Votes do
  @moduledoc """
  Context module for managing votes.
  """

  import Ecto.Query

  alias Lepatriinu.Repo
  alias Lepatriinu.Votes.Vote

  @doc """
  Creates a vote with the given attributes.
  """
  def create(attrs \\ %{}) do
    %Vote{}
    |> Vote.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Counts poll votes.
  """
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
  def user_voted?(user_id, poll_id) do
    from(v in Vote,
      where: v.user_id == ^user_id and v.poll_id == ^poll_id
    )
    |> Repo.exists?()
  end
end
