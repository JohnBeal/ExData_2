##Attach necessary packages
library(dplyr)

##Download and extract National Emissions Inventory (NEI) data file
URL<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(URL, basename(URL), mode = "wb")
dateDownloaded<-date()
unzip(basename(URL))

##Read NEI and Source Classification Code (SCC) data
NEI<-readRDS("summarySCC_PM25.rds")
NEI<-transform(NEI, fips = as.factor(fips), SCC = as.factor(SCC), Pollutant = as.factor(Pollutant),
               type = as.factor(type), year = as.factor(year))
SCC<-readRDS("Source_Classification_Code.rds")

##Group NEI data by year and summarise by total emissions for each year
NEI_year<-group_by(NEI, year)
AnnEmiss<-as.data.frame(summarise(NEI_year, sum(Emissions)))

##Plot total annual emissions  in the USA vs. year for 1999, 2002, 2005, 2008; and output to png file
png("Plot1.png")
par(mar = c(5.1, 6, 4.1, 2.1))
barplot((AnnEmiss[,2]/1e6), names.arg = c("1999", "2002", "2005", "2008"), 
        main = "Total annual emissions (PM2.5) in the United States in the period 1999-2008", xlab = "Year",
        ylab = "Total annual emissions (PM2.5) \n / tons (000,000s)", 
        axis.lty = 1, ylim = c(0,10))  ##Convert scale to tons (000,000s)
dev.off()