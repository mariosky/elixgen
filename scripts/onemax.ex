
genotype = fn -> for _ <- 1..100, do: Enum.random(0..1) end

fitness_function = fn chromosome -> Enum.sum(chromosome) end
max_fitness = 100

soln = Genetic.run(genotype, fitness_function, max_fitness)

IO.inspect(soln, limit: :infinity)
#IO.write(fitness_function.(soln))
