mutable struct Gene
    sourceType::UInt8  # 1bit SENSOR / NEURON
    sourceNum::UInt8   # 7bit
    sinkType::UInt8    # 1bit NEURON / ACTION
    sinkNum::UInt8     # 7bit
    weight::Int16       # 16bit

    hex::UInt32

    function Gene()
        gene = Random.randstring(['a':'f'; '0':'9'], 8)
        return new(parseHex(gene)...)
    end

    function Gene(hexStr)
        return new(parseHex(hexStr)...)
    end
end

#+++++
# Constructor func
#+++++

# const SENSOR = UInt8(1) # always a source
# const ACTION = UInt8(1) # always a sink
# const NEURON = UInt8(0) # either source or sink

function parseHex(hStr)
    # todo: add check that strings are hex vals of length 8
    hex = parse(UInt32, hStr, base=16)
    bStr = lpad(string(hex, base=2),32,"0")

    soT = parse(UInt8, bStr[1], base=2)
    soN = parse(UInt8, bStr[2:8], base=2)
    siT = parse(UInt8, bStr[9], base=2)
    siN = parse(UInt8, bStr[10:16], base=2)
    w = reinterpret(Int16, parse(UInt16, hStr[5:8],base=16))

    return soT, soN, siT, siN, w, hex
end

#+++++
# Overload func
#+++++

function Base.getproperty(g::Gene, p::Symbol)
    if p == :weight
        return (getfield(g, p) / 8192.0)
    elseif p == :weightInt
        return getfield(g,:weight)
    else
        return getfield(g,p)
    end
end
