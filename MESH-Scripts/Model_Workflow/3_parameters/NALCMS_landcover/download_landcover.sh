# --- Settings
# Find the line with the CEC url
setting_line=$(grep -m 1 "^land_cover_url" ../../0_control_files/control_active.txt) # -m 1 ensures we only return the top-most result. This is needed because variable names are sometimes used in comments in later lines

# Extract the url
lc_url=$(echo ${setting_line##*|}) # remove the part that ends at "|"
lc_url=$(echo ${lc_url%%#*}) # remove the part starting at '#'; does nothing if no '#' is present

# Find the line with the root path
setting_line=$(grep -m 1 "^root_path" ../../0_control_files/control_active.txt) # -m 1 ensures we only return the top-most result. This is needed because variable names are sometimes used in comments in later lines

# Extract the root path
root=$(echo ${setting_line##*|}) # remove the part that ends at "|"
root=$(echo ${root%%#*}) # remove the part starting at '#'; does nothing if no '#' is present

# Find the line with the domain name
setting_line=$(grep -m 1 "^domain_name" ../../0_control_files/control_active.txt) # -m 1 ensures we only return the top-most result. This is needed because variable names are sometimes used in comments in later lines

# Extract the domain name
domainname=$(echo ${setting_line##*|}) # remove the part that ends at "|"
domainname=$(echo ${domainname%%#*}) # remove the part starting at '#'; does nothing if no '#' is present

# download the 2010 NALCMS 30m - Landsat land cover TIF
wget http://www.cec.org/files/atlas_layers/1_terrestrial_ecosystems/1_01_2_land_cover_2010_30m/land_cover_2010v2_30m_tif.zip

# make the landcover directory
mkdir $root/domain_$domainname/landcover/

# move the land cover into the land cover folder
mv land_cover_2010v2_30m_tif.zip $root/domain_$domainname/landcover/


# --- Code provenance
# Generates a basic log file in the domain folder and copies the control file and itself there.
# Make a log directory if it doesn't exist
log_path="$root/domain_$domainname/landcover/_workflow_log/"
mkdir -p $log_path

# Log filename
today=`date '+%F'`
log_file="${today}_clone_log.txt"

# Make the log
this_file="download_landcover.sh"
echo "Log generated by ${this_file} on `date '+%F %H:%M:%S'`"  > $log_path/$log_file # 1st line, store in new file
echo 'Downloaded 2010 North America NALCMS land cover data' >> $log_path/$log_file # 2nd line, append to existing file

# Copy this file to log directory
cp $this_file $log_path