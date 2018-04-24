defmodule Haterblock.AccountsTest do
  use Haterblock.DataCase

  alias Haterblock.Accounts

  describe "users" do
    alias Haterblock.Accounts.User

    @valid_attrs %{
      google_id: "some google id",
      google_token: "some google token",
      google_refresh_token: "some google refresh token",
      email: "test1@email.com",
      name: "Ciccio Pasticcio",
      synced_at: Timex.parse!("2015-06-24T04:50:34.0000000Z", "{ISO:Extended:Z}"),
      auto_reject_enabled: true
    }
    @update_attrs %{
      google_id: "some updated google id",
      google_token: "some updated google token",
      email: "test2@email.com",
      name: "Ciccio Pasticcione",
      synced_at: Timex.parse!("2015-06-25T04:50:34.0000000Z", "{ISO:Extended:Z}"),
      auto_reject_enabled: false
    }
    @invalid_attrs %{google_id: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.google_id == "some google id"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.google_id == "some updated google id"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
