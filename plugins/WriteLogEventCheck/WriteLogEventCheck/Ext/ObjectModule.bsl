
Procedure Init(BSLParser) Export
	
EndProcedure // Init() 

Function Interface() Export
	Var Interface;
	Interface = New Array;
	Interface.Add("VisitDesigExpr");
	Return Interface;
EndFunction // Interface() 

Procedure VisitDesigExpr(Decl, Info) Export
	If Decl.Object.Name = "ЗаписьЖурналаРегистрации" Then 
		If Decl.Select[0].Value[0].Type = "DesigExpr" And Decl.Select[0].Value[0].Call = True Then 
			EventName = Decl.Select[0].Value[0].Select[0].Value;
			If EventName[0].Type = "StringExpr" Then 
				For Each ExprList In EventName[0].List Do 
					If ExprList.Type = "BasicLitExpr" Then 
						If StrFind(ExprList.Value, ". ") > 0 Then 
							Message(StrTemplate("Строка %1 .В параметре ""ИмяСобытия"" метода ""ЗаписьЖурналаРегистрации()"" имеется лишний пробел после точки.", ExprList.Place.Line));
						EndIf;
					EndIf;
				EndDo;
			EndIf;
			If EventName[1] = Undefined Then 
				Message(StrTemplate("Строка %1 .Для параметра ""ИмяСобытия"" метода ""ЗаписьЖурналаРегистрации()"" не задан основной язык конфигурации.", Decl.Select[0].Value[0].Place.Line));
			EndIf;
			
			
		ElsIf Decl.Select[0].Value[0].Type = "StringExpr" Then 
			For Each ExprList In Decl.Select[0].Value[0].List Do 
				If ExprList.Type = "BasicLitExpr" Then 
					If StrFind(ExprList.Value, ". ") > 0 Then 
						Message(StrTemplate("Строка %1 .В параметре ""ИмяСобытия"" метода ""ЗаписьЖурналаРегистрации()"" имеется лишний пробел после точки.", ExprList.Place.Line));
					EndIf;
				EndIf;
			EndDo;
		ElsIf Decl.Select[0].Value[0].Type = "DesigExpr" And Decl.Select[0].Value[0].Call = False Then 
			//TODO сделать в статанализе определение знаение переменной.
			
		Else 
			Message("Проверить правило XXX");
		EndIf;
		//TODO Переделать когда будет статанализ.
		If Decl.Select[0].Value.Count() >= 5 Then 
			If StrFind(Decl.Select[0].Value[4].Place.Str, "ПодробноеПредставлениеОшибки") > 0 Or StrFind(Decl.Select[0].Value[4].Place.Str, "DetailErrorDescription") > 0 Then 
				If Not Decl.Select[0].Value[1].Place.Str = "УровеньЖурналаРегистрации.Ошибка" Then 
					Message(StrTemplate("Строка %1. Если в параметре ""Комментарий"" метода ""ЗаписьЖурналаРегистрации()"" указано подробное описание ошибки, то уровень журнала должен быть ""Ошибка"".""", Decl.Select[0].Value[1].Place.Line));
				EndIf;
			EndIf;
		EndIf;
	EndIf;
EndProcedure // VisitStringExpr()