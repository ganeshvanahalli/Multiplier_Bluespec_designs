package LognPipeTb;

// testbench for LognPipe

import Multiplier::*;
import FIFOF::*;
import LognPipe::*;



Tin notestinputs = 99;
Tin notestinput = 14;

(* synthesize *)
	module mkLognPipeTb (Empty);

	Reg#(Tin) cycle <- mkReg(0);
	Reg#(Tin) x    <- mkReg(1);
	Reg#(Tin) y    <- mkReg(0);
	Reg#(Tin) a    <- mkReg(?);
	Reg#(Tin) b    <- mkReg(?);
	FIFOF#(Tin) inQ1 <- mkSizedFIFOF(6);
	FIFOF#(Tin) inQ2 <- mkSizedFIFOF(6);
	
	// The dut
	Multiplier_IFC dut <- mkLognPipe;

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
	$display("multiplier = %0d multiplicand = %0d in LognPipeline though. :P",m,n);
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
	rule stop(cycle>notestinputs && inQ1.notEmpty);
	$display("\t finish");
	$finish(0);
	endrule


	endmodule : mkLognPipeTb

	endpackage : LognPipeTb

