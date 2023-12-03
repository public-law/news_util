defmodule HttpUtil do
  @moduledoc """
  A module for HTTP functions.
  """

  @spec tld(URI.t()) :: binary() | nil

  @doc """
  Get the top-level domain from a URI.

  ## Examples

      iex> HttpUtil.tld(%URI{host: "www.example.com"})
      "example.com"

      iex> HttpUtil.tld(%URI{host: "www.example.co.uk"})
      "co.uk"
  """
  def tld(%URI{host: nil}), do: nil

  def tld(%URI{host: host}) do
    host
    |> String.split(".")
    |> Enum.reverse()
    |> Enum.take(2)
    |> Enum.reverse()
    |> Enum.join(".")
  end
end
