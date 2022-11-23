module Alu_Control(
	opcode,
	func_field,
	alu_control
    );
	 
input [5:0] opcode;
input [5:0] func_field;
output reg [2:0] alu_control;
reg [2:0] func_code;

always @ (*)
begin
	case (func_field)
	6'h20: func_code = 3'h0;
	6'h22: func_code = 3'h1;
	6'h24: func_code = 3'h2;
	6'h25: func_code = 3'h3;
	6'h27: func_code = 3'h4;
	6'h2A: func_code = 3'h5;
	default: func_code = 3'h0;
	endcase

	case (opcode)
	6'h00: alu_control = func_code;
	6'h04: alu_control = 3'h1;
	6'h23: alu_control = 3'h0;
	6'h2B: alu_control = 3'h0;
	default: alu_control = 3'h0;
	endcase
end
endmodule

module Alu_Core(
	A,
	B,
	alu_control,
	result,
	zero
    );

input [31:0] A;
input [31:0] B;
input [2:0] alu_control;
output reg [31:0] result;
output wire zero;

assign zero = !(|result);

always @ (*)
begin
	case(alu_control)
	3'h0: result = A + B;
	3'h1: result = A - B;
	3'h2: result = A & B;
	3'h3: result = A | B;
	3'h4: result = ~(A | B);
	3'h5: result = (A < B);
	default: result = A + B;
	endcase
end
endmodule

module Alu_Top(
	opcode,
	func_field,
	A,
	B,
	result,
	zero
    );

input [5:0] opcode;
input [5:0] func_field;
input [31:0] A;
input [31:0] B;
output [31:0] result;
output zero;
wire [2:0] alu_control;

Alu_Control alu_ctrlr_inst (
.opcode (opcode),
.func_field (func_field),
.alu_control (alu_control)
);

Alu_Core alu_core_inst (
.A (A),
.B (B),
.alu_control (alu_control),
.result (result),
.zero (zero)
);

endmodule

module Alu_Top_tb;

// Inputs
reg [5:0] opcode;
reg [5:0] func_field;
reg [31:0] A;
reg [31:0] B;

// Outputs
wire [31:0] result;
wire zero;

// Instantiate the Unit Under Test (UUT)
Alu_Top uut (
	.opcode(opcode), 
	.func_field(func_field), 
	.A(A), 
	.B(B), 
	.result(result),
	.zero(zero)
);

initial begin
	$dumpfile("Alu_Top_tb.vcd");
	$dumpvars(0, Alu_Top_tb);
	// Initialize Inputs
	opcode = 0;
	func_field = 0;
	A = 0;
	B = 0;
	
	#30;
	A=32'h2222; B=32'h1111;
	opcode=6'h00;func_field=6'h20; 
	#30;
	opcode=6'h00;func_field=6'h24;
	#30;
	opcode=6'h23;func_field=6'h00;
	#30;
	A=31'h5555; B=32'h5555;
	opcode=6'h04;func_field=6'h00;
	#30;
	A=32'h1111; B=32'h2222;
	opcode=6'h00;func_field=6'h2A;
	#30;

	$finish;
end
      
endmodule