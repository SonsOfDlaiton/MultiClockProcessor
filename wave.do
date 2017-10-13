onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /proc/Input
add wave -noupdate /proc/Instruction
add wave -noupdate /proc/addrRegisterA
add wave -noupdate /proc/addrRegisterB
add wave -noupdate /proc/paramC
add wave -noupdate /proc/Reset
add wave -noupdate /proc/Clock
add wave -noupdate /proc/Run
add wave -noupdate /proc/Done
add wave -noupdate /proc/Multiclock
add wave -noupdate /proc/TemporaryRegister
add wave -noupdate /proc/registers
add wave -noupdate /proc/memory
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 171
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {980 ps}
view wave 
wave clipboard store
wave create -driver freeze -pattern counter -startvalue 0101000000000000 -endvalue 1111111111111111 -type Range -direction Up -period 50ps -step 1 -repeat forever -range 15 0 -starttime 0ps -endtime 100000ps sim:/proc/Input 
WaveExpandAll -1
wave create -driver freeze -pattern constant -value 1 -starttime 0ps -endtime 100000ps sim:/proc/Reset 
wave create -driver freeze -pattern clock -initialvalue HiZ -period 100ps -dutycycle 50 -starttime 0ps -endtime 100000ps sim:/proc/Clock 
wave create -driver freeze -pattern constant -value 1 -starttime 0ps -endtime 1000000ps sim:/proc/Run 
WaveCollapseAll -1
wave clipboard restore
