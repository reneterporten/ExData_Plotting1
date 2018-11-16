# Plot 4

# Load relevant packages
library(dplyr)
library(tidyr)
library(lubridate)

# Set working directory and define datapath to the houshold power consumption data
setwd("/YOURPATH/Exploratory Data Analysis/")
dataPath <- "/YOURPATH/Exploratory Data Analysis/household_power_consumption.txt"

# Read in data and converge into dplyr data frame. Also combine date and time into one column
allData <- read.table(dataPath, stringsAsFactors = FALSE, header = TRUE, sep = ";") %>%
        tbl_df() %>%
        unite(col = DateTime, Date, Time, sep = " ")  %>%
        mutate(DateTime = parse_date_time(DateTime, order = "dmy HMS"))

# Filter the data based on the dates between 02/02 & 03/02/2007
# I had to shift the time selection to 1 hour more to the past and future to select the good
# date and time range between 2007-02-01 and 2007-02-02. This might be due to the specific timezone
# I am operating in.
myData <- filter(allData, DateTime >= "2007-02-01 01:00:00" & DateTime <= "2007-02-03 01:00:00")
rm(allData)

# Mutate the char type data into numeric
myData <- mutate(myData, Global_active_power = as.numeric(Global_active_power)) %>%
        mutate(Global_reactive_power = as.numeric(Global_reactive_power)) %>%
        mutate(Voltage = as.numeric(Voltage)) %>%
        mutate(Sub_metering_1 = as.numeric(Sub_metering_1)) %>%
        mutate(Sub_metering_2 = as.numeric(Sub_metering_2)) %>%
        mutate(Sub_metering_3 = as.numeric(Sub_metering_3))

# Plot 4 - Combined plot with four different displays
png(filename = "plot4.png", width = 480, height = 480)
par(mfrow = c(2, 2), mar = c(6, 6, 0.5, 0.5), oma = c(2, 2, 1, 1))

with(myData, plot(DateTime, Global_active_power,
                  type = "l",
                  ylab = "Global Active Power",
                  xlab = ""))

with(myData, plot(DateTime, Voltage,
                  type = "l",
                  ylab = "Voltage",
                  xlab = "datetime"))

with(myData, plot(DateTime, Sub_metering_1,
                  type = "l", 
                  col = "black",
                  xlab = "",
                  ylab = "Energy sub metering"))
lines(myData$DateTime, myData$Sub_metering_2, col = "red")
lines(myData$DateTime, myData$Sub_metering_3, col = "blue")
legend("topright", 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col = c("black", "red", "blue"), 
       lty =1,
       bty = "n")

with(myData, plot(DateTime, Global_reactive_power,
                  type = "l",
                  xlab = "datetime"))
dev.off()