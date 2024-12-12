defmodule LepatriinuWeb.UserSettingsLive do
  use LepatriinuWeb, :live_view

  alias Lepatriinu.Accounts

  def render(assigns) do
    ~H"""
    <.header class="text-center">
      Account Settings
      <:subtitle>Nie potrzebuje tego widoku</:subtitle>
    </.header>
    """
  end

  def mount(%{"token" => token}, _session, socket) do
    {:ok, push_navigate(socket, to: ~p"/users/settings")}
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

end
