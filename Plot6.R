##Attach necessary packages
library(dplyr); library(ggplot2)

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

##Subset NEI by "Onroad" type, and location (Baltimore City, MD; fips =  24510 and Los Angeles County, CA; fips = 06037)
## then group by year and summarise by annual emissions.
NEI_onroad<-NEI[NEI$type == "ON-ROAD",]
NEI_onroad_subset<-filter(NEI_onroad, fips %in% c("24510", "06037"))
NEI_onroad_subset<-group_by(NEI_onroad_subset, year, fips) 
AnnEmiss_onroad_subset<-summarise(NEI_onroad_subset, TotEmiss = sum(Emissions))


##Plot annual emissions from motor vehicles in Baltimore, MD & LA county, CA for 1999, 2002, 2005, and 2008
png("Plot6.png")
m<- ggplot(AnnEmiss_onroad_subset, aes(x = year, y = (TotEmiss/1e3)))
m<- m + geom_line(aes(group = fips))
dev.off()