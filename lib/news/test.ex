defmodule News.Test do
  @moduledoc """
  Test helpers.
  """


  @doc """
  Returns the contents of a fixture file.
  """
  @spec fixture_file!(binary) :: binary
  def fixture_file!(name) do
    name |> fixture_path() |> File.read!
  end


  @spec fixture_path(binary) :: binary
  defp fixture_path(name) do
    Path.join("test/fixtures", name)
  end
end
