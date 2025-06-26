module tb_parking_system;
  reg clk;
  reg reset;
  reg sensor_entrance;
  reg sensor_exit;
  reg [1:0] password_1;
  reg [1:0] password_2;
  wire GREEN_LED;
  wire RED_LED;
  wire [6:0] HEX_1;
  wire [6:0] HEX_2;
  parking_system d0 (
  .clk(clk), 
  .reset(reset), 
  .sensor_entrance(sensor_entrance), 
  .sensor_exit(sensor_exit), 
  .password_1(password_1), 
  .password_2(password_2), 
  .GREEN_LED(GREEN_LED), 
  .RED_LED(RED_LED), 
  .HEX_1(HEX_1), 
 .HEX_2(HEX_2)
 );
 initial begin
    
    $dumpfile("dump.vcd");
    $dumpvars(1,tb_parking_system);

 clk = 0;
 forever #5 clk = ~clk;
 end
 initial begin
 reset= 1;
 sensor_entrance = 0;
 sensor_exit = 0;
 password_1 = 0;
 password_2 = 0;
 
 #20;
        reset = 0;

        // Valid entrance and correct password
        #10;
        sensor_entrance = 1;
        #20;
        sensor_entrance = 0;
        password_1 = 2'b01;
        password_2 = 2'b10;
        #40; // Wait for counter_wait to exceed 3 cycles

        // Exit the parking
        sensor_exit = 1;
        #20;
        sensor_exit = 0;

        //  Wrong password entered
        #20;
        sensor_entrance = 1;
        #20;
        sensor_entrance = 0;
        password_1 = 2'b11;
        password_2 = 2'b00;
        #40;

        // Correct it after wrong attempt
        password_1 = 2'b01;
        password_2 = 2'b10;
        #20;
        sensor_exit = 1;
        #20;
        sensor_exit = 0;

        //  Enter and exit simultaneously (goes to STOP)
        #20;
        sensor_entrance = 1;
        sensor_exit = 1;
        password_1 = 2'b01;
        password_2 = 2'b10;
        #40;
        sensor_entrance = 0;
        sensor_exit = 0;

        // Try correct password in STOP
        password_1 = 2'b01;
        password_2 = 2'b10;
        #40;

        $finish;
 end
      
endmodule
