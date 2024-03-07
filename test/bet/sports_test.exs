defmodule Bet.SportsTest do
  use Bet.DataCase

  alias Bet.Sports

  describe "sports" do
    alias Bet.Sports.Sport

    import Bet.SportsFixtures

    @invalid_attrs %{name: nil, description: nil}

    test "list_sports/0 returns all sports" do
      sport = sport_fixture()
      assert Sports.list_sports() == [sport]
    end

    test "get_sport!/1 returns the sport with given id" do
      sport = sport_fixture()
      assert Sports.get_sport!(sport.id) == sport
    end

    test "create_sport/1 with valid data creates a sport" do
      valid_attrs = %{name: "some name", description: "some description"}

      assert {:ok, %Sport{} = sport} = Sports.create_sport(valid_attrs)
      assert sport.name == "some name"
      assert sport.description == "some description"
    end

    test "create_sport/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sports.create_sport(@invalid_attrs)
    end

    test "update_sport/2 with valid data updates the sport" do
      sport = sport_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description"}

      assert {:ok, %Sport{} = sport} = Sports.update_sport(sport, update_attrs)
      assert sport.name == "some updated name"
      assert sport.description == "some updated description"
    end

    test "update_sport/2 with invalid data returns error changeset" do
      sport = sport_fixture()
      assert {:error, %Ecto.Changeset{}} = Sports.update_sport(sport, @invalid_attrs)
      assert sport == Sports.get_sport!(sport.id)
    end

    test "delete_sport/1 deletes the sport" do
      sport = sport_fixture()
      assert {:ok, %Sport{}} = Sports.delete_sport(sport)
      assert_raise Ecto.NoResultsError, fn -> Sports.get_sport!(sport.id) end
    end

    test "change_sport/1 returns a sport changeset" do
      sport = sport_fixture()
      assert %Ecto.Changeset{} = Sports.change_sport(sport)
    end
  end
end
