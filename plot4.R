#packages
library(readr)
library(dplyr)
library(lubridate)
library(magrittr)
library(tidyr)

#Open the files
if(!file.exists("data")){
        dir.create("data")
}
url1 <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url1, destfile = "./data/df1.zip")
unzip(zipfile = "./data/df1.zip")

#confirm download date
dateDownloaded <- date()

# Memory requirements: 2075259*9*8/2^20 = 142 MB of RAM

#initialize table
my_data <- read.csv("./household_power_consumption.txt", stringsAsFactors = TRUE, header = TRUE, sep = ";",na.strings = "?")

# combine date and time
my_data <- unite(my_data, datetime, c(Date,Time), sep = " ")

#Change the date time format
my_data$datetime <- strptime(my_data$datetime, format = "%d/%m/%Y %H:%M:%S")

#limit data to Feb 1st and 2nd 2007
my_subset <- filter(my_data, datetime >="2007-02-01" & datetime <"2007-02-03")

#create plot
png("plot4.png")
par(mfcol = c(2,2))
plot(x = my_subset$datetime, y = my_subset$Global_active_power, type = "l",xlab = "", ylab = "Global Active Power (kilowatts)")
dates <- my_subset$datetime
Sub_1 <- my_subset$Sub_metering_1
Sub_2 <- my_subset$Sub_metering_2
Sub_3 <- my_subset$Sub_metering_3
plot(dates, Sub_1, type="n",xlab="",ylab="Energy sub metering")
points(dates,Sub_1,type = "l")
points(dates,Sub_2,type="l",col = "red")
points(dates,Sub_3,type="l",col = "blue")
legend("topright", pch = "---",col = c("black","red","blue"), legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
voltage <- my_subset$Voltage
plot(dates,voltage, type = "l", xlab = "datetime", ylab = "Voltage")
g_r_p <- my_subset$Global_reactive_power
plot(dates,g_r_p, type = "l", xlab = "datetime", ylab = "Global_reactive_power")
dev.off()
