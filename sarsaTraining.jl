# Produzido por Andre Abreu Moreno 
# Antes de executar, verificar o nome do ativo a ser executado 
# No arquivo constantes, atribuir as variaveis relativas aos dados historicos a sua coluna correspondente no arquivo csv 
# lendos dados csv
using DelimitedFiles
using DataFrames
using Random
using CSV
using Dates
using Gadfly, RDatasets
import Cairo, Fontconfig

include("funcao.jl")
include("constantes.jl")
#******************************************************************

# """ Declaracao de variaveis """
# Escolher o ativo (mesmo nome da pasta)
ativo = "PETR3" 
iteracao = 0 # colocar 0 para iniciar um treinamento
# iteracao = 1 # utilizar um modelo ja treinado (ler um dicionario)

# """ Inicializa todos os valores de Q(e,a) arbitrariamente """
Q_e_a = inicializaQ(iteracao, ativo)

# """ Inicio do treinamento"""
qtd_iteracao = 300000
contador = []
historico_recompensa = []
historico_retorno = []
p_enter_long = 0
p_enter_short = 0
# Para cada episodio 
while iteracao < qtd_iteracao
      iteracao = iteracao + 1
      println("iteracao: ", iteracao)
      # DECLARACAO DE VARIAVEIS
      global ativo
      global contador
      global historico_recompensa
      global historico_retorno
      global iteracao
      global ativo
      global Q_e_a
      global p_enter_long
      global p_enter_short

      dados = open(ativo * "/dados/training.csv", "r")
      n = iteracao%5
      recompensa = 0
      recompensa_acumulada = 0
      retorno = 0
      retorno_acumulado = 0


      result = open(ativo * "/saida/resultado$(n).txt", "w")
      cont = 1    #variavel para verificar quantos estados já se passaram na iteracao atual


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
      # Imprime o primeiro estado em result
      # printEstado(result, estado)

      # """ Escolhe a acao """
      acao = escolheAcao(result, estado)

      # println(result, "***************")
      # println(result, "estado ", cont, "\n")

      # """ Ler todos os dados do banco de dados para o episodio """
      while !eof(dados)
            
            # """   S
            # Ler nova linha do historico de valor das acoes
            # instanteT1 = instante relativo ao estado atual
            # instanteT0 = instante relativo ao proximo estado
            # """
            instanteT1 = instanteT0
            instanteT0 = parse.(Float32,split(readline(dados),";")[2:7])


            # """   Atualiza p_enter_short e p_enter_long de entrada da posicao(se for o caso) """
            # preco é atualizado com o preco do fechamento do ativo no instante que ele tomou a acao, ou seja, intanteT1
            p_enter_long, p_enter_short = atualizaPreco1(p_enter_long, p_enter_short, acao, instanteT1)

            # """ Executa a açao """
            proximo_estado = executaAcao(result, estado, acao, instanteT0, instanteT1, p_enter_long, p_enter_short)
            cont = cont + 1
            # """ Calcula recompensa r(t+1) """
            # a recompensa é calculada utilizando o preco ao entra na posicao (Long ou short) e o preco do instante atual
            recompensa_acumulada = recompensa_acumulada + recompensa
            recompensa = calculaRecompensa(p_enter_long, p_enter_short, acao, instanteT1)

            # """ Atualiza o retorno """
            # o retorno é calculado levando em consideracao o preco futuro da acao e o preco atual
            retorno_acumulado = retorno_acumulado + retorno
            retorno = calculaRetorno(p_enter_long,p_enter_short,instanteT0,instanteT1, acao)

            # """ Atualiza p_enter_short e p_enter_long na saida de posicao(se for o caso)"""
            p_enter_long, p_enter_short = atualizaPreco2(p_enter_long, p_enter_short, acao)

            # """Escolhe a proxima acao"""
            proxima_acao = escolheAcao(result, proximo_estado)

            # """ Atualiza Q(e,a) """
            Q_e_a[acao] = atualizaQ(acao, proxima_acao,recompensa, taxa_aprendizado, fator_desconto)

            # """ atualiza estado e acao """
            estado = proximo_estado
            acao = proxima_acao
      end


      # """ Salva Status a cada 1000 iteracoes"""
      if iteracao%2500 == 0
            append!(contador, iteracao)
            append!(historico_recompensa, recompensa_acumulada)
            append!(historico_retorno, retorno_acumulado)
      end
      close(result)
      close(dados)
end

# """ Salvar dicionario """ 
salvarDicionario(ativo)

# """ Plotar grafisco e salvar RECOMPENSA"""
df = DataFrame(Iteracao = contador,Recompensa = historico_recompensa)
CSV.write(ativo * "/IteracaoVsRecompensa.csv", df)
gcont_recompensa = plot(df, x = :Iteracao, y = :Recompensa, Geom.line)
draw(PNG(ativo * "/grafico/Treinamento/iteracaoVsrecompensa.png", 50cm, 15cm), gcont_recompensa)

# """ Plotar grafico e salvar RETORNO"""
df = DataFrame(Iteracao = contador,Retorno = historico_retorno)
CSV.write(ativo * "/IteracaoVsRetorno.csv", df)
gcont_retorno = plot(df, x = :Iteracao, y = :Retorno, Geom.line)
draw(PNG(ativo * "/grafico/Treinamento/iteracaoVsretorno.png", 50cm, 15cm), gcont_retorno)