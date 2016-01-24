# Load packages ================================================================
# Load all required packages installing any that are missing.
requiredPackages <- c("dplyr", "ggplot2")
missingPackages <- !is.element(requiredPackages, installed.packages()[,1])
missingPackages <- requiredPackages[missingPackages]
if (length(missingPackages) != 0) install.packages(missingPackages)
lapply(requiredPackages, library, character.only = TRUE)
rm(requiredPackages, missingPackages)

# Load data ====================================================================
# Time when copy of activity.zip in this fork was downloaded.
dateDownloaded <- "Sat Jan 23 22:13:46 2016"

# Download data if not present and update time when the copy was downloaded.
if (!file.exists("activity.zip") && !file.exists("activity.csv")) {
    
    url = paste("https://d396qusza40orc.cloudfront.net/",
                "repdata%2Fdata%2Factivity.zip", sep = "")
    
    # Determine download.file method based on OS.
    if (.Platform$OS.type == "unix") {
        osMethod = "libcurl"
    } else {
        osMethod = "wininet"
    }
    
    download.file(url, "activity.zip", method = osMethod)
    dateDownloaded <- date()
    rm(url, osMethod)
}

# If .csv data file is not present if not unzip activity.zip
if (!file.exists("activity.csv")) {
    unzip("activity.zip")
}

# Load .csv file as data frame table
activity <- tbl_df(read.csv("activity.csv"))

# What is mean total number of steps taken per day?

# Discard row with NAs, group by day, and calculate total steps per day.
dailyActivity <- na.omit(activity) %>% group_by(date) %>%
    summarize(totalSteps = sum(steps))

# Calculate mean and median of the total steps taken per day
meanSteps <- mean(dailyActivity$totalSteps)
medianSteps <- median(dailyActivity$totalSteps)

# Plot data ====================================================================
# Make a histogram of the total number of steps taken each day.
# Open graphics device for png.
png(filename = "./figures/plot3.png",width = 640, height = 480, units = "px",
    bg = "transparent")

# Determine optimal binwidth for histogram using the Freedman-Diaconis rule.
binNumber <- nclass.FD(dailyActivity$totalSteps)

# Construct histogram
histSteps <- ggplot(dailyActivity, aes(totalSteps)) +
    geom_histogram(aes(y = ..count../sum(..count..)),
                   origin = min(dailyActivity$totalSteps),
                   bins = binNumber,
                   col = "black",
                   right = TRUE,
                   fill= "grey",
                   na.rm = TRUE) +
    xlim(c(min(dailyActivity$totalSteps),
           max(dailyActivity$totalSteps))) +
    ggtitle("Normalized Histogram of Total Steps Per Day") +
    xlab("total steps per day") +
    ylab("percent of days")
print(histSteps)

#close graphics device
dev.off()


# What is the average daily activity pattern?
# 
# Make a time series plot (i.e. 𝚝𝚢𝚙𝚎 = "𝚕") of the 5-minute interval (x
# axis) and the average number of steps taken, averaged across all days (y-axis)
# Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?
# Imputing missing values
# 
# Note that there are a number of days/intervals where there are missing values (coded as 𝙽𝙰). The presence of missing days may introduce bias into some calculations or summaries of the data.
# 
# Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with 𝙽𝙰s)
# Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.
# Create a new dataset that is equal to the original dataset but with the missing data filled in.
# Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?
# Are there differences in activity patterns between weekdays and weekends?
# 
# For this part the 𝚠𝚎𝚎𝚔𝚍𝚊𝚢𝚜() function may be of some help here. Use the dataset with the filled-in missing values for this part.
# 
# Create a new factor variable in the dataset with two levels – “weekday” and “weekend” indicating whether a given date is a weekday or weekend day.
# Make a panel plot containing a time series plot (i.e. 𝚝𝚢𝚙𝚎 = "𝚕") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). See the README file in the GitHub repository to see an example of what this plot should look like using simulated data.