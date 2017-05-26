alias Dotex.{Graph, Node}

a = Node.new("A")
b = Node.new("B")
c = Node.new("C")
d = Node.new("D")

Graph.new(type: "graph")
|> Graph.add_node(a)
|> Graph.add_node(b)
|> Graph.add_connection(a, [b, d])
|> Graph.add_connection(b, c)
|> Graph.add_connection(b, d)
|> Dotex.write_graph("png", "simple.png")
