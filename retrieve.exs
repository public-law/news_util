[url] = System.argv()  # "https://www.cde.ca.gov/sp/ch/qandasec5.asp"

#
# Create the Ruby code to import the cites.
#

IO.puts CodeGen.ruby_code(url)
