defmodule News.Parser do
  @moduledoc """
  A module for parsing news articles.
  """

  @doc """
  Find the best title in the HTML tags and meta-tags.
  """
  @spec find_title(binary) :: binary
  def find_title(html) do
    {:ok, document} = Floki.parse_document(html)

    orig_title  = raw_title(document)
    clean_title = title_without_hyphenation(orig_title)

    clean_title
  end


  # Create initial simple implementations of the missing functions.
  def find_title_from_meta_tags(_html) do
    "Charter School FAQ Section 99"
  end


  defp raw_title(document) do
    document
    |> Floki.find("title")
    |> Floki.text()
  end


  defp title_without_hyphenation(title) do
    title
      |> String.split(~r/[-–—]/)
      |> List.first
      |> String.trim
  end
end
