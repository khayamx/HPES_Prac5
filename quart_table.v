`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2017-2020, Gisselquist Technology, LLC
//
// This file is part of the CORDIC related project set.
//
// The CORDIC related project set is free software (firmware): you can
// redistribute it and/or modify it under the terms of the GNU Lesser General
// Public License as published by the Free Software Foundation, either version
// 3 of the License, or (at your option) any later version.
//
// The CORDIC related project set is distributed in the hope that it will be
// useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTIBILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser
// General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  (It's in the $(ROOT)/doc directory.  Run make
// with no target there if the PDF file isn't present.)  If not, see
// License:	LGPL, v3, as defined and found on www.gnu.org,
//		http://www.gnu.org/licenses/lgpl.html
//
////////////////////////////////////////////////////////////////////////////////
//
//
module	quarterwav(i_clk, i_reset, i_ce, i_phase, i_aux, o_val, o_aux);
	//
	parameter	PW =64, // Number of bits in the input phase
			OW =11; // Number of output bits
	//
	input		   i_clk;
	input          i_reset;
	input          i_ce;
	input	wire	[(PW-1):0]	i_phase;
	output	reg	[(OW-1):0]	o_val;
	//
	input	wire			i_aux;
	output	reg			o_aux;

	reg	[11:0]		quartertable	[0:64];
 
	initial	$readmemh("C:\Users\HP USER\Documents\4th YEAR\HPES\Pracs\git\EEE4120F-Pracs-master\Prac5\LUT_sinefull.coe", quartertable);
    //set val
     
    //-------------------------------
	reg	[1:0]	negate;
	reg	[(PW-3):0]	index;
	reg	[(OW-1):0]	tblvalue;

	initial	negate  = 2'b00;
	initial	index   = 0;
	initial	tblvalue= 0;
	initial	o_val   = 0;
	always @(posedge i_clk)
	if (i_reset)
	begin
		negate  <= 2'b00;
		index   <= 0;
		tblvalue<= 0;
		o_val   <= 0;
	end else if (i_ce)
	begin
		// Clock #1
		negate[0] <= i_phase[(PW-1)];
		if (i_phase[(PW-2)])
			index <= ~i_phase[(PW-3):0];
		else
			index <=  i_phase[(PW-3):0];
		// Clock #2
		tblvalue <= quartertable[index];
		negate[1] <= negate[0];
		// Output Clock
		if (negate[1])
			o_val <= -tblvalue;
		else
			o_val <=  tblvalue;
	end

	reg [1:0]	aux;

	initial	{ o_aux, aux } = 0;
	always @(posedge i_clk)
	if (i_reset)
		{ o_aux, aux } <= 0;
	else if (i_ce)
		{ o_aux, aux } <= { aux, i_aux };
endmodule
