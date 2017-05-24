defmodule Dotex.Graph do
  @moduledoc """
  The base struct for storing the attributes, nodes and connections of a Graphviz graph
  """

  defstruct connections: [], nodes: [], type: "digraph", id: nil, attributes: []

  @doc """
  Create a new Graphviz graph

  ## Arguments

  * `type` - "graph" or "digraph"
  * `id` - (optional) the id of the graph
  * `attributes` - (optional) list of attributes for the graph (eg. [rankdir: "LR"]
  """
  def new(attributes), do: struct(Dotex.Graph, attributes)

  @doc """
  Create a connection between a node and one or more nodes

  ## Attributes

  * `graph` - the graph to operate on
  * `srcnode` - a Dotex.Node that is the source of the connection
  * `dstnode` - a single Dotex.Node or list of Dotex.Node to add a connection to
  * `params` - optional paramater for the connection (eg. [color: "blue"]
  """
  def add_connection(graph = %Dotex.Graph{}, srcnode = %Dotex.Node{}, dstnode, params \\ []) do
    connections = [{srcnode, dstnode, params}|graph.connections]
    %{graph | connections: connections}
  end

  @doc """
  Add a node to a graph

  ## Attributes

  * `graph` - the graph to operate on
  * `node` - the node being added to the graph
  """
  def add_node(graph = %Dotex.Graph{}, node = %Dotex.Node{}) do
    nodes = [node|graph.nodes]
    %{graph | nodes: nodes}
  end
end
