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

##Subset NEI for Baltimore City, MD (fips = 24510), group by year and summarise by total annual emissions 
NEI_Baltimore<-NEI[NEI$fips == 24510,]
NEI_Baltimore_year<-group_by(NEI_Baltimore, year)
AnnEmiss_Baltimore<-as.data.frame(summarise(NEI_Baltimore_year, sum(Emissions)))

##Plot total annual emissions from Baltimore, MD vs. year for 1999, 2002, 2005, 2008; and output to png file
png("Plot2.png")
par(mar = c(5.1, 6, 4.1, 2.1))
barplot((AnnEmiss_Baltimore[,2]/1e3), names.arg = c("1999", "2002", "2005", "2008"), 
        main = "Total annual emissions (PM2.5) in Baltimore City, MD \n in the period 1999-2008", xlab = "Year",
        ylab = "Total annual emissions (PM2.5) \n / tons (000s)", 
        axis.lty = 1, ylim = c(0,10), col = "blue")  ##Convert scale to tons (000,000s)
dev.off()