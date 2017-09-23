
Procedure Init(BSLParser) Export
	
EndProcedure // Init() 

Function Interface() Export
	Var Interface;
	Interface = New Array;
	Interface.Add("VisitDecl");
	Return Interface;
EndFunction // Interface() 

Procedure VisitDecl(Module, Decl) Export
	Var InTry, Stmt;
	InTry = False;
	Stmt = VisitStatements(Decl.Body, InTry);
	//If Stmt = Undefined
	//	Or Stmt.Type <> "ReturnStmt"
	//	Or TryCount <> 1 Then
	//	
	//EndIf;
EndProcedure // VisitFuncDecl()

Function VisitStatements(Statements, InTry)
	Var Stmt;
	For Each Stmt In Statements Do
		VisitStmt(Stmt, InTry);
	EndDo;
	Return Stmt;
EndFunction // VisitStatements()

Procedure VisitStmt(Stmt, InTry)
	NodeType = Stmt.Type;
	If NodeType = "ReturnStmt" Then
		
	ElsIf NodeType = "IfStmt" Then
		VisitStatements(Stmt.Then, InTry);
		If Stmt.ElsIf <> Undefined Then
			VisitStatements(Stmt.ElsIf, InTry)
		EndIf;
		If Stmt.Else <> Undefined Then
			VisitStatements(Stmt.Else, InTry);
		EndIf;
	ElsIf NodeType = "WhileStmt" Then
		VisitStatements(Stmt.Body, InTry);
	ElsIf NodeType = "ForStmt" Then
		VisitStatements(Stmt.Body, InTry);
	ElsIf NodeType = "TryStmt" Then
		VisitStatements(Stmt.Try, True);
		InTry = False;
		VisitStatements(Stmt.Except, InTry);
	ElsIf NodeType = "AssignStmt" Then 
		If Stmt.Right.Type = "NewExpr" Then 
			If Stmt.Right.Constr.Type = "DesigExpr" And (Stmt.Right.Constr.Object.Name = "COMОбъект" or Stmt.Right.Constr.Object.Name = "COMObject") Then 
				If Not InTry Then 
					Message(StrTemplate("Конструктор COMОбъект/COMObject, строка - %1, должен быть к конструкции Попытка" "", Stmt.Place.Line));
				EndIf;
			EndIf;
		EndIf;
	EndIf;
EndProcedure // VisitStmt()
