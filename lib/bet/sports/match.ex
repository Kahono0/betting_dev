defmodule Bet.Sports.Match do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bet.Sports.Sport

  schema "matches" do
    field :name, :string
    field :description, :string
    belongs_to :sport, Sport


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(match, attrs) do
    match
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
