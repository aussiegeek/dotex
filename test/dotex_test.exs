defmodule DotexTest do
  use ExUnit.Case

  test "simple digraph" do
    a = Dotex.Node.new("A")
    b = Dotex.Node.new("B")
    c = Dotex.Node.new("C")

    graph =
      Dotex.Graph.new
      |> Dotex.Graph.add_connection(a, b)
      |> Dotex.Graph.add_connection(b, [c,a])
      |> Dotex.graph

    assert graph == ~s(digraph {
  "A" -> "B";
  "B" -> "C", "A";
}
)
  end

  test "digraph with attributes" do
    a = Dotex.Node.new("A", %{shape: "box"})
    b = Dotex.Node.new(~s{Node "B"})
    c = Dotex.Node.new("C", %{style: "filled", fillcolor: "blue"})

    graph =
      Dotex.Graph.new
      |> Dotex.Graph.add_node(a)
      |> Dotex.Graph.add_node(b)
      |> Dotex.Graph.add_node(c)
      |> Dotex.Graph.add_connection(a, b)
      |> Dotex.Graph.add_connection(c, a, %{label: "label"})
      |> Dotex.Graph.add_connection(b, [c,a], %{label: "connections", arrowhead: "dot"})
      |> Dotex.graph

    assert graph == ~S(digraph {
  "A" [shape="box"];
  "C" [style="filled",fillcolor="blue"];
  "A" -> "Node \"B\"";
  "C" -> "A" [label="label"];
  "Node \"B\"" -> "C", "A" [label="connections",arrowhead="dot"];
}
)
  end

  test "write graph to file" do
    a = Dotex.Node.new("A")
    b = Dotex.Node.new("B")
    c = Dotex.Node.new("C")

    :ok = Dotex.Graph.new
    |> Dotex.Graph.add_connection(a, b)
    |> Dotex.Graph.add_connection(b, [c,a])
    |> Dotex.write_graph(:dot, "/tmp/dotex.dot")

    assert File.read("/tmp/dotex.dot") == {:ok, ~s(digraph {
\tgraph [bb="0,0,54,180"];
\tnode [label="\\N"];
\tA\t [height=0.5,
\t\tpos="27,162",
\t\twidth=0.75];
\tB\t [height=0.5,
\t\tpos="27,90",
\t\twidth=0.75];
\tA -> B\t [pos="e,21.121,107.96 21.16,144.41 20.297,136.51 20.048,126.85 20.412,117.94"];
\tB -> A\t [pos="e,32.84,144.41 32.879,107.96 33.714,115.83 33.948,125.37 33.583,134.19"];
\tC\t [height=0.5,
\t\tpos="27,18",
\t\twidth=0.75];
\tB -> C\t [pos="e,27,36.104 27,71.697 27,63.983 27,54.712 27,46.112"];
}
)}
  end
end
