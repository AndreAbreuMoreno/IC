
function inicializaQ(iteracao, ativo)
      # Funcao que inicializa os valores da funcao Q(e,a) caso seja a primeira iteracao ou retorna os valores mais atual da funcao
      # :param iteracao: quantidade de iteracao realizada no treinamento
      # :type iteracao: int64
      # :return: dicionario contando valores da funcao estado-acao
      # :type: dict

      if iteracao == 0
            # Inicializacao dos indices de Q
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
                                                                        append!(vals,(rand()-rand(0:1))*0.1)
                                                                        aux = num + 3
                                                                        append!(keys,aux)
                                                                        append!(vals,(rand()-rand(0:1))*0.1)
                                                                  elseif a == 2
                                                                        aux = num + 5
                                                                        append!(keys,aux)
                                                                        append!(vals,(rand()-rand(0:1))*0.1)
                                                                        aux = num + 6
                                                                        append!(keys,aux)
                                                                        append!(vals,(rand()-rand(0:1))*0.1)
                                                                  elseif a == 3
                                                                        aux = num + 1
                                                                        append!(keys,aux)
                                                                        append!(vals,(rand()-rand(0:1))*0.1)
                                                                        aux = num + 4
                                                                        append!(keys,aux)
                                                                        append!(vals,(rand()-rand(0:1))*0.1)
                                                                        aux = num + 7
                                                                        append!(keys,aux)
                                                                        append!(vals,(rand()-rand(0:1))*0.1)
                                                                  end
                                                            end
                                                      end
                                                end
                                          end
                                    end
                              end
                        end
                  end
            end
            Q_e_a = Dict(zip(keys, vals))
            return Q_e_a
      else
            # Realizar leitura de um dicionario armazenado
            chave = open(ativo * "/dict/chave.txt", "r")
            valor = open(ativo * "/dict/valor.txt", "r")
            keys= []
            vals = []
            while !eof(chave)
                  k = parse.(Int64,readline(chave))
                  v = parse.(Float64,readline(valor))
                  append!(keys, k)
                  append!(vals, v)
            end
            Q_e_a = Dict(zip(keys, vals))

            close(chave)
            close(valor)

            return Q_e_a
      end
end

function imprimeDicionario(Q_e_a, ativo)
      # Funcao que imprimi dicionario para conferencia
      # :param Q_e_a: dicionario a ser impresso
      # :type Q_e_a: dict
      # :param ativo: acao que esta analisando (nome da pasta)
      # type ativo: string

      dic = open(ativo * "/dict/dicionario.txt", "w")
      for (k,v) in Q_e_a
            println(dic, "k:", k, "v: ",v, " typeofk: ", typeof(k))
      end
      close(dic)
end

function primeiroEstado(estado,instanteT0, instanteT1)
      # Funcao que obtem o estado inicial 
      # :param estado: estado em que o agente se encontra
      # :type estado: array de int com 10 dimensoes
      # :param instanteT0: instante relativo ao estado atual do agente
      # :type instanteT0: array de string
      # :param instanteT1: instante relativo ao estado no temp T-1 do agente
      # :type instanteT1: array de string
      estado[POSICAO] = NPOS

      #ESTADO 2
      if (instanteT1[FECHAMENTO] - instanteT1[ABERTURA]) >= 0
            estado[VAR_PRECO_2] = UP
      else estado[VAR_PRECO_2] = DOWN
      end


      #ESTADO 3
      if instanteT0[FECHAMENTO] - instanteT0[ABERTURA] >= 0
            estado[VAR_PRECO_1] = UP
      else estado[VAR_PRECO_1] = DOWN
      end

      #ESTADO 4
      estado[ACAO] = NOPa

      #ESTADO 5    
      estado[VAR_VOLUME_2] = UP
  
      
      #ESTADO 6
      if instanteT0[VOLUME] >= instanteT1[VOLUME]
            estado[VAR_VOLUME_1] = UP
      else estado[VAR_VOLUME_1] = DOWN
      end
      
      #ESTADO 7
      media1 = (instanteT1[MAXIMA] + instanteT1[MINIMA])/2
      if instanteT1[FECHAMENTO] >= media1
            estado[7] = MAX
      else estado[7] = MIN
      end

      #ESTADO 8
      media = (instanteT0[MAXIMA] + instanteT0[MINIMA])/2
      if instanteT0[FECHAMENTO] >= media
            estado[8] = MAX
      else estado[8] = MIN
      end

      #ESTADO 9
      estado[RETORNO] = NPOS
      
end

function escolheAcao(arq, estado)
      # Funcao que escolha a acao utilizado a politica e-greedy
      # :param arq: arquivo onde sera impresso informacoes para conferencia
      # :param estado: estado atual do agente
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
            while key[num] == 0
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

function executaAcao(arq, estado,acao,instanteT0, instanteT1, preco_long,preco_short)
      # instanteT1 = instante relativo ao estado atual
      # instanteT0 = instante relativo ao proximo estado
      acao = acao%10
      println(arq, "acao: ", acao," - ", conjuntoAcao[acao])
      # ESTADO 1 - TIPO DE POSICAO 
      proximo_estado = zeros(10)
      if acao == ENTER_LONG
            proximo_estado[POSICAO] = LONG
      elseif acao == EXIT_LONG || acao == EXIT_SHORT
            proximo_estado[POSICAO] = NPOS
      elseif acao == ENTER_SHORT
            proximo_estado[POSICAO] = SHORT
      elseif acao == STAY_LONG || acao == STAY_SHORT || acao == NOPa
            proximo_estado[POSICAO] = estado[POSICAO]
      end

      #ESTADO 2 - VARIACAO DE PRECO EM T-2
      proximo_estado[VAR_PRECO_2] = estado[VAR_PRECO_1]

      #ESTADO 3 - VARIACAO DO PRECO EM T-1
      if instanteT1[FECHAMENTO] >= instanteT1[ABERTURA]
            proximo_estado[3] = UP
      else proximo_estado[3] = DOWN
      end

      #ESTADO 4 - ACAO TOMADA
      if acao == ENTER_LONG || acao == EXIT_SHORT
            proximo_estado[ACAO] = BUY
      elseif acao == EXIT_LONG || acao == ENTER_SHORT
            proximo_estado[ACAO] = SELL
      elseif acao == STAY_LONG || acao == STAY_SHORT || acao == NOPa
            proximo_estado[ACAO] = NOPa
      end

      #ESTADO 5 - VARIACAO DO VOLUME EM T-2
      proximo_estado[VAR_VOLUME_2] = estado[VAR_VOLUME_1]

      #ESTADO 6 - VARIACAO DO VOLUME EM T-1
      if instanteT0[VOLUME] >= instanteT1[VOLUME]
            proximo_estado[VAR_VOLUME_1] = UP
      else proximo_estado[VAR_VOLUME_1] = DOWN
      end

      #ESTADO 7 - EXTREMO MAIS PROXIMO DO PRECO DE FECHAMENTO EM T-2
      proximo_estado[7] = estado[8]

      #ESTADO 8 - EXTREMO MAIS PROXIMO DO PRECO DE FECHAMENTO EM T-1
      media = (instanteT1[MAXIMA] + instanteT1[MINIMA])/2
      if instanteT1[FECHAMENTO] >= media
            proximo_estado[8] = MAX
      else proximo_estado[8] = MIN
      end

      #ESTADO 9 - RETORNO
      if proximo_estado[POSICAO] == NPOS
            proximo_estado[RETORNO] =  NPOS
      elseif proximo_estado[POSICAO] == LONG
            if preco_long <= instanteT1[FECHAMENTO]
                  proximo_estado[RETORNO] = UP
            else proximo_estado[RETORNO] = DOWN
            end
      elseif proximo_estado[POSICAO] == SHORT
            if preco_short <= instanteT1[FECHAMENTO]
                  proximo_estado[RETORNO] = DOWN
            else proximo_estado[RETORNO] = UP
            end
      end

      return proximo_estado
end

function calculaRecompensa(preco_long, preco_short, acao, instanteT1)
      recomp = 0
      n = acao%10
      if n == NOPa
            recomp = 0
      elseif n == ENTER_LONG || n == STAY_LONG || n == EXIT_LONG
            recomp = (instanteT1[FECHAMENTO] - preco_long)/preco_long
      elseif n == ENTER_SHORT || n == STAY_SHORT ||n == EXIT_SHORT
            recomp = (preco_short - instanteT1[FECHAMENTO])/preco_short
      end
      return recomp
end

function atualizaQ(acao, proxima_acao, recompensa, taxa_aprendizado, fator_desconto)
      val = Q_e_a[acao] + taxa_aprendizado * (recompensa + fator_desconto * Q_e_a[proxima_acao] - Q_e_a[acao])
      return val
end

function atualizaPreco1(preco_long, preco_short,  acao, instanteT1)
      n = acao%10
      if n == ENTER_LONG
            preco_long = instanteT1[FECHAMENTO]
      elseif n == ENTER_SHORT
            preco_short = instanteT1[FECHAMENTO]
      end
      return preco_long, preco_short
end

function atualizaPreco2(preco_long, preco_short, acao)
      
      n = acao%10
      if n == EXIT_LONG
            preco_long = 0
      elseif n == EXIT_SHORT
            preco_short = 0
      end
      return preco_long, preco_short
end

function calculaRetorno(p_enter_long,p_enter_short,instanteT0,instanteT1, acao)
      n = acao%10
      if p_enter_short == 0 && p_enter_long == 0
            evolucao = 0
      elseif p_enter_long != 0 #n == ENTER_LONG || n == STAY_LONG || n == EXIT_LONG
            evolucao = (instanteT0[FECHAMENTO] - instanteT1[FECHAMENTO])/p_enter_long
      elseif p_enter_short != 0  #n == ENTER_SHORT || n == STAY_SHORT ||n == EXIT_SHORT
            evolucao = (instanteT1[FECHAMENTO] - instanteT0[FECHAMENTO])/p_enter_short
      end
      return evolucao
end


function salvarDicionario(ativo)
      chave = open(ativo * "/dict/chave.txt", "w")
      valor = open(ativo * "/dict/valor.txt", "w")
      for (k,v) in Q_e_a
            println(chave, k)
            println(valor, v)
      end
      close(chave)
      close(valor)
end