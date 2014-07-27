# Read RDS files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Extract Baltimore City(fips = 24510) emissions
Baltimore <- subset(NEI, fips=="24510")

# Total emissions in the Baltimore City in 1999, 2002, 2005, 2005
totalEmi_Baltimore = aggregate(Emissions ~ year, data=Baltimore, sum)


png("plot2.png", width=480, height=480, units="px")

plot(totalEmi_Baltimore$year, totalEmi_Baltimore$Emissions, type="l",
     xlab="Year",
     ylab=expression(PM[2.5]~Emissions~(`in`~tons)),
     main=expression(Total~PM[2.5]~Emissions~`in`~Baltimore~City~`,`~Maryland))

dev.off()


