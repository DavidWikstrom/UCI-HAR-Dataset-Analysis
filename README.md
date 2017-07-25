# UCI HAR Dataset Analysis

This repository contains an R script, __run_analysis.R__, which can be run to download and process the [UCI HAR Dataset](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones), outputting two different, tidy data sets:
* UCI_HAR_Dataset_Tidy.txt
* UCI_HAR_Dataset_Tidy_Grouped.txt

__UCI_HAR_Dataset_Tidy.txt__ will contains the data from the two subsets provided in __UCI HAR Dataset__ - _train_ and _test_.
__UCI_HAR_Dataset_Tidy_Grouped.txt__ is based on the former, and contains the same data, grouped by Activity and Subject, showing the means for each of the measurements.

## Analysis

The analysis starts by downloading the zip-compressed "Human Activity Recognition Using Smartphones" dataset from the online location to the location working directory (unless it's already present there).

The zip file is decompressed.

The analysis loops through the two subsets - _train_ and _test_, and, for each subset, reads each of the relevant files, compiling the relevant information (measurement data and labels), which selecting only the measurements that pertain to means and standard deviation. The subsets are added together to form a single dataset.

This combined dataset is saved as a text file: __UCI_HAR_Dataset_Tidy.txt__, in the working directory.

Finally, a summary of the dataset is created, with one row per Activity and SubjectID, with the average for each measurement.

## Data CodeBook

The [codebook](CodeBook.md) describes the variables, the data, the transformations that are done and the clean up that was performed on the data.