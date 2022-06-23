## cap1 visualização de dados com ggplot2

#Instalando a lib tidyverse
install.packages("tidyverse")

#Carregando a lib tidyverse
library(tidyverse)

#Acessar informações do dataframe
?ggplot

#Usando o ggplot2
#Carrega o dataframe para a memória da função
ggplot(data = mpg) +
#Inicia a criação das camadas
  geom_point(mapping = aes(x = displ, y = hwy))

#Exibindo a camada de carga do dataframe para a memória
ggplot(data = mpg)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = cyl, y = hwy))

#Resumo estatístico descritivo
summary(mpg)

#Resumo com num de linhas/colunas, nome das colunas e tipo 
glimpse(mpg)

#Para incluir cores aos pontos com base em outra variável, inclua color dentro do aes() 
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

#Para incluir tamanho aos pontos com base em outra variável, inclua size dentro do aes() 
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, size = class))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class, size = class))

#Para incluir transparência aos pontos com base em outra variável, inclua alpha dentro do aes() 
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

#Para incluir formas aos pontos com base em outra variável, inclua shape dentro do aes() 
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))
#O ggplot só exibe 6 formas e por isso SUVs ficou sem nenhuma

#Para alterar as cores dos pontos, inclua color fora do aes() 
#Declarando fora do aes() redefinimos a cor dos pontos independente dos critérios eixo
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")

########## FACETAS ##########
#Útil para dividir o gráfico através de uma variável caterógica

#Note que a Faceta é outra camada adicionada pelo sinal de "+"

#facet_wrap: separando por uma variável categórica
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow = 2)

#facet_wrap: separando por uma variável categórica
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, ncol = 1)

#facet_grid: separando por Mais de uma variável categórica
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~  cyl)

#facet_grid: separando por Mais de uma variável categórica
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class)) +
  facet_grid(. ~  cyl)

#facet_grid: separando por Mais de uma variável categórica
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class)) +
  facet_grid(cyl ~ .)

########## GEOM ##########
#É o time de gráfico, linhas, colunas, dispersão etc

#Nem toda estética de geom_point funciona em geon_smooth (ex: formato dos pontos)
ggplot(data = mpg)+
  geom_smooth(mapping = aes(x = displ, y = hwy))

#Aqui temos as estéticas específicas linetype
ggplot(data = mpg)+
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))

#Criando grupos
ggplot(data = mpg)+
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))

#Separando as linhas por cores
ggplot(data = mpg)+
  geom_smooth(mapping = aes(x = displ, y = hwy, color = drv))

#Unindo duas camadas de GEOM
ggplot(data = mpg)+
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))+
  geom_point(mapping = aes(x = displ, y = hwy))

#Unindo duas camadas de GEOM sem repetição de código
#Observe que a diferença está no local onde lançamos o mapeamendo
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, linetype = drv))+
  geom_smooth()+
  geom_point()

#Apesar do mapping global, podemos lançar características estéticas separadas
ggplot(data = mpg, mapping = aes(x = displ, y = hwy))+
  geom_smooth(mapping = aes(color = class))+
  geom_point()

#Podemos utilizar funções de filtro no mapeamento global ou até mesmo
# no mapeamento das camadas
ggplot(data = mpg, mapping = aes(x = displ, y = hwy))+
  geom_point(mapping = aes(color = class))+
  geom_smooth(
    data = filter(mpg, class == "subcompact"), 
    se = FALSE
  )
#O critério se = FALSE remove o contorno com o intervalo de confiança ao redor da linha

#Alterando características estéticas dos gráficos para treinar:
#1)
ggplot(
  data = mpg, mapping = aes(x = displ, y = hwy)
) +
  geom_point() +
  geom_smooth(se = FALSE)

#2)
ggplot(
  data = mpg, mapping = aes(x = displ, y = hwy, color = drv)
) +
  geom_point() +
  geom_smooth(se = FALSE)
  
#3)
ggplot(
  data = mpg
) +
  geom_point(mapping = aes(x = displ, y = hwy, alpha = drv)) +
  geom_smooth(mapping = aes(x = displ, y = hwy, color = drv), se = FALSE)

#4)
ggplot(
  data = mpg
) +
  geom_point(mapping = aes(x = displ, y = hwy, alpha = drv)) +
  geom_smooth(mapping = aes(x = displ, y = hwy), se = FALSE)

#5)
ggplot(
  data = mpg
) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv), se = FALSE)

#6)
ggplot(
  data = mpg
) +
  geom_point(mapping = aes(x = displ, y = hwy, color = drv))

########## TRANSFORMAÇÕES ESTATÍSTICAS ##########

?diamonds

#Histograma
#De onde vem o count no eixo y?
#Gráficos de barra, histogramas, polígonos resumem dados do eixo y para plotagem
#O nome desse resumo "automático" é stat e pode ser observado no help do geom_bar
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))

?geom_bar

#gráficos de barra, histogramas e polígonos possuem stats implícitos na funcão geom_
#o stat pode ser alterado se acessado diretamente

demo <- tribble(
  ~a,~b,
  "bar_1",20,
  "bar_2", 30,
  "bar_3", 40
)

ggplot(
  data = demo) +
  geom_bar(
    mapping = aes(x = a, y = b), stat = "identity"
  )

#para ver todos os stats devo avaliar o Computed variables dentro do help do geom_
ggplot(
  data = diamonds
) +
  geom_bar(
    mapping = aes(x = cut, y = ..prop.., group = 1)
  )

#AJUSTES DE POSIÇÃO
#Alterando estética
#1)
ggplot(
  data = diamonds
) +
  geom_bar(
    mapping = aes(x = cut, color = cut)
  )

#2)
ggplot(
  data = diamonds
) +
  geom_bar(
    mapping = aes(x = cut, fill = cut)
  )
  
#3)
ggplot(
  data = diamonds
) +
  geom_bar(
    mapping = aes(x = cut, fill = clarity)
  )

#4)
ggplot(
  data = diamonds
) +
  geom_bar(
    mapping = aes(x = cut, fill = clarity), position = "fill"
  )

#4)
ggplot(
  data = diamonds
) +
  geom_bar(
    mapping = aes(x = cut, fill = clarity), position = "dodge"
  )

#Gráficos que utilizam stats para resumos estatísticos podem possuir 
#valores que se sobrepõe e esses podem ser controlados pela "position = jitter" 
ggplot(
  data = diamonds
) +
  geom_bar(
    mapping = aes(x = cut, fill = clarity), position = "jitter"
  )

#Em gráficos de dispersão/linhas também há presença de resumo automático
#Na base mpg temos 234 pontos e são exibidos apenas 126
#Observe que com o position = "jitter" podemos incluir esse ruído e avaliar os demais pontos
#Esse ajuste é automático e as posições não são precisas (cuidado)
ggplot(
  data = mpg
) +
  geom_point(
    mapping = aes(x = displ, y = hwy), position = "jitter"
  )

#Podemos aprender mais sobre cada ajuste, podemos acessar o help da position e entender o ajuste 
?position_dodge
?position_fill
?position_jitter

########## SISTEMAS DE COORDENADAS ##########

#BoxPlot
ggplot(
  data = mpg, mapping = aes(x = class, y = hwy)
  ) +
  geom_boxplot()

#BoxPlot + flip
ggplot(
  data = mpg, mapping = aes(x = class, y = hwy)
) +
  geom_boxplot() +
  coord_flip()
