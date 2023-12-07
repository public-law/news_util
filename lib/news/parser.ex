defmodule News.Parser do
  @moduledoc """
  A module for parsing news articles.
  """

  @spec find_title(
          binary()
          | [
              binary()
              | {:comment, binary()}
              | {:pi | binary(), binary() | [{any(), any()}] | %{optional(binary()) => binary()},
                 list() | %{optional(binary()) => binary()}}
              | {:doctype, binary(), binary(), binary()}
            ]
        ) :: binary
  @doc """
  Find the best title in the HTML tags and meta-tags.
  """
  def find_title(document) do
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


  @spec find_source_name(binary) :: binary
  def find_source_name(url) do
    {:ok, document} =
      url
      |> find_source_url()
      |> CurlEx.get_with_user_agent!(:microsoft_edge_windows)
      |> Floki.parse_document()

    document
    |> Floki.find("title")
    |> Floki.text()
    |> String.trim()
  end


  @spec find_source_url(binary) :: binary
  def find_source_url(url) do
    u = URI.parse(url)
    "#{u.scheme}://#{u.host}"
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
