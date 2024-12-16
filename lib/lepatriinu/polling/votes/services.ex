defmodule Lepatriinu.Votes.Services do
  @moduledoc """
  Services for votes.
  """

  alias Lepatriinu.Votes

  defmodule CastVoteService do
    def call(attrs) do
      with {:ok, vote} <- Votes.create(attrs) do
        :ok =
          Phoenix.PubSub.broadcast(
            Lepatriinu.PubSub,
            "poll_votes:#{vote.poll_id}",
            {:user_voted, vote}
          )

        {:ok, vote}
      end
    end
  end
end
