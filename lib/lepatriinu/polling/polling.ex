defmodule Lepatriinu.Polling do
  @moduledoc """
  Interface for Polling.
  """

  alias Lepatriinu.Polls.Poll
  alias Lepatriinu.Votes.Vote

  @doc """
  Creates a poll.
  """
  @callback create_poll(params :: map()) :: {:ok, Poll.t()} | {:error, Ecto.Changeset.t()}

  @doc """
  Fetches all polls.
  """
  @callback get_all() :: list(Poll.t())

  @doc """
  Fetches a poll.
  """
  @callback get(id :: integer()) :: Poll.t() | nil

  @doc """
  Creates a user vote in the poll.
  """
  @callback vote(params :: map()) :: {:ok, Vote.t()} | {:error, Ecto.Changeset.t()}

  @doc """
  Checks if user voted in the poll.
  """
  @callback user_voted?(user_id :: integer(), poll_id :: integer()) :: boolean()

  @doc """
  Counts poll votes.
  """
  @callback count_poll_votes(poll_id :: integer()) :: map()

  def current() do
    Lepatriinu.PollingImpl
  end
end

defmodule Lepatriinu.PollingImpl do
  @moduledoc """
  Polling implementation.
  """

  alias Lepatriinu.Polls
  alias Lepatriinu.Votes
  alias Lepatriinu.Votes.Services

  @behaviour Lepatriinu.Polling

  defdelegate create_poll(params), to: Polls, as: :create

  defdelegate get_all(), to: Polls, as: :get_all

  defdelegate get(id), to: Polls, as: :get

  defdelegate vote(params), to: Services.CastVoteService, as: :call

  defdelegate user_voted?(user_id, poll_id), to: Votes, as: :user_voted?

  defdelegate count_poll_votes(poll_id), to: Votes, as: :count_poll_votes
end
