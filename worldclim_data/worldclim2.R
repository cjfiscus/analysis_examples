#!/usr/bin/env Rscript
# Extract worldclim2 data
# cjfiscus
# 9/8/19

options(stringsAsFactors = F)
library(pacman)
p_load(raster)

# download worldclim2 bio variables at http://worldclim.org/version2 at desired resolution
# 30s is highest resolution but file is large (~19GB)

# set to directory containing data (.tif files)
files<-list.files("~/Downloads/wc2/", ".tif", full.names=T)
rasterStack<-stack(files)

# read in df with coordinates and sample ids
df<-read.delim("~/Google Drive/scratch/Final_Analyses/data/1001_Genomes_2016.txt")

# make sample ids rownames, must be LON, LAT
samples<-df[,c("id", "longitude", "latitude")]
row.names(samples)<-samples$id
samples$id<-NULL

# extract worldclim data for coordinates
worldclimData<-as.data.frame(cbind(row.names(samples), extract(rasterStack, samples)))
names(worldclimData)<-c("ID", "BIO1", "BIO2", "BIO3", "BIO4", "BIO5", "BIO6", 
                        "BIO7", "BIO8", "BIO9", "BIO10", "BIO11", "BIO12", 
                        "BIO13", "BIO14", "BIO15", "BIO16", "BIO17", "BIO18", "BIO19")

# write out variable key
variables<-c("BIO1", "BIO2", "BIO3", "BIO4", "BIO5", "BIO6", 
             "BIO7", "BIO8", "BIO9", "BIO10", "BIO11", "BIO12", 
             "BIO13", "BIO14", "BIO15", "BIO16", "BIO17", "BIO18", "BIO19")
keys<-c("Annual Mean Temperature", 
        "Mean Diurnal Range (Mean of monthly (max temp - min temp))",
        "Isothermality (BIO2/BIO7) (* 100)",
        "Temperature Seasonality (standard deviation *100)",
        "Max Temperature of Warmest Month",
        "Min Temperature of Coldest Month",
        "Temperature Annual Range (BIO5-BIO6)",
        "Mean Temperature of Wettest Quarter", 
        "Mean Temperature of Driest Quarter",
        "Mean Temperature of Warmest Quarter", 
        "Mean Temperature of Coldest Quarter",
        "Annual Precipitation",
        "Precipitation of Wettest Month",
        "Precipitation of Driest Month",
        "Precipitation Seasonality (Coefficient of Variation)",
        "Precipitation of Wettest Quarter",
        "Precipitation of Driest Quarter",
        "Precipitation of Warmest Quarter",
        "Precipitation of Coldest Quarter")

variableKey<-as.data.frame(cbind(variables, keys))
write.table(variableKey, "~/Desktop/worldclim2_variables.txt", sep="\t", quote=F, col.names=F, row.names=F)

# write out worldclimData
write.table(worldclimData,"~/Desktop/clim_data.txt", sep="\t", quote=F, row.names=F)
