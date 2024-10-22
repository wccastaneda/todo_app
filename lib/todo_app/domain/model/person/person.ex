defmodule TodoApp.Model.Person do
  alias __MODULE__, as: Person
  @derive Jason.Encoder
  defstruct [:id, :name]

  def new(id, name) do
    %Person{
      id: id,
      name: name
    }
  end
end
