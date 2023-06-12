
defmodule OneMax do
  @behaviour Problem 
  alias Types.Chromosome 

  @impl true
  def genotype do
    genes = for _ <- 1..1000, do: Enum.random(0..1)
    %Chromosome{genes: genes, size: 1000}
  end

  @impl true
  def fitness_function(chromosome), do: Enum.sum(chromosome.genes)

  @impl true
  def terminate?(population), do:
    hd(population).fitness >= 1000
  end


soln = Genetic.run(OneMax)
IO.inspect(soln)
