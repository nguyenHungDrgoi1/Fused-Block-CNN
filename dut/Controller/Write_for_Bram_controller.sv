module Write_for_Bram_controller(
    input clk,
    input reset_n,
    input valid,
    output logic [31:0] write_addr,
    input [15:0] OFM_C

);
    always_ff @(posedge clk or negedge reset_n ) begin
        if(~reset_n) begin
            write_addr <= 0;
        end
        else begin
            if(valid) begin
                if(write_addr == ( OFM_C >> 3 ) - 1) begin
                    write_addr <= 0;
                end
                else  begin
                    write_addr <= write_addr + 1;
                end
            end
        end
    end
endmodule 