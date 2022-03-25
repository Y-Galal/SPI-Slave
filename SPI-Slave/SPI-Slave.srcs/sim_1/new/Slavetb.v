`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2021 04:31:48 PM
// Design Name: 
// Module Name: Slavetb
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


module Slavetb;

reg MOSI,SS,clk,SCLK,reset; 
reg [7:0]readData;
wire MISO;
wire command_OP;
wire [7:0]WAddress;
wire [7:0]WData;

Slave S1(      MOSI,
               SS,
               clk,
               SCLK,
               reset,
               readData,
               MISO,
               command_OP,
               WAddress,
               WData);
               
always #10 clk=~clk;

initial
begin
    clk=0;
    SCLK=0;
    reset =0;
    SS=1;
    readData=0;
    MOSI=1;
    #110;
//    //Starting Simulation
    #10;
    SS=0;
    reset=1;
    
//    // sending command write 0x02 (0000 0010)
    MOSI= 0;
    #20;
    MOSI=1;
    #20;
    MOSI=0;
    #120;
    // Sending Address 0xF0
    MOSI=1;
    #80;
    MOSI=0;
    #80;
    // sending data of 0x12 (0001 0010)
    MOSI=0;
    #20;
    MOSI=1;
    #20;
    MOSI=0;
    #40;
    MOSI=1;
    #20;
    MOSI=0;
    #60;
    //Sending another 8 bits 0x03
    MOSI=1;
    #40;
    MOSI=0;
    #120;
    //Sending another 8 bits 0x01
    MOSI=1;
    #20;
    MOSI=0;
    #140;
    #20;
    SS=1; // ending the transaction
    
    // sending read command 0x03 (0000 0011) from address 0xF0 (1111 0000)
    
    #200;
    SS=0;
    MOSI=1;
    #40;
    MOSI=0;
    #120;
    //Sending Address
    MOSI=0;
    #20;
    MOSI=0;
    #20;
    MOSI=0;
    #20;
    MOSI=0;
    #20;
    MOSI=1;
    #20;
    MOSI=1;
    #20;
    MOSI=1;
    #20;
    MOSI=1;
    #20;

    readData=8'b10101010;
    #160;
    readData=8'hab;
    #160;
    readData=8'b11110000;
    #160;
    SS=1;
    
    
end

always@(*)
begin
    if(SS==0)
        SCLK<=clk;
    else
        SCLK<=0;
end

endmodule
