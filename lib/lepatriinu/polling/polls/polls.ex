defmodule Lepatriinu.Polls do
  alias Lepatriinu.Polls.Poll
  alias Lepatriinu.Repo

  @doc """
  Creates a new poll with the given attributes.
  """
  def create(attrs \\ %{}) do
    %Poll{}
    |> Poll.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns a list of all polls.
  """
  def get_all do
    Repo.all(Poll)
  end

  @doc """
  Returns a specific poll.
  """
  def get(id) do
    Repo.get(Poll, id)
  end
end
