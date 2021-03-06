//source: less/tree/directive.js 2.4.0+1

part of tree.less;

class Directive extends DirectiveBase {
  String name;
  Node value;
  List<Ruleset> rules;
  int index;
  FileInfo currentFileInfo;
  DebugInfo debugInfo;
  bool isReferenced = false;

  final String type = 'Directive';

  Directive(String this.name, Node this.value,  rules, int this.index,
      FileInfo this.currentFileInfo, DebugInfo this.debugInfo, [bool this.isReferenced = false]):super() {

    if (rules != null) {
      if (rules is List) {
        this.rules = rules;
      } else {
        this.rules = [rules];
        this.rules[0].selectors = (new Selector([], null, null, this.index, currentFileInfo)).createEmptySelectors();
      }
      this.rules.forEach((rule) {rule.allowImports = true;});
    }

//2.4.0+1
//  var Directive = function (name, value, rules, index, currentFileInfo, debugInfo, isReferenced) {
//      var i;
//
//      this.name  = name;
//      this.value = value;
//      if (rules) {
//          if (Array.isArray(rules)) {
//              this.rules = rules;
//          } else {
//              this.rules = [rules];
//              this.rules[0].selectors = (new Selector([], null, null, this.index, currentFileInfo)).createEmptySelectors();
//          }
//          for (i = 0; i < this.rules.length; i++) {
//              this.rules[i].allowImports = true;
//          }
//      }
//      this.index = index;
//      this.currentFileInfo = currentFileInfo;
//      this.debugInfo = debugInfo;
//      this.isReferenced = isReferenced;
//  };
  }
}

/// Base class for Directive and Media
class DirectiveBase extends Node with OutputRulesetMixin, VariableMixin implements GetIsReferencedNode, MarkReferencedNode {
  String name;
  Node value;
  List<Ruleset> rules;
  int index;
  FileInfo currentFileInfo;
  DebugInfo debugInfo;
  bool isReferenced = false;

  final String type = 'DirectiveBase';

  DirectiveBase();

  ///


  ///
  void accept(Visitor visitor) {
//    Node value = this.value;
//    Ruleset rules = this.rules;

    if (this.rules != null) this.rules = visitor.visitArray(this.rules);
    if (this.value != null) this.value = visitor.visit(this.value);

//2.4.0+
//  Directive.prototype.accept = function (visitor) {
//      var value = this.value, rules = this.rules;
//      if (rules) {
//          this.rules = visitor.visitArray(rules);
//      }
//      if (value) {
//          this.value = visitor.visit(value);
//      }
//  };
  }

  ///
  bool isRulesetLike(bool root)  => (this.rules != null) || !this.isCharset();

//2.3.1
//  Directive.prototype.isRulesetLike = function() {
//      return this.rules || !this.isCharset();
//  };

  ///
  bool isCharset() => '@charset' == this.name;

  ///
  void genCSS(Contexts context, Output output) {
    Node value = this.value;
    var rules = this.rules;
    output.add(this.name, this.currentFileInfo, this.index);
    if (value != null) {
      output.add(' ');
      value.genCSS(context, output);
    }
    if (rules != null) {
      outputRuleset(context, output, rules);
    } else {
      output.add(';');
    }

//2.4.0+1
//  Directive.prototype.genCSS = function (context, output) {
//      var value = this.value, rules = this.rules;
//      output.add(this.name, this.currentFileInfo, this.index);
//      if (value) {
//          output.add(' ');
//          value.genCSS(context, output);
//      }
//      if (rules) {
//          this.outputRuleset(context, output, rules);
//      } else {
//          output.add(';');
//      }
//  };
  }

