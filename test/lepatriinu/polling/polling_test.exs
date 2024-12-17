defmodule Lepatriinu.PollingTest do
  use Lepatriinu.DataCase

  alias Lepatriinu.Polls.Poll
  alias Lepatriinu.Polling
  alias Lepatriinu.Votes.Vote

  describe "create_poll/1" do
    test "creates a poll with valid params" do
      question = "Who is the oldest in Middle-earth?"
      options = ["Gandalf", "Galadriel", "Tom Bombadil"]
      valid_attrs = %{question: question, options: options}

      assert {:ok, %Poll{} = poll} = Polling.current().create_poll(valid_attrs)
      assert poll.question == question
      assert poll.options == options
    end

    test "does not create a poll with invalid params" do
      invalid_attrs = %{question: nil, options: []}

      assert {:error, changeset} = Polling.current().create_poll(invalid_attrs)
      assert "can't be blank" in errors_on(changeset).question
      assert "should have at least 2 item(s)" in errors_on(changeset).options
    end
  end

  describe "get_all_polls/0" do
    test "returns all polls" do
      poll1 = insert(:poll, question: "Question 1", options: ["Option 1", "Option 2"])
      poll2 = insert(:poll, question: "Question 2", options: ["Option 1", "Option 2"])

      polls = Polling.current().get_all_polls()

      assert length(polls) == 2
      assert Enum.any?(polls, &(&1.id == poll1.id))
      assert Enum.any?(polls, &(&1.id == poll2.id))
    end

    test "returns an empty list if no polls exist" do
      assert Polling.current().get_all_polls() == []
    end
  end

  describe "get_poll/1" do
    test "returns the poll with the given id" do
      poll = insert(:poll, question: "What is your favorite color?", options: ["Red", "Blue"])

      assert %Poll{} = fetched_poll = Polling.current().get_poll(poll.id)
      assert fetched_poll.id == poll.id
      assert fetched_poll.question == "What is your favorite color?"
    end

    test "returns nil if the poll with the given id does not exist" do
      assert Polling.current().get_poll(-1) == nil
    end
  end

  describe "vote/1" do
    test "creats a vote with valid params" do
      user = insert(:user)
      poll = insert(:poll, options: ["Red", "Blue"])

      vote_params = %{user_id: user.id, poll_id: poll.id, selected_option: "Red"}

      assert {:ok, %Vote{} = vote} = Polling.current().vote(vote_params)
      assert vote.user_id == user.id
      assert vote.poll_id == poll.id
      assert vote.selected_option == "Red"
    end

    test "does not create a vote with invalid params" do
      user = insert(:user)
      poll = insert(:poll)

      vote_params = %{user_id: user.id, poll_id: poll.id, selected_option: ""}

      assert {:error, changeset} = Polling.current().vote(vote_params)
      assert "can't be blank" in errors_on(changeset).selected_option
    end

    test "does not create a vote for the same user and poll" do
      user = insert(:user)
      poll = insert(:poll, options: ["Red", "Blue"])

      vote_params = %{user_id: user.id, poll_id: poll.id, selected_option: "Red"}

      {:ok, %Vote{} = _vote} = Polling.current().vote(vote_params)

      assert {:error, changeset} = Polling.current().vote(vote_params)
      assert "has already been taken" in errors_on(changeset).user_id
    end

    test "broadcasts an event when a vote is created" do
      user = insert(:user)
      poll = insert(:poll, options: ["Red", "Blue"])
      topic = "poll_votes:#{poll.id}"
      Phoenix.PubSub.subscribe(Lepatriinu.PubSub, topic)

      vote_params = %{user_id: user.id, poll_id: poll.id, selected_option: "Red"}
      {:ok, %Vote{} = vote} = Polling.current().vote(vote_params)

      assert_receive {:user_voted, ^vote}
    end
  end

  describe "user_voted?/2" do
    test "returns true if user already voted in the poll" do
      user = insert(:user)
      poll = insert(:poll)
      insert(:vote, user: user, poll: poll)

      assert Polling.current().user_voted?(user.id, poll.id)
    end

    test "returns false if user have not voted in the poll" do
      user = insert(:user)
      poll = insert(:poll)

      refute Polling.current().user_voted?(user.id, poll.id)
    end
  end

  describe "count_poll_votes/1" do
    test "returns counted votes for a poll" do
      options = ["Dwalin", "Balin", "Fili", "Kili"]
      poll = insert(:poll, options: options)
      insert(:vote, poll: poll, selected_option: "Dwalin")
      insert(:vote, poll: poll, selected_option: "Balin")
      insert(:vote, poll: poll, selected_option: "Balin")

      results = Polling.current().count_poll_votes(poll.id)

      assert results["Balin"] == 2
      assert results["Dwalin"] == 1
    end
  end
end
