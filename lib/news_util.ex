import CalCodes

defmodule NewsUtil do
  @spec find_citations(binary()) :: list()
  @doc """
  Find citations in a string of HTML.
  """
  def find_citations(html) do
    html
    |> uri_list()
    |> Enum.map(&transform/1)
    |> Enum.filter(&is_binary/1)
    |> cleanup_list()
  end


  @spec transform(URI.t()) :: nil | binary()
  def  transform(%URI{} = url) do
    case url do
      %{host: "leginfo.legislature.ca.gov"} -> leginfo_url_to_cite(url)
      %{host: "texas.public.law"}           -> texas_public_law_url_to_cite(url)

      _ -> nil
    end
  end


  @spec uri_list(binary()) :: list()
  def  uri_list(html) when is_binary(html) do
    {:ok, document} = Floki.parse_document(html)

    document
    |> Floki.attribute("a", "href")
    |> List.flatten()
    |> Enum.map(&URI.parse/1)
  end


  def cleanup_list(list) do
    list
    |> Enum.sort()
    |> Enum.uniq()
  end


  def texas_public_law_url_to_cite(%URI{path: path}) do
    path
    |> String.split("/")
    |> List.last()
    |> String.replace("_", " ")
    |> String.split(" ")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end


  def leginfo_url_to_cite(%URI{query: query}) do
    query
    |> URI.decode_query()
    |> make_cite_to_cal_codes()
  end


  def make_cite_to_cal_codes(%{"lawCode" => code, "sectionNum" => section}) do
    "CA #{code_to_abbrev(code)} Section #{section}"
    |> String.replace_suffix(".", "")
  end
end
