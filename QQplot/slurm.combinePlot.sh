#!/bin/bash

trait="FAME.QT.All.Regular."


# Prepare the sbatch command for each run
echo $trait
sbatch submit.gwas.sh  ${trait}

##########################################################################################

trait="FAME.QT.All.Regular.SKATO."


# Prepare the sbatch command for each run
echo $trait
sbatch submit.gwas.sh ${trait}


##########################################################################################

trait="MEE.QT.All.Regular."


# Prepare the sbatch command for each run
echo $trait
sbatch submit.gwas.sh  ${trait}


##########################################################################################

trait="MEE.QT.All.Regular.SKATO."


# Prepare the sbatch command for each run
echo $trait
sbatch submit.gwas.sh  ${trait}


##########################################################################################

trait="FAME.QT.EUR.Regular."


# Prepare the sbatch command for each run
echo $trait
sbatch submit.gwas.sh  ${trait}

##########################################################################################

trait="FAME.QT.EUR.Regular.SKATO."


# Prepare the sbatch command for each run
echo $trait
sbatch submit.gwas.sh ${trait}


##########################################################################################

trait="MEE.QT.EUR.Regular."


# Prepare the sbatch command for each run
echo $trait
sbatch submit.gwas.sh  ${trait}


##########################################################################################

trait="MEE.QT.EUR.Regular.SKATO."


# Prepare the sbatch command for each run
echo $trait
sbatch submit.gwas.sh  ${trait}



##########################################################################################
##########################################################################################


trait="FAME.Responder.All."

# Prepare the sbatch command for each run
echo $trait
sbatch submit.gwas.sh  ${trait}



##########################################################################################

trait="MEE.Responder.All."

# Prepare the sbatch command for each run
echo $trait
sbatch submit.gwas.sh  ${trait}



##########################################################################################

trait="FAME.Responder.EUR."


# Prepare the sbatch command for each run
echo $trait
sbatch submit.gwas.sh  ${trait}

##########################################################################################
trait="MEE.Responder.EUR."

# Prepare the sbatch command for each run
echo $trait
sbatch submit.gwas.sh  ${trait}


##########################################################################################
##########################################################################################


trait="FAME.ExResponder.All."

# Prepare the sbatch command for each run
echo $trait
sbatch submit.gwas.sh  ${trait}



##########################################################################################

trait="MEE.ExResponder.All."

# Prepare the sbatch command for each run
echo $trait
sbatch submit.gwas.sh  ${trait}



##########################################################################################

trait="FAME.ExResponder.EUR."


# Prepare the sbatch command for each run
echo $trait
sbatch submit.gwas.sh  ${trait}

##########################################################################################
trait="MEE.ExResponder.EUR."

# Prepare the sbatch command for each run
echo $trait
sbatch submit.gwas.sh  ${trait}


