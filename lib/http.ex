defmodule Http do
  @moduledoc """
  A module for HTTP functions.
  """

  @doc """
  Get the contents of a URL, using curl.
  """
  @spec get!(binary) :: binary
  def get!(url) do
    {output, 0} = System.cmd("curl", [url, "--silent"])
    output
  end
end
