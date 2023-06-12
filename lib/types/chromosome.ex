
defmodule Types.Chromosome do
  @type t :: %__MODULE__{
    genes: Enum.t,
    fitness: number(),
    size: integer(),
    age: integer()
  }

@enforce_keys :genes

defstruct [:genes, size: 0, fitness: 0, age: 0] 
end

