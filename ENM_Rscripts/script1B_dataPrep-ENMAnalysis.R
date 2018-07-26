#!/usr/bin/env Rscript

#Orig name: 1.b Load-prepare data and modeling ENMwizard.R

##########################################################################################
#
# I. SETUP.
#
##########################################################################################

############## PACKAGES

## Load needed packages, R code, or other prelim stuff. Install packages if not present.
packages <- c('devtools', 'ENMeval', 'raster', 'sp', 'rgeos', 'rgdal')
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
    install.packages(setdiff(packages, rownames(installed.packages())))
}
devtools::install_github("HemingNM/ENMwizard")
## If needed:
# devtools::install_github("danlwarren/ENMTools")
# devtools::install_github("mlammens/spThin")

library(ENMwizard)
library(raster)
library(rgeos)
library(sp)
library(rgdal)
library(spThin)}

############## SET PATHS TO DIR, FILES, etc.

setwd('/path/to/working/dir')
path2files <- "path/to/your/files"

############## DATA

## Load NewWorld shapefile
NewWorld <- shapefile(paste0(path2files,"/shapes/NWCountries/NWCountries.shp"))
crs.set <- crs(NewWorld)

## Load and check occurrence data
Aspen1 <- read.csv("Presence_Data/Ptremuloides_GBIF_plus_ours_n275.csv")
Aspen2 <- read.csv("Presence_Data/Ptrem_1s.csv")
head(Aspen1)
head(Aspen2)
Aspen2$Species <- "Populus_tremuloides"
Aspen2$Ptrem <- NULL
colnames(Aspen2)[1:2] <- c("Longitude", "Latitude")
head(Aspen2)
Aspen <- gtools::smartbind(Aspen1, Aspen2)
head(Aspen)
summary(Aspen)
write.csv(Aspen,"Presence_Data/Ptrem_Merged_records_UNsampled_UNfiltered.csv")
rm(Aspen1, Aspen2)

spp.occ.list <- list(Aspen = Aspen)

##########################################################################################
#
# II. PREPARE ENVIRONMENTAL DATA.
#
##########################################################################################

##### A. Prepare enviromental data layers
##### A.1 Create occurrence polygon to crop rasters prior to modelling:
occ.polys <- poly.c.batch(spp.occ.list)

##### B.1 Creating buffer:
occ.b <- bffr.batch(occ.polys, bffr.width = 1.5)

##### C.1 Cut enviromental layers with M and save in hardrive:
path.env <- paste0(path2files,"/ClimaticScenarios/PR/WorldClim/2_5min/bio_2-5m_bil")
current <- brick(paste(path.env, "bio.grd", sep="/"))
occ.b.env <- env.cut(occ.b, current)

# occ.polys <- occ_polys
# occ.b.env <- occ_b_env
# occ.b <- occ_b

##### D. Projection Area (P.A.)
##### D.1 Polygon for P.A.:
proj.pol <- pred.a.poly.batch(occ.polys, deg.incr = 7)
plot(proj.pol$Aspen)
plot(NewWorld, add=T)

##### D.2 Crop P.A. based on polygon:
## Requires the following datasets (from script1A also)
# (1) For Mid-Holocene (HLC; about 6000 years ago): 
# 1.1: MIROC-ESM: http://biogeo.ucdavis.edu/data/climate/cmip5/mid/mrmidbi_2-5m.zip
# 1.2: MPI-ESM-P: http://biogeo.ucdavis.edu/data/climate/cmip5/mid/memidbi_2-5m.zip 
# 1.3: CCSM4: http://biogeo.ucdavis.edu/data/climate/cmip5/mid/ccmidbi_2-5m.zip 
# 1.4: IPSL-CM5A-LR: http://biogeo.ucdavis.edu/data/climate/cmip5/mid/ipmidbi_2-5m.zip 
# 
# (2) For the Last Glacial Maximum (LGM; about 22,000 years ago):
# 2.1: MIROC-ESM: http://biogeo.ucdavis.edu/data/climate/cmip5/lgm/mrlgmbi_2-5m.zip
# 2.2: MPI-ESM-P: http://biogeo.ucdavis.edu/data/climate/cmip5/lgm/melgmbi_2-5m.zip 
# 2.3: CCSM4: http://biogeo.ucdavis.edu/data/climate/cmip5/lgm/cclgmbi_2-5m.zip 
# 
# (3) Last inter-glacial (LIG; ~120,000 - 140,000 years BP): 
# 3.1: LIG-CCSM3: http://biogeo.ucdavis.edu/data/climate/worldclim/1_4/grid/pst/lig/lig_30s_bio.zip

proj.scn <- list(current = current,
                 HLCmrmidbi = brick(paste0(path2files,"/ClimaticScenarios/PA/mrmidbi_2-5m/mrmidbi_NW.grd"))[[-c(10:11)]],
                 HLCmemidbi = brick(paste0(path2files,"/ClimaticScenarios/PA/memidbi_2-5m/memidbi_NW.grd"))[[-c(10:11)]],
                 HLCccmidbi = brick(paste0(path2files,"/ClimaticScenarios/PA/ccmidbi_2-5m/ccmidbi_NW.grd"))[[-c(10:11)]],
                 HLCipmidbi = brick(paste0(path2files,"/ClimaticScenarios/PA/ipmidbi_2-5m/ipmidbi_NW.grd"))[[-c(10:11)]],
                 LGMmrlgmbi = brick(paste0(path2files,"/ClimaticScenarios/PA/mrlgmbi_2-5m/mrlgmbi_NW.grd"))[[-c(10:11)]],
                 LGMmelgmbi = brick(paste0(path2files,"/ClimaticScenarios/PA/melgmbi_2-5m/melgmbi_NW.grd"))[[-c(10:11)]],
                 LGMcclgmbi = brick(paste0(path2files,"/ClimaticScenarios/PA/cclgmbi_2-5m/cclgmbi_NW.grd"))[[-c(10:11)]],
                 LIGlig_30s = brick(paste0(path2files,"/ClimaticScenarios/PA/lig_30s_bio/lig_30s_bio__NW.grd"))[[-c(10:11)]]
)

proj.scn
### chech whether or not all env. datasets have the same names
sapply(seq_along(proj.scn), function(i, proj.scn) names(proj.scn[[i]]), proj.scn)

Aspen.aproj <- pred.a.batch.mscn(proj.pol, proj.scn, numCores = 2)

### check if layers of projection areas have the same names
sapply(seq_along(Aspen.aproj$Aspen), function(i, Aspen.aproj) names(Aspen.aproj$Aspen[[i]]), Aspen.aproj)


##########################################################################################
#
# III. FILTER ORIGINAL OCCURRENCES DATASET USING spThin.
#
##########################################################################################

##### A. Thin occurrences
# occ.locs <- thin.batch(spp.occ.list, dist = 10000, nrep = 1, great.circle.distance = TRUE)
occ.locs <- thin.batch(spp.occ.list, thin.par = 10, reps = 1)
occ.locs <- loadTocc(occ.locs)

write.csv(as.data.frame(occ.locs$Aspen),"Presence_Data/Ptrem_Merged_records_spThin.filtered.csv", row.names=F)

# # occ.locs <- list()
# # occ.locs$Aspen <- read.csv("Presence_Data/Ptrem_Merged_records_spThin.filtered.csv")


##########################################################################################
#
# IV. TUNING PARAMETERS FOR MAXENT ECOLOGICAL NICHE MODELING.
#
##########################################################################################

#### A. Tuning Maxent's feauture classes (FCs) and regularization multiplier (RM) via 
####    ENMeval analysis
#### A.1 First, load specific packages, just in case:
library(ENMeval)
library(rJava)
library(dismo)

#### A.2 Run ENMevaluate:
ENMeval_res.lst <- ENMevaluate.batch(occ.locs, occ.b.env, 
                                     RMvalues = seq(0.5, 4, 0.5), 
                                     fc = c("L", "P", "Q", "H",
                                            "LP", "LQ", "LH",
                                            "PQ", "PH", "QH",
                                            "LPQ", "LPH", "LQH", "PQH",
                                            "LPQH"), # , "LPQHT"
                                     method = "block",
                                     parallel = T, numCores = 7)

saveRDS(ENMeval_res.lst, file = "3_out.MaxEnt/ENMeval_res.rds")
# ENMeval_res.lst <- list()
# ENMeval_res.lst$Aspen <- readRDS(file = "3_out.MaxEnt/ENMeval_res.rds")


##########################################################################################
#
# V. ECOLOGICAL NICHE MODELING CALIBRATION IN MAXENT.
#
##########################################################################################

#### A.1 Run top corresponding models:
mxnt.mdls.preds.cf <- mxnt.c.batch(ENMeval.o.l = ENMeval_res.lst, 
                                    a.calib.l = occ.b.env, occ.l = occ.locs,
                                    mSel = "LowAIC")

mxnt.mdls.preds.cf$Aspen$ENMeval.results

rm(ENMeval_res.lst) # remove large ENMeval object from R memory


#### A.2 Run projections for present and past climatic scenarios:
mxnt.mdls.preds.cf <- mxnt.p.batch.mscn(mxnt.mdls.preds.cf, 
                                        a.proj.l = Aspen.aproj,
                                        numCores = 3)

names(mxnt.mdls.preds.cf$Aspen$mxnt.preds)
# 4.8.5 threshold for current and future pred
# options: ("fcv1", "fcv5", "fcv10", "mtp", "x10ptp", "etss", "mtss", "bto", "eetd")
mods.thrshld.lst <- f.thr.batch(mxnt.mdls.preds.cf, thrshld.i = 5)

mxnt.mdls.preds.cf$Aspen$mxnt.mdls[[1]]@results


#### A.3 Plot results for various climatic scenarios:
## Recall datasets are:
# (1) For Mid-Holocene (HLC; about 6000 years ago): 
# 1.1: MIROC-ESM: http://biogeo.ucdavis.edu/data/climate/cmip5/mid/mrmidbi_2-5m.zip
# 1.2 MPI-ESM-P: http://biogeo.ucdavis.edu/data/climate/cmip5/mid/memidbi_2-5m.zip 
# 1.3: CCSM4: http://biogeo.ucdavis.edu/data/climate/cmip5/mid/ccmidbi_2-5m.zip 
# 1.4: IPSL-CM5A-LR: http://biogeo.ucdavis.edu/data/climate/cmip5/mid/ipmidbi_2-5m.zip 
# 
# (2) For the Last Glacial Maximum (LGM; about 22,000 years ago):
# 2.1: MIROC-ESM: http://biogeo.ucdavis.edu/data/climate/cmip5/lgm/mrlgmbi_2-5m.zip
# 2.2: MPI-ESM-P: http://biogeo.ucdavis.edu/data/climate/cmip5/lgm/melgmbi_2-5m.zip 
# 2.3: CCSM4: http://biogeo.ucdavis.edu/data/climate/cmip5/lgm/cclgmbi_2-5m.zip 
# 
# (3) Last inter-glacial (LIG; ~120,000 - 140,000 years BP): 
# 3.1: LIG-CCSM3: http://biogeo.ucdavis.edu/data/climate/worldclim/1_4/grid/pst/lig/lig_30s_bio.zip
#
## List of dataset names:
# "current"    
# "HLCmrmidbi" "HLCmemidbi" "HLCccmidbi" "HLCipmidbi" 
# "LGMmrlgmbi" "LGMmelgmbi" "LGMcclgmbi"
# "LIGlig_30s"

breaks <- seq(0, 1, .01)
colors <- colorRampPalette(c("gray", "yellow", "olivedrab1", "green4", "darkgreen"))(length(breaks))

pdf("figs/AspenProjections.10ptp.pdf", height = 12, width = 12)
par(mfrow = c(3,3), mar = c(2,2.5,2,2.5), oma = c(1,1,1,1)) #  
plot(mods.thrshld.lst$Aspen$current$continuous$x10ptp, col = colors, main = "current")

plot(mods.thrshld.lst$Aspen$HLCmrmidbi$continuous$x10ptp, col = colors, main = "HLC: MIROC-ESM")
plot(mods.thrshld.lst$Aspen$HLCmemidbi$continuous$x10ptp, col = colors, main = "HLC: MPI-ESM-P")
plot(mods.thrshld.lst$Aspen$HLCccmidbi$continuous$x10ptp, col = colors, main = "HLC: CCSM4")
plot(mods.thrshld.lst$Aspen$HLCipmidbi$continuous$x10ptp, col = colors, main = "HLC: IPSL-CM5A-LR")

plot(mods.thrshld.lst$Aspen$LGMmrlgmbi$continuous$x10ptp, col = colors, main = "LGM: MIROC-ESM")
plot(mods.thrshld.lst$Aspen$LGMmelgmbi$continuous$x10ptp, col = colors, main = "LGM: MPI-ESM-P")
plot(mods.thrshld.lst$Aspen$LGMcclgmbi$continuous$x10ptp, col = colors, main = "LGM: CCSM4")

plot(mods.thrshld.lst$Aspen$LIGlig_30s$continuous$x10ptp, col = colors, main = "LIG: CCSM3")
dev.off()


##########################################################################################
#
# IV. CALCULATE METRICS (VAR CONTRIBUTION AND IMPORTANCE, TOTAL AREA).
#
##########################################################################################

#### A.1 Compute variable contribution and importance:
f.var.ci(mxnt.mdls.preds.cf)

#### A.2 Compute "Fractional predicted area" ('n of occupied pixels'/n) for multiple scenarios:
f.FPA(mods.thrshld.lst)

#### A.3 Compute "Omission Rate":
f.OR(mods.thrshld.lst, occ.locs)

#### A.4 Compute species total suitable area:
f.area.occ.mscn(mods.thrshld.lst)


