# Music Emotion Recognition using Spectrogram Features and Kernel Smoothing

---

## Dataset

The project uses the **DEAM (Database for Emotional Analysis of Music)** dataset.

Dataset Link:

https://cvml.unige.ch/databases/DEAM/

Files used:

* Audio recordings from DEAM dataset
* Dynamic Valence Annotations
* Dynamic Arousal Annotations

---

## Methodology

### Step 1: Spectrogram Feature Extraction

Audio signals are processed using Short-Time Fourier Transform (STFT) to obtain spectrogram representations.

### Step 2: Data Normalization

Valence and Arousal annotation values are normalized before training.

Generated Files:

* Normalized_File_Valence.csv
* Normalized_File_arousal.csv

### Step 3: Target Vector Generation

Target vectors are created from the normalized annotations.

Generated Files:

* TargetVector.mat
* TargetVector_arousal.mat

### Step 4: Kernel Smoothing Regression

Gaussian Kernel Smoothing Regression is used to predict:

* Valence
* Arousal

Performance Metrics:

* RMSE
* MAE
* Correlation Coefficient
* R² Score

### Step 5: Emotion Classification

Predicted Valence and Arousal values are mapped into emotional categories using K-Means Clustering and Euclidean Distance based classification.

---

## Repository Contents

### Input Annotation Files

* valence.csv
* arousal.csv

### Normalized Annotation Files

* Normalized_File_Valence.csv
* Normalized_File_arousal.csv

### Target Vectors

* TargetVector.mat
* TargetVector_arousal.mat

### Prediction Results

* Predicted_Average_Valence.csv
* Predicted_Average_Arousal.csv

### Actual vs Predicted Comparisons

* Actual_vs_Predicted.csv
* Actual_vs_Predicted_arousal.csv

### Average Emotion Values

* Average_Valence.csv
* Average_Arousal.csv

### Emotion Classification Results

* Emotion_Classification.csv
* Song_Mood_Classification_Euclidean.csv

---

## Example Performance

### Valence Prediction

RMSE = 0.176934

MAE = 0.122218

Correlation = 0.752516

R² = 0.535410

---

## Software Used

* MATLAB
* Signal Processing Toolbox
* Statistics and Machine Learning Toolbox



---

## Author

**K. Deepa Vastala**


---

## References

1. E. S. Gopi, Pattern Recognition and Machine Learning.
2. Christopher M. Bishop, Pattern Recognition and Machine Learning.
3. Kevin P. Murphy, Machine Learning: A Probabilistic Perspective.
4. DEAM Dataset – https://cvml.unige.ch/databases/DEAM/
