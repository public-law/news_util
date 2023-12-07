defmodule CodeGen do
  @moduledoc """
  A module for generating code.
  """


  @spec ruby_code(binary) :: binary
  def ruby_code(url) do
    info =
      url
      |> URI.parse()
      |> News.Article.find_info()

    citation_list =
      info.citations
      |> Enum.map_join(",\n    ", fn cite -> "'#{cite}'" end)


    """
    Source.find_or_create_by!(name: "#{info.source_name}", url: "#{info.source_url}")

    NewsImport.add(
      Item.find_or_create_by(
        url:              URI('#{url}').to_s,
        title:            "#{info.title}",
        summary:          "#{info.description}",
        secondary_source: Source.find_by!(name: '#{info.source_name}'),
        published_on:     Date.parse('#{info.date_modified}'),
      ),
      [
        #{citation_list}
      ]
    )
    """
  end
end
