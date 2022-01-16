# tmp struct for building of brain
# this struct allows us to keep track of connections
struct Node
    remappedNumber::Int
    numOutputs::Int
    numSelfInputs::Int
    numSensorInORNeurons::Int
end

NUM_SENSORS = 21
NUM_ACTIONS = 11

function renumberConn!(g::Genome, conn::Vector{Gene}; maxNeurons=10)
    for gene in g.genome
        if gene.sourceType == 0 # ie a neuron
            gene.sourceNum %= maxNeurons
        else
            gene.sourceNum %= NUM_SENSORS
        end

        if gene.sinkType == 0 # ie a neuron
            gene.sinkNum %= maxNeurons
        else
            gene.sinkNum %= NUM_SENSORS
        end

        push!(conn, gene)
    end
end
