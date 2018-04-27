defmodule TestAsync do
  def perform(function) do
    function.()
  end

  def perform(function, _) do
    perform(function)
  end
end
