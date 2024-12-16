defmodule Lepatriinu.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lepatriinu.Accounts` context.
  """

  def unique_user_name, do: "Galadriel_#{System.unique_integer()}"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{name: unique_user_name()})
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Lepatriinu.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
