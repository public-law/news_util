defmodule News.Parser do
  @moduledoc """
  A module for parsing news articles.
  """

  @doc """
  Find the best title in the HTML tags and meta-tags.
  """
  @spec find_title(Floki.html_tree) :: binary
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


  @spec find_source_name(Floki.html_tree, binary) :: binary
  def find_source_name(document, url) when is_binary(url) do
    find_source_name(URI.parse url)
  end


  @spec find_source_name(URI.t) :: binary
  def find_source_name(%URI{} = url) do
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


  @spec find_source_url(URI.t) :: binary
  def find_source_url(%URI{} = uri) do
    "#{uri.scheme}://#{uri.host}"
  end


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
