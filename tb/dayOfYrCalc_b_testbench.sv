`timescale 1ns / 1ns

module dayOfYrCalc_b_testbench;

	/******************************************************************/
	/* Local parameters and variables								  */
	/******************************************************************/

	localparam CLK_PERIOD = 1;

	logic 	[5:0] 	dayOfMonth_tester 		= '0;
	logic 	[3:0]	month_tester 			= '0;
	logic 	[8:0] 	dayOfYear_tester 		= '0;
	logic 	[10:0] 	year_tester 			= '0;

	int 			month_range[12]			= '{31,28,31,30,31,30,31,31,30,31,30,31};
	int 			d 						= 0;
	int 			m 						= 0;
	int 			y 						= 0;

	wire 			leap_tester;

	/******************************************************************/
	/* Global Assignments											  */
	/******************************************************************/	

	assign leap_tester = (y[1:0] == 2'b00) ? 1'b1 : 1'b0;

	/******************************************************************/
	/* Instantiating the DUT										  */
	/******************************************************************/

	dayOfYrCalc_b DUT (

		.dayOfMonth 		(dayOfMonth_tester),		// I [5:0] 		range is 1..31
		.month 				(month_tester),				// I [3:0] 		range is 1..12
		.year 				(year_tester), 				// I [10:0] 	range is 0000..2047
		.dayOfYear 			(dayOfYear_tester)			// O [8:0] 		range is 1..366

		);

	/******************************************************************/
	/* Running the testbench simluation                               */
	/******************************************************************/

	always begin

		for (y = 0; y < 2048; y++) begin

			#(CLK_PERIOD * 30)
			year_tester <= 11'(y);
			month_tester <= 1;
			dayOfMonth_tester <= 1;

			if (leap_tester) begin
				month_range[1] = 29;
			end
			else begin
				month_range[1] = 28;
			end

			for (m = 0; m <= 11; m++) begin

				#(CLK_PERIOD * 5)
				month_tester <= (4'(m)) + 1;
				dayOfMonth_tester <= 1;

				for (d = 1; d <= month_range[m]; d++) begin
					#(CLK_PERIOD) dayOfMonth_tester = 6'(d);
				end

			end
		end
	end

	initial begin
		$monitor("Time: ", $stime , "\t\t\tYear: ", year_tester, "\t\t\tMonth: ", month_tester, "\t\t\tDay of Month: ", dayOfMonth_tester, "\t\t\tCalculated Day of Year: ", dayOfYear_tester);
    end 

endmodule