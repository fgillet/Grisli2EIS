#!/bin/bash
escapeSubst() { sed 's/[&/\]/\\&/g'  <<<"$1"; }

## souce mesh bash function from src dir
export SRC_DIR=..

## Input data files

# GRISLI input file
GRISLI="${SRC_DIR}/DATA/LGM-IPSL-abs_euras20-pourElmer.nc"
echo "GRISLI input file: " $GRISLI

# get sea level elevation
sl=$(ncks  -H -C -v sealevel -s "%f\n" $GRISLI)
echo "sea level elevation: " $sl

# depth avegared viscosity
ViscosityFile="${SRC_DIR}/DATA/AverageViscosity.nc"


sed  "s/<GRISLI_FILE>/$(escapeSubst "$GRISLI")/g;\
      s/<VISCOSITY_FILE>/$(escapeSubst "$ViscosityFile")/g;\
      s/<Zsea>/$sl/g"\
      ${SRC_DIR}/SIFs/INIT.sif > INIT.sif


sed  "s/<Zsea>/$sl/g"\
     ${SRC_DIR}/SIFs/CTRL.sif > CTRL.sif
cp ${SRC_DIR}/SIFs/H_numerics.sif .
cp ${SRC_DIR}/SIFs/SSA_numerics.sif .
