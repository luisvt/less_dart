//source: less/tree/operation.js 2.4.0

part of tree.less;

class Operation extends Node {
  String op;
  List<Node> operands;
  bool isSpaced;

  final String type = 'Operation';

  ///
  Operation(String op, List this.operands, [bool this.isSpaced = false]) {
    this.op = op.trim();

//2.3.1
//  var Operation = function (op, operands, isSpaced) {
//      this.op = op.trim();
//      this.operands = operands;
//      this.isSpaced = isSpaced;
//  };
  }

  ///
  void accept(Visitor visitor) {
    this.operands = visitor.visit(this.operands);

//2.3.1
//  Operation.prototype.accept = function (visitor) {
//      this.operands = visitor.visit(this.operands);
//  };
  }

  ///
  eval(Contexts context) {
    Node a = this.operands[0].eval(context);
    Node b = this.operands[1].eval(context);

    if (context.isMathOn()) {
      if (a is Dimension && b is Color) a = (a as Dimension).toColor();
      if (b is Dimension && a is Color) b = (b as Dimension).toColor();
      if (a is! OperateNode) {
        throw new LessExceptionError(new LessError(
            type: 'Operation',
            message: 'Operation on an invalid type'
        ));
      }
      return (a as OperateNode).operate(context, this.op, b);
    } else {
      return new Operation(this.op, [a, b], this.isSpaced);
    }

//2.3.1
//  Operation.prototype.eval = function (context) {
//      var a = this.operands[0].eval(context),
//          b = this.operands[1].eval(context);
//
//      if (context.isMathOn()) {
//          if (a instanceof Dimension && b instanceof Color) {
//              a = a.toColor();
//          }
//          if (b instanceof Dimension && a instanceof Color) {
//              b = b.toColor();
//          }
//          if (!a.operate) {
//              throw { type: "Operation",
//                      message: "Operation on an invalid type" };
//          }
//
//          return a.operate(context, this.op, b);
//      } else {
//          return new Operation(this.op, [a, b], this.isSpaced);
//      }
//  };
  }

  ///
  void genCSS(Contexts context, Output output) {
    this.operands[0].genCSS(context, output);
    if (this.isSpaced) output.add(' ');
    output.add(this.op);
    if (this.isSpaced) output.add(' ');
    this.operands[1].genCSS(context, output);

//2.3.1
//  Operation.prototype.genCSS = function (context, output) {
//      this.operands[0].genCSS(context, output);
//      if (this.isSpaced) {
//          output.add(" ");
//      }
//      output.add(this.op);
//      if (this.isSpaced) {
//          output.add(" ");
//      }
//      this.operands[1].genCSS(context, output);
//  };
  }
}