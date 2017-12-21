package PipeTb;

// testbench for Pipe

import Multiplier::*;
import FIFO::*;
import FIFOF::*;
import Pipe::*;



Tin notestinputs = 99;
Tin notestinput = 14;

(* synthesize *)
	module mkPipeTb (Empty);

	Reg#(Tin) cycle <- mkReg(0);
	Reg#(Tin) x    <- mkReg(1);
	Reg#(Tin) y    <- mkReg(0);
	Reg#(Tin) a    <- mkReg(?);
	Reg#(Tin) b    <- mkReg(?);
	FIFO#(Tin) inQ1 <- mkSizedFIFO(18);
	FIFO#(Tin) inQ2 <- mkSizedFIFO(18);
	
	// The dut
	Multiplier_IFC dut <- mkPipe;

	// RULES ----------------
	rule cyclecount;
	$display("------Cycle %0d------", cycle);
	cycle <= cycle + 1;
	endrule 

	rule rule_tb_1 (x < notestinputs);
	dut.start (x, y);
	x <= x + 1;
	y <= y + 1;
	inQ1.enq(x);
	inQ2.enq(y);
	endrule

	rule rule_tb_2(dut.yes_or_no()==1);
	$display("Rule tb2 fired");
	let z = dut.result();
	Tout m = {0,inQ1.first()};
	Tout n = {0,inQ2.first()};
	inQ1.deq();
	inQ2.deq();
	let l = m*n;
	$display("multiplier = %0d multiplicand = %0d in pipeline though. :P",m,n);
	$display("    Result = %0d Expected = %0d", z, l);
	if (z != l) 
	begin
	$display("Error"); 
	$finish(0);
	end
	$display("-------------------------------");
	endrule

	rule mvasz(x>=notestinputs);
	dut.acknowledge();
	endrule

	// TASK: Add a rule to invoke $finish(0) at the appropriate moment
	rule stop(cycle>notestinputs+notestinput);
	$display("\t finish");
	$finish(0);
	endrule


	endmodule : mkPipeTb

	endpackage : PipeTb

