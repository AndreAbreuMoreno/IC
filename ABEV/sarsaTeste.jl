#""" lendos dados csv"""
using DelimitedFiles
using DataFrames
using Random
using CSV
using Dates
using Gadfly, RDatasets
import Cairo, Fontconfig

"""CONSTANTES """
#ESTADOS
#estado 1
const   LONG  = 1
const   SHORT = 2
const   NPOS  = 3
conjuntoPosicao = ["LONG", "SHORT", "NPOS"]
#estados 2, 3, 5 e 6
const   UP    = 1
const   DOWN  = 2
conjuntoVariacao = ["UP", "DOWN"]
#estado 4
const   BUY   = 1
const   SELL  = 2
const   NOPe   = 3
conjuntoOperacao = ["BUY", "SELL", "NOPe"]
#estado 7
const   MAX   = 1
const   MIN   = 2

#CONSTANTES PARA AS ACÓES
#COMPRAR
const   ENTER_LONG  = 1
const   STAY_LONG   = 2
const   EXIT_LONG   = 3
const   ENTER_SHORT = 4
const   STAY_SHORT  = 5
const   EXIT_SHORT  = 6
const   NOPa         = 7
conjuntoAcao = ["ENTER_LONG", "STAY_LONG", "EXIT_LONG", "ENTER_SHORT", "STAY_SHORT", "EXIT_SHORT", "NOPa"]

"""FUNCOES"""
# Funcao executa a acao
function criaQ(dictChave, dictValor)
      chave = open(dictChave, "r")
      valor = open(dictValor, "r")
      dic = open("dict/dicionario_teste.txt", "w")
      keys= []
      vals = []
      while !eof(chave)
            k = parse.(Int64,readline(chave))
            v = parse.(Float64,readline(valor))
            append!(keys, k)
            append!(vals, v)
      end
      Q_e_a = Dict(zip(keys, vals))
      for (k,v) in Q_e_a
            println(dic, "k:", k, "v: ",v, " typeofk: ", typeof(k))
      end
      close(dic)
      close(chave)
      close(valor)
      return Q_e_a
end

function primeiroEstado(estado, linhat0, linhat1, linhat2, linhat3)
      estado[1] = NPOS
      #ESTADO 2
      if (linhat2[4] - linhat2[1]) >= 0
            estado[2] = UP
      else estado[2] = DOWN
      end
      #ESTADO 3
      if linhat1[4] - linhat1[1] >= 0
            estado[3] = UP
      else estado[3] = DOWN
      end
      #ESTADO 4
      estado[4] = NOPa
      #ESTADO 5
      if linhat2[6] - linhat3[6] >= 0
            estado[5] = UP
      else estado[5] = DOWN
      end
      #ESTADO 6
      if linhat1[6] - linhat2[6] >= 0
            estado[6] = UP
      else estado[6] = DOWN
      end
      #ESTADO 7
      media = (linhat2[2] + linhat2[3])/2

      if linhat2[4] >= media
            estado[7] = MAX
      else estado[7] = MIN
      end
      # println("estado[7]: ", estado[7]," media: ", media," linha: ", linhat2[2])
      #ESTADO 8
      media = (linhat1[2] + linhat1[3])/2
      if linhat1[4] >= media
            estado[8] = MAX
      else estado[8] = MIN
      end
      # println("estado[8]: ", estado[8]," media: ", media," linha: ", linhat1[2])
      #ESTADO 9
      estado[9] = NPOS
      estado[10]= 0
end

function escolheAcao(arq, estado)
      println(arq, "\nEscolhe acao")
      key = calculaKey(estado)
      println(arq, "key: ", key)
      for i in key
            if i != 0
                  println(arq, "i: ", Q_e_a[i], )
            end
      end
      println(arq, "melhor acao")
      acao = melhorAcao(arq, key)
      return acao
end

function  calculaKey(estado)
      key = 0
      key1 = 0
      key2 = 0
      key3 = 0

      for i in [1:9;]
            key = key + estado[i]*10^(10-i)
            # println("i :", i, " estado: ", estado)
      end
      if estado[1] == LONG
            key1 = key + 2
            key2 = key + 3
            key3 = 0
      elseif estado[1] == SHORT
            key1 = key + 5
            key2 = key + 6
            key3 = 0
      elseif estado[1] == NPOS
            key1 = key + 1
            key2 = key + 4
            key3 = key + 7
      end
      return convert(Array{Int64},[key1,key2,key3])
