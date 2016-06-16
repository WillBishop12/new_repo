reddit = read.csv("reddit.csv")
str(reddit)

#Check how many people are in each employment status
table(reddit$employment.status)
summary(reddit)

#Find values of "age range"
levels(reddit$age.range)

#Plot how many in each age bin
install.packages("ggplot2")
library(ggplot2)
qplot(data=reddit, x=age.range)

#"under 18" category is at end due to alpha order
#we want a categorical variable (factor) with ordered levels - an ordered factor
reddit$age.range = ordered(reddit$age.range, levels = c("Under 18", "18-24", "25-34", "35-44", "45-54", "55-64", "65 or Above"))
qplot(data=reddit, x=age.range)
