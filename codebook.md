# Code Book

This code book decribes the variables, data and transformations I have made in my solution to the Getting and Cleaning Data course project.

It builds upon the README.txt and features_info.txt files from the original Human Activity Recognition Using Smartphones dataset. I have included these in this repo.

The experimental data records the sensor signals from a smartphones worn by a group of 30 volunteers while performing six activities. 3-axial linear acceleration and 3-axial angular velocity signals from the embedded accelerometer and gyroscope were captured. 

The base sensor signals were processed to derive a set of signals and related variables for each so that each row contained 561 features. Of these only the features relating to the mean value and standard deviation were required. These could be identifed as the feature names contained the variable mean() or std(), e.g. tBodyAcc-mean()-X and tBodyAcc-std()-X.

The study han also randomly partitioned into the data into two sets, training data and test data. 

Each set consisted of 3 files:

  * X_{set name}.txt: 561 features (columns) per row with no header row.
  * y_{set name}.txt: single column (activity code) for each row in the X_{set name}.txt file.
  * subject_{set name}.txt: single column (subject ID) for each row in the X_{set name}.txt file. 
  
The column names were contained in the 'features.txt' file.

The descriptive names for the activity codes were contained in the 'activity_labels.txt' file.

After the X_{set name}.txt are loaded with read.table the following actions are performed:

  * The columns corresponding to mean() and std() variables are selected and renamed.
  * The subject ID is added from subject_{set name}.txt with cbind()
  * The activity code is added from y_{set name}.txt with cbind()
  * The activty description is merged from activity_labels.txt
  * A unique id is added to each row
  
The data is then reshaped for the mean() and std() variables by:

  * separate gather() for mean() and std() variables
  * removal of the variable portion of the signal name, e.g. tBodyAcc-mean()-X and tBodyAcc-std()-X become tBodyAcc-X. The t and f prefix indicating the signal domain are also expanded to time and freq(uency).
  * merging of mean() and std() data back into a single row.
  * grouping by subject, activty and signal and summarising mean of mean() and std() to produce the final dataset as illustrated below: 


subject | activity | signal  | mean | std
--- | --- | --- | --- | --- 
 1 |  LAYING | freq-BodyAccJerk-X | -0.9570739 | -0.9641607
 1 |  LAYING | freq-BodyAccJerk-Y | -0.9224626 | -0.9322179
 1 |  LAYING | freq-BodyAccJerk-Z | -0.9480609 | -0.9605870
 1 |  LAYING |    freq-BodyAccMag | -0.8617676 | -0.7983009
 1 |  LAYING |     freq-BodyAcc-X | -0.9390991 | -0.9244374
 1 |  LAYING |     freq-BodyAcc-Y | -0.8670652 | -0.8336256
      
Where: 

  * subject: the subject id from the source data
  * activity: the activity description from the source data
  * signal: the signal from the source data
  * mean: average mean()
  * std: average std()

The units used for the accelerations are 'g's (gravity of earth -> 9.80665 m/seg2), e.g.
freq-Body**Acc**-X.

The gyroscope units are rad/seg , e.g. time-Body**Gyro**-X.

## Citation 

Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013. 
