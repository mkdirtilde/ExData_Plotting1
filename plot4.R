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

png(file = "plot4.png", width = 480, height = 480)

par(mfrow=c(2,2))

# Top Left - Datetime vs Global Active Power
plot(x_vals,
     power.data$Global_active_power,
     type = "l", 
     ylab = "Global Active Power",
     xlab = "")


# Top Right - Datetime vs Voltage
plot(x_vals,
     power.data$Voltage,
     type = "l",
     xlab = "datetime",
     ylab = "voltage")

# Bottom left - Datetime vs Energy sub metering
plot(x_vals,
     power.data$Sub_metering_1,
     type = "l", 
     ylab = "Energy sub metering",
     xlab = "")

lines(x_vals, power.data$Sub_metering_2, col="red")
lines(x_vals, power.data$Sub_metering_3, col="blue")

legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col=c("black", "red", "blue"), lty=1)

# Bottom Right - Datetime vs Energy reactive power
plot(x_vals,
     power.data$Global_reactive_power,
     type = "l",
     xlab = "datetime",
     ylab = "Global_reactive_power")

dev.off()