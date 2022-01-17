using BioSim
using BenchmarkTools

genomeStr = randGenomeStr(16)

genome = @btime Genome(genomeStr)
# mutable gene  -> 5.927 μs (106 allocations: 4.59 KiB)
# immutable gene-> 6.007 μs (93 allocations: 4.44 KiB)

nn = @btime NeuralNet(genome)
# 1.220 μs (5 allocations: 432 bytes)


genomeTest1 = [
    "8181ffff"
]   # correct output: []
genomeTest2 = [
    "0181ffff",
    "8101ffff",
    "8105ffff"
]   # correct output: [1]
genomeTest2a = [
    "0281ffff",
    "0102ffff",
    "8101ffff"
]   # correct output: [1,2]
genomeTest3 = [
    "0181abcd",
    "0102bbcd",
    "0201ffff",
    "0202aaaa",
    "81021111",
    "01032222"
]   # correct output: [1,2]
genomeTest4 = [
    "8101aaaa",
    "0181bbbb",
    "0182cccc"
] # correct output: [1]
genomeTest5 = [
    "8101aaaa",
    "0181bbbb",
    "8202aaaa",
    "0281bbbb"
] # correct output: [1,2]
genomeTest5a = [
    "8101aaaa",
    "0181bbbb",
    "8203aaaa",
    "0281bbbb",
    "0203ffff",
    "0302ffff",
    "0381aaaa"
] # correct output: [1,2,3]
genomeTest5b = [
    "8101aaaa",
    "0181bbbb",
    "8203aaaa",
    "0281bbbb",
    "0203ffff",
    "0302ffff",
    "0381aaaa",
    "0401abcd",
    "0104abcd",
    "0305dddd"
] # correct output: [1,2,3,4]
genomeTest6 = [
    "8104aaaa",
    "8105aaaa",
    "8103aaaa",
    "0402bbbb",
    "0505cccc",
    "0502cccc",
    "0203dddd",
    "0201eeee",
    "0301eeee",
    "0181abcd"
] # correct output: [1:5]
genomeTest7 = [
    "8107aaaa",
    "8209aaaa",
    "0705bbbb",
    "0808bbbb",
    "0806bbbb",
    "0905bbbb",
    "0906bbbb",
    "0481cccc",
    "0501cccc",
    "0606cccc",
    "0602cccc",
    "0603cccc",
    "0181dddd",
    "0282dddd"
] # correct output: [1,2,4,5,6,7,8,9]
genomeTest8 = [
    "8101aaaa",
    "0181cccc",
    "0201bbbb",
    "0202bbbb"
] # correct output: [1,2]
genomeTest9 = [
    "8101aaaa",
    "0102bbbb",
    "0181cccc"
] # correct output: [1]
genomeTest10 = [
    "8101aaaa",
    "8102aaaa",
    "0181bbbb"
] # correct output: [1]
genomeTest11 = [
    "8182aaaa",
    "0101bbbb",
    "0181bbbb",
    "0182bbbb"
] # correct output: [1]
genomeTest12 = [
    "8181aaaa",
    "8202aaaa",
    "0181bbbb",
    "0182bbbb",
    "0102bbbb",
    "0202bbbb",
    "0283bbbb"
] # correct output: [1,2]

tests = [
    genomeTest1,
    genomeTest2,
    genomeTest2a,
    genomeTest3,
    genomeTest4,
    genomeTest5,
    genomeTest5a,
    genomeTest5b,
    genomeTest6,
    genomeTest7,
    genomeTest8,
    genomeTest9,
    genomeTest10,
    genomeTest11,
    genomeTest12
]

usedNeuron = Vector{Int}()
getUsedNeuron!(Gene.(genomeTest2), usedNeuron)

tests_result = map(x->getUsedNeuron!(Gene.(x),usedNeuron), tests)
