this is basically a sequential-combinational way of finding the product , also pipe-line design is also introduced  in here.

most of u will get just by looking thru dis example.

eg :-> 						   (bits of mplr)

											level[0]			level[1]		level[2]

1011011101			    
*    10110    ===>          0 }		[0]		prod[0]		}		prod[0]  	}    prod[0] => final product				
				   1011011101 }		[1]					}					}
				   										}               	}
				   1011011101 }		[1]		prod[1]		}				    }
				            0 }		[0]										}
				            												}	
				   1011011101 }		[1]		prod[2]		}		prod[1]		}

				   total clock-cycles it took is just log(n) where n is max number of bits take here in n as 16 hence its just log(16) => 4 clock cycles [wohoo]

i range is from [0-15]
as product can be max of 32bits.

from i=0 to 
i.e prod[i+1][i] = prod[i][2*i] + prod[i][2*i +1]

but initially i.e prod[0] array is stored in such a way that no need of left shifting in ahead levels is needed.
i.e

n<=8

for(i=0;i<n;i++)
begin
	prod[0][i]<=add(a<<((2*i)*b[2*i]) ,a<<((2*i+1)*b[2*i+1]));
end

* after this initialization is done ,

rule fire!;
let x=n>>1;
for(i=0;i<3;i++)
begin
	for(j=0;j<x;j=j+1)
	begin
		prod[i+1][j]<=add(prod[i][2*j],prod[i][2*j+1],0);
	end
x <= x>>1;
end
endrule

* and the most desired the product is allset in prod[3][0]

implementation
______________

[]	[]	[]	[]
[]	[]	[]
[]	[]
[]	[]
[]	
[]
[]
[]

by this design pipeline is achieved in log(n) clock cycles