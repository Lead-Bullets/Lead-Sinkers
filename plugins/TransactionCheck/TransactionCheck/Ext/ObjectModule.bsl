
Procedure Init(BSLParser) Export
	
EndProcedure // Init() 

Function Interface() Export
	Var Interface;
	Interface = New Array;
	Interface.Add("VisitDecl");
	Return Interface;
EndFunction // Interface() 

Procedure VisitDecl(Decl, Info) Export
	Var BeginTransaction, CommitTransaction, RollbackTransaction;
	BeginTransaction = False;
	CommitTransaction = False;
	RollbackTransaction = False;
	LineBeginTransaction = 0;
	Stmt = VisitStatements(Decl.Body, BeginTransaction, CommitTransaction, RollbackTransaction, LineBeginTransaction);
	If BeginTransaction = True And (CommitTransaction = False Or RollbackTransaction = False) Then 
		If CommitTransaction = False Then 
			Message(StrTemplate("Строка %1. Для вызова ""НачатьТранзакцию()"" отсутствует парный вызов ""ЗафиксироватьТранзакцию()""", LineBeginTransaction));
		EndIf;
		If RollbackTransaction = False Then 
			Message(StrTemplate("Строка %1. Для вызова ""НачатьТранзакцию()"" отсутствует парный вызов ""ОтменитьТранзакцию()""", LineBeginTransaction));
		EndIf;
	EndIf;
EndProcedure // VisitDecl()

Function VisitStatements(Statements, BeginTransaction, CommitTransaction, RollbackTransaction, LineBeginTransaction)
	Var Stmt;
	For Each Stmt In Statements Do
		VisitStmt(Stmt, BeginTransaction, CommitTransaction, RollbackTransaction, LineBeginTransaction);
	EndDo;
	Return Stmt;
EndFunction // VisitStatements()

Procedure VisitStmt(Stmt, BeginTransaction, CommitTransaction, RollbackTransaction, LineBeginTransaction)
	NodeType = Stmt.Type;
	If NodeType = "CallStmt" Then
		If Stmt.Desig.Object.Name = "НачатьТранзакцию" and Stmt.Desig.Call = True Then 
			If BeginTransaction = True And (CommitTransaction = False Or RollbackTransaction = False) Then 
				If CommitTransaction = False Then 
					Message(StrTemplate("Строка %1. Для вызова ""НачатьТранзакцию()"" отсутствует парный вызов ""ЗафиксироватьТранзакцию()""", LineBeginTransaction));
				EndIf;
				If RollbackTransaction = False Then 
					Message(StrTemplate("Строка %1. Для вызова ""НачатьТранзакцию()"" отсутствует парный вызов ""ОтменитьТранзакцию()""", LineBeginTransaction));
				EndIf;
			EndIf;
			BeginTransaction = True;
			CommitTransaction = False;
			RollbackTransaction = False;
			LineBeginTransaction = Stmt.Place.Line;
		EndIf;
		If Stmt.Desig.Object.Name = "ЗафиксироватьТранзакцию" and Stmt.Desig.Call = True Then 
			If BeginTransaction = False Then 
				Message(StrTemplate("Строка %1. Отсутствует вызов ""НачатьТранзакцию()"", хотя вызывается ""ЗафиксироватьТранзакцию()""", Stmt.Place.Line));
			EndIf;
			CommitTransaction = True;
		EndIf;
		If Stmt.Desig.Object.Name = "ОтменитьТранзакцию" and Stmt.Desig.Call = True Then 
			If BeginTransaction = False Then 
				Message(StrTemplate("Строка %1. Отсутствует вызов ""НачатьТранзакцию()"", хотя вызывается ""ОтменитьТранзакцию()""", Stmt.Place.Line));
			EndIf;
			RollbackTransaction = True;
		EndIf;
	ElsIf NodeType = "IfStmt" Then
		VisitStatements(Stmt.Then, BeginTransaction, CommitTransaction, RollbackTransaction, LineBeginTransaction);
		If Stmt.ElsIf <> Undefined Then
			VisitStatements(Stmt.ElsIf, BeginTransaction, CommitTransaction, RollbackTransaction, LineBeginTransaction)
		EndIf;
		If Stmt.Else <> Undefined Then
			VisitStatements(Stmt.Else, BeginTransaction, CommitTransaction, RollbackTransaction, LineBeginTransaction);
		EndIf;
	ElsIf NodeType = "WhileStmt" Then
		VisitStatements(Stmt.Body, BeginTransaction, CommitTransaction, RollbackTransaction, LineBeginTransaction);
	ElsIf NodeType = "ForStmt" Then
		VisitStatements(Stmt.Body, BeginTransaction, CommitTransaction, RollbackTransaction, LineBeginTransaction);
	ElsIf NodeType = "TryStmt" Then
		VisitStatements(Stmt.Try, BeginTransaction, CommitTransaction, RollbackTransaction, LineBeginTransaction);
		VisitStatements(Stmt.Except, BeginTransaction, CommitTransaction, RollbackTransaction, LineBeginTransaction);
	EndIf;
EndProcedure // VisitStmt()
