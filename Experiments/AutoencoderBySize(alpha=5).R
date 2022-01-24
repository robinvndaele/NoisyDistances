setwd("..")

### Load libraries ###

library("ggplot2") # general plotting

### We study how high-dimensional noise affects the autoencoder dimensionality reduction ###

cors_auto <- read.table("Results/Size/AUTO_alpha5.csv", # load the results
                        sep=",", row.names=1, header=TRUE)
ggplot(data=cors_auto, aes(x=dim, y=cor, color=factor(size))) +
  geom_line() +
  geom_point() +
  scale_x_log10() +
  ylab("correlation") +
  labs(col="data size") +
  ggtitle("AutoEncoder") +
  theme_classic() +
  theme(text=element_text(size=15), plot.title=element_text(hjust=0.5, size=15),
        legend.title=element_text(size=12), legend.text=element_text(size=10))
