using BioSim
using BenchmarkTools

genomeStr = randGenomeStr(16)

genome = @btime Genome(genomeStr)
# mutable gene  -> 5.927 μs (106 allocations: 4.59 KiB)
# immutable gene-> 6.007 μs (93 allocations: 4.44 KiB)

nn = @btime NeuralNet(genome)
# 1.220 μs (5 allocations: 432 bytes)
