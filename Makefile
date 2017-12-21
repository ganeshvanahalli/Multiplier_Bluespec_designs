LABNAME = Design and analysis of single cycle, multi-cyle and pipelined multiplier circuits.
SHORTNAME = Mult 
SMOKENAME = Mult 

## Default simulator is iverilog
VSIM = -vsim iverilog

.PHONY: help
help:
	@echo "Lab: $(LABNAME)"
	@echo "Useful targets:"
	@echo "single -- Builds the single cycle circuit."
	@echo "multi -- Builds the multi cycle circuit."
	@echo "pipe -- Builds the pipelined circuit."
	@echo "  clean          --  remove intermediate files"
	@echo "  help           --  display this message"

#.PHONY: single
single: Multiplier.bsv Single.bsv SingleTb.bsv
	@echo "Compiling into verilog files"
	bsc -verilog -u SingleTb.bsv	
	@echo "Generting the simulation object"
	bsc -verilog -e  mkSingleTb -o SingleTb.bsim


multi: Multiplier.bsv Multi.bsv MultiTb.bsv
	@echo "Compiling into verilog files"
	bsc -verilog -u MultiTb.bsv	
	@echo "Generting the simulation object"
	bsc -verilog -e mkMultiTb -o MultiTb.bsim

multiLFSR: Multiplier.bsv Multi.bsv MultiTbLFSR.bsv
	@echo "Compiling into verilog files"
	bsc -verilog -u MultiTbLFSR.bsv	
	@echo "Generting the simulation object"
	bsc -verilog -e mkMultiTb -o MultiTb.bsim

pipe: Multiplier.bsv Pipe.bsv PipeTb.bsv
	@echo "Compiling into verilog files"
	bsc -verilog -u PipeTb.bsv	
	@echo "Generting the simulation object"
	bsc -verilog -e  mkPipeTb -o PipeTb.bsim

lognPipe: Multiplier.bsv LognPipe.bsv LognPipeTb.bsv
	@echo "Compiling into verilog files"
	bsc -verilog -u LognPipeTb.bsv	
	@echo "Generting the simulation object"
	bsc -verilog -e  mkLognPipeTb -o LognPipeTb.bsim

.PHONY: clean
clean:
	@rm -f *.bi *.bo *.ba mk*.c mk*.h mk*.o mk*.v *_c *_v *.vcd *~ *.fsdb *.log *.bsim
