defmodule DotexTest do
  use ExUnit.Case

  alias Dotex.{Node, Graph}

  test "simple digraph" do
    a = Dotex.Node.new("A")
    b = Dotex.Node.new("B")
    c = Dotex.Node.new("C")

    graph = Graph.new
    |> Graph.add_connection(a, b)
    |> Graph.add_connection(b, [c,a])
    |> Dotex.graph

    assert graph == ~s(digraph {
  "A" -> "B";
  "B" -> "C", "A";
}
)
  end

  test "digraph with attributes" do
    a = Node.new("A", %{shape: "box"})
    b = Node.new(~s{Node "B"})
    c = Node.new("C", %{style: "filled", fillcolor: "blue"})

    graph = Graph.new
      |> Graph.add_node(a)
      |> Graph.add_node(b)
      |> Graph.add_node(c)
      |> Graph.add_connection(a, b)
      |> Graph.add_connection(c, a, %{label: "label"})
      |> Dotex.Graph.add_connection(b, [c,a], %{label: "connections", arrowhead: "dot"})
      |> Dotex.graph

    assert graph == ~S(digraph {
  "A" [shape="box"];
  "C" [fillcolor="blue",style="filled"];
  "A" -> "Node \"B\"";
  "C" -> "A" [label="label"];
  "Node \"B\"" -> "C", "A" [arrowhead="dot",label="connections"];
}
)
  end

  test "write graph to file" do
    a = Node.new("A")
    b = Node.new("B")
    c = Node.new("C")

    :ok = Dotex.Graph.new
    |> Graph.add_connection(a, b)
    |> Graph.add_connection(b, [c,a])
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

  test "ethane" do
    c0 = Node.new("C_0")
    c1 = Node.new("C_1")
    h0 = Node.new("H_0")
    h1 = Node.new("H_1")
    h2 = Node.new("H_2")
    h3 = Node.new("H_3")
    h4 = Node.new("H_4")
    h5 = Node.new("H_5")

    graph = Graph.new(type: "graph", id: "ethane")
    |> Graph.add_connection(c0, h0, [type: "s"])
    |> Graph.add_connection(c0, h1, [type: "s"])
    |> Graph.add_connection(c0, h2, [type: "s"])
    |> Graph.add_connection(c0, c1, [type: "s"])
    |> Graph.add_connection(c1, h3, [type: "s"])
    |> Graph.add_connection(c1, h4, [type: "s"])
    |> Graph.add_connection(c1, h5, [type: "s"])
    |> Dotex.graph
    assert graph == File.read!("test/ethane.dot")
  end

  test "philosophers dillema" do
    bec3 = Node.new("bec3", shape: "box")
    rel3 = Node.new("rel3", shape: "box")
    bec2 = Node.new("bec2", shape: "box")
    rel2 = Node.new("rel2", shape: "box")
    acq2 = Node.new("acq2", shape: "box")
    acq3 = Node.new("acq3", shape: "box")
    bec1 = Node.new("bec1", shape: "box")
    rel1 = Node.new("rel1", shape: "box")
    acq1 = Node.new("acq1", shape: "box")
    hu3 = Node.new("hu3", shape: "circle", fixedsize: true, width: 0.9)
    th3 = Node.new("th3", shape: "circle", fixedsize: true, width: 0.9)
    ri3 = Node.new("ri3", shape: "circle", fixedsize: true, width: 0.9)
    ea3 = Node.new("ea3", shape: "circle", fixedsize: true, width: 0.9)
    hu2 = Node.new("hu2", shape: "circle", fixedsize: true, width: 0.9)
    th2 = Node.new("th2", shape: "circle", fixedsize: true, width: 0.9)
    ri2 = Node.new("ri2", shape: "circle", fixedsize: true, width: 0.9)
    ea2 = Node.new("ea2", shape: "circle", fixedsize: true, width: 0.9)
    hu1 = Node.new("hu1", shape: "circle", fixedsize: true, width: 0.9)
    th1 = Node.new("th1", shape: "circle", fixedsize: true, width: 0.9)
    ri1 = Node.new("ri1", shape: "circle", fixedsize: true, width: 0.9)
    ea1 = Node.new("ea1", shape: "circle", fixedsize: true, width: 0.9)

    graph = Dotex.Graph.new(type: "digraph", id: "PhiloDilemma", attributes: [overlap: false, label: "PetriNet Model PhiloDilemma\\nExtracted from ConceptBase and layed out by Graphviz", fontsize: 12])
    |> Graph.add_node(bec3)
    |> Graph.add_node(rel3)
    |> Graph.add_node(bec2)
    |> Graph.add_node(rel2)
    |> Graph.add_node(acq2)
    |> Graph.add_node(acq3)
    |> Graph.add_node(bec1)
    |> Graph.add_node(rel1)
    |> Graph.add_node(acq1)
    |> Graph.add_node(hu3)
    |> Graph.add_node(th3)
    |> Graph.add_node(ri3)
    |> Graph.add_node(ea3)
    |> Graph.add_node(hu2)
    |> Graph.add_node(th2)
    |> Graph.add_node(ri2)
    |> Graph.add_node(ea2)
    |> Graph.add_node(hu1)
    |> Graph.add_node(th1)
    |> Graph.add_node(ri1)
    |> Graph.add_node(ea1)
    |> Graph.add_connection(ri3, [acq2, acq3])
    |> Graph.add_connection(hu3, acq3)
    |> Graph.add_connection(bec3, hu3)
    |> Graph.add_connection(th3, bec3)
    |> Graph.add_connection(rel3, [th3, ri3])
    |> Graph.add_connection(ea3, rel3)
    |> Graph.add_connection(acq3, ea3)
    |> Graph.add_connection(ri2, [acq1, acq2])
    |> Graph.add_connection(hu2, acq2)
    |> Graph.add_connection(bec2, hu2)
    |> Graph.add_connection(th2, bec2)
    |> Graph.add_connection(rel2, [th2, ri2])
    |> Graph.add_connection(ea2, rel2)
    |> Graph.add_connection(acq2, ea2)
    |> Graph.add_connection(ri1, [acq3, acq1])
    |> Graph.add_connection(hu1, acq1)
    |> Graph.add_connection(bec1, hu1)
    |> Graph.add_connection(th1, bec1)
    |> Graph.add_connection(rel1, [th1, ri1])
    |> Graph.add_connection(ea1, rel1)
    |> Graph.add_connection(acq1, ea1)
    |> Dotex.graph
    assert graph == File.read!("test/philodillema.dot")
  end
end
