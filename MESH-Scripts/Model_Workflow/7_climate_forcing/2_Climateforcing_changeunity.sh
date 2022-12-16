#!/bin/bash
#SBATCH --account=rpp-kshook
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=10G
#SBATCH --time=00:30:00
#SBATCH --job-name=BowAtBanff_change_unity
#SBATCH --error=errors_BowAtBanff
#SBATCH --mail-user=example.email@usask.ca
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END


# Find the line with the domain name
setting_line=$(grep -m 1 "^domain_name" ../0_control_files/control_active.txt) # -m 1 ensures we only return the top-most result. This is needed because variable names are sometimes used in comments in later lines
# Extract the domain name
domainname=$(echo ${setting_line##*|}) # remove the part that ends at "|"
domainname=$(echo ${domainname%%#*}) # remove the part starting at '#'; does nothing if no '#' is present


# Find the line with the domain name
setting_line=$(grep -m 1 "^root_path" ../0_control_files/control_active.txt) # -m 1 ensures we only return the top-most result. This is needed because variable names are sometimes used in comments in later lines
# Extract the domain name
root=$(echo ${setting_line##*|}) # remove the part that ends at "|"
root=$(echo ${root%%#*}) # remove the part starting at '#'; does nothing if no '#' is present


# laod modules 
module load cdo/1.9.8


# input folder
infolder=$root/domain_$domainname/forcing/ # /subbasin_select  
fl=RDRS_$domainname'_remapped_1980-01-01-13-00-00.nc'
echo $fl


for var in RDRS_v2.1_P_HU_09944 RDRS_v2.1_A_PR0_SFC RDRS_v2.1_P_P0_SFC RDRS_v2.1_P_FB_SFC RDRS_v2.1_P_FI_SFC RDRS_v2.1_P_TT_09944 RDRS_v2.1_P_UVC_09944 latitude longitude 
	do
		echo $var
		cdo selname,$var $infolder/$fl $infolder/$var'_'$fl		
	done


## Adjust Units
## Pressure from "mb" to "Pa"
cdo mulc,100 $infolder/'RDRS_v2.1_P_P0_SFC_'$fl $infolder/tmp.nc
cdo setattribute,RDRS_v2.1_P_P0_SFC@units=Pa $infolder/tmp.nc $infolder/'RDRS_v2.1_P_P0_SFC_'$fl
rm $infolder/tmp.nc

## Temperature from "deg_C" to "K"
cdo addc,273.16 $infolder/'RDRS_v2.1_P_TT_09944_'$fl $infolder/tmp.nc
cdo setattribute,RDRS_v2.1_P_TT_09944@units=K $infolder/tmp.nc $infolder/'RDRS_v2.1_P_TT_09944_'$fl
rm $infolder/tmp.nc

## Wind speed from "knts" to "m/s"
cdo mulc,0.5144444444444444 $infolder/'RDRS_v2.1_P_UVC_09944_'$fl $infolder/tmp.nc
cdo setattribute,RDRS_v2.1_P_UVC_09944@units="m s-1" $infolder/tmp.nc $infolder/'RDRS_v2.1_P_UVC_09944_'$fl
rm $infolder/tmp.nc

## Precipitation from "m" over the hour to a rate "mm/s" = "kg m-2 s-1"
cdo divc,3.6 $infolder/'RDRS_v2.1_A_PR0_SFC_'$fl $infolder/tmp.nc
cdo setattribute,RDRS_v2.1_A_PR0_SFC@units="mm s-1" $infolder/tmp.nc $infolder/'RDRS_v2.1_A_PR0_SFC_'$fl
rm $infolder/tmp.nc


#merge files 
cdo -z zip -b F32 merge $infolder/'RDRS_v2.1_P_HU_09944_'$fl $infolder/'RDRS_v2.1_A_PR0_SFC_'$fl $infolder/'RDRS_v2.1_P_P0_SFC_'$fl $infolder/'RDRS_v2.1_P_FB_SFC_'$fl $infolder/'RDRS_v2.1_P_FI_SFC_'$fl $infolder/'RDRS_v2.1_P_TT_09944_'$fl $infolder/'RDRS_v2.1_P_UVC_09944_'$fl $infolder/'latitude_'$fl $infolder/'longitude_'$fl $infolder/tmep$fl

for var in RDRS_v2.1_P_HU_09944 RDRS_v2.1_A_PR0_SFC RDRS_v2.1_P_P0_SFC RDRS_v2.1_P_FB_SFC RDRS_v2.1_P_FI_SFC RDRS_v2.1_P_TT_09944 RDRS_v2.1_P_UVC_09944 latitude longitude
	do
		rm $infolder/$var'_'$fl		
	done

# Remove original file and replace it with changed unity file.
rm $infolder/$fl
mv $infolder/tmep$fl $infolder/$fl