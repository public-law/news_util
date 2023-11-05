cal_codes = %{
  "CONS" => "Constitution",
  "BPC"  => "Business and Professions Code",
  "CIV"  => "Civil Code",
  "CCP"  => "Code of Civil Procedure",
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

code_abbrevs = %{
  "Business and Professions Code" => "Bus & Prof Code",
  "Civil Code"                    => "Civ Code",
  "Code of Civil Procedure"       => "Civ Proc Code",
  "Commercial Code"               => "Com Code",
  "Corporations Code"             => "Corp Code",
  "Education Code"                => "Educ Code",
  "Elections Code"                => "Elec Code",
  "Evidence Code"                 => "Evid Code",
  "Family Code"                   => "Fam Code",
  "Financial Code"                => "Fin Code",
  "Fish and Game Code"            => "Fish & Game Code",
  "Government Code"               => "Govt Code",
  "Harbors and Navigation Code"   => "Harb & Nav Code",
  "Health and Safety Code"        => "Health & Safety Code",
  "Insurance Code"                => "Ins Code",
  "Labor Code"                    => "Lab Code",
  "Military and Veterans Code"    => "Mil & Vet Code",
  "Penal Code"                    => "Penal Code",
  "Probate Code"                  => "Prob Code",
  "Public Contract Code"          => "Pub Cont Code",
  "Public Utilities Code"         => "Pub Util Code",
  "Revenue and Taxation Code"     => "Rev & Tax Code",
  "Streets and Highways Code"     => "Sts & High Code",
  "Unemployment Insurance Code"   => "Unemp Ins Code",
  "Vehicle Code"                  => "Veh Code",
  "Water Code"                    => "Water Code",
  "Welfare and Institutions Code" => "Welf & Inst Code",
}


[url]    = System.argv() # "https://www.cde.ca.gov/sp/ch/qandasec5.asp"
response = HTTPoison.get!(url)
pattern  = ~r/sectionNum=[^&]+&lawCode=\w\w\w/

Regex.scan(pattern, response.body)
|> Enum.map(fn [match] ->
    String.replace(match, "sectionNum=", "")
    |> String.replace("&lawCode=", " ")
    |> String.split(" ")
  end)
|> Enum.map(fn [section, code] -> {code_abbrevs[cal_codes[code]], String.replace_suffix(section, ".", "")} end)
|> Enum.map(fn {code, section} -> "CA #{code} Section #{section}" end)
|> Enum.sort()
|> Enum.uniq()
|> IO.inspect()
