defmodule DotexTest do
  use ExUnit.Case

  test "simple digraph" do
    a = Dotex.Node.new('A')
    b = Dotex.Node.new('B')
    c = Dotex.Node.new('C')

    graph =
      Dotex.Graph.new
      |> Dotex.Graph.add_connection(a, b)
      |> Dotex.Graph.add_connection(b, [c,a])
      |> Dotex.graph

    assert graph == ~s(digraph {
  A -> B;
  B -> C, A;
}
)
  end

  test "digraph with attributes" do
    a = Dotex.Node.new('A', %{shape: "box"})
    b = Dotex.Node.new('B')
    c = Dotex.Node.new('C', %{style: "filled", fillcolor: "blue"})

    graph =
      Dotex.Graph.new
      |> Dotex.Graph.add_node(a)
      |> Dotex.Graph.add_node(b)
      |> Dotex.Graph.add_node(c)
      |> Dotex.Graph.add_connection(a, b)
      |> Dotex.Graph.add_connection(c, a, %{label: "label"})
      |> Dotex.Graph.add_connection(b, [c,a], %{label: "connections", arrowhead: "dot"})
      |> Dotex.graph

    assert graph == ~s(digraph {
  A [shape="box"];
  C [style="filled",fillcolor="blue"];
  A -> B;
  C -> A [label="label"];
  B -> C, A [label="connections",arrowhead="dot"];
}
)
  end
end
