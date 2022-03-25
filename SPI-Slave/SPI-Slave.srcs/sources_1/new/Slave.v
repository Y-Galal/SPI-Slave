`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2021 01:36:48 PM
// Design Name: 
// Module Name: Slave
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


module Slave( input MOSI,
              input SS,
              input clk,
              input SCLK,
              input reset,
              input [7:0] readData,
              output MISO,
              output RW,
              output [7:0]WAddress,
              output [7:0]WData);
    reg [1:0]command; 
    reg r_MISO;
    reg [7:0]r_WAddress;
    reg [7:0]r_WData;
    reg r_RW;
    wire S1,S2,S3,AddEN,ShLD,ShEN,CMDEn;
    FSM F1( clk,SS, reset,command,S1,S2,S3,AddEN,ShLD,CMDEn,ShEN   );
    
    reg [7:0]ShiftReg;
    reg [7:0] Add_ShReg;
    assign RW=r_RW;
    assign MISO =r_MISO;
    assign WData=r_WData;
    assign WAddress=r_WAddress;
    always@(posedge clk)
    begin
        if(reset==0)
        begin
            ShiftReg<=0;
        end
    end
    
  
    
    always@(posedge SCLK)
    begin    
        if(S2 ==1)
        begin
            Add_ShReg<=ShiftReg;
            r_RW<= 0;
        end
        else
        begin
            r_WData<=ShiftReg;
            r_RW <= (^command);
        end
        
        if(AddEN == 1)
            begin
            if(S1==1 )
            begin
                if(command == 2'b10)
                    r_WAddress <= ShiftReg-1;
//               else if(command == 2'b11)
//                    r_WAddress <=ShiftReg;
            end
            else 
            begin
            if(command == 2'b10)
                r_WAddress <= r_WAddress +1'b1;
            end
        end
 
          
          
        if(S3 == 1)
        begin
        if(CMDEn == 1) begin
          command<=ShiftReg[1:0];
          end
        end
        else
        begin
          command<=2'b01;
        end
        
        if(ShEN == 1)
        begin
                
                ShiftReg <= {MOSI, ShiftReg[7:1]};
        end
        else
        begin
            ShiftReg <= ShiftReg;
        end
        
        
        
    end

always@(negedge SCLK)
begin
        if(AddEN ==1 && S1==1)
        begin
            if(command == 2'b11)
                    r_WAddress <=ShiftReg;
        end
        else if(AddEN==1 && S1==0 && command == 2'b11)
        begin
            r_WAddress<=r_WAddress+1;
        end
end

always@(negedge SCLK)
begin

       if(ShLD == 1'b1)
        begin
            ShiftReg = readData;
            r_MISO=ShiftReg[0];
        end
        else if(ShEN == 1'b1)
        begin
          r_MISO=ShiftReg[0];
        
        end

end

    
endmodule














