struct NeuralNet
    connections::Vector{Gene}
    neurons::Vector{AbstractNeuron}

    function NeuralNet(g::Genome)
        conn = Vector{Gene}()
        renumberConn!(g, conn)
		getUsedConn!(conn)

        # take used connections & reorder
        # iter in 2 passes
        # O(2n)
        # pass 1: add from (source or neuron) to neuron
        # pass 2: add from (source or neuron) to action
        # or
        # O(n)
        # iter on all
        # if (source or neuron) to neuron
        # 	add to neurons
        # else
        # 	add to tmp_neurons
        # append!(neurons, tmp_neurons)

		neurons = Vector{AbstractNeuron}()
		# iter thru conn & add neuron
		# reorder conn numbers or make neurons = Dict{Int,AbstractNeuron}

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

# Tree search starting from Action Neurons to Sensor Neurons
function getUsedConn!(conn::Vector{Gene})
	usedNeuron = Vector{Int}()
	getUsedNeuron!(conn, usedNeuron)
	filter!(gene->
		!(gene.sourceType==0&&gene.sourceNum∉usedNeuron)&&
		!(gene.sinkType==0&&gene.sinkNum∉usedNeuron),
		conn
	)
end

# Tree search starting from Action Neurons to Sensor Neurons
function getUsedNeuron!(conn::Vector{Gene}, nodes::Vector{Int}, node::Union{Gene,Nothing}=nothing)
    if isnothing(node) # starting case: find action neurons and recurse on them
		# split on sink type
		# no need to pass around & search full list
		# filter out internal neurons with self output
        actionNeurons = filter(gene->gene.sinkType==1,conn)
        rest = filter(
			gene->gene.sinkType==0&&(gene.sinkNum!=gene.sourceNum||gene.sourceType!=0),
			conn
		)

		# mutating version
		# ================
        for an in actionNeurons
            append!(nodes, getUsedNeuron!(rest, nodes, an))
            unique!(nodes)
        end
        return nodes

		# non-mutating version
		# ====================
        # v = Vector{Int}()
		# for an in actionNeurons
		# 	append!(v, getUsedNeuron!(rest,nodes,an))
		# end
		# return unique!(v)

    elseif node.sourceType == 1 # base case: found a path to sensor neuron
        return nodes
    else # found conn from internal node
        neurons = filter(gene->gene.sinkNum==node.sourceNum, conn)
        rest = filter(gene->gene.sinkNum!=node.sourceNum, conn)

        for n in neurons
            usedNeuron = getUsedNeuron!(rest,vcat(nodes, node.sourceNum), n)
            nodes = vcat(nodes, usedNeuron)
        end

        return nodes
    end
end

#+++++

# take genome and generate brain

# feedfoward
function (brain::NeuralNet)(x)
    return x
end
