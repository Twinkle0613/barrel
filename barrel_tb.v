`timescale 1ns/1ns
/*
Check list
1. Global stimulus
2. Individual testCase?
3. Main Loop(initial block)
   -to control sequence of task
4.Error counting task/function 
5.Autocheck function using task/always block
6.use for loop / randomize data
7.$display/$monitor final sucess failure 
8.Force Error into design.
9.All test sets covered 
*/
module barrel_tb;

//SetUp I/O
reg clk,Load,reset;
reg [7:0]data_in;
reg [2:0]sel;
wire [7:0]data_out;
integer i,j;
reg errors = 0;
reg [7:0] expected;
barrel B2(clk,reset,Load,sel,data_in,data_out);
//barrel B2(.clk(clk),.Load(Load),.reset(reset),.sel(sel),.data_in(data_in),.data_out(data_out));
//SetUp reset
initial 
 begin 
 reset <= 1;
 @(posedge clk);
 @(negedge clk) reset = 0;
 end 

//----------------Main loop------------------//
initial 
 begin 
 Test_Given_load_is_1();
 $finish;
 end 
//-------------------------------------------// 

task Test_Given_load_is_1();

 begin 
  #2 Load = 1;
   for( i = 0; i < 3 ; i = i + 1)
	 begin 
	  data_in = {$random}%256;
	   for( j = 0; j < 8 ; j = j + 1)
		begin 
		 #3 sel = j; 
		 //shifter(j,shifterOut);
		 expected = ( data_in << sel ) | ( data_in >> sel); 
		 verifyOutput(expected,data_out);
		end 
	 end 
 end 
endtask 
/*
task shifter();
 input [32:0]N; 
 output [7:0]out; 
  begin 
   out = ( data_in >> N ) | ( data_in << N); 
  end 
endtask
*/
task verifyOutput;
 input[7:0] expValue;
 input[7:0] actValue;
begin 
 if(actValue[7:0] != expValue[7:0])
   begin
    errors = errors + 1;
    $display("Expected %b was %b , error collection is %d at %d",expValue,actValue,errors,$time);
   end 
end 
endtask

initial 
 begin 
	clk <= 0 ;
	forever #1 clk = ~clk;
 end 

initial 
 begin 
  $display(" clk | reset | Load | Sel | data_in | data_out | expected");
  $monitor("  %b |  %b   |  %b  | %b  | %b | %b | %b |",clk,reset,Load,sel,data_in,data_out,expected); 
 end  
 
 
endmodule 
