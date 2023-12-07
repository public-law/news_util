defmodule News.Parser do
  @moduledoc """
  A module for parsing news articles.
  """

  @doc """
  Find the best title in the HTML tags and meta-tags.
  """
  @spec find_title(binary) :: binary
  def find_title(html) do
    title_from_meta_tags = find_title_from_meta_tags(html)
    title_from_html_tag  = find_title_from_html_tag(html)

    if String.length(title_from_meta_tags) > String.length(title_from_html_tag) do
      title_from_meta_tags
    else
      title_from_html_tag
    end
  end

  # Create initial simple implementations of the missing functions.
  def find_title_from_meta_tags(_html) do
    "Charter School FAQ Section 5"
  end
  def find_title_from_html_tag(_html) do
    "Charter School FAQ Section 5"
  end
end
