# Set working directory
setwd(choose.dir(getwd()))

# Read data in .csv format (comma delimited)
df <- read.csv(choose.files())

# Install and load required packages
install.packages(c("ggplot2", "reshape2", "dplyr"))
library(ggplot2)
library(reshape2)
library(dplyr)

# Convert data to long format
d <- melt(df, id.vars="Temperature")

# Plot data to select temperature range 
ggplot(d, aes(Temperature,value, col=variable)) + 
  geom_point() + 
  stat_smooth() 

# Define temperature range and reference sample column - you can use wild-type or mutant as reference. In sample dataset C10 is WT reference and F1 is mutant reference
min_tm_hrm <- 75
max_tm_hrm <- 90
ref_column <- "C10"

# Filter the data for selected temperature range
df2 <- df %>%
  dplyr::filter(Temperature>min_tm_hrm) %>%
  dplyr::filter(Temperature<max_tm_hrm)

# Remove selected columns
drops <- c("B11","D1") # select columns to remove
df2 <- df2[ , !(names(df2) %in% drops)]

# Plot data for selected temperature range 
d2 <- melt(df2, id.vars="Temperature")

ggplot(d2, aes(Temperature,value, col=variable)) + 
  geom_point() + 
  stat_smooth() 

# Normalize the data
normalize <- function(x, na.rm = TRUE) {
  return((x- min(x)) /(max(x)-min(x))*100)
}

d3 <- as.data.frame(lapply(df2[2:length(df2)], normalize))

Temperature <- df2$Temperature
d4 <- cbind(Temperature, d3)

# Plot normalized data
d5 <- melt(d4, id.vars="Temperature")

ggplot(d5, aes(Temperature,value, col=variable)) + 
  geom_point() + 
  stat_smooth() 

# Calculate differences from the reference sample
df_ref <- d4 %>%
  select(all_of(ref_column))

diff <- d4[2:length(d4)] - df_ref[,1]
diff2 <- cbind(Temperature, diff)

# Plot the difference plot
d6 <- melt(diff2, id.vars="Temperature")

ggplot(d6, aes(Temperature,value, col=variable)) + 
  geom_point() + 
  stat_smooth() 

# Cluster data
t <- t(diff2[2:length(diff2)])
CLUSTERS2 <- kmeans(t, 3, iter.max = 10, nstart = 1)
CLUSTERS2

# Add clusters to data
clu2 <- CLUSTERS2$cluster
mlt <- melt(diff2[2:length(diff2)])

xx <- mlt %>%
  group_by(variable) %>%
  summarise(
    value = mean(value, na.rm = TRUE)
  )

mrg <- cbind(xx, clu2)
mrg2 <- merge(mrg, d6, by="variable")

# Plot the difference plot colored by clusters
mrg2$clu2 <- as.factor(mrg2$clu2) # this is needed to avoid continuous scale for coloring
ggplot(mrg2, aes(Temperature,value.y, col=clu2)) + 
  geom_point()

# Publication-ready plot
# set size of text - e.g., for plots in Plant Physiology text should be between 6 to 8 points


p <- ggplot(mrg2, aes(Temperature, value.y, colour=clu2)) + 
  stat_smooth(aes(group = variable), se=F, size=0.5) +
  labs(title="Difference curve", x=expression(paste("Temperature [",degree, "C]")), y = expression(paste(Delta, " Fluorescence"))) +
  theme_classic(base_size = 6) +
  theme(axis.text.y = element_text(color="black", size = 6),
        axis.text.x = element_text(color="black", size = 6),
        text = element_text(size = 6),
        legend.text=element_text(size=6),
        legend.position = c(0.85, 0.2), # adjust legend position depending on the plot - first value defines position on X axis (from 0 to 1), second on Y axis
        legend.background=element_rect(fill = alpha("white", 0)),
        plot.title = element_text(size = 8),
        axis.line = element_line(colour = 'black', size = 0.5),
        axis.ticks = element_line(colour = "black", size = 0.5))+ 
  scale_x_continuous(expand = c(0, 0)) + # you can adjust breaks: scale_x_continuous(expand = c(0, 0), breaks = c(75, 77, 79, 81, 83, 85,87, 89))
  scale_y_continuous(expand = c(0, 0)) + # you can set limits: scale_y_continuous(expand = c(0, 0), limits = c(-0.025, 0.1))
  geom_hline(yintercept = 0, size=0.5, linetype = 3) + # this is horizontal dotted line on 0 y value
  scale_color_manual(name = "Group",
                     values = c( "1" = "#D81B60", "2" = "#FFC107", "3" = "#004D40"),     # adjust colors (REMEMBER ABOUT COLOR VISION-DEFICIENT READERS) and labels
                     labels = c("mutant", "hetero", "wt")) # Rename them according to your references!

p

# Save plot as vector graphic (svg, can be further edited e.g. in Inkscape or converted to pdf) and raster graphic (jpg)
outputfile1 <- "test.svg"
outputfile2 <- "test.jpeg"

svg(filename = outputfile1, width = 3.4, height = 2.5)                     # szerokosc 3.4 1 lam, 5 1.5 lamu, 6.7 2 lamy
p
dev.off()

jpeg(outputfile2, width = 3.4,
     height    = 2.5,
     units     = "in",
     res       = 600,
     pointsize = 6)
p
dev.off()

# Save cluster assignment as .csv file
clustering.data <- as.data.frame(clu2)
write.csv(clustering.data, "clustering_data.csv")
