package Single; 

import Multiplier::*;

(* synthesize *)
module mkSingle( Multiplier_IFC );
Reg#(Bool)     available   <- mkReg(True);
Reg#(Bit#(16)) mplr        <- mkReg(0);
Reg#(Bit#(32)) product     <- mkReg(?);

function Bit#(2) addsingle(Bit#(1) a, Bit#(1) b, Bit#(1) fof);
let sum = a^b^fof;
let ofo = (a & b) | (fof & (a ^ b));
return {ofo,sum};
endfunction

function Bit#(17) addit(Tin a, Tin b, Bit#(1)c);
Tin sum;
for(Integer i=0; i<valueof(16); i=i+1)
begin
let ts= addsingle(a[i],b[i],c);
c = ts[1]; sum[i] = ts[0];
end
return {c,sum};
endfunction

function Tin lolo(Bit#(17) a);
Tin x;
for(Integer i=0;i<valueof(16);i=i+1)
begin
x[i]=a[i+1];
end
return x;
endfunction

function Tout multiplyit(Tin a, Tin b);
Tin prod = 0;
Tin tp=0;
for(Integer i = 0; i < valueof(16); i = i+1)
begin
Tin m = (a[i]==0)? 0 : b;
Bit#(17) sum = addit(m,tp,0);
prod[i] = sum[0];
tp = lolo(sum);
end
return {tp,prod};
endfunction

method Action start(Tin m1, Tin m2) if ((mplr == 0) && available);
available <= False;
product<= multiplyit(m1,m2);
mplr<=1;
endmethod

method Tout result() if (!available);
return {product};
endmethod

method Action acknowledge() if ((mplr == 1) && !available);
available <= True;
mplr<=0;
endmethod

method Bit#(1) yes_or_no() if(1==2);
return 0;
endmethod

endmodule : mkSingle

endpackage : Single
