
Procedure Init(BSLParser) Export
	
EndProcedure // Init() 

Function Interface() Export
	Var Interface;
	Interface = New Array;
	Interface.Add("VisitDesigExpr");
	Return Interface;
EndFunction // Interface() 

Procedure VisitDesigExpr(Decl, Info) Export
	CallMethodName = "РольДоступна, IsInRole, Сообщить, Message, ТекущаяДата, CurrentDate, ПолучитьФорму, GetForm, НайтиПоКоду, FindByCode, НайтиПоНаименованию, FindByDescription";
	If StrFind(CallMethodName, Decl.Object.Name) > 0 Then 
		Message(StrTemplate("Строка %1. Использование метода %2.", Decl.Place.Line, Decl.Object.Name));
	EndIf;
EndProcedure // VisitCallStmt()