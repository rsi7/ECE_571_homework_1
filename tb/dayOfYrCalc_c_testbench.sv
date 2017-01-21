// Module: dayOfYrCalc_c_testbench.sv
// Author: Rehan Iqbal
// Date: January 20, 2017
// Company: Portland State University
//
// Description:
// ------------
// Instantiates the device-under-test (dayOfYrCalc) and runs through each
// year between 0 and 2047. Most day & month combinations are randomly
// generated, but special cases (leap years, 100-year & 400-year events)
// have more directed testing.
//
///////////////////////////////////////////////////////////////////////////////

module dayOfYrCalc_c_testbench;

	timeunit 1ns;

	/*************************************************************************/
	/* Top-level port declarations											 */
	/*************************************************************************/

	localparam CLK_PERIOD = 1;

	logic 	[5:0] 	dayOfMonth_tester 		= '0;		// dayOfMonth to send to DUT
	logic 	[3:0]	month_tester 			= '0;		// month to send to DUT
	logic 	[8:0] 	dayOfYear_tester 		= '0;		// dayOfYear to send to DUT
	logic 	[10:0] 	year_tester 			= '0;		// year to send to DUT

	int unsigned 	month_range[12]			= '{31,28,31,30,31,30,31,31,30,31,30,31};
	int unsigned 	y 						= 0;

	int 			fhandle;				// integer to hold file location

	int 			month_seed;				// integer value to hold random month
	int 			day_seed;				// integer value to hold random day

	wire 			divby4;					// flag indicating divisibility by 4
	wire 			divby100; 				// flag indicating divisibility by 100
	wire 			divby400; 				// flag indicating divisibility by 400
	wire 			leap_tester;  			// flag indicating leap year status

	/*************************************************************************/
	/* Global Assignments													 */
	/*************************************************************************/	

	assign divby4 = (y[1:0] == 2'b00) ? 1'b1 : 1'b0; 				// is year divisible by 4?
	assign divby100 = ((y % 100) == 0) ? 1'b1 : 1'b0; 				// is year divisible by 100?
	assign divby400 = ((y % 400) == 0) ? 1'b1 : 1'b0;				// is year divisible by 400?

	assign leap_tester = (((divby4) && (divby400 || !divby100))); 	// determine leap year status

	/*************************************************************************/
	/* Instantiating the DUT 												 */
	/*************************************************************************/

	dayOfYrCalc_c DUT (

		.dayOfMonth 		(dayOfMonth_tester),		// I [5:0] 		range is 1..31
		.month 				(month_tester),				// I [3:0] 		range is 1..12
		.year 				(year_tester), 				// I [10:0] 	range is 0000..2047
		.dayOfYear 			(dayOfYear_tester)			// O [8:0] 		range is 1..366

		);

	/*************************************************************************/
	/* Running the testbench simluation										 */
	/*************************************************************************/

	// format time units for printing later
	// also setup the output file location

	initial begin
		$timeformat(-9, 0, "ns", 8);
		fhandle = $fopen("C:/Users/riqbal/Desktop/dayOfYrCalc_c_results.txt");
	end

	// main simulation loop

	initial begin

		for (y = 0; y < 2048; y++) begin

			#30ns
			year_tester = 11'(y);
			month_tester = 4'd1;
			dayOfMonth_tester = 6'd1;

			// check for leap year...
			// if so, need to generate between 1 - 29 for Feb
			
			if (leap_tester) begin
				month_range[1] = 29;
			end
			else begin
				month_range[1] = 28;
			end

			// bound random generation of month & day
			month_seed = $urandom_range(32'd11, 32'd0);
			day_seed = $urandom_range(month_range[month_seed], 32'd1);

			// send to DUT inputs
			month_tester = (4'(month_seed)) + 1;
			dayOfMonth_tester = 6'(day_seed);

			// print results to file
			$fmonitor(fhandle, "Time:\t%t\t\tYear: %d\t\tMonth: %d\t\tDay of Month: %d\t\tDay of Year: %d\t", $time, year_tester, month_tester, dayOfMonth_tester, dayOfYear_tester);

		end

		// wrap up file writing & finish simulation
		$fwrite(fhandle, "\n\nEND OF FILE");
		$fclose(fhandle);
		$stop;
	end

endmodule