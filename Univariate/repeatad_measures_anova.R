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

df = read.table("data_periphyton.txt", header = T)
head(df)

#defining factors
df$snails = as.factor(df$snails)
df$nutrient = as.factor(df$nutrient)
df$time = as.factor(df$time)
df$id = as.factor(df$id)

#tendencia geral
dfstats<- df  %>%
  group_by(snails,nutrient,time) %>%
  get_summary_stats(periphyton_growth, type = "mean_sd")
dfstats

#normalidade
dfnorm <- df %>%
  group_by(snails,nutrient) %>%
  shapiro_test(periphyton_growth)
dfnorm


#NAO ATINGIR A NORMALIDADE NÃO É MUITO PROBLEMÁTICO, 
#POIS A ANOVA REQUER MAIS A NORMALIDADE DOS RESÍDUOS DO MODELO DO QUE A 
#NORMALIDADE DI DADI BRUTI

# ================================ PLOT =========================================================
bxp1 <- ggplot(df, aes( x = time, y = periphyton_growth, color = snails))+ #color= fator1 ao inves de fill tbm fica bacana
  geom_boxplot()+
  xlab("Time")+
  ylab("periphyton growth")+
  labs(color = "Snails")+
  theme(axis.text.x=element_text(angle = 0),
        panel.background = element_rect(fill = "white", colour = "white"),
        panel.border = element_rect(linetype = "solid", fill = NA))

bxp2 <- ggplot(df, aes( x = time, y = periphyton_growth, color = nutrient))+ #color= fator1 ao inves de fill tbm fica bacana
  geom_boxplot()+
  xlab("Time")+
  ylab("periphyton growth")+
  labs(color = "Nutrient")+
  theme(axis.text.x=element_text(angle = 0),
        panel.background = element_rect(fill = "white", colour = "white"),
        panel.border = element_rect(linetype = "solid", fill = NA))

grid.arrange(bxp1,bxp2, nrow=2)


df$all_trats = as.factor(paste(df$snails, df$nutrient, sep = ""))
df$all_trats
#ordenar NIVEIS
df$all_trats <- factor(df$all_trats, levels = c("Hwithout", "Owithout" ,"Hwith","Owith")) 
ggplot(df, aes( x = time, y = periphyton_growth, fill = all_trats))+ #color= fator1 ao inves de fill tbm fica bacana
  geom_boxplot()+
  xlab("Time")+
  ylab("periphyton growth")+
  labs(fill = "Treatements")+
  theme(axis.text.x=element_text(angle = 0),
        panel.background = element_rect(fill = "white", colour = "white"),
        panel.border = element_rect(linetype = "solid", fill = NA))

# ============================== REPEATED MEASURES ANOVA - METHOD 1 ====================================
# rm using linear model
lm_model <- aov(periphyton_growth ~ snails*nutrient*time + Error(id/time), data = df)
summary(lm_model)


# Extracting residuals to test normality of residuals
id_model <- lm_model$"id"
id_time_model <- lm_model$"id:time"
# residuals
id_residuals <- residuals(id_model)
id_time_residuals <- residuals(id_time_model)
# shapiro.test on residuals
shapiro.test(id_residuals)
shapiro.test(id_time_residuals) #not normal, maybe a log(y) helps
# We were unable to test sphericity, but from the residuals we know whether or not it meets the assumption of non-sphericity
  # ============================== REPEATED MEASURES ANOVA - METHOD 2 ====================================
#using mixed effects
library(lmerTest)
#time needs be continuous in this case, unless the model will have more factors than observations
df$time2 = as.numeric(df$time)
lmm <- lmer(periphyton_growth ~ snails*nutrient*time2 + (1|id),data = df) #random effects (1|var)
summary(lmm)
anova(lmm)
#residuals and normality of residuals
resid_lmer <- residuals(lme_model)
shapiro.test(resid_lmer) #not normal, maybe a log(y) helps
is_norm <- check_normality(lmm)
is_norm
plot(is_norm, type = "qq", detrend = TRUE)
# We were unable to test sphericity, but from the residuals we know whether or not it meets the assumption of non-sphericity

library(reghelper)
simple_slopes(lmm)
graph_model(lmm, y=periphyton_growth, x = snails, lines=nutrient)#overall effects
# ============================== REPEATED MEASURES ANOVA - METHOD 3 =====================================
library(ez) #USING ez package
#This model tests sphericity, but not normality of residuals

df$periLog= log(df$periphyton_growth)

ez_model <- ezANOVA(
  data = df,
  dv = .(periphyton_growth),    # dependent variable
  wid = .(id),      # subject id
  between = .(snails, nutrient), #predictors (between effect)
  within = .(time),  # (within-effect: time)
  type = 3,         
  detailed = TRUE)   # Include spherecity test
print(ez_model)

# ============================== REPEATED MEASURES ANOVA - METHOD 4 =====================================
library(afex)#
#This model  tests sphericity and normality of residuals
model <- aov_ez(
  id = "id", 
  dv = "periphyton_growth", 
  within = c("time"),
  #transformation = "log", #additional argument to transform data
  between = c("snails", "nutrient"), 
  data = df,
  detailed = TRUE
)
summary(model)
is_norm <- check_normality(model);is_norm
plot(is_norm, type = "qq", detrend = TRUE)

# ============================== REPEATED MEASURES ANOVA - METHOD 5 (other distributions) =====================================
# Ajustando o modelo GLMM com distribuição Poisson
library(lme4)
gamma_model <- glmer(periphyton_growth ~ snails * nutrient * time2 + (1|id), 
                       data = df, family = Gamma(link = "log"))
summary(gamma_model)
#family = poisson #count data
#family = Gamma(link = "log")
#family = binomial #discrete 0 1 data
gaussian_model <- lmer(periphyton_growth ~ snails * nutrient * time2 + (1|id), 
                     data = df)
anova(gamma_model, gaussian_model)
