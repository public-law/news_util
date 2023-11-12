import CalCodes

defmodule NewsUtil do
  @moduledoc """
  Documentation for `NewsUtil`.
  """


  @spec find_citations(binary()) :: list()
  @doc """
  Find citations in a string of HTML.
  """
  def find_citations(html) do
    {:ok, document} = Floki.parse_document(html)

    leginfo_urls =
      document
      |> Floki.attribute("a", "href")
      |> List.flatten()
      |> Enum.map(&URI.parse/1)
      |> Enum.filter(&leginfo_url?/1)

    leginfo_cites =
      leginfo_urls
      |> Enum.map(&leginfo_url_to_cite/1)
      |> Enum.sort()
      |> Enum.uniq()

    texas_public_law_urls =
      document
      |> Floki.attribute("a", "href")
      |> List.flatten()
      |> Enum.map(&URI.parse/1)
      |> Enum.filter(&texas_public_law_url?/1)

    texas_public_law_cites =
      texas_public_law_urls
      |> Enum.map(&texas_public_law_url_to_cite/1)
      |> Enum.sort()
      |> Enum.uniq()

    leginfo_cites ++ texas_public_law_cites
  end


  defp texas_public_law_url?(%{host: "texas.public.law"}), do: true
  defp texas_public_law_url?(_),  do: false

  defp texas_public_law_url_to_cite(%{path: path}) do
    path
    |> String.split("/")
    |> List.last()
    |> String.replace("_", " ")
    |> String.split(" ")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end



  defp leginfo_url?(%{host: "leginfo.legislature.ca.gov"}), do: true
  defp leginfo_url?(_),  do: false

  defp leginfo_url_to_cite(%{query: query}) do
    query
    |> URI.decode_query()
    |> make_cite_to_cal_codes()
  end


  defp make_cite_to_cal_codes(%{"lawCode" => code, "sectionNum" => section}) do
    "CA #{code_to_abbrev(code)} Section #{section}"
    |> String.replace_suffix(".", "")
  end
end
