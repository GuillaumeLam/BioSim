struct NeuralNet
    connections::Vector{Gene}
    neurons::Vector{AbstractNeuron}

    function NeuralNet(g::Genome)
        conn = Vector{Gene}()
        renumberConn!(g, conn)

        neurons = Vector{AbstractNeuron}()
        return new(conn, neurons)
    end

    function NeuralNet(genomeStr::Vector{String})
        return NeuralNet(Genome(genomeStr))
    end
end

#+++++
# Constructor func
#+++++

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

#+++++

# take genome and generate brain

# feedfoward
function (brain::NeuralNet)(x)
    return x
end
