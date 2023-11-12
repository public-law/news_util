[url] = System.argv()  # "https://www.cde.ca.gov/sp/ch/qandasec5.asp"

#
# Create the Ruby code to import the cites.
#

IO.puts "["

Enum.each(NewsUtil.find_citations(URI.parse(url)), fn cite ->
  IO.puts "  \"#{cite}\","
end)

IO.puts "]"
