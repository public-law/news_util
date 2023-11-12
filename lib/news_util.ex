import Enum
import List
import CalCodes


defmodule NewsUtil do

  @doc """
  Find citations in a string of HTML or from a URL.
  """
  @spec find_citations(binary() | URI.t()) :: list()
  def find_citations(%URI{} = url) do
    url
    |> URI.to_string()
    |> HTTPoison.get!()
    |> Map.fetch!(:body)
    |> find_citations()
  end

  def find_citations(html) when is_binary(html) do
    html
    |> uri_list()
    |> map(&transform/1)
    |> filter(&is_binary/1)
    |> cleanup_list()
  end


  def temp_file!(ext \\ "tmp") do
    dir       = System.tmp_dir!()
    file      = Integer.to_string(System.system_time()) <> "." <> ext
    full_path = Path.join(dir, file)

    %{dir: dir, file: file, full_path: full_path}
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
