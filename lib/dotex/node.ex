defmodule Dotex.Node do
  @moduledoc """
  Represents a single Graphviz node include any attributes
  """

  defstruct name: "", params: %{}
  def new(name, params \\ %{}) when is_binary(name) do
    %Dotex.Node{name: name, params: params}
  end
end
