#!/usr/bin/env Rscript

#Orig name: 2.2. main figs.R

##########################################################################################
#
# I. SETUP.
#
##########################################################################################

############## DATA

## Download additional datasets not used in prelim mapping, namely that for ice extent 
# during the LGM, available here:
# https://crc806db.uni-koeln.de/layer/show/6

############## PACKAGES

library(ENMwizard)
library(raster)

############## SET PATHS TO DIR, FILES, etc.

path2files <- "path/to/your/files"


##########################################################################################
#
# II. CREATE MANUSCRIPT FIGURES.
#
##########################################################################################

#### A. Prep files
iceLGM <- shapefile(paste0(path2files,"/shapes/LGM glaciations/lgm.shp"))
iceLGM <- crop(buffer(iceLGM, width=0), proj.pol$Aspen)

#### B. Layout and colors
# In the upper row: Current, Mid-Holocene.
# In the lower row:  LGM, LIG.
breaks <- seq(0, 1, .01)
colors <- colorRampPalette(c("gray", "yellow", "olivedrab1", "green4", "darkgreen"))(length(breaks)) # tan1

#### C. Create main figures: quaking aspen, whole species level
{
  pdf("figs/msFigAspenProjections.10ptp.pdf", height = 8, width = 8)
  par(mfrow=c(2,2), mar=c(0,0,0,0), oma=c(2.3,2.3,0,2)) #  
  plot(mods.thrshld.lst$Aspen$current$continuous$x10ptp, col=colors,
       axes=FALSE, bty="l", box=FALSE, legend=FALSE)#, main="current")
  text(-160, 10, "Present", adj = 0, # clim.scn name
       cex=1.2, col = "black", font=1)
  Axis(side=2, cex.axis=1.3)
  
  plot(mods.thrshld.lst$Aspen$HLCccmidbi$continuous$x10ptp, col=colors,
       axes=FALSE, bty="l", box=FALSE, legend=FALSE)#, main="HLC: CCSM4")
  text(-160, 10, "Mid-Holocene", adj = 0, # clim.scn name
       cex=1.2, col = "black", font=1)
  
  plot(mods.thrshld.lst$Aspen$LGMcclgmbi$continuous$x10ptp, col=colors,
       axes=FALSE, bty="l", box=FALSE, legend=FALSE)#, main="LGM: CCSM4")
  plot(iceLGM, col="lightsteelblue2", border="lightsteelblue2", lwd=0.00001, add=T)
  legend(-165, 25, legend=c("Ice extent"), fill=c("lightsteelblue2"),
         box.lwd=.3, cex=1.2, bty="n") # turn off the legend border# , inset=c(-0.05,0)
  text(-160, 10, "Last Glacial Maximum", adj = 0, # clim.scn name
       cex=1.2, col = "black", font=1)
  Axis(side=1, cex.axis=1.3)
  Axis(side=2, cex.axis=1.3)
  
  plot(mods.thrshld.lst$Aspen$LIGlig_30s$continuous$x10ptp, col=colors,
       axes=FALSE, bty="l", box=FALSE, legend=FALSE)#, main="LIG: CCSM3")
  text(-160, 10, "Last Interglacial", adj = 0, # clim.scn name
       cex=1.2, col = "black", font=1)
  Axis(side=1, cex.axis=1.3)
  
  # legend
  par(mfrow=c(1,1), mar=c(.5,.5,1,0), oma=c(2.5,15,1,.5))
  plot(mods.thrshld.lst$Aspen$current$continuous$x10ptp,  legend.only=TRUE, legend.width=.7, legend.shrink=.65,
       breaks = breaks, col= colors, # c("blue", "gray90", "red"),
       axis.args=list( at=seq(0, 1, .2), labels=seq(0, 1, .2),
                       cex.axis=1.1))  
  # legend("bottomright",
  #        legend=c("LGM \nice extent"),
  #        fill=c("lightsteelblue2"),
  #        bty="n", # turn off the legend border
  #        cex=1.1, inset=c(-0.01,0))
  dev.off()
}

