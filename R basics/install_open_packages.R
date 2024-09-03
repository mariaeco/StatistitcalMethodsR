# ==============================================================================
# title: Install and Open Packages
# author: Maria M. Cardoso
# date: 2024-09-02
# ==============================================================================  

# 1) Install Packages
#To install the packages, you can just type:

install.packages("ggplot2")

#Alternatively, you can use the menu by clicking on 
# Tools → Install Packages, and then type the package 
#name in the Packages field:

## 2) Open Packages

#To open the packages, you can use:
# 2.1) library("ggplot2")

library("ggplot2")

#or

# 2.2) require("ggplot2")
#Opens the package in the same way as the library function, 
#but it has a return value that can be used inside functions to 
#ensure that the package is available and the function will work. 
#Thus, require is most often used inside functions or scripts 
#where you want to try to load the package without interrupting 
#the execution of the code, especially in contexts where 
#failures can be handled conditionally.

require("ggplot2")

