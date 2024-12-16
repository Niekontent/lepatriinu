defmodule Lepatriinu.Polls.Poll do
  @moduledoc """
  Ecto Poll schema.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          id: integer(),
          question: String.t(),
          options: list(String.t()),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  schema "polls" do
    field :question, :string
    field :options, {:array, :string}
    timestamps()
  end

  @required ~w(question options)a

  def changeset(poll, attrs \\ %{}) do
    poll
    |> cast(attrs, @required)
    |> validate_required(@required)
    |> validate_length(:options, min: 2, message: "Minimum two options required.")
  end
end
