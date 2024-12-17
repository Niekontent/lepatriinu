defmodule LepatriinuWeb.PollDetailsLive do
  use LepatriinuWeb, :live_view

  import LepatriinuWeb.PollComponents

  alias Lepatriinu.Polling
  alias LepatriinuWeb.Helpers.PollHelper

  @impl true
  def render(assigns) do
    ~H"""
    <div class="border-2 border-solid border-black">
      <div class="bg-rose-300 border-b-2 border-solid border-black px-2">
        POLL
      </div>

      <%= if @user_voted? do %>
        <.poll_results poll={@poll} percentage_results={@percentage_results} />
      <% else %>
        <.poll_voting poll={@poll} phx_click="vote" />
      <% end %>
    </div>
    """
  end

  @impl true
  def mount(%{"poll_id" => id}, session, socket) do
    %{"user_id" => user_id} = session

    poll = Polling.current().get_poll(id)
    user_voted? = Polling.current().user_voted?(user_id, poll.id)

    percentage_results =
      poll.id
      |> Polling.current().count_poll_votes()
      |> PollHelper.results_in_percentage()

    if connected?(socket) do
      Phoenix.PubSub.subscribe(Lepatriinu.PubSub, "poll_votes:#{id}")
    end

    socket =
      socket
      |> assign(poll: poll)
      |> assign(user_id: user_id)
      |> assign(user_voted?: user_voted?)
      |> assign(percentage_results: percentage_results)

    {:ok, socket}
  end

  @impl true
  def handle_event("vote", %{"option" => option}, socket) do
    %{poll: %{id: poll_id}, user_id: user_id} = socket.assigns

    vote_params = %{poll_id: poll_id, user_id: user_id, selected_option: option}

    {:ok, _vote} = Polling.current().vote(vote_params)

    socket =
      socket
      |> assign_poll_results()
      |> assign(user_voted?: true)

    {:noreply, socket}
  end

  @impl true
  def handle_info({:user_voted, _vote}, socket) do
    socket = assign_poll_results(socket)

    {:noreply, socket}
  end

  defp assign_poll_results(socket) do
    %{poll: %{id: poll_id}} = socket.assigns

    percentage_results =
      poll_id
      |> Polling.current().count_poll_votes()
      |> PollHelper.results_in_percentage()

    assign(socket, percentage_results: percentage_results)
  end
end