#### D. Create main figures: quaking aspen clusters (genetic lineages)
{
  lin.names <- names(spp.cl.occ.list)
  for(i in seq_along(spp.cl.occ.list)){
    pdf(paste0("figs/msFig", lin.names[i],".Projections.10ptp.pdf"), height = 8, width = 8)
    par(mfrow=c(2,2), mar=c(0,0,0,0), oma=c(2.3,2.3,0,2)) #  
    plot(mods.cl.thrshld.lst[[i]]$current$continuous$x10ptp, col=colors,
         axes=FALSE, bty="l", box=FALSE, legend=FALSE)#, main="current")
    text(-160, 10, "Present", adj = 0, # clim.scn name
         cex=1.2, col = "black", font=1)
    Axis(side=2, cex.axis=1.3)
    
    plot(mods.cl.thrshld.lst[[i]]$HLCccmidbi$continuous$x10ptp, col=colors,
         axes=FALSE, bty="l", box=FALSE, legend=FALSE)#, main="HLC: CCSM4")
    text(-160, 10, "Mid-Holocene", adj = 0, # clim.scn name
         cex=1.2, col = "black", font=1)
    
    plot(mods.cl.thrshld.lst[[i]]$LGMcclgmbi$continuous$x10ptp, col=colors,
         axes=FALSE, bty="l", box=FALSE, legend=FALSE)#, main="LGM: CCSM4")
    plot(iceLGM, col="lightsteelblue2", border="lightsteelblue2", lwd=0.00001, add=T)
    legend(-165, 25, legend=c("Ice extent"), fill=c("lightsteelblue2"),
           box.lwd=.3, cex=1.2, bty="n") # turn off the legend border# , inset=c(-0.05,0)
    text(-160, 10, "Last Glacial Maximum", adj = 0, # clim.scn name
         cex=1.2, col = "black", font=1)
    Axis(side=1, cex.axis=1.3)
    Axis(side=2, cex.axis=1.3)
    
    plot(mods.cl.thrshld.lst[[i]]$LIGlig_30s$continuous$x10ptp, col=colors,
         axes=FALSE, bty="l", box=FALSE, legend=FALSE)#, main="LIG: CCSM3")
    text(-160, 10, "Last Interglacial", adj = 0, # clim.scn name
         cex=1.2, col = "black", font=1)
    Axis(side=1, cex.axis=1.3)
    
    # legend
    par(mfrow=c(1,1), mar=c(.5,.5,1,0), oma=c(2.5,15,1,.5))
    plot(mods.cl.thrshld.lst[[i]]$current$continuous$x10ptp,  legend.only=TRUE, legend.width=.7, legend.shrink=.65,
         breaks = breaks, col= colors, # c("blue", "gray90", "red"),
         axis.args=list( at=seq(0, 1, .2), labels=seq(0, 1, .2),
                         cex.axis=1.1))  
    # legend("bottomright", 
    #        legend=c("LGM \n ice extent"), 
    #        fill=c("lightsteelblue2"), 
    #        bty="n", # turn off the legend border
    #        cex=1.0)
    
    dev.off()
  }
}

############## 

