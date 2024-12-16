defmodule LepatriinuWeb.UserLoginLive do
  use LepatriinuWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.simple_form for={@form} id="login_form" action={~p"/users/log_in"} phx-update="ignore">
        <div class="bg-amber-100 border-2 border-solid border-black">
          <div class="bg-sky-500 border-b-2 border-solid border-black px-2">
            Log in
          </div>

          <div class="py-6 flex flex-col items-center">
            <input
              type="text"
              name="user[name]"
              class="w-3/4 bg-amber-100 border-2 border-solid border-black focus:ring-transparent focus:border-black"
              placeholder="Name"
            />

            <label class="my-4 flex items-center">
              <input
                name="user[remember_me]"
                type="checkbox"
                class="bg-amber-100 border-solid border-black border-2 mr-2"
              /> Keep me logged in
            </label>

            <button class="border-2 border-solid border-black px-4 hover:bg-amber-400 w-1/2">
              Log in
            </button>
            <.link
              navigate={~p"/users/register"}
              class="border-2 border-solid border-black px-4 hover:bg-amber-400 w-1/2 mt-4 text-center"
            >
              Sign up
            </.link>
          </div>
        </div>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    form = to_form(%{}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
