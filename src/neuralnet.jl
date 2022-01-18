struct NeuralNet
    connections::Vector{Gene}
    neurons::Dict{Int,AbstractNeuron}

    function NeuralNet(g::Genome)
        conn = Vector{Gene}()
        moduloConnNum!(g, conn)
		keepUsedConn!(conn)
		orderConn!(conn)

		neurons = Dict{Int,AbstractNeuron}()
		genNeurons!(conn, neurons)
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

function moduloConnNum!(g::Genome, conn::Vector{Gene}; maxNeurons=10)
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

# Use list of used internal neurons to keep only connections involving them
# & Change numbering of nodes to 1:length(usedNodes)
function keepUsedConn!(conn::Vector{Gene})
	usedNodes = Vector{Int}()
	getUsedNodes!(conn, usedNodes)
	filter!(gene->
		!(gene.sourceType==0&&gene.sourceNum∉usedNodes)&&
		!(gene.sinkType==0&&gene.sinkNum∉usedNodes),
		conn
	)
	remapConn!(conn, usedNodes)
end

# Tree search starting from Action Neurons
function getUsedNodes!(conn::Vector{Gene}, nodes::Vector{Int}, node::Union{Gene,Nothing}=nothing)
    if isnothing(node) # starting case: find action neurons and recurse on them
		# split on sink type
		# no need to pass around & search full list
		# filter out internal neurons with self output
        actionNeurons = filter(gene->gene.sinkType==1,conn)
        # rest = filter(
		# 	gene->gene.sinkType==0&&(gene.sinkNum!=gene.sourceNum||gene.sourceType!=0),
		# 	conn
		# )
        rest = filter(gene->gene.sinkType==0,conn)

		# mutating version
		# ================
        for an in actionNeurons
            append!(nodes, getUsedNodes!(rest, nodes, an))
            unique!(nodes)
			sort!(nodes)
        end

		# non-mutating version
		# ====================
        # v = Vector{Int}()
		# for an in actionNeurons
		# 	append!(v, getUsedNodes!(rest,nodes,an))
		# end
		# unique!(v)
		# sort!(v)
		# return v

    elseif node.sourceType == 1 # base case: found a path to sensor neuron
        return nodes
    else # found conn from internal node
        neurons = filter(gene->gene.sinkNum==node.sourceNum, conn)
        rest = filter(gene->gene.sinkNum!=node.sourceNum, conn)

		if isempty(neurons)
			nodes = vcat(nodes,node.sourceNum)
		else
			for n in neurons
	            usedNeuron = getUsedNodes!(rest,vcat(nodes, node.sourceNum), n)
	            nodes = vcat(nodes, usedNeuron)
	        end
		end

        return nodes
    end
end

function orderConn!(conn::Vector{Gene})
	fromSnsr = Vector{Gene}()
	toNeuron = Vector{Gene}()
	toAction = Vector{Gene}()

	for gene in conn
		if gene.sourceType==1
			push!(fromSnsr, gene)
		elseif gene.sinkType==0
			push!(toNeuron, gene)
		else
			push!(toAction, gene)
		end
	end
	empty!(conn)
	append!(conn, fromSnsr)
	append!(conn, toNeuron)
	append!(conn, toAction)
end

function genNeurons!(conn::Vector{Gene}, neurons::Dict{Int,AbstractNeuron})
	for gene in conn
		if gene.sourceType==0 && !haskey(neurons, gene.sourceNum)
			neurons[gene.sourceNum]=BioSim.Neuron(false)
		end

		if gene.sinkType==0
			if !haskey(neurons, gene.sinkNum)
				neurons[gene.sinkNum]=BioSim.Neuron(true)
			else
				neurons[gene.sinkNum].driven = true
			end
		end
	end
end

#+++++

# feedfoward
function (brain::NeuralNet)()
    return true
end
