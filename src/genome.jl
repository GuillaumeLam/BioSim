struct Genome
    genome::Vector{Gene}

    Genome() = new(Vector{Gene}())
    Genome(genomeStr::Vector{String}) = new(Gene.(genomeStr))
    Genome(n::Int) = Genome(randGenomeStr(n))
end

function randGenomeStr(n)
    vec = Vector{String}()

    for _ in 1:n
        push!(vec, Random.randstring(['a':'f'; '0':'9'], 8))
    end

    return vec
end
