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
png("Plot4.png")

dev.off()