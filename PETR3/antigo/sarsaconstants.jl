
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
