module CONV_256PE(
    input clk,
    input reset_n,
    input [256*8-1:0] IFM ,
    input [7:0] Weight,
    input [255:0] PE_restart,
    input [255:0] PE_finish,
    output [255:0] valid,
    output [256*8-1:0] OFM
);
    
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : PE_ARRAY
            PE pe_inst (
                .clk(clk),
                .reset_n(reset_n),
                .IFM(IFM[i*8 +: 8]),
                .Weight(Weight),
                .PE_restart(PE_restart[i]),
                .PE_finish(PE_finish[i]),
                .valid(valid[i]),
                .OFM(OFM[i*8 +: 8])
            );
        end
    endgenerate
    
endmodule