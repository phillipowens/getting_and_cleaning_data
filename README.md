# Getting and Cleaning Data

## Introduction

This repo contains my solution to the Getting and Cleaning Data course project. 

The R code to implement the solution is all in the one script file *run_analysis.R*

## Dependencies

The *run_analysis.R* script is uses the **Dplyr** and **Tidyr** libraries. The script calls the *require()* function on both of these to check they are loaded. 

## run_analysis.R

After sourcing the script it can be excuted by calling the function *do.analysis(outfilename = "wearables.txt")*.  On invocation the script performs the following actions:

1. Checks for source data

  * Checks for the required source files in a sub-directory *"UCI HAR Dataset"* of the working directory as located in the original zip file

  * If a file is not found, the script wil attempt to extract it from *wearables.zip* in the working directory.

  * If the zip file is not found it will attempt to download the file from web.
  
2. Combines the subject, activty and signal data, selecting only those variables that correspond to mean or standard deviation measures for each signal.  

3. The data is reshaped into a tidy dataset with each row representing the average mean and standard deviation for a given subject, activty and signal. The signal is not further sub-divided as suggested in [David Hood's post](https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/)

4. Saves a summary file of the mean and standard deviation by subject, activity and signal via *write.table(outfilename, row.name=FALSE)* to the working directory. *outfilename* has a default of *wearables.txt*

Full details of the treatment of the data is given in the codebook.md in this repo.

## Viewing the result

The resulting summary file can be loaded via *read.table(filename, headers = TRUE)*, where *filename* is either the *outfilename* parameter passed to *do.analysis()* or the default value of *"wearables.txt"* if no *outfilename* was given. 