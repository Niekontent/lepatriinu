defmodule Lepatriinu.Factories do
  @moduledoc """
  This module defines factories used by tests.
  """
  use ExMachina.Ecto, repo: Lepatriinu.Repo

  alias Lepatriinu.Polls.Poll
  alias Lepatriinu.Votes.Vote
  alias Lepatriinu.Accounts.User

  def user_factory do
    %User{
      name: "Gandalf_#{System.unique_integer()}"
    }
  end

  def poll_factory do
    %Poll{
      question: "Default question",
      options: ["Option 1", "Option 2"]
    }
  end

  def vote_factory do
    %Vote{
      poll: build(:poll),
      user: build(:user),
      selected_option: "Option 1"
    }
  end
end
