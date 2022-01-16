# tmp struct for building of brain
# this struct allows us to keep track of connections
mutable struct Node
    remappedNumber::Int
    numOutputs::Int
    numSelfInputs::Int
    numSensorInORNeurons::Int
end

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
