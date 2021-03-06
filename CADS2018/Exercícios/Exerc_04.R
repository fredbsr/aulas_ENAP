# Exercícios aula 04
lista.de.pacotes = c("tidyverse","lubridate","janitor","readxl","stringr","repmis") # escreva a lista de pacotes
novos.pacotes <- lista.de.pacotes[!(lista.de.pacotes %in%
                                      installed.packages()[,"Package"])]
if(length(novos.pacotes) > 0) {install.packages(novos.pacotes)}
lapply(lista.de.pacotes, require, character.only=T)
rm(lista.de.pacotes,novos.pacotes)
gc()



# Carregue o arquivo `decisoes.rds` em um objeto chamado `decisoes`. ----

decisoes <- read_rds("C:/Users/Aluno/Desktop/git/aulas_ENAP/CADS2018/Exercícios/dados/decisoes.rds")

# Crie um objeto contendo o tempo médio entre decisão e registro por juiz, apenas para processos relacionados a drogas nos municípios de Campinas ou Limeira. ----
## Obs.: a nova "singularidade" da base de dados será o `juiz`. Na base original, a singularidade era o `processo`

juizes_drogas_CL <- decisoes %>% 
  # selecionando as colunas utilizadas (só pra usar o select)
  select(juiz,municipio,txt_decisao,data_registro,data_decisao) %>%
  # criando variável "droga" a partir do texto da decisão
  mutate(txt_decisao = tolower(txt_decisao),
         droga = str_detect(txt_decisao,
                            "droga|entorpecente|psicotr[óo]pico|maconha|haxixe|coca[íi]na"),
          # variável tempo,
         tempo = dmy(data_registro) - dmy(data_decisao)) %>% 
  # filtrando municípios e processos sobre drogas
  filter(droga ==TRUE,municipio %in% c("Campinas","Limeira")) %>%
  group_by(juiz) %>%
  summarise(tempo_medio = mean(tempo,na.rm=T))

# Salve o objeto resultante em um arquivo chamado `juizes_drogas_CL.rds` ----

write_rds(juizes_drogas_CL,
          "C:/Users/Aluno/Desktop/git/aulas_ENAP/CADS2018/Exercícios/dados/juizes_drogas_CL.rds")


# Faça commit e push do script e do arquivo `.rds` ----

#
dec_gather <- decisoes %>% 
  filter(!is.na(id_decisao)) %>% 
  select(id_decisao:data_registro) %>% 
  # 1. nome da coluna que vai guardar os nomes de colunas empilhadas
  # 2. nome da coluna que vai guardar os valores das colunas
  # 3. seleção das colunas a serem empilhadas
  gather(key="variavel", value="valor", -id_decisao) %>% 
  arrange(id_decisao)


decisoes_peq <- decisoes %>%
  head(2)

dec_gather_peq <- decisoes_peq %>% 
  filter(!is.na(id_decisao)) %>% 
  select(id_decisao:data_registro) %>% 
  # 1. nome da coluna que vai guardar os nomes de colunas empilhadas
  # 2. nome da coluna que vai guardar os valores das colunas
  # 3. seleção das colunas a serem empilhadas
  gather(key="variavel", value="valor", -id_decisao) %>% 
  arrange(id_decisao)

levels(factor(dec_gather$variavel))

decisoes_spread <- decisoes %>% 
  filter(!is.na(id_decisao)) %>% 
  select(id_decisao:data_registro) %>% 
  gather(key, value, -id_decisao) %>%
  
  # 1. coluna a ser espalhada
  # 2. valores da coluna
  spread(key, value)

# Qual juiz julga a maior proporção de processos que tratam de drogas ----

juiz_droga <- decisoes %>% 
  filter(!is.na(txt_decisao)) %>%
  mutate(txt_decisao = tolower(txt_decisao),
         droga = str_detect(txt_decisao,
                            "droga|entorpecente|psicotr[óo]pico|maconha|haxixe|coca[íi]na"),
         droga=case_when(
           droga==TRUE ~ "droga",
           droga==FALSE ~ "n_droga"
         )) %>%
  group_by(juiz,droga) %>%
  summarise(n=n()) %>%
  spread(droga,n,fill = 0) %>%
  mutate(total=droga+n_droga,
         proporcao=droga/total) %>%
  arrange(desc(proporcao))
  

# Crie um objeto contendo informações sobre os tamanhos das bancadas dos ----
# partidos (arquivo `bancadas.rds`), suas respectivas coligações 
# eleitorais para 2018 (arquivo `coligacoes.xlsx`) e o 
# grau de concordância com a agenda do Gov 
# Temer (arquivo `governismo_temer.xlsx`). 

# Bônus: use `group_by` e `summarise` para identificar qual candidato tem a ----
# coligação com menor média de concordância e qual candidato 
# tem a maior proporção total de assentos.