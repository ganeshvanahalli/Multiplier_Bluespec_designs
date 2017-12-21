package Multiplier; 

// Multiplier IFC

typedef Bit#(16) Tin;
typedef Bit#(32) Tout;

interface Multiplier_IFC;
    method Action  start (Tin m1, Tin m2);
    method Action acknowledge();
    method Tout    result();
    method Bit#(1) yes_or_no();
endinterface
        
endpackage
 