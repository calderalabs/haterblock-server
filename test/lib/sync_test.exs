defmodule Haterblock.SyncTest do
  use Haterblock.DataCase

  @user_attrs %{
    google_id: "some google id",
    google_token: "some google token",
    google_refresh_token: "some google refresh token",
    email: "test1@email.com",
    name: "Ciccio Pasticcio"
  }

  setup do
    {:ok, _} = Haterblock.Accounts.create_user(@user_attrs)
    :ok
  end

  describe "sync_comments" do
    test "syncs comments not older than a week" do
      now = Timex.now()

      Haterblock.YoutubeTestApi.put_comments([
        %{
          id: "1",
          snippet: %{
            textDisplay: "Some comment",
            moderationStatus: "published",
            videoId: "1",
            publishedAt: Timex.shift(now, days: -3) |> DateTime.to_iso8601()
          }
        },
        %{
          id: "2",
          snippet: %{
            textDisplay: "Some other comment",
            moderationStatus: "published",
            videoId: "1",
            publishedAt: Timex.shift(now, days: -8) |> DateTime.to_iso8601()
          }
        }
      ])

      Haterblock.Sync.sync_comments()
      comments = Haterblock.Comments.list_comments()
      assert Enum.count(comments) == 1
      comment = comments |> List.first()
      assert comment.body == "Some comment"
      assert comment.status == "published"
      assert comment.video_id == "1"
      assert comment.published_at == Timex.shift(now, days: -3)
    end

    test "syncs only comments that are not already imported" do
      now = Timex.now()

      {:ok, _} =
        Haterblock.Comments.create_comment(%{
          body: "some body",
          google_id: "1",
          score: 0,
          status: "published",
          published_at: Timex.shift(now, days: -3),
          video_id: "1",
          user_id: 1
        })

      Haterblock.YoutubeTestApi.put_comments([
        %{
          id: "1",
          snippet: %{
            textDisplay: "some body",
            moderationStatus: "published",
            videoId: "1",
            publishedAt: Timex.shift(now, days: -3) |> DateTime.to_iso8601()
          }
        }
      ])

      Haterblock.Sync.sync_comments()
      comments = Haterblock.Comments.list_comments()
      assert Enum.count(comments) == 1
    end

    test "assigns a sentiment score to every comment" do
    end

    test "auto rejects hateful comments if auto rejecting is turned on" do
    end

    test "doesn't auto reject hateful comments if auto rejecting is turned off" do
    end

    test "syncs multiple pages of comments" do
    end

    test "sends an email about new hateful comments if auto rejecting is turned off" do
    end

    test "sends an email about ther rejection of hateful commments if auto rejecting is turned off" do
    end

    test "broadcasts the new comment count to the user channel" do
    end
  end
end
