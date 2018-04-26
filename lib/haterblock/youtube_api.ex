defmodule Haterblock.YoutubeApi do
  def new_connection(token) do
    GoogleApi.YouTube.V3.Connection.new(token)
  end

  def comments_set_moderation_status(conn, ids, status) do
    GoogleApi.YouTube.V3.Api.Comments.youtube_comments_set_moderation_status(conn, ids, status)
  end

  def channels_list(conn, part, options) do
    GoogleApi.YouTube.V3.Api.Channels.youtube_channels_list(conn, part, options)
  end

  def comment_threads_list(conn, part, options) do
    GoogleApi.YouTube.V3.Api.CommentThreads.youtube_comment_threads_list(conn, part, options)
  end
end
