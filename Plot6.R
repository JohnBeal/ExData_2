##Attach necessary packages
library(dplyr); library(ggplot2); library(grid)

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
AnnEmiss_onroad_subset$fips<-gsub(06037, "Los Angeles County", AnnEmiss_onroad_subset$fips)
AnnEmiss_onroad_subset$fips<-gsub(24510, "Baltimore City", AnnEmiss_onroad_subset$fips)


##Plot annual emissions from motor vehicles in Baltimore, MD & LA county, CA for 1999, 2002, 2005, and 2008
png("Plot6.png", width = 700)
m<- ggplot(AnnEmiss_onroad_subset, aes(x = year, y = (TotEmiss/1e3), fill = fips))
m<- m + geom_bar(stat = "identity", position = "dodge")
m<- m + theme(text = element_text(size = 20), plot.title = element_text(size = rel(1.25)), 
             legend.title = element_blank(), axis.title.y = element_text(vjust =1))
m<-m + labs(title = "Annual emissions (PM2.5) from motor vehicles \n in the period 1999-2008")
m<-m + ylab("Emissions (PM2.5) from motor vehicles \n / tons (000s)")
m<-m + xlab("Year")
m
dev.off()