vlog -f sourcefile.txt -svinputport=relaxed +cover -covercells
vlog -cover bcesft ../Dut/Sync_Buffer.sv
vsim -voptargs=+acc work.Top_FIFO -cover +assertdebug
run -all
coverage save FIFO_TB.ucdb
