/*A. (20 pts) Write a SystemVerilog module that calculates the day of the year (ex: 01-Feb would be the 32nd day of the year). 
Ignore leap years for now. The signature for the module is:

module dayOfYrCalc_a (

input 	logic [5:0] 	dayOfMonth, 	// range is 1..31
input 	logic [3:0] 	month, 			// range is 1..12
output 	logic [8:0] 	dayOfYear 		// range is 1..366
);

*/

/*

function g(y,m,d)
	m = (m + 9) % 12
	y = y - m/10
	return 365*y + y/4 - y/100 + y/400 + (m*306 + 5)/10 + ( d - 1 )

*/

module dayOfYrCalc_a (

	/******************************************************************/
	/* Top-level port declarations					                  */
	/******************************************************************/

	input	logic	[5:0]	dayOfMonth,		// range is 1..31
	input	logic	[3:0]	month,			// range is 1..12

	output	logic	[8:0]	dayOfYear,		// range is 1..366

	);

	/******************************************************************/
	/* Local parameters and variables				                  */
	/******************************************************************/

	wire			[3:0]	month_t;

	/******************************************************************/
	/* Global Assignments							                  */
	/******************************************************************/	

	assign 	month_t = (month + 9) % 12;

	/******************************************************************/
	/* dayOfYear generator block 			                  		  */
	/******************************************************************/

	always_ff@(posedge clk) begin
		dayOfYear <= (((month_t * 306) + 5)/10) + (dayOfMonth-1);
	end

endmodule