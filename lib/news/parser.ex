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
    title_from_html_tags = find_title_from_html_tags(html)

    if String.length(title_from_meta_tags) > String.length(title_from_html_tags) do
      title_from_meta_tags
    else
      title_from_html_tags
    end
  end

end
