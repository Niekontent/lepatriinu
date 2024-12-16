defmodule LepatriinuWeb.PollComponents do
  @moduledoc """
  Provides poll UI components.
  """
  use Phoenix.Component

  alias Lepatriinu.Polls.Poll

  attr :poll, Poll, required: true
  attr :navigate, :string, required: true

  def poll_tile(assigns) do
    ~H"""
    <div class="border-2 border-solid border-black w-3/4 h-16 flex justify-between mb-2">
      <div class="flex flex-col ml-2 mt-2 uppercase">
        <span>{@poll.question}</span>
        <span class="text-xs">
          CREATED {Timex.format!(@poll.inserted_at, "{YYYY}-{0M}-{D}")}
        </span>
      </div>
      <div class="flex items-end">
        <.link
          navigate={@navigate}
          class="border-2 border-solid border-black px-4 m-2 hover:bg-amber-400"
        >
          DETAILS
        </.link>
      </div>
    </div>
    """
  end

  attr :poll, Poll, required: true
  attr :percentage_results, :map, required: true

  def poll_results(assigns) do
    ~H"""
    <div class="uppercase flex flex-col items-center my-4">
      <div
        :for={option <- @poll.options}
        class="flex justify-between w-3/4 border-b-2 border-solid border-black mb-4"
      >
        <span>{option}</span>
        <span>{Map.get(@percentage_results, option, 0)}%</span>
      </div>
    </div>
    """
  end

  attr :poll, Poll, required: true
  attr :phx_click, :string, required: true

  def poll_voting(assigns) do
    ~H"""
    <div class="uppercase">
      <div class="flex justify-center my-4">{@poll.question}</div>

      <div class="flex flex-col items-center">
        <button
          :for={option <- @poll.options}
          type="button"
          class="border-2 border-solid border-black w-1/2 mb-2 uppercase hover:bg-amber-400"
          phx-click="vote"
          phx-value-option={option}
        >
          {option}
        </button>
      </div>
    </div>
    """
  end
end
