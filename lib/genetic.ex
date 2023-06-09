
defmodule Genetic do
  @moduledoc """
  Documentation for `Genetic`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Genetic.hello()
      :world

  """

  alias Types.Chromosome

  def initialize(genotype, opts \\ []) do
    population_size = Keyword.get(opts, :population_size, 100)
    for _ <- 1..population_size, do: genotype.()
  end

  def evaluate(population, fitness_function, opts \\ []) do
    population 
    |> Enum.map( fn chromosome -> 
      fitness = fitness_function.(chromosome)    
      age = chromosome.age + 1
      %Chromosome{chromosome | fitness: fitness, age: age}
    end)  
    |> Enum.sort_by(& &1.fitness, &>=/2)  
  end

  def crossover(population) do
    #IO.inspect(population)
    population 
    |> Enum.reduce([], fn {ind1, ind2}, acc ->
        crossover_point = Enum.random(1..length(ind1.genes))
        {{h1, t1}, {h2, t2}} = {Enum.split(ind1.genes, crossover_point), Enum.split(ind2.genes, crossover_point)}
        {c1, c2} = {%Chromosome{genes: h1 ++ t2}, %Chromosome{genes: h2 ++ t1}}
        [c1 | [c2 | acc]]
        end
    )
  end

  def crossover2(population) do
    #IO.write("\nCrossover:\n")
    #IO.inspect(population)
    population 
    |> Enum.flat_map(fn {ind1, ind2} ->
        crossover_point = Enum.random(1..length(ind1))
        {{h1, t1}, {h2, t2}} = {Enum.split(ind1, crossover_point), Enum.split(ind2, crossover_point)}
        [h1 ++ t2, h2 ++ t1]
        end
    )
  end

  def selection(population) do
    #IO.write("\nSelection:\n")
    #IO.inspect(population)
    Enum.chunk_every(population,2) |>
    Enum.map(fn [a, b] ->
      {a, b}  
      end
    )
    end 

  def mutation(population) do 
    #IO.write("\nMutation:\n")
    #IO.inspect(population)
    population 
    |> Enum.map(fn chromosome -> 
      if :rand.uniform() <= 0.05 do 
        %Chromosome{ genes: Enum.shuffle(chromosome.genes)}
      else
        chromosome
      end
    end
    )
  end

  def evolve(population, problem, opts \\ []) do
    population = evaluate(population, &problem.fitness_function/1, opts)
    best = hd(population)
    IO.write(to_string(problem.fitness_function(best)) <> "\n")
    if problem.terminate?(population) do
      IO.write("best:")
      best
    else
      population
      |> selection()
      |> crossover()
      |> mutation()
      |> evolve(problem , opts)
    end
  end

  def run(problem, opts \\ []) do
    population = initialize(&problem.genotype/0)
    IO.write(Enum.count(population))
    IO.write("\nInitial:\n")
    IO.inspect(population)
    population
    |> evolve(problem) 
  end
end
