# ===============================================================================================
#
# REPEATED MEASURE ANOVA
# ===============================================================================================
#pacotes necessarios
library(tidyverse)#summarise
library(ggpubr)#ggboxplot
library(rstatix)#Vget_summary_stats
library(ggplot2)
library(gridExtra)#gridarrange boxplot
library(performance) # for assumption checks
library(qqplotr)

df = read.table("data_peryphyton.txt", header = T)
head(df)

#defining factors
df$snails = as.factor(df$snails)
df$nutrient = as.factor(df$nutrient)
df$time = as.factor(df$time)
df$id = as.factor(df$id)

#tendencia geral
dfstats<- df  %>%
  group_by(snails,nutrient,time) %>%
  get_summary_stats(peryphyton_growth, type = "mean_sd")
dfstats

#normalidade
dfnorm <- df %>%
  group_by(snails,nutrient) %>%
  shapiro_test(peryphyton_growth)
dfnorms



#NAO ATINGIR A NORMALIDADE NÃO É MUITO PROBLEMÁTICO, 
#POIS A ANOVA REQUER MAIS A NORMALIDADE DOS RESÍDUOS DO MODELO DO QUE A 
#NORMALIDADE DI DADI BRUTI

# ================================ PLOT =========================================================
bxp1 <- ggplot(df, aes( x = time, y = peryphyton_growth, color = snails))+ #color= fator1 ao inves de fill tbm fica bacana
  geom_boxplot()+
  xlab("Time")+
  ylab("Peryphyton growth")+
  labs(color = "Snails")+
  theme(axis.text.x=element_text(angle = 0),
        panel.background = element_rect(fill = "white", colour = "white"),
        panel.border = element_rect(linetype = "solid", fill = NA))

bxp2 <- ggplot(df, aes( x = time, y = peryphyton_growth, color = nutrient))+ #color= fator1 ao inves de fill tbm fica bacana
  geom_boxplot()+
  xlab("Time")+
  ylab("Peryphyton growth")+
  labs(color = "Nutrient")+
  theme(axis.text.x=element_text(angle = 0),
        panel.background = element_rect(fill = "white", colour = "white"),
        panel.border = element_rect(linetype = "solid", fill = NA))

grid.arrange(bxp1,bxp2, nrow=2)


df$all_trats = as.factor(paste(df$snails, df$nutrient, sep = ""))
df$all_trats
#ordenar NIVEIS
df$all_trats <- factor(df$all_trats, levels = c("Hwithout", "Owithout" ,"Hwith","Owith")) 
ggplot(df, aes( x = time, y = peryphyton_growth, fill = all_trats))+ #color= fator1 ao inves de fill tbm fica bacana
  geom_boxplot()+
  xlab("Time")+
  ylab("Peryphyton growth")+
  labs(fill = "Treatements")+
  theme(axis.text.x=element_text(angle = 0),
        panel.background = element_rect(fill = "white", colour = "white"),
        panel.border = element_rect(linetype = "solid", fill = NA))

# ============================== REPEATED MEASURES ANOVA - METHOD 1 ====================================
# rm using linear model
lm_model <- aov(peryphyton_growth ~ snails*nutrient*time + Error(id/time), data = df)
summary(lm_model)

# Extracting residuals to test normality of residuals
id_model <- lm_model$"id"
id_time_model <- lm_model$"id:time"
# residuals
id_residuals <- residuals(id_model)
id_time_residuals <- residuals(id_time_model)
# shapiro.test
shapiro.test(id_residuals)
shapiro.test(id_time_residuals) #not normal, maybe a log(y) helps

  # ============================== REPEATED MEASURES ANOVA - METHOD 2 ====================================
#using mixed effects
library(lmerTest)
#time needs be continuous in this case, unless the model will have more factors than observations
df$time2 = as.numeric(df$time)
lmm <- lmer(peryphyton_growth ~ snails*nutrient*time2 + (1|id) ,data = df)
summary(lmm)
resid_lmer <- residuals(lme_model)
shapiro.test(resid_lmer) #not normal, maybe a log(y) helps
is_norm <- check_normality(lmm)
is_norm
plot(is_norm, type = "qq", detrend = TRUE)


# ============================== REPEATED MEASURES ANOVA - METHOD 3 =====================================
library(afex)#
#This model also tests sphericity
df = read.table("data_peryphyton.txt", header = T)
model <- aov_ez(
  id = "id", 
  dv = "peryphyton_growth", 
  within = c("time"),
  transformation = "log",
  between = c("snails", "nutrient"), 
  data = df,
  detailed = TRUE
)
summary(model)
is_norm <- check_normality(model);is_norm
plot(is_norm, type = "qq", detrend = TRUE)

# ============================== REPEATED MEASURES ANOVA - METHOD 4 =====================================
library(ez) #USING ez package
#This model also tests sphericity

df$peryLog= log(df$peryphyton_growth)

ez_model <- ezANOVA(
  data = df,
  dv = .(peryphyton_growth),    # dependent variable
  wid = .(id),      # subject id
  between = .(snails, nutrient), #predictors (between effect)
  within = .(time),  # (within-effect: time)
  type = 3,         
  detailed = TRUE)   # Include spherecity test
print(ez_model)

