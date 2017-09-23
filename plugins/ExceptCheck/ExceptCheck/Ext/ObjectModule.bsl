Procedure Init(BSLParser) Export
	
EndProcedure // Init()

Function Interface() Export
	Var Interface;
	Interface = New Array;
	Interface.Add("VisitTryStmt");
	Return Interface;
EndFunction // Interface()

Procedure VisitTryStmt(FuncDecl) Export
	Var CountCallStmtWriteLogEventInExcept;
	CountCallStmtWriteLogEventInExcept = 0;
	VisitStatements(FuncDecl.Try, CountCallStmtWriteLogEventInExcept, FuncDecl);
	StmtExcept = VisitStatements(FuncDecl.Except, CountCallStmtWriteLogEventInExcept, FuncDecl);
	If CountCallStmtWriteLogEventInExcept <> 1 Then 
			Message(StrTemplate("Ошибка в строке %1 Исключение должно иметь запись в журнал регистрации, Правило 3.4. Недопустимо перехватывать любые исключения, бесследно для системного администратора:" "", FuncDecl.Place.Line));
	EndIf;
EndProcedure // VisitDecl()

Function VisitStatements(Statements, CountCallStmtWriteLogEventInExcept, FuncDecl)
	Var Stmt;
	For Each Stmt In Statements Do
		VisitStmt(Stmt, CountCallStmtWriteLogEventInExcept, FuncDecl);
	EndDo;
	Return Stmt;
EndFunction // VisitStatements()

Procedure VisitStmt(Stmt, CountCallStmtWriteLogEventInExcept, FuncDecl)
	NodeType = Stmt.Type;
	
	If NodeType = "CallStmt" Then
		NodeDesig = Stmt.Desig;
		If NodeDesig.Type = "DesigExpr" Then 
			If NodeDesig.Object.Name = "ЗаписьЖурналаРегистрации" Then 
				CountCallStmtWriteLogEventInExcept = CountCallStmtWriteLogEventInExcept + 1;
			EndIf;
		EndIf;
	ElsIf NodeType = "IfStmt" Then
		VisitStatements(Stmt.Then, CountCallStmtWriteLogEventInExcept, FuncDecl);
		If Stmt.ElsIf <> Undefined Then
			VisitStatements(Stmt.ElsIf, CountCallStmtWriteLogEventInExcept, FuncDecl)
		EndIf;
		If Stmt.Else <> Undefined Then
			VisitStatements(Stmt.Else, CountCallStmtWriteLogEventInExcept, FuncDecl);
		EndIf;
	ElsIf NodeType = "WhileStmt" Then
		VisitStatements(Stmt.Body, CountCallStmtWriteLogEventInExcept, FuncDecl);
	ElsIf NodeType = "ForStmt" Then
		VisitStatements(Stmt.Body, CountCallStmtWriteLogEventInExcept, FuncDecl);
	ElsIf NodeType = "TryStmt" Then
		CountCallStmtWriteLogEventInExcept = 0;
		VisitStatements(Stmt.Try, CountCallStmtWriteLogEventInExcept, FuncDecl);
		StmtExcept = VisitStatements(Stmt.Except, CountCallStmtWriteLogEventInExcept, FuncDecl);
		If CountCallStmtWriteLogEventInExcept <> 1 Then 
			Message(StrTemplate("Исключение %1() должно иметь запись в журнал регистрации, Правило 3.4. Недопустимо перехватывать любые исключения, бесследно для системного администратора:" "", FuncDecl.Object.Name));
		EndIf;
	EndIf;
EndProcedure // VisitStmt()
