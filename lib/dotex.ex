defmodule Dotex do
  def graph(graph) do
    "digraph {\n" <> generate_nodes(Enum.reverse(graph.nodes)) <> generate_connections(Enum.reverse(graph.connections)) <> "}\n"
  end

  def write_graph(graph, fileformat, filename) do
    graph_string = graph(graph)

    {:ok, tmp_path} = Temp.path(%{suffix: ".dot"})

    :ok = File.write(tmp_path, graph_string)

    {output, result} = System.cmd("dot", [tmp_path, "-T#{fileformat}", "-o#{filename}"])

    cond do
      result == 0 -> :ok
      true ->
        {:error, output}
    end
  end

  defp generate_connections([]), do: ""
  defp generate_connections([{src, dst, params}|t]) when is_list(dst) do
    dstnames = dst
    |> Enum.map(fn (d) -> d.name end)
    |> Enum.join(", ")

    ~s(  #{src.name} -> #{dstnames}#{generate_params(params)};\n) <> generate_connections(t)
  end
  defp generate_connections([{src, dst, params}|t]) do
    ~s(  #{src.name} -> #{dst.name}#{generate_params(params)};\n)  <> generate_connections(t)
  end

  defp generate_nodes([]), do: ""
  defp generate_nodes([%{params: params}|t]) when params == %{} do
    "" <> generate_nodes(t)
  end
  defp generate_nodes([%{name: name, params: params}|t]) do
    "  #{name}#{generate_params(params)};\n" <> generate_nodes(t)
  end

  def generate_params(params) when params == %{}, do: ""
  def generate_params(params) do
    param_string =
      params
      |> Enum.reverse
      |> Enum.map(fn({k,v}) -> ~s(#{k}="#{v}") end)
    |> Enum.join(",")
    " [#{param_string}]"
  end
end
