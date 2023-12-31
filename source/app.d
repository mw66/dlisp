/*
  dle.d
  dLISP

  Author: Fredrik Olsson <peylow@treyst.se>
  Copyright (c) 2005 Treyst AB, <http://www.treyst.se>
  All rights reserved.

    This file is part of dLISP.
    dLISP is free software; you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation; either version 2.1 of the License, or
    (at your option) any later version.

    dLISP is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with dLISP; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/

module dle;

import undead.cstream;
import dlisp.concell;
import dlisp.dlisp;
import dlisp.predefs.all;

int main(char[][] args) {
  DLisp dlisp = new DLisp(addAllToEnvironment(new Environment()));
  
  Cell* top_cell = dlisp.parseEvalPrint(`(LOAD "system.lisp" T)`.dup, true);
//  top_cell = dlisp.parseEvalPrint(`(read-eval-print-loop)`, true);


  int inputcount = 0;
  string inputprompt = "> ";
  string input;
  string resultprompt = "=> ";
  dlisp.environment.bindValue("*input-count*", &inputcount);
  dlisp.environment.bindValue("*input-prompt*", &inputprompt);
  dlisp.environment.bindValue("*input-string*", &input);
  dlisp.environment.bindValue("*result-prompt*", &inputprompt);
  
  dout.writeLine(dlisp.versionString());
  
  while(1) {
    dout.writeString(inputprompt);
    input = cast(string)din.readLine();
    inputcount++;
    if (input != "") {
      if (input == "quit") 
        break;
      try {
        dlisp.tracelevel = 0;
        Cell* cell = dlisp.parse(input);
        cell = dlisp.eval(cell);
        dout.writeLine(resultprompt ~ cellToString(cell));
      } catch (DLispState e) {
        dout.writeLine("RTE: " ~ e.toString());
      }
    }
  }
  
  return 0;
}
