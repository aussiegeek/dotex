defmodule Dotex.Node do
  @moduledoc """
  Represents a single Graphviz node include any attributes
  """

  defstruct name: "", attributes: []

  @doc """
  Create a new node

  ## Attributes
  * `name` - the name of the new node. Should be unique
  * `attributes` - (optional) list of attributes for the node (eg. [color: "black"])
  """
  def new(name, attributes \\ []) when is_binary(name) do
    %Dotex.Node{name: name, attributes: attributes}
  end
end
