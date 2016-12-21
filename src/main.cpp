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

#include <cstdio>
#include <cstring>
#include "rot13.h"

using namespace std;

int main(int argc, char** argv)
{
	if (argc==2 && argv[1][0]=='-')
		srot13();
	else if (argc==2) {
		int len=strlen(argv[1])+5;
		char* to=new char[len];
		sprintf_s(to, len, "%s.out", argv[1]);
		frot13(argv[1], to);
		delete[] to;
	}
	else if (argc==3)
		frot13(argv[1], argv[2]);
	else
		fprintf(stdout, 
				"Usage:\r\n%s -\r\n%s <file_from>\r\n%s <file_from> <file_to>\r\n", 
				argv[0], argv[0], argv[0]);
	
	return 0;
}
