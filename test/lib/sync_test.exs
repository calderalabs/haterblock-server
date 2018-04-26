defmodule Haterblock.SyncTest do
  use Haterblock.DataCase

  describe "sync_comments" do
    test "syncs comments not older than a week" do
    end

    test "syncs only new comments" do
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
