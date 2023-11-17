import Enum
import List

import CalCodes


defmodule NewsUtil do
  @moduledoc false

  @doc """
  Find citations in a string of HTML or from a URL.
  """
  @spec find_citations(URI.t) :: [binary]
  def find_citations(%URI{} = uri) do
    url       = URI.to_string(uri)
    temp_file = FileUtil.tmp_file!(url)
    File.write!(temp_file, CurlEx.get!(url))

    find_citations_in_file(temp_file)
  end


  @spec find_citations_in_file(binary) :: [binary]
  def find_citations_in_file(path) do
    case Path.extname(path) do
      ".pdf" -> find_citations_in_html(FileUtil.read_pdf_as_html!(path))
      _      -> find_citations_in_html(File.read!(path))
    end
  end


  @spec find_citations_in_html(binary) :: [binary]
  defp find_citations_in_html(html) do
    cites_from_hrefs =
      html
      |> hrefs()
      |> map(&transform/1)
      |> filter(&is_binary/1)
      |> cleanup_list()

    crs_cites_from_text =
      case Regex.scan(~r/(C.R.S. &#xa7;(&#xa7;)? \d+-\d+-\d+)/, html) do
        list -> list |> flatten() |> uniq() |> map(fn m -> String.replace(m, ~r/&#xa7; ?/, "", global: true) end) |> reject(&(String.length(&1) == 0))
      end

    tx_cites_from_text =
      case Regex.scan(~r/(Texas \w+ Code Section [\d\w.]+)/, html) do
        list ->
          list
          |> flatten()
          |> uniq()
          |> map(fn m -> String.replace(m, "Texas ", "Tex. ", global: true) end)
          |> map(fn m -> String.replace(m, "Family ", "Fam. ", global: true) end)
          |> map(fn m -> String.replace(m, "Transportation ", "Transp. ", global: true) end)
      end

     uniq(cites_from_hrefs ++ crs_cites_from_text ++ tx_cites_from_text)
  end


  @spec hrefs(binary) :: [URI.t]
  defp hrefs(html) do
    {:ok, document} = Floki.parse_document(html)

    document
    |> Floki.attribute("a", "href")
    |> flatten()
    |> map(&URI.parse/1)
  end


  @spec transform(URI.t) :: nil | binary
  defp transform(%URI{} = url) do
    case url do
      %{host: "leginfo.legislature.ca.gov"} -> leginfo_url_to_cite(url)
      %{host: "newyork.public.law"}         -> public_law_url_to_cite(url)
      %{host: "texas.public.law"}           -> public_law_url_to_cite(url)
      _ -> nil
    end
  end


  @spec cleanup_list(list) :: list
  defp cleanup_list(list) do
    list
    |> sort()
    |> uniq()
  end


  @spec public_law_url_to_cite(URI.t) :: binary
  defp public_law_url_to_cite(%URI{path: path}) do
    path
    |> String.split("/")
    |> last()
    |> String.replace("_", " ")
    |> String.split(" ")
    |> map(&String.capitalize/1)
    |> join(" ")
    |> String.replace("N.y.", "N.Y.")
  end


  @spec leginfo_url_to_cite(URI.t) :: binary
  defp leginfo_url_to_cite(%URI{query: query}) do
    query
    |> URI.decode_query()
    |> make_cite_to_cal_codes()
  end


  @spec make_cite_to_cal_codes(map) :: binary
  defp make_cite_to_cal_codes(%{"lawCode" => code, "sectionNum" => section}) do
    "CA #{code_to_abbrev(code)} Section #{section}"
    |> String.replace_suffix(".", "")
  end
end
