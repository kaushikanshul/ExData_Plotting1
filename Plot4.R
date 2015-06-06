# Reading the Datafile
FileName <- "./exdata-data-household_power_consumption/household_power_consumption.txt"

# reading the file - 3 methods (Select any one)
# Method 1: Reading the full file and then subset to selected range

###################
#Fulldata <- read.table(FileName, header=TRUE, sep=";", stringsAsFactors=FALSE)
#SelectData <- Fulldata[Fulldata$Date %in% c("1/2/2007","2/2/2007"),]
#SelectData[,3] <- as.numeric(SelectData[,3])
#SelectData[,4] <- as.numeric(SelectData[,4])
#SelectData[,5] <- as.numeric(SelectData[,5])
#SelectData[,6] <- as.numeric(SelectData[,6])
#SelectData[,7] <- as.numeric(SelectData[,7])
#SelectData[,8] <- as.numeric(SelectData[,8])
#SelectData[,9] <- as.numeric(SelectData[,9])
###################


# Method 2: Reading only the selected data within the required dates to make it faster
# But the start point in this method is hard coded after looking at the input file
# Seems to be the best method, but requires some pre-work and is less flexible
###################
SelectData <- read.table(FileName, header=FALSE, sep=";", stringsAsFactors=FALSE, skip = 66637, nrows=2880)
colnames(SelectData) <- c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
###################

# Method 3: Reading only the selected data within the required dates to make it faster
# This method looks for the required date and skips everything before it.
# this is much slower than method 2, almost as much time as method 1 but is more flexible
###################
#SelectData <- read.table(FileName, header=FALSE, sep=";", stringsAsFactors=FALSE, skip=grep("31/1/2007;23:59:00", readLines(FileName)), nrows=2880)
#colnames(SelectData) <- c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
###################


# Combine the date and time to create date-time
DateTime <- strptime(paste(SelectData$Date, SelectData$Time, sep=" "), "%d/%m/%Y %H:%M:%S") 



png("plot4.png", width=480, height=480)
par(mfrow = c(2, 2)) 

plot(DateTime, SelectData$Global_active_power, type="l", xlab="", ylab="Global Active Power", cex=0.2)

plot(DateTime, SelectData$Voltage, type="l", xlab="datetime", ylab="Voltage")

plot(DateTime, SelectData$Sub_metering_1, type="l", ylab="Energy sub metering", xlab="")
lines(DateTime, SelectData$Sub_metering_2, type="l", col="red")
lines(DateTime, SelectData$Sub_metering_3, type="l", col="blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=, lwd=2.5, col=c("black", "red", "blue"), bty="n")

plot(DateTime, SelectData$Global_reactive_power, type="l", xlab="datetime", ylab="Global_reactive_power")

dev.off()