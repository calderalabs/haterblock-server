defmodule Haterblock.ChannelsTest do
  use Haterblock.DataCase

  alias Haterblock.Channels

  describe "comments" do
    alias Haterblock.Channels.Comment

    @valid_attrs %{body: "some body", google_id: "some google_id"}
    @update_attrs %{body: "some updated body", google_id: "some updated google_id"}
    @invalid_attrs %{body: nil, google_id: nil}

    def comment_fixture(attrs \\ %{}) do
      {:ok, comment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Channels.create_comment()

      comment
    end

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert Channels.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert Channels.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      assert {:ok, %Comment{} = comment} = Channels.create_comment(@valid_attrs)
      assert comment.body == "some body"
      assert comment.google_id == "some google_id"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Channels.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      assert {:ok, comment} = Channels.update_comment(comment, @update_attrs)
      assert %Comment{} = comment
      assert comment.body == "some updated body"
      assert comment.google_id == "some updated google_id"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = Channels.update_comment(comment, @invalid_attrs)
      assert comment == Channels.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = Channels.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Channels.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = Channels.change_comment(comment)
    end
  end
end
