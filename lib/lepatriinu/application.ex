defmodule Lepatriinu.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LepatriinuWeb.Telemetry,
      Lepatriinu.Repo,
      {DNSCluster, query: Application.get_env(:lepatriinu, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Lepatriinu.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Lepatriinu.Finch},
      # Start a worker by calling: Lepatriinu.Worker.start_link(arg)
      # {Lepatriinu.Worker, arg},
      # Start to serve requests, typically the last entry
      LepatriinuWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Lepatriinu.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LepatriinuWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
