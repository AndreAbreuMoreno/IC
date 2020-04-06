

#""" lendos dados csv"""
using DelimitedFiles
using DataFrames
using Random
using CSV

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


const taxa_aprendizado  = 0.007
const fator_desconto    = 0.7
const taxa_exploracao = 0.3

# """ Leitura e escrita de arquivos  """
# dados = open("dados/BPAC11.csv", "r")

"""FUNCOES"""
# Funcao executa a acao

function escolheAcao(arq, estado)
      println(arq, "\nEscolhe acao")
      key = calculaKey(estado)
      println(arq, "key: ", key)

      epsilon = rand()
      if epsilon > taxa_exploracao
            return melhorAcao(key)
      else
            num = rand(1:3)
            while key[num] == 0
                  num = rand(1:3)
            end
      end
      println(arq, "num ", num, " key: ", key[num])
      return key[num]
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
end

function executaAcao(arq, estado,acao,linhat1, linhat2)
      acao = acao%10
      println(arq, "acao: ", acao, conjuntoAcao[acao])
      # ESTADO 1
      proximo_estado = zeros(10)
      if acao == ENTER_LONG
            proximo_estado[1] = LONG
            proximo_estado[10] = (linhat1[2] + linhat1[3])/2
      elseif acao == EXIT_LONG || acao == EXIT_SHORT
            proximo_estado[1] = NPOS
            proximo_estado[10] = 0
      elseif acao == ENTER_SHORT
            proximo_estado[1] = SHORT
            proximo_estado[10] = (linhat1[2] + linhat1[3])/2
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
      elseif estado[1] == LONG
            recompensa = (linhat0[4] - estado[10])/estado[10]
      elseif estado[1] == SHORT
            recompensa = (estado[10] - linhat0[4])/estado[10]
      end
      return recompensa
end

function  calculaKey(estado)
      key = 0
      key1 = 0
      key2 = 0
      key3 = 0

      for i in [1 2 3 4 5 6 7 8 9]
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

function melhorAcao(key)
      if key[3] != 0
            if Q[key[1]] > Q[key[2]]
                  if Q[key[1]] > Q[key[3]]
                        return key[1]
                  else return key[3]
                  end
            elseif Q[key[2]] > Q[key[3]]
                  return key[2]
            else return key[3]
            end
      elseif Q[key[1]] > Q[key[2]]
                  return key[1]
      else return key[2]
      end
end

function criaQ(iteracao)
      if iteracao == 0
            Q = zeros(1728,3)
            # INICIALIZACAO DA MATRIZ Q
            a1 = 0
            b1 = 0
            c1 = 0
            d1 = 0
            e1 = 0
            f1 = 0
            g1 = 0
            h1 = 0
            i1 = 0
            keys = []
            vals = []
            for a in [1 2 3]
                  a1 = a*1000000000
                  for b in [1 2]
                        b1 = b*100000000
                        for c in [1 2]
                              c1 = c*10000000
                              for d in [1 2 3 7]
                                    d1 = d*1000000
                                    for e in [ 1 2]
                                          e1 = e*100000
                                          for f in [1 2]
                                                f1 = f*10000
                                                for g in [1 2]
                                                      g1 = g*1000
                                                      for h in [1 2]
                                                            h1 = h*100
                                                            for i in [1 2 3]
                                                                  i1 = i*10
                                                                  num = a1 + b1 + c1 + d1 + e1 + f1 + g1 + h1 + i1
                                                                  if a == 1
                                                                        aux = num + 2
                                                                        append!(keys,aux)
                                                                        append!(vals,rand()*0.00001)
                                                                        aux = num + 3
                                                                        append!(keys,aux)
                                                                        append!(vals,rand()*0.00001)
                                                                  elseif a == 2
                                                                        aux = num + 5
                                                                        append!(keys,aux)
                                                                        append!(vals,rand()*0.00001)
                                                                        aux = num + 6
                                                                        append!(keys,aux)
                                                                        append!(vals,rand()*0.00001)
                                                                  elseif a == 3
                                                                        aux = num + 1
                                                                        append!(keys,aux)
                                                                        append!(vals,rand()*0.00001)
                                                                        aux = num + 4
                                                                        append!(keys,aux)
                                                                        append!(vals,rand()*0.00001)
                                                                        aux = num + 7
                                                                        append!(keys,aux)
                                                                        append!(vals,rand()*0.00001)
                                                                  end
                                                                  append!(vals,rand()*0.0001)
                                                            end
                                                      end
                                                end
                                          end
                                    end
                              end
                        end
                  end
            end

            vals = zeros(size(keys))
            Q = Dict(zip(keys, vals))
            return Q
      end
end
""" Inicializa todos os valores de Q(e,a) arbitrariamente """
# Q = zeros(1728,3)
# # INICIALIZACAO DA MATRIZ Q
# a1 = 0
# b1 = 0
# c1 = 0
# d1 = 0
# e1 = 0
# f1 = 0
# g1 = 0
# h1 = 0
# i1 = 0
# keys = []
# vals = []
# for a in [1 2 3]
#       a1 = a*1000000000
#       for b in [1 2]
#             b1 = b*100000000
#             for c in [1 2]
#                   c1 = c*10000000
#                   for d in [1 2 3 7]
#                         d1 = d*1000000
#                         for e in [ 1 2]
#                               e1 = e*100000
#                               for f in [1 2]
#                                     f1 = f*10000
#                                     for g in [1 2]
#                                           g1 = g*1000
#                                           for h in [1 2]
#                                                 h1 = h*100
#                                                 for i in [1 2 3]
#                                                       i1 = i*10
#                                                       num = a1 + b1 + c1 + d1 + e1 + f1 + g1 + h1 + i1
#                                                       if a == 1
#                                                             aux = num + 2
#                                                             append!(keys,aux)
#                                                             append!(vals,rand()*0.00001)
#                                                             aux = num + 3
#                                                             append!(keys,aux)
#                                                             append!(vals,rand()*0.00001)
#                                                       elseif a == 2
#                                                             aux = num + 5
#                                                             append!(keys,aux)
#                                                             append!(vals,rand()*0.00001)
#                                                             aux = num + 6
#                                                             append!(keys,aux)
#                                                             append!(vals,rand()*0.00001)
#                                                       elseif a == 3
#                                                             aux = num + 1
#                                                             append!(keys,aux)
#                                                             append!(vals,rand()*0.00001)
#                                                             aux = num + 4
#                                                             append!(keys,aux)
#                                                             append!(vals,rand()*0.00001)
#                                                             aux = num + 7
#                                                             append!(keys,aux)
#                                                             append!(vals,rand()*0.00001)
#                                                       end
#                                                       append!(vals,rand()*0.0001)
#                                                 end
#                                           end
#                                     end
#                               end
#                         end
#                   end
#             end
#       end
# end

# vals = zeros(size(keys))
# Q = Dict(zip(keys, vals))




""" para cada iteracao """
it = open("dict/iteracao.txt", "r")
iteracao = parse(Int64,readline(it))
close(it)

Q = criaQ(iteracao)

qtd_iteracao = 300000
# criar loop das itearcoes
while iteracao < qtd_iteracao
      global iteracao
      global linhas
      global dados1

      dados = open("dados/training.csv", "r")
      result = open("saida/resultado$(iteracao).txt", "w")



      println("iteracao", iteracao)
      """ Inicializa estado e """
      estado = zeros(Int64,10)
      proximo_estado = zeros(10)
      recompensa = 0

      cabecalho = readline(dados)
      linhat3 = split(readline(dados),"\t")
      linhat3 = parse.(Float32,linhat3[3:8])
      linhat2 = split(readline(dados),"\t")
      linhat2 = parse.(Float32,linhat2[3:8])
      linhat1 = split(readline(dados),"\t")
      linhat1 = parse.(Float32,linhat1[3:8])
      linhat0= split(readline(dados),"\t")
      linhat0= parse.(Float32,linhat0[3:8])
      cont = 1
      global cont
      global dados

      primeiroEstado(estado, linhat0, linhat1, linhat2, linhat3)
      printEstado(result, estado)

      #""" Execucao do algoritmo """
      """ Escolhe a acao """
      acao = escolheAcao(result, estado)

      println(result, "*************** \nestado", cont, "\n")