end

function melhorAcao(arq, key)
      if key[3] != 0
            println(arq, "key3")
            if Q_e_a[key[1]] > Q_e_a[key[2]]
                  if Q_e_a[key[1]] > Q_e_a[key[3]]
                        return key[1]
                  else return key[3]
                  end
            elseif Q_e_a[key[2]] > Q_e_a[key[3]]
                  return key[2]
            else return key[3]
            end
      elseif Q_e_a[key[1]] > Q_e_a[key[2]]
            println(arq, "key1")
            return key[1]
      else
            println(arq, "key2")
            return key[2]
      end
end

function printEstado(arq, estado)
      if estado[1] == LONG
            print(arq, "estado",cont, " = [LONG, ")
      elseif estado[1] == SHORT
            print(arq, "estado",cont, " = [SHORT, ")
      elseif estado[1] == NPOS
            print(arq, "estado",cont, " = [NPOS, ")
      end
      if estado[2] == UP
            print(arq, "UP, ")
      else print(arq, "DOWN, ")
      end
      if estado[3] == UP
            print(arq, "UP, ")
      else print(arq, "DOWN, ")
      end
      if estado[4] == BUY
            print(arq, "BUY, ")
      elseif estado[4] == SELL
            print(arq, "SELL, ")
      else print(arq, "NOP, ")
      end
      if estado[5] == UP
            print(arq, "UP, ")
      else print(arq, "DOWN, ")
      end
      if estado[6] == UP
            print(arq, "UP, ")
      else print(arq, "DOWN, ")
      end
      if estado[7] == MAX
            print(arq, "MAX, ")
      else print(arq, "MIN, ")
      end
      if estado[8] == MAX
            print(arq, "MAX, ")
      else print(arq, "MIN, ")
      end
      if estado[9] == UP
            print(arq, "UP] ")
      elseif estado[9] == DOWN
             print(arq, "DOWN] ")
      else print(arq, "NPOS] ")
      end
      print(arq, estado[10])
      println(arq, "")
end

function executaAcao(arq, estado,acao,linhat1, linhat2)
      acao = acao%10
      println(arq, "acao: ", acao," ", conjuntoAcao[acao])
      # ESTADO 1
      proximo_estado = zeros(10)
      if acao == ENTER_LONG
            proximo_estado[1] = LONG
            proximo_estado[10] = linhat1[4]
      elseif acao == EXIT_LONG || acao == EXIT_SHORT
            proximo_estado[1] = NPOS
            proximo_estado[10] = 0
      elseif acao == ENTER_SHORT
            proximo_estado[1] = SHORT
            proximo_estado[10] = linhat1[4]
      elseif acao == STAY_LONG || acao == STAY_SHORT || acao == NOPa
            proximo_estado[1] = estado[1]
            proximo_estado[10] = estado[10]
      end
      #ESTADO 2
      proximo_estado[2] = estado[3]

      #ESTADO 3
      if linhat1[4] - linhat1[1] >= 0
            proximo_estado[3] = UP
      else proximo_estado[3] = DOWN
      end

      #ESTADO 4
      if acao == ENTER_LONG || acao == EXIT_SHORT
            proximo_estado[4] = BUY
      elseif acao == EXIT_LONG || acao == ENTER_SHORT
            proximo_estado[4] = SELL
      else proximo_estado[4] = NOPa
      end

      #ESTADO 5
      proximo_estado[5] = estado[6]

      #ESTADO 6
      if linhat1[6] - linhat2[6] >= 0
            proximo_estado[6] = UP
      else proximo_estado[6] = DOWN
      end

      #ESTADO 7
      proximo_estado[7] = estado[8]

      #ESTADO 8
      media = (linhat1[2] + linhat1[3])/2
      if linhat1[4] >= media
            proximo_estado[8] = MAX
      else proximo_estado[8] = MIN
      end

      #ESTADO 9
      if proximo_estado[1] == NPOS
            proximo_estado[9] =  NPOS
      elseif (proximo_estado[10] - linhat1[4]) >= 0
            proximo_estado[9] = UP
      else proximo_estado[9] = DOWN
      end
      return proximo_estado
