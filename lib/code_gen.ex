defmodule CodeGen do
  @moduledoc """
  A module for generating code.
  """


  def ruby_code(url) do
    cites = "[" <> Enum.join(Enum.map(NewsUtil.find_citations(URI.parse(url)), fn cite -> "\n    \"#{cite}\"" end), ",") <> "\n  ]"

    """
    NewsImport.add(
      Item.find_or_create_by(
        url:              URI('#{url}').to_s,
        secondary_source: Source.find_by!(name: ''),
        title:            "",
        published_on:     Date.parse(''),
        summary:          "",
      ),
      #{cites}
    )
    """
  end
end
