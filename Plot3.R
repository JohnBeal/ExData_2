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

##Subset NEI for Baltimore City, MD (fips = 24510), group by type and year and summarise by annual emissions per type 
NEI_Baltimore<-NEI[NEI$fips == 24510,]
NEI_Baltimore_type<-group_by(NEI_Baltimore, year, type)
AnnEmiss_Baltimore_type<-as.data.frame(summarise(NEI_Baltimore_type, TotEmiss = sum(Emissions)))

##Plot annual total emissions per type (point, nonpoint, onroad, nonroad) from Baltimore, MD for 1999, 2002, 2005, 2008
png("Plot3.png")
m<-ggplot(AnnEmiss_Baltimore_type, aes(x = year, y = TotEmiss, group = type, col = type))
m<-m+geom_ribbon(aes(ymin=0, ymax=TotEmiss, fill = type, alpha = 0.75, position = "stack"))
m<-m+geom_area(aes(y = TotEmiss, fill = type))
dev.off()