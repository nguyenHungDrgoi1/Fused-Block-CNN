module address_generator #(
    parameter TOTAL_PE   = 16,
    parameter DATA_WIDTH = 32
)(
    input  wire clk,
    input  wire rst_n,
    input  wire [3:0] KERNEL_W,
    input  wire [7:0] OFM_W,
    input  wire [7:0] OFM_C,
    input  wire [7:0] IFM_C,
    input  wire [7:0] IFM_W,
    input  wire [1:0] stride,
    input  wire ready,
    input  wire [31:0] addr_in,

    output wire [31:0] req_addr_out_ifm,
    output wire [31:0] req_addr_out_filter,
    output reg done_compute,
    output reg addr_valid_ifm,
    output wire addr_valid_filter
);

wire in_progress;
reg [7:0] count_for_a_Window;
reg [7:0] count_for_a_OFM;
reg [7:0] row_index_KERNEL;
reg [7:0] col_index_KERNEL;

reg [7:0] row_index_OFM;
reg [7:0] col_index_OFM;
reg [7:0] tiles_count;
reg [31:0] addr_fetch_ifm;
reg [31:0] predict_line_addr_fetch_ifm;
reg [31:0] predict_window_addr_fetch_ifm;
reg [31:0] predict_window_OFM_addr_fetch_ifm;
reg [31:0] addr_fetch_filter;
reg [31:0] window_start_addr_ifm;
reg [31:0] window_start_addr_filter;


wire [7:0] num_of_tiles = IFM_C >> 2; 
wire [7:0] num_of_tiles_for_PE = OFM_C >> 4;

// FSM state encoding for IFM
parameter START_ADDR_IFM        = 3'b000;
parameter FETCH_WINDOW      = 3'b001;
parameter NEXT_WINDOW      = 3'b010;

reg [2:0] current_state_IFM, next_state_IFM;


// FSM state encoding for WEIGHT
parameter START_ADDR_FILTER    = 1'b0;
parameter FETCH_FILTER  = 1'b1;
reg current_state_FILTER, next_state_FILTER;

//---------------------------------------------------IFM---------------------------------------------------------//
// FSM State Register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        current_state_IFM <= START_ADDR_IFM;
    else
        current_state_IFM <= next_state_IFM;
end

// FSM Next State Logic
always @(*) begin
    case (current_state_IFM)
        START_ADDR_IFM: begin
            if ( ready ) begin
                next_state_IFM =    FETCH_WINDOW ;
            end else begin
                next_state_IFM =    START_ADDR_IFM;
                done_compute            <=  0;
            end
            addr_valid_ifm  = 1'b0;
        end

        FETCH_WINDOW: begin
            
            if ( count_for_a_Window < KERNEL_W * KERNEL_W* num_of_tiles*num_of_tiles_for_PE  -1) begin
                next_state_IFM =    FETCH_WINDOW ;
                
            end else begin
                next_state_IFM =    NEXT_WINDOW;
            end
            addr_valid_ifm  = 1'b1;
        end

        NEXT_WINDOW: begin
            count_for_a_Window  = 'b0;
            row_index_KERNEL        <= 'b0;
            col_index_KERNEL        <= 'b0;
            if (count_for_a_OFM < OFM_W*OFM_W -1 )   begin
                next_state_IFM =    FETCH_WINDOW ;
                addr_fetch_ifm          <= predict_window_addr_fetch_ifm ;
            end else begin
                next_state_IFM =    START_ADDR_IFM;
                done_compute            =  1;
            end
            addr_valid_ifm  = 1'b1;
        end

        default: begin
            next_state_IFM = START_ADDR_IFM;
            addr_valid_ifm  = 1'b0;
        end

    endcase
end

                
// FSM Output Logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        predict_line_addr_fetch_ifm         <= 0;
        predict_window_addr_fetch_ifm       <= 0;
        predict_window_OFM_addr_fetch_ifm   <= 0;

    end
    else begin
        if ( (row_index_KERNEL == KERNEL_W * num_of_tiles -4 )  ) begin 
            if ( col_index_KERNEL != (KERNEL_W -1))
            predict_line_addr_fetch_ifm <= predict_line_addr_fetch_ifm + IFM_C*IFM_W ;
            else predict_line_addr_fetch_ifm <= window_start_addr_ifm  ;
        end
        if ( (row_index_KERNEL == KERNEL_W * num_of_tiles -3 ) && ( col_index_KERNEL == KERNEL_W -1  )  && ( tiles_count == num_of_tiles_for_PE -1  ) ) begin 
            predict_window_addr_fetch_ifm <= window_start_addr_ifm + IFM_C ;
            //window_start_addr_ifm <= window_start_addr_ifm + IFM_C ;
            predict_line_addr_fetch_ifm <= window_start_addr_ifm + IFM_C ;
        end
        if ( (row_index_KERNEL == KERNEL_W * num_of_tiles -2 ) && ( col_index_KERNEL == KERNEL_W -1  ) && ( tiles_count == num_of_tiles_for_PE -1  ) && ( row_index_OFM == OFM_W -1 ) ) begin 
            predict_window_OFM_addr_fetch_ifm <= window_start_addr_ifm + IFM_C * KERNEL_W ;
            predict_window_addr_fetch_ifm      <= window_start_addr_ifm + IFM_C * KERNEL_W ;
            predict_line_addr_fetch_ifm        <= window_start_addr_ifm + IFM_C * KERNEL_W ;
        end
    end
end

// FSM Output Logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        addr_fetch_ifm          <= addr_in;
        addr_valid_ifm          <= 1'b0;
        count_for_a_Window      <= 1'b0;
        row_index_KERNEL        <= 8'b0;
        count_for_a_OFM         <= 8'b0;
        col_index_KERNEL        <= 8'b0;
        row_index_OFM           <= 8'b0;
        col_index_OFM           <= 8'b0;
        tiles_count             <= 8'b0;
        done_compute            <= 1'h0;
    end else begin
        case (current_state_IFM)
            START_ADDR_IFM: begin
                if ( ready ) begin
                    row_index_KERNEL        <= 8'b0;
                    col_index_KERNEL        <= 8'b0;
                    col_index_OFM           <= 8'b0;
                    count_for_a_Window      <= 8'b0;
                    //count_for_a_OFM         <= 8'b0;
                    window_start_addr_ifm   <= 0;
                end else begin
                end
                
            end

            FETCH_WINDOW: begin
                count_for_a_Window  <= count_for_a_Window + 'b1;
                
                if ( count_for_a_Window < KERNEL_W * KERNEL_W* num_of_tiles*num_of_tiles_for_PE  -1) begin
                    //if ( count_for_a_Window ==0  ) window_start_addr_ifm   <= addr_fetch_ifm;
                    
                    if (row_index_KERNEL < KERNEL_W * num_of_tiles -1 ) begin  
                        row_index_KERNEL    <= row_index_KERNEL + 1'b1;
                        addr_fetch_ifm  <= addr_fetch_ifm + 'h4;  
                                       
                    end  
                    else
                    begin
                        
                        if (row_index_KERNEL == KERNEL_W * num_of_tiles -1) begin
                        row_index_KERNEL        <= 'b0;
                        addr_fetch_ifm  <= predict_line_addr_fetch_ifm;
                        end
                        if (col_index_KERNEL    <   KERNEL_W -1 ) begin
                            col_index_KERNEL        <= col_index_KERNEL + 1'b1;
                        end
                        else
                        begin
                            col_index_KERNEL        <= 'b0;
                            if ( tiles_count < num_of_tiles_for_PE)  begin  
                                //addr_fetch_ifm <= window_start_addr_ifm;
                                tiles_count <=    tiles_count +1'b1 ;
                                
                            end
                        end
                    
                    end
                end else begin
                end
            addr_valid_ifm  = 1'b1;
            end 

            NEXT_WINDOW: begin
                
                count_for_a_OFM     <= count_for_a_OFM + 'b1;
                tiles_count             <= 0;
                window_start_addr_ifm   <= predict_window_addr_fetch_ifm;
                if (row_index_KERNEL == 0) row_index_KERNEL <= row_index_KERNEL +1;
                if (count_for_a_Window == 0) count_for_a_Window <= count_for_a_Window +1;    
                if (count_for_a_OFM    <   OFM_W*OFM_W-1) begin
                    
                    if ( row_index_OFM < OFM_W-1) begin
                        addr_fetch_ifm          <= addr_fetch_ifm +'h4 ;
                        row_index_OFM           <= row_index_OFM +1;
                        
                    end
                    else
                    begin
                        addr_fetch_ifm          <= addr_fetch_ifm +'h4 ;
                        col_index_OFM           <= col_index_OFM + 1'b1;   
                        row_index_OFM           <=  0;
                        if ( col_index_OFM < OFM_W) begin
                            //addr_fetch_ifm       <= predict_window_OFM_addr_fetch_ifm  ;
                            
                        end
                        else 
                        begin
                            
                        end
                    end


                end else begin    
                end
                if (count_for_a_OFM >= OFM_W*OFM_W -1 )   begin
                    
                end else begin
        
                end
                


            end

            default: begin
                addr_valid_ifm  <= 1'b0;
                
            end
        endcase
    end
end




assign req_addr_out_ifm = addr_fetch_ifm;


//---------------------------------------------------WEIGHT---------------------------------------------------------//
// FSM State Register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        current_state_FILTER <= START_ADDR_FILTER;
    else
        current_state_FILTER <= next_state_FILTER;
end


// FSM Next State Logic
always @(*) begin
    case (current_state_FILTER)
        START_ADDR_FILTER: begin

            if ( ready ) begin
                next_state_FILTER           <=  FETCH_FILTER ;
                addr_fetch_filter           <=  addr_in;
            end else begin
                next_state_FILTER = START_ADDR_FILTER;
            end

        end
        FETCH_FILTER: begin
         
            if (count_for_a_Window <  KERNEL_W * KERNEL_W* num_of_tiles*num_of_tiles_for_PE  -1) begin
                next_state_FILTER = FETCH_FILTER;
            end else begin
                next_state_FILTER = START_ADDR_FILTER;
            end
        end
        default: 
            next_state_FILTER = START_ADDR_FILTER;
    endcase
end


// FSM Output Logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        addr_fetch_filter                           <= addr_in;
    end else begin
        case (current_state_FILTER)
            START_ADDR_FILTER: begin
                if ( ready ) begin
                    window_start_addr_filter        <= addr_fetch_filter;
                    if ( addr_valid_ifm ==1 )  addr_fetch_filter               <= addr_fetch_filter + 'h4; 
                end 
            end

            FETCH_FILTER: begin
                if ( addr_valid_ifm ==1 ) begin
                    addr_fetch_filter               <= addr_fetch_filter + 'h4;  
                end                 
            end
            
            default: begin
                addr_fetch_filter  <= 'b0;
                
            end
        endcase
    end
end

assign addr_valid_filter   = addr_valid_ifm;
assign req_addr_out_filter = addr_fetch_filter;

endmodule