#include<iostream>
#include<vector>
#include <llvm/IR/Value.h>
#include <memory>
#include <string>
using std::shared_ptr;
using std::cout;
using std::cin;
using std::make_shared;
using std::string;
using std::endl;
class CodeGenContext;
class NStatement;
class NExpression;

typedef std::vector<shared_ptr<NStatement>> StatementList;
typedef std::vector<shared_ptr<NExpression>> ExpressionList;
typedef std::vector<shared_ptr<NVariableDeclaration>> VariableList;
class ASTnode
{
public:
    ASTnode(){}
    virtual ~ASTnode(){}
    //virtual void printtype() =0;
    //virtual string gettypename() const=0;
    //virtual llvm::value *codeGen() = 0;
};

class NExpression : public ASTnode {
    //virtual llvm::value* codeGen(CodeGenContext& context);
};

class NStatement : public ASTnode {
    //virtual llvm::value* codeGen(CodeGenContext& context);
};

class NInteger : public NExpression {
public:
    long long value;
    NInteger(long long value) : value(value) { }
    //virtual llvm::value* codeGen(CodeGenContext& context);
};

class NFloat : public NExpression {
public:
    float value;
    NFloat(double value) : value(value) { }
    //virtual llvm::value* codeGen(CodeGenContext& context);
};
class NString : public NExpression {
public:
    string value;
    NString(string &value) : value(value){}
    //virtual llvm::value* codeGen(CodeGenContext& context);
};
class NDouble : public NExpression {
public:
    double value;
    NDouble(double value) : value(value){}
    //virtual llvm::value* codeGen(CodeGenContext& context);
};
class NBool : public NExpression {
public:
    bool value;
    NBool(string &value) : value(value == "true"){}
    //virtual llvm::value* codeGen(CodeGenContext& context);
};
class NChar : public NExpression {
public:
    char value;
    NChar(string &value) : value(value[0]){}
    //virtual llvm::value* codeGen(CodeGenContext& context);
};
class NVoid : public NExpression {
public:
    NVoid() = default;

    llvm::Value *codeGen(CodeGenContext &context) ;
};
class NIdentifier : public NExpression {
public:
    std::string name;
    std::string type;
    bool isarray = false;
    shared_ptr<ExpressionList> arraySize = make_shared<ExpressionList>();
    NIdentifier(){}
    NIdentifier(const std::string &name) : name(name) { }
    NIdentifier(const std::string &name,std::string type) : name(name),type(type) { }
    //virtual llvm::value* codeGen(CodeGenContext& context);
};

class NFunctionCall : public NExpression {
public:
    const shared_ptr<NIdentifier> id;
    shared_ptr<ExpressionList> arguments=make_shared<ExpressionList>();
    NFunctionCall(const shared_ptr<NIdentifier> id, shared_ptr<ExpressionList> arguments) :
        id(id), arguments(arguments) { }
    NFunctionCall(const shared_ptr<NIdentifier> id) : id(id) { }
    //virtual llvm::value* codeGen(CodeGenContext& context);
};

class NBinaryOperator : public NExpression {
public:
    int op;
	shared_ptr<NExpression> lhs;
	shared_ptr<NExpression> rhs;
    NExpression& rhs;
    NBinaryOperator(shared_ptr<NExpression> lhs, int op, shared_ptr<NExpression> rhs) :
        lhs(lhs), rhs(rhs), op(op) { }
    //virtual llvm::value* codeGen(CodeGenContext& context);
};

class NAssignment : public NExpression {
public:
    shared_ptr<NIdentifier> lhs;
    shared_ptr<NExpression> rhs;
    NAssignment(shared_ptr<NIdentifier> lhs, shared_ptr<NExpression> rhs) : 
        lhs(lhs), rhs(rhs) { }
    //virtual llvm::value* codeGen(CodeGenContext& context);
};

class Narrayelement : public NExpression{
public:
    shared_ptr<NExpression> arrayname;
    shared_ptr<ExpressionList> expressions = make_shared<ExpressionList>();
    Narrayelement(shared_ptr<NExpression> arrayname,shared_ptr<ExpressionList> expressions):
    arrayname(arrayname),expressions(expressions){}
    Narrayelement(shared_ptr<NExpression> arrayname,shared_ptr<NExpression> expression):
    arrayname(arrayname){expressions->push_back(expression);}
    //virtual llvm::value* codeGen(CodeGenContext& context);
};
class Narrayelementassign : public NExpression{
public:
    shared_ptr<Narrayelement> element;
    shared_ptr<NExpression> assign;
    Narrayelementassign(shared_ptr<Narrayelement> element,shared_ptr<NExpression> assign):
    element(element),assign(assign){}
    //virtual llvm::value* codeGen(CodeGenContext& context);
};
class NBlock : public NExpression {
public:
    shared_ptr<StatementList> statements;
    NBlock(){}
    NBlock(shared_ptr<StatementList> statements):statements(statements) { }
    //virtual llvm::value* codeGen(CodeGenContext& context);
};

class NExpressionStatement : public NStatement {
public:
    shared_ptr<NExpression> expression;
    NExpressionStatement(shared_ptr<NExpression> expression) : 
        expression(expression) { }
    //virtual llvm::value* codeGen(CodeGenContext& context);
};

class NVariableDeclaration : public NStatement {
public:
	const shared_ptr<NIdentifier> type;
	shared_ptr<NIdentifier> id;
	shared_ptr<NExpression> assignmentExpr = nullptr;

    NVariableDeclaration(){}

	NVariableDeclaration(const shared_ptr<NIdentifier> type, shared_ptr<NIdentifier> id, shared_ptr<NExpression> assignmentExpr = NULL)
		: type(type), id(id), assignmentExpr(assignmentExpr) {
            cout << "isArray = " << type->isarray << endl;
            assert(!type->isarray || (type->isarray && type->arraySize != nullptr));
	}
    //virtual llvm::value* codeGen(CodeGenContext& context);
};

class NFunctionDeclaration : public NStatement {
public:
    const shared_ptr<NIdentifier> type;
    const shared_ptr<NIdentifier> id;
    VariableList arguments;
    shared_ptr<NBlock> block;
    NFunctionDeclaration(const shared_ptr<NIdentifier> type, const shared_ptr<NIdentifier> id, 
            VariableList arguments, shared_ptr<NBlock> block) :
        type(type), id(id), arguments(arguments), block(block) { }
    //virtual llvm::value* codeGen(CodeGenContext& context);
};

class Nbreak : public NStatement{
    //Nbreak(){}
    //virtual llvm::value* codeGen(CodeGenContext& context);
};
class Nforloop : public NStatement{
public:
    shared_ptr<NExpression> initial;
    shared_ptr<NExpression> condition;
    shared_ptr<NExpression> end;
    shared_ptr<NBlock> block;
    Nforloop(shared_ptr<NExpression> i,shared_ptr<NExpression> c,shared_ptr<NExpression> e,shared_ptr<NBlock> b):
    initial(i),condition(c),end(e),block(b)
    {
        if( condition == nullptr ){
            condition = make_shared<NInteger>(1);
        }
    }
    //virtual llvm::value* codeGen(CodeGenContext& context);
};

class Nstructdeclaration:public NStatement{
public:
    shared_ptr<NExpression> structname;
    VariableList variablelist;
    Nstructdeclaration(shared_ptr<NExpression> structname,VariableList variablelist):
    structname(structname),variablelist(variablelist)
    {}
    //virtual llvm::value* codeGen(CodeGenContext& context);
};

class Narrayinitialize:public NStatement{
public:
    shared_ptr<NVariableDeclaration> arrayinit;
    shared_ptr<ExpressionList> assign;
    Narrayinitialize(shared_ptr<NVariableDeclaration> arrayinit,shared_ptr<ExpressionList> assign=nullptr):
    arrayinit(arrayinit),assign(assign){}
    //virtual llvm::value* codeGen(CodeGenContext& context);
};

class Nifelse: public NStatement{
public:
    shared_ptr<NBlock> ifblock;
    shared_ptr<NBlock> elseblock;
    shared_ptr<NExpression> condition;
    Nifelse(shared_ptr<NExpression> condition,shared_ptr<NBlock> ifblock,shared_ptr<NBlock> elseblock=nullptr):
    condition(condition),ifblock(ifblock),elseblock(elseblock){}
    //virtual llvm::value* codeGen(CodeGenContext& context);
};

class Nreturn: public NStatement{
public:
    shared_ptr<NExpression> expression;
    Nreturn(){expression=nullptr;}
    Nreturn(shared_ptr<NExpression> expression = nullptr) : expression(expression) {}

    //virtual llvm::value* codeGen(CodeGenContext& context);
};

class Nwhile: public NStatement{
public:
    shared_ptr<NBlock> whileblock;
    shared_ptr<NExpression> condition;
    Nwhile(shared_ptr<NBlock> whileblock,shared_ptr<NExpression> condition):whileblock(whileblock),condition(condition){}
    //virtual llvm::value* codeGen(CodeGenContext& context);
};

class NStructmember: public NExpression{
public:
    shared_ptr<NIdentifier> structname;
    shared_ptr<NIdentifier> member;
    NStructmember(shared_ptr<NIdentifier> structname,shared_ptr<NIdentifier> member):structname(structname),member(member){}
    //virtual llvm::value* codeGen(CodeGenContext& context);
};

class Nstructassign:public NExpression{
public:
    shared_ptr<NStructmember> member;
    shared_ptr<NExpression> assign;
    Nstructassign(shared_ptr<NStructmember> member,shared_ptr<NExpression> assign):
    member(member),assign(assign){}
    //virtual llvm::value* codeGen(CodeGenContext& context);
};
