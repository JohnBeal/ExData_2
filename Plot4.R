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

##Subset SCC codes corresponding to coal combustion (1. Containing terms "Coal" or "Lignite" (a type of coal) AND 
## 2. Containing the abbreviation "Comb(ustion)", "Marine" (coal-burning vessels),"Coal-fired" or "In-Process" 
## (industrial processes which burn coal))
SCC_coal<-SCC[grep(pattern = "Coal|Lignite", SCC$Short.Name),] 
SCC_coalcomb<-SCC_coal[grep(pattern = "Comb|Marine|Coal-[a-zA-Z\\s]*fired|In-Process", SCC_coal$Short.Name),]


##Subset NEI entries with corresponding SCC codes, group by year and summarise by annual emissions
NEI_coal<-NEI[which(NEI$SCC %in% SCC_coalcomb$SCC),]
NEI_coal_year<-group_by(NEI_coal, year)
AnnEmiss_coal<-summarise(NEI_coal_year, TotEmiss = sum(Emissions))


##Plot annual emissions related to coal combustion in the USA for 1999, 2002, 2005, and 2008.
png("Plot4.png", width = 700)
m<-ggplot(AnnEmiss_coal, aes(x = year, weight = (TotEmiss/1e3)))
m<-m + geom_bar(width = 0.5, colour = "blue", fill = "blue")
m<-m + scale_y_continuous(limits = c(0, 600))
m<-m + theme(text = element_text(size = 20),  
             axis.title.y = element_text(vjust = 1.25))
m<-m + labs(title = "Annual emissions (PM2.5) from combustion of coal \n in the United States in the period 1999-2008")
m<-m + ylab("Emissions (PM2.5) from coal combustion \n / tons (000s)")
m<-m + xlab("Year")
m
dev.off()