#!/bin/bash

## Extract contour from GRISLI ice-sheet mask
## Requires:
##  * Input arguments:
##    - $GRISLI: variable pointing to the GRISLI input file
##    - $MaskVal: the number of the ice sheet (tacheg variable)
##  * codes:
##    - nco
##    - gdal
##
ExtractPolygon () {
 
 echo $MaskVal
 echo $GRISLI

 ## Maske binary mask where mask=1 for the required GRISLI mask value
 ncap2 -v -s "mask=tacheg==$MaskVal" $GRISLI mask.nc

 ## Get contour polygon from the mask
 rm -rf contour.shp
 gdal_polygonize.py -mask NETCDF:"mask.nc":mask -f "ESRI Shapefile"  NETCDF:"mask.nc":mask contour.shp

}


## Convert the contour file to a gmsh .geo file 
## (closed contour with unique lateral physical boundary)
## Requires:
##  * Input arguments:
##    - $resolution: the required initial mesh resolution
##    - $Contour2geo: python code in elmer sources to create .geo files
## Rq. --spline can induce loops and may fail on complex contours
ShpToGeo () {
  if [ ! -f "$Contour2geo" ]; then
    echo "Contour2geo does not exist. return ..."
    exit 1
  fi
  python $Contour2geo -r $resolution -i contour.shp -o mesh.geo 
}

## Convert the gmsh .geo file to Elmer input format
## Requires:
##  * Codes:
##   - gmsh
##   - ElmerGrid
##
GeoToElmer () {
  gmsh -1 -2 mesh.geo
  ElmerGrid 14 2 mesh.msh -autoclean
  ElmerGrid 2 5 mesh
}
