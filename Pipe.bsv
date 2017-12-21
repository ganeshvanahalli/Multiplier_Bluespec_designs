package Pipe; 

import Multiplier::*;

//concept is to left shift and add multiplicand if and only if the mplr[0] i.e intermediate_b[0]==1; aand right shifting intermediate_b every time; 

(* synthesize *)
module mkPipe( Multiplier_IFC );
Reg#(Bit#(32)) intermediate_a[17];      
Reg#(Bit#(32)) intermediate_b[17];      
Reg#(Bit#(32)) intermediate_value[17];
Reg#(Bool) valid[17];
          
for(Integer i=0;i<17;i=i+1)
begin
intermediate_a[i] <- mkReg(0);
intermediate_b[i] <- mkReg(0);
intermediate_value[i] <- mkReg(0);
valid[i] <- mkReg(False);
end

function Bit#(2) addsingle(Bit#(1) a, Bit#(1) b, Bit#(1) fof);
let sum = a^b^fof;
let ofo = (a & b) | (fof & (a ^ b));
return {ofo,sum};
endfunction

function Tout addit(Tout a, Tout b, Bit#(1)c);
Tout sum;
for(Integer i=0; i<valueof(32); i=i+1)
begin
let ts= addsingle(a[i],b[i],c);
c = ts[1]; sum[i] = ts[0];
end
return sum;
endfunction 


rule everytime;
for(Integer i=0;i<16;i=i+1)
begin
	if(valid[i])
	begin
		if(intermediate_b[i][i]==1)
		begin
		intermediate_value[i+1]<= addit(intermediate_value[i],intermediate_a[i]<<i,0);   
		end
		if(intermediate_b[i][i]==0)
		begin
		intermediate_value[i+1]<=intermediate_value[i];
		end
		intermediate_a[i+1]<=intermediate_a[i];
		intermediate_b[i+1]<=intermediate_b[i];

	end
valid[i+1]<=valid[i];
end
endrule

method Action start(Tin m1,Tin m2);
intermediate_a[0]<={0,m1};
intermediate_b[0]<={0,m2};
intermediate_value[0]<=0;
valid[0]<=True;
endmethod

method Action acknowledge();
valid[0]<=False;
endmethod

method Tout result() if(valid[16]); 
return (intermediate_value[16]);
endmethod

method Bit#(1) yes_or_no();
let x=0;
if(valid[16])
x=1;
return x;
endmethod


endmodule : mkPipe

endpackage : Pipe

