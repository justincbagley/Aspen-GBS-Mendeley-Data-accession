## README

## Data for: Genotyping-by-sequencing and ecological niche modeling illuminate phylogeography, admixture, and Pleistocene range dynamics in quaking aspen (_Populus tremuloides_)

**Justin C. Bagley** [:envelope:](mailto:jcbagley@vcu.edu)

_Department of Biology, Virginia Commonwealth University, Richmond, VA_
_Departamento de Zoologia, Universidade de Brasília, Brasília, DF, Brazil_

**Eliécer E. Gutiérrez**

_Universidade Federal de Santa Maria, Santa Maria, RS, Brazil_

**Neander M. Heming**

_Departamento de Zoologia, Universidade de Brasília, Brasília, DF, Brazil_


##

## LICENSE

All code and data within this "Data for: Genotyping-by-sequencing and ecological niche modeling 
illuminate phylogeography, admixture, and Pleistocene range dynamics in quaking aspen 
(_Populus tremuloides_)" Mendeley Data accession correspond to the paper by Bagley et al. (in 
review; see below) and is available "AS IS" under a generous 
<a href="https://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 
International licence</a> (or "CC BY 4.0"). See the online 
<a href="https://creativecommons.org/licenses/by/4.0/legalcode"></a> license for more
information.

## CITATION

If you use scripts from this accession as part of your published research, we request that 
you cite the dataset as follows (also see DOI information below): 
  
- Bagley, J.C., Gutiérrez, E.E., Heming, N.M. (2018). Data for: Genotyping-by-sequencing and 
ecological niche modeling illuminate phylogeography, admixture, and Pleistocene range dynamics 
in quaking aspen (_Populus tremuloides_). _Mendeley Data_, v1, available at:
<http://dx.doi.org/10.17632/jhkhvdgyfy.1>.

Alternatively, please provide the following link to this software/data accession in your 
manuscript:

- http://dx.doi.org/10.17632/jhkhvdgyfy.1

## DOI

The DOI for this accession is as follows: doi:[10.17632/jhkhvdgyfy.1](http://dx.doi.org/10.17632/jhkhvdgyfy.1). The CITATION section above illustrates how to cite this code using the DOI.

## INTRODUCTION

In support of the manuscript by Bagley et al. (in review) on quaking aspen phylogeography 
and ecological niche modeling (ENM), this accession dataset provides 1) SNP variant and genotype 
data files used during our genomic analyses, and 2) raw data files and computer code used 
during our ENM analyses. A list of the contents of this accession is given below in text 
format, and also visually depicted with a figure showing the full file tree structure.

Anyone with facility in population genetics and modern analysis of population genomic data 
will be able to quickly use the raw SNP data, e.g. to check SNPs or experiment with different 
filtering strategies, or use the genotype files to conduct population genetic analyses in 
```R``` packages mentioned in the Materials and Methods section of the paper (Bagley et al. 
in review) or other software.

In this README, we list the files and analysis scripts contained within this accession, 
we briefly describe the genomic data files provided, and we briefly explain how ENM Rscripts 
herein were strung together in a pipeline workflow suitable for UNIX-like environments with
recent R and MaxEnt installs.


## CONTENTS

**Scripts and other files contained in this accession.**

Text representation of the file tree structure of the accession:

