# Script to initialize a Xilinx Vivado project
# Make sure to run this script from the project root directory
create_project RVSCC project
create_fileset -blockset rtl
create_fileset -blockset fw
add_files -fileset rtl rtl
add_files -fileset sim_1 test