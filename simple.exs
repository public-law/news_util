cal_codes = %{
  "CONS" => "Constitution",
  "BPC"  => "Business and Professions Code",
  "CIV"  => "Civil Code",
  "COM"  => "Commercial Code",
  "CORP" => "Corporations Code",
  "EDC"  => "Education Code",
  "ELEC" => "Elections Code",
  "EVID" => "Evidence Code",
  "FAM"  => "Family Code",
  "FIN"  => "Financial Code",
  "FGC"  => "Fish and Game Code",
  "GOV"  => "Government Code",
  "HNC"  => "Harbors and Navigation Code",
  "HSC"  => "Health and Safety Code",
  "INS"  => "Insurance Code",
  "LAB"  => "Labor Code",
  "MVC"  => "Military and Veterans Code",
  "PEN"  => "Penal Code",
  "PROB" => "Probate Code",
  "PCC"  => "Public Contract Code",
  "PUC"  => "Public Utilities Code",
  "RTC"  => "Revenue and Taxation Code",
  "SHC"  => "Streets and Highways Code",
  "UIC"  => "Unemployment Insurance Code",
  "VEH"  => "Vehicle Code",
  "WAT"  => "Water Code",
  "WIC"  => "Welfare and Institutions Code",
}

url      = "https://www.cde.ca.gov/sp/ch/qandasec5.asp"
response = HTTPoison.get!(url)
pattern  = ~r/sectionNum=[^&]+&lawCode=\w\w\w/

Regex.scan(pattern, response.body)
|> Enum.map(fn [match] ->
    String.replace(match, "sectionNum=", "")
    |> String.replace("&lawCode=", " ")
    |> String.split(" ")
  end)
|> Enum.map(fn [section, code] -> {cal_codes[code], String.replace_suffix(section, ".", "")} end)
|> Enum.map(fn {code, section} -> "CA #{code} Section #{section}" end)
|> Enum.uniq()
|> IO.inspect()
