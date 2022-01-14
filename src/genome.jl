struct Genome
    genome::Vector{Gene}

    Genome() = new(Vector{Gene}())
    Genome(genomeStr::Vector{String}) = new(Gene.(genomeStr))
end

function addGene!(genome::Genome, gene::Gene)
    push!(genome.genome, gene)
end

function randGenome!(genome::Genome, n)
    for _ in 1:n
        addGene!(genome, Gene())
    end
end

function randGenome(n)
    genome = Genome()
    randGenome!(genome, n)
    return genome
end

function randGenomeStr(n)
    vec = Vector{String}()

    for _ in 1:n
        push!(vec, Random.randstring(['a':'f'; '0':'9'], 8))
    end

    return vec
end
