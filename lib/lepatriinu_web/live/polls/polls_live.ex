defmodule LepatriinuWeb.PollsLive do
  use LepatriinuWeb, :live_view

  import LepatriinuWeb.PollComponents

  alias Lepatriinu.Polling

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-52 border-2 border-solid border-black">
      <div class="bg-amber-400 border-b-2 border-solid border-black px-2">
        POLLS
      </div>

      <div class="flex flex-col items-center my-6">
        <%= if Enum.empty?(@polls) do %>
          <div class="flex justify-center py-2">
            Ops! It seems there are no polls.
          </div>
        <% else %>
          <.poll_tile :for={poll <- @polls} poll={poll} navigate={~p"/#{poll.id}"} />
        <% end %>
      </div>

      <div class="flex flex-row justify-center py-2">
        <.link navigate={~p"/new"} class="border-2 border-solid border-black px-4 hover:bg-amber-400">
          ADD POLL
        </.link>
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    polls = Polling.current().get_all_polls()

    {:ok, assign(socket, polls: polls)}
  end
end
