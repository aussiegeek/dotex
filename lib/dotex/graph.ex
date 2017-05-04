defmodule Dotex.Graph do
  defstruct connections: [], nodes: []

  def new do
    %Dotex.Graph{}
  end

  def add_connection(graph = %Dotex.Graph{}, srcnode = %Dotex.Node{}, dstnode, params \\ %{}) do
    connections = [{srcnode, dstnode, params}|graph.connections]
    %{graph | connections: connections}
  end

  def add_node(graph = %Dotex.Graph{}, node = %Dotex.Node{}) do
    nodes = [node|graph.nodes]
    %{graph | nodes: nodes}
  end
end
