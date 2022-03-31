`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2022 03:10:20 PM
// Design Name: 
// Module Name: bram_test
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module bram_test();

//--------defining the variables---------------
reg clk;                     // Input to desing must be 'reg' and output as 'wire'
reg ena;
reg wea;
reg [3:0] t_addr;
reg [15:0] t_din;
wire [15:0] t_dout;
reg [15:0] rx_data;

//-----------------------------


//------------------initiating the design module----------------

bram bram_test (
  .clka(clk),    // input wire clka
  .ena(ena),      // input wire ena
  .wea(wea),      // input wire [0 : 0] wea
  .addra(t_addr),  // input wire [3 : 0] addra
  .dina(t_din),    // input wire [15 : 0] dina
  .douta(t_dout)  // output wire [15 : 0] douta
);







//------------------generating clock -------------
 always #5  clk  = ~clk;



//----------------------
///------------define write task ------------

task write_data(input reg [3:0]addr, input reg [15:0]data);
 begin  
    @(posedge clk)    //----generating writing request
    begin
      ena = 1;
      wea = 1;                 //----write
      t_addr = addr;
      t_din = data;   
    end


    @(posedge clk)    //----deasserting the write request on next clock 
    begin
      ena = 0;
      wea = 0;
      t_addr = 0;
      t_din = 0;   
    end

end    
endtask



task read_data(input reg [3:0]addr, output reg [15:0]data);
   begin
    @(posedge clk)    //----generating reading request
    begin
      ena = 1;
      wea = 0;                 //----reading
      t_addr = addr;
  //    t_din = data;   
    end
 
/*
    @(posedge clk)    //----deasserting the write request on next clock 
    begin
      ena = 0;
      wea = 0;
      t_addr = 0;   
    end
    */
/*
    @(posedge clk)    //----deasserting the write request on next clock 
    begin
        data = t_dout; 
    end */
  end  
endtask
//---------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------








//--------------initialising the variables------------






initial
begin

 clk = 0;
#10; 
 ena = 0;
 wea =0;
 t_addr = 0 ;
 t_din =0;

//-------------writing data to BRAM----------------
  for(integer i=0; i<16; i=i+1)
    write_data(i,'h1000+i);

#200;
      ena = 0;
      wea = 0;
      t_addr = 0;   

//-------------reading data of BRAM----------------
  for(integer i=0; i<16; i=i+1)
    begin 
     read_data(i,rx_data);
    end

      ena = 0;
      wea = 0;
      t_addr = 0;   
    
#100;
      ena = 0;
      wea = 0;
      t_addr = 0;   


end



endmodule
