defmodule News.Test do
  @moduledoc """
  Test helpers.
  """

  @spec fixture(binary) :: binary
  def fixture(name) do
    Path.join("test/fixtures", name)
  end
end
