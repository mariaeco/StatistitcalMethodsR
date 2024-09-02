# ==============================================================================
# title: Open Files in R
# author: Maria M. Cardoso
# date: 2024-08-29
# ==============================================================================  
    
    
# In this section, we'll explore various methods for opening data files in R, ranging from simple copy-and-paste techniques to importing files directly from the web. You can work with a variety of file formats, including .txt, .csv, .xlsx, and others.
# for detailed information see: [www.easystat.com]
#We'll cover the following methods:
    # 1) Open using clipboard
    # 2) Open using file.choose()
    # 3) Open with read.table()
    # 4) Open with read_excel()
    # 5) Open with read.csv()

# =====================================================================================================================
## 1) Open using clipboard 
# =====================================================================================================================

#In this option, open your data file (.xlxs, .csv, .txt, etc.) in an application of your choice,
# select it in its entirety, and copy it (ctr+c).
#After that, return to your R code and just run the function:

df = read.table("clipboard", header = TRUE,  sep="\t", na.strings= " ")

#what these arguments tell us:
#  header = True: save the first line as your variable names (column names)
#  sep = "\t": The separation between columns, for this method, is tab.
#  na.strings = " ": In this case, the cells with missing data are empty, so we use " "
#  If instead of empty there is NA, or NaN, or nan, or any other, you must put the correct acronym.
#  Example: na.strings = "NA"


# =====================================================================================================================
## 2) Open using file.choose() 
# =====================================================================================================================

#This is the easiest way, it will open a window for you to browse the file on your device.

df = read.table(file.choose(), header = TRUE, sep="\t", na.strings = " ") 


# =====================================================================================================================
## 3) Open with read.table() 
# =====================================================================================================================

# You'll need to specify the file path, which can be done in three ways:
#  a) Inserting the file  path in the reading function, example:

df = read.table("C:/Users/username/myproject/data.txt" , header = TRUE,
                sep="\t", na.strings = " ")#this is an example of path - change for your file path


#  b) If you're working with multiple files, it's often more convenient to set the working directory first using the setwd() function. By setting your project's working directory, any files you open or save will automatically be directed to this location, and after you can just write the file name in the reading function:

setwd("C:/Users/username/myproject")#this is an example of path - change for your file path
df = read.table("data.txt", header = TRUE, sep="\t", na.strings = " ")

#  c) Alternatively, you can set the working directory using the RStudio interface:
#Session -> Set Working Directory -> Choose Directory

df = read.table("data.txt", header = TRUE, sep="\t", na.strings = " ")

#  d) Open from web:

df = read.table("https://raw.githubusercontent.com/mariaeco/StatistitcalMethodsR/main/datasets/music_dataset.txt", 
                header = TRUE, sep="\t", na.strings = " ")


# =====================================================================================================================
## 4) Open with read_excel() 
# =====================================================================================================================

#The function read_excel() does not open Excel files directly from the internet.
#Remember to set file directory first.
#If the file have more than 1 sheet, you need set the sheet number.

library("readxl")#remember to install package first: install.packages("readxl")

setwd("C:/Users/username/myproject")#this is an example of path - change for your file path
df = read_excel("music_dataset.xlsx", col_names = TRUE, na = "", sheet = 1)


# =====================================================================================================================
##  5) Open with read.csv() 
# =====================================================================================================================

#For the read_csv() function you can open it from the working directory and also 
#from the web like the read.table() function

df= read.csv("https://raw.githubusercontent.com/mariaeco/StatistitcalMethodsR/main/datasets/music_dataset.csv", 
             header = TRUE, sep=",", na.strings = " ") 


