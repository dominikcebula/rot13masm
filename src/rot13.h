// rot13masm
// Dominik Cebula
// dominikcebula@gmail.com

// This file is part of rot13masm. rot13masm is free software: you can
// redistribute it and/or modify it under the terms of the GNU General Public
// License as published by the Free Software Foundation, version 2.
// 
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
// 
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
// 
// Copyright Dominik Cebula

#pragma once

extern "C" {
	/**
	 * rot13 on memory block
	 * @param buff pointer to the beginning of the memory block
	 * @param len size of the memory block
	 * @return 0 if everything goes ok, >0 on error
	 */
	int rot13(char* buff, int len);

	/**
	 * rot13 on stdin/stdout
	 * @return 0 if everything goes ok, >0 on error
	 */
	int srot13();

	/**
	 * rot13 on files
	 * @param from input file name
	 * @param to output file name
	 * @return 0 if everything goes ok, >0 on error
	 */
	int frot13(char* from, char* to);
}
