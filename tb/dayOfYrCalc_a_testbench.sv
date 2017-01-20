`timescale 1ns / 1ns

module dayOfYrCalc_a_testbench;

	/******************************************************************/
	/* Local parameters and variables								  */
	/******************************************************************/

	localparam CLK_PERIOD = 1;

	logic 	[5:0] 	dayOfMonth_tester 	= '0;
	logic 	[3:0]	month_tester 		= '0;
	logic 	[8:0] 	dayOfYear_tester 	= '0;

	/******************************************************************/
	/* Instantiating the DUT										  */
	/******************************************************************/

	dayOfYrCalc_a DUT (

		.dayOfMonth 		(dayOfMonth_tester),		// I [5:0] 		range is 1..31
		.month 				(month_tester),				// I [3:0] 		range is 1..12
		.dayOfYear 			(dayOfYear_tester)			// O [8:0] 		range is 1..366

		);

	/******************************************************************/
	/* Running the testbench simluation                               */
	/******************************************************************/

	always begin
		#(CLK_PERIOD * 30)
		for (int m = 1; m <= 12; m++) begin
			#(CLK_PERIOD * 5) month_tester <= 12'(m);
			for (int d = 1; d <= 30; d++) begin
				#(CLK_PERIOD) dayOfMonth_tester <= 6'(d);
			end
		end
	end

	initial begin
		$monitor($stime,, month_tester ,, dayOfMonth_tester ,, dayOfYear_tester);
    end 

endmodule