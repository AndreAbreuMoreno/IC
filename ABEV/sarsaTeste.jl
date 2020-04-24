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
p_enter_long = 0.0
p_enter_short = 0.0
historico = []
historico_acumulado = []
evol = []
evol2 = []
recompensa_acumulada = 0
recompensa = 0
cont = 1
evolucao_acumulada = 0
evolucao = 0
evolucao_acumulada2 = 0
evolucao2 = 0

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
      global evol
      global recompensa_acumulada
      global recompensa
      global posicao
      global p_enter_long
      global p_enter_short
      global evolucao_acumulada
      global evolucao
      global evolucao_acumulada2
      global evolucao2

      """   Ler nova linha do historico de valor das acoes
            linhat2 = estado anterior (t - 1)
            linhat1 = estado atual
            linhat0 = estado proximo
            Armazena a data do estado atual
      """
      linhat2 = linhat1
      linhat1 = linhat0
      linhat0 = split(readuntil(dados,"%"),";")
            dia = parse.(Int16,split(linhat0[2], "."))
            dia2 = Date(dia[3],dia[2],dia[1])
            date = [date; dia2]
      linhat0= parse.(Float32,linhat0[3:8])

      """   Armazena o preco de fechamento do estado atual
            Armazena a posicao do estado atual
      """
      append!(fechamento, linhat0[4])
      append!(posicao, estado[1])


      """   Atualiza p_enter_short e p_enter_long de entrada (se for o caso)"""
      p_enter_long, p_enter_short = atualizaPreco1(p_enter_long, p_enter_short, acao, linhat1)

      """   Executa a açao """
      println(result, "linha t1 ", linhat1)
      println(result, "linha t0 ", linhat0)
      proximo_estado = executaAcao(result, estado, acao,linhat0,linhat1, linhat2, p_enter_long,p_enter_short)

      """   Imprime estado atual e o proximo estado """
      print(result, "        ")
      printEstado(result, estado)
      cont = cont + 1
      print(result, "proximo ")
      printEstado(result, proximo_estado)

      """ Calcula recompensa r(t+1)"""
      recompensa_acumulada = recompensa_acumulada + recompensa
      recompensa = calculaRecompensa(p_enter_long, p_enter_short,estado, acao, linhat0)

      evolucao = calculaEvolucao(p_enter_long, p_enter_short, estado, acao, linhat0, linhat1)
      evolucao2 = calculaEvolucao2(p_enter_long, p_enter_short, estado, acao, linhat0, linhat1)
      evolucao_acumulada = evolucao_acumulada + evolucao
      evolucao_acumulada2 = evolucao_acumulada2 + evolucao2
      println(result, "recompensa: ", recompensa, " recomp_acumulada: ", recompensa_acumulada," long: ", p_enter_long, " short: ", p_enter_short)
      println(result, "preco atual: ", linhat1[4], " preco proximo: ", linhat0[4])
      append!(evol, round(evolucao_acumulada, digits = 4))
      append!(evol2, round(evolucao_acumulada2, digits = 4))
      append!(historico, round(recompensa, digits =4 ))
      append!(historico_acumulado, round(recompensa_acumulada*100, digits = 4))

      """ Atualiza p_enter_short e p_enter_long na saida(se for o caso)"""
      p_enter_long, p_enter_short = atualizaPreco2(p_enter_long, p_enter_short, acao, linhat1)

      """Escolhe a proxima acao"""
      proxima_acao = escolheAcaoTeste(result, proximo_estado)

      """ Atualiza Q(e,a) """
      antes = Q_e_a[acao]
      proximo = Q_e_a[proxima_acao]
      Q_e_a[acao] = atualizaQ(acao, proxima_acao, recompensa, taxa_aprendizado, fator_desconto)
      println(result, "antes: ", antes," proximo: ", proximo, " teste dict: ", Q_e_a[acao])

      """ atualiza estado e acao """
      estado = proximo_estado
      acao = proxima_acao


      println(result, "***************")
      println(result, "estado ", cont, "\n")
end

df = DataFrame(Data = date, Close = fechamento, Recompensa = historico, RecompensaAcumulada = historico_acumulado, Estado = posicao, Evolucao = evol, Evolucao2 = evol2)

CSV.write("resultado.csv", df)
gclose = plot(df, x = :Data, y = :Close, Geom.line)
draw(PNG("grafico/fechamento.png", 50cm, 15cm), gclose)

grecompAcum = plot(df, x = :Data, y = :RecompensaAcumulada, Geom.line)
draw(PNG("grafico/recompensaAcum.png", 50cm, 15cm), grecompAcum)

grecomp = plot(df, x = :Data, y = :Recompensa, color = :Estado , Geom.bar)
draw(PNG("grafico/recompensa.png", 40cm, 15cm), grecomp)

gevol = plot(df, x = :Data, y = :Evolucao, Geom.line)
draw(PNG("grafico/evolucao.png", 40cm, 15cm), gevol)

gevol2 = plot(df, x = :Data, y = :Evolucao2, Geom.line)
draw(PNG("grafico/evolucao2.png", 40cm, 15cm), gevol2)

print(df)
close(dados)
close(result)
