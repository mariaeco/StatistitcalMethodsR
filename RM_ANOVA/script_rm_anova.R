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



df = read.table("data_peryphyton.txt", header = T)
head(df)

#defining factors
df$snails = as.factor(df$snails)
df$nutrient = as.factor(df$nutrient)
df$time = as.factor(df$time)

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


