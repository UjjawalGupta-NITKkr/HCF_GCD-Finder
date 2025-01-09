module CONTROLLER(
    output reg done, ldA, ldB, sel1, sel2, sel_in,
    input start, lt, gt, eq, clk              
);
    reg [2:0] state, next_state;

    
    localparam IDLE = 3'b000,   
               LOAD_A = 3'b001, 
               LOAD_B = 3'b010,
               COMPARE = 3'b011, 
               UPDATE = 3'b100,  
               DONE = 3'b101;   

    
    always @(posedge clk) begin
        state <= next_state;
    end

    
    always @(*) begin
        case (state)
            IDLE: next_state <= (start) ? LOAD_A : IDLE;
            LOAD_A: next_state <= LOAD_B;
            LOAD_B: next_state <= COMPARE;
            COMPARE: next_state <= (eq) ? DONE : UPDATE;
            UPDATE: next_state <= COMPARE;
            DONE: next_state <= DONE;
            default: next_state <= IDLE;
        endcase
    end

    
    always @(*) begin
        
        ldA = 0; ldB = 0; sel1 = 0; sel2 = 0; sel_in = 0; done = 0;

        case (state)
            IDLE: begin
                
                done = 0;
            end
            LOAD_A: begin
                
                ldA = 1;
                sel_in = 1; 
            end
            LOAD_B: begin
            
                ldB = 1;
                sel_in = 1; 
            end
            COMPARE: begin
              
                if (lt) begin
                    sel1 = 1; sel2 = 0; ldB = 1; 
                end else if (gt) begin
                    sel1 = 0; sel2 = 1; ldA = 1; 
                end
            end
            UPDATE: begin
                
                sel_in = 0; 
            end
            DONE: begin
               
                done = 1;
            end
        endcase
    end
endmodule
