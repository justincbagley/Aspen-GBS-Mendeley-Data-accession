#!/usr/bin/env Rscript

#Orig name: 2.1.b Load-prepare cluster data and modeling ENMwizard.R

##########################################################################################
#
# I. SETUP.
#
##########################################################################################

############## PACKAGES
library(ENMwizard)
library(raster)

############## DATA
## import occ data
Aspen.cltr1 <- read.delim("Presence_Data/aspen_clusters_may24/cluster1_coords_uniq.txt", header=FALSE)
Aspen.cltr2 <- read.delim("Presence_Data/aspen_clusters_may24/cluster2_coords_uniq.txt", header=FALSE)
Aspen.cltr3 <- read.delim("Presence_Data/aspen_clusters_may24/cluster3_coords_uniq.txt", header=FALSE)

## colnames(Aspen)
colnames(Aspen.cltr1) <- c("Latitude", "Longitude")
colnames(Aspen.cltr2) <- c("Latitude", "Longitude")
colnames(Aspen.cltr3) <- c("Latitude", "Longitude")

## remove some sites for MCP
Aspen.cltr1 <- Aspen.cltr1[-2,] # remove Colorado site
Aspen.cltr3 <- Aspen.cltr3[-7,] # remove outgroup site

coordinates(Aspen.cltr1) <- ~Longitude+Latitude
coordinates(Aspen.cltr2) <- ~Longitude+Latitude
coordinates(Aspen.cltr3) <- ~Longitude+Latitude
crs(Aspen.cltr1) <- crs(Aspen.c)
crs(Aspen.cltr2) <- crs(Aspen.c)
crs(Aspen.cltr3) <- crs(Aspen.c)


par(mar=c(0,0,0,0), oma=c(2.3,2.3,0,2)) #  
plot(rbind(Aspen.cltr1, Aspen.cltr2, Aspen.cltr3), cex=.1)
plot(Aspen.c, col="gray", add=T)
plot(Aspen.cltr1, bg="#FFEF02", pch=21, lwd=.2, add=T) # gold1
plot(Aspen.cltr2, bg="#1E4871", pch=21, lwd=.2, add=T) # darkblue
plot(Aspen.cltr3, bg="#FF2600", pch=21, lwd=.2, add=T) # red


spp.cl.occ.list <- list(Aspen.cltr1 = Aspen.cltr1,
                        Aspen.cltr2 = Aspen.cltr2,
                        Aspen.cltr3 = Aspen.cltr3)


##########################################################################################
#
# II. CREATE MCPs FOR CLUSTERS/LINEAGES, AND EXTRACT OCCURRENCE RECORDS BY CLUSTER.
#
##########################################################################################

#### A.1 create cluster/lineage MCPs:
occ.cl.polys <- poly.c.batch(spp.cl.occ.list)

#### A.2 Convert cluster hex colors to RGB format:
cl.col <- col2rgb(c("#FFEF02", "#1E4871", "#FF2600"), alpha = F)/255

#### A.3 Plot MCPs and color to match genetic cluster colors in Fig. 1 (Bagley et al. 
####     aspen GBS phylogeography manuscript):
plot(rbind(Aspen.cltr1, Aspen.cltr2, Aspen.cltr3), cex=.1)
plot(NewWorld, add=T)
plot(occ.cl.polys$Aspen.cltr1, col=rgb(cl.col[1,1], cl.col[2,1], cl.col[3,1],.5), lwd=.2, add=T) # gold1
plot(occ.cl.polys$Aspen.cltr2, col=rgb(cl.col[1,2], cl.col[2,2], cl.col[3,2],.5), lwd=.2, add=T) # darkblue
plot(occ.cl.polys$Aspen.cltr3, col=rgb(cl.col[1,3], cl.col[2,3], cl.col[3,3],.5), lwd=.2, add=T) # red
plot(Aspen.c, col=rgb(0,0,0,.2), add=T)
plot(Aspen.cltr1, bg="#FFEF02", pch=21, cex=.6, lwd=.2, add=T) # gold1
plot(Aspen.cltr2, bg="#1E4871", pch=21, cex=.6, lwd=.2, add=T) # darkblue
plot(Aspen.cltr3, bg="#FF2600", pch=21, cex=.6, lwd=.2, add=T) # red


#### A.4 Create MCPs with IDs to extract occs that fall within
occ.cl.polys2 <- lapply(seq_along(occ.cl.polys), function(i, x, y){
                      x[[i]]$ID <- i
                      return(x[[i]])
                    }, occ.cl.polys, spp.cl.occ.list)
