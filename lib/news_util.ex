import Enum
import List
import CalCodes


defmodule NewsUtil do
  @spec find_citations(binary()) :: list()
  @doc """
  Find citations in a string of HTML.
  """
  def find_citations(html) when is_binary(html) do
    html
    |> uri_list()
    |> map(&transform/1)
    |> filter(&is_binary/1)
    |> cleanup_list()
  end


  defp uri_list(html) when is_binary(html) do
    {:ok, document} = Floki.parse_document(html)

    document
    |> Floki.attribute("a", "href")
    |> flatten()
    |> map(&URI.parse/1)
  end


  defp transform(%URI{} = url) do
    case url do
      %{host: "leginfo.legislature.ca.gov"} -> leginfo_url_to_cite(url)
      %{host: "texas.public.law"}           -> texas_public_law_url_to_cite(url)

      _ -> nil
    end
  end


  defp cleanup_list(list) do
    list
    |> sort()
    |> uniq()
  end


  defp texas_public_law_url_to_cite(%URI{path: path}) do
    path
    |> String.split("/")
    |> last()
    |> String.replace("_", " ")
    |> String.split(" ")
    |> map(&String.capitalize/1)
    |> join(" ")
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
end
