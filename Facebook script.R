# Pseudo-Facebook Data
# Read in data
getwd()
list.files()
pf = read.csv("pseudo_facebook.tsv", sep='\t')
View(pf)

#Histogram of users' birthdays
names(pf) # look at all variable names

#Need to set bins=31 in order to get correct histogram, unlike in the video
qplot(data=pf, x=dob_day, bins=31) +
  scale_x_continuous(breaks = 1:31)

#Now do it with "facet wrap"
qplot(data=pf, x=dob_day, bins=31) +
  scale_x_continuous(breaks = 1:31) +
  facet_wrap(~dob_month, ncol=3)
#Note syntax: facet wrap contains a tilde and then the variable
#Similar to "by" in Stata or "hue" in Python
#Facet grid has vertical variables ~ horiz variables when you want to facet over >1

#Histogram of friend counts
qplot(data=pf, x=friend_count)
summary(pf$friend_count) #find max

#Histogram for people with fewer than 1,000 friends
qplot(data=pf, x=friend_count, xlim=c(0, 1000))

#Try with different bin width and x axis breaks every 50 units
qplot(data=pf, x=friend_count, binwidth=25) +
  scale_x_continuous(limits=c(0, 1000), breaks=seq(0, 1000, 50))

#Now check whether men or women have more friends
qplot(data=pf, x=friend_count, binwidth=25) +
  scale_x_continuous(limits=c(0, 1000), breaks=seq(0, 1000, 50)) +
  facet_wrap(~gender, ncol=1)

#Remove "NA" observations
qplot(data=subset(pf, !is.na(gender)), x=friend_count, binwidth=25) +
  scale_x_continuous(limits=c(0, 1000), breaks=seq(0, 1000, 50)) +
  facet_wrap(~gender, ncol=1)

#Statistics by gender
table(pf$gender)
by(pf$friend_count, pf$gender, summary)

#Histogram of tenure (how long someone has been on Facebook), and use color
qplot(data=pf, x=tenure, color=I("black"), fill=I("#099DD9"), binwidth=30)

#Tenure by years instead of days ; introduce x and y axis labels
qplot(data=pf, x=tenure / 365.2425, 
      xlab = "Number of years using Facebook",
      ylab = "Number of users in sample",
      color=I("black"), fill=I("#F79420"), binwidth=1/4)

#Histogram of ages
qplot(data=pf, x=age)
#Bunch of outliers around age 100 - probably fake or entered
#wrong year for age (e.g. 1902 instead of 2002)
qplot(data=pf, x=age, xlim=c(10, 90), binwidth=2,
      xlab = "Age in years", ylab = "Number of users in sample")

#Transforming data with long tails (common in Facebook data)
#Example: friend count
summary(pf$friend_count)
summary(log(pf$friend_count))
#get rid of zero values, which have -inf as log
summary(log(pf$friend_count + 1))
#Histogram of log of friend count
qplot(data=pf, x=log(friend_count + 1))
#Now much more like a normal distribution!

#3 histograms in one column: original friend count, log, and square root
#install.packages("gridExtra")
library(gridExtra)
p1 = qplot(data=pf, x=friend_count)
p2 = qplot(data=pf, x=log(friend_count + 1))
p3 = qplot(data=pf, x=sqrt(friend_count))
grid.arrange(p1, p2, p3, ncol=1) # doesn't work

#Alternate way to transform data
#Use ggplot instead of qplot
p1 = ggplot(aes(x=friend_count), data=pf) + geom_histogram()
p1
p2 = p1 + scale_x_log10()
grid.arrange(p1, p2, ncol=1)
#this one graphs the actual count on the x-axis instead of the log

#Can also add scale layer to qplots
qplot(data=pf, x=friend_count) + scale_x_log10()

#Frequency polygon
#Look at friend counts by gender again
qplot(data=subset(pf, !is.na(gender)), x=friend_count, y=..count../sum(..count..),
      geom='freqpoly', color=gender, binwidth=10) + 
  scale_x_continuous(lim=c(0, 1000))
#Note new y variable - this changes y axis to proportions instead of counts
#this shows more men at lower end of distribution - can't see higher end clearly
qplot(data=subset(pf, !is.na(gender)), x=friend_count, y=..count../sum(..count..),
      geom='freqpoly', color=gender, binwidth=10) + 
  scale_x_continuous(lim=c(250, 1000))
#I think this is wrong...it's still showing as a percentage of TOTAL users, not 
#a percentage of male or female users