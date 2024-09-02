# ==============================================================================
# title: T test for independent samples
# author: Maria M. Cardoso
# date: 2024-08-17
# ==============================================================================  

# 
#   T-test  compare means between two independent groups.
#   
#   Both groups must have Gaussian distribution (normal distribution) and homogeneous variance.
#   However, for large samples, the most important thing is homogeneous variance between groups.
#   Below we will perform the pipeline for performing the t-test:
#       1) test both sample distribution (histogram and normality tests)
#       2) test the homogeneity of variance between groups
#       3) If everything is ok: apply t-test
# 
# 

## Install and open libraries:
#install.packages('ggplot2')
library(ggplot2)

## Open data
df= read.csv("https://raw.githubusercontent.com/mariaeco/StatistitcalMethodsR/main/datasets/ttest_data_tilapia_predator.csv", header = TRUE,  sep=",")
attach(df, warn.conflicts = FALSE)#to save column names #warn.conflicts do not show warnings
print("See the first samples of the data:")
head(df)


# ==============================================================================  
## 1) Test both sample distribution (histogram and normality tests)
# ==============================================================================  
#We have a dataset with three variable: id (identification), predator = presence or absence of predator fish, and  tilapia_size.
#Let's first plot the histogram to have an ideal of the distribution. We need plot for both groups:

ggplot(df, aes(x=tilapia_size, fill=predator)) + 
    facet_wrap(~predator)+
    geom_histogram(colour="black", position="identity", bins = 8, alpha=0.8)+
    scale_fill_manual(values=c('#f8766d', '#00bfc4'))+
theme_classic()


#We can see the histograms on the same plot and check the overlap. If we look at the histogram this way, we see some overlap between the two groups, but tilapia size in the presence of predator seems a bit larger. We gonna test if the sizes are different using the t-test.
ggplot(df, aes(x=tilapia_size, fill=predator)) +
  geom_histogram(position="identity", bins = 8, alpha=0.8)+
  theme_classic()


#Applying normality test
#We can do this using the Shapiro-Wilks test, which is suitable for samples 
# smaller than 30. For larger samples you can use Kolmogorov-Smirnov test.

shapiro.test(tilapia_size[predator=='absence'])
shapiro.test(tilapia_size[predator=='presence'])
#We can observe that both have normal distribution (p-value > 0.05). So, we can proceed.

# ==============================================================================  
## **2) Test homogeneity**
# ==============================================================================  

#We gonna use the Bartlett test. if p-value >0.05 the variance of our groups are the same and we can apply t-test.

bartlett.test(tilapia_size~predator)
#Variance is ok (p>0.05)! We can apply t-test bellow:

# ==============================================================================  
## **3) Applying t-test**
# ==============================================================================  

t.test(tilapia_size~predator , data = df)

# The size of the tilapia differs significantly (p<0.05) between the site 
# with and without predators. The average size with predators was 14.23 cm and without predators was 9.70 cm.
# And the group without predators was on average 6.2 cm smaller than the group with predators.
#Let's see in a boxplot
ggplot(df ,aes(x=predator, y=tilapia_size, fill=predator)) + 
  geom_boxplot(width=0.5,lwd=1)+
  labs(subtitle="Tilapia size", x="Predator", y="Tilapia size") +
  scale_fill_discrete(name = "Predator", labels = c("Absence","Presence"))+
  scale_x_discrete(labels=c("Absence","Presence"))+
  theme_classic()

