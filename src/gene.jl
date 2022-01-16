mutable struct Gene
    sourceType::UInt8  # 1bit SENSOR / NEURON
    sourceNum::UInt8   # 7bit
    sinkType::UInt8    # 1bit NEURON / ACTION
    sinkNum::UInt8     # 7bit
    weight::Int32       # 16bit

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
    bStr = string(hex, base=2)

    if length(bStr)<32
        bStr = lpad(bStr,32,"0")
    end

    soT = parse(UInt8, bStr[1], base=2)
    soN = parse(UInt8, bStr[2:8], base=2)
    siT = parse(UInt8, bStr[9], base=2)
    siN = parse(UInt8, bStr[9:16], base=2)
    w = parse(Int32, bStr[17:32], base=2)

    return soT, soN, siT, siN, w
end

#+++++
