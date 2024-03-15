defmodule Bet.PlacementTest do
  use Bet.DataCase

  alias Bet.Placement

  describe "odds" do
    alias Bet.Placement.Odd

    import Bet.PlacementFixtures

    @invalid_attrs %{name: nil, status: nil, odd: nil}

    test "list_odds/0 returns all odds" do
      odd = odd_fixture()
      assert Placement.list_odds() == [odd]
    end

    test "get_odd!/1 returns the odd with given id" do
      odd = odd_fixture()
      assert Placement.get_odd!(odd.id) == odd
    end

    test "create_odd/1 with valid data creates a odd" do
      valid_attrs = %{name: "some name", status: "some status", odd: 120.5}

      assert {:ok, %Odd{} = odd} = Placement.create_odd(valid_attrs)
      assert odd.name == "some name"
      assert odd.status == "some status"
      assert odd.odd == 120.5
    end

    test "create_odd/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Placement.create_odd(@invalid_attrs)
    end

    test "update_odd/2 with valid data updates the odd" do
      odd = odd_fixture()
      update_attrs = %{name: "some updated name", status: "some updated status", odd: 456.7}

      assert {:ok, %Odd{} = odd} = Placement.update_odd(odd, update_attrs)
      assert odd.name == "some updated name"
      assert odd.status == "some updated status"
      assert odd.odd == 456.7
    end

    test "update_odd/2 with invalid data returns error changeset" do
      odd = odd_fixture()
      assert {:error, %Ecto.Changeset{}} = Placement.update_odd(odd, @invalid_attrs)
      assert odd == Placement.get_odd!(odd.id)
    end

    test "delete_odd/1 deletes the odd" do
      odd = odd_fixture()
      assert {:ok, %Odd{}} = Placement.delete_odd(odd)
      assert_raise Ecto.NoResultsError, fn -> Placement.get_odd!(odd.id) end
    end

    test "change_odd/1 returns a odd changeset" do
      odd = odd_fixture()
      assert %Ecto.Changeset{} = Placement.change_odd(odd)
    end
  end
end
