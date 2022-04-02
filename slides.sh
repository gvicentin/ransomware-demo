
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