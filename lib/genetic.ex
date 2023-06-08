
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

  def evolve(population, fitness_function,  max_fitness) do
    population = evaluate(population, fitness_function)
    best = hd(population)
    if fitness_function.(best) >= max_fitness do
      IO.write("best:")
      best
    else
      population
      |> evaluate(fitness_function)
      |> hd
      # |> selection.()
      # |> crossover.()
      # |> mutation.()
      # |> algorithm.(algorithm, config + 1)
    end
  end

  def run(genotype, fitness_function, max_fitness) do
    population = initialize(genotype)
    IO.write(Enum.count(population))
    population
    |> evolve(fitness_function, max_fitness) 
  end
end
