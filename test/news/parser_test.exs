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

end
