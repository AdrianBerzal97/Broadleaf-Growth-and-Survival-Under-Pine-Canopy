options(contrasts=c(factor="contr.sum", ordered="contr.poly"))

#Importar base de datos
sup <- read.table("clipboard", header=T, sep="\t", dec=".")
#Explorar base de datos
str(sup)
sup$ESPECIE<-as.factor(sup$especie)#convertimos el bloque a factor
sup$BLOQUE<-as.factor(sup$bloque)#convertimos el bloque a factor
sup$TRATAMIENTO<-as.factor(sup$tratamiento)#convertimos el tratamiento a factor
sup$cobh.1<-as.factor(sup$cobh.1)#convertimos el tratamiento a factor
sup

summary(sup)
library(car)
options(contrasts=c(factor="contr.sum", ordered="contr.poly"))
modelo.glm<-glm(sup_3~, data = sup, family=binomial(link = "logit"))
summary(modelo.glm)
Anova(modelo.glm, type = "3")
