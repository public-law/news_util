defmodule CodeGen do
  @moduledoc """
  A module for generating code.
  """


  def ruby_code(url) do
    info =
      url
      |> URI.parse()
      |> NewsUtil.find_citations()

    citation_list =
      info.citations
      |> Enum.map_join(",\n    ", fn cite -> "'#{cite}'" end)


    """
    NewsImport.add(
      Item.find_or_create_by(
        url:              URI('#{url}').to_s,
        title:            "#{info.title}",
        summary:          "#{info.description}",
        secondary_source: Source.find_by!(name: ''),
        published_on:     Date.parse(''),
      ),
      [
        #{citation_list}
      ]
    )
    """
  end
end
