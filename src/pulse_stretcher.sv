
module pulse_stretcher #(
    parameter int N = 3
) (
    input logic clk,
    input logic reset_n,
    input logic in_pulse,
    output logic out_pulse
);
//    logic [$clog2(N)-1:0] count, count_next;
//    logic out_pulse_next;
    
//    always_comb begin
//        if (in_pulse)
//            count_next = N; 
//        else if (count != 0)
//            count_next = count - 1;
//        else
//            count_next = '0;
            
//        if(count_next) begin
//            out_pulse_next = 1'b1;
//        end else begin
//            out_pulse_next = 1'b0;
//        end 
//    end
    
//    always @(posedge clk or negedge reset_n) begin
//        if (!reset_n) begin
//            out_pulse <= 1'b0;
//            count <= '0;
//        end else begin
//            out_pulse <= out_pulse_next;
//            count <= count_next;
//        end
//    end
    logic [$clog2(N+1)-1:0] count;
    // next-cycle stretch count
    logic [$clog2(N+1)-1:0] count_next;

    // combinational "would-be" stretch
    always_comb begin
        if (in_pulse)
            count_next = N;
        else if (count != 0)
            count_next = count - 1;
        else
            count_next = 0;
    end

    // out_pulse is high *whenever* we are in a stretch OR the incoming pulse is asserted
    assign out_pulse = (in_pulse) || (count != 0);

    // synchronous update only for count
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            count <= 0;
        else
            count <= count_next;
    end
endmodule