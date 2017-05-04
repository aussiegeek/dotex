defmodule Dotex.Node do
  defstruct name: "", params: %{}
  def new(name, params \\ %{}) do
    %Dotex.Node{name: name, params: params}
  end
end
