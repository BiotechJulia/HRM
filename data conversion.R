# Set working directory
setwd(choose.dir(getwd()))

# From StepOne Software export "Melt Region Temperature Data" and "Melt Region Normalized Data", File type: .txt. 
# Then open each file in notepad and remove first rows: 
# * Block Type = 96well
# * Chemistry = SYBR_GREEN
# * Experiment File Name = xxx.eds
# * Experiment Run End Time = xxx
# * Instrument Type = steponeplus
# * Passive Reference = 
#   
#   [Melt Region Temperature Data]
# 
# Then save changes and read temperature data in .txt format (tab delimited)
df <- read.delim(choose.files())

temp <- df[-1][-2][-2]

df <- t(temp)
colnames(df) <- df[1,]
df <- as.data.frame(df[-1, ])
temperature_means <- colMeans(temp[-1])

# Now read normalized data
df2 <- read.delim(choose.files())
fluo <- df2[5:length(df2)]
colnames(fluo) <- temperature_means
data <- cbind(df2$Well.Location, fluo)
t <- t(data)
colnames(t)<- t[1,]
t2 <- as.data.frame(t[-1, ])

myDF <- cbind(Temperature = rownames(t2), t2)
rownames(myDF) <- NULL

# Save data in csv format
write.csv(myDF, "HRM.csv", row.names = F)
