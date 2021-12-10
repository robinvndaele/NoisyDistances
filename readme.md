This folder contains the Appendix for arxiv submission https://arxiv.org/abs/2109.10569: 
_The Curse Revisited:  When are Distances Informative for theGround Truth in Noisy High-Dimensional Data?_

## Setup

### Enviroments
* R (Rstudio)
* Python (Jupyter notebook) 

### R requirements
* ggplot2 (general plotting)
* igraph (working with graphs)
* ggpubr (combining plots)
* FNN (fast k-NN graph computation)
* parallel (parallel processing in R)
* umap (umap dimensionality reduction)
* diffusionMap (diffusion map dimensionality reduction)
* rpca (Robust PCA dimensionality reduction)
* dimRed (Isomap dimensionality reduction)

### Python Requirements 
* numpy (handling arrays)
* pandas (handling data frames)
* pytorch (neural networks in Python)
* matplotlib (plotting)
	
## Datasets
* Cell trajectory: https://zenodo.org/record/1443566 (also available from "Data" folder)

## Run
* Folder "Scripts": contains the code (R) for producing the cell trajectory visualization prior to the experiments section in the main paper.
* Folder "Experiments": contains all code (R + Python) for producing the results in the experiments
section of the main paper, with files named accordingly.

### R
* Open file in Rstudio 
* Source --> Source with Echo (ctrl + shift + enter).

### Python 
* Open file in Jupyter notebook
* Cell --> Run Cells (ctrl + enter).

## Results
* Folder "Output": contains all output by code block in PDF format, with files named accordingly.