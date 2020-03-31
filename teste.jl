const nome_do_arquivo = "dados_teste.txt"

function salvar(info)
      arq = open(nome_do_arquivo, "w")
      for elemento in info
            println(arq, elemento)
      end
      close(arq)
end
dados = rand(10_000)


function ler()
      arq = open(nome_do_arquivo, "r")
      vetor = []
      while !eof(arq)
            linha = readline(arq)
            elemento = parse(Float64, linha)
            vetor = [vetor;elemento]

      end
      close(arq)
      dump(vetor)
end


salvar(dados)
dados_lidos = ler()