```
Current directory tree structure:

/
|
|
|- ENM_Results
|   |-- species_RESULTS
|   |   |-- totalArea.aspen.csv
|   |   |-- sel.mdls.Aspen.csv
|   |   |-- OmRate.aspen.csv
|   |   |-- FracPredArea.aspen.csv
|   |   |-- var.Contribution.Aspen.csv
|   |   |-- var.PermImportanceAspen.csv
|   |   
|   |- cluster_RESULTS
|      |-- totalArea.MCPea.csv
|      |-- FracPredArea.MCPea.csv
|      |-- OmRate.MCPea.csv
|      |-- var.Contribution.Aspen.cltr1.MCPea.csv
|      |-- var.Contribution.Aspen.cltr2.MCPea.csv
|      |-- var.Contribution.Aspen.cltr3.MCPea.csv
|      |-- var.PermImportanceAspen.cltr1.MCPea.csv
|      |-- var.PermImportanceAspen.cltr2.MCPea.csv
|      |-- var.PermImportanceAspen.cltr3.MCPea.csv
|      |-- sel.mdls.Aspen.cltr3.MCPea.csv
|      |-- sel.mdls.Aspen.cltr2.MCPea.csv
|      |-- sel.mdls.Aspen.cltr1.MCPea.csv
|
|- Calibration_Areas
|   |-- species_MCP
|   |   |-- Aspen.occ.poly.dbf
|   |   |-- Aspen.occ.poly.prj
|   |   |-- Aspen.occ.poly.shp
|   |   |-- Aspen.occ.poly.shx
|   |
|   |- species_MCP_Calib
|   |   |-- Aspen.bffr.dbf
|   |   |-- Aspen.bffr.prj
|   |   |-- Aspen.bffr.shp
|   |   |-- Aspen.bffr.shx
|   |
|   |- species_MCcP
|   |   |-- Aspen.concave.occ.poly.dbf
|   |   |-- Aspen.concave.occ.poly.prj
|   |   |-- Aspen.concave.occ.poly.shp
|   |   |-- Aspen.concave.occ.poly.shx
|   |
|   |- cluster_MCPea_Calib
|   |   |-- Aspen.cltr2.MCPea.dbf
|   |   |-- Aspen.cltr2.MCPea.prj
|   |   |-- Aspen.cltr2.MCPea.shp
|   |   |-- Aspen.cltr2.MCPea.shx
|   |   |-- Aspen.cltr3.MCPea.dbf
|   |   |-- Aspen.cltr3.MCPea.prj
|   |   |-- Aspen.cltr3.MCPea.shp
|   |   |-- Aspen.cltr3.MCPea.shx
|   |   |-- Aspen.cltr1.MCPea.dbf
|   |   |-- Aspen.cltr1.MCPea.prj
|   |   |-- Aspen.cltr1.MCPea.shp
|   |   |-- Aspen.cltr1.MCPea.shx
|   |
|   |- cluster_MCP
|      |-- Aspen.cltr1.occ.poly.dbf
|      |-- Aspen.cltr1.occ.poly.prj
|      |-- Aspen.cltr1.occ.poly.shp
|      |-- Aspen.cltr1.occ.poly.shx
|      |-- Aspen.cltr2.occ.poly.dbf
|      |-- Aspen.cltr2.occ.poly.prj
|      |-- Aspen.cltr2.occ.poly.shp
|      |-- Aspen.cltr2.occ.poly.shx
|      |-- Aspen.cltr3.occ.poly.dbf
|      |-- Aspen.cltr3.occ.poly.prj
|      |-- Aspen.cltr3.occ.poly.shp
|      |-- Aspen.cltr3.occ.poly.shx
|   
|- ENM_Rscripts
      |-- script2_cluster_dataPrep-ENMAnalysis.R
      |-- script1B_dataPrep-ENMAnalysis.R
      |-- script3_manuscriptFigures.R
      |-- script1A_climScenarios2Grd.R
```

Graphical representation of the file tree structure:

<!-- ![file tree structure for this repository]('./file_tree_structure.pdf') -->
<p align="left"><img src="file_tree_structure.pdf"></img></p>


## PIPELINE OVERVIEW

Briefly, the ```MTML-msBayes``` workflow involves four steps, which are also described in
the user's manual: (**1**) making the input files, (**2**) calculating the observed summary statistics vector,
(**3**) simulating (from) the prior, and (**4**) getting the posterior distributions of hABC model 
hyperparameters (Hickerson et al. 2006, 2007; Huang et al. 2011). As clearly outlined in the
Materials and Methods section of the paper, we used a modified version of this pipeline 
that combines priors across models and yields model-averaged hyperparameter estimates 
(Hickerson et al. 2014). This was accomplished by first rescaling Omega and E[τ] hyper-
parameters to be consistent across priors, before estimating hyperparameter posterior 
distributions weighted by model averaging, using procedures in Hickerson et al. (2014).

Below, we expand on the four general steps above, which are also given in the manuscript, 
to list a set of ten explicit, more nuanced operations that we conducted during our analyses,
and to describe which scripts in the accession contain the corresponding code. For continuity 
with commenting in the accession scripts (especially the main analysis scripts, ```4FrogsABCAnalysis.sh``` 
and ```3FishesABCAnalysis.sh```; see **Table 1** _above_), we divide the ```MTML-msBayes``` analysis
steps into four sections that correspond to the four broad "steps" in the analysis and paper, 
and which are labeled with Roman numerals. Below this level, we also enumerate individual 
procedures as "operations" with Arabic numerals. A total of ten operations comprise the 
main analysis, and most of these from three sections prepare prior simulation results for 
post-processing as described in the scripts. 


## PIPELINE STEPS

### STEP I. INPUT FILES

1.  We prepared input batch files and fasta files for each ```im```-formatted input file 
in each of _n_ = 4 model folders (where _n_ corresponds to the total number of models) by 
running the ```convertIM.pl``` Perl script on an input file list ("infile.list"; e.g. listing
all of the frog taxa, in the case of the frog analysis), as follows:

```$ convertIM.pl infile.list ##--See MTML-msBayes manual for more info. ```

