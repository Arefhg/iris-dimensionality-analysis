# Iris Dataset — Dimensionality Reduction & Clustering in MATLAB

This is a project I did for my Numerical Methods for Data Analysis course.
The goal was to apply different methods to the Iris dataset and explore how
well each one can reduce the data or find the hidden groups in it.

---

## What's the problem I was solving?

The Iris dataset has 150 flower samples. Each one has 4 measurements (sepal length,
sepal width, petal length, petal width) and belongs to one of 3 species:
**Setosa**, **Versicolor**, or **Virginica**.

The problem is you can't visualize 4-dimensional data directly. So I wanted to
figure out: if I compress it down to 2D, can I still see the three species
separated? And which method does the best job?

I also tried clustering — meaning, can an algorithm find the 3 groups completely
on its own, without ever being told which flower belongs to which species?

---

## Methods I used

| Step | Method | Supervised? | What it does |
|---|---|---|---|
| 1 | Data normalization | — | Remove missing values, scale all features to mean=0, std=1 |
| 2 | LDA | Yes (uses labels) | Projects data to 1D to maximally separate the 3 species |
| 3 | PCA | No | Finds 2D directions of max variance without knowing the labels |
| 4 | SVD | No | Decomposes the data matrix directly, similar result to PCA |
| 5 | SVD → PCA | No | SVD first removes the weakest direction, then PCA takes over |
| 6 | LDA → PCA | Hybrid | Appends the LDA projection to the features before running PCA |
| 7 | K-Means | No | Partitions data into 3 clusters based on distance to centroids |
| 8 | K-Medoids | No | Like K-Means but uses real data points as centers (more stable) |

---

## What I found

The most consistent result across all methods: **Setosa is always clearly separated**
from the other two. You can see it as a tight isolated cluster in every single plot.

The harder part is separating **Versicolor and Virginica** from each other — they
genuinely overlap in the feature space, which all the unsupervised methods struggle with.
LDA does the best job because it actually uses the species labels to find the
most discriminating direction.

The LDA → PCA combination surprised me the most. Adding the LDA output as an
extra feature before running PCA visibly improved the separation between the
two harder classes, compared to plain PCA.

K-Means and K-Medoids both recover the Setosa cluster perfectly without any
label information, which I thought was pretty cool.

---

## How to run it

### What you need
- MATLAB (R2021a or newer)
- Statistics and Machine Learning Toolbox

### Steps

```
1. Clone or download this repo
2. Open MATLAB and navigate to the project folder
3. cd src
4. run('iris_analysis.m')
```

That's it. The script will open 8 scatter plots (one per method) plus a small
table showing the first 5 rows of the raw data.

> Make sure `Iris.csv` is in the `data/` folder — the script looks for it at
> `../data/Iris.csv` relative to where it runs from.

---

## Folder structure

```
iris-dimensionality-analysis/
│
├── data/
│   └── Iris.csv

├── src/
│   └── iris_analysis.m

├── report/
│   └── Iris_Analysis_Report.docx

└── README.md
```

---

## Quick explanation of each method

**PCA** — finds the axes along which the data varies the most, then projects
everything onto the top 2 axes. Completely ignores class labels.

**SVD** — factorises the data matrix X = U·S·V'. Plotting the first two columns
of U gives a view of the data very similar to PCA, just computed differently.

**LDA** — unlike PCA, LDA *knows* the class labels and finds the direction that
pushes the three species as far apart as possible. That's why it does better
at separating Versicolor and Virginica.

**K-Means** — picks K random starting points, assigns every sample to the nearest
one, then moves each center to the average of its group. Repeats until stable.

**K-Medoids** — same idea as K-Means, except the centers have to be actual points
from the dataset (not computed averages). This makes it less affected by outliers.

---

*Numerical Methods for Data Analysis — Aref Haghgoorostami*
