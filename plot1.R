# Plot 1

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

# Plot 1 - Histogram of Global Active Power in kilowatts
png(filename = "plot1.png", width = 480, height = 480)
with(myData, hist(Global_active_power, 
                  col = "red", 
                  main = "Global Active Power", 
                  xlab = "Global Active Power (kilowatts)"))
dev.off()