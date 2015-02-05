//source: tree/directive.js 2.3.1 lines 92-122

part of tree.less;

// Used in Directive & Media -
class OutputRulesetMixin {
  ///
  //2.3.1 ok
  void outputRuleset(Contexts context, Output output, List<Node> rules) {
    int ruleCnt = rules.length;

    if (context.tabLevel == null) context.tabLevel = 0;
    context.tabLevel++;

    // Compressed
    if (context.compress) {
      output.add('{');
      for (int i = 0; i < ruleCnt; i++) rules[i].genCSS(context, output);
      output.add('}');
      context.tabLevel--;
      return;
    }

    // Non-compressed
    String tabSetStr  = '\n' +  '  ' * (context.tabLevel - 1);
    String tabRuleStr = tabSetStr + '  ';
    if (ruleCnt == 0) {
      output.add(' {' + tabSetStr + '}');
    } else {
      output.add(' {' + tabRuleStr);
      rules[0].genCSS(context, output);
      for (int i = 1; i < ruleCnt; i++) {
        output.add(tabRuleStr);
        rules[i].genCSS(context, output);
      }
      output.add(tabSetStr + '}');
    }

    context.tabLevel--;

//2.3.1
//  Directive.prototype.outputRuleset = function (context, output, rules) {
//      var ruleCnt = rules.length, i;
//      context.tabLevel = (context.tabLevel | 0) + 1;
//
//      // Compressed
//      if (context.compress) {
//          output.add('{');
//          for (i = 0; i < ruleCnt; i++) {
//              rules[i].genCSS(context, output);
//          }
//          output.add('}');
//          context.tabLevel--;
//          return;
//      }
//
//      // Non-compressed
//      var tabSetStr = '\n' + Array(context.tabLevel).join("  "), tabRuleStr = tabSetStr + "  ";
//      if (!ruleCnt) {
//          output.add(" {" + tabSetStr + '}');
//      } else {
//          output.add(" {" + tabRuleStr);
//          rules[0].genCSS(context, output);
//          for (i = 1; i < ruleCnt; i++) {
//              output.add(tabRuleStr);
//              rules[i].genCSS(context, output);
//          }
//          output.add(tabSetStr + '}');
//      }
//
//      context.tabLevel--;
//  };
  }
}