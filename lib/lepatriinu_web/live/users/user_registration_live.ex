defmodule LepatriinuWeb.UserRegistrationLive do
  use LepatriinuWeb, :live_view

  alias Lepatriinu.Accounts
  alias Lepatriinu.Accounts.User

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.simple_form
        for={@form}
        id="registration_form"
        phx-submit="save"
        phx-change="validate"
        phx-trigger-action={@trigger_submit}
        action={~p"/users/log_in?_action=registered"}
        method="post"
      >
        <div class="bg-amber-100 border-2 border-solid border-black">
          <div class="bg-sky-500 border-b-2 border-solid border-black px-2">
            Sign up
          </div>
          <div class="py-6 flex flex-col items-center">
            <input
              type="text"
              name="user[name]"
              class="w-3/4 bg-amber-100 border-2 border-solid border-black focus:ring-transparent focus:border-black"
              placeholder="Name"
            />
            <button class="border-2 border-solid border-black px-4 hover:bg-amber-400 w-3/4 mt-4">
              Create an account
            </button>
          </div>
        </div>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        changeset = Accounts.change_user_registration(user)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
