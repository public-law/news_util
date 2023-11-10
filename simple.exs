[url]    = System.argv() # "https://www.cde.ca.gov/sp/ch/qandasec5.asp"
response = HTTPoison.get!(url)


#
# Create the Ruby code to import the cites.
#

IO.puts "["

Enum.each(NewsUtil.find_citations(response.body), fn cite ->
  IO.puts "  \"#{cite}\","
end)

IO.puts "]"
