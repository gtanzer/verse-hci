﻿using System;
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

        public static string Substring(string v, int start, int end) => v.Substring(start, end - start);

        public static int? AbsPos(string v, int k) {
            return k > 0 ? k - 1 : v.Length + k + 1;
        }

    }
}
