using DelimitedFiles
using DataFrames
using Random
using CSV
using Dates
using Gadfly, RDatasets
import Cairo, Fontconfig

dados = DataFrame()
# eixo_x = open("data.txt", "r")
# dados_x = readline(eixo_x)
eixoy = open("recompensa_acum.txt", "r")
global dadoy = []
while !eof(eixoy)
    line = parse.(Float64,readline(eixoy))
    # println(line)
    append!(dadoy,line)
end
# print(dadoy)

println("ndims: ", ndims(dadoy), " size: ", size(dadoy, 1))
eixox = open("data_historico.txt", "r")
while !eof(eixox)
    line = parse.(Date,readline(eixoy))
    println(line)
    append!(dadox,line)
end
print(dadox)

# dadox = [1:123;]

p = plot(x = dadox, y = dadoy)
draw(PNG("recompensa.png", 22cm, 15cm), p)
close(eixoy)
close(eixox)
