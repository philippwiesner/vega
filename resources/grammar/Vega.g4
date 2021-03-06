grammar Vega;

block
    :   (FUNC ID LBRACKET functionParameterDeclaration? RBRACKET RETURN_TYPE functionReturnType scopeStatement)+ EOF
    ;

functionParameterDeclaration
	:   functionParameterDefinition (COMMA functionParameterDefinition)*
    ;

functionParameterDefinition
    :   ID COLON variableType (ASSIGN expression)?
    ;

functionReturnType
    :   terminalVariableType (LARRAY RARRAY)*
    ;

scopeStatement
    :   LCURLY statement RCURLY
    ;

statement
	:	(identifierStatement DELIMITER
	|   returnStatement DELIMITER
	|   CONTINUE DELIMITER
	|   BREAK DELIMITER
	|	whileStatement
	|	ifStatement
	|	block)+
	|   PASS DELIMITER
	;

identifierStatement
    :   ID (declarationStatement | assignStatement | funcCall)
    ;

declarationStatement
    :   (COMMA ID)* COLON (CONST)? variableType (ASSIGN expression)?
    ;

assignStatement
	:   (arrayAccess)? ASSIGN expression
    ;

returnStatement
    :   RETURN expression
    ;

whileStatement
	:   WHILE conditionalScope
    ;

ifStatement
	:   IF conditionalScope (ELIF conditionalScope)* (ELSE scopeStatement)?
    ;

conditionalScope
    :   LBRACKET expression RBRACKET scopeStatement
    ;

expression
    :   term (PLUS term | MINUS term | OR term)*
    ;

term
    :	factor (MULT factor | DIV factor| AND factor)*
	;

factor
    :   NOT? MINUS? unary (comparisonOperator unary)*
    ;

unary
    :   terminal
    |   ID (arrayAccess)? // potential array access
    |   ID funcCall
    |   LBRACKET expression RBRACKET
    |   LARRAY (expression (COMMA expression)*)? RARRAY
    ;

funcCall
    :   LBRACKET ( expression (COMMA expression)*)? RBRACKET
    ;

arrayAccess
    :   LARRAY expression RARRAY
    ;

// Terminals
terminal
    :   INT
    |   FLOAT
    |   BOOL
    |   LITERAL
    |   CHAR
    ;
variableType
    :   terminalVariableType (LARRAY INT RARRAY)*
    ;
terminalVariableType
    :   INT_TYPE
    |   FLOAT_TYPE
    |   STRING_TYPE
    |   CHAR_TYPE
    |   BOOL_TYPE
    ;
comparisonOperator
    :   EQUAL
    |   NOTEQUAL
    |   GREATER
    |   GREATEREQ
    |   LESS
    |   LESSEQ
    ;


// Tokens
PLUS
    :   '+'
    ;
MINUS
    :   '-'
    ;
MULT
    :   '*'
    ;
DIV
    :   '/'
    ;
LBRACKET
    :   '('
    ;
RBRACKET
    :   ')'
    ;
LCURLY
    :   '{'
    ;
RCURLY
    :   '}'
    ;
LARRAY
    :   '['
    ;
RARRAY
    :   ']'
    ;
COLON
    :   ':'
    ;
COMMA
    :   ','
    ;
ASSIGN
    :   '='
    ;
LESS
    :   '<'
    ;
GREATER
    :   '>'
    ;
EQUAL
    :   '=='
    ;
LESSEQ
    :   '<='
    ;
GREATEREQ
    :   '>='
    ;
NOTEQUAL
    :   '!='
    ;
DELIMITER
    :   ';'
    ;

// Words
CONST
    :   'const'
    ;
FUNC
    :   'func'
    ;
WHILE
    :   'while'
    ;
IF
    :   'if'
    ;
ELIF
    :   'elif'
    ;
ELSE
    :   'else'
    ;
RETURN_TYPE
    :   '->'
    ;
RETURN
    :   'return'
    ;
PASS
    :   'pass'
    ;
CONTINUE
    :   'continue'
    ;
BREAK
    :   'break'
    ;
INT_TYPE
    :   'int'
    ;
FLOAT_TYPE
    :   'float'
    ;
STRING_TYPE
    :   'str'
    ;
CHAR_TYPE
    :   'char'
    ;
BOOL_TYPE
    :   'bool'
    ;
NOT
    :   'not'
    |   '!'
    ;
AND
    :   'and'
    |   '&&'
    ;
OR
    :   'or'
    |   '||'
    ;


ID  :	('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')*
    ;

BOOL
    :   'true'
    |   'false'
    ;

INT :	'0'..'9'+
    ;

FLOAT
    :   ('0'..'9')+ '.' ('0'..'9')* EXPONENT?
    |   '.' ('0'..'9')+ EXPONENT?
    |   ('0'..'9')+ EXPONENT
    ;

LITERAL
    :  '"' ( ESC_SEQ | ~('\\'|'"') )* '"'
    ;

CHAR:  '\'' ( ESC_SEQ | ~('\''|'\\') ) '\''
    ;

fragment
EXPONENT : ('e'|'E') ('+'|'-')? ('0'..'9')+ ;

fragment
HEX_DIGIT : ('0'..'9'|'a'..'f'|'A'..'F') ;

fragment
ESC_SEQ
    :   '\\' ('b'|'t'|'n'|'f'|'r'|'\\"'|'\''|'\\')
    |   UNICODE_ESC
    |   OCTAL_ESC
    ;

fragment
OCTAL_ESC
    :   '\\' ('0'..'3') ('0'..'7') ('0'..'7')
    |   '\\' ('0'..'7') ('0'..'7')
    |   '\\' ('0'..'7')
    ;

fragment
UNICODE_ESC
    :   '\\' 'u' HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT
    ;

WS : [ \t\n]+ -> skip;
