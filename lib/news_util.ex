import Enum
import List

import CalCodes
import News.Http
alias News.Parser


defmodule NewsUtil do
  @moduledoc false

  @doc """
  Find citations in a string of HTML or from a URL.
  """
  def find_citations(%URI{} = uri) do
    url       = URI.to_string(uri)
    temp_file = News.File.tmp_file!(url)
    File.write!(temp_file, CurlEx.get_with_user_agent!(url, :microsoft_edge_windows))

    find_citations_in_file(temp_file)
  end


  def find_citations_in_file(path) do
    html = case Path.extname(path) do
      ".pdf" -> News.File.read_pdf_as_html!(path)
      _      -> File.read!(path)
    end

    {:ok, document} = Floki.parse_document(html)

    cites = find_citations_in_html(html, document)
    _title = Parser.find_title(document)

    cites
  end


  defp find_citations_in_html(html, document) do
    cites_from_hrefs =
      document
      |> hrefs()
      |> map(&href_to_cite/1)

    crs_cites_from_text_1 =
      Regex.scan(~r/(C.R.S. &#xa7;(?:&#xa7;)? \d+-\d+-\d+)/, html)
      |> flatten()
      |> map(fn m -> String.replace(m, ~r/&#xa7; ?/, "", global: true) end)

    crs_cites_from_text_2 =
      Regex.scan(~r/(\d+-\d+-\d+(?:\.\d+)?) C.R.S./, html)
      |> map(&last/1)
      |> map(fn m -> "C.R.S. #{m}" end)
      |> flatten()

    tx_cites_from_text =
      Regex.scan(~r/(Texas \w+ Code Section [\d\w.]+)/, html)
      |> flatten()
      |> map(fn m -> String.replace(m, "Texas ",          "Tex. ")    end)
      |> map(fn m -> String.replace(m, "Family ",         "Fam. ")    end)
      |> map(fn m -> String.replace(m, "Transportation ", "Transp. ") end)


     (cites_from_hrefs ++ crs_cites_from_text_1 ++ crs_cites_from_text_2 ++ tx_cites_from_text)
     |> filter(&is_binary/1)
     |> cleanup_list()
  end


  def hrefs(document) do
    document
    |> Floki.attribute("a", "href")
    |> flatten()
    |> map(&URI.parse/1)
    |> reject(&is_nil/1)
  end


  @spec href_to_cite(URI.t) :: nil | binary
  def href_to_cite(%URI{} = url) do
    cond do
      tld(url) == "public.law" ->
        public_law_url_to_cite(url)

      url.host == "leginfo.legislature.ca.gov" ->
        leginfo_url_to_cite(url)

      true -> nil
    end
  end


  @spec cleanup_list(list) :: list
  defp cleanup_list(list) do
    list
    |> sort()
    |> uniq()
  end


  defp public_law_url_to_cite(%URI{path: path}) do
    path
    |> String.split("/")
    |> last
    |> String.replace("_", " ")
    |> News.Text.titleize
  end


  defp leginfo_url_to_cite(%URI{query: query}) do
    query
    |> URI.decode_query()
    |> make_cite_to_cal_codes()
  end


  defp make_cite_to_cal_codes(%{"lawCode" => code, "sectionNum" => section}) do
    "CA #{code_to_abbrev(code)} Section #{section}"
    |> String.replace_suffix(".", "")
  end

  defp make_cite_to_cal_codes(_), do: nil
end
