
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name Semaforos-SED -dir "C:/Users/sed/Desktop/Semaforos-SED/planAhead_run_5" -part xc3s200ft256-5
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "C:/Users/sed/Desktop/Semaforos-SED/top.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/Users/sed/Desktop/Semaforos-SED} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "top.ucf" [current_fileset -constrset]
add_files [list {top.ucf}] -fileset [get_property constrset [current_run]]
link_design