#### E. Map all projections (time-slices) for whole quaking aspen species, plus clusters
{
  clim.scen.nms <- c("Present", 
                     "HLC: MIROC-ESM", "HLC: MPI-ESM-P", "HLC: CCSM4", "HLC: IPSL-CM5A-LR",
                     "LGM: MIROC-ESM", "LGM: MPI-ESM-P", "LGM: CCSM4", "LIG: CCSM3")
  names(clim.scen.nms) <- names(Aspen.aproj$Aspen)
  LGM <- grepl("LGM", names(Aspen.aproj$Aspen))
  
  lin.names <- names(spp.cl.occ.list)
  lin.names2 <- names(mods.cl.thrshld.lst)
  
  pdf("figs/AspenProjections_withLineages.10ptp.pdf", height = 3*9, width = 20)
  par(mfrow = c(9,4), mar = c(1,1,1,1), oma = c(1.2,4,2,2)) #  
  for(i in seq_along(clim.scen.nms)){
    plot(mods.thrshld.lst$Aspen[[i]]$continuous$x10ptp, col = colors,
         axes=FALSE, bty="l", box=FALSE, legend=FALSE)
    if(LGM[i]){
      plot(iceLGM, col="lightsteelblue2", border="lightsteelblue2", lwd=0.00001, add=T)
      legend(-165, 25, legend=c("Ice extent"), fill=c("lightsteelblue2"),
             box.lwd=.3, cex=1.3, bty="n") # turn off the legend border# , inset=c(-0.05,0)
    }
    if(i == 1){ # Lineage name
      mtext("Aspen", side=3, line=1, padj = 0,
          cex=1.5, col = "black", font=2)
      }
    
    mtext(clim.scen.nms[i], side=2, line=2, padj = -1, # clim.scn name
          cex=1.2, col = "black", font=2)
    # text(-158, 15, clim.scen.nms[i], adj = 0, # clim.scn name
    #      cex=1.2, col = "black", font=2)
    
    Axis(side=2, cex.axis=1.3)
    if(i == length(clim.scen.nms)){
      Axis(side=1, cex.axis=1.3)
    }
    
    for(j in seq_along(lin.names2)){
      plot(mods.cl.thrshld.lst[[j]][[i]]$continuous$x10ptp, col=colors,
           axes=FALSE, bty="l", box=FALSE, legend=FALSE)
      if(LGM[i]){
        plot(iceLGM, col="lightsteelblue2", border="lightsteelblue2", lwd=0.00001, add=T)
      }
      if(i == 1){
        mtext(paste("Lineage", j), side=3, line=1, padj = 0, # Lineage name
              cex=1.5, col = "black", font=2)
        }
      
      if(i == length(clim.scen.nms)){
        Axis(side=1, cex.axis=1.3)
      }
    }
  }
  # legend
  par(mfrow=c(1,1), mar=c(.5,.5,1,0), oma=c(2.5,30,1,.5))
  plot(mods.thrshld.lst$Aspen$current$continuous$x10ptp,  legend.only=TRUE, legend.width=.9, legend.shrink=.35,
       breaks = breaks, col= colors, # c("blue", "gray90", "red"),
       axis.args=list( at=seq(0, 1, .2), labels=seq(0, 1, .2),
                       cex.axis=1.1))
  # legend("bottomright", 
  #        legend=c("LGM \n ice extent"), 
  #        fill=c("lightsteelblue2"), 
  #        bty="n", # turn off the legend border
  #        cex=1.0)
  dev.off()
}


############## 

#### F. Calibration areas for quaking aspen clusters (genetic lineages)
#### F.1 Whole-species minimum concave polygon (MCcP), whole species minimum convex polygon
####     (MCP), and MCPs for each genetic cluster:
{
  par(mfrow = c(1,1), mar = c(1,1,1,1), oma = c(1.2,1.2,2,1.2)) #  
  pdf("figs/prelim/Cluster_calibArea.MCPea.pdf", width = 7, height = 7)
  plot(occ.b$Aspen, col="orange")
  plot(concave.poly$Aspen.concave, col="gray", add=T)
  plot(occ.cl.polys$Aspen.cltr1, col="#FFEF02", add=T)
  plot(occ.cl.polys$Aspen.cltr2, col="#1E4871", add=T)
  plot(occ.cl.polys$Aspen.cltr3, col="#FF2600", add=T)
  plot(NewWorld, border=rgb(0,0,0,.4), bg="white", add=T)
  legend("bottomleft", 
         legend=c("Lineage 1 MCP",
                  "Lineage 2 MCP",
                  "Lineage 3 MCP",
                  "Species MCcP with unidentified lineages", 
                  "Species buffered MCP"), 
         fill=c("#FFEF02",
                "#1E4871",
                "#FF2600",
                "gray", 
                "orange"), 
         bty="n", # turn off the legend border
         cex=1.0) # decrease the font / legend size
  mtext("Calibration Area of Lineages", side=3, line=1, padj = 0,
        cex=1, col = "black", font=2)
  Axis(side=2, cex.axis=1.3)
  Axis(side=1, cex.axis=1.3)
  dev.off()
}