end

function calculaRecompensa(proximo_estado, estado, acao, linhat0)
      recompensa = 0
      if estado[1] == NPOS
            recompensa = 0
      elseif estado[1] == LONG
            recompensa = (linhat0[4] - estado[10])/estado[10]
      elseif estado[1] == SHORT
            recompensa = (estado[10] - linhat0[4])/estado[10]
      end
      return recompensa
end


""" Inicializa todos os valores de Q(e,a) arbitrariamente """
dadosTeste = "dados/ABEV3teste.csv"
dictChave = "dict/chave/chave.txt"
dictValor = "dict/valor/valor.txt"
const taxa_aprendizado  = 0.007
const fator_desconto    = 0.7

""" Cria o dicionario """
Q_e_a = criaQ(dictChave, dictValor)


dados = open(dadosTeste, "r")
test = open("saida/result_teste.txt", "w")
#***********************************************
""" Testa algoritmo"""
estado = zeros(Int64,10)
proximo_estado = zeros(Int64,10)
cabecalho = readuntil(dados,"%")
linhat3 = split(readuntil(dados,"%"),"\t")
linhat3 = parse.(Float32,linhat3[3:8])
linhat2 = split(readuntil(dados,"%"),"\t")
linhat2 = parse.(Float32,linhat2[3:8])
linhat1 = split(readuntil(dados,"%"),"\t")
linhat1 = parse.(Float32,linhat1[3:8])
linhat0= split(readuntil(dados,"%"),"\t")
linhat0= parse.(Float32,linhat0[3:8])
primeiroEstado(estado, linhat0, linhat1, linhat2, linhat3)

acao = escolheAcao(test, estado)
# variaveis
date = []
fechamento = []
posicao = []

historico = []
historico_acumulado = []
recompensa = 0
cont = 1

println(test, "***************")
println(test, "estado ", cont, "\n")

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
      global recompensa
      global posicao


      linhat2 = linhat1
      linhat1 = linhat0
      linhat0 = split(readuntil(dados,"%"),"\t")
      dia = parse.(Int16,split(linhat0[2], "."))
      dia2 = Date(dia[3],dia[2],dia[1])
      date = [date; dia2]
      linhat0= parse.(Float32,linhat0[3:8])
      append!(fechamento, linhat0[4])
      append!(posicao, estado[1])

      """ Executa a açao """
      proximo_estado = executaAcao(test, estado, acao,linhat1, linhat2)
      # IMPRIME ESTADO E PROXIMO ESTADO
      println(test, "                    1     2   3   4   5    6     7     8    9")
      print(test, "        ")
      printEstado(test, estado)
      cont = cont + 1
      print(test, "proximo ")
      printEstado(test, proximo_estado)
      println(test, "preco atual: ", linhat0[4])

      """ Calcula recompensa r(proximo estado)"""
      r = calculaRecompensa(proximo_estado, estado, acao, linhat0)
      recompensa = recompensa + r
      append!(historico, round(r, digits =4 ))
      append!(historico_acumulado, round(recompensa, digits = 4))

      """Escolhe a proxima acao"""
      proxima_acao = escolheAcao(test, proximo_estado)

      println(test, "recompensa: ", recompensa, " estado: ", estado[10], " valor atual: ", linhat0[4])

      """ Atualiza Q(e,a) """
      antes = Q_e_a[acao]
      proximo = Q_e_a[proxima_acao]
      Q_e_a[acao] = Q_e_a[acao] + taxa_aprendizado * (recompensa + fator_desconto* Q_e_a[proxima_acao] - Q_e_a[acao])
      println(test, "antes: ", antes," proximo: ", proximo, " teste dict: ", Q_e_a[acao])

      """ atualiza estado e acao """
      estado = proximo_estado
      acao = proxima_acao

      println(test, "***************")
      println(test, "estado ", cont, "\n")
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
close(test)
