## cap 3 ##
## Transformação de dados com dplyr - pacote tidyverse## 

library(tidyverse)
install.packages("nycflights13") #pacote com dados de voo de NY
library(nycflights13) 

df <- flights 

#filtrar as colunas através de critérios
filter(df, month == 1, day == 1)

#filtrar as colunas através de critérios e criar um novo df
df_novo <- filter(df, month == 1, day == 1)

#operadores de comparações
# >, >=, <, <=, != (diferente) e == (igual)

#cuidado ao comparar números com muitas casas decimais

sqrt(2) ^ 2 == 2 
1/49 * 49 == 1 

#o correta neste caso é usarmos near()
near(sqrt(2) ^ 2,2)
near(1/49 * 49, 1) 

#operadores lógicos
# & e , | ou , ! não

#voo de novembro ou dezembro
nov_dez <- filter(df, month == 11 | month == 12)

#voos de novembro ou dezembro com notação %in%
nov_dez <- filter(df, month %in% c(11,12))

#selecionando voos que não atrasaram
voo_sem_atraso <- filter(df, !(arr_delay > 120 | dep_delay > 120)) #utilizando a lei de morgan !(x & y) ou !(x | y)
voo_sem_atraso_2 <- filter(df, arr_delay <= 120, dep_delay <= 120)

#selecionando voos que atrasaram
voo_com_atraso <- filter(df, c(arr_delay > 120 | dep_delay > 120))

#valores faltantes NA - not availables , não disponíveis -
#operações com NA sempre resultarão em NA
NA > 5
10 == NA
NA + 10
NA / 2
NA == NA

#determinar se há valores faltantes
x <- NA
is.na(x)

#Atenção - filter não retorna linhas com valor NA
#criando df com linhas NA
df_NA <- tibble(x = c(1,NA,3), y = x * 2)

#explorando função tibble()
?tibble()

#visualizando novo df_NA
df_NA

#testando as linhas NA
is.na(df_NA)

#maneira de filtrar que não considera linhas NA
filter(df_NA, x > 1)

#maneira de filtrar que considera linhas NA
filter(df_NA, x > 1 | is.na(x))

## exercitando o apresendizado ##
#voos para Houston (IAH iu HOU)
view(filter(df, dest == "IAH" | dest == "HOU"))

#foram operador pela United, American ou Delta
view(filter(df, carrier == "US" | carrier == "DL" | carrier == "AA"))

#partiram em julho, agosto ou setembro
view(filter(df, month == 7 | month == 8 | month == 9))

#chegaram com mais de duas horas de atraso mais não saíram atrasados
view(filter(df, dep_delay <= 0 & arr_delay >= 120))

#atrasaram uma hora na decolagem e o voo tem duracao menor ou igual a 30min
view(filter(df, dep_delay >=60 & air_time <= 30))

#atrasaram de 30min a 1h na decolagem
view(filter(df, between(dep_delay,30,60)))

#ordenando linhas com arrange()
view(arrange(df, year, month, day))

#para ordenar por ascendente use asc() e descendente use desc()
view(arrange(df, desc(month)))

#obs: valores faltantes NA são sempre colocados no final

#descobrindo quais variáveis possuem valores NA
summary(is.na(df))

#ordenando os valores NA 
view(arrange(df, desc(is.na(arr_time))))

#utilizando o select() para selecionar colunas
view(select(df, year, month, day))

#selecionando colunas que estão entre
view(select(df, year:day))

#selecionando colunas que Não estão entre
view(select(df, -(year:day)))

#funções úteis para combinarmos com select()
#start_with("abc") - combina nomes que comecem com ABC
#ends_with("xyz") - combina nomes que terminem com XYZ
#contains("ijk") - combina nomes que contenham IJK
#matches("(.)\\1") - para ser utilizada com REGEX - expressão regular
#num_range("x", 1:3) - combinar x1, x2, x3

#renomeando colunas com rename()
view(rename(df, ano = year, mes = month, dia = day))

#movendo variáveis para o início do dataset
view(select(df, time_hour, air_time, everything()))

#adicionando novas variáveis com mutate()

df_novo <- select(df, 
                  year:day,
                  ends_with("delay"),
                  distance,
                  air_time) %>% #operador pipe, utilizado para usar 2 ou mais funções na mesma instrução
          mutate(df_novo, 
                  gain = arr_delay - dep_delay,
                  speed = distance / air_time * 60)

#as novas variáveis podem ser utilizadas para criar outras novas variáveis

df_novo <- mutate(df_novo,
                  hours = air_time / 60,
                  gain_per_hour = gain/hours)

#e se quiser manter apenas as novas variáveis 

