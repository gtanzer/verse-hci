﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using Microsoft.ProgramSynthesis;
using System.Threading.Tasks;
using Microsoft.ProgramSynthesis.Rules;
using Microsoft.ProgramSynthesis.Specifications;
using Microsoft.ProgramSynthesis.Learning;

/*
 * PROSE documentation on Witness Functions:
 *  https://microsoft.github.io/prose/documentation/prose/tutorial/#witness-functions
 *  https://microsoft.github.io/prose/documentation/prose/backpropagation/
 */

namespace ProseSummative {
    public class WitnessFunctions : DomainLearningLogic {
        public WitnessFunctions(Grammar grammar) : base(grammar) { }

        [WitnessFunction(nameof(Semantics.Substring), 1)]
        public DisjunctiveExamplesSpec WitnessStartPosition(GrammarRule rule, ExampleSpec spec) {
            var result = new Dictionary<State, IEnumerable<object>>();

            foreach (var example in spec.Examples) {
                State inputState = example.Key;
                var input = inputState[rule.Body[0]] as string;
                var output = example.Value as string;
                var occurrences = new List<int>();

                for (int i = input.IndexOf(output); i >= 0; i = input.IndexOf(output, i + 1)) {
                    occurrences.Add(i);
                }

                if (occurrences.Count == 0) return null;
                result[inputState] = occurrences.Cast<object>();
            }
            return new DisjunctiveExamplesSpec(result);

        }

        [WitnessFunction(nameof(Semantics.Substring), 2, DependsOnParameters = new []{1})]
        public ExampleSpec WitnessEndPosition(GrammarRule rule, ExampleSpec spec, ExampleSpec startSpec) {
            var result = new Dictionary<State, object>();
            foreach (var example in spec.Examples) {
                State inputState = example.Key;
                var output = example.Value as string;
                var start = (int) startSpec.Examples[inputState];
                result[inputState] = start + output.Length;
            }
            return new ExampleSpec(result);
        }

        [WitnessFunction(nameof(Semantics.AbsPos), 1)]
        public DisjunctiveExamplesSpec WitnessK(GrammarRule rule, DisjunctiveExamplesSpec spec) {

            var kExamples = new Dictionary<State, IEnumerable<object>>();
            foreach (var example in spec.DisjunctiveExamples) {
                State inputState = example.Key;
                var v = inputState[rule.Body[0]] as string;

                var positions = new List<int>();
                foreach (int pos in example.Value) {
                    positions.Add((int)pos + 1);
                    positions.Add((int)pos - v.Length - 1);
                }
                if (positions.Count == 0) return null;
                kExamples[inputState] = positions.Cast<object>();
            }
            return DisjunctiveExamplesSpec.From(kExamples);
        }
    }
}