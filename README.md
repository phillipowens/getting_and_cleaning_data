# Getting and Cleaning Data

## Introduction

This repo contains my solution to the Getting and Cleaning Data course project. 

The R code to implement the solution is all in the one script file run_analysis.R

## Dependencies

The run_analysis.R script is uses the **Dplyr** and **Tidyr** libraries. The script calls the require() function on both of these to check they are loaded. 

## run_analysis.R

When the script is source it performs the following actions:

1. Checks for source data

  * Checks for the required source files in a sub-directory "UCI HAR Dataset" of the working directory as located in the original zip file

  * If a file is not found, the script wil attempt to extract it from wearables.zip in the working directory.

  * If the zip file is not found it will attempt to download the file from web.
  
2. Combines the subject, activty and signal data, selecting only those variables that correspond to mean or standard deviation measures fo each signal.  

3. Saved a summary file of the mean and standard deviation by subject, activity and signal via write.table to wearables.txt in the working directory.

