alias News.Parser
alias News.Test

defmodule News.ParserTest do
  @moduledoc false
  use ExUnit.Case
  doctest News.Parser

  @test_cases_for_title [
    %{
      file:  "qandasec5.asp",
      url:   "https://www.cde.ca.gov/sp/ch/qandasec5.asp",

      title: "Charter School FAQ Section 5",
      source_name: "California Department of Education",
      source_url: "https://www.cde.ca.gov",
    },
    %{
      file:  "qandasec6.asp",
      url:   "https://www.cde.ca.gov/sp/ch/qandasec6.asp",

      title: "Charter School FAQ Section 6",
      source_name: "California Department of Education",
      source_url: "https://www.cde.ca.gov",
    },
  ]


  Enum.each(@test_cases_for_title, fn %{file: f, url: url, title: title, source_name: source_name, source_url: source_url} ->
    test "finds the title in #{f}" do
      {:ok, document} = Floki.parse_document(File.read!(Test.fixture(unquote f)))

      assert Parser.find_title(document)          == unquote(title)
      assert Parser.find_source_url(unquote url)  == unquote(source_url)
      assert Parser.find_source_name(unquote url) == unquote(source_name)
    end
  end)
end
