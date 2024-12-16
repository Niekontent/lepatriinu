defmodule LepatriinuWeb.PollCreationLive do
  use LepatriinuWeb, :live_view

  alias Lepatriinu.Polls.Poll

  @impl true
  def mount(_params, _session, socket) do
    form = %Poll{} |> Poll.changeset() |> to_form()

    socket =
      socket
      |> assign(form: form)
      |> assign(options: [""])

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.simple_form for={@form} phx-submit="save_poll" phx-change="change_poll">
      <div class="bg-amber-100 border-2 border-solid border-black">
        <div class="bg-sky-500 border-b-2 border-solid border-black px-2">
          CREATE POLL
        </div>

        <div class="flex flex-col items-center my-6">
          <input
            type="text"
            name="poll[question]"
            class="w-3/4 bg-amber-100 border-2 border-solid border-black focus:ring-transparent focus:border-black"
            placeholder="QUESTION"
            value={@form[:question].value}
          />

          <div id="options-container" class="w-3/4 flex flex-col mt-4">
            <%= for {option, index} <- Enum.with_index(@options) do %>
              <input
                type="text"
                value={option}
                name="poll[options][]"
                class="mt-2 bg-amber-100 border-2 border-solid border-black focus:ring-transparent focus:border-black"
                placeholder={"OPTION #{index + 1}"}
                label={"OPTION #{index + 1}"}
              />
            <% end %>

            <div class="flex justify-center mt-2">
              <button
                type="button"
                phx-click="add_option"
                class="border-2 border-solid border-black px-4"
              >
                ADD OPTION
              </button>
            </div>
          </div>
        </div>

        <div class="py-2 flex justify-end border-t-2 border-solid border-black">
          <button class="bg-sky-500 border-2 border-solid border-black px-4 mr-2">CREATE</button>
        </div>
      </div>
    </.simple_form>
    """
  end

  @impl true
  def handle_event("change_poll", %{"poll" => params}, socket) do
    form = %Poll{} |> Poll.changeset(params) |> to_form()

    socket =
      socket
      |> assign(form: form)
      |> assign(options: params["options"])

    {:noreply, socket}
  end

  def handle_event("add_option", params, socket) do
    options = socket.assigns.options ++ [""]
    {:noreply, assign(socket, options: options)}
  end

  def handle_event("save_poll", %{"poll" => params}, socket) do
    case Lepatriinu.Polling.current().create_poll(params) do
      {:ok, _poll} ->
        {:noreply, push_navigate(socket, to: "/")}

      {:error, _changeset} ->
        socket =
          socket
          |> put_flash(:error, "dupa!")

        {:noreply, socket}
    end
  end
end
