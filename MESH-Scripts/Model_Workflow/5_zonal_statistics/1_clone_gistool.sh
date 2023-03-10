git clone https://github.com/kasra-keshavarz/gistool.git

# --- Code provenance
# Generates a basic log file in the domain folder and copies the control file and itself there.
# Make a log directory if it doesn't exist
log_path="gistool/_workflow_log/"
mkdir -p $log_path

# Log filename
today=`date '+%F'`
log_file="${today}_clone_log.txt"

# Make the log
this_file="1_clone_gistool.sh"
echo "Log generated by ${this_file} on `date '+%F %H:%M:%S'`"  > $log_path/$log_file # 1st line, store in new file
echo 'Cloned GIS Tool package into parent directory' >> $log_path/$log_file # 2nd line, append to existing file

# Copy this file to log directory
cp $this_file $log_path
