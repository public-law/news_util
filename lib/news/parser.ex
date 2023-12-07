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

    # title_from_meta_tags = find_title_from_meta_tags(html)
    # title_from_html_tag  = find_title_from_html_tag(html)

    # if String.length(title_from_meta_tags) > String.length(title_from_html_tag) do
    #   title_from_meta_tags
    # else
    #   title_from_html_tag
    # end

    find_title_from_html_tag(document)
  end


  # Create initial simple implementations of the missing functions.
  def find_title_from_meta_tags(_html) do
    "Charter School FAQ Section 99"
  end


  def find_title_from_html_tag(document) do
    orig_title  = raw_title(document)
    clean_title = title_without_hyphenation(orig_title)

    # TODO: Decide intelligently which title to return.

    clean_title
  end


  defp title_without_hyphenation(title) do
    title
      |> String.split(~r/[-–—]/)
      |> List.first
      |> String.trim
  end


  defp raw_title(document) do
    document
    |> Floki.find("title")
    |> Floki.text()
  end
end
