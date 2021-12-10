******************************************************************************************
***************** FOR REVIEWING PURPOSES ONLY. PLEASE DO NOT DISTRIBUTE. *****************
******************************************************************************************

NOTE: DROPBOX SUBMISSION IS TEMPORARY (FOR ANONYMITY)
FINAL CODE WILL BE SHARED THROUGH GITHUB

This folder contains the Appendix and source code for AISTATS submission 397: 
The Curse Revisited:  When are Distances Informative for theGround Truth in Noisy High-Dimensional Data?

******************************************************************************************
****************************************** Setup *****************************************
******************************************************************************************

- Enviroments: R (Rstudio) & Python (jupyter notebook)

- R Requirements: 
	- ggplot2 (general plotting)
	- igraph (working with graphs)
	- ggpubr (combining plots)
	- FNN (fast k-NN graph computation)
	- parallel (parallel processing in R)
	- umap (umap dimensionality reduction)
	- diffusionMap (diffusion map dimensionality reduction)
	- rpca (Robust PCA dimensionality reduction)
	- dimRed (Isomap dimensionality reduction)

- Python requirements:
	- numpy (handling arrays)
	- pandas (handling data frames)
	- pytorch (neural networks in Python)
	- matplotlib (plotting)

******************************************************************************************
**************************************** Datasets ****************************************
******************************************************************************************

- Cell trajectory: https://zenodo.org/record/1443566 (also available from "Data" folder)

******************************************************************************************
****************************************** Run *******************************************
******************************************************************************************

In Rstudio: Source --> Source with Echo (ctrl + shift + enter).

	- CellTrajectory.R: 	R code for Figure 1 in the main paper.
	- ConfirmCLT.R: 	R code for validating Theorem 2.1 in the main paper. 
				These results are discussed in Appendix A.
	- RandomByAlpha.R: 	R code for validating Corollary 2.3 and Remark 2.4 in the main paper. 
				These results are discussed in Section 3.1.
	- DimredByAlpha.R: 	R code for our results discussed in Section 3.2 of the main paper.
				Code to obtain the performances is commented out by standard.
				These are stored in the "Results" folder and are loaded by the script.

In Python Jupyter notebook: Cell --> Run Cells (ctrl + enter).

	- AutoEncoderByAlpha.ipynb: Similar as "DimredByAlpha.R", but only for the autoencoder model and in Python.

******************************************************************************************
**************************************** Results *****************************************
******************************************************************************************

- OutputPDF: contains all output by code block in PDF format, with files named accordingly.
- Results: contains the stored performances for the results discussed in Section 3.2 of the main paper.
