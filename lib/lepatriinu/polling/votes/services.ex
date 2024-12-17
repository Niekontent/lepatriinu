defmodule Lepatriinu.Votes.Services do
  @moduledoc """
  Services for votes.
  """

  alias Lepatriinu.Votes

  defmodule CastVoteService do
    @doc """
    Creates a vote with the given attributes
    and broadcasts an event.
    """

    @spec call(map()) :: {:ok, Vote.t()} | {:error, Ecto.Changeset.t()}
    def call(attrs) do
      with {:ok, vote} <- Votes.create(attrs),
           :ok <- broadcast_user_voted(vote) do
        {:ok, vote}
      end
    end

    @spec broadcast_user_voted(Vote.t()) :: :ok | {:error, term()}
    defp broadcast_user_voted(vote) do
      Phoenix.PubSub.broadcast(
        Lepatriinu.PubSub,
        "poll_votes:#{vote.poll_id}",
        {:user_voted, vote}
      )
    end
  end
end