Resulting batch files had generic filenames, "batch.masterIn.fromIM", which were not changed. 
We then edited the batch file for each model (in each model folder) so that it contained correct 
prior bounds for each model class (e.g. for model one, M1, we set upperTheta = 0.1). 

### STEP II. OBSERVED SUMMARY STATISTICS

2.  For the second step in the pipeline, before actually simulating the prior in ```MTML-msBayes```, 
we obtained a vector of observed summary statistics from the DNA sequence data by running 
the ```obsSumStats.pl``` Perl script, as follows:

```obsSumStats.pl -s 7 -T obsSS.table batch.masterIn.fromIM > obsSS.txt ```

We did this within each of the _n_ run directories on the Brigham Young University Fulton 
Supercomputing Lab's supercomputer, marylou ([http://marylou.byu.edu](http://marylou.byu.edu)), 
before running simulations in ```MTML-msBayes``` (i.e. submitting jobs to supercomputer queue).

### STEP III. RUNNING MTML-MSBAYES: SIMULATING THE PRIOR

3.  Like steps I and II above, step III involved a single operation, in this case running 
```MTML-msBayes```. Before we submitted runs to the supercomputer, we prepared shell scripts 
for queuing runs for each model (M1-M4), for each species group (frogs and fishes). Here, 
we prepared _x_ shell scripts, where _x_ = 1 shell script/run * 10 runs/model * _y_ model 
priors. We found that it was highly efficient to conduct 10 parallel runs per model (e.g. M1) 
for 500000 simulations each, and then later to combine these for 5 million total simulated 
datasets (final 'BIG' priorfile) per model. 


### STEP IV. POST-PROCESSING PRIOR FILES, MODEL-AVERAGING, AND POSTERIOR DISTRIBUTIONS

Unlike the other steps above, this step involved multiple operations.

4.  After ```MTML-msBayes``` runs successfully finished, **operation #4** was to download and 
organize the prior simulation results ("priorfiles"). We pulled results off of the supercomputer 
and into the corresponding local directories. We then ensured that the column numbers, 
"obsSS.txt" file (containing observed summary statistics), priorfile names, output file names, 
etc. were distinct/identifiable to each particular dataset(s) and different model(s) tested. 
We double checked results locally to make sure that they corresponded to the correct models and 
directory structure.

