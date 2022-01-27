struct NeuralNet
    connections::Vector{Gene}
    neurons::Dict{Int,Neuron}

    function NeuralNet(g::Genome; maxNeurons=10, numSensors=21, numActions=11)
        conn = Vector{Gene}()
        moduloConnNum!(g, conn, maxNeurons=maxNeurons, numSensors=numSensors, numActions=numActions)
		keepUsedConn!(conn)
		orderConn!(conn)

		neurons = Dict{Int,Neuron}()
		genNeurons!(conn, neurons)
		return new(conn, neurons)
    end

    function NeuralNet(genomeStr::Vector{String}; maxNeurons=10, numSensors=21, numActions=11)
        return NeuralNet(Genome(genomeStr), maxNeurons=maxNeurons, numSensors=numSensors, numActions=numActions)
    end
end

#+++++
# Constructor func
#+++++

function moduloConnNum!(g::Genome, conn::Vector{Gene}; maxNeurons, numSensors, numActions)
    for gene in g.genome
        if gene.sourceType == 0 # ie a neuron
            gene.sourceNum %= maxNeurons
        else
            gene.sourceNum %= numSensors
        end


        if gene.sinkType == 0 # ie a neuron
            gene.sinkNum %= maxNeurons
        else
            gene.sinkNum %= numActions
        end

		# 1-index all nums
		gene.sourceNum += 1
		gene.sinkNum += 1

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

# Replace largest val num for missing num, then use second largest
# Eg. [1 3 4] (source/sink)Num 4 => 2
# More effecient than 'moving' them down in value one by one
function remapConn!(conn::Vector{Gene}, nodes::Vector{Int})
	offset = 0

	for i in 1:length(nodes)
		idx = findfirst(x->x==i,nodes)
		if isnothing(idx)
			changeNodeNum!(conn,nodes[end-offset],i)
			offset += 1
		end
	end
end

function changeNodeNum!(conns::Vector{Gene}, oldNum::Int, newNum::Int)
	for conn in conns
		if conn.sinkType == 0 && conn.sinkNum == oldNum
			conn.sinkNum = UInt8(newNum)
		end
		if conn.sourceType == 0 && conn.sourceNum == oldNum
			conn.sourceNum = UInt8(newNum)
		end
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

#+++++

function genNeurons!(conn::Vector{Gene}, neurons::Dict{Int,Neuron})
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
# Struct func
#+++++

# tmp function to debug
getSensor(a) = return 0.5

# feedfoward ie step forward in time the neural network
function step(brain::NeuralNet, sim, boid)
	actionLevels = zeros(NUM_ACTIONS)
	neuronAcc = zeros(length(brain.neurons))
	neuronOutputComp = false

	for conn in brain.connections
		if conn.sinkType == 1 && !neuronOutputComp
			for (key, neuron) in brain.neurons
				if neuron.driven
					neuron.output = tanh(neuronAcc[key])
				end
			end
			neuronOutputComp = true
		end

		inputVal = rand(Float64)

		if conn.sourceType == 1
			# inputVal = getSensor(conn.sourceNum)
			inputVal = boid.sensors(conn.sourceNum, sim, boid)
		else
			inputVal = brain.neurons[conn.sourceNum].output
		end

		if conn.sinkType == 1
			actionLevels[conn.sinkNum] += inputVal * conn.weight
		else
			neuronAcc[conn.sinkNum] += inputVal * conn.weight
		end
	end
	return actionLevels
end

function toRGB(nn::NeuralNet)
    color = 0

    for gene in nn.connections
        color += gene.hex
    end

	bStr = lpad(string(color % 0xffffff, base=2),24,"0")
	R = parse(UInt, bStr[1:8], base=2)/255
	G = parse(UInt, bStr[9:16], base=2)/255
	B = parse(UInt, bStr[17:24], base=2)/255
    return RGB(R,G,B)
end

function display(nn::NeuralNet)
	#make graph of boid's brain
	sensors = Dict{Int,Int}()
	actions = Dict{Int,Int}()

	for conn in nn.connections
		if conn.sourceType==1 & !haskey(sensors, conn.sourceNum)
			sensors[conn.sourceNum] = 0
		end
		if conn.sinkType==1 & !haskey(actions, conn.sinkNum)
			actions[conn.sinkNum] = 0
		end
	end

	s = sort!(collect(keys(sensors)))
	a = sort!(collect(keys(actions)))

	size = length(sensors) + length(nn.neurons) + length(actions)

	g = zeros(size, size)
	edgelabels = Dict{Tuple{Int,Int},String}()
	edgecolor = []

	for conn in nn.connections
		f = 0
		if conn.sourceType == 0
			f = length(sensors) + (conn.sourceNum+1)
		else
			f = findfirst(x->x==conn.sourceNum,s)
		end

		t = 0

		if conn.sinkType == 0
			t = length(sensors) + (conn.sinkNum+1)
		else
			t = length(sensors) +
				length(nn.neurons) +
				findfirst(x->x==conn.sinkNum,a)
		end

		g[f,t] = 1
		push!(edgecolor, conn.weight>0 ? colorant"#00FF7F" : colorant"#DC143C")
		edgelabels[(f,t)]=string(round(conn.weight,digits=3))
	end

	n = sort!(collect(keys(nn.neurons)))

	nodenames = []
	nodecolor = []

	for i in s
		push!(nodenames, "S$i")
		push!(nodecolor, colorant"#9558B2")
	end
	for i in n
		push!(nodenames, "N$i")
		push!(nodecolor, colorant"#389826")
	end
	for i in a
		push!(nodenames, "A$i")
		push!(nodecolor, colorant"#CB3C33")
	end

	# save("brain_graphplot.png",graphplot(...))

	return graphplot(
		g,
		names=nodenames,
		nodecolor=nodecolor,
		nodeshape=:circle,
		nodesize=0.15,
		edgelabel=edgelabels,
		edgestrokec=edgecolor,
		edgelabel_offset=0.09,
		edge_label_box=true,
		curvature_scalar=0.025,
		arrow=arrow(:closed, :head)
	)
end
