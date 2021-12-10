setwd("..")

### Load libraries ###

library("parallel") # parallel processing
library("ggplot2") # general plotting
library("ggpubr") # combining plots
library("umap") # get default umap parameters to change to 1 component

### Specify the experiment parameters ###

set.seed(17) # seed for reproducibility
ntimes <- 100 # number of noise replicates to investigate dimred performance
npoints <- 25 # number of points in our ground truth data set to be investigated
maxdim <- 10000 # maximal dimension of the data set to be investigated
dims <- round(exp(seq(log(2), log(maxdim), length.out=10))) # dimensions to study from log-scale
a <- 1.25 # magnitude of noise: per dimension we sample noise uniformly from [-a, a]
alphas <- c(seq(2, 6, by=1), Inf) # factors controling the growth rate of the ground truth diameters

### Construct the ground data sets according to the growth rates ###

t <- seq(0, 1, length.out=npoints)
datasets <- lapply(alphas, function(alpha){
  if(alpha==Inf) factor <- rep(1, maxdim) else factor <- (1:maxdim)**(-1 / alpha)
  data.frame(sapply(factor, function(f) t * f))
})

# ### Setup clusters for parallel experiments ###

# n.cores <- detectCores()
# clust <- makeCluster(n.cores)
# clusterExport(clust, c("datasets",  "maxdim", "dims", "npoints", "a" , "t"))
# clusterEvalQ(clust, library("diffusionMap")) # diffusion map dimensionality reduction
# clusterEvalQ(clust, library("umap")) # UMAP dimensionality reduction
# clusterEvalQ(clust, library("rpca")) # Robust PCA dimensionality reduction
# clusterEvalQ(clust, library("dimRed")) # Isomap dimensionality reduction

### We view the magnitude of noise and PCA projection for an example dataset ###

idx <- 6
XN <- datasets[[idx]][,1:2] + matrix(runif(2 * npoints, min=-a, max=a), ncol=2)
PCA <- data.frame(PC1=prcomp(XN, rank.=1)$x, PC2=0)

P1 <- ggplot(datasets[[idx]], aes(x=X1, y=X2)) +
  geom_point(size=3, aes(col=t)) +
  scale_colour_gradientn(colours=topo.colors(7)) +
  labs(col="true order") +
  ggtitle("without noise") +
  theme_bw() +
  theme(text=element_text(size=10), plot.title=element_text(hjust=0.5, size=12))

P2 <- ggplot(XN, aes(x=X1, y=X2)) +
  geom_point(size=3, aes(col=t)) +
  scale_colour_gradientn(colours=topo.colors(7)) +
  labs(col="true order") +
  ggtitle("with noise") +
  theme_bw() +
  theme(text=element_text(size=10), plot.title=element_text(hjust=0.5, size=12))

P3 <- ggplot(PCA, aes(x=PC1, y=PC2)) +
  geom_point(size=3, aes(col=t)) +
  scale_colour_gradientn(colours=topo.colors(7)) +
  ylab("") +
  labs(col="true order") +
  ggtitle("PCA") +
  theme_bw() +
  theme(text=element_text(size=10), plot.title=element_text(hjust=0.5, size=12),
        axis.ticks.y=element_blank(), axis.text.y=element_blank())

ggarrange(P1, P2, P3, ncol=3, common.legend=TRUE, legend="right")

### We study how high-dimensional noise affects the PCA dimensionality reduction ###

# set.seed(13) # seed for reproducibility
# cors_pca  <- Reduce("+", parLapply(clust, 1:ntimes, function(n){
#   N <- matrix(runif(maxdim * npoints, min=-a, max=a), ncol=maxdim)
#   sapply(datasets, function(X){
#     XN <- X + N
#     sapply(dims, function(this_dim){
#       PCA <- prcomp(XN[,1:this_dim], rank.=1)$x[,1]
#       max(cor(PCA, t), cor(PCA[rev(1:npoints)], t))
#     })
#   })
# })) / ntimes
# cors_pca <- data.frame(alpha=rep(alphas, each=length(dims)),
#                        dim=rep(dims, length(alphas)),
#                        cor=as.numeric(cors_pca))
# saveRDS(cors_pca, file="Results/Alpha/PCA.rds") # store the results

cors_pca <- readRDS("Results/Alpha/PCA.rds") # load the results
P1 <- ggplot(data=cors_pca, aes(x=dim, y=cor, color=factor(alpha))) +
  geom_line() +
  geom_point() +
  scale_x_log10() +
  ylab("correlation") +
  labs(col="alpha") +
  ggtitle("PCA") +
  theme_classic() +
  theme(text=element_text(size=15), plot.title=element_text(hjust=0.5, size=15),
        legend.title=element_text(size=20), legend.text=element_text(size=20)); P1

### We study how high-dimensional noise affects the UMAP dimensionality reduction ###

# custom.config <- umap.defaults
# custom.config$n_components <- 1
# clusterExport(clust, "custom.config")
# set.seed(13) # seed for reproducibility
# cors_umap  <- Reduce("+", parLapply(clust, 1:ntimes, function(n){
#   N <- matrix(runif(maxdim * npoints, min=-a, max=a), ncol=maxdim)
#   sapply(datasets, function(X){
#     XN <- X + N
#     sapply(dims, function(this_dim){
#       UMAP <- umap(XN[,1:this_dim], config=custom.config)$layout[,1]
#       max(cor(UMAP, t), cor(UMAP[rev(1:npoints)], t))
#     })
#   })
# })) / ntimes
# cors_umap <- data.frame(alpha=rep(alphas, each=length(dims)),
#                         dim=rep(dims, length(alphas)),
#                         cor=as.numeric(cors_umap))
# saveRDS(cors_umap, file="Results/Alpha/UMAP.rds") # store the results

cors_umap <- readRDS("Results/Alpha/UMAP.rds") # load the results
P2 <- ggplot(data=cors_umap, aes(x=dim, y=cor, color=factor(alpha))) +
  geom_line() +
  geom_point() +
  scale_x_log10() +
  ylab("correlation") +
  labs(col="alpha") +
  ggtitle("UMAP") +
  theme_classic() +
  theme(text=element_text(size=15), plot.title=element_text(hjust=0.5, size=15),
        legend.title=element_text(size=20), legend.text=element_text(size=20)); P2

### We study how high-dimensional noise affects the diffusion map dimensionality reduction ###

# set.seed(13) # seed for reproducibility
# cors_diff  <- Reduce("+", parLapply(clust, 1:ntimes, function(n){
#   N <- matrix(runif(maxdim * npoints, min=-a, max=a), ncol=maxdim)
#   sapply(datasets, function(X){
#     XN <- X + N
#     sapply(dims, function(this_dim){
#       invisible(capture.output(DM <- suppressWarnings(diffuse(dist(XN[,1:this_dim]), maxdim=1)$X)))
#       max(cor(DM, t), cor(DM[rev(1:npoints)], t))
#     })
#   })
# })) / ntimes
# cors_diff <- data.frame(alpha=rep(alphas, each=length(dims)),
#                         dim=rep(dims, length(alphas)),
#                         cor=as.numeric(cors_diff))
# saveRDS(cors_diff, file="Results/Alpha/DIFFM.rds") # store the results

cors_diff <- readRDS("Results/Alpha/DIFFM.rds") # load the results
P3 <- ggplot(data=cors_diff, aes(x=dim, y=cor, color=factor(alpha))) +
  geom_line() +
  geom_point() +
  scale_x_log10() +
  ylab("correlation") +
  labs(col="alpha") +
  ggtitle("DiffusionMap") +
  theme_classic() +
  theme(text=element_text(size=15), plot.title=element_text(hjust=0.5, size=15),
        legend.title=element_text(size=20), legend.text=element_text(size=20)); P3

### We study how high-dimensional noise affects the robust PCA dimensionality reduction ###

# set.seed(13) # seed for reproducibility
# cors_rpca  <- Reduce("+", parLapply(clust, 1:ntimes, function(n){
#   N <- matrix(runif(maxdim * npoints, min=-a, max=a), ncol=maxdim)
#   sapply(datasets, function(X){
#     XN <- as.matrix(X + N)
#     sapply(dims, function(this_dim){
#       RPCA <- rpca(XN[,1:this_dim])
#       RPCA <- RPCA$L.svd$u[,1] * RPCA$L.svd$d[1]
#       max(cor(RPCA, t), cor(RPCA[rev(1:npoints)], t))
#     })
#   })
# })) / ntimes
# cors_rpca <- data.frame(alpha=rep(alphas, each=length(dims)),
#                         dim=rep(dims, length(alphas)),
#                         cor=as.numeric(cors_rpca))
# saveRDS(cors_rpca, file="Results/Alpha/RPCA.rds") # store the results

cors_rpca <- readRDS("Results/Alpha/RPCA.rds") # load the results
P4 <- ggplot(data=cors_rpca, aes(x=dim, y=cor, color=factor(alpha))) +
  geom_line() +
  geom_point() +
  scale_x_log10() +
  ylab("correlation") +
  labs(col="alpha") +
  ggtitle("Robust PCA") +
  theme_classic() +
  theme(text=element_text(size=15), plot.title=element_text(hjust=0.5, size=15),
        legend.title=element_text(size=20), legend.text=element_text(size=20)); P4

### We study how high-dimensional noise affects the robust PCA dimensionality reduction ###
### The experiments are conducted in Python and the results are loaded in R for plotting ###

cors_auto <- read.table("Results/Alpha/AUTO.csv", # load the results
                        sep=",", row.names=1, header=TRUE)
P5 <- ggplot(data=cors_auto, aes(x=dim, y=cor, color=factor(alpha))) +
  geom_line() +
  geom_point() +
  scale_x_log10() +
  ylab("correlation") +
  labs(col="alpha") +
  ggtitle("AutoEncoder") +
  theme_classic() +
  theme(text=element_text(size=15), plot.title=element_text(hjust=0.5, size=15),
        legend.title=element_text(size=20), legend.text=element_text(size=20)); P5

### We study how high-dimensional noise affects the Isomap dimensionality reduction ###

# set.seed(13) # seed for reproducibility
# cors_iso  <- Reduce("+", parLapply(clust, 1:ntimes, function(n){
#   N <- matrix(runif(maxdim * npoints, min=-a, max=a), ncol=maxdim)
#   sapply(datasets, function(X){
#     XN <- X + N
#     sapply(dims, function(this_dim){
#       ISO <- embed(XN[,1:this_dim], "Isomap", knn=10, ndim=1, .mute=c("message"))@data@data[,1]
#       max(cor(ISO, t), cor(ISO[rev(1:npoints)], t))
#     })
#   })
# })) / ntimes
# cors_iso <- data.frame(alpha=rep(alphas, each=length(dims)),
#                        dim=rep(dims, length(alphas)),
#                        cor=as.numeric(cors_iso))
# saveRDS(cors_iso, file="Results/Alpha/ISO.rds") # store the results

cors_iso <- readRDS("Results/Alpha/ISO.rds") # load the results
P6 <- ggplot(data=cors_iso, aes(x=dim, y=cor, color=factor(alpha))) +
  geom_line() +
  geom_point() +
  scale_x_log10() +
  ylab("correlation") +
  labs(col="alpha") +
  ggtitle("Isomap") +
  theme_classic() +
  theme(text=element_text(size=15), plot.title=element_text(hjust=0.5, size=15),
        legend.title=element_text(size=20), legend.text=element_text(size=20)); P6

### Finally, we combine the plots for comparison ###

ggarrange(P1, P2, P3, P4, P5, P6, nrow=2, ncol=3, common.legend=TRUE)
