### CAP 05 - ANÁLISE EXPLORATÓRIA DE DADOS ###

## Algumas perguntas importantes a se fazer no início

# 1) Que tipo de variação ocorre dentro de minhas variáveis?
# 2) Que tipo de covariação ocorre entre minhas variáveis?

## VISUALIZANDO DISTRIBUIÇÕES ##

library(tidyverse)

#Plotando a varivável cut em forma de barra, onde x é a variável e y a contagem(n)
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))

#Contagem de cut (n)
diamonds %>% 
  count(cut)

#Plotando a varivável carat em forma de histograma, onde x é a variável e y a contagem(n)
#Um histograma divide o eixo x em caixas (bins)
ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.5)

#Contagem de carat (n) entre as bins
diamonds %>% 
  count(cut_width(carat, 0.5))

#Para sobrepor vários histogramas podemos utilizar os gráficos de linhas da função abaixo
# eles realizam o mesmo cálculo mas são melhores visualmente
#Gerando base com diamantes < que 3 quilates
smaller <- diamonds %>% 
  filter(carat < 3)

#Gráfico1 - linhas por qualidade do diamante
ggplot(data = smaller) +
  geom_freqpoly(mapping = aes(x = carat, color = cut), binwidth = 0.1)

#Gráfico2 - valores frequentes
ggplot(data = smaller) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.01)

#Gráfico3 - valores incomuns (outliers)
ggplot(diamonds) +
  geom_histogram(mapping = aes(x = y), binwidth = 0.5)

#Gráfico3.1 - valores incomuns (outliers) - melhorando a visualização (estabelecendo limite eixo y)
ggplot(diamonds) +
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(ylim = c(0,50))


### VALORES FALTANTES (MISSING VALUES) ###

#Utilizando mutate() e ifelse para modificar os valores da variável y
# ifelse(condição lófica, valor verdadeiro, valor falso)
diamonds2 <- diamonds %>% 
  mutate(y = ifelse(y < 3 | y > 20, NA, y))

#Gráfico1: com y alterado (inclusão de NA no lugar dos outliers)
#Observe que o R exibirá um  Warning avisando sobre a remoção de NA
ggplot(diamonds2) + 
  geom_point(mapping = aes(x = x, y = y))

#Gráfico2: com y alterado (inclusão de NA no lugar dos outliers)
#Observe que o R NÃO exibirá um Warning avisando sobre NA pois a função na.rm = TRUE irá removê-los
ggplot(diamonds2) + 
  geom_point(mapping = aes(x = x, y = y), na.rm = TRUE)

