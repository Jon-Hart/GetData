Processing of UCI-Samsung smartphone machine learning dataset into a tidy dataset
=========

run_analysis.R
-----
This script performs all of the analysis including:

1. Downloading the data
2. Unpacking
3. Loading the data
4. Merging column names, activity labels, and the training and test datasets into a single monolithic tidy data set.
5. Summrizing the merged data set by subject and activity.  The mean value for each feature is returned.
6. Writing the data table out(summarized.table.txt).

codebook.txt
-----
A codebook describing the features in the summary data table.