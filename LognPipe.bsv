package LognPipe; 

import Multiplier::*;

(* synthesize *)
module mkLognPipe( Multiplier_IFC );
Reg#(Bit#(32)) a <- mkReg(0);      
Reg#(Bit#(32)) b <- mkReg(0);      
Reg#(Bit#(32)) prod[8][8];
Reg#(Bool) valid[4];
Reg#(Bool) appocalypse <- mkReg(False);
          
for(Integer i=0;i<4;i=i+1)
begin
valid[i] <- mkReg(False);
end

Integer cop=8;

for(Integer i=0;i<4;i=i+1)
begin
	for(Integer j=0;j<cop;j=j+1)
	begin
		prod[i][j]<-mkReg(0);
	end
	cop=cop/2;
end

function Bit#(2) addsingle(Bit#(1) x, Bit#(1) y, Bit#(1) fof);
let sum = x^y^fof;
let ofo = (x & y) | (fof & (x ^ y));
return {ofo,sum};
endfunction

function Tout addit(Tout x, Tout y, Bit#(1)c);
Tout sum;
for(Integer i=0; i<valueof(32); i=i+1)
begin
let ts= addsingle(x[i],y[i],c);
c = ts[1]; sum[i] = ts[0];
end
return sum;
endfunction 

rule firo;
Tin x=4;
for(Tin i=0;i<3;i=i+1)
begin
	if(valid[i])
	begin
		for(Tin j=0;j<x;j=j+1)
		begin
			prod[i+1][j]<=addit(prod[i][2*j],prod[i][2*j+1],0);
		end
	end
	x = x>>1;
	valid[i+1]<=valid[i];
end
endrule

rule first_set(appocalypse);
for(Tin i=0;i<8;i=i+1)
begin
	prod[0][i]<=addit((a<<((2*i)))*(extend (b[2*i])),(a<<(2*i+1))*(extend (b[2*i +1])),0);
end
valid[0]<=True;
endrule

method Action start(Tin m1,Tin m2);
a<={0,m1};
b<={0,m2};
appocalypse<=True;
endmethod

method Action acknowledge();
valid[0]<=False;
appocalypse<=False;
endmethod

method Tout result() if(valid[3]); 
return prod[3][0];
endmethod

method Bit#(1) yes_or_no();
let x=0;
if(valid[3])
x=1;
return x;
endmethod


endmodule : mkLognPipe

endpackage : LognPipe

