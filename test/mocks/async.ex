defmodule TestAsync do
  def perform(function) do
    function.()
  end
end
