# read RDS files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# extract Baltimore City (fips: 24510) and LA (fips: 06037) from NEI data
NEI_subset <- subset(NEI, fips=="24510" | fips=="06037")

# extract the NEI which are motor vehicle sources
motorVehicle <- subset(SCC, grepl("- On-Road ", as.character(EI.Sector)))
sccs <- motorVehicle$SCC
motorNEI <- subset(NEI_subset, SCC %in% sccs)

# Grouping the data by year, fips and taking the sum of emissioins in each combination
aggData <- aggregate(motorNEI$Emissions, by=list(year = motorNEI$year, fips = motorNEI$fips), FUN=sum)

# replacing the values in the fips column with the corresponding city names
aggData[aggData$fips %in% "24510", 2] <- "Baltimore"
aggData[aggData$fips %in% "06037", 2] <- "California"
colnames(aggData)[3] <- "Emissions"

# Which city has seen greater changes over time in motor vehicle emissions?
# Strategy: calculate the absolute change in each period a) 1999 - 2002; b) 2002 - 2005; c) 2005 - 2009

# create a new data diffEmi
diffEmi = aggData
diffEmi['diff'] = 0 #form a new column

#calculate the absolute change / diff in each period
diffEmi$diff[2:4] = abs(diff(aggData$Emissions[1:4]))
diffEmi$diff[6:8] = abs(diff(aggData$Emissions[5:8]))

#remove irrevlant row and columns
diffEmi <- diffEmi[-c(1, 5),] #row
diffEmi <- diffEmi[, -c(1, 3)] #col
rownames(diffEmi) <- NULL

#add the period column
diffEmi['period'] = rep(c("1999-2002", "2002-2005", "2005-2008"), 2)

#graph
library(ggplot2)
png(filename = "plot6.png", width=720, height=480, units="px")

ggplot(diffEmi, aes(x=period, y=diff, fill=fips)) +
        geom_bar(stat="identity", position="dodge")+
        xlab("Period") +
        ylab(expression(Absolute~Change~of~PM[2.5]~Emissions~(`in`~tons)))+
        ggtitle(expression(Absolute~Change~of~PM[2.5]~ Emission))+
        scale_x_discrete(labels=diffEmi$period)+
        scale_fill_discrete(name="City") + geom_text(aes(label=round(diffEmi$diff, 2), stat="identity", vjust = -0.5), position = position_dodge(width=1))

dev.off()

