import os 
import numpy as np
import geopandas as gpd
from pathlib import Path
import time
start_time = time.time()


# %%Control file handling
controlFolder = Path('../../0_control_files')  # Easy access to control file folder
controlFile = 'control_active.txt'          # Store the name of the 'active' file in a variable


#Function to extract a given setting from the control file
def read_from_control( file, setting ):
    # Open 'control_active.txt' and ...
    with open(file) as contents:
        for line in contents:
            # ... find the line with the requested setting
            if setting in line and not line.startswith('#'):
                break    
    # Extract the setting's value
    substring = line.split('|',1)[1]      # Remove the setting's name (split into 2 based on '|', keep only 2nd part)
    substring = substring.split('#',1)[0] # Remove comments, does nothing if no '#' is found
    substring = substring.strip()         # Remove leading and trailing whitespace, tabs, newlines
    # Return this value   
    return substring


#Function to specify a default path
def make_default_path(suffix):
    # Get the root path
    rootPath = Path( read_from_control(controlFolder/controlFile,'root_path') )
    defaultPath = rootPath / suffix 
    return defaultPath


# %% Get the domain folder
domain_name = read_from_control(controlFolder/controlFile,'domain_name')
domainFolder = 'domain_' + domain_name


#  %% Get the target shapefile
target_shp_path = read_from_control(controlFolder/controlFile,'river_network_shp_path')
# Specify default path if needed
if target_shp_path == 'default':
    target_shp_path = make_default_path('domain_'+domain_name+'/shapefiles/river_network/') # outputs a Path()
else:
    target_shp_path = Path(target_shp_path) # make sure a user-specified path is a Path()
target_shp_name = read_from_control(controlFolder/controlFile,'river_network_shp_name')
target_shp      = target_shp_path / target_shp_name

# %% set CRS to 4326 
original_shp = gpd.read_file(str(target_shp).replace("\\","/"))
original_shp = original_shp.set_crs('epsg:4326')
original_shp.to_file(target_shp)