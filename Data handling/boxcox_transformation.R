# ==============================================================================
# title: BoxCox and Transformations
# author: Maria M. Cardoso
# date: 2024-08-27
# ==============================================================================  



#Sometimes the raw data do not meet the assumptions of data normality, that is, .
#the sample set of the variable does not have a Gaussian distribution.
#And, in some cases, a simple transformation makes the data meet the 
#assumption of normality, which is necessary for many statistical tests. 
#However, be careful, often the data has an identity, and transforming it 
# can remove its essence, as is the case with binary and multinomial data 
#(See more here on [distributions](distributions.html)).
#Here we will see:
    #  1) How do I know if I need a transformation?
    #  2) How do I know which transformation to use?
    #  3) How to Transform data?


## Opening the libraries we will use:
library(MASS)# to apply boxcox

## Open data
df= read.csv("https://raw.githubusercontent.com/mariaeco/StatistitcalMethodsR/main/datasets/boxcox_data_stage_biomass.csv", header = TRUE,  sep=",")
attach(df, warn.conflicts = FALSE)#to save column names #warn.conflicts do not show warnings
print("See the first samples of the data:")
head(df)

# =====================================================================================================================
## 1) How do I know if I need a transformation?
# =====================================================================================================================

#First, look at the histogram of the desired variables and 
#see that the first one has a bell shape, which may have a Gaussian distribution, 
#but the second variable has a distribution skewed to the left, 
#which may resemble a Gamma distribution and may possibly fail the normality tests.
#Let's then apply the normality tests to the variables.

par(mfrow = c(1,2)) #create a figure with 2 plots based on the line, I have 1 row and 2 columns of figure
par(pin = c(2,2))#histogram sizes
hist(adultBiomass, col='#f8766d') #simple histograms
hist(larvaeBiomass, col='#00bfc4')

#Applying the normality tests to both variables, we can observe that the first follows a Gaussian distribution (p>0.05) but the second does not (p<0.05), as already indicated by the observation in the histogram.

shapiro.test(adultBiomass)
shapiro.test(larvaeBiomass)


# =====================================================================================================================
## 2) How do I know which transformation to use?
# =====================================================================================================================

#Since the lavaeBiomass variable does not have a normal distribution, 
#we will apply the BoxCox test to see which transformation applies best.
#The result is the lambda value, and according to the optimal lambda value 
#we will know which transformation is best. See below the lambda value and the
#suggested transformations for each lambda value: 
# https://github.com/mariaeco/StatistitcalMethodsR/blob/main/sources/transformations.jpg


par(pin = c(3,3))#plot size
lambda = boxcox(larvaeBiomass~1) #boxcox result saved in a variable called lambda
ci_optimum = lambda$x[which.max(lambda$y)]#finding lambda optimum 
ci_lambda = range(lambda$x[lambda$y > max(lambda$y)-qchisq(0.95,1)/2])#finding confidence interval
cat("Lambda optimum", ci_optimum, "\nLambda CI:", ci_lambda)#printing results

#Note that the lambda result tells us in the vertical dashed lines the optimum 
#(middle line) and the confidence interval (right and left lines). 
#Our optimum is around 0.26, and the interval is between 0.02 and 0.54. 
#According to  figure 1, with lambda around zero we can apply the log transformation, 
#but with lambda around 0.5 we apply the square root. Which one do we use if our
#lambda is right in the middle 0.26? In this case, since 0.26 is closer to 0.5 
#than 0, we can apply the square root. However, if you apply the log, you will 
#see that in this case, your data will also have a normal distribution. 
#So you can use one or the other without any harm.


# =====================================================================================================================
## **3) Transforming**
# =====================================================================================================================

par(mfrow = c(1,2))
par(pin = c(2,2))#histogram sizes
hist(log(adultBiomass), col='#f8766d', main="Log transform")
hist(sqrt(larvaeBiomass), col='#00bfc4', main="Sqrt transform")

#Note that both transformations lead to a Gaussian distribution:

reslog <- shapiro.test(log(larvaeBiomass))
ressqrt <- shapiro.test(sqrt(larvaeBiomass))
cat("Logarithm: p-value =", reslog$p.value, "\n","Square Root: p-value =", ressqrt$p.value)



