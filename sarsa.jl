

#""" lendos dados csv"""
using DelimitedFiles
using DataFrames
using Random

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
function executarAcao(estado)
      while true
            acao = rand([1,2,3,4,5,6,7])
            println("acao: ", conjuntoAcao[acao], " posicao: ", conjuntoPosicao[estado[1]])
            if estado[1] == LONG
                  if acao == STAY_LONG
                        break
                  elseif acao == EXIT_LONG
                        estado[1] = NPOS
                        break
                  end

            elseif estado[1] == SHORT
                  if acao == STAY_SHORT
                        break
                  elseif acao == EXIT_SHORT
                        estado[1] = NPOS
                        break
                  end
            elseif estado[1] == NPOS
                  if acao == ENTER_LONG
                        estado[1] = LONG
                        break
                  elseif acao == ENTER_SHORT
                        estado[1] = SHORT
                        break
                  elseif acao == NOPa
                        break
                  end
            end
      end
end

function printestado(estado)
      if estado[1] == LONG
            print("estado = [LONG, ")
      elseif estado[1] == SHORT
            print("estado = [SHORT, ")
      elseif estado[1] == NPOS
            print("estado = [NPOS, ")
      end
      if estado[2] == UP
            print("UP, ")
      else print("DOWN, ")
      end
      if estado[3] == UP
            print("UP, ")
      else print("DOWN, ")
      end
      if estado[4] == BUY
            print("BUY, ")
      elseif estado[4] == SELL
            print("SELL, ")
      else print("NOP, ")
      end
      if estado[5] == UP
            print("UP, ")
      else print("DOWN, ")
      end
      if estado[6] == UP
            print("UP, ")
      else print("DOWN, ")
      end
      if estado[7] == MAX
            print("MAX, ")
      else print("MIN, ")
      end
      if estado[8] == MAX
            print("MAX, ")
      else print("MIN, ")
      end
      if estado[9] == UP
            print("UP]")
      elseif estado[9] == DOWN
             print("DOWN]")
      else print("NPOS]")
      end
      println("")
end

function primeiroEstado(estado)
      estado[1] = NPOS
      #ESTADO 2
      println(linhat1[4], linhat1[1], typeof(linhat1))
      if (linhat1[4] - linhat1[1]) >= 0
            estado[2] = UP
      else estado[2] = DOWN
      end
      #ESTADO 3
      if linhat2[4] - linhat2[1] >= 0
            estado[3] = UP
      else estado[3] = DOWN
      end
      #ESTADO 4
      estado[4] = NOPa
      #ESTADO 5
      if linhat2[5] - linhat1[5] >= 0
            estado[5] = UP
      else estado[5] = DOWN
      end
      #ESTADO 6
      if linhat3[5] - linhat2[5] >= 0
            estado[6] = UP
      else estado[6] = DOWN
      end
      #ESTADO 7
      media = (linhat1[4] + linhat1[1])/2

      if linhat1[2] >= media
            estado[7] = MAX
      else estado[7] = MIN
      end
      println("estado[7]: ", estado[7]," media: ", media," linha: ", linhat1[2])
      #ESTADO 8
      media = (linhat2[4] + linhat2[1])/2
      if linhat2[2] >= media
            estado[8] = MAX
      else estado[8] = MIN
      end
      #ESTADO 9
      estado[9] = NPOS
end
dados = open("dados/BPAC11.csv", "r")

""" Estado inicial """
historico = []
estado = zeros(Int8,10)
linhat1 = readline(dados)
linhat1 = split(readline(dados),"\t")
linhat1 = parse.(Float32,linhat1[3:8])
linhat2 = split(readline(dados),"\t")
linhat2 = parse.(Float32,linhat2[3:8])
linhat3 = split(readline(dados),"\t")
linhat3 = parse.(Float32,linhat3[3:8])

primeiroEstado(estado)
# estado[1] = NPOS
# #ESTADO 2
# println(linhat1[4], linhat1[1], typeof(linhat1))
# if (linhat1[4] - linhat1[1]) >= 0
#       estado[2] = UP
# else estado[2] = DOWN
# end
# #ESTADO 3
# if linhat2[4] - linhat2[1] >= 0
#       estado[3] = UP
# else estado[3] = DOWN
# end
# #ESTADO 4
# estado[4] = NOPa
# #ESTADO 5
# if linhat2[5] - linhat1[5] >= 0
#       estado[5] = UP
# else estado[5] = DOWN
# end
# #ESTADO 6
# if linhat3[5] - linhat2[5] >= 0
#       estado[6] = UP
# else estado[6] = DOWN
# end
# #ESTADO 7
# media = (linhat1[4] + linhat1[1])/2
#
# if linhat1[2] >= media
#       estado[7] = MAX
# else estado[7] = MIN
# end
# println("estado[7]: ", estado[7]," media: ", media," linha: ", linhat1[2])
# #ESTADO 8
# media = (linhat2[4] + linhat2[1])/2
# if linhat2[2] >= media
#       estado[8] = MAX
# else estado[8] = MIN
# end
# #ESTADO 9
# estado[9] = NPOS
println(estado)
executarAcao(estado)
printestado(estado)
while true
      acao = rand([1,2,3,4,5,6,7])
      println("acao: ", conjuntoAcao[acao], " posicao: ", conjuntoPosicao[estado[1]])
      if estado[1] == LONG
            if acao == STAY_LONG
                  break
            elseif acao == EXIT_LONG
                  estado[1] = NPOS
                  break
            end

      elseif estado[1] == SHORT
            if acao == STAY_SHORT
                  break
            elseif acao == EXIT_SHORT
                  estado[1] = NPOS
                  break
            end
      elseif estado[1] == NPOS
            if acao == ENTER_LONG
                  estado[1] = LONG
                  break
            elseif acao == ENTER_SHORT
                  estado[1] = SHORT
                  break
            elseif acao == NOPa
                  break
            end
      end
end

# linhat1 = readline(dados)
# linha = readline(dados)
#
# while !eof(dados)
#       linha = readline(dados)
#       #<DATE>	<TIME>	<OPEN>	<HIGH>	<LOW>	<CLOSE>	<TICKVOL>	<VOL>	<SPREAD>
#       println(linha)
# end

# function recompensa (estado, acao)
#         if
#
# end
#
# function numToVecto (num)
#         vector = [num]
#         vector = vector.spli
# end

# historico = readdlm("dados/BPAC11.csv", header=true)
# tamanho = length(historico[1])
#
# for linha = range(tamanho)
#         println(linha)
#         #println(historico[linha])
# end
