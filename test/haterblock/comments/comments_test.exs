defmodule Haterblock.CommentsTest do
  use Haterblock.DataCase

  alias Haterblock.Comments

  describe "comments" do
    alias Haterblock.Comments.Comment

    @valid_attrs %{
      body: "some body",
      google_id: "some google_id",
      score: 0,
      status: "published",
      published_at: Timex.parse!("2015-06-24T04:50:34.0000000Z", "{ISO:Extended:Z}"),
      user_id: 1
    }
    @update_attrs %{
      body: "some updated body",
      google_id: "some updated google_id",
      score: 1,
      status: "rejected",
      published_at: Timex.parse!("2015-06-25T04:50:34.0000000Z", "{ISO:Extended:Z}"),
      user_id: 1
    }
    @invalid_attrs %{
      body: nil,
      google_id: nil,
      score: nil,
      status: nil,
      published_at: nil,
      user_id: nil
    }

    def comment_fixture(attrs \\ %{}) do
      {:ok, comment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Comments.create_comment()

      comment
    end

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert Comments.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert Comments.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      assert {:ok, %Comment{} = comment} = Comments.create_comment(@valid_attrs)
      assert comment.body == "some body"
      assert comment.google_id == "some google_id"
      assert comment.score == 0
      assert comment.status == "published"

      assert comment.published_at ==
               Timex.parse!("2015-06-24T04:50:34.0000000Z", "{ISO:Extended:Z}")

      assert comment.user_id == 1
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Comments.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      assert {:ok, comment} = Comments.update_comment(comment, @update_attrs)
      assert %Comment{} = comment
      assert comment.body == "some updated body"
      assert comment.google_id == "some updated google_id"
      assert comment.score == 1
      assert comment.status == "rejected"

      assert comment.published_at ==
               Timex.parse!("2015-06-25T04:50:34.0000000Z", "{ISO:Extended:Z}")

      assert comment.user_id == 1
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = Comments.update_comment(comment, @invalid_attrs)
      assert comment == Comments.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = Comments.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Comments.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = Comments.change_comment(comment)
    end
  end
end
