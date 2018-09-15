
<!-- README.md is generated from README.Rmd. Please edit that file -->
MachineShop: Machine Learning Models and Tools
==============================================

Overview
--------

`MachineShop` is a meta-package for machine learning with a common interface for model fitting, prediction, performance assessment, and presentation of results. Support is provided for predictive modeling of numerical, categorical, and censored time-to-event outcomes, including those listed in the table below, and for resample (bootstrap and cross-validation) estimation of model performance.

<table class="table table-striped" style="width: auto !important; margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="border-bottom:hidden" colspan="1">
</th>
<th style="border-bottom:hidden; padding-bottom:0; padding-left:3px;padding-right:3px;text-align: center; " colspan="4">
Response Variable Types

</th>
</tr>
<tr>
<th style="text-align:left;">
</th>
<th style="text-align:center;">
factor
</th>
<th style="text-align:center;">
numeric
</th>
<th style="text-align:center;">
ordered
</th>
<th style="text-align:center;">
Surv
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
C5.0 Classification
</td>
<td style="text-align:center;">
x
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
</td>
</tr>
<tr>
<td style="text-align:left;">
Conditional Inference Trees
</td>
<td style="text-align:center;">
x
</td>
<td style="text-align:center;">
x
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
x
</td>
</tr>
<tr>
<td style="text-align:left;">
Cox Regression
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
x
</td>
</tr>
<tr>
<td style="text-align:left;">
Generalized Linear Models
</td>
<td style="text-align:center;">
x
</td>
<td style="text-align:center;">
x
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
</td>
</tr>
<tr>
<td style="text-align:left;">
Gradient Boosted Models
</td>
<td style="text-align:center;">
x
</td>
<td style="text-align:center;">
x
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
x
</td>
</tr>
<tr>
<td style="text-align:left;">
Lasso and Elastic-Net
</td>
<td style="text-align:center;">
x
</td>
<td style="text-align:center;">
x
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
x
</td>
</tr>
<tr>
<td style="text-align:left;">
Feed-Forward Neural Networks
</td>
<td style="text-align:center;">
x
</td>
<td style="text-align:center;">
x
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
</td>
</tr>
<tr>
<td style="text-align:left;">
Partial Least Squares
</td>
<td style="text-align:center;">
x
</td>
<td style="text-align:center;">
x
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
</td>
</tr>
<tr>
<td style="text-align:left;">
Ordered Logistic Regression
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
x
</td>
<td style="text-align:center;">
</td>
</tr>
<tr>
<td style="text-align:left;">
Random Forests
</td>
<td style="text-align:center;">
x
</td>
<td style="text-align:center;">
x
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
</td>
</tr>
<tr>
<td style="text-align:left;">
Parametric Survival Regression
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
x
</td>
</tr>
<tr>
<td style="text-align:left;">
Support Vector Machines
</td>
<td style="text-align:center;">
x
</td>
<td style="text-align:center;">
x
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
</td>
</tr>
</tbody>
</table>

Installation
------------

``` r
# Development version from GitHub
# install.packages("devtools")
devtools::install_github("brian-j-smith/MachineShop")
```

Example
-------

The following is a brief example using the package to apply gradient boosted models to predict the species of flowers in Edgar Anderson's iris dataset.

``` r
## Load the package
library(MachineShop)
library(magrittr)

## Iris flower species (3 level response)
df <- iris
df$Species <- factor(df$Species)

## Create training and test sets
set.seed(123)
trainindices <- sample(nrow(df), nrow(df) * 2 / 3)
train <- df[trainindices, ]
test <- df[-trainindices, ]

## Gradient boosted mode fit to training set
gbmfit <- fit(GBMModel(), Species ~ ., data = train)

## Variable importance
(vi <- varimp(gbmfit))
#>                 Overall
#> Petal.Length 100.000000
#> Petal.Width   12.700153
#> Sepal.Width    2.140995
#> Sepal.Length   0.000000

plot(vi)
```

<img src="man/figures/README-unnamed-chunk-3-1.png" style="display: block; margin: auto;" />

``` r
## Test set predicted probabilities
predict(gbmfit, newdata = test, type = "prob") %>% head
#>         setosa versicolor virginica
#> [1,] 0.4216059  0.2975845 0.2808096
#> [2,] 0.4216059  0.2975845 0.2808096
#> [3,] 0.4216059  0.2975845 0.2808096
#> [4,] 0.4216059  0.2975845 0.2808096
#> [5,] 0.4219454  0.2958235 0.2822311
#> [6,] 0.4229810  0.2952935 0.2817254

## Test set predicted classification
predict(gbmfit, newdata = test) %>% head
#> [1] setosa setosa setosa setosa setosa setosa
#> Levels: setosa versicolor virginica
```

``` r
## Resample estimation of model performance
(perf <- resample(GBMModel(), Species ~ ., data = df))
#> An object of class "Resamples"
#> 
#> metrics: Accuracy, Kappa, WeightedKappa, MLogLoss
#> 
#> method: 10-Fold CV
#> 
#> resamples: 10

summary(perf)
#>                    Mean    Median         SD       Min       Max NA
#> Accuracy      0.9400000 0.9333333 0.04919099 0.8666667 1.0000000  0
#> Kappa         0.9100000 0.9000000 0.07378648 0.8000000 1.0000000  0
#> WeightedKappa 0.9330032 0.9249531 0.05424416 0.8500000 1.0000000  0
#> MLogLoss      0.9225421 0.9232478 0.01008958 0.9087998 0.9379053  0

plot(perf, metrics = c("Accuracy", "Kappa", "MLogLoss"))
```

<img src="man/figures/README-unnamed-chunk-5-1.png" style="display: block; margin: auto;" />

``` r
## Model tuning
gbmtune <- tune(GBMModel, Species ~ ., data = df,
                grid = expand.grid(n.trees = c(25, 50, 100),
                                    interaction.depth = 1:3,
                                    n.minobsinnode = c(5, 10)))

plot(gbmtune, type = "line", metrics = c("Accuracy", "Kappa", "MLogLoss"))
```

<img src="man/figures/README-unnamed-chunk-6-1.png" style="display: block; margin: auto;" />

Documentation
-------------

Once the package is installed, general documentation on its usage can be viewed with the following console commands.

``` r
library(MachineShop)
?MachineShop
RShowDoc("Introduction", package = "MachineShop")
```
