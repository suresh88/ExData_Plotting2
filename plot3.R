# Read RDS files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Extract Baltimore City(fips = 24510) emissions
Baltimore <- subset(NEI, fips=="24510")

# Grouping the data by year, type and taking the sum of emissioins in each combination
aggData <- aggregate(Baltimore$Emissions, by=list(year = Baltimore$year, type = Baltimore$type), FUN=sum)
colnames(aggData)[3] <- "emissions"

library(ggplot2)
png(filename="plot3.png", width=720, height=480, units="px")

p <- ggplot(aggData, aes(x=year, y=emissions, group=type, color=type))
p <- p + geom_line() + geom_point() + xlab("Year") + ylab(expression(Total~PM[2.5]~Emissions~(`in`~tons)))
p <- p + scale_colour_discrete(name="Type", breaks=c("NON-ROAD", "NONPOINT", "ON-ROAD", "POINT"), labels=c("Non-road", "Non-point", "On-road", "Point"))
p <- p + ggtitle(expression(Total~PM[2.5]~Emission~`in`~Baltimore~City))
p

dev.off()

