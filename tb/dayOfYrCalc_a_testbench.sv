`timescale 1ns / 1ns

module dayOfYrCalc_a_testbench;

	/******************************************************************/
	/* Local parameters and variables								  */
	/******************************************************************/

	localparam CLK_PERIOD = 1;

	logic 	[5:0] 	dayOfMonth_tester 		= '0;
	logic 	[3:0]	month_tester 			= '0;
	logic 	[8:0] 	dayOfYear_tester 		= '0;

	int 			month_range[12]			= '{31,28,31,30,31,30,31,31,30,31,30,31};
	int 			d 						= 0;
	int 			m 						= 0;

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

		for (m = 0; m <= 11; m++) begin

			#(CLK_PERIOD * 5)
			dayOfMonth_tester <= 1;
			month_tester <= (4'(m))+1;

			for (d = 1; d <= month_range[m]; d++) begin
				#(CLK_PERIOD) dayOfMonth_tester = 6'(d);
			end

		end
	end

	initial begin
		$monitor("Time: ", $stime , "\t\t\tMonth: ", month_tester, "\t\t\tDay of Month: ", dayOfMonth_tester, "\t\t\tCalculated Day of Year: ", dayOfYear_tester);
    end 

endmodule