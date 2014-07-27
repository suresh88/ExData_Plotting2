# Read RDS files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# To look for coal combustion-related sources, we extract the SCC number which
# SCC.Level.Three columns with value "coal" or "lignite"
coalIdx = which(grepl("coal", SCC$SCC.Level.Three, ignore.case=TRUE) |
                grepl("lignite", SCC$SCC.Level.Three, ignore.case=TRUE))

# extract coal related SCC number
coalSCC = SCC[coalIdx, 1]

# extract NEI which are coal related
coalNEI = subset(NEI, SCC %in% coalSCC)

# total emissions in 1999, 2002, 2005, 2008
coalTotalEmi = aggregate(Emissions ~ year, data=coalNEI, sum)

# graph
library(ggplot2)
png(filename="plot4.png", width=720, height=480, units="px")

ggplot(coalTotalEmi, aes(x=factor(year), y=Emissions)) +
        geom_bar(stat="identity",  fill="#E69346", width=.3) +
        xlab("Year") +
        ylab(expression(PM[2.5]~Emissions~(`in`~tons)))+
        ggtitle(expression(Absolute~Change~of~PM[2.5]~ Emission)) + ylim(0, 610000)

dev.off()