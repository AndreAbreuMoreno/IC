#""" lendos dados csv"""
using DelimitedFiles
using DataFrames
using Random
using CSV
using Dates
using Gadfly, RDatasets
import Cairo, Fontconfig

include("funcao.jl")
include("constantes.jl")

# """ Declaracao de variaveis """
# Escolher o ativo 
ativo = "PETR3" #(mesmo nome da pasta)
iteracao = 1  # valor diferente de zero para que lido o dicionario obtido no treinamento

dadosTeste = ativo * "/dados/teste.csv"
dictChave = ativo * "/dict/chave.txt"
dictValor = ativo * "/dict/valor.txt"
dadosResultado = ativo * "/saida/result_teste.txt"


data = []
fechamento = []
posicao = []
hist_recompensa = []
hist_recompensa_acumulada = []
hist_retorno = []
hist_retorno_acumulado = []
p_enter_long = 0.0
p_enter_short = 0.0
recompensa_acumulada = 0
recompensa = 0
retorno = 0
retorno_acumulado = 0
cont = 1

# Ler o dicionario 
Q_e_a = inicializaQ(iteracao, ativo)

#imprime dicionario para conferencia
imprimeDicionario(Q_e_a, ativo)

# abre arquivos para ler os dados de tese e para salvar 
result = open(dadosResultado, "w")
dados = open(dadosTeste, "r")

#***********************************************
# """ Testa algoritmo"""
# """ Le o cabecalho da tabela de dados e as duas primeiras linhas para obter o estado inicial"""
cabecalho = readline(dados)
instanteT2 = parse.(Float32,split(readline(dados),";")[2:7])
instanteT1 = parse.(Float32,split(readline(dados),";")[2:7])
instanteT0 = instanteT1
# """ Cria array para armazenar estado e o proximo_estado"""
estado = zeros(Int64,10)
proximo_estado = zeros(Int64, 10)

# """ Inicialza o estado """
primeiroEstado(estado, instanteT1, instanteT2)
# Imprime o primeiro estado em um arquivo .txt (result)
# printEstado(result, estado)

# """ Escolhe a acao """
acao = escolheAcaoTeste(result, estado)

println(result, "***************")
println(result, "estado ", cont, "\n")

while !eof(dados)
      global instanteT0
      global instanteT1
      global data
      global fechamento
      global posicao
      global hist_recompensa
      global hist_recompensa_acumulada
      global hist_retorno
      global hist_retorno_acumulado
      global p_enter_long
      global p_enter_short
      global recompensa
      global recompensa_acumulada
      global retorno
      global retorno_acumulado
      global estado
      global proximo_estado
      global dados
      global acao
      global cont
      # ***************************************  
      # Ler nova linha do historico de valor das acoes
      # instanteT1 = instante relativo ao estado atual
      # instanteT0 = instante relativo ao proximo estado 
      # ***************************************  
      instanteT1 = instanteT0
      instanteT0 = split(readline(dados),";")
      # retira a informaçao da data e ajusta seu formato
            dia = parse.(Int16,split(instanteT0[DATA], "."))
            dia = Date(dia[3],dia[2],dia[1])
            data = [data; dia]
      instanteT0 = parse.(Float32,instanteT0[2:7])

      # ***************************************   
      # Armazena o preco de fechamento do estado atual e
      # Armazena a posicao do estado atual
      # ***************************************  
      append!(fechamento, instanteT0[FECHAMENTO])
      append!(posicao, estado[1])


      # """   Atualiza p_enter_short e p_enter_long de entrada (se for o caso)"""
      p_enter_long, p_enter_short = atualizaPreco1(p_enter_long, p_enter_short, acao, instanteT1)

      # """   Executa a açao """
      println(result, "instante t1 ", instanteT1)
      println(result, "instante t0 ", instanteT0)
      proximo_estado = executaAcao(result, estado, acao, instanteT0, instanteT1, p_enter_long, p_enter_short)

      # """   Imprime estado atual e o proximo estado """
      print(result, "        ")
      printEstado(result, estado)
      cont = cont + 1
      print(result, "proximo ")
      printEstado(result, proximo_estado)

      # """ Calcula recompensa r(t+1) """
      # a recompensa é calculada utilizando o preco ao entra na posicao (Long ou short) e o preco do instante atual
      recompensa_acumulada = recompensa_acumulada + recompensa
      recompensa = calculaRecompensa(p_enter_long, p_enter_short, acao, instanteT1)

      #imprime dados para conferencia no arquivo
      println(result, "recompensa: ", recompensa, " recomp_acumulada: ", recompensa_acumulada," long: ", p_enter_long, " short: ", p_enter_short)
      println(result, "preco em atual: ", instanteT1[FECHAMENTO], " preco futuro: ", instanteT0[FECHAMENTO])

      # """ Atualiza o retorno """
      # o retorno é calculado levando em consideracao o preco futuro da acao e o preco atual
      retorno_acumulado = retorno_acumulado + retorno
      retorno = calculaRetorno(p_enter_long,p_enter_short,instanteT0,instanteT1, acao)

      # """ Armazena o historico da recompensa e do retorno """
      append!(hist_retorno, round(retorno, digits = 4))
      append!(hist_retorno_acumulado, round(retorno_acumulado, digits = 4))
      append!(hist_recompensa, round(recompensa, digits =4 ))
      append!(hist_recompensa_acumulada, round(recompensa_acumulada * 100, digits = 4))

      # """ Atualiza p_enter_short e p_enter_long na saida(se for o caso)"""
      p_enter_long, p_enter_short = atualizaPreco2(p_enter_long, p_enter_short, acao)

      # """Escolhe a proxima acao"""
      proxima_acao = escolheAcaoTeste(result, proximo_estado)

      # """ Atualiza Q(e,a) """
      antes = Q_e_a[acao]
      proximo = Q_e_a[proxima_acao]
      Q_e_a[acao] = atualizaQ(acao, proxima_acao, recompensa, taxa_aprendizado, fator_desconto)
      #imprime dados para conferencia no arquivo
      println(result, "antes: ", antes," proximo: ", proximo, " teste dict: ", Q_e_a[acao])

      # """ atualiza estado e acao """
      estado = proximo_estado
      acao = proxima_acao

      #imprime dados para conferencia no arquivo
      println(result, "***************")
      println(result, "estado ", cont, "\n")
end

df = DataFrame(Data = data, Close = fechamento, Recompensa = hist_recompensa, RecompensaAcumulada = hist_recompensa_acumulada, Estado = posicao, Retorno = hist_retorno, RetornoAcumulado = hist_retorno_acumulado)

CSV.write(ativo * "/resultado.csv", df)
gclose = plot(df, x = :Data, y = :Close, Geom.line)
draw(PNG(ativo * "/grafico/Teste/fechamentoTeste.png", 50cm, 15cm), gclose)

grecompAcum = plot(df, x = :Data, y = :RecompensaAcumulada, Geom.line)
draw(PNG(ativo * "/grafico/Teste/DataVsRecompAcum.png", 50cm, 15cm), grecompAcum)

grecompAcumBarra = plot(df, x = :Data, y = :RecompensaAcumulada, color = :Estado, Geom.bar)
draw(PNG(ativo * "/grafico/Teste/DataVsRecompAcumladaBarra.png", 50cm, 15cm), grecompAcumBarra)

grecompAcumBarra = plot(df, x = :Data, y = :Recompensa, color = :Estado,  Geom.bar)
draw(PNG(ativo * "/grafico/Teste/DataVsRecompBarra.png", 50cm, 15cm), grecompAcumBarra)

gretornoBarra = plot(df, x = :Data, y = :Retorno, color = :Estado , Geom.bar)
draw(PNG(ativo * "/grafico/Teste/DataVsRetornoBarra.png", 50cm, 15cm), gretornoBarra)

gretornoAcumBarra = plot(df, x = :Data, y = :RetornoAcumulado, color = :Estado , Geom.bar)
draw(PNG(ativo * "/grafico/Teste/DataVsRetornoAcumBarra.png", 50cm, 15cm), gretornoAcumBarra)

gretorno = plot(df, x = :Data, y = :Retorno, Geom.line)
draw(PNG(ativo * "/grafico/Teste/DataVsRetorno.png", 40cm, 15cm), gretorno)

gretornoAcum = plot(df, x = :Data, y = :RetornoAcumulado, Geom.line)
draw(PNG(ativo * "/grafico/Teste/DataVsRetornoAcumulado.png", 40cm, 15cm), gretornoAcum)

println(ativo)
print(df)
close(dados)
close(result)
