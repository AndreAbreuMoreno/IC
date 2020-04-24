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
#******************************************************************

""" Declaracao de variaveis """
qtd_iteracao = 300000
dadosTraining = "dados/TIMP3training.csv"
iteracao = 0
p_enter_long = 0
p_enter_short = 0

""" Inicializa todos os valores de Q(e,a) arbitrariamente """
Q_e_a = criaQ(iteracao)

""" Para cada episodio """
contador = []
saida = []
while iteracao < qtd_iteracao
      println("iteracao: ", iteracao)
      # DECLARACAO DE VARIAVEIS
      global iteracao
      global cont = 1    #variavel para verificar quantos estados já se passaram na iteracao atual
      global p_enter_long = 0
      global p_enter_short = 0
      global dados = open(dadosTraining, "r")
      n = iteracao%5
      recompensa = 0
      recompensa_acumulada = 0
      result = open("saida/resultado$(n).txt", "w")

      """ Inicializa estado e o proximo_estado"""
      estado = zeros(Int64,10)
      proximo_estado = zeros(Int64, 10)
      cabecalho = readuntil(dados,"%")
      linhat3 = split(readuntil(dados,"%"),";")
      linhat3 = parse.(Float32,linhat3[3:9])
      linhat2 = split(readuntil(dados,"%"),";")
      linhat2 = parse.(Float32,linhat2[3:9])
      linhat1 = split(readuntil(dados,"%"),";")
      linhat1 = parse.(Float32,linhat1[3:9])
      linhat0= split(readuntil(dados,"%"),";")
      linhat0= parse.(Float32,linhat0[3:9])
      primeiroEstado(estado, linhat0, linhat1, linhat2, linhat3)
      # Imprime o primeiro estado em result
      # printEstado(result, estado)

      """ Escolhe a acao """
      acao = escolheAcao(result, estado)

      # println(result, "***************")
      # println(result, "estado ", cont, "\n")

      """ REPEAT """
      while !eof(dados)
            """   Ler nova linha do historico de valor das acoes
                  linhat2 = estado anterior (t - 1)
                  linhat1 = estado atual
                  linhat0 = estado proximo
            """
            linhat2 = linhat1
            linhat1 = linhat0
            linhat0 = split(readuntil(dados,"%"),";")
            linhat0 = parse.(Float64,linhat0[3:9])
            cont = cont + 1

            """   Atualiza p_enter_short e p_enter_long de entrada da posicao(se for o caso) """
            p_enter_long, p_enter_short = atualizaPreco1(p_enter_long, p_enter_short, acao, linhat1)

            """ Executa a açao """
            proximo_estado = executaAcao(result, estado, acao,linhat0, linhat1, linhat2, p_enter_long, p_enter_short)

            """ Calcula recompensa r(t+1)"""
            recompensa_acumulada = recompensa_acumulada + recompensa
            recompensa = calculaRecompensa(p_enter_long, p_enter_short,estado, acao, linhat0)

            """ Atualiza p_enter_short e p_enter_long na saida de posicao(se for o caso)"""
            p_enter_long, p_enter_short = atualizaPreco2(p_enter_long, p_enter_short, acao, linhat1)

            """Escolhe a proxima acao"""
            proxima_acao = escolheAcao(result, proximo_estado)

            """ Atualiza Q(e,a) """
            Q_e_a[acao] = atualizaQ(acao, proxima_acao,recompensa, taxa_aprendizado, fator_desconto)

            """ atualiza estado e acao """
            estado = proximo_estado
            acao = proxima_acao
      end
      iteracao = iteracao + 1

      """ Salva Status a cada 1000 iteracoes"""
      if iteracao%5000 == 0
            append!(contador, iteracao)
            append!(saida, recompensa_acumulada)
      end
      close(result)
      close(dados)
end

""" Salvar dicionario """
chave = open("dict/chave/chave.txt", "w")
valor = open("dict/valor/valor.txt", "w")
for (k,v) in Q_e_a
          println(chave, k)
          println(valor, v)
end
close(chave)
close(valor)


df = DataFrame(Iteracao = contador,Recompensa = saida)

CSV.write("contRecompensa.csv", df)
gcont_recompensa = plot(df, x = :Iteracao, y = :Recompensa, Geom.line)
draw(PNG("grafico/cont_recomp.png", 50cm, 15cm), gcont_recompensa)
