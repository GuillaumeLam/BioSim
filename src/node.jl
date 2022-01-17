mutable struct Node
    remappedNumber::Int
    numOutputs::Int
    numSelfInputs::Int
    numSensorInORNeurons::Int
end
# tmp struct for building of brain
# this struct allows us to keep track of connections to & from each node
# helps cut useless connections

#+++++
# Constructor func
#+++++

# Iter through connections & track internal neuron using Node struct in dict
function popNodeDict!(conns::Vector{Gene}, nodeDict::Dict{Int,Node})
    for gene in conns
        if gene.sinkType == 0
            if !haskey(nodeDict, gene.sinkNum)
                nodeDict[gene.sinkNum] = Node(0,0,0,0)
            end

            node = nodeDict[gene.sinkNum]

            if gene.sourceType == 0 && (gene.sourceNum == gene.sinkNum)
                node.numSelfInputs += 1
            else
                node.numSensorInORNeurons += 1
            end
        end

        if gene.sourceType == 0
            if !haskey(nodeDict, gene.sourceNum)
                nodeDict[gene.sourceNum] = Node(0,0,0,0)
            end

            node = nodeDict[gene.sourceNum]
            node.numOutputs += 1
        end
    end
end

# Remove all neurons with no outputs or only outputs to itself
# Removing a node may results in other nodes needing to be removed
function cullNeurons!(conn::Vector{Gene}, nodeDict::Dict{Int,Node})
    done = false

    while !done
        done = true

        nodeDictCpy = copy(nodeDict)
        #iter thru cpy while editing original

        for (key,node) in nodeDictCpy
            if node.numOutputs == node.numSelfInputs
                done = false
                rmvConnToNeuron!(conn, nodeDict, key)
                #remove
                delete!(nodeDict, key)
            # else
            #     #incr key of entry in dict
            #     delete!(nodeDict, key)
            #     nodeDict[(key+1)] = node
            end
        end
    end
end

# Remove connections to neuron we are culling
function rmvConnToNeuron!(conn::Vector{Gene}, nodeDict::Dict{Int,Node}, neuronNum::Int)
    for gene in conn
        if gene.sinkType == 0 && gene.sinkNum == neuronNum
            if gene.sourceType == 0
                nodeDict[gene.sourceNum].numOutputs -= 1
            end
            # deleteat!(conn, )
        else

        end
    end
end
