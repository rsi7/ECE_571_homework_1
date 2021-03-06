// Module: dayOfYrCalc_a.sv
// Author: Rehan Iqbal
// Date: January 20, 2017
// Company: Portland State University

// Description:
// ------------
// Given the month (1-12) and day of month (1-31) it will return the day number 
// of the year (1-365). It does not consider the year (leap or otherwise).
//
///////////////////////////////////////////////////////////////////////////////

module dayOfYrCalc_a (

	/*************************************************************************/
	/* Top-level port declarations											 */
	/*************************************************************************/

	input	logic	[5:0]	dayOfMonth,		// range is 1..31
	input	logic	[3:0]	month,			// range is 1..12

	output	logic	[8:0]	dayOfYear		// range is 1..366

	);

	/*************************************************************************/
	/* Local parameters and variables										 */
	/*************************************************************************/

	reg 			[8:0] 	temp_sum;		// stores dayOfMonth calculations

	/*************************************************************************/
	/* dayOfYear generator block											 */
	/*************************************************************************/

	always@(dayOfMonth or month) begin

		temp_sum = 0;

			case(month)
				4'd1 : temp_sum = 0;		// Jan (+0)
				4'd2 : temp_sum = 31;		// Feb (+31)
				4'd3 : temp_sum = 59;		// March (+28)
				4'd4 : temp_sum = 90;		// April (+31)
				4'd5 : temp_sum = 120;		// May (+30)
				4'd6 : temp_sum = 151;		// June (+31)
				4'd7 : temp_sum = 181;		// July (+30)
				4'd8 : temp_sum = 212;		// August (+31)
				4'd9 : temp_sum = 243;		// September (+31)
				4'd10 : temp_sum = 273;		// October (+30)
				4'd11 : temp_sum = 304;		// November (+31)
				4'd12 : temp_sum = 334;		// December (+30)
				default: temp_sum = 0;		// handle months 13-16
			endcase

		// increment the dayOfMonth calculation
		temp_sum += dayOfMonth;

		// store results into output
		dayOfYear = temp_sum;

	end

endmodule