# Read RDS files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Extract Baltimore City(fips = 24510) emissions
Baltimore <- subset(NEI, fips=="24510")

# To look for motor vehicle sources, we extract the SCC number which
# EI.Sector column with value "- On-Road "
motorVehicle <- subset(SCC, grepl("- On-Road ", as.character(EI.Sector)))
sccs<-motorVehicle$SCC

# extract the NEI which are motor vehicle sources
motorNEI<-subset(Baltimore, SCC %in% sccs)
aggData<-aggregate(motorNEI$Emissions, by=list(year = motorNEI$year), FUN=sum)
colnames(aggData)[2] <- "emissions"

#graph
png(filename="plot5.png", width=720, height=480, units="px")

library(ggplot2)

ggplot(aggData, aes(x=factor(year), y=emissions)) +
        geom_bar(stat="identity",  fill="#E69346", width=.3) +
        xlab("Period") +
        ylab(expression(PM[2.5]~Emissions~(`in`~tons)))+
        ggtitle(expression(Total~PM[2.5]~Emissions~from~Motor~Vehicle~Sources~In~Baltimore~City))

dev.off()

