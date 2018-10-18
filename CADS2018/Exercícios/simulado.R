## Simulado

# 1. Caregue os pacotes "tidyverse", "survey" e "srvyr"
lista.de.pacotes = c("tidyverse","lubridate","janitor","readxl","stringr","repmis","survey","srvyr") # escreva a lista de pacotes
novos.pacotes <- lista.de.pacotes[!(lista.de.pacotes %in%
                                      installed.packages()[,"Package"])]
if(length(novos.pacotes) > 0) {install.packages(novos.pacotes)}
lapply(lista.de.pacotes, require, character.only=T)
rm(lista.de.pacotes,novos.pacotes)
gc()

# 2. Leia o conjunto de dados 'api' do pacote survey usando o comando data(api)
data(api)

# 3. Elimine os objetos 'apiclus1', 'apiclus2', 'apipop' e 'apistrat'
# mantendo apenas o objeto apisrs
rm(apiclus1,apiclus2,apipop,apistrat)

# 4. crie o objeto 'pesos' selecionando as colunas 'cds' e 'pw' do objeto 'apisrs'
pesos <- apisrs %>%
  dplyr::select(cds,pw)

# 4. crie o objeto 'escolas_notas' selecionando as colunas 
# 'cds', 'stype', 'api99' e 'api00' do objeto apisrs
pesos <- apisrs %>%
  dplyr::select(cds,stype,api99,api00)


