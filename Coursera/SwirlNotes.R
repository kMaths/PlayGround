#Notes on swirl's Getting and Cleaning Data

library(swirl)
#see variable in workspace
ls()
#clear workspace
rm(list=ls())
swirl()
#call me kMaths
#... means to press enter when I am done reading
#press Esc to exit Swirl
#type bye() to exit and save

#skip() allows you to skip the current question
#play() lets you play with R, and swirl will ignore you
#nxt() will get swirl's attention again when you play()
#main() for swirl's main menue
#info() in case I lose this or something

# 1: R Programming: The basics of programming in R
# 2: Regression Models: The basics of regression modeling in R
# 3: Statistical Inference: The basics of statistical inference in R
# 4: Exploratory Data Analysis: The basics of exploring data in R
# 5: Don't install anything for me. I'll do it myself.
#https://github.com/swirldev/swirl_courses



#Manipultating Data with dplyr

#tabular = presented in a table
#ftp = file transfer protocol
library(dplyr)
mydf <- read.csv(path2csv, stringsAsFactors = FALSE)
dim(mydf)
head(mydf)
packageVersion("dplyr")

#load data into 'data frame tbl' or 'tbl_df'
cran <- tbl_df(mydf)

#remove original data frame from workspace to avoid confusion
rm('mydf')

#printing is the advantage
cran
#More informative and compact
#class and dimension are shown
#automatically shows the first 10 rows and only columns that fit

#five verbs that cover fundamentals of data manipulation
#select(), filter(), arrange(), mutate(), and summarize()

?select
#select subsets columns
select(cran, ip_id, package, country)
#note, we didn't have to say ip_id$cran. dplyr is smart like that

5:20
#we can use this notation in the select function
select(cran, r_arch:country)
select(cran, country:r_arch)
select(cran, -time)
-5:20
-(5:20)
select(cran, -(X:size))

play()
?filter()
nxt()
filter(cran, package == "swirl")
filter(cran, r_version == "3.1.1", country == "US")
?Comparison
filter(cran, country == "IN", r_version <= "3.0.2")
#| for or
filter(cran, country == "US" | country == "IN")
filter(cran, size > 100500, r_os == "linux-gnu")
filter(cran, !is.na(r_version))

#arange selected clumns in any order using arrange()
cran2 <- select(cran, size:ip_id)
arrange(cran2, ip_id)
arrange(cran2, desc(ip_id))
arrange(cran2, package, ip_id)
arrange(cran2, country, desc(r_version), ip_id)

#mutate()
cran3 <- select(cran, ip_id, package, size)
cran3
mutate(cran3, size_mb = size / 2^20)
mutate(cran3, size_mb = size / 2^20, size_gb = size_mb / 2^10)
mutate(cran3, correct_size = size + 1000)

#summarize()
summarize(cran, avg_bytes = mean(size))



#Grouping and Chaining with dplyr
2
#use group_by() to break up dataset into groups of rows 
#based on values of one or more variables 

library(dplyr)
cran <- tbl_df(mydf)
rm("mydf")
cran
?group_by
by_package <- group_by(cran, package)
by_package
#actions made on grouped data sets will take place on groups
summarize(by_package, mean(size))
?n
?n_distinct
submit()
pack_sum
quantile(pack_sum$count, probs = 0.99)
top_counts <- filter(pack_sum, count >679)
top_counts
#View() will allow us to see all of the data
View(top_counts)
top_counts_sorted <- arrange(top_counts,desc(count))
View(top_counts_sorted)
quantile(pack_sum$unique, probs= 0.99)
top_unique <- filter(pack_sum, unique > 465)
View(top_unique)
top_unique_sorted <- arrange(top_unique, desc(unique))
View(top_unique_sorted)
#chaining is also known as piping
submit()
#chaining allows us to read from left to right instead of right to left. Psh,
#all these non-math people are so easily confused
View(result3)
#We don't have to specify what table to use when chaining




#Tidying Data with tidyr
library(tidyr)
#each variable forms a column
#each observation forms a row
#one table per observational unit


#Column headers are values, not variables names
students
?gather
#gather() is melting, we minus out colvars)


#Multiple variables are stored in one column
#key is the name of the column we will create to put old column nmaes into
students2
#everything but grade with -grade
res <- gather(students2, sex_class, count, -grade)
res
gather(students, sex, count, -grade)
?separate
separate(data = res, col = sex_class, into = c("sex", "class"))
#if you don't specify, separate will separate on non alpha-numeric values.
submit()
#you can chain these commands


#Variables are stored in both rows and columns.
students3
submit()
?spread

students3 %>%
  gather(class, grade, class1:class5, na.rm = TRUE) %>%
  spread(test,grade) %>%
  mutate(class = extract_numeric(class)) %>%
  print

extract_numeric('class5')

#Multiple observation units are stored in the same table.
students4
submit()
passed
failed
passed <- mutate(passed, status = "passed")
failed <- mutate(failed, status = "failed")
bind_rows(passed, failed)

sat
submit()