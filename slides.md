%title: Ransomware
%author: Guilherme Vicentin, CP300760X
%date: 2022-04-08


-> # TRABALHO 1 - RANSOMWARE <-

-------------------------------------------------

-> # INTRODUÇÃO  <-

**Ransom**   +   **ware**
(Resgate)   (Algo relacionado a computadores)

> " Ransomware é um tipo de malware que ameaça publicar os dados
> pessoais da vítima ou bloquear perpetuamente o acesso a eles,
> a menos que um resgate seja pago. Se implementado adequadamente,
> recuperar os arquivos sem a chave criptográfica é um problema
> considerado intratável "

 [Wikipedia](https://en.wikipedia.org/wiki/Ransomware).

-------------------------------------------------

-> # INTRODUÇÃO  <-

[Relatório Global de Ransoware, FortiNet 2021](https://inforchannel.com.br/2021/10/01/pesquisa-da-fortinet-mostra-alta-preocupacao-com-ataques-de-ransomware/).

* maior preocupação com ransomware do que com qualquer outra ameaças cibernéticas
* Ataques dessa natureza têm crescido 1.070% por ano
* A principal preocupação é o risco de perda de dados, produtividade e interrupção


[Levantamento realizado pela Microsoft](https://tecmundo.com.br/seguranca/226777-ransomware-cresce-30-gera-prejuizos-r-32-4-bilhoes-brasil.htm)

* R$ 32,4 bilhões de prejuízos às empresas brasileiras.

-------------------------------------------------

-> # OPERAÇÃO  <-

1. **Pré-Ataque**
   1. atacante gera par de chaves assiméticas
   2. chave pública é inserida no malware
   
2. **Infecção**
   1. atacante realiza instalação do software na máquina da vítima
   
3. **Sequestro dos Dados**
   1. malware gera uma chave simétrica
   2. utiliza tal chave para criptografar os dados
   3. criptografa a chave simétrica com chave pública do atacante
   
4. **Pagamento**
   
5. **Recuperação**
   1. após pagamento confirmado, atacante devolve chave simétrica descriptada
   2. dados podem ser recuperados

-------------------------------------------------

-> # INFECÇÃO  <-

* **Engenhatia Social**
  *  E-mails de spam e até mesmo telefonemas para confirmação de credenciais
* **Recrutamento**
  * Oferendo valores para que acessos sejam cedidos
* **Repositórios Públicos**
  * Métodos de busca de credênciais em repositórios públicos
* **Exploração de Vulnerabilidades**
  * Execução de código malicioso explorando softwares vulneráveis

**Grupo Lapsus**
Estuda a rotina e níveis de acessos de profissionais internos do alvo
[Análise realizada pela Microdoft](https://boletimsec.com.br/microsoft-revela-modus-operandi-do-lapsus/)

**WannaCry**
Ransomware com mais de 230.000 máquinas infectadas, cobrando 300 U$/máquina pelo resgate
Vulnerabilidade EthernalBlue desenvolvida pela NSA afeta SOs Windows
[Fonte Wikipedia](https://en.wikipedia.org/wiki/WannaCry_ransomware_attack)

-------------------------------------------------

-> # DEMONSTRAÇÃO  <-

**Agenda**
<br>
* Método de Infecção
<br>
* Simular uma vítima sendo comprometida
<br>
* Recuperar os dados
<br>
* Analisé do código
<br>
* Ambiente

-------------------------------------------------

-> # MITIGAÇÃO  <-

* Se o ataque ainda estiver em curso é possível parar o processo antes do fim
* Nunca execute scripts de instalação de fontes desconfiáveis
* Verifique o código usando cURL
* Manter políticas eficientes de **backup**

-------------------------------------------------

-> # QUESTÕES  <-

1. Por que usamos criptografia assimétrica para criptografar uma chave
   simétrica? Não podemos pular uma etapa e usar criptografia assimétrica
   para criptografar os arquivo?

2. 

-------------------------------------------------

-> # FIM  <-

**Código para a demo e slides**
https://github.com/gvicentin/ransomware-demo
