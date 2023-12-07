alias News.Parser

defmodule News.ParserTest do
  @moduledoc false
  use ExUnit.Case
  doctest News.Parser

  @test_cases_for_title [
    %{
      file: "qandasec5.asp",
      title: "Charter School FAQ Section 5",
    },
    %{
      file: "qandasec6.asp",
      title: "Charter School FAQ Section 6",
    },
  ]


  Enum.each(@test_cases_for_title, fn %{file: f, title: c} ->
    test "finds the title in #{f}" do
      assert Parser.find_title(News.Test.fixture(unquote(f))) == unquote(c)
    end
  end)
end
