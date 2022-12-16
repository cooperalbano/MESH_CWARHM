# Script to clone MESH

# --- Settings
# Find the line with the GitHub url
setting_line=$(grep -m 1 "^github_MESH" ../0_control_files/control_active.txt) # -m 1 ensures we only return the top-most result. This is needed because variable names are sometimes used in comments in later lines

# Extract the url
github_url=$(echo ${setting_line##*|}) # remove the part that ends at "|"
github_url=$(echo ${github_url%%#*}) # remove the part starting at '#'; does nothing if no '#' is present

# Find the line with the destination path
dest_line=$(grep -m 1 "^install_path_MESH" ../0_control_files/control_active.txt)

# Extract the path
MESH_path=$(echo ${dest_line##*|}) 
MESH_path=$(echo ${MESH_path%%#*}) 

# Specify the default path if needed
if [ "$MESH_path" = "default" ]; then
  
 # Get the root path
 root_line=$(grep -m 1 "^root_path" ../0_control_files/control_active.txt)
 root_path=$(echo ${root_line##*|}) 
 root_path=$(echo ${root_path%%#*}) 
 MESH_path="${root_path}/installs/MESH/"
fi

wget -O $MESH_path/r1813.zip https://wiki.usask.ca/download/attachments/983105591/r1813.zip?version=2&modificationDate=1633583308100&api=v2&download=true 

# --- Code provenance
# Generates a basic log file in the domain folder and copies the control file and itself there.
# Make a log directory if it doesn't exist
log_path="${MESH_path}/_workflow_log/"
mkdir -p $log_path

# Log filename
today=`date '+%F'`
log_file="${today}_clone_log.txt"

# Make the log
this_file="1a_clone_MESH.sh"
echo "Log generated by ${this_file} on `date '+%F %H:%M:%S'`"  > $log_path/$log_file # 1st line, store in new file
echo 'Cloned MESH into parent directory' >> $log_path/$log_file # 2nd line, append to existing file

# Copy this file to log directory
cp $this_file $log_path
