`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2025 07:03:05 PM
// Design Name: 
// Module Name: top_tb
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

//include "rotating_arbiter_assertions.vh"
`include "rotating_arbiter_assertions.vh"

module top_tb();

//    packed_array_3d packed_array_3d_test();
//    my_packed_array_3d my_packed_array_3d_test();
//    packed_unpacked_mix packed_unpacked_mix_test();
//    rom_16_by_8_tb rom_16_by_8_test();
//    priority_arbiter_tb priority_arbiter_test();
//    pulse_stretcher_tb pulse_stretcher_test();
    rotating_arbiter_tb rotating_arbiter_test();
endmodule


module copy_and_compare_array ();
    int arr1[5];
    int arr2[5];
    int status;
    initial begin
        foreach(arr1[i]) arr1[i] = $random;
        arr2 = arr1;
        status = (arr1 == arr2);
        $display("arr1 = %0p arr2 = %0p status = %0d" , arr1, arr2, status);
    end
endmodule

module packed_array_3d ();
    bit [2:0][3:0][7:0] m_data;
	initial begin
		m_data[0] = 32'hface_cafe;
		m_data[1] = 32'h1234_5678;
		m_data[2] = 32'hcade_fade;
		
		$display ("m_data = 0x%0h", m_data);
        foreach (m_data[i]) begin
          $display ("m_data[%0d] = 0x%0h", i, m_data[i]);
          foreach (m_data[i][j]) begin
            $display ("m_data[%0d][%0d] = 0x%0h", i, j, m_data[i][j]);
          end
        end
	end
endmodule


module my_packed_array_3d();
	bit [2:0][3:0][7:0] m_data;
	initial begin
		m_data[0] = 32'hface_cafe;
		m_data[1] = 32'h1234_5678;
        m_data[2] = 32'hcade_fade;
        $display ("m_data = %0h", m_data);
        $display("size1 = %0d | size2 = %0d | size3 = %0d", $size(m_data), $size(m_data[0]), $size(m_data[0][0]));
        for (int i=0; i<$size(m_data); i++) begin
            for (int j=0; j<$size(m_data[i]); j++) begin
              $display ("m_data[%0d][%0d] = %0h", i, j, m_data[i][j]);
            end
        end 
    end
endmodule


module packed_unpacked_mix();
  bit [3:0][7:0] 	stack [2][4]; 		// 2 rows, 4 cols

	initial begin
		// Assign random values to each slot of the stack
		foreach (stack[i])
            foreach (stack[i][j]) begin
                foreach (stack [i][j][k]) begin
                    stack[i][j][k] = $random;
                    $display ("stack[%0d][%0d][%0d] = 0x%0h", i, j, k,  stack[i][j][k]);
                end
            end 

		// Print contents of the stack
		$display ("stack = %p", stack);

		// Print content of a given index
        $display("stack[0][0][2] = 0x%0h", stack[0][0][2]);
	end
endmodule







