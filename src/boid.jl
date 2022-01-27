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

    sensors::SensorsInput
    # actions::Actions

    function Boid(location::Tuple{Int,Int}, genome::Genome)
        sensors = SensorsInput()
        new(
            location,
            genome,
            NeuralNet(genome, numSensors=length(sensors)),
            0,
            true,
            rand(1:4),
            0.5,
            16,
            sensors
        )
    end

    Boid(genome::Vector{String}) = Boid((0,0), genome)

    function Boid(location::Tuple{Int,Int}, genomeLength::Int)
        genome = Genome(genomeLength)
        return Boid(location, genome)
    end

    Boid(location::Tuple{Int,Int}) = Boid(location, 16)
    Boid() = Boid((0,0))
end

function step(boid::Boid, sim)
    boid.age += 1

    actionLevels = step(boid.brain, sim, boid)
    return nothing
end

# reproduction
# mutation
# use genome to color for visual

function toRGB(boid::Boid)
    return toRGB(boid.brain)
end
