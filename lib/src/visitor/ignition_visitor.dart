// Not in original

part of visitor.less;

///
/// Visitor to run after parse input file, before imports
///
class IgnitionVisitor extends VisitorBase {
  Environment environment;
  Visitor _visitor;

  bool isReplacing = true;

  IgnitionVisitor() {
    _visitor = new Visitor(this);
    environment = new Environment();
  }

  ///
  Node run(Node root) => _visitor.visit(root);

  ///
  /// Load options and remove directive
  ///
  Options visitOptions(Options optionsNode, VisitArgs visitArgs) {
    optionsNode.apply(environment);
    return null;
  }

  Function visitFtn(Node node) {
    if (node is Options)    return visitOptions;

    return null;
  }

  /// funcOut visitor.visit distribuitor
  Function visitFtnOut(Node node) => null;
}