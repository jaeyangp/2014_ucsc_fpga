
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name xor3gate -dir "C:/Users/dalsook/FPGA/xor3gate/planAhead_run_3" -part xc3s100ecp132-5
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "C:/Users/dalsook/FPGA/xor3gate/s3_xor3gate.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/Users/dalsook/FPGA/xor3gate} }
set_property target_constrs_file "xor3gate.ucf" [current_fileset -constrset]
add_files [list {xor3gate.ucf}] -fileset [get_property constrset [current_run]]
link_design
