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
                                                                        # append!(vals,rand())
                                                                        # append!(vals,rand()*0.000001)
                                                                        # append!(vals,(rand()-rand(0:1))*0.000001)
                                                                        append!(vals,(rand()-rand(0:1)))
                                                                        aux = num + 3
                                                                        append!(keys,aux)
                                                                        # append!(vals,rand())
                                                                        # append!(vals,rand()*0.000001)
                                                                        # append!(vals,(rand()-rand(0:1))*0.000001)
                                                                        append!(vals,(rand()-rand(0:1)))
                                                                  elseif a == 2
                                                                        aux = num + 5
                                                                        append!(keys,aux)
                                                                        # append!(vals,rand())
                                                                        # append!(vals,rand()*0.000001)
                                                                        # append!(vals,(rand()-rand(0:1))*0.000001)
                                                                        append!(vals,(rand()-rand(0:1)))

                                                                        aux = num + 6
                                                                        append!(keys,aux)
                                                                        # append!(vals,rand())
                                                                        # append!(vals,rand()*0.000001)
                                                                        # append!(vals,(rand()-rand(0:1))*0.000001)
                                                                        append!(vals,(rand()-rand(0:1)))

                                                                  elseif a == 3
                                                                        aux = num + 1
                                                                        append!(keys,aux)
                                                                        # append!(vals,rand())
                                                                        # append!(vals,rand()*0.000001)
                                                                        # append!(vals,(rand()-rand(0:1))*0.000001)
                                                                        append!(vals,(rand()-rand(0:1)))

                                                                        aux = num + 4
                                                                        append!(keys,aux)
                                                                        # append!(vals,rand())
                                                                        # append!(vals,rand()*0.000001)
                                                                        # append!(vals,(rand()-rand(0:1))*0.000001)
                                                                        append!(vals,(rand()-rand(0:1)))

                                                                        aux = num + 7
                                                                        append!(keys,aux)
                                                                        # append!(vals,rand())
                                                                        # append!(vals,rand()*0.000001)
                                                                        # append!(vals,(rand()-rand(0:1))*0.000001)
                                                                        append!(vals,(rand()-rand(0:1)))

                                                                  end
                                                                  # append!(vals,rand()*0.000001)
                                                                  # append!(vals,(rand()-rand(0:1))*0.000001)
                                                                  # append!(vals,(rand()-rand(0:1))*0.000001)

                                                            end
                                                      end
                                                end
                                          end
                                    end
                              end
                        end
                  end
            end
            # vals = zeros(size(keys)) nao compensa, resultado pior
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

function criaQTeste(dictChave, dictValor)
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
      #ESTADO 8
      media = (linhat1[2] + linhat1[3])/2
      if linhat1[4] >= media
            estado[8] = MAX
      else estado[8] = MIN
      end
      #ESTADO 9
      estado[9] = NPOS
      estado[10]= 0
end

function escolheAcao(arq, estado)
      println(arq, "\nEscolhe acao")
      key = calculaKey(estado)
      println(arq, "key: ", key)
      epsilon = rand()
      taxa_exploracao = exp(log(0.5) + iteracao*(log(0.0001)-log(0.5))/300000)
      acao = melhorAcao(arq,key)
      if epsilon > taxa_exploracao
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

function escolheAcaoTeste(arq, estado)
      println(arq, "\nEscolhe acao")
      key = calculaKey(estado)
      println(arq, "key: ", key)
      epsilon = rand()
      taxa_exploracao = 0
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
                        println(arq, "key 1")
                        return key[1]
                  else
                        println(arq, "key 3")
                        return key[3]
                  end
            elseif Q_e_a[key[2]] >= Q_e_a[key[3]]
                  println(arq, "key 2")
                  return key[2]
            else
                  println(arq, "key 3")
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
      println(arq, "")
end

function executaAcao(arq, estado,acao,linhat0, linhat1, linhat2, preco_long,preco_short)
      acao = acao%10
      println(arq, "acao: ", acao," - ", conjuntoAcao[acao])
      # ESTADO 1
      proximo_estado = zeros(10)
      if acao == ENTER_LONG
            proximo_estado[1] = LONG
            proximo_estado[10] = preco_long
      elseif acao == EXIT_LONG || acao == EXIT_SHORT
            proximo_estado[1] = NPOS
            proximo_estado[10] = 0
      elseif acao == ENTER_SHORT
            proximo_estado[1] = SHORT
            proximo_estado[10] = preco_short
      elseif acao == STAY_LONG || acao == STAY_SHORT || acao == NOPa
            proximo_estado[1] = estado[1]
            proximo_estado[10] = estado[10]
      end

      #ESTADO 2
      proximo_estado[2] = estado[3]

      #ESTADO 3
      if linhat1[4] >= linhat1[1]
            proximo_estado[3] = UP
      else proximo_estado[3] = DOWN
      end

      #ESTADO 4
      if acao == ENTER_LONG || acao == EXIT_SHORT
            proximo_estado[4] = BUY
      elseif acao == EXIT_LONG || acao == ENTER_SHORT
            proximo_estado[4] = SELL
      elseif acao == STAY_LONG || acao == STAY_SHORT || acao == NOPa
            proximo_estado[4] = NOPa
      end

      #ESTADO 5
      proximo_estado[5] = estado[6]

      #ESTADO 6
      if linhat1[6] >= linhat2[6]
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
      # if proximo_estado[1] == NPOS
      #       proximo_estado[9] =  NPOS
      # elseif proximo_estado[1] == LONG
      #       if preco_long >= linhat1[4]
      #             proximo_estado[9] = UP
      #       else proximo_estado[9] = DOWN
      #       end
      # elseif proximo_estado[1] == SHORT
      #       if preco_short >= linhat1[4]
      #             proximo_estado[9] = DOWN
      #       else proximo_estado[9] = UP
      #       end
      # end
      if proximo_estado[1] == NPOS
            proximo_estado[9] =  NPOS
      elseif proximo_estado[1] == LONG
            if linhat0[4] >= linhat1[4]
                  proximo_estado[9] = UP
            else proximo_estado[9] = DOWN
            end
      elseif proximo_estado[1] == SHORT
            if linhat0[4] >= linhat1[4]
                  proximo_estado[9] = DOWN
            else proximo_estado[9] = UP
            end
      end
      return proximo_estado
end

function calculaRecompensa(preco_long, preco_short,estado, acao, linhat0)
      recomp = 0
      n = acao%10
      if n == NOPa
            recomp = 0
      elseif n == ENTER_LONG || n == STAY_LONG || n == EXIT_LONG
            recomp = (linhat0[4] - preco_long)/preco_long
      elseif n == ENTER_SHORT || n == STAY_SHORT ||n == EXIT_SHORT
            recomp = (preco_short - linhat0[4])/preco_short
      end
      return recomp
end


function atualizaPreco1(preco_long, preco_short,  acao, linhat1)
      n = acao%10
      if n == ENTER_LONG
            preco_long = linhat1[4]
      elseif n == ENTER_SHORT
            preco_short = linhat1[4]
      end
      return preco_long, preco_short
end

function atualizaPreco2(preco_long, preco_short, acao, linhat1)
      n = acao%10
      if n == EXIT_LONG
            preco_long = 0
      elseif n == EXIT_SHORT
            preco_short = 0
      end
      return preco_long, preco_short
end
