defmodule NewsUtil do
  @moduledoc """
  Documentation for `NewsUtil`.
  """

  @cal_codes %{
    "CONS" => "Constitution",
    "BPC" => "Business and Professions Code",
    "CIV" => "Civil Code",
    "CCP" => "Code of Civil Procedure",
    "COM" => "Commercial Code",
    "CORP" => "Corporations Code",
    "EDC" => "Education Code",
    "ELEC" => "Elections Code",
    "EVID" => "Evidence Code",
    "FAM" => "Family Code",
    "FIN" => "Financial Code",
    "FGC" => "Fish and Game Code",
    "GOV" => "Government Code",
    "HNC" => "Harbors and Navigation Code",
    "HSC" => "Health and Safety Code",
    "INS" => "Insurance Code",
    "LAB" => "Labor Code",
    "MVC" => "Military and Veterans Code",
    "PEN" => "Penal Code",
    "PROB" => "Probate Code",
    "PCC" => "Public Contract Code",
    "PUC" => "Public Utilities Code",
    "RTC" => "Revenue and Taxation Code",
    "SHC" => "Streets and Highways Code",
    "UIC" => "Unemployment Insurance Code",
    "VEH" => "Vehicle Code",
    "WAT" => "Water Code",
    "WIC" => "Welfare and Institutions Code"
  }

  @code_abbrevs %{
    "Business and Professions Code" => "Bus & Prof Code",
    "Civil Code" => "Civ Code",
    "Code of Civil Procedure" => "Civ Proc Code",
    "Commercial Code" => "Com Code",
    "Corporations Code" => "Corp Code",
    "Education Code" => "Educ Code",
    "Elections Code" => "Elec Code",
    "Evidence Code" => "Evid Code",
    "Family Code" => "Fam Code",
    "Financial Code" => "Fin Code",
    "Fish and Game Code" => "Fish & Game Code",
    "Government Code" => "Govt Code",
    "Harbors and Navigation Code" => "Harb & Nav Code",
    "Health and Safety Code" => "Health & Safety Code",
    "Insurance Code" => "Ins Code",
    "Labor Code" => "Lab Code",
    "Military and Veterans Code" => "Mil & Vet Code",
    "Penal Code" => "Penal Code",
    "Probate Code" => "Prob Code",
    "Public Contract Code" => "Pub Cont Code",
    "Public Utilities Code" => "Pub Util Code",
    "Revenue and Taxation Code" => "Rev & Tax Code",
    "Streets and Highways Code" => "Sts & High Code",
    "Unemployment Insurance Code" => "Unemp Ins Code",
    "Vehicle Code" => "Veh Code",
    "Water Code" => "Water Code",
    "Welfare and Institutions Code" => "Welf & Inst Code"
  }

  @spec find_citations(binary()) :: list()
  @doc """
  Find citations in a string of HTML.
  """
  def find_citations(html) do
    {:ok, document} = Floki.parse_document(html)

    hrefs =
      Floki.find(document, "a[href]")
      |> Enum.filter(fn anchor ->
        Floki.attribute(anchor, "href")
        |> List.first()
        |> String.match?(~r/leginfo\.legislature\.ca\.gov/)
      end)
      |> Enum.map(fn anchor ->
        Floki.attribute(anchor, "href")
      end)
      |> List.flatten()

    params_maps =
      hrefs
      |> Enum.map(fn href ->
        String.split(href, "?")
        |> List.last()
        |> URI.decode_query()
      end)

    params_maps
    |> Enum.map(fn m ->
      "CA #{@code_abbrevs[@cal_codes[m["lawCode"]]]} Section #{m["sectionNum"]}"
    end)
    |> Enum.map(fn s -> String.replace_suffix(s, ".", "") end)
    |> Enum.uniq()
    |> Enum.sort()
  end
end
