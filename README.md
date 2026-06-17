# Music Emotion Recognition using Spectrogram Features and Kernel Smoothing

## Overview

This project focuses on the mathematical foundations of Machine Learning and their application to Music Emotion Recognition (MER). The objective is to predict the emotional content of music in terms of **Valence** and **Arousal** using spectrogram-based audio features and Kernel Smoothing Regression.

The work was carried out as part of a Summer Internship at the **Pattern Recognition and Computational Intelligence Laboratory, Department of Electronics and Communication Engineering, National Institute of Technology Tiruchirappalli**.

---

## Project Objectives

* Extract meaningful features from music audio signals.
* Generate spectrogram representations using Short-Time Fourier Transform (STFT).
* Normalize spectrogram features and emotion annotations.
* Predict Valence and Arousal values using Kernel Smoothing Regression.
* Analyze music emotions using the Valence-Arousal model.
* Perform clustering and visualization of emotional categories.

---

## Dataset

**DEAM Dataset (Database for Emotional Analysis of Music)**

Dataset Link:

https://cvml.unige.ch/databases/DEAM/

Files Used:

* Audio files from DEAM dataset
* Dynamic Valence Annotations
* Dynamic Arousal Annotations

Annotation Path:

```text
DEAM_Annotations.zip
 └── annotations
     └── annotations averaged per song
         └── dynamic (per second annotations)
             ├── valence.csv
             └── arousal.csv
```

---

## Methodology

### 1. Audio Processing

* Audio files are loaded from the DEAM dataset.
* Audio signals are converted into spectrogram representations using STFT.
* Spectrograms are normalized for consistent feature scaling.

### 2. Feature Extraction

* Spectrogram magnitude values are extracted.
* Features are flattened into vectors.
* Principal Component Analysis (PCA) is applied for dimensionality reduction.

### 3. Emotion Prediction

Kernel Smoothing Regression with Gaussian Kernel is used to predict:

* Valence
* Arousal

### 4. Emotion Classification

Predicted Valence and Arousal values are grouped using:

* K-Means Clustering
* Euclidean Distance Analysis

---

## Machine Learning Concepts Implemented

### Regression

* Linear Regression (Polynomial Kernel)
* Linear Regression (Gaussian Kernel)
* Linear Regression (Trigonometric Basis)
* Polynomial Regression
* Gaussian Basis Function Regression
* Regularization (Ridge Regression)
* Bayesian Regression
* Gaussian Kernel Smoothing

### Dimensionality Reduction

* Principal Component Analysis (PCA)
* Linear Discriminant Analysis (LDA)
* Kernel Linear Discriminant Analysis (KLDA)

### Classification

* Logistic Regression
* Support Vector Machine (SVM)
* Artificial Neural Network (ANN)
* K-Means Clustering

---

## Performance Metrics

The model performance is evaluated using:

* Root Mean Square Error (RMSE)
* Mean Absolute Error (MAE)
* Correlation Coefficient
* R-Squared (R²)

Example Result:

```text
Best Sigma = 3.0

RMSE = 0.176934
MAE  = 0.122218
Corr = 0.752516
R²   = 0.535410
```

---

## Software Requirements

* MATLAB
* Signal Processing Toolbox
* Statistics and Machine Learning Toolbox

---

## Project Structure

```text
Project/
│
├── Audio/
├── valence.csv
├── arousal.csv
│
├── Spectrogram Generation and Normalization
├── Valence Normalization
├── Arousal Normalization
├── Kernel Smoothing Regression(train.m)
├── Valence Prediction(predict_plot_valence.m)
├── Arousal Prediction(predict_plot_arousal.m)
├── Predicted_Average_Valence.csv
├── Predicted_Average_Arousal.csv
├── Determining mood of song
|
|
└── README.md
```

---

## Results

* Successfully extracted spectrogram-based audio features.
* Predicted Valence and Arousal values from music recordings.
* Applied Kernel Smoothing Regression for emotion estimation.
* Visualized emotional categories using K-Means clustering.
* Evaluated performance using standard regression metrics.

---

## Author

**K. Deepa Vastala**

---

## References

1. E. S. Gopi, Pattern Recognition and Machine Learning.
2. Christopher M. Bishop, Pattern Recognition and Machine Learning.
3. Kevin P. Murphy, Machine Learning: A Probabilistic Perspective.
4. DEAM Dataset – https://cvml.unige.ch/databases/DEAM/
