################################################################                                                           #
##   ANOVA Crecimiento en Altura y Diámetro  Ańo 1 y 2      ####
##                                                          ####
################################################################                                                    #####

# Cargar paquetes necesarios

rm(list = ls())

library(agricolae) # Hace pruebas de medias
library(car)        # Selecciona el tipo de error para prueba de hipótesis.
library(dplyr)
library(Rmisc)
library(xlsx)
#setwd("C:/Users/JOSE LUIS GARCIA/OneDrive - Universidad Politécnica de Madrid/Doctorado_UPM/Tesis/1_Plantación bajo cubierta/Análisis estadístico/2. Crecimiento/Salidas")
#getwd()


#### Ańo1 ####

# Importación de datos desde excel.
growth<-read.table("clipboard", header=T, sep="\t", dec=".")
str(growth)
growth$BLOQUE<-as.factor(growth$BLOQUE)
growth$TRATAMIENTO<-as.factor(growth$TRATAMIENTO)
growth$ESPECIE<-as.factor(growth$ESPECIE)
# Filtrar solo las plantas vivas en el ańo 1
growth_1<-growth[growth$alt_uno != "Muerto",]
# Convertimos la varible a numércia

growth_1$alt_uno<-as.numeric(growth_1$alt_uno)
growth_1$diam_uno<-as.numeric(growth_1$diam_uno)
str(growth_1)
# Creamos nuevas variable de crecmiento relativo y absoluto
growth_1$IA_1<-growth_1$alt_uno-growth_1$alt_cero 
growth_1$ID_1<-growth_1$diam_uno-growth_1$diam_cero
growth_1$TRCA_0_1<-(log(growth_1$alt_uno)-log(growth_1$alt_cero))/11
growth_1$TRCD_0_1<-(log(growth_1$diam_uno)-log(growth_1$diam_cero))/11

# ANOVA ####
# Ir cambiando la variable de respuesta
options(contrasts=c(factor="contr.sum", ordered="contr.poly"))
modelo<- lm(alt_uno~TRATAMIENTO*ESPECIE+BLOQUE, data = growth)
Anova(modelo, type = "III")
summary(modelo)
plot(modelo)

# Supuestos de ANOVA ####
# Normalidad
hist(residuals(modelo))
qqnorm(residuals(modelo))
qqline(residuals(modelo), col="red")
shapiro.test(residuals(modelo))

# Homocedasticidad
plot(fitted(modelo), residuals(modelo), main="Residuos vs Predicciones")
abline(h=0, col="red")
leveneTest(alt_uno~TRATAMIENTO*ESPECIE, data = growth, center=median)

#-Pruebas-Post-hoc con paquete agrocolae

 
out <- HSD.test(modelo,"ESPECIE", group=TRUE,console=TRUE)
out <- HSD.test(modelo,"TRATAMIENTO", group=TRUE,console=TRUE)

# Cáculo de promedios
dplyr::summarise(group_by(growth_1, TRATAMIENTO), mean(TRCD_0_1)) 
dplyr::summarise(group_by(growth_1, ESPECIE), mean(TRCD_0_1)) 

Medias_T<-summarySE(growth_1, measurevar=c ("TRCD_0_1"), groupvars=c("TRATAMIENTO"),na.rm = TRUE)
Medias_S<-summarySE(growth_1, measurevar=c ("TRCD_0_1"), groupvars=c("ESPECIE"),na.rm = TRUE)

write.xlsx(Medias_T,"Medias_TRCD_0_1_T.xlsx")
write.xlsx(Medias_S,"Medias_TRCD_0_1_S.xlsx")


#### Ańo2####

# Importación de datos desde excel.
growth<-read.table("clipboard", header=T, sep="\t", dec=".")
str(growth)
growth$BLOQUE<-as.factor(growth$BLOQUE)
growth$TRATAMIENTO<-as.factor(growth$TRATAMIENTO)
growth$ESPECIE<-as.factor(growth$ESPECIE)


# Filtrar solo las plantas vivas
# Se usará para analizar diametro en ańo 2

growth_y2<-growth[growth$alt_dos != "Muerto",]

# Convertimos las varibles altura y diámetro a numérica

growth_y2$diam_uno<-as.numeric(growth_y2$diam_uno)
growth_y2$diam_dos<-as.numeric(growth_y2$diam_dos)
growth_y2$alt_uno<-as.numeric(growth_y2$alt_uno)
growth_y2$alt_dos<-as.numeric(growth_y2$alt_dos)
str(growth_y2)

# Creamos nuevas variables con el incremento absoluto (IX) y relativo (TRCX)
growth_y2$ID_1_2<-growth_y2$diam_dos-growth_y2$diam_uno
growth_y2$ID_0_2<-growth_y2$diam_dos-growth_y2$diam_cero
growth_y2$IA_1_2<-growth_y2$alt_dos-growth_y2$alt_uno
growth_y2$IA_0_2<-growth_y2$alt_dos-growth_y2$alt_cero

# Tasa relativa de crecimiento en diámetro
growth_y2$TRCD_1_2<-(log(growth_y2$diam_dos)-log(growth_y2$diam_uno))/11
growth_y2$TRCD_0_2<-(log(growth_y2$diam_dos)-log(growth_y2$diam_cero))/22
growth_y2$TRCA_1_2<-(log(growth_y2$alt_dos)-log(growth_y2$alt_uno))/11
growth_y2$TRCA_0_2<-(log(growth_y2$alt_dos)-log(growth_y2$alt_cero))/22






