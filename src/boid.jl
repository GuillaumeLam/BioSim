mutable struct Boid
    location::Tuple{Int,Int}
    genome::Genome
    brain::NeuralNet
    age::UInt32
    alive::Bool
    lastMoveDir::UInt8 # 1->N, 2->W, 3->S, 4->E
    responsiveness::Float16
    probDist::UInt8
    # might remove some params, not sure boid need all this info

    Boid(genome::Vector{String}) = Boid((0,0), genome)

    Boid(location::Tuple{Int,Int}, genome::Genome) =
        new(location, genome, NeuralNet(genome), 0, true, rand(1:4), 0.5, 16)

    function Boid(location::Tuple{Int,Int}, genomeLength::Int)
        genome = Genome(genomeLength)
        return Boid(location, genome)
    end

    Boid(location::Tuple{Int,Int}) = Boid(location, 16)
end

function (boid::Boid)()
    boid.age += 1

    return boid.brain()
end

# reproduction
# mutation
# use genome to color for visual

function toRGB(boid::Boid)
    return toRGB(boid.brain)
end
