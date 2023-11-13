import Enum
import List
import CalCodes


defmodule NewsUtil do

  @doc """
  Find citations in a string of HTML or from a URL.
  """
  def find_citations(%URI{} = uri) do
    url       = URI.to_string(uri)
    temp_file = tmp_file!(url)
    response  = HTTPoison.get!(url)
    File.write!(temp_file, response.body)

    find_citations(file: temp_file)
  end

  def find_citations(file: path) do
    case Path.extname(path) do
      ".pdf" -> find_citations(read_pdf_as_html!(path))
      _      -> find_citations(File.read!(path))
    end
  end

  def find_citations(html) when is_binary(html) do
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


  @spec read_pdf_as_html!(any()) :: binary()
  def read_pdf_as_html!(input_file) do
    html_temp_file = tmp_file!("tempfile.html")
    :os.cmd(String.to_charlist("mutool convert -o #{html_temp_file} #{input_file}"))
    File.read!(html_temp_file)
  end


  @spec tmp_file!(binary()) :: binary()
  def tmp_file!(ext_to_match \\ "tempfile.tmp") do
    ext  = Path.extname(ext_to_match)
    dir  = System.tmp_dir!()
    file = "#{System.system_time()}-#{rand()}#{ext}"

    Path.join(dir, file)
  end


  @spec rand() :: pos_integer()
  def rand() do
    :rand.uniform(10_000_000_000_000)
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
