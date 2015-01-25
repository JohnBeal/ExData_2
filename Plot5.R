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

## Subset NEI to "Onroad" type only: "Onroad" includes all motor vehicles used on public roadways. 
## Note: The "Nonroad" type includes motor vehicles used elsewhere than public roadways, but as 
## the "Nonroad, Off-Highway vehicle" class also includes non-vehicle sources such as portable equipment, 
## which can not be distinguished in a programatic manner, this analysis will be limited to "Onroad" type only.
NEI_onroad<-NEI[NEI$type == "ON-ROAD",]
NEI_onroad_year<-group_by(NEI_onroad, year)
AnnEmiss_onroad<-summarise(NEI_onroad_year, TotEmiss = sum(Emissions))

##Plot annual emissions from motor vehicles ("Onroad") in the USA for 1999, 2002, 2005, and 2008.
png("Plot5.png", width = 700)
m<-ggplot(AnnEmiss_onroad, aes(x = year, weight = (TotEmiss/1e3)))
m<-m + geom_bar(width = 0.5, colour = "blue", fill = "blue")
m<-m + scale_y_continuous(limits = c(0, 200))
m<-m + theme(text = element_text(size = 20))
m<-m + labs(title = "Annual emissions (PM2.5) from motor vehicles \n in the United States in the period 1999-2008")
m<-m + ylab("Emissions (PM2.5) from motor vehicles \n / tons (000s)")
m<-m + xlab("Year")
m
dev.off()