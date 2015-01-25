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
AnnEmiss_Baltimore_type$type<-factor(AnnEmiss_Baltimore_type$type, levels(AnnEmiss_Baltimore_type$type)[c(2, 4, 1, 3)])


##Plot annual total emissions per type (point, nonpoint, onroad, nonroad) from Baltimore, MD for 1999, 2002, 2005, 2008
png("Plot3.png", width = 700)
m<-ggplot(AnnEmiss_Baltimore_type, aes(x = year, y = (TotEmiss/1e3), fill = type))
m<-m+geom_bar(stat = "identity", position = "dodge")
m<- m + theme(text = element_text(size = 20), plot.title = element_text(size = rel(1.25)), 
              legend.title = element_blank(), axis.title.y = element_text(vjust =1))
m<-m + labs(title = "Annual emissions (PM2.5) by type \n in Baltimore City, MD in the period 1999-2008")
m<-m + ylab("Emissions (PM2.5)  \n / tons (000s)")
m<-m + xlab("Year")
m
dev.off()