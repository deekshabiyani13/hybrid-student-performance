# Hybrid Intelligent System: Student Performance Prediction

##  Description

This project implements a hybrid intelligent system combining **fuzzy logic** and **neural networks (ANFIS)** to predict student performance levels.

The system analyzes academic indicators and classifies students into performance categories.

---

##  Inputs

* **Attendance (%)**
* **Assignment Marks (0–100)**
* **Test Marks (0–100)**

---

##  Output

* **Performance Level**

  * Poor
  * Average
  * Good

---

##  Methodology

###  Fuzzy Logic Component

* Uses **Mamdani Fuzzy Inference System**
* Defines linguistic variables:

  * Low, Medium, High
* Rule-based reasoning:

  * Example:
    *IF attendance is high AND marks are high THEN performance is good*

---

###  Neural Network Component (ANFIS)

* ANFIS = Adaptive Neuro-Fuzzy Inference System
* Combines:

  * Fuzzy logic (interpretability)
  * Neural network learning (accuracy)
* Learns patterns from dataset using hybrid learning

---

###  Hybrid Integration

* Fuzzy system provides structured rules
* ANFIS optimizes parameters using data
* Final system combines:

  * Human-like reasoning
  * Data-driven learning

---

##  Dataset

* Synthetic dataset of **300 students**
* Features:

  * Attendance
  * Assignment Marks
  * Test Marks
* Output:

  * Performance score (0–1)

---

##  Classification Logic

The predicted score is converted into performance levels:

* **Poor:** 0 – 0.40
* **Average:** 0.40 – 0.70
* **Good:** 0.70 – 1.00

---

##  Results

* Smooth training convergence
* Good prediction accuracy
* Strong alignment between actual and predicted values

---

##  Files Included

* `student_performance.m` → MATLAB implementation
* `student_performance_fuzzy.fis` → Fuzzy system file
* `screenshots/` → Output graphs:

  * Membership functions
  * Training curve
  * Prediction plot
  * Class distribution

---

##  Conclusion

The hybrid system successfully predicts student performance by combining fuzzy logic and neural networks. It improves accuracy while maintaining interpretability.

---

##  Note

This project demonstrates how intelligent systems can be applied in **education analytics** for performance evaluation and decision-making.