  ///
  Directive eval(Contexts context) {
    Node value = this.value;
    List<Ruleset> rules = this.rules;

    // media stored inside other directive should not bubble over it
    // backpup media bubbling information
    List<Media> mediaPathBackup = context.mediaPath;
    List<Media> mediaBlocksBackup = context.mediaBlocks;
    // deleted media bubbling information
    context.mediaPath = [];
    context.mediaBlocks = [];

    if (value != null) value = value.eval(context);
    if (rules != null) {
      // assuming that there is only one rule at this point - that is how parser constructs the rule
      rules = [rules[0].eval(context)];
      rules[0].root = true;
    }
    // restore media bubbling information
    context.mediaPath = mediaPathBackup;
    context.mediaBlocks = mediaBlocksBackup;

    return new Directive(this.name, value, rules,
        this.index, this.currentFileInfo, this.debugInfo, this.isReferenced);

//2.4.0+1
//  Directive.prototype.eval = function (context) {
//      var mediaPathBackup, mediaBlocksBackup, value = this.value, rules = this.rules;
//
//      //media stored inside other directive should not bubble over it
//      //backpup media bubbling information
//      mediaPathBackup = context.mediaPath;
//      mediaBlocksBackup = context.mediaBlocks;
//      //deleted media bubbling information
//      context.mediaPath = [];
//      context.mediaBlocks = [];
//
//      if (value) {
//          value = value.eval(context);
//      }
//      if (rules) {
//          // assuming that there is only one rule at this point - that is how parser constructs the rule
//          rules = [rules[0].eval(context)];
//          rules[0].root = true;
//      }
//      //restore media bubbling information
//      context.mediaPath = mediaPathBackup;
//      context.mediaBlocks = mediaBlocksBackup;
//
//      return new Directive(this.name, value, rules,
//          this.index, this.currentFileInfo, this.debugInfo, this.isReferenced);
//  };
  }

// in VariableMixin - override

  ///
  //untested
  Node variable(String name) {
    //return this.variables()[name];
    if (this.rules != null && this.rules.isNotEmpty) {
      return this.rules[0].value(name);
    }
    return null;

//2.4.0+
//  Directive.prototype.variable = function (name) {
//      if (this.rules) {
//          // assuming that there is only one rule at this point - that is how parser constructs the rule
//          return Ruleset.prototype.variable.call(this.rules[0], name);
//      }
//  };
  }

  ///
  //untested
  List<MixinFound> find (Selector selector, [self, Function filter]) {
    if (this.rules != null && this.rules.isNotEmpty) {
      // assuming that there is only one rule at this point - that is how parser constructs the rule
      return this.rules[0].find(selector, self, filter);
    }
    return null;
//2.4.0+
//  Directive.prototype.find = function () {
//      if (this.rules) {
//          // assuming that there is only one rule at this point - that is how parser constructs the rule
//          return Ruleset.prototype.find.apply(this.rules[0], arguments);
//      }
//  };
  }

  ///
  //untested
  List<Node> rulesets(){
    if (this.rules != null && this.rules.isNotEmpty) {
      // assuming that there is only one rule at this point - that is how parser constructs the rule
      return this.rules[0].rulesets();
    }
    return null;

//2.4.0+
//  Directive.prototype.rulesets = function () {
//      if (this.rules) {
//          // assuming that there is only one rule at this point - that is how parser constructs the rule
//          return Ruleset.prototype.rulesets.apply(this.rules[0]);
//      }
//  };
  }

  //--- MarkReferencedNode

  ///
  void markReferenced() {
    List<Node> rules;
    this.isReferenced = true;

    if (this.rules != null) {
      rules = this.rules;
      for (int i = 0; i < rules.length; i++) {
        if (rules[i] is MarkReferencedNode) (rules[i] as MarkReferencedNode).markReferenced();
      }
    }

// 2.4.0+
//  Directive.prototype.markReferenced = function () {
//      var i, rules;
//      this.isReferenced = true;
//      if (this.rules) {
//          rules = this.rules;
//          for (i = 0; i < rules.length; i++) {
//              if (rules[i].markReferenced) {
//                  rules[i].markReferenced();
//              }
//          }
//      }
//  };
  }

  ///
  bool getIsReferenced() => (this.currentFileInfo == null)
                          || !this.currentFileInfo.reference
                          || this.isReferenced;

//2.3.1
//  Directive.prototype.getIsReferenced = function () {
//      return !this.currentFileInfo || !this.currentFileInfo.reference || this.isReferenced;
//  };
}