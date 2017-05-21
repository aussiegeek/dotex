defmodule Dotex.Node do
  defstruct name: "", params: %{}
  def new(name, params \\ %{}) when is_binary(name) do
    %Dotex.Node{name: name, params: params}
  end
end
