
Procedure Init(BSLParser) Export
	
EndProcedure // Init() 

Function Interface() Export
	Var Interface;
	Interface = New Array;
	Interface.Add("VisitTernaryExpr");
	Return Interface;
EndFunction // Interface() 

Procedure VisitTernaryExpr(Decl, Info) Export
	If Info.Outer.Parent.Type = "TernaryExpr" Or Info.Parent.Type = "TernaryExpr" Then 
		Message(StrTemplate("Строка %1 Позиция %2. Использование вложенного тернарного оператора", Decl.Place.Line, Decl.Place.Pos));
	EndIf;
EndProcedure // VisitTernaryExpr()