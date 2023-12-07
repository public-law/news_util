defmodule CodeGen do
  @moduledoc """
  A module for generating code.
  """


  def ruby_code(url) do
    info =
      url
      |> URI.parse()
      |> NewsUtil.find_citations()

    citations =
      info.cites
      |> Enum.map_join(",\n    ", fn cite -> "'#{cite}'" end)

    title = info.title

    """
    NewsImport.add(
      Item.find_or_create_by(
        url:              URI('#{url}').to_s,
        title:            "#{title}",
        secondary_source: Source.find_by!(name: ''),
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
