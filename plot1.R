# Read RDS files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Total emissions in 1999, 2002, 2005, 2008
totalEmi = aggregate(Emissions ~ year, data=NEI, sum)

# plot
png("plot1.png", width=480, height=480, units="px")

plot(totalEmi$year, totalEmi$Emissions, type="l",
     xlab="Year",
     ylab=expression(PM[2.5]~Emissions~(`in`~tons)),
     main=expression(Total~PM[2.5]~Emissions~`in`~United~States))

dev.off()
