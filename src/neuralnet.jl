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

# take genome and generate brain

# feedfoward
function (brain::NeuralNet)(x)
    return x
end
