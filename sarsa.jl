

#lendos dados csv
using DelimitedFiles
using DataFrames
using Random
#CONSTANTES PARA OS ESTADOS
#estado 1
const   LONG  = 1
const   SHORT = 2
const   NPOS  = 3
conjuntoPosicao = ["LONG", "SHORT", "NPOS"]
#estados 2, 3, 5 e 6
const   UP    = 1
const   DOWN  = 2
#estado 4
const   BUY   = 1
const   SELL  = 2
const   NOPe   = 3
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
# Parametros
qtd_Estados = 9

# inicialização das variáveis

estados = zeros(qtd_Estados)
visitados = -ones(1728,7)

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

dados = open("dados/BPAC11.csv", "r")
estado = zeros(Int8,9)
linhat1 = readline(dados)
linhat1 = readline(dados)
estado[1] = NPOS
linhat2 = readline(dados)
bool = false
while !bool
      acao = rand([1,2,3,4,5,6,7])
      println("acao: ", conjuntoAcao[acao], " posicao: ", conjuntoPosicao[estado[1]])
      if estado[1] == LONG
            if acao == STAY_LONG
                  bool = true
            elseif acao == EXIT_LONG
                  bool = true
                  estado[1] = NPOS
            end

      elseif estado[1] == SHORT
            if acao == STAY_SHORT
                  bool = true
            elseif acao == EXIT_SHORT
                  bool = true
                  estado[1] = NPOS
            end
      elseif estado[1] == NPOS
            if acao == ENTER_LONG
                  bool = true
                  estado[1] = LONG
            elseif acao == ENTER_SHORT
                  bool = true
                  estado[1] = SHORT
            elseif acao == NOPa
                  bool = true
            end
      end
end

linhat1 = readline(dados)
linha = readline(dados)

while !eof(dados)
      linha = readline(dados)
      #<DATE>	<TIME>	<OPEN>	<HIGH>	<LOW>	<CLOSE>	<TICKVOL>	<VOL>	<SPREAD>
      println(linha)
end
