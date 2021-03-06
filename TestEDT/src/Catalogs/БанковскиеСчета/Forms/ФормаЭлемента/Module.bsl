
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		Объект.ВалютаДенежныхСредств = УА_ПривилегированныйСервер.ВалютаРеглУчета();
		
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НомерСчетаПриИзменении(Элемент)
	
	Объект.НомерСчета = СтрЗаменить(Объект.НомерСчета, " ", "");
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("НаименованиеНачалоВыбораЗавершение", ЭтотОбъект);
	
	ПоказатьВыборИзСписка(ОписаниеОповещения, ПолучитьСборкуНаименования(), Элемент);

КонецПроцедуры

&НаКлиенте
Процедура НаименованиеНачалоВыбораЗавершение(ВыбранноеЗначение, ДопПараметры) Экспорт
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.Наименование = ВыбранноеЗначение;
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Обычный = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный;

	ФормаВыбора = ПолучитьФорму("Справочник.ДоговорыКонтрагентов.ФормаВыбора", , Элемент);
	
	СписокОтбор = ФормаВыбора.Список.КомпоновщикНастроек.Настройки.Отбор;
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокОтбор, "Владелец", Объект.Владелец, ВидСравненияКомпоновкиДанных.Равно, ,Истина, Обычный);
	
	ОткрытьФорму(ФормаВыбора);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция получет сборку наименования
//
// Параметры:
//  Отсутствуют
//
// Возвращаемое значение:
//   СписокЗначений
//
&НаКлиенте
Функция ПолучитьСборкуНаименования()
	
	//Варианты наименования отличаются последовательностью элементов:
	// 0: 40702978000000000000, ОАО "СБЕРБАНК РОССИИ", EUR
	// 1: 40702978000000000000 (EUR) в ОАО "СБЕРБАНК РОССИИ"
	// 2: ОАО "СБЕРБАНК РОССИИ" (40702978000000000000, EUR) 
	
	СЗ = Новый СписокЗначений;						
	СЗ.Добавить(СокрЛП(Объект.НомерСчета) +" "+ СокрЛП(Объект.Банк)+" "+СокрЛП(Объект.ВалютаДенежныхСредств));
	СЗ.Добавить(СокрЛП(Объект.НомерСчета) +" ("+СокрЛП(Объект.ВалютаДенежныхСредств)+") в "+ СокрЛП(Объект.Банк));
	СЗ.Добавить(СокрЛП(Объект.Банк)+" ("+Объект.НомерСчета +", "+СокрЛП(Объект.ВалютаДенежныхСредств)+")");	  
			 	
	Возврат СЗ;
	
КонецФункции // ПолучитьСборкуНаименования()

#КонецОбласти
