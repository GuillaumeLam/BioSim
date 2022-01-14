module BioSim

using Random

include("gene.jl")
export Gene

include("genome.jl")
export Genome
export addGene!, randGenome!, randGenome, randGenomeStr

end
