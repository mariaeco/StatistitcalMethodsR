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



df = read.table("clipboard", header = T)
head(df)

#defining factors
df$peixe = as.factor(df$peixe)
df$nutriente = as.factor(df$nutriente)
df$tempo = as.factor(df$tempo)

#tendencia geral
dfstats<- df  %>%
  group_by(peixe,nutriente,tempo) %>%
  get_summary_stats(fito, type = "mean_sd")
dfstats

#normalidade
dfnorm <- df %>%
  group_by(peixe,nutriente) %>%
  shapiro_test(fito)
dfnorm
