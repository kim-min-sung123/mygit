
module add_subNbit_v2 #(parameter N = 4)(
    input [N-1:0] A, // 4bit bus A [Msb:Lsb]
    input [N-1:0] B,
    input Cin,
    output [N-1:0] S,
    output Cout
  );	
    
    assign {Cout,S} = A + ( B ^ {N{Cin}} ) + Cin; 
	 // if add, cin=0 or if sub, cin=1
endmodule




