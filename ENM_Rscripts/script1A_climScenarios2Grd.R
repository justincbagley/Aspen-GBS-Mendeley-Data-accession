#!/usr/bin/env Rscript

#Orig name: 1.a save ClimScenarios as grd files.R

##########################################################################################
#
# I. SETUP.
#
##########################################################################################

############## DATA

## Download links for climatic scenarios. MUST download the following datasets outside of 
## R, before editing or running this script.
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

############## PACKAGES

library(raster)

############## SET PATHS TO DIR, FILES, etc.

path2files <- "path/to/your/files"
NewWorld <- shapefile(paste0(path2files,"/shapes/NWCountries/NWCountries.shp"))

path.scn <- paste0(path2files, "/ClimaticScenarios/PA")
scn.nm <- c("mrmidbi_2-5m", "memidbi_2-5m", "ccmidbi_2-5m", "ipmidbi_2-5m", "mrlgmbi_2-5m", "melgmbi_2-5m",
  "cclgmbi_2-5m", "lig_30s_bio")
lr.nm <- gsub("_2-5m", "", scn.nm)


##########################################################################################
#
# II. CONVERT CLIMATE SCENARIO FILES TO GRD FILES.
#
##########################################################################################

for(i in seq_along(scn.nm)){
	PA.scn <- stack(list.files(paste(path.scn, scn.nm[i], sep="/"), full.names=T))
	names(PA.scn) <- gsub(lr.nm, "bio", names(PA.scn))
	PA.scn <- crop(PA.scn, NewWorld)
	writeRaster(PA.scn, paste0(path.scn, scn.nm[i],"/", lr.nm,"_NW.grd"),
            overwrite=T)
}

## Check whether names are correct upon file load:
PA.scn <- brick(paste0(path.scn, "/ipmidbi_2-5m/ipmidbi_NW.grd"))
names(PA.scn)