5.  **Operation #5** was to make the summary statistics vector files "headless" by removing their 
header lines. Specifically, we removed the header of the "obsSS.txt" file for each dataset and 
added a dummy variable column (```9\t```, gives 1 column of 9's, which should be the first column).  
The obsSS.txt file then had two rows, including a header comprising the first row, and a string of 
summary statistics making up the second row. We simply removed the header line and then added ```9\t``` 
(nine followed by a tab) to the beginning of the remaining row. Last, we renamed the file 
"obsSS_headless.txt" and noted the file path so we could easily refer back to it during 
subsequent post-processing.

6.  During **operation #6**, we prepared the prior file resulting from each run for ABC model-
averaging analysis. We concatenated all smaller priorfiles for each of the 10 runs conducted 
within each model folder to obtain final "BIG" priorfiles for each model. We did this in three 
steps (a-c): 

	- (**a.**) We moved all priorfiles (e.g. named ```priorfile_3tax_M1_run1```, ```priorfile_3tax_M2_run1```, and so on; 
from all models) into a common directory.  
	- (**b.**) Next, we concatenated priorfiles for each run per model and saved the resulting 
"BIG" priorfile, whose length was equivalent to the sum total number of data simulations 
plus one, or in our case 5 x 10^6  + 1 = 5,000,001 lines, and we gave this final priorfile a 
new name. We then checked the length of each final "BIG" priorfile using ```$ wc -l <BIG_5mil_priorfile_name> ```
in Mac Terminal.
	- (**c.**) Last, we removed all initial priorfiles (for runs 1-10 for each model) using the 
```rm``` command in Terminal.

7.  **Operation #7** was to obtain model indicator (column) numbers to insert into subsequent ABC 
```R``` code. These numbers are critical to link the summary statistics files to the correct model 
for a set of _Y_-taxon models. We obtained the column numbers from doing a preliminary accept/reject
step on one of the priorfiles resulting from a set of ```MTML-msBayes``` simulations (e.g. for run1
for a given model), using the ```acceptRej.pl``` Perl script. This script output the set of
numbers (e.g. "12 13 14 15 16 17 18 19 20 24 25 26" in the ```3FishesABCAnalysis.sh``` script),
which were subsequently copied down in a separate file and then inserted in the place of ranges
of numbers in our original script(s), as needed, so that the numbers string was appropriate for
the corresponding dataset. Here is an example of code for running ```acceptRej.pl``` on the 3 fishes
model M1 (which is also given in the shell script):

```
##--Example using Fishes M2-BESTmodel:
cd /Users/justinbagley/bin
acceptRej.pl -t 0.0002 -p outfig.pdf /Volumes/4TB_MAC/msbayes_from_Ana/hickerlab/3fishes_Sept2015/obsSS.txt /Volumes/4TB_MAC/msbayes_from_Ana/hickerlab/3fishes_Sept2015/fishprior_M2_upTheta0.1_tau0.8_Anc0.5_5Mil > modeEstimatesOut.txt
```

8.  **Operation #8** was to obtain a final set of 'headless' priorfiles with model indicator
columns. This was done by removing headers from the final "BIG 5mil..." priorfiles (see filenames
in our scripts), and then using the accept/reject algorithm to filter 10,000 simulations from 
each prior and save them in a file ending in ```*headless_10K```.

9.  **Operation #9** was to conduct rescaling of Omega and E[τ] estimates for prior classes 
(models) with lower upper bounds on the theta prior (P(θD)) used during simulations during
STEP III. The procedures for doing this are explained within the ```4FrogsABCAnalysis.sh``` 
and ```3FishesABCAnalysis.sh``` shell scripts. 

10.  Finally, **Operation #10** involved combining all of the correct (and if needed, rescaled)
headless priorfiles and using the rejection algorithm to filter simulations from the resulting
final priorfile.


---
### _*IMPORTANT: The main enclosed shell scripts, ```4FrogsABCAnalysis.sh``` and ```3FishesABCAnalysis.sh```, contain detailed code for conducting operations #7 through #10 (of STEP IV) for the 4 frogs and 3 fishes analyses.*_
---

After **operation #10** above, sufficient simulation and post-processing work was completed to 
arrive at a final set of files that could be analyzed and used to summarize the posteriors
of hyperparameter (Et, Psi, and Omega) distributions and calculate model-averaged posterior
estimates and their 95% highest posterior densities (HPDs). These subsequent steps were 
conducted in ```R``` **using code in the ```4FrogsPosterior.r``` and ```3FishesPosterior.r``` Rscripts.**


## GRAPHICAL CHECKS ON PRIORS

After our analysis was complete, we used principal components analysis (PCA) conducted in ```R```
to conduct graphical checks on our prior simulations and make sure that our observed data
fell within the prior bounds and random sample of prior points from each model, for each
species group analyzed. Graphical checks were conducted using the ```graphicalPriorChecks.sh```
shell script in this accession, which includes code for brief file processing, as well as
generating and running a custom ```R``` analysis of both the frog and fish datasets. The
code directs ```R``` to save graphical plots to file; the resulting plots from our analysis
are shown in **Figure S2** of the Supplemental Files for Bagley et al. (2018).


## ADDITIONAL NOTES

Paths to filenames are given in the scripts "as is", and have not been sanitized, so as to
show how shifts were made between different folders. Movements into the user's ```bin``` folder
were necessary because a specific, updated version of ```MTML-msBayes``` and related executables
were included in that folder and not placed in the ```$PATH``` environmental variable. This is
because we were partly interested in comparing results from different versions of ```MTML-msBayes```,
for analyses reported and discussed in Overcast et al. (2017).


## REFERENCES

- Bagley, J.C., Hickerson, M.J. & Johnson, J.B. 2018. Testing hypotheses of diversification in Panamanian frogs and freshwater fishes using hierarchical approximate Bayesian computation with model averaging. _PeerJ_.
- Hey, J., & Nielsen, R. 2004. Multilocus methods for estimating population sizes, migration rates and divergence time, with applications to the divergence of _Drosophila pseudoobscura_ and _D. persimilis_. _Genetics_ 167: 747-760.
- Hickerson, M.J., Stahl, E. & Lessios, H.A. 2006. Test for simultaneous divergence using Approximate Bayesian Computation. _Evolution_ 60: 2435-2453.
- Hickerson, M.J., Stahl, E. & Takebayashi, N. 2007. msBayes: a pipeline for testing comparative phylogeographic histories using hierarchical approximate Bayesian computation. _BMC Bioinformatics_ 8: 268.
- Hickerson, M.J., Stone, G.N., Lohse, K., Demos, T.C., Xie, X., Landerer, C. & Takebayashi, N. 2014. Recommendations for using msBayes to incorporate uncertainty in selecting an ABC model prior: a response to Oaks et al. _Evolution_ 68: 284-294.
- Huang, W., Takebayashi, N., Qi, Y. & Hickerson, M.J. 2011. MTML-msBayes: Approximate Bayesian comparative phylogeographic inference from multiple taxa and multiple loci with rate heterogeneity. _BMC Bioinformatics_ 12: 1.
- Overcast, I., Bagley, J.C. & Hickerson, M.J. 2017. Improving approximate Bayesian computation tests for synchronous diversification by buffering divergence time classes. _BMC Evolutionary Biology_ 17: 203.


