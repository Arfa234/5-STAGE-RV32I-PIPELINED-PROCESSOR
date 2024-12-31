module tb_Pipeline_module();
 reg clk=0, rst;
 always begin
 clk = ~clk;
 #50; end
 initial begin
 rst <= 1'b0;
 #200;
 rst <= 1'b1;
#500000
$stop;
 end
 initial begin
 $dumpfile("dump.vcd");
 $dumpvars(0, tb_Pipeline_module);
 end
 Pipeline_top dut (.clk(clk), .rst(rst));
endmodule
