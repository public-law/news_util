defmodule CodeGen do
  @moduledoc """
  A module for generating code.
  """


  def ruby_code(url) do
    citations =
      url
      |> URI.parse()
      |> NewsUtil.find_citations()
      |> Enum.map_join(",\n    ", fn cite -> "'#{cite}'" end)

    """
    NewsImport.add(
      Item.find_or_create_by(
        url:              URI('#{url}').to_s,
        secondary_source: Source.find_by!(name: ''),
        title:            "",
        published_on:     Date.parse(''),
        summary:          "",
      ),
      [
        #{citations}
      ]
    )
    """
  end
end
