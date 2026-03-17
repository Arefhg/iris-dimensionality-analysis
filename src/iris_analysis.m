% =========================================================================
%  IRIS DATASET - Dimensionality Reduction & Clustering
%  Numerical Methods for Data Analysis | MATLAB Project
%  Author: Aref Haghgoorostami
% =========================================================================
%
%  THE PROBLEM I'M TRYING TO SOLVE:
%  ---------------------------------
%  The Iris dataset has 150 flowers, each described by 4 measurements:
%    - Sepal Length (cm)
%    - Sepal Width  (cm)
%    - Petal Length (cm)
%    - Petal Width  (cm)
%
%  There are 3 species: Setosa, Versicolor, and Virginica.
%
%  The issue is I can't just "look at" 4-dimensional data. So the question
%  I want to answer is: can I reduce it to 2D and still see the species
%  clearly separated? And which method does this best?
%
%  I also wanted to try clustering - meaning, can an algorithm find the
%  3 groups on its own WITHOUT being told which flower is which species?
%
%  WHAT I DID:
%  -----------
%  Step 1 - Load the data and normalize it
%  Step 2 - LDA (supervised, uses the labels to separate classes)
%  Step 3 - PCA (unsupervised, finds the main directions of variance)
%  Step 4 - SVD (breaks down the data matrix directly)
%  Step 5 - SVD then PCA combined
%  Step 6 - LDA then PCA combined
%  Step 7 - K-Means clustering
%  Step 8 - K-Medoids clustering (more stable than K-Means)
% =========================================================================

clc; clear; close all;


%% =========================================================================
%  STEP 1 - LOADING AND PREPARING THE DATA
% =========================================================================
%
%  First I load the CSV and take a quick look at it to make sure everything
%  loaded correctly. Then I clean it up (remove any missing rows), split
%  it into features and labels, and normalize.
%
%  I normalize because the features are all in centimeters but with
%  different ranges - without normalization, methods like K-Means would
%  unfairly weight whichever feature has the biggest numbers.
%  After normalizing, every feature has mean=0 and std=1.
%
%  For the labels: grp2idx turns "Iris-setosa" etc. into 1, 2, 3.
% =========================================================================

% load the data
iris = readtable('../data/Iris.csv');

% show the first 5 rows in a small UI window so I can confirm it loaded right
fig_preview = uifigure('Name', 'Iris - first 5 rows');
uitable(fig_preview, ...
    'Data',       iris(1:5, :), ...
    'Position',   [20 20 560 160], ...
    'ColumnName', iris.Properties.VariableNames);

% drop any rows with missing values (there aren't any in Iris but good habit)
iris = rmmissing(iris);

% columns 2-5 are the 4 measurements, column 6 is the species name
% (column 1 is just a row ID so I skip it)
iris_features = table2array(iris(:, 2:5));
iris_labels   = grp2idx(iris{:, end});   % 1=setosa, 2=versicolor, 3=virginica

% normalize all features to zero mean, unit variance
iris_features = normalize(iris_features);

fprintf('Loaded: %d samples, %d features, %d species\n', ...
    size(iris_features,1), size(iris_features,2), numel(unique(iris_labels)));


%% =========================================================================
%  STEP 2 - LINEAR DISCRIMINANT ANALYSIS (LDA)
% =========================================================================
%
%  LDA is a supervised method - it actually uses the species labels to find
%  the best direction for separating the classes. Basically it looks for a
%  line to project the data onto where the three groups are as far apart
%  as possible.
%
%  I'm projecting onto just 1 dimension here (LD1). The result should show
%  Setosa clearly separated from the other two, since it's biologically
%  more distinct. Versicolor and Virginica tend to be closer together.
%
%  In MATLAB: fitcdiscr trains the model, then I manually do the projection
%  by multiplying the features by the first discriminant vector.
% =========================================================================

% fit the LDA model using the true labels
lda_model = fitcdiscr(iris_features, iris_labels);

% project each sample down to 1D using the first discriminant
iris_lda_proj = iris_features * lda_model.Coeffs(1,2).Linear;

% plot - y is all zeros because it's 1D, I just spread points along x
figure('Name', 'LDA');
scatter(iris_lda_proj, zeros(size(iris_lda_proj)), 60, iris_labels, 'filled');
title('Step 2 - LDA: 1D Projection of Iris Species', 'FontSize', 13);
xlabel('LD1');
colormap(jet); colorbar;
grid on;
% what I saw: Setosa (dark blue) is completely on its own on the right.
% Versicolor and Virginica are closer together but still mostly separate.


%% =========================================================================
%  STEP 3 - PRINCIPAL COMPONENT ANALYSIS (PCA)
% =========================================================================
%
%  PCA is unsupervised - it doesn't know anything about the species, it just
%  finds the directions where the data varies the most. The first two
%  principal components (PC1, PC2) give me the best 2D view of the 4D data.
%
%  I'm colouring the dots by K-Means cluster assignment (from step 7,
%  which I compute here early so I can reuse it in multiple plots).
%  Using 'Replicates', 10 means I run K-Means 10 times and pick the
%  best result - this reduces the chance of landing on a bad random start.
% =========================================================================

