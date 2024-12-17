defmodule Lepatriinu.Polls do
  @moduledoc """
  The Polls context.
  """

  alias Lepatriinu.Polls.Poll
  alias Lepatriinu.Repo

  @doc """
  Creates a new poll with the given attributes.
  """
  @spec create(map()) :: {:ok, Poll.t()} | {:error, Ecto.Changeset.t()}
  def create(attrs \\ %{}) do
    %Poll{}
    |> Poll.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns a list of all polls.
  """
  @spec get_all() :: list(Poll.t())
  def get_all do
    Repo.all(Poll)
  end

  @doc """
  Returns a specific poll.
  """
  @spec get(integer()) :: Poll.t()
  def get(id) do
    Repo.get(Poll, id)
  end
end