# Filtramos plantas ramoneadas
growth_y2sr<-growth_y2[growth_y2$Ramon != "Si",]

# Convertimos las varibles altura y diámetro a numérica

growth_y2sr$diam_uno<-as.numeric(growth_y2sr$diam_uno)
growth_y2sr$diam_dos<-as.numeric(growth_y2sr$diam_dos)
growth_y2sr$alt_uno<-as.numeric(growth_y2sr$alt_uno)
growth_y2sr$alt_dos<-as.numeric(growth_y2sr$alt_dos)
str(growth_y2sr)

# Creamos nuevas variables con el incremento absoluto (IX) y relativo (TRCX)
growth_y2sr$ID_1_2<-growth_y2sr$diam_dos-growth_y2sr$diam_uno
growth_y2sr$ID_0_2<-growth_y2sr$diam_dos-growth_y2sr$diam_cero
growth_y2sr$IA_1_2<-growth_y2sr$alt_dos-growth_y2sr$alt_uno
growth_y2sr$IA_0_2<-growth_y2sr$alt_dos-growth_y2sr$alt_cero

# Tasa relativa de crecimiento en diámetro
growth_y2sr$TRCD_1_2<-(log(growth_y2sr$diam_dos)-log(growth_y2sr$diam_uno))/11
growth_y2sr$TRCD_0_2<-(log(growth_y2sr$diam_dos)-log(growth_y2sr$diam_cero))/22
growth_y2sr$TRCA_1_2<-(log(growth_y2sr$alt_dos)-log(growth_y2sr$alt_uno))/11
growth_y2sr$TRCA_0_2<-(log(growth_y2sr$alt_dos)-log(growth_y2sr$alt_cero))/22






# Ojo, aquí se usan solo  plantas no ramoneadas#####

#growth_2_dsr<-growth_2_d[growth_2_d$Ramon != "Si",]

# Ojo, aquí se usan solo  plantas no ramoneadas
growth_2_alt$IA_1_2<-growth_2_alt$alt_dos-growth_2_alt$alt_uno
growth_2_alt$IA_0_2<-growth_2_alt$alt_dos-growth_2_alt$alt_cero
growth_2_alt$TRCA_1_2<-(log(growth_2_alt$alt_dos)-log(growth_2_alt$alt_uno))/11
growth_2_alt$TRCA_0_2<-(log(growth_2_alt$alt_dos)-log(growth_2_alt$alt_cero))/22



# ANOVA ####
# Ir cambiando la variable de respuesta
options(contrasts=c(factor="contr.sum", ordered="contr.poly"))
modelo<-lm((alt_dos~TRATAMIENTO*ESPECIE+ BLOQUE, data = growth_y2sr)
Anova(modelo, type = "III")
summary(modelo)

# Supuestos de ANOVA ####
# Normalidad
hist(residuals(modelo))
qqnorm(residuals(modelo))
qqline(residuals(modelo), col="red")
shapiro.test(residuals(modelo))

# Homocedasticidad
plot(fitted(modelo), residuals(modelo), main="Residuos vs Predicciones")
abline(h=0, col="red")
leveneTest(TRCA_0_2~ESPECIE*TRATAMIENTO, data = growth_2_alt, center=median)

#-Pruebas-Post-hoc con paquete agrocolae

out <- HSD.test(modelo,"ESPECIE", group=TRUE,console=TRUE)
out <- HSD.test(modelo,"TRATAMIENTO", group=TRUE,console=TRUE)

# Cáculo de promedios
dplyr::summarise(group_by(growth_2_alt, TRATAMIENTO), mean(TRCA_0_2)) 
dplyr::summarise(group_by(growth_2_alt, ESPECIE), mean(TRCA_0_2)) 


Medias_T<-summarySE(growth_2_alt, measurevar=c ("TRCA_0_2"), groupvars=c("TRATAMIENTO"),na.rm = TRUE)
Medias_S<-summarySE(growth_2_alt, measurevar=c ("TRCA_0_2"), groupvars=c("ESPECIE"),na.rm = TRUE)

write.xlsx(Medias_T,"Medias_TRCA_0_2_T.xlsx")
write.xlsx(Medias_S,"Medias_TRCA_0_2_S.xlsx")



dplyr::summarise(group_by(growth_2_d, TRATAMIENTO), mean(ID_1_2)) 
dplyr::summarise(group_by(growth_2_d, TRATAMIENTO), mean(ID_0_2)) 
dplyr::summarise(group_by(growth_2_d, TRATAMIENTO), mean(TRCD_1_2)) 
dplyr::summarise(group_by(growth_2_d, TRATAMIENTO), mean(TRCD_0_2))

dplyr::summarise(group_by(growth_2_alt, TRATAMIENTO), mean(IA_1_2)) 
dplyr::summarise(group_by(growth_2_alt, TRATAMIENTO), mean(IA_0_2)) 
dplyr::summarise(group_by(growth_2_alt, TRATAMIENTO), mean(TRCA_1_2)) 
dplyr::summarise(group_by(growth_2_alt, TRATAMIENTO), mean(TRCA_0_2))




# Análisis usandola distribuci´no gamma