df_novo <- transmute(df_novo,
                     gain = arr_delay - dep_delay,
                     hours = air_time / 60,
                     gain_per_hour = gain / hours)

#operadores aritméticos +, -, *, /, ^ e %/% (divisão inteira), %% (resto)

#resumos agrupados com summarize()
view(summarize(df, delay = mean(dep_delay, na.rm = TRUE)))
#na.rm = TRUE é para remover os valores NA

#resumo agrupados com summarize() e group_by()
df_agrupado <- group_by(df, year, month, day)
view(summarize(df_agrupado, delay = mean(dep_delay, na.rm = TRUE)))

#entendendo se há relação entre o atraso dos voo e a distância percorrida 
destino <- group_by(df, dest)
atraso <- summarize(destino,
                    count = n(),
                    dist = mean(distance, na.rm = TRUE),
                    delay = mean(arr_delay, na.rm = TRUE))     
atraso <- filter(atraso, count > 20, dest != "HNL")                    

ggplot(data = atraso, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)
geom_point()

#realizando agrupamento por data
by_data <- flights %>% 
  group_by(year, month, day) %>%
  summarize(delay = mean(dep_delay, na.rm = TRUE))
  

#entendendo se há relação entre o atraso dos voo e a distância percorrida com pipe %>%
atraso <- df %>%
  group_by(dest) %>%
  summarize(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_time, na.rm = TRUE)
  )%>%filter(count > 20, dest != "HNL")

#criando um novo dataset sem os voos cancelados para usos futuros
#obs: os voos cancelados são os que tem dep_delay e arr_delay vazios NA
df_sem_cancelados <- df %>%
  filter(!is.na(dep_delay), !is.na(arr_delay))

#funçao de contagem count()
#obs: sempre que fizer uma agragação sugerimos que inclua count = n()
atrasos <- df_sem_cancelados %>%
  group_by(tailnum) %>%
  summarize(
    delay = mean(arr_delay)
  )

ggplot(data = atrasos, mapping = aes(x = delay))+
  geom_freqpoly(binwidth = 10)

#diagrama de dispersão: qntde_voos vs atraso_médio
atrasos3 <- df_sem_cancelados %>%
  group_by(tailnum) %>%
  summarize(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )

ggplot(data = atrasos3, mapping = aes(x = n, y = delay))+
  geom_point(alpha = 1/10)

atrasos3 %>%
  filter(n > 25) %>%
  ggplot(mapping = aes(x = n, y = delay))+
  geom_point(alpha = 1/10)

#medidas de dispersão sd(), IQR(), mad()
#verificando a dispersão na distância entre os destinos
df_sem_cancelados %>%
  group_by(dest) %>%
  summarize(distancia_sd = sd(distance)) %>%
  arrange(desc(distancia_sd))

#encontrando valores mínimo min() e máximo max()
df_sem_cancelados %>%
  group_by(year, month, day) %>%
  summarize(
    primeiro = min(dep_time),
    ultimo = max(dep_time)
  )

#realizando contagens destintas com n_distinct 
df_sem_cancelados %>%
  group_by(dest) %>%
  summarize(carrier = n_distinct(carrier)) %>%
  arrange(desc(carrier))

#realizando contagens
#contagem por destino
df_sem_cancelados %>%
  group_by(dest) %>%
  summarize(carrier = n()) %>%
  arrange(desc(carrier))

#função específica para contagens
#contangem por destino
df_sem_cancelados %>%
  count(dest) %>%
  arrange(desc(n))

#quando são usados critérios dentro das funções sum() e mean() temos retornos destintos:
#aplicando critério dentro da função de soma sum() teremos a CONTAGEM
#quantos voo que partiram antes das 05AM
df_sem_cancelados %>% 
  group_by(year, month, day) %>% 
  summarize(n_early = sum(dep_time < 500)) #%>% 
  #arrange(desc(n_early))

#aplicando critério dentro da função de média mean() teremos a PROPORÇÃO
#qual o % de voo que chegaram com mais de 1h de atraso
df_sem_cancelados %>% 
  group_by(year, month, day) %>% 
  summarize(hour_per = mean(arr_delay > 60)) %>% 
  arrange(desc(hour_per))

#analisando dados de um time de baiseball, pacote Lahman, base batting
#criando base em formato tibble
rebatidas <- as_tibble(Lahman::Batting)

#avaliando os batedores
batedores <- rebatidas %>%
  group_by(playerID) %>%
  summarize(
    ba = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    ab = sum(AB, na.rm = TRUE)
  )
batedores %>%
  filter(ab > 100) %>%
  ggplot(mapping = aes(x = ab, y = ba)) +
    geom_point() +
    geom_smooth(se = FALSE)

