module BioSim

using BenchmarkTools

using Images
using Plots
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

include("boid.jl")
export Boid

include("environment.jl")
export Environment
export findEmptyLoc, pop!

end
