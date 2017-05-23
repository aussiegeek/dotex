defmodule Dotex.Graph do
  @moduledoc """
  The base struct for storing the attributes, nodes and connections of a Graphviz graph
  """

  defstruct connections: [], nodes: [], type: "digraph", id: nil, attributes: []

  def new, do: %Dotex.Graph{}
  def new(params), do: struct(Dotex.Graph, params)

  def add_connection(graph = %Dotex.Graph{}, srcnode = %Dotex.Node{}, dstnode, params \\ %{}) do
    connections = [{srcnode, dstnode, params}|graph.connections]
    %{graph | connections: connections}
  end

  def add_node(graph = %Dotex.Graph{}, node = %Dotex.Node{}) do
    nodes = [node|graph.nodes]
    %{graph | nodes: nodes}
  end
end
