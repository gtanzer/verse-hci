using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using Microsoft.ProgramSynthesis.Utils;

/*
 * PROSE documentation on Semantics:
 *  https://microsoft.github.io/prose/documentation/prose/tutorial/#semantics
 * and Black-Box Operators:
 *  https://microsoft.github.io/prose/documentation/prose/usage/#black-box-operators
 */

namespace ProseSummative {
    public static class Semantics {

        
        // An operator that converts a positive or negative number into an
        // an index into a string. For example, the number -2 on string "walrus"
        // will be converted to 4, because "walrus" is 6 characters long.
        public static int? AbsPos(string v, int k) {
            return k > 0 ? k - 1 : v.Length + k + 1;
        }
        

        static string Substring(string x, int? pos)
    {
        if (pos == null)
            return null;
        int start = pos.Value;
        int end = pos.Value;
        if (start < 0 || start >= x.Length ||
            end < 0 || end >= x.Length || end < start)
            return null;
        return x.Substring(start, end - start);
    }


    }
}
