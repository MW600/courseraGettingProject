# courseraGettingProject
Course project for Getting and Cleaning Data

The run_analysis.R script is used to automatically check for existence and/or download the necessary Samsung data.

In the first step all the measurements data are merged together in order: first TEST set, then TRAIN set. Variables names, read from "features.txt" file, are added afterwards. Subject and Activity Labels data are merged together separately, based on the numeric value of Activity.

In the next step columns containing mean() (for average) and std() (for standard deviation) data are extracted from all measurement data. Subject + Activity data is added afterwards. 2-Level sorting is the last step.

In the end, the data set is aggregated based on two columns: subject and activity. Resulting variable - tidyData, contains averaged and grouped data. The variable is saved afterwards in a text file.
