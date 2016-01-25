# Reproducible Research: Peer Assessment 1



## Loading and preprocessing the data


File "activity.zip" was downloaded (on: **Sat Jan 23 22:13:46 2016**) and unzipped to
"activity.csv".


```r
activity <- tbl_df(read.csv("activity.csv"))
```



## What is mean total number of steps taken per day?

Any NAs in the data were omitted, the total steps taken per day were
calculated and plotted as a histogram:


```r
dailyActivity <- na.omit(activity) %>% group_by(date) %>%
    summarize(totalSteps = sum(steps))
```

![](PA1_template_files/figure-html/histogramSteps-1.png)



The total number of steps taken per day have a mean of 
**10766.19** and a median of **10765**.



## What is the average daily activity pattern?

To calculate the daily activity pattern, NAs were ommited, and the average
number of steps per interval was calculated and plotted as a line graph:


```r
intervalActivity <- na.omit(activity) %>% group_by(interval) %>%
    summarize(meanSteps = mean(steps))
```

![](PA1_template_files/figure-html/lineGraphActivity-1.png)



The 5-minute interval **835** contains the maximum number
of steps on average across all the days.



## Imputing missing values



## Are there differences in activity patterns between weekdays and weekends?
