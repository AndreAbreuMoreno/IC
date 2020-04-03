

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

# """FUNCOES"""
# Funcao executa a acao
function escolheAcao(estado)
      while true
            acao = rand([1,2,3,4,5,6,7])
            println(result, "acao: ", conjuntoAcao[acao])
            if estado[1] == LONG
                  if acao == STAY_LONG
                        return acao
                  elseif acao == EXIT_LONG
                        return acao
                  end
            elseif estado[1] == SHORT
                  if acao == STAY_SHORT
                        return acao
                  elseif acao == EXIT_SHORT
                        return acao
                  end
            elseif estado[1] == NPOS
                  if acao == ENTER_LONG
                        return acao
                  elseif acao == ENTER_SHORT
                        return acao
                  elseif acao == NOPa
                        return acao
                  end
            end
      end
end

function printestado(estado)
      if estado[1] == LONG
            print(result, "estado",cont, " = [LONG, ")
      elseif estado[1] == SHORT
            print(result, "estado",cont, " = [SHORT, ")
      elseif estado[1] == NPOS
            print(result, "estado",cont, " = [NPOS, ")
      end
      if estado[2] == UP
            print(result, "UP, ")
      else print(result, "DOWN, ")
      end
      if estado[3] == UP
            print(result, "UP, ")
      else print(result, "DOWN, ")
      end
      if estado[4] == BUY
            print(result, "BUY, ")
      elseif estado[4] == SELL
            print(result, "SELL, ")
      else print(result, "NOP, ")
      end
      if estado[5] == UP
            print(result, "UP, ")
      else print(result, "DOWN, ")
      end
      if estado[6] == UP
            print(result, "UP, ")
      else print(result, "DOWN, ")
      end
      if estado[7] == MAX
            print(result, "MAX, ")
      else print(result, "MIN, ")
      end
      if estado[8] == MAX
            print(result, "MAX, ")
      else print(result, "MIN, ")
      end
      if estado[9] == UP
            print(result, "UP]")
      elseif estado[9] == DOWN
             print(result, "DOWN]")
      else print(result, "NPOS]")
      end
      println(result, "")
end

function primeiroEstado(estado)
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
      if linhat1[5] - linhat2[5] >= 0
            estado[5] = UP
      else estado[5] = DOWN
      end
      #ESTADO 6
      if linhat0[5] - linhat1[5] >= 0
            estado[6] = UP
      else estado[6] = DOWN
      end
      #ESTADO 7
      media = (linhat2[3] + linhat2[2])/2

      if linhat2[2] >= media
            estado[7] = MAX
      else estado[7] = MIN
      end
      # println("estado[7]: ", estado[7]," media: ", media," linha: ", linhat2[2])
      #ESTADO 8
      media = (linhat1[3] + linhat1[2])/2
      if linhat1[2] >= media
            estado[8] = MAX
      else estado[8] = MIN
      end
      # println("estado[8]: ", estado[8]," media: ", media," linha: ", linhat1[2])
      #ESTADO 9
      estado[9] = NPOS
end

function atualizaEstado(estado,acao)
      proximo_estado = zeros(10)
      proximo_estado[1] = estado[1]
      if acao == ENTER_LONG
            proximo_estado[1] = LONG
            proximo_estado[10] = linhat0[4]
      elseif acao == EXIT_LONG || acao == EXIT_SHORT
            proximo_estado[1] = NPOS
            proximo_estado[10] = 0
      elseif acao == ENTER_SHORT
            proximo_estado[1] = SHORT
            proximo_estado[10] = linhat0[4]
      elseif acao == STAY_LONG || acao == STAY_SHORT
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
      if linhat1[5] - linhat2[5] >= 0
            proximo_estado[6] = UP
      else proximo_estado[6] = DOWN
      end

      #ESTADO 7
      proximo_estado[7] = estado[8]

      #ESTADO 8
      media = (linhat1[3] + linhat1[2])/2
      if linhat1[4] >= media
            proximo_estado[8] = MAX
      else proximo_estado[8] = MIN
      end

      #ESTADO 9
      if proximo_estado[1] == NPOS
            proximo_estado[9] =  NPOS
      elseif (proximo_estado[10] - linhat1[4]) > 0
            proximo_estado[9] = UP
      else proximo_estado[9] = DOWN
      end
      return proximo_estado
end

function printdados(linhat0, linhat1, linhat2, proximo_estado)
      # println(result, "atual. close - open: ", linhat0[4], " ", linhat0[1], " ",linhat0[4] - linhat0[1])
      # println(result, "t1. close - open: ", linhat1[4], " ",linhat1[1], " ",linhat1[4] - linhat1[1])
      # println(result, "6. vol. ticket t1 - ticket t2: ", linhat1[5], " ", linhat2[5], " ",linhat1[5] - linhat2[5])
      # println(result, "8. t1. media: ",(linhat1[3] + linhat1[2])/2, " close: ",linhat1[4])
      # println(result, "9. estado: ", proximo_estado[1], "valor: ", proximo_estado[10], "closet1: ", linhat1[4] )
end

function calculaRecompensa(proximo_estado, estado, acao, linhat0)
      recompensa = 0
      if estado[1] == NPOS
            recompensa = 0
      elseif acao == ENTER_LONG || acao == STAY_LONG || acao == EXIT_LONG
            recompensa = (linhat0[4] - estado[10])/estado[10]
      elseif acao == ENTER_SHORT || acao == STAY_SHORT || acao == EXIT_SHORT
            recompensa = (estado[10] - linhat0[4])/estado[10]
      end
      return recompensa
end
# """ Leitura e escrita de arquivos  """
dados = open("dados/BPAC11.csv", "r")
result = open("resultado.txt", "w")

#""" Inicializacao de variaveis """

Q = zeros(1728,3)
estado = zeros(Int8,10)
linhat2 = readline(dados)
linhat2 = split(readline(dados),"\t")
linhat2 = parse.(Float32,linhat2[3:8])
linhat1 = split(readline(dados),"\t")
linhat1 = parse.(Float32,linhat1[3:8])
linhat0= split(readline(dados),"\t")
linhat0= parse.(Float32,linhat0[3:8])
cont = 0
primeiroEstado(estado)
printestado(estado)
proximo_estado = zeros(10)
recompensa = 0

#""" Execucao do algoritmo """
while !eof(dados)
      global linhat0
      global linhat1
      global estado
      global cont
      global recompensa

      println(result, "*************** \nestado\n")
      println(result, "escolhe acao")
      acao = escolheAcao(estado)

      linhat1 = linhat0
      linhat0=split(readline(dados),"\t")
      linhat0= parse.(Float32,linhat0[3:8])
      proximo_estado = atualizaEstado(estado, acao)
      # println("atual", estado)
      # println("proximo ", proximo_estado)
      printdados(linhat0, linhat1, linhat2, proximo_estado)
      println(result, "                    1     2   3   4   5    6     7     8    9")
      print(result, "        ")
      printestado(estado)
      cont = cont + 1
      print(result, "proximo ")
      printestado(proximo_estado)

      recompensa = calculaRecompensa(proximo_estado, estado,acao, linhat0)

      #<DATE>	<TIME>	<OPEN>	<HIGH>	<LOW>	<CLOSE>	<TICKVOL>	<VOL>	<SPREAD>
      estado = proximo_estado
end


close(dados)
close(result)


















# while true
#       acao = rand([1,2,3,4,5,6,7])
#       println("acao: ", conjuntoAcao[acao], " posicao: ", conjuntoPosicao[estado[1]])
#       if estado[1] == LONG
#             if acao == STAY_LONG
#                   break
#             elseif acao == EXIT_LONG
#                   estado[1] = NPOS
#                   break
#             end
#
#       elseif estado[1] == SHORT
#             if acao == STAY_SHORT
#                   break
#             elseif acao == EXIT_SHORT
#                   estado[1] = NPOS
#                   break
#             end
#       elseif estado[1] == NPOS
#             if acao == ENTER_LONG
#                   estado[1] = LONG
#                   break
#             elseif acao == ENTER_SHORT
#                   estado[1] = SHORT
#                   break
#             elseif acao == NOPa
#                   break
#             end
#       end
# end
#










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
