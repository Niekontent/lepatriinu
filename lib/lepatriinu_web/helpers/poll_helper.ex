defmodule LepatriinuWeb.Helpers.PollHelper do
  @moduledoc """
  Provides helper functions for polls.
  """

  @spec results_in_percentage(map()) :: map()
  def results_in_percentage(poll_results) do
    total = Enum.reduce(poll_results, 0, fn {_answer, count}, acc -> acc + count end)

    if total == 0 do
      %{}
    else
      Enum.reduce(poll_results, %{}, fn {answer, count}, acc ->
        percentage = (count / total * 100) |> Float.round(2)
        Map.put(acc, answer, percentage)
      end)
    end
  end
end
