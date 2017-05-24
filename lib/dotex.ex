defmodule Dotex do
  @moduledoc """
  Dotex is an Elixir library that generates [Graphviz](http://www.graphviz.org) files.

  Requires graphviz to be installed to generate graphs successfully
  """

  @doc false
  def graph(graph) do
    "#{graph.type}#{graph_id(graph.id)} {\n" <>
      generate_graph_attributes(graph.attributes) <>
      generate_nodes(Enum.reverse(graph.nodes)) <>
      generate_connections(graph, Enum.reverse(graph.connections)) <>
      "}\n"
  end

  @doc """
  Write a graph to disk

  Writes `graph` to disk at the path specified by `filename`. `fileformat` is the format to use for output, eg. `dot`, `svg` or `png`
  """
  def write_graph(graph, fileformat, filename) do
    graph_string = graph(graph)

    {:ok, tmp_path} = Temp.path(%{suffix: ".dot"})

    :ok = File.write(tmp_path, graph_string)

    {output, result} = System.cmd("dot", [tmp_path, "-T#{fileformat}", "-o#{filename}"])

    if result == 0, do: :ok, else: {:error, output}
  end

  defp generate_connections(_graph, []), do: ""
  defp generate_connections(graph, [{src, dst, attributes}|t]) when is_list(dst) do
    dstnames = dst
    |> Enum.map(fn (d) -> escape_name(d.name) end)
    |> Enum.join(", ")

    ~s(  #{escape_name(src.name)} #{connector(graph)} ) <>
      dstnames <>
      generate_node_attributes(attributes) <>
      ";\n" <>
      generate_connections(graph, t)
  end
  defp generate_connections(graph, [{src, dst, attributes}|t]) do
    ~s(  #{escape_name(src.name)} #{connector(graph)} ) <>
      escape_name(dst.name) <>
      generate_node_attributes(attributes) <>
      ";\n" <>
      generate_connections(graph, t)
  end

  defp connector(%{type: "digraph"}), do: "->"
  defp connector(%{type: "graph"}), do: "--"

  defp generate_nodes([]), do: ""
  defp generate_nodes([%{attributes: attributes}|t]) when attributes == [] do
    "" <> generate_nodes(t)
  end
  defp generate_nodes([%{name: name, attributes: attributes}|t]) do
    "  #{escape_name(name)}#{generate_node_attributes(attributes)};\n" <> generate_nodes(t)
  end

  defp generate_node_attributes(attributes) when attributes == [], do: ""
  defp generate_node_attributes(attributes) do
    attr_string =
      attributes
      |> Enum.map(fn({k, v}) -> ~s(#{k}="#{v}") end)
    |> Enum.join(",")
    " [#{attr_string}]"
  end

  defp generate_graph_attributes([]), do: ""
  defp generate_graph_attributes(attributes) do
    joined = attributes
    |> Enum.map(fn({k, v}) -> ~s(#{k}="#{v}") end)
    |> Enum.join(" ")
    "  " <> joined <> ";\n"
  end

  defp graph_id(nil), do: nil
  defp graph_id(name), do: " #{name}"
  defp escape_name(name) when is_binary(name), do: ~s["#{String.replace(name, ~s{"}, ~s(\\"))}"]
end