names(occ.cl.polys2) <- names(occ.cl.polys)

occ.cl.polys2
row.names(occ.cl.polys2$Aspen.cltr2)

#### A.5 Bind MCPs into same sp object:
Aspen.cltr.comb <- do.call(rbind, occ.cl.polys2)
plot(Aspen.cltr.comb)

# # create a small buffer to avoid removing pixels partially 
# # overlapping with areas of lineages
# Aspen.cltr.comb.b <- buffer(Aspen.cltr.comb, width=.15)
# plot(Aspen.cltr.comb.b, add=T)
# # Aspen.cltr.comb$ID

#### B.1 Extract occs that fall within MCPs:
pts.clrs <- extract(Aspen.cltr.comb, Aspen.c)
pts.clrs <- pts.clrs[!is.na(pts.clrs$ID),]
plot(Aspen.c[pts.clrs$point.ID,], add=T)

# number of records within MCPs of each cluster:
sum(pts.clrs$ID==1)
sum(pts.clrs$ID==2)
sum(pts.clrs$ID==3)

#### B.2 Plot occurrence localities within MCPs of each cluster:
{
  if(dir.exists("figs/prelim")==F) dir.create("figs/prelim")
  pdf("figs/prelim/Cluster_pts.pdf", width = 7, height = 7)
  par(mfrow=c(2,2), mar=c(1,1,1,1), oma=c(1,1,1,1) )
  
  # plot of all study area
  plot(Aspen.c, col=rgb(0,0,0,.2))
  # plot(rbind(Aspen.cltr1, Aspen.cltr2, Aspen.cltr3), cex=.1, add=T)
  plot(NewWorld, add=T)
  plot(occ.cl.polys$Aspen.cltr1, col=rgb(cl.col[1,1], cl.col[2,1], cl.col[3,1],.5), lwd=.2, add=T) # gold1
  plot(occ.cl.polys$Aspen.cltr2, col=rgb(cl.col[1,2], cl.col[2,2], cl.col[3,2],.5), lwd=.2, add=T) # darkblue
  plot(occ.cl.polys$Aspen.cltr3, col=rgb(cl.col[1,3], cl.col[2,3], cl.col[3,3],.5), lwd=.2, add=T) # red
  # plot(Aspen.c, col=rgb(0,0,0,.2), add=T)
  plot(Aspen.cltr1, bg="#FFEF02", pch=21, cex=.6, lwd=.2, add=T) # gold1
  plot(Aspen.cltr2, bg="#1E4871", pch=21, cex=.6, lwd=.2, add=T) # darkblue
  plot(Aspen.cltr3, bg="#FF2600", pch=21, cex=.6, lwd=.2, add=T) # red
  
  # plot of cluster 1
  plot(occ.cl.polys$Aspen.cltr1, col=rgb(cl.col[1,1], cl.col[2,1], cl.col[3,1],.5), lwd=.2,
       main="Cluster 1, N = ~11") # gold1
  plot(Aspen.c[pts.clrs$point.ID[pts.clrs$ID==1],], add=T)
  plot(Aspen.cltr1, bg="#FFEF02", pch=21, cex=.6, lwd=.2, add=T) # gold1
  
  # plot of cluster 2
  plot(occ.cl.polys$Aspen.cltr2, col=rgb(cl.col[1,2], cl.col[2,2], cl.col[3,2],.5), lwd=.2,
       main="Cluster 2, N = 45") # darkblue
  plot(Aspen.c[pts.clrs$point.ID[pts.clrs$ID==2],], add=T)
  plot(Aspen.cltr2, bg="#1E4871", pch=21, cex=.6, lwd=.2, add=T) # darkblue
  
  # plot of cluster 3
  plot(occ.cl.polys$Aspen.cltr3, col=rgb(cl.col[1,3], cl.col[2,3], cl.col[3,3],.5), lwd=.2,
       main="Cluster 3, N = 1504") # red
  plot(Aspen.c[pts.clrs$point.ID[pts.clrs$ID==3],], add=T)
  plot(Aspen.cltr3, bg="#FF2600", pch=21, cex=.6, lwd=.2, add=T) # red
  dev.off()
}



### C. Bind occurrence records with localities from which we obtained genetic information:
# function to bind
f.bind.cltr.occ <- function(all.pts, IDclrs, clrs.pts.lst){
  final.pts <- list()
  for(i in sort(unique(IDclrs$ID))){
    sel.pts <- all.pts[IDclrs$point.ID[IDclrs$ID==i], ]
    final.pts[[i]] <- rbind(as(sel.pts, 'SpatialPoints'), clrs.pts.lst[[i]])
  }
  names(final.pts) <- names(clrs.pts.lst)
  return(final.pts)
}

# bind
spp.cl.Focc.list <- f.bind.cltr.occ(Aspen.c, pts.clrs, clrs.pts.lst = 
                                     list(Aspen.cltr1 = Aspen.cltr1,
                                          Aspen.cltr2 = Aspen.cltr2,
                                          Aspen.cltr3 = Aspen.cltr3))

spp.cl.Focc.list


##########################################################################################
#
# III. PREPARE ENVIRONMENTAL DATA FOR THE CLUSTERS.
#
##########################################################################################

##### A.1 Create occ polygon to crop rasters prior to modelling
## Method: MCPea: (spMCP - MCcPA) + MCPLi:
# KEY:
# spMCP: species MCP, occ.b$Aspen
# MCcPA: species concave polygon (MCcP), concave.poly$Aspen.concave
# MCPLi: cluster MCP

spp.occ.list2 <- spp.occ.list
names(spp.occ.list2) <- "Aspen.concave"

#### A.2 Concave occ polygon: MCcPA
concave.poly <- poly.c.batch(spp.occ.list2, convex = F, alpha = 6.5)
# small buffer to avoid removing pixels overlapping occ records
concave.poly <- bffr.batch(concave.poly, bffr.width = .15)
par(mfrow=c(1,1))
plot(concave.poly$Aspen.concave, col="gray")
plot(Aspen.cltr.comb, add=T)

#### B.1 Remove area containing occ records from Aspen MCP: (spMCP - MCcPA)
Aspen.outside2 <- gDifference(occ.b$Aspen, concave.poly$Aspen.concave)
plot(Aspen.outside2, col='yellow') # common calibration area
plot(concave.poly$Aspen.concave, col="gray", add=T) # area removed from calibration

par(mfrow=c(2,2), mar = c(1,1,1,1), oma = c(1.2,1.2,2,1.2))
sapply(occ.cl.polys, function(x) {
  plot(Aspen.outside2, col='yellow')
  plot(concave.poly$Aspen.concave, col="gray", add=T)
  plot(x, col="red", add=T)} )

## add areas of each lineage to calibration area:  MCPea = (spMCP - MCcPA) + MCPLi
# also create a small buffer to avoid removing pixels partially 
# overlapping with areas of lineages
occ.cl.polys.MCPea <- lapply(names(occ.cl.polys), 
                             function(i, x, y){
                               return(rgeos::gUnion(y, buffer(x[[i]], width=.15)))
                             }, x=occ.cl.polys, y=Aspen.outside2)
names(occ.cl.polys.MCPea) <- paste0(names(occ.cl.polys), ".MCPea")

# plot resulting areas
par(mfrow=c(2,2))
sapply(occ.cl.polys.MCPea, plot, col="yellow")
# save shapefiles of resulting areas
sapply(names(occ.cl.polys.MCPea), function(i, x){
  shapefile(x[[i]], paste0("1_sppData/occ.bffr/", i,".shp"))
}, occ.cl.polys.MCPea)


#### B.2 Clip environmental layers using env.cut function of ENMwizard, and save to hard drive: 
# method: MCPea: (spMCP - MCcPA) + MCPLi
occ.cl.b.env6 <- env.cut(occ.cl.polys.MCPea, current)


#### C. Cut multiple Projection Areas (P.A.s):
Aspen.cl.aproj <- pred.a.batch.rst.mscn(proj.pol$Aspen, proj.scn, occ.cl.polys)


##########################################################################################
#
# IV. FILTER/CLEAN ORIGINAL OCCURRENCES DATASET FOR CLUSTER ANALYSES.
#
##########################################################################################

occ.cl.locs <- lapply(seq_along(spp.cl.Focc.list), 
                      function(i, x){
                        cbind(as.data.frame(x[[i]]), species=names(x)[i])
                      }, spp.cl.Focc.list)
names(occ.cl.locs) <- names(spp.cl.Focc.list)
lapply(occ.cl.locs, head)


occ.cl.locs <- thin.batch(occ.cl.locs, thin.par = 10, reps = 5)
occ.cl.locs <- loadTocc(occ.cl.locs)
lapply(occ.cl.locs, head)
sapply(occ.cl.locs, nrow) # number of occ localities to be used on ENM


##########################################################################################
#
# V. TUNING PARAMETERS FOR MAXENT ECOLOGICAL NICHE MODELING ON CLUSTER DATA.
#
##########################################################################################

#### A. Tuning Maxent's feauture classes (FCs) and regularization multiplier (RM) via 
####    ENMeval analysis. 
#### A.1 First, load specific packages, just in case:
library(ENMeval)
library(rJava)
library(dismo)

#### A.2 Run ENMevaluate:
# method: MCPea: (spMCP - MCcPA) + MCPLi
occ.cl.locs.MCPea <- occ.cl.locs
names(occ.cl.locs.MCPea) <- paste0(names(occ.cl.locs.MCPea), ".MCPea")
ENMeval_res.cl.lst <- ENMevaluate.batch(occ.cl.locs.MCPea, occ.cl.b.env6,
                                        RMvalues = seq(0.5, 4, 0.5),
                                        fc = c("L", "P", "Q", "H",
                                               "LP", "LQ", "LH",
                                               "PQ", "PH", "QH",
                                               "LPQ", "LPH", "LQH", "PQH",
                                               "LPQH"), # , "LPQHT"
                                        method = "block",
                                        parallel = T, numCores = 6)
saveRDS(ENMeval_res.cl.lst, file = "3_out.MaxEnt/ENMeval_res.cl.MCPea.rds")


# ENMeval_res.cl.lst <- list()
# ENMeval_res.cl.lst <- readRDS(file = "3_out.MaxEnt/ENMeval_res.cl.rds")
# names(ENMeval_res.cl.lst)


##########################################################################################
#
# VI. ECOLOGICAL NICHE MODELING CALIBRATION IN MAXENT.
#
##########################################################################################

#### A.1 Run top corresponding models:
# method: MCPea: (spMCP - MCcPA) + MCPLi
mxnt.mdls.cl.MCPea.preds.cf <- mxnt.c.batch(ENMeval.o.l = ENMeval_res.cl.lst,
                                              a.calib.l = occ.cl.b.env6, occ.l = occ.cl.locs.MCPea,
                                              mSel = "LowAIC")

rm(ENMeval_res.cl.lst) # remove large ENMeval object from R memory

#### A.2 Run projections for present and past climatic scenarios:
# method: MCPea: (spMCP - MCcPA) + MCPLi
mxnt.mdls.cl.MCPea.preds.cf <- mxnt.p.batch.mscn(mxnt.mdls.cl.MCPea.preds.cf,
                                                   a.proj.l = Aspen.cl.aproj,
                                                   numCores = 3)


names(mxnt.mdls.preds.cf$Aspen$mxnt.preds)
names(mxnt.mdls.cl.MCPea.preds.cf$Aspen.cltr1.MCPea$mxnt.preds)

#### A.3 Threshold for current and future predictions under different scenarios:
# 4.8.5 threshold for current and future pred
# options: ("fcv1", "fcv5", "fcv10", "mtp", "x10ptp", "etss", "mtss", "bto", "eetd")
mods.cl.thrshld.lst <- f.thr.batch(mxnt.mdls.cl.MCPea.preds.cf, thrshld.i = 5)
names(mods.cl.thrshld.lst)

#### A.4 Plot results:
plot(mods.cl.thrshld.lst[[1]]$current$binary$x10ptp)
plot(mods.cl.thrshld.lst[[2]]$current$binary$x10ptp)
plot(mods.cl.thrshld.lst[[3]]$current$binary$x10ptp)



##########################################################################################
#
# IV. CALCULATE METRICS (VAR CONTRIBUTION AND IMPORTANCE, TOTAL AREA).
#
##########################################################################################

#### A.1 Compute variable contribution and importance:
# f.var.ci(mxnt.mdls.cl.MCPeaul.preds.cf)
f.var.ci(mxnt.mdls.cl.MCPea.preds.cf)

#### A.2 Compute "Fractional predicted area" ('n of occupied pixels'/n) for multiple scenarios:
f.FPA(mods.cl.thrshld.lst)

#### A.3 Compute "Omission Rate":
# f.OR(mods.cl.thrshld.lst, occ.cl.locs.MCPeaul, clim.scn.nm = "current")
f.OR(mods.cl.thrshld.lst, occ.cl.locs.MCPea, clim.scn.nm = "current")

#### A.4 Compute cluster total suitable areas:
f.area.occ.mscn(mods.cl.thrshld.lst)

