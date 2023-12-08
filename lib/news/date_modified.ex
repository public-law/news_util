defmodule News.DateModified do
  @moduledoc """
  An article's updated-at date.
  """

  @doc "Parses the most recent Published Date from a news article."
  @spec parse(Floki.html_tree) :: Date.t | nil
  def parse(document) do
    with [{_, _, schema_text}] <- Floki.find(document, "script[type='application/ld+json']"),
         {:ok, schema_org}     <- Jason.decode(schema_text) do
      date_modified(schema_org)
    else
      _ -> nil
    end
  end


  defp date_modified(%{"dateModified" => date}),  do: parse_date_text(date)
  defp date_modified(%{"datePublished" => date}), do: parse_date_text(date)
  defp date_modified(_), do: nil


  defp parse_date_text(date) when is_binary(date) do
    date_struct = 
      Regex.run(~r/(\d{4}-\d{2}-\d{2})/, date) 
      |> List.first
      |> Date.from_iso8601

    case date_struct do
      {:ok, date} -> date
      _           -> nil
    end
  end
end
