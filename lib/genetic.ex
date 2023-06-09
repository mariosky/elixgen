
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

  def initialize(genotype) do
    for _ <- 1..100, do: genotype.()
  end

  def evaluate(population, fitness_function) do
    population 
    |> Enum.sort_by(fitness_function, &>=/2)  
  end

  def crossover(population) do
    #IO.inspect(population)
    population 
    |> Enum.reduce([], fn {ind1, ind2}, acc ->
        crossover_point = Enum.random(1..length(ind1))
        {{h1, t1}, {h2, t2}} = {Enum.split(ind1, crossover_point), Enum.split(ind2, crossover_point)}
        [h1 ++ t2, h2 ++ t1 | acc ]
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
      if :random.uniform() <= 0.05 do 
        Enum.shuffle(chromosome) 
      else
        chromosome
      end
    end
    )
  end

  def evolve(population, fitness_function,  max_fitness) do
    population = evaluate(population, fitness_function)
    best = hd(population)
    IO.write(to_string(fitness_function.(best)) <> "\n")
    if fitness_function.(best) >= max_fitness do
      IO.write("best:")
      best
    else
      population
      |> evaluate(fitness_function)
      # |> hd
      |> selection()
      |> crossover2()
      |> mutation()
      |> evolve(fitness_function, max_fitness)
    end
  end

  def run(genotype, fitness_function, max_fitness) do
    population = initialize(genotype)
    IO.write(Enum.count(population))
    IO.write("\nInitial:\n")
    IO.inspect(population)
    population
    |> evolve(fitness_function, max_fitness) 
  end
end