while !eof(dados)
      # """ Repeat """

            # global linhat0
            # global linhat1
            # global linhat2
            # global estado
            # global recompensa
            # global acao
      """ Executa a açao """

            # ATUALIZA O ESTADO
            linhat2 = linhat1
            linhat1 = linhat0
            linhat0=split(readline(dados),"\t")
            linhat0= parse.(Float32,linhat0[3:8])
            proximo_estado = executaAcao(result, estado, acao,linhat1, linhat2)

            # IMPRIME DADOS
            # println("atual", estado)
            # println("proximo ", proximo_estado)
            printdados(linhat0, linhat1, linhat2, proximo_estado)
            println(result, "                    1     2   3   4   5    6     7     8    9")
            print(result, "        ")
            printEstado(result, estado)
            cont = cont + 1
            print(result, "proximo ")
            printEstado(result, proximo_estado)

            """ Calcula recompensa"""
            recompensa = calculaRecompensa(proximo_estado, estado,acao, linhat0)

            """Escolhe a proxima acao"""
            proxima_acao = escolheAcao(result, proximo_estado)


            # CALCULA A RECOMPENSA
            println(result, "recompensa: ", recompensa, " estado: ", estado[10], " valor atual: ", linhat0[4])

            # Q_atual = get(Q, acao, -1)
            # Q_proximo = get(Q, proxima_acao, -1)
            # println(result, "Q_atual: ", Q_atual, " Q_proximo: ", Q_proximo)
            # Q_atualizado = Q_atual + taxa_aprendizado*(recompensa + fator_desconto*Q_proximo - Q_atual)
            # aux = Dict(acao => Q_atual)
            # merge!(Q, aux)
            # teste = get(Q, acao, -1)
            antes = Q[acao]
            proximo = Q[proxima_acao]
            Q[acao] = Q[acao] + taxa_aprendizado*(recompensa + fator_desconto*Q[proxima_acao] - Q[acao])

            teste = Q[acao]

            println(result, "antes: ", antes," proximo: ", proximo, " teste dict: ", teste)

            estado = proximo_estado
            acao = proxima_acao
            println(result,"\n**************\nestado", cont, "\n")
      end
      iteracao = iteracao + 1
      if iteracao%1000 == 0
            chave = open("dict/chave$(iteracao).txt", "w")
            valor = open("dict/valoar$(iteracao).txt", "w")

            for (k,v) in Q
                      println(chave, k)
                      println(valor, v)
            end
            it = open("dict/iteracao.txt", "w")
            println(it, iteracao)
            close(it)
      end
      close(result)
      close(dados)
end


#***********************************************
estado = zeros(Int64,10)
proximo_estado = zeros(Int64,10)
dados = open("dados/teste.csv", "r")
test = open("saida/result_teste.txt", "w")
hist = open("saida/historico.txt", "w")
hist2 = open("saida/historico_acumulado.txt", "w")

cabecalho = readline(dados)
linhat3 = split(readline(dados),"\t")
linhat3 = parse.(Float32,linhat3[3:8])
linhat2 = split(readline(dados),"\t")
linhat2 = parse.(Float32,linhat2[3:8])
linhat1 = split(readline(dados),"\t")
linhat1 = parse.(Float32,linhat1[3:8])
linhat0= split(readline(dados),"\t")
linhat0= parse.(Float32,linhat0[3:8])
primeiroEstado(estado, linhat0, linhat1, linhat2, linhat3)
recompensa = 0
historico = []
historico_acumulado = []
while !eof(dados)
      global linhat1
      global linhat0
      global dados
      global estado
      global recompensa
      global proximo_estado
      global historico
      global historico_acumulado
      key = calculaKey(estado)
      acao = melhorAcao(key)
      println(test, "key: ", key)
      if key[3] == 0
            println(test, "1 ", Q[key[1]]," 2 ", Q[key[2]], " acao: ", acao%10, conjuntoAcao[acao%10])
      else println(test, "1 ", Q[key[1]]," 2 ", Q[key[2]]," 3 ", Q[key[3]]," acao: ", acao%10, conjuntoAcao[acao%10])
      end
      linhat2 = linhat1
      linhat1 = linhat0
      linhat0=split(readline(dados),"\t")
      linhat0= parse.(Float32,linhat0[3:8])
      r = calculaRecompensa(proximo_estado, estado, acao, linhat0)
      append!(historico, r)
      recompensa = recompensa + r
      append!(historico_acumulado, recompensa)
      println(test, "recompensa: ", recompensa)
      proximo_estado = executaAcao(result, estado, acao,linhat1, linhat2)
      estado = proximo_estado


end

println(test, " recompensa acumulada: ", recompensa)
println(hist, historico)
println(hist2, historico_acumulado)

close(dados)
