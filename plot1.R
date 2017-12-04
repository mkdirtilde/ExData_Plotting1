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

png(file = "plot1.png", width = 480, height = 480)

hist(power.data$Global_active_power, col="red",  main="Global Active Power", xlab="Global Active Power (kilowatts)")

dev.off()