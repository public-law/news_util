defmodule CodeGen do
  @moduledoc """
  A module for generating code.
  """

  @ruby_code """
  def hello_world
    puts 'Hello, world!'
  end
  """

  @spec ruby_code() :: <<_::344>>
  def ruby_code do
    @ruby_code
  end
end
