
Procedure Init(BSLParser) Export
	
EndProcedure // Init() 

Function Interface() Export
	Var Interface;
	Interface = New Array;
	Interface.Add("VisitTernaryExpr");
	Return Interface;
EndFunction // Interface() 

Procedure VisitTernaryExpr(Decl, Info) Export
	If Info.Outer.Parent.Type = "TernaryExpr" Then 
		Message(StrTemplate("Строка %1. Использование вложенного тернарного оператора", Decl.Place.Line));
	EndIf;
EndProcedure // VisitTernaryExpr()