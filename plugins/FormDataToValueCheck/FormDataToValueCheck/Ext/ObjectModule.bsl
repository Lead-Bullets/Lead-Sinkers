
Procedure Init(BSLParser) Export
	
EndProcedure // Init() 

Function Interface() Export
	Var Interface;
	Interface = New Array;
	Interface.Add("VisitDesigExpr");
	Return Interface;
EndFunction // Interface() 

Procedure VisitDesigExpr(Decl, Info) Export
	If Decl.Object.Name = "ДанныеФормыВЗначение" or Decl.Object.Name = "FormDataToValue" Then 
		Message(StrTemplate("Строка %1. Использован метод ""ДанныеФормыВЗначение()"".", Decl.Place.Line));
	EndIf;
EndProcedure // VisitDesigExpr()