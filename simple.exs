[url]    = System.argv() # "https://www.cde.ca.gov/sp/ch/qandasec5.asp"
response = HTTPoison.get!(url)

NewsUtil.find_citations(response.body) |> IO.inspect()
