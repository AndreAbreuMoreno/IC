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

function criaQ(iteracao)
      if iteracao == 0
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
                                                                        append!(vals,rand()*0.000001)
                                                                        # append!(vals,rand())
                                                                        aux = num + 3
                                                                        append!(keys,aux)
                                                                        append!(vals,rand()*0.000001)
                                                                        # append!(vals,rand())
                                                                  elseif a == 2
                                                                        aux = num + 5
                                                                        append!(keys,aux)
                                                                        append!(vals,rand()*0.000001)
                                                                        # append!(vals,rand())

                                                                        aux = num + 6
                                                                        append!(keys,aux)
                                                                        append!(vals,rand()*0.000001)
                                                                        # append!(vals,rand())

                                                                  elseif a == 3
                                                                        aux = num + 1
                                                                        append!(keys,aux)
                                                                        append!(vals,rand()*0.000001)
                                                                        # append!(vals,rand())

                                                                        aux = num + 4
                                                                        append!(keys,aux)
                                                                        append!(vals,rand()*0.000001)
                                                                        # append!(vals,rand())

                                                                        aux = num + 7
                                                                        append!(keys,aux)
                                                                        append!(vals,rand()*0.000001)
                                                                        # append!(vals,rand())

                                                                  end
                                                                  append!(vals,rand()*0.000001)
                                                                  # append!(vals,rand())

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
            Q_e_a = Dict(zip(keys, vals))
            return Q_e_a
      else

            chave = open("dict/chave/chave.txt", "r")
            valor = open("dict/valor/valor.txt", "r")
            dic = open("dict/dicionario.txt", "w")
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
      epsilon = rand()
      taxa_exploracao = exp(log(0.5) + iteracao*(log(0.0001)-log(0.5))/350000)
      acao = melhorAcao(arq,key)
      if epsilon > 1.5*taxa_exploracao
            println(arq, "melhor acao")
            return acao
      else
            println(arq, "aleatorio")
            num = rand(1:3)
            while key[num] == 0 || key[num] == acao
                  num = rand(1:3)
            end
            println(arq, "num ", num, " key: ", key[num])
            return key[num]
      end
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
            println(arq, "key 3 != 0")
            if Q_e_a[key[1]] >= Q_e_a[key[2]]
                  if Q_e_a[key[1]] >= Q_e_a[key[3]]
                        println(arq, "1")
                        return key[1]
                  else
                        println(arq, "key3")
                        return key[3]
                  end
            elseif Q_e_a[key[2]] >= Q_e_a[key[3]]
                  println(arq, "key2")
                  return key[2]

            else
                  println(arq, "key3")
                  return key[3]
            end
      elseif Q_e_a[key[1]] >= Q_e_a[key[2]]
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

function executaAcao(arq, estado,acao,linhat0, linhat1, linhat2)
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
      recomp = 0
      if estado[1] == NPOS
            recomp = 0
      elseif estado[1] == LONG
            recomp = (linhat0[4] - estado[10])/estado[10]
      elseif estado[1] == SHORT
            recomp = (estado[10] - linhat0[4])/estado[10]
      end
      return recomp
end
#******************************************************************

""" Declaracao de variaveis """
qtd_iteracao = 350000
dadosTraining = "dados/PETR3training.csv"
dadosTeste = "dados/PETR3teste.csv"
iteracao = 0
const taxa_aprendizado  = 0.007
const fator_desconto    = 0.7

""" Inicializa todos os valores de Q(e,a) arbitrariamente """
Q_e_a = criaQ(iteracao)

""" Para cada episodio """
contador = []
saida = []
while iteracao < qtd_iteracao
      println("iteracao", iteracao)
      # DECLARACAO DE VARIAVEIS
      global iteracao
      global cont = 1    #variavel para verificar quantos estados já se passaram na iteracao atual
      n = iteracao%5
      recompensa = 0
      recompensa_acumulada = 0
      global dados = open(dadosTraining, "r")
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
      printEstado(result, estado)

      """ Escolhe a acao """
      acao = escolheAcao(result, estado)

      println(result, "***************")
      println(result, "estado ", cont, "\n")

      """ REPEAT """
      while !eof(dados)
            linhat2 = linhat1
            linhat1 = linhat0
            linhat0 = split(readuntil(dados,"%"),";")
            linhat0 = parse.(Float64,linhat0[3:9])

            """ Executa a açao """
            proximo_estado = executaAcao(result, estado, acao,linhat0, linhat1, linhat2)
            # IMPRIME ESTADO E PROXIMO ESTADO
            println(result, "linha t1 ", linhat1)
            println(result, "linha t0 ", linhat0)
            println(result, "                    1     2   3   4   5    6     7     8    9")
            print(result, "        ")
            printEstado(result, estado)
            cont = cont + 1
            print(result, "proximo ")
            printEstado(result, proximo_estado)

            """ Calcula recompensa r(proximo estado)"""
            recompensa_acumulada = recompensa_acumulada + recompensa
            proxima_recompensa = calculaRecompensa(proximo_estado, estado,acao, linhat0)

            """Escolhe a proxima acao"""
            proxima_acao = escolheAcao(result, proximo_estado)

            println(result, "recompensa: ", recompensa, " estado: ", estado[10], " valor atual: ", linhat1[4])

            """ Atualiza Q(e,a) """
            antes = Q_e_a[acao]
            proximo = Q_e_a[proxima_acao]
            Q_e_a[acao] = Q_e_a[acao] + taxa_aprendizado * (recompensa + fator_desconto* Q_e_a[proxima_acao] - Q_e_a[acao])
            println(result, "antes: ", antes," proximo: ", proximo, " teste dict: ", Q_e_a[acao])

            """ atualiza estado e acao """
            estado = proximo_estado
            acao = proxima_acao
            recompensa = proxima_recompensa

            println(result, "***************")
            println(result, "estado ", cont, "\n")
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
