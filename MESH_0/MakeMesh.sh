#!/bin/bash

## souce mesh bash function from src dir
export SRC_DIR=..
source ${SRC_DIR}/src/MeshFunctions.sh

##########################################################
## Step 1 : Extract contour from GRISLI
##########################################################
## GRISLI input data file
GRISLI="${SRC_DIR}/DATA/LGM-IPSL-abs_euras20-pourElmer.nc"
## tacheg values conrreponding to the domain
MaskVal=1

ExtractPolygon

##########################################################
## Step 2 : Convert polygon to gmsh .geo file
##########################################################
## elmerice python script
Contour2geo=${ELMER_SRC}/elmerice/Meshers/GIS/Contour2geo.py
## mesh resolution
resolution=10.0e3

ShpToGeo

##########################################################
## Step 3 : make gmsh mesh and convert to Elmer format
##########################################################
GeoToElmer
