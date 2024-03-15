defmodule Bet.PlacementFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bet.Placement` context.
  """

  @doc """
  Generate a odd.
  """
  def odd_fixture(attrs \\ %{}) do
    {:ok, odd} =
      attrs
      |> Enum.into(%{
        name: "some name",
        odd: 120.5,
        status: "some status"
      })
      |> Bet.Placement.create_odd()

    odd
  end
end
