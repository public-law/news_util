import Enum
import List
import CalCodes


defmodule NewsUtil do
  @moduledoc false


  @doc """
  Find citations in a string of HTML or from a URL.
  """
  @spec find_citations(URI.t()) :: list()
  def find_citations(%URI{} = uri) do
    url       = URI.to_string(uri)
    temp_file = FileUtil.tmp_file!(url)
    response  = HTTPoison.get!(url)
    File.write!(temp_file, response.body)

    find_citations_in_file(temp_file)
  end


  @spec find_citations_in_file(binary()) :: list()
  def find_citations_in_file(path) do
    case Path.extname(path) do
      ".pdf" -> find_citations_in_html(FileUtil.read_pdf_as_html!(path))
      _      -> find_citations_in_html(File.read!(path))
    end
  end


  @spec find_citations_in_html(binary()) :: list()
  defp find_citations_in_html(html) when is_binary(html) do
    cites_from_hrefs =
      html
      |> uri_list()
      |> map(&transform/1)
      |> filter(&is_binary/1)
      |> cleanup_list()

    cites_from_text =
      case Regex.scan(~r/(C.R.S. &#xa7;(&#xa7;)? \d+-\d+-\d+)/, html) do
        list -> list |> flatten() |> uniq() |> map(fn m -> String.replace(m, ~r/&#xa7; ?/, "", global: true) end) |> reject(&(String.length(&1) == 0))
      end

     cites_from_hrefs  ++ cites_from_text
  end


  @spec uri_list(binary()) :: list()
  def uri_list(html) when is_binary(html) do
    {:ok, document} = Floki.parse_document(html)

    document
    |> Floki.attribute("a", "href")
    |> flatten()
    |> map(&URI.parse/1)
  end


  @spec transform(URI.t()) :: nil | binary()
  def transform(%URI{} = url) do
    case url do
      %{host: "leginfo.legislature.ca.gov"} -> leginfo_url_to_cite(url)
      %{host: "texas.public.law"}           -> texas_public_law_url_to_cite(url)
      %{host: "newyork.public.law"}         -> newyork_public_law_url_to_cite(url)

      _ -> nil
    end
  end


  @spec cleanup_list(any()) :: list()
  def cleanup_list(list) do
    list
    |> sort()
    |> uniq()
  end


  @spec texas_public_law_url_to_cite(URI.t()) :: binary()
  def texas_public_law_url_to_cite(%URI{path: path}) do
    public_law_url_to_cite(%URI{path: path})
  end


  @spec newyork_public_law_url_to_cite(URI.t()) :: binary()
  def newyork_public_law_url_to_cite(%URI{path: path}) do
    public_law_url_to_cite(%URI{path: path})
    |> String.replace("N.y.", "N.Y.")
  end


  @doc """
  Convert most public.law URLs to citations.
  """
  @spec public_law_url_to_cite(URI.t()) :: binary()
  def public_law_url_to_cite(%URI{path: path}) do
    path
    |> String.split("/")
    |> last()
    |> String.replace("_", " ")
    |> String.split(" ")
    |> map(&String.capitalize/1)
    |> join(" ")
  end


  @spec leginfo_url_to_cite(URI.t()) :: binary()
  def leginfo_url_to_cite(%URI{query: query}) do
    query
    |> URI.decode_query()
    |> make_cite_to_cal_codes()
  end


  @spec make_cite_to_cal_codes(map()) :: binary()
  def make_cite_to_cal_codes(%{"lawCode" => code, "sectionNum" => section}) do
    "CA #{code_to_abbrev(code)} Section #{section}"
    |> String.replace_suffix(".", "")
  end
end
