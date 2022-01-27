module BioSim

using BenchmarkTools

using Random

using Images
using Plots
using GraphRecipes


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

include("sensorsinput.jl")
export SensorsInput

include("boid.jl")
export Boid

include("environment.jl")
export Environment
export findEmptyLoc, pop!

include("simulator.jl")
export Simulator
export run

end
