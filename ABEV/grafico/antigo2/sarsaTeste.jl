#""" lendos dados csv"""
using DelimitedFiles
using DataFrames
using Random
using CSV
using Dates
using Gadfly, RDatasets
import Cairo, Fontconfig

include("sarsafunction.jl")
include("sarsaconstants.jl")


""" Inicializa todos os valores de Q(e,a) arbitrariamente """
dadosTeste = "dados/ABEV3teste.csv"
dictChave = "dict/chave/chave.txt"
dictValor = "dict/valor/valor.txt"

date = []
fechamento = []
posicao = []
preco_long = 0.0
preco_short = 0.0
historico = []
historico_acumulado = []
recompensa_acumulada = 0
recompensa = 0
cont = 1

""" Cria o dicionario """
Q_e_a = criaQTeste(dictChave, dictValor)


dados = open(dadosTeste, "r")
result = open("saida/result_teste.txt", "w")
#***********************************************
""" Testa algoritmo"""
estado = zeros(Int64,10)
proximo_estado = zeros(Int64,10)
cabecalho = readuntil(dados,"%")
linhat3 = split(readuntil(dados,"%"),";")
linhat3 = parse.(Float32,linhat3[3:8])
linhat2 = split(readuntil(dados,"%"),";")
linhat2 = parse.(Float32,linhat2[3:8])
linhat1 = split(readuntil(dados,"%"),";")
linhat1 = parse.(Float32,linhat1[3:8])
linhat0= split(readuntil(dados,"%"),";")
linhat0= parse.(Float32,linhat0[3:8])
primeiroEstado(estado, linhat0, linhat1, linhat2, linhat3)

acao = escolheAcaoTeste(result, estado)

println(result, "***************")
println(result, "estado ", cont, "\n")

while !eof(dados)
      global linhat1
      global linhat0
      global dados
      global estado
      global acao
      global cont
      global date
      global fechamento
      global historico
      global historico_acumulado
      global recompensa_acumulada
      global recompensa
      global posicao
      global preco_long
      global preco_short


      linhat2 = linhat1
      linhat1 = linhat0
      linhat0 = split(readuntil(dados,"%"),";")
            dia = parse.(Int16,split(linhat0[2], "."))
            dia2 = Date(dia[3],dia[2],dia[1])
            date = [date; dia2]
      linhat0= parse.(Float32,linhat0[3:8])
      append!(fechamento, linhat0[4])
      append!(posicao, estado[1])

      """ Executa a açao """
      proximo_estado = executaAcao(result, estado, acao,linhat0,linhat1, linhat2, preco_long,preco_short)
      println(result, "linha t1 ", linhat1)
      println(result, "linha t0 ", linhat0)
      # IMPRIME ESTADO E PROXIMO ESTADO
      println(result, "                    1     2   3   4   5    6     7     8    9")
      print(result, "        ")
      printEstado(result, estado)
      println(result, "recompensa: ", recompensa, " estado: ", estado[10], " valor atual: ", linhat1[4])
      cont = cont + 1
      print(result, "proximo ")
      printEstado(result, proximo_estado)

      """ Atualiza preco_short e preco_long de entrada (se for o caso)"""
      preco_long, preco_short = atualizaPreco1(preco_long, preco_short, acao, linhat1)

      # """ Calcula recompensa r(proximo estado)"""
      # r = calculaRecompensa(proximo_estado, estado, acao, linhat0)
      # recompensa = recompensa + r

      """ Calcula recompensa r(proximo estado)"""
      recompensa_acumulada = recompensa_acumulada + recompensa
      # proxima_recompensa = calculaRecompensa(preco_long, preco_short, acao, linhat0)
      proxima_recompensa = calculaRecompensa(preco_long, preco_short,estado, acao, linhat0)

      println(result, "prox recompensa: ", proxima_recompensa, " estado: ", proximo_estado[10], " valor prox: ", linhat0[4])
      println(result, "preco atual: ", linhat1[4], " preco proximo: ", linhat0[4])

      """ Atualiza preco_short e preco_long na saida(se for o caso)"""
      preco_long, preco_short = atualizaPreco2(preco_long, preco_short, acao, linhat1)


      append!(historico, round(recompensa, digits =4 ))
      append!(historico_acumulado, round(recompensa_acumulada, digits = 4))

      """Escolhe a proxima acao"""
      proxima_acao = escolheAcaoTeste(result, proximo_estado)


      """ Atualiza Q(e,a) """
      antes = Q_e_a[acao]
      proximo = Q_e_a[proxima_acao]
      Q_e_a[acao] = Q_e_a[acao] + taxa_aprendizado * (proxima_recompensa + fator_desconto* Q_e_a[proxima_acao] - Q_e_a[acao])
      println(result, "antes: ", antes," proximo: ", proximo, " teste dict: ", Q_e_a[acao])

      """ atualiza estado e acao """
      estado = proximo_estado
      acao = proxima_acao
      recompensa = proxima_recompensa

      println(result, "***************")
      println(result, "estado ", cont, "\n")
end

df = DataFrame(Data = date, Close = fechamento, Recompensa = historico, RecompensaAcumulada = historico_acumulado, Estado = posicao)

CSV.write("resultado.csv", df)
gclose = plot(df, x = :Data, y = :Close, Geom.line)
draw(PNG("grafico/fechamento.png", 50cm, 15cm), gclose)

grecompAcum = plot(df, x = :Data, y = :RecompensaAcumulada, Geom.line)
draw(PNG("grafico/recompensaAcum.png", 50cm, 15cm), grecompAcum)

grecomp = plot(df, x = :Data, y = :Recompensa, color = :Estado , Geom.bar)
draw(PNG("grafico/recompensa.png", 40cm, 15cm), grecomp)

print(df)
close(dados)
close(result)
