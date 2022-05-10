# BeerliIndergandKunz2022: replication files.

- Current version: `1.0.0 22apr2022`
- Jump to: [`overview`](#overview) [`crosswalk`](#crosswalk) [`source files`](#source-files) [`update history`](#update-history) [`authors`](#authors) [`references`](#references)

-----------

## Overview 

This repository contains replication files and data for [Beerli, Indergand and Kunz (2022)](https://doi.org/10.1007/s00148-022-00892-3) more detail on the construction can be found in the longer version that contains the appendix [Beerli, Indergand and Kunz (2022)](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=3674880). 

The analysis is based on several restricted datasets, such as the Swiss census, we can not make these available but are happy to direct interested readers and support any replication, please do not hesitate to contact either [Andreas Beerli](mailto:beerli@kof.ethz.ch) or [Johannes Kunz](mailto:johannes.kunz@monash.edu) about any of these. Likewise for brevity we exclude the multitude of replication files for the Appendix version but are happy to provide these upon request. 

First, based on collapsed data sets from the microdata in the census we provide three data sets (in the mainfiles folder) used in the main paper along with do-files on their extraction (in the replicationcodes/_data folder). 

Second, we present all do-files used to generate the exhibits in the main paper (in the replicationcodes/_estimation folder). Simple adjustments of paths should suffice to replicate any of our main results, again please do not hesitate to contact us. Only figure 1 (polarisation) can not be replicated with the data posted here as it is based on the Swiss Labor Force Survey (SAKE). The SAKE is easy to get upon which the figure can be replicated, again please contact us if you need any assistance with this. 

Third, perhaps most useful for future research is the construction of the routine share in Swiss commuting zones, which we detail below. 

## Swiss routine share data

As detailed in the main paper and in more detail in the appendix we construct the Swiss local level decadal routine share following [Autor & Dorn (2013)](https://www.ddorn.net/papers/Autor-Dorn-LowSkillServices-Polarization.pdf) and its corresponding instrumental variable and saved the data separately for future research (swissroutineshare/). 

## Source files  

We do not re-post the publicly available datasets from the various sources here since they belong to different entities, however, we present all sources and do-files extracting and preparing the data. If interested in the exact datasets (in case there are updates or they are not available anymore, please contact us directly). 


## Update History
* **April 22, 2022**
  - initial commit
  

## Authors:

[Andreas Beerli](https://andreasbeerli.com)
<br>ETH, Zurich 

[Ronald Indergand](https://www.linkedin.com/in/ronald-indergand-0a0a10112/?originalSubdomain=ch)
<br>SECO 

[Johannes Kunz](https://sites.google.com/site/johannesskunz/)
<br>Monash University 

## References: 

David, H. Autor, & Dorn, David (2013). The growth of low-skill service jobs and the polarization of the US labor market. American Economic Review, 103(5), 1553-97.

Beerli, Andreas E., Indergand, Ronald & Kunz, Johannes .S. [The supply of foreign talent: how skill-biased technology drives the location choice and skills of new immigrants](https://doi.org/10.1007/s00148-022-00892-3). Journal of Population Economics (2022). https://doi.org/10.1007/s00148-022-00892-3



