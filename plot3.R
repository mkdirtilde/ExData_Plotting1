library(tidyverse)
library(data.table)

power.data.file <- "household_power_consumption.txt"

# Load and format columns as date/time
power.data      <- tibble::as.tibble(fread(power.data.file,  na.strings="?"))
power.data      <- power.data %>% mutate(Date=as.Date(Date,'%d/%m/%Y'))
power.data      <- power.data %>% mutate(Time=as.POSIXct(strptime(Time, "%H:%M:%S")))

# Only first 2 days of Feb needed
power.data      <- subset(power.data, Date >= as.Date('01/02/2007','%d/%m/%Y'))
power.data      <- subset(power.data, Date <= as.Date('02/02/2007','%d/%m/%Y'))

power.data      <- power.data %>% mutate(weekday=weekdays(Date))

x_vals          <- as.POSIXct(paste(power.data$Date, format(power.data$Time,'%H:%M:%S')))

png(file = "plot3.png", width = 480, height = 480)

plot(x_vals,
     power.data$Sub_metering_1,
     type = "l", 
     ylab = "Energy sub metering",
     xlab = "")

lines(x_vals, power.data$Sub_metering_2, col="red")
lines(x_vals, power.data$Sub_metering_3, col="blue")

legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col=c("black", "red", "blue"), lty=1)

dev.off()