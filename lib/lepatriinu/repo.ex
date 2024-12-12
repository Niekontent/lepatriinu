defmodule Lepatriinu.Repo do
  use Ecto.Repo,
    otp_app: :lepatriinu,
    adapter: Ecto.Adapters.Postgres
end
