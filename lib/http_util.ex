defmodule HttpUtil do
  @moduledoc """
  A module for HTTP functions.
  """

  @doc """
  Get the top-level domain from a URI.

  ## Examples

      iex> HttpUtil.tld(%URI{host: "www.example.com"})
      "example.com"

      iex> HttpUtil.tld(%URI{host: "www.example.co.uk"})
      "co.uk"
  """
  @spec tld(URI.t()) :: binary()
  def tld(%URI{host: host}) do
    host
    |> String.split(".")
    |> Enum.reverse()
    |> Enum.take(2)
    |> Enum.reverse()
    |> Enum.join(".")
  end
end
