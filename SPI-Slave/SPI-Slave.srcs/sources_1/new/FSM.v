`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2021 01:44:18 PM
// Design Name: 
// Module Name: FSM
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


module FSM( input clk,
            input SS,
            input reset,
            input [1:0]command,
            output S1,
            output S2,
            output S3,
            output AddEN,
            output ShLD,
            output CMDEn,
            output ShEN   );
            
    reg [3:0]CurrState;
    parameter idle_state = 4'b0001;
    parameter CA_state = 4'b0010;
    parameter write_state = 4'b0100;
    parameter read_state = 4'b1000;
    reg[2:0] count;
    reg CA_count;
    reg r_ShEN;
    reg r_S3;
    reg r_S1;
    reg r_S2;
    reg r_AddEN;
    reg r_ShLD;
    reg r_CMDEn;
    assign CMDEn= r_CMDEn;
    assign ShEN = r_ShEN;
    assign S1 = r_S1;
    assign S2 =r_S2;
    assign S3 =r_S3;
    assign AddEN = r_AddEN;
    assign ShLD = r_ShLD;
    always @(posedge clk)
    begin
        if(reset == 0)
        begin
            CurrState <=idle_state;
            count<=0;
            CA_count <=0;
            r_AddEN<=0;
            r_ShEN<=0;
            r_S3<=0;
            r_S1<=1;
            r_S2<=1;
            r_ShLD<=0;
            r_CMDEn<=0;
        end
        else
        begin
            case(CurrState)
            idle_state:
            begin
                if(SS == 1'b0)
                begin
                    CurrState<=CA_state;
                    r_ShEN=1;
                    count<=0;
                    CA_count <=0;
                    r_AddEN<=0;
                    r_S3<=0;
                    r_S1<=1;
                    r_S2<=1;
                    r_ShLD<=0;
                    r_CMDEn<=0;
                end
                else
                begin
                    count<=0;
                    CA_count <=0;
                    r_AddEN<=0;
                    r_S3<=0;
                    r_S1<=1;
                    r_S2<=1;
                    r_ShLD<=0;
                    r_CMDEn<=0;
                end
            end
            CA_state:
            begin
                if(SS == 1'b1)
                    CurrState <= idle_state;
                else
                begin
                    count<=count+1;
                    if(count == 6 && CA_count ==1)
                    begin
                        if(command ==2'b11)
                        begin
                            CurrState <= read_state;
                            r_ShEN <=1;
                            r_ShLD<=1;
                            r_AddEN <=1;
                            count<=0;
                        end
                    end
                    if(count == 7)
                    begin
                        count<=0;
                        r_S3 <=1;
                        CA_count <=1;
                        if(CA_count == 1)
                        begin
                            r_S1 <= 1;
                            r_S2 <= 1;
                            CA_count<=0;
                            
                           if(command == 2'b10) begin
                                CurrState <= write_state;
                                r_ShEN <=1;
                                r_AddEN<=1;
                                end
                           else
                           begin
                                CurrState <= read_state;
                                r_ShEN <=1;
                                r_ShLD<=1;
                                r_AddEN <=1;
                           end
                        end
                        else
                            r_CMDEn<=1;
                    end
                    else 
                        r_CMDEn<=0;
                end
            end
            write_state:
            begin
                if(SS==1)
                begin
                    r_S3<=0;
                    r_ShEN <=0;
                    CurrState <= idle_state;
                    r_CMDEn=0;
                end
                else 
                begin
                    count<=count+1;

                    if(count==0) begin r_AddEN <=0; r_S2<=1; end 
                    if(count == 7)
                    begin
                        r_S2 <=0;
                        r_S1 <=0;
                        r_AddEN<=1;
                        count<=0;
                    end
                end
            end
            read_state:
            begin
                if(SS ==1)
                begin
                    r_ShLD<=0;
                    CurrState<=idle_state;
                    r_S3 <=0;
                    r_CMDEn=0;
                end
                else
                begin
                    if(count==0) begin r_AddEN <=0; r_ShLD<=0; end
                    count<=count+1;
                    if(count == 7)
                    begin
                        r_S2<=1;
                        r_S1<=0;
                        r_AddEN <=1;
                        r_ShLD<=1;
                        count<=0;
                    end
                    else
                    begin
                        r_ShLD <=0;
                    end
                end
            end
            default: 
            begin
                CurrState <= idle_state;
            end
            endcase
        end
    end
endmodule
