
"""CONSTANTES """
#CONSTANTES PARA O CABEÇALHO DA TABELA DE DADOS
#Enumerar a constante de acordo com a respectiva coluna na tabela de DADOS
#A primeira coluna tem que necessariamente ser a coluna da Data. 
#Enumerar as demais colunas a partir de 1
const DATA = 1 #nao alterar, a primeira coluna na tabela de dados deve ser a data
const FECHAMENTO = 1
const ABERTURA = 2
const MAXIMA = 3
const MINIMA = 4
const VOLUME = 5
const VARIACAO = 6

#ESTADOS
#nome dos estados
const   POSICAO = 1
const   VAR_PRECO_2 = 2
const   VAR_PRECO_1 = 3
const   ACAO = 4
const   VAR_VOLUME_2 = 5
const   VAR_VOLUME_1 = 6
const   PROX_FECHAMNTO_2 = 7
const   PROX_FECHAMNTO_1 = 8
const   RETORNO = 9

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
