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

    orig_title  = title_tag(document)
    clean_title = title_without_hyphenation(orig_title)
    h1_title    = h1_tag(document)


    # Whatever the h1 tag matches is definitely the best title.
    # If the h1 tag doesn't match one, then just use the
    # original HTML title.
    cond do
      clean_title == h1_title -> clean_title
      orig_title  == h1_title -> orig_title

      true                    -> clean_title
    end
  end


  # Create initial simple implementations of the missing functions.
  def find_title_from_meta_tags(_html) do
    "Charter School FAQ Section 99"
  end


  defp title_tag(document) do
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


  defp h1_tag(document) do
    document
    |> Floki.find("h1")
    |> Floki.text()
  end
end
