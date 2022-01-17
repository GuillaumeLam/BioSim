module BioSim

using BenchmarkTools

using Random

include("gene.jl")
export Gene

include("genome.jl")
export Genome
export addGene!, randGenome!, randGenome, randGenomeStr

include("neuron.jl")
include("node.jl")
include("neuralnet.jl")
export NeuralNet
export getUsedConn!, getUsedNeuron!

end