% PCA - scores matrix has one row per sample in the new PC space
[~, pca_scores] = pca(iris_features);

% K-Means on the original features (K=3 because I know there are 3 species)
kmeans_labels = kmeans(iris_features, 3, 'Replicates', 10);

figure('Name', 'PCA');
scatter(pca_scores(:,1), pca_scores(:,2), 60, kmeans_labels, 'filled');
title('Step 3 - PCA: Iris in 2D (coloured by K-Means cluster)', 'FontSize', 13);
xlabel('PC1'); ylabel('PC2');
colormap(jet); colorbar;
grid on;
% what I saw: one cluster is very clearly isolated (that's Setosa).
% The other two overlap a bit in the middle - which makes sense because
% Versicolor and Virginica are genuinely quite similar species.


%% =========================================================================
%  STEP 4 - SINGULAR VALUE DECOMPOSITION (SVD)
% =========================================================================
%
%  SVD breaks the data matrix X into three parts: X = U * S * V'
%  The U matrix (left singular vectors) captures patterns across samples.
%  Plotting the first two columns of U gives a view of the data that's
%  mathematically similar to PCA, but computed differently.
%
%  While PCA works on the covariance matrix, SVD works directly on X.
%  For clean, well-scaled data like this, both give almost the same picture.
%  I'm using 'econ' to only compute what I actually need (saves memory).
% =========================================================================

[U_iris, ~, ~] = svd(iris_features, 'econ');

figure('Name', 'SVD');
scatter(U_iris(:,1), U_iris(:,2), 60, iris_labels, 'filled');
title('Step 4 - SVD: Iris via Left Singular Vectors', 'FontSize', 13);
xlabel('U[:,1] - 1st Singular Vector');
ylabel('U[:,2] - 2nd Singular Vector');
colormap(jet); colorbar;
grid on;
% pretty much the same picture as PCA. Setosa is still isolated, the other
% two overlap. This tells me both methods pick up the same structure.


%% =========================================================================
%  STEP 5 - SVD FOLLOWED BY PCA
% =========================================================================
%
%  Here I'm chaining two methods together. The idea:
%    1. SVD gives me the top 3 left singular vectors (I drop the 4th,
%       which captures the least variance / most noise)
%    2. Then I apply PCA to those 3 vectors
%
%  So SVD does a first pass of noise reduction, and PCA then extracts
%  the most informative 2D projection from the cleaned result.
%  I expected the clusters to look a bit tighter - and they did, slightly.
% =========================================================================

% take top 3 singular directions (drop the 4th / weakest one)
U_top3 = U_iris(:, 1:3);

% now apply PCA on top of that
[~, pca_svd_scores] = pca(U_top3);

figure('Name', 'SVD + PCA');
scatter(pca_svd_scores(:,1), pca_svd_scores(:,2), 60, iris_labels, 'filled');
title('Step 5 - SVD then PCA: Iris', 'FontSize', 13);
xlabel('PC1'); ylabel('PC2');
colormap(jet); colorbar;
grid on;
% the clusters are slightly more compact here - removing the weakest
% singular direction before PCA seems to help a little.


%% =========================================================================
%  STEP 6 - LDA FOLLOWED BY PCA
% =========================================================================
%
%  Another combination, but this one mixes supervised and unsupervised.
%
%  What I did: take the 1D LDA projection from step 2 and add it as an
%  extra column to the original 4 features. So now I have 5 columns.
%  Then I run PCA on this 5-column matrix.
%
%  The idea is that the LDA column gives PCA a "hint" about where the
%  class boundaries are, without PCA itself needing to know the labels.
%  I was curious if this would help Versicolor and Virginica separate better
%  than plain PCA - and it did noticeably.
% =========================================================================

% append the LDA projection as an extra feature
iris_augmented = [iris_lda_proj, iris_features];   % now 150 x 5

[~, pca_lda_scores] = pca(iris_augmented);

figure('Name', 'LDA + PCA');
scatter(pca_lda_scores(:,1), pca_lda_scores(:,2), 60, iris_labels, 'filled');
title('Step 6 - LDA then PCA: Iris', 'FontSize', 13);
xlabel('PC1'); ylabel('PC2');
colormap(jet); colorbar;
grid on;
% this gave better separation between the two harder classes (2 and 3).
% Not perfect, but clearly better than just PCA on its own.


%% =========================================================================
%  STEP 7 - K-MEANS CLUSTERING
% =========================================================================
%
%  K-Means is fully unsupervised - it finds groups without knowing the
%  species labels at all. The algorithm:
%    1. Pick K random starting centroids
%    2. Assign each point to the nearest centroid
%    3. Update each centroid to the mean of its assigned points
%    4. Repeat until nothing changes
%
%  I used K=3 (matching the actual number of species) and ran it twice:
%  once on the original 4 features, once on just the 2 PCA scores.
%  I wanted to see if reducing to 2D first helps or hurts clustering.
%
%  Both use Replicates=10 to pick the best of 10 random starts.
% =========================================================================

% K-Means on PCA scores (2D version)
kmeans_pca_labels = kmeans(pca_scores(:,1:2), 3, 'Replicates', 10);

% plot K-Means from original features, shown in PCA space
figure('Name', 'K-Means (original features)');
scatter(pca_scores(:,1), pca_scores(:,2), 60, kmeans_labels, 'filled');
title('Step 7a - K-Means on original 4 features (shown in PCA space)', 'FontSize', 13);
xlabel('PC1'); ylabel('PC2');
colormap(jet); colorbar;
grid on;

% plot K-Means run directly on PCA scores
figure('Name', 'K-Means on PCA scores');
scatter(pca_scores(:,1), pca_scores(:,2), 60, kmeans_pca_labels, 'filled');
title('Step 7b - K-Means on 2D PCA scores', 'FontSize', 13);
xlabel('PC1'); ylabel('PC2');
colormap(jet); colorbar;
grid on;
% Setosa was found perfectly in both cases. The PCA version gave
% slightly cleaner boundaries for the other two.


%% =========================================================================
%  STEP 8 - K-MEDOIDS CLUSTERING
% =========================================================================
%
%  K-Medoids is similar to K-Means but with one key difference:
%  instead of using the mean of a cluster as its center (which can be
%  a point that doesn't actually exist in the data), K-Medoids forces
%  each center to be a real data point from the dataset.
%
%  This makes it less sensitive to outliers. If there's one weird extreme
%  value in a cluster, it won't drag the center away from the main group.
%
%  On this clean dataset the results are quite similar to K-Means,
%  but in messier real-world data K-Medoids tends to be more reliable.
% =========================================================================

kmedoids_labels = kmedoids(iris_features, 3);

figure('Name', 'K-Medoids');
scatter(pca_scores(:,1), pca_scores(:,2), 60, kmedoids_labels, 'filled');
title('Step 8 - K-Medoids Clustering (shown in PCA space)', 'FontSize', 13);
xlabel('PC1'); ylabel('PC2');
colormap(jet); colorbar;
grid on;
% very similar to K-Means here, which makes sense since Iris doesn't
% have strong outliers. The advantage would show more on messier data.


%% =========================================================================
%  SUMMARY OF WHAT I FOUND
% =========================================================================
%
%  Method           | What I noticed
%  -----------------|-----------------------------------------------------
%  LDA (1D)         | Best separation - Setosa fully alone, others mostly ok
%  PCA (2D)         | Good overview - Setosa clear, Versicolor/Virginica mix
%  SVD (2D)         | Almost identical to PCA, same structure
%  SVD then PCA     | Slightly tighter clusters, noise reduced a little
%  LDA then PCA     | Noticeably better for the two harder classes
%  K-Means (orig.)  | Recovered Setosa perfectly, ~90% correct overall
%  K-Means (PCA)    | Same accuracy but cleaner looking boundaries
%  K-Medoids        | Similar to K-Means, but would be better with outliers
%
%  The consistent finding across everything: Setosa is easy to separate.
%  The hard part is always Versicolor vs Virginica - they genuinely overlap.
% =========================================================================

fprintf('\nDone. All figures are open.\n');
