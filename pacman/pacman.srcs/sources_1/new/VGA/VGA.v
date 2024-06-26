//lawxiuyong, Bing

module vga (
   input clk100_i,
   output vga_hs_o,
   output vga_vs_o,
   output [11:0] vga_rgb
);
  
   //internal signals
   wire           vga_clk;
   reg [10:0]     vga_pix_x = 0;
   reg [9:0]      vga_pix_y = 0;
   reg            vga_hs;
   reg            vga_vs;
   
   //VGA timing parameters
   localparam     VGA_X_SIZE   = 1650;
   localparam     VGA_Y_SIZE   = 750;
   localparam     VGA_HS_BEGIN = 1390;
   localparam     VGA_HS_SIZE  =  40;
   localparam     VGA_VS_BEGIN = 725;
   localparam     VGA_VS_SIZE  =   5;
   localparam     VGA_X_PIXELS = 1280;
   localparam     VGA_Y_PIXELS = 720;
    
   //clock wizard
   clk_wiz_0 instance_name
   (
    // Clock out ports
    .clk_out1(vga_clk),     // output clk_out1
    // Clock in ports
    .clk_in1(clk100_i)      // input clk_in1
   );

    
   //horizontal pixel counter
   always @ (posedge vga_clk)
   begin
      if (vga_pix_x == VGA_X_SIZE-1) begin
         vga_pix_x <= 0;
      end else begin
         vga_pix_x <= vga_pix_x + 1;
      end
   end
   
   //vertical pixel counter
   always @ (posedge vga_clk)
   begin
      if (vga_pix_x == VGA_X_SIZE-1) begin
         if (vga_pix_y == VGA_Y_SIZE-1) begin
            vga_pix_y <= 0;
         end else begin
            vga_pix_y <= vga_pix_y + 1;
         end
      end
   end
   
   always @ (posedge vga_clk)
   begin
      //horizontal sync
      vga_hs <= 1'b1;
      if (vga_pix_x >= VGA_HS_BEGIN & vga_pix_x < VGA_HS_BEGIN + VGA_HS_SIZE) begin
        vga_hs <= 1'b0;
      end
      
      //vertical sync
      vga_vs <= 1'b1;
      if (vga_pix_y >= VGA_VS_BEGIN & vga_pix_y < VGA_VS_BEGIN + VGA_VS_SIZE) begin
        vga_vs <= 1'b0;
      end
      
      //color signal
      //vga_col <= 0;
      //if (vga_pix_x < VGA_X_PIXELS && vga_pix_y < VGA_Y_PIXELS) begin
      //vga_col <= vga_pix_x[8:1] ^ vga_pix_y[8:1];
      //end
   end
   
   assign vga_hs_o = vga_hs;
   assign vga_vs_o = vga_vs;

   //display array
   wire [11:0] rgb;
   wire [10:0] pix_x;
   wire [9:0] pix_y;
   assign pix_x = vga_pix_x;
   assign pix_y = vga_pix_y;
   output_display_array (
      .clk_vga(vga_clk),
      .row(pix_y),
      .col(pix_x),
      .rgb_720p(rgb)
   );

   //color signal
   assign vga_rgb = (vga_pix_x >= 11'd0 && vga_pix_x < 11'd1280 && vga_pix_y >= 10'd0 && vga_pix_y < 10'd720) ? rgb : 12'h000;

endmodule
