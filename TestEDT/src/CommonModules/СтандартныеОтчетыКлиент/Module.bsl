///////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

//Процедура добавляет поля ресурсов в запрещенные поля 
//
// Параметры:
//  Форма - форма отчета
//  СписокПолей - список полей
//
Процедура ДобавитьПоляРесурсовВЗапрещенныеПоля(Форма, СписокПолей) Экспорт
	
	Для Каждого ИмяПоказателя Из Форма.НаборПоказателей Цикл
		Если Форма.Отчет["Показатель" + ИмяПоказателя] Тогда 
			Если ИмяПоказателя = "Контроль" Тогда
				Продолжить;
			КонецЕсли;
			ВидОстатка = "";
			Если Форма.Отчет.Свойство("РазвернутоеСальдо") Тогда
				Если ТипЗнч(Форма.Отчет.РазвернутоеСальдо) = Тип("Булево") Тогда
					Если Форма.Отчет.РазвернутоеСальдо Тогда
						ВидОстатка = "";
					Иначе
						ВидОстатка = "Развернутый";
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			СписокПолей.Добавить("СальдоНаНачалоПериода." + ИмяПоказателя + "Начальный" + ВидОстатка + "ОстатокДт");
			СписокПолей.Добавить("СальдоНаНачалоПериода." + ИмяПоказателя + "Начальный" + ВидОстатка + "ОстатокКт");
			СписокПолей.Добавить("СальдоНаКонецПериода." + ИмяПоказателя + "Конечный" + ВидОстатка + "ОстатокДт");
			СписокПолей.Добавить("СальдоНаКонецПериода." + ИмяПоказателя + "Конечный" + ВидОстатка + "ОстатокКт");
		Иначе
			СписокПолей.Добавить("СальдоНаНачалоПериода." + ИмяПоказателя + "НачальныйОстатокДт");
			СписокПолей.Добавить("СальдоНаНачалоПериода." + ИмяПоказателя + "НачальныйОстатокКт");
			СписокПолей.Добавить("ОборотыЗаПериод." + ИмяПоказателя + "ОборотДт");
			СписокПолей.Добавить("ОборотыЗаПериод." + ИмяПоказателя + "ОборотКт");
			СписокПолей.Добавить("СальдоНаКонецПериода." + ИмяПоказателя + "КонечныйОстатокДт");
			СписокПолей.Добавить("СальдоНаКонецПериода." + ИмяПоказателя + "КонечныйОстатокКт");
			СписокПолей.Добавить("СальдоНаНачалоПериода." + ИмяПоказателя + "НачальныйРазвернутыйОстатокДт");
			СписокПолей.Добавить("СальдоНаНачалоПериода." + ИмяПоказателя + "НачальныйРазвернутыйОстатокКт");
			СписокПолей.Добавить("СальдоНаКонецПериода." + ИмяПоказателя + "КонечныйРазвернутыйОстатокДт");
			СписокПолей.Добавить("СальдоНаКонецПериода." + ИмяПоказателя + "КонечныйРазвернутыйОстатокКт");
		КонецЕсли;
	КонецЦикла;
		
КонецПроцедуры

//Процедура группирует поля параметров формы перед началом добавления нового поля 
//
// Параметры:
//  Форма - форма отчета
//  Элемент - элемент формы
//  Отказ - флаг отказа от выполения процедуры
//  Копирование - флаг копирования
//  Родитель - родительский элемент
//  Группа - группа
//
Процедура ГруппировкаПередНачаломДобавления(Форма, Элемент, Отказ, Копирование, Родитель, Группа) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СхемаКомпоновкиДанных", Форма.СхемаКомпоновкиДанных);
	ПараметрыФормы.Вставить("Режим"          , "Группировка");
	ПараметрыФормы.Вставить("ИсключенныеПоля", Форма.ПолучитьЗапрещенныеПоля("Группировка"));
	ПараметрыФормы.Вставить("ТекущаяСтрока"  , Неопределено);

	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ГруппировкаПередНачаломДобавленияЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораДоступногоПоля", ПараметрыФормы, Элемент,,,,ОповещениеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
	Отказ = Истина;
	
КонецПроцедуры

Процедура ГруппировкаПередНачаломДобавленияЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Форма = ДополнительныеПараметры.Форма;
	
	ПараметрыВыбранногоПоля = РезультатЗакрытия;
	
	Если ТипЗнч(ПараметрыВыбранногоПоля) = Тип("Структура") Тогда
		НоваяСтрока = Форма.Отчет.Группировка.Добавить();
		НоваяСтрока.Использование = Истина;
		НоваяСтрока.Поле          = ПараметрыВыбранногоПоля.Поле;
		НоваяСтрока.Представление = ПараметрыВыбранногоПоля.Заголовок;
	КонецЕсли;
	
КонецПроцедуры

//Процедура группирует поля параметров формы перед началом изменения поля 
//
// Параметры:
//  Форма - форма отчета
//  Элемент - элемент
//  Отказ - флаг отказа от выполения процедуры
//
Процедура ГруппировкаПередНачаломИзменения(Форма, Элемент, Отказ) Экспорт
	
	Если Элемент.ТекущийЭлемент = Форма.Элементы.ГруппировкаПредставление Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("СхемаКомпоновкиДанных", Форма.СхемаКомпоновкиДанных);
		ПараметрыФормы.Вставить("Режим"          , "Группировка");
		ПараметрыФормы.Вставить("ИсключенныеПоля", Форма.ПолучитьЗапрещенныеПоля("Группировка"));
		ПараметрыФормы.Вставить("ТекущаяСтрока"  , Элемент.ТекущиеДанные.Поле);
			
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Форма", Форма);
		ДополнительныеПараметры.Вставить("Элемент", Элемент);
			
		ОповещениеОЗакрытии = Новый ОписаниеОповещения("ГруппировкаПередНачаломИзмененияЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		
		ОткрытьФорму("ОбщаяФорма.ФормаВыбораДоступногоПоля", ПараметрыФормы, Элемент,,,,ОповещениеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ГруппировкаПередНачаломИзмененияЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Форма =   ДополнительныеПараметры.Форма;
	Элемент = ДополнительныеПараметры.Элемент;
	
	ПараметрыВыбранногоПоля = РезультатЗакрытия;
	
		Если ТипЗнч(ПараметрыВыбранногоПоля) = Тип("Структура") Тогда
			НоваяСтрока = Элемент.ТекущиеДанные;
			НоваяСтрока.Использование = Истина;
			НоваяСтрока.Поле          = ПараметрыВыбранногоПоля.Поле;
			НоваяСтрока.Представление = ПараметрыВыбранногоПоля.Заголовок;
		КонецЕсли;
	
КонецПроцедуры

//Процедура устанавливает в отчете отборы перед началом добавления 
//
// Параметры:
//  Форма - форма отчета
//  Элемент - элемент
//  Отказ - флаг отказа от выполения процедуры
//  Копирование - флаг копирования
//  Родитель - родительский элемент
//  Группа - группа
//
Процедура ОтборыПередНачаломДобавления(Форма, Элемент, Отказ, Копирование, Родитель, Группа) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СхемаКомпоновкиДанных", Форма.СхемаКомпоновкиДанных);
	ПараметрыФормы.Вставить("Режим"                , "Отбор");
	ПараметрыФормы.Вставить("ИсключенныеПоля"      , Форма.ПолучитьЗапрещенныеПоля("Отбор"));
	ПараметрыФормы.Вставить("ТекущаяСтрока"        , Неопределено);

	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("Элемент", Элемент);
		
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ОтборыПередНачаломДобавленияЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораДоступногоПоля", ПараметрыФормы, Элемент,,,,ОповещениеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
	Отказ = Истина;

КонецПроцедуры

Процедура ОтборыПередНачаломДобавленияЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Форма =   ДополнительныеПараметры.Форма;
	Элемент = ДополнительныеПараметры.Элемент;
	
	ПараметрыВыбранногоПоля = РезультатЗакрытия;
	
	Если ТипЗнч(ПараметрыВыбранногоПоля) = Тип("Структура") Тогда
		
		Если Элемент.ТекущаяСтрока = Неопределено Тогда
			ТекущаяСтрока = Неопределено;
		Иначе
			ТекущаяСтрока = Форма.Отчет.КомпоновщикНастроек.Настройки.Отбор.ПолучитьОбъектПоИдентификатору(Элемент.ТекущаяСтрока);
		КонецЕсли;

		Если ТипЗнч(ТекущаяСтрока) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			ЭлементОтбора = ТекущаяСтрока.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ИначеЕсли ТипЗнч(ТекущаяСтрока) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			Если ТекущаяСтрока.Родитель <> Неопределено Тогда
				ЭлементОтбора = ТекущаяСтрока.Родитель.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			Иначе
				ЭлементОтбора = Форма.Отчет.КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			КонецЕсли;
		Иначе
			ЭлементОтбора = Форма.Отчет.КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		КонецЕсли;
		
		ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(ПараметрыВыбранногоПоля.Поле);
		Если Строка(ПараметрыВыбранногоПоля.Поле) = "Портфель" И Форма.Отчет.Свойство("Портфель") Тогда
			ЭлементОтбора.ПравоеЗначение = Форма.Отчет.Портфель;
		КонецЕсли;
		ЭлементОтбора.ВидСравнения = ПараметрыВыбранногоПоля.ВидСравнения;
		
		Элемент.ТекущаяСтрока = Форма.Отчет.КомпоновщикНастроек.Настройки.Отбор.ПолучитьИдентификаторПоОбъекту(ЭлементОтбора);
		
	КонецЕсли;
	
КонецПроцедуры

//Процедура устанавливает в отчете отборы перед началом изменения 
//
// Параметры:
//  Форма - форма отчета
//  Элемент - элемент
//  Отказ - флаг отказа от выполения процедуры
//
Процедура ОтборыПередНачаломИзменения(Форма, Элемент, Отказ) Экспорт
	
	Если (Найти(Элемент.ТекущийЭлемент.Имя, "ОтборыЛевоеЗначение") > 0 И ТипЗнч(Элемент.ТекущиеДанные.ЛевоеЗначение) = Тип("ПолеКомпоновкиДанных")) Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("СхемаКомпоновкиДанных", Форма.СхемаКомпоновкиДанных);
		ПараметрыФормы.Вставить("Режим"                , "Отбор");
		ПараметрыФормы.Вставить("ИсключенныеПоля"      , Форма.ПолучитьЗапрещенныеПоля("Отбор"));
		ПараметрыФормы.Вставить("ТекущаяСтрока"        , Элемент.ТекущиеДанные.ЛевоеЗначение);
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Форма", Форма);
		ДополнительныеПараметры.Вставить("Элемент", Элемент);
		
		ОповещениеОЗакрытии = Новый ОписаниеОповещения("ОтборыПередНачаломИзмененияЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		
		ОткрытьФорму("ОбщаяФорма.ФормаВыбораДоступногоПоля", ПараметрыФормы, Элемент,,,,ОповещениеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
		Отказ = Истина;
		
	КонецЕсли;	
	
КонецПроцедуры

Процедура ОтборыПередНачаломИзмененияЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Форма =   ДополнительныеПараметры.Форма;
	Элемент = ДополнительныеПараметры.Элемент;
	
	ПараметрыВыбранногоПоля = РезультатЗакрытия;
	
	Если ТипЗнч(ПараметрыВыбранногоПоля) = Тип("Структура") Тогда
		
		ТекущаяСтрока = Форма.Отчет.КомпоновщикНастроек.Настройки.Отбор.ПолучитьОбъектПоИдентификатору(Элемент.ТекущаяСтрока);
		
		Если СтрНайти(Элемент.ТекущийЭлемент.Имя, "ОтборыЛевоеЗначение") > 0 Тогда 
			ТекущаяСтрока.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ПараметрыВыбранногоПоля.Поле);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

//Процедура устанавливает в отчете дополнительные поля перед началом добавления 
//
// Параметры:
//  Форма - форма отчета
//  Элемент - элемент
//  Отказ - флаг отказа от выполения процедуры
//  Копирование - флаг копирования
//  Родитель - родительский элемент
//  Группа - группа
//
Процедура ДополнительныеПоляПередНачаломДобавления(Форма, Элемент, Отказ, Копирование, Родитель, Группа) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СхемаКомпоновкиДанных", Форма.СхемаКомпоновкиДанных);
	ПараметрыФормы.Вставить("Режим"                , "Выбор");
	ПараметрыФормы.Вставить("ИсключенныеПоля"      , Форма.ПолучитьЗапрещенныеПоля("Выбор"));
	ПараметрыФормы.Вставить("ТекущаяСтрока"        , Неопределено);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ДополнительныеПоляПередНачаломДобавленияЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораДоступногоПоля", ПараметрыФормы, Элемент,,,,ОповещениеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
	Отказ = Истина;
	
КонецПроцедуры

Процедура ДополнительныеПоляПередНачаломДобавленияЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Форма = ДополнительныеПараметры.Форма;
	
	ПараметрыВыбранногоПоля = РезультатЗакрытия;
	
	Если ТипЗнч(ПараметрыВыбранногоПоля) = Тип("Структура") Тогда
		НоваяСтрока = Форма.Отчет.ДополнительныеПоля.Добавить();
		НоваяСтрока.Использование = Истина;
		НоваяСтрока.Поле          = ПараметрыВыбранногоПоля.Поле;
		НоваяСтрока.Представление = ПараметрыВыбранногоПоля.Заголовок;
	КонецЕсли;
	
КонецПроцедуры

//Процедура устанавливает в отчете дополнительные поля перед началом изменения 
//
// Параметры:
//  Форма - форма отчета
//  Элемент - элемент
//  Отказ - флаг отказа от выполения процедуры
//
Процедура ДополнительныеПоляПередНачаломИзменения(Форма, Элемент, Отказ) Экспорт
	
	Если Элемент.ТекущийЭлемент = Форма.Элементы.ДополнительныеПоляПредставление Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("СхемаКомпоновкиДанных", Форма.СхемаКомпоновкиДанных);
		ПараметрыФормы.Вставить("Режим"                , "Выбор");
		ПараметрыФормы.Вставить("ИсключенныеПоля"      , Форма.ПолучитьЗапрещенныеПоля("Выбор"));
		ПараметрыФормы.Вставить("ТекущаяСтрока"        , Элемент.ТекущиеДанные.Поле);
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Форма", Форма);
		ДополнительныеПараметры.Вставить("Элемент", Элемент);
	
		ОповещениеОЗакрытии = Новый ОписаниеОповещения("ДополнительныеПоляПередНачаломИзмененияЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		
		ОткрытьФорму("ОбщаяФорма.ФормаВыбораДоступногоПоля", ПараметрыФормы, Элемент,,,,ОповещениеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДополнительныеПоляПередНачаломИзмененияЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Форма =   ДополнительныеПараметры.Форма;
	Элемент = ДополнительныеПараметры.Элемент;
	
	ПараметрыВыбранногоПоля = РезультатЗакрытия;
	
	Если ТипЗнч(ПараметрыВыбранногоПоля) = Тип("Структура") Тогда
		НоваяСтрока = Элемент.ТекущиеДанные;
		НоваяСтрока.Использование = Истина;
		НоваяСтрока.Поле          = ПараметрыВыбранногоПоля.Поле;
		НоваяСтрока.Представление = ПараметрыВыбранногоПоля.Заголовок;
	КонецЕсли;
	
КонецПроцедуры

//Процедура устанавливает в отчете сортировку перед началом добавления 
//
// Параметры:
//  Форма - форма отчета
//  Элемент - элемент
//  Отказ - флаг отказа от выполения процедуры
//  Копирование - флаг копирования
//  Родитель - родительский элемент
//  Группа - группа
//
Процедура СортировкаПередНачаломДобавления(Форма, Элемент, Отказ, Копирование, Родитель, Группа) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СхемаКомпоновкиДанных", Форма.СхемаКомпоновкиДанных);
	ПараметрыФормы.Вставить("Режим"                , "Порядок");
	ПараметрыФормы.Вставить("ИсключенныеПоля"      , Форма.ПолучитьЗапрещенныеПоля("Порядок"));
	ПараметрыФормы.Вставить("ТекущаяСтрока"        , Неопределено);

	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("СортировкаПередНачаломДобавленияЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораДоступногоПоля", ПараметрыФормы, Элемент,,,,ОповещениеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	Отказ = Истина;
	
КонецПроцедуры

Процедура СортировкаПередНачаломДобавленияЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Форма = ДополнительныеПараметры.Форма;
	
	ПараметрыВыбранногоПоля = РезультатЗакрытия;
	
	Если ТипЗнч(ПараметрыВыбранногоПоля) = Тип("Структура") Тогда
		НоваяСтрока = Форма.Отчет.КомпоновщикНастроек.Настройки.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
		НоваяСтрока.Использование     = Истина;
		НоваяСтрока.Поле              = Новый ПолеКомпоновкиДанных(ПараметрыВыбранногоПоля.Поле);
		НоваяСтрока.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
	КонецЕсли;
	
КонецПроцедуры

//Процедура устанавливает в отчете сортировку перед началом изменения 
//
// Параметры:
//  Форма - форма отчета
//  Элемент - элемент
//  Отказ - флаг отказа от выполения процедуры
//
Процедура СортировкаПередНачаломИзменения(Форма, Элемент, Отказ) Экспорт
	
	Если Найти(Элемент.ТекущийЭлемент.Имя, "СортировкаПоле") = 1 Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("СхемаКомпоновкиДанных", Форма.СхемаКомпоновкиДанных);
		ПараметрыФормы.Вставить("Режим"          , "Порядок");
		ПараметрыФормы.Вставить("ИсключенныеПоля", Форма.ПолучитьЗапрещенныеПоля("Порядок"));
		ПараметрыФормы.Вставить("ТекущаяСтрока"  , Элемент.ТекущиеДанные.Поле);

		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Форма", Форма);
		ДополнительныеПараметры.Вставить("Элемент", Элемент);
	
		ОповещениеОЗакрытии = Новый ОписаниеОповещения("СортировкаПередНачаломИзмененияЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		
		ОткрытьФорму("ОбщаяФорма.ФормаВыбораДоступногоПоля", ПараметрыФормы, Элемент,,,,ОповещениеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура СортировкаПередНачаломИзмененияЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Форма =   ДополнительныеПараметры.Форма;
	Элемент = ДополнительныеПараметры.Элемент;
	
	ПараметрыВыбранногоПоля = РезультатЗакрытия;
	
	Если ТипЗнч(ПараметрыВыбранногоПоля) = Тип("Структура") Тогда
		РедактируемаяСтрока = Форма.Отчет.КомпоновщикНастроек.Настройки.Порядок.ПолучитьОбъектПоИдентификатору(Элемент.ТекущаяСтрока);
		
		РедактируемаяСтрока.Использование = Истина;
		РедактируемаяСтрока.Поле          = Новый ПолеКомпоновкиДанных(ПараметрыВыбранногоПоля.Поле);
	КонецЕсли;
	
КонецПроцедуры

//Процедура устанавливает в отчете группировку по счетам в табличном поле перед началом добавления 
//
// Параметры:
//  ФормаОтчета - форма отчета
//  Элемент - элемент
//  Отказ - флаг отказа от выполения процедуры
//  Копирование - флаг копирования
//  Родитель - родительский элемент
//  Группа - группа
//
Процедура ТабличноеПолеПоСчетамГруппировкаПередНачаломДобавления(ФормаОтчета, ИмяЭлемента, Элемент, Отказ, Копирование, Родитель, Группа) Экспорт
	
	Отказ = Истина;
	НоваяСтрока = ФормаОтчета.Отчет[ИмяЭлемента].Добавить();
	НоваяСтрока.Использование = Истина;
	
КонецПроцедуры

//Процедура табличного поля отчета при изменении счета 
//
// Параметры:
//  ФормаОтчета - форма отчета
//  ИмяЭлемента - имя элемента
//  Элемент - текущий элемент
//
Процедура ТабличноеПолеПоСчетамСчетПриИзменении(ФормаОтчета, ИмяЭлемента, Элемент) Экспорт
	
	ТекущиеДанные = ФормаОтчета.Элементы[ИмяЭлемента].ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		Если ЗначениеЗаполнено(ТекущиеДанные.Счет) Тогда
			ДанныеСчета = БухгалтерскийУчетПовтИсп.ПолучитьСвойстваСчета(ТекущиеДанные.Счет);
			Если ДанныеСчета.КоличествоСубконто = 0 Тогда
				ТекущиеДанные.ПоСубсчетам = Истина;
				ТекущиеДанные.ПоСубконто    = СтрЗаменить(ТекущиеДанные.ПоСубконто, "+", "-");
				ТекущиеДанные.Представление = "";
			Иначе
				ТекущиеДанные.ПоСубсчетам = Ложь;
				ТекущиеДанные.ПоСубконто    = СтрЗаменить(ТекущиеДанные.ПоСубконто, "-", "+");
				ТекущиеДанные.Представление = "";
				СтрокаПоСубконто    = "";
				СтрокаПредставление = "";
				Для Индекс = 1 По ДанныеСчета.КоличествоСубконто Цикл
					СтрокаПоСубконто    = СтрокаПоСубконто + "+" + Индекс;
					СтрокаПредставление = СтрокаПредставление + ДанныеСчета["ВидСубконто" + Индекс + "Наименование"] + ", ";
				КонецЦикла;
				СтрокаПредставление = Лев(СтрокаПредставление, СтрДлина(СтрокаПредставление) - 2);
				ТекущиеДанные.ПоСубконто    = СтрокаПоСубконто;
				ТекущиеДанные.Представление = СтрокаПредставление;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

//Процедура табличного поля отчета при изменении по субсчетам 
//
// Параметры:
//  ФормаОтчета - форма отчета
//  ИмяЭлемента - имя элемента
//  Элемент - текущий элемент
//
Процедура ТабличноеПолеПоСчетамПоСубсчетамПриИзменении(ФормаОтчета, ИмяЭлемента, Элемент) Экспорт
	
	ТекущиеДанные = ФормаОтчета.Элементы[ИмяЭлемента].ТекущиеДанные;
	ДанныеСчета = БухгалтерскийУчетПовтИсп.ПолучитьСвойстваСчета(ТекущиеДанные.Счет);
	Если ТекущиеДанные <> Неопределено Тогда
		Если ТекущиеДанные.ПоСубсчетам Тогда
			Если ИмяЭлемента = "РазвернутоеСальдо" Тогда
				ТабличноеПолеПоСчетамПредставлениеОчистка(ФормаОтчета, ИмяЭлемента, Элемент, Ложь);
			КонецЕсли; 
		Иначе
			Если ПустаяСтрока(ТекущиеДанные.Представление) Тогда
				ТекущиеДанные.ПоСубсчетам = Истина;
				Возврат;
			КонецЕсли;
			ТекущиеДанные.ПоСубконто    = СтрЗаменить(ТекущиеДанные.ПоСубконто, "-", "+");
			ТекущиеДанные.Представление = "";
			СтрокаПоСубконто    = "";
			СтрокаПредставление = "";
			Для Индекс = 1 По ДанныеСчета.КоличествоСубконто Цикл
				СтрокаПоСубконто    = СтрокаПоСубконто + "+" + Индекс;
				СтрокаПредставление = СтрокаПредставление + ДанныеСчета["ВидСубконто" + Индекс + "Наименование"] + ", ";
			КонецЦикла;
			СтрокаПредставление = Лев(СтрокаПредставление, СтрДлина(СтрокаПредставление) - 2);
			ТекущиеДанные.ПоСубконто    = СтрокаПоСубконто;
			ТекущиеДанные.Представление = СтрокаПредставление;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

//Процедура определяет субконто счетов и открывает общую форму настроек по субконто 
//
// Параметры:
//  ФормаОтчета - форма отчета
//  ИмяЭлемента - имя элемента
//  Элемент - текущий элемент
//  ДанныеВыбора - данные для выбора
//  Стандартная обработка - стандартная обработка события
//
Процедура ТабличноеПолеПоСчетамПредставлениеНачалоВыбора(ФормаОтчета, ИмяЭлемента, Элемент, ДанныеВыбора, СтандартнаяОбработка) Экспорт
	
	СтрокаПоСубконто = ФормаОтчета.Элементы[ИмяЭлемента].ТекущиеДанные.ПоСубконто;
	Счет = ФормаОтчета.Элементы[ИмяЭлемента].ТекущиеДанные.Счет;
	ДанныеСчета = БухгалтерскийУчетПовтИсп.ПолучитьСвойстваСчета(Счет);
	СписокВидовСубконто = Новый СписокЗначений;
	Если ПустаяСтрока(СтрокаПоСубконто) Тогда		
		Для Индекс = 1 По ДанныеСчета.КоличествоСубконто Цикл
			СписокВидовСубконто.Добавить(ДанныеСчета["ВидСубконто" + Индекс], ДанныеСчета["ВидСубконто" + Индекс + "Наименование"]);
		КонецЦикла;
	Иначе
		КоличествоСубконто = СтрДлина(СтрокаПоСубконто) / 2;
		Для Индекс = 1 По КоличествоСубконто Цикл
			СписокВидовСубконто.Добавить(ДанныеСчета["ВидСубконто" + Сред(СтрокаПоСубконто, Индекс*2, 1)], ДанныеСчета["ВидСубконто" + Сред(СтрокаПоСубконто, Индекс*2, 1) + "Наименование"], ?(Сред(СтрокаПоСубконто, Индекс * 2 - 1, 1) = "+", Истина, Ложь));
		КонецЦикла;
	КонецЕсли;	
	ОткрытьФорму("ОбщаяФорма.ФормаНастройкаПоСубконто", Новый Структура("СписокВидовСубконто", СписокВидовСубконто), Элемент);
	
КонецПроцедуры

//Процедура очищает представление 
//
// Параметры:
//  ФормаОтчета - форма отчета
//  ИмяЭлемента - имя элемента
//  Элемент - текущий элемент
//  Стандартная обработка - стандартная обработка события
//
Процедура ТабличноеПолеПоСчетамПредставлениеОчистка(ФормаОтчета, ИмяЭлемента, Элемент, СтандартнаяОбработка) Экспорт
		
	ФормаОтчета.Элементы[ИмяЭлемента].ТекущиеДанные.ПоСубконто    = СтрЗаменить(ФормаОтчета.Элементы[ИмяЭлемента].ТекущиеДанные.ПоСубконто, "+", "-");
	ФормаОтчета.Элементы[ИмяЭлемента].ТекущиеДанные.Представление = "";
	
КонецПроцедуры

//Процедура обработки выбора табличного поля по счетам 
//
// Параметры:
//  ФормаОтчета - форма отчета
//  ИмяЭлемента - имя элемента
//  Элемент - текущий элемент
//  ВыбранноеЗначение - выбранное значение
//  СтандартнаяОбработка - стандартная обработка события
//
Процедура ТабличноеПолеПоСчетамПредставлениеОбработкаВыбора(ФормаОтчета, ИмяЭлемента, Элемент, ВыбранноеЗначение, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = ФормаОтчета.Элементы[ИмяЭлемента].ТекущиеДанные;
	ДанныеСчета = БухгалтерскийУчетПовтИсп.ПолучитьСвойстваСчета(ТекущиеДанные.Счет);
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СписокЗначений") Тогда 
		СтрокаПоСубконто = "";
		СтрокаПредставление = "";
		Для Каждого ЭлементСписка Из ВыбранноеЗначение Цикл
			Если ЭлементСписка.Пометка Тогда
				СтрокаПоСубконто    = СтрокаПоСубконто + "+";
				СтрокаПредставление = СтрокаПредставление + Строка(ЭлементСписка.Значение) + ", ";
			Иначе
				СтрокаПоСубконто = СтрокаПоСубконто + "-";
			КонецЕсли;
			
			Для Индекс = 1 По ДанныеСчета.КоличествоСубконто Цикл 
				Если ДанныеСчета["ВидСубконто" + Индекс] = ЭлементСписка.Значение Тогда
					СтрокаПоСубконто = СтрокаПоСубконто + Индекс;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		СтрокаПредставление = Лев(СтрокаПредставление, СтрДлина(СтрокаПредставление) - 2);
		
		Если ПустаяСтрока(СтрокаПредставление) И Не ДанныеСчета.ЗапретитьИспользоватьВПроводках Тогда
			Возврат;
		КонецЕсли;
		ТекущиеДанные.ПоСубконто    = СтрокаПоСубконто;
		ТекущиеДанные.Представление = СтрокаПредставление;
		
		Если ПустаяСтрока(СтрокаПредставление) Тогда
			ТекущиеДанные.ПоСубсчетам = Истина;
		Иначе
			Если ИмяЭлемента = "РазвернутоеСальдо" Тогда
				ТекущиеДанные.ПоСубсчетам = Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

//Процедура обработки расшифровки стандартного отчета 
//
// Параметры:
//  ФормаОтчета - форма отчета
//  Элемент - текущий элемент
//  Расшифровка - расшифровка
//  Стандартная обработка - стандартная обработка события
//
Процедура ОбработкаРасшифровкиСтандартногоОтчета(ФормаОтчета, Элемент, Расшифровка, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ИдентификаторОбъекта = СтандартныеОтчетыКлиентСервер.ПолучитьИдентификаторОбъекта(ФормаОтчета);
	
	ПараметрыРасшифровки = СтандартныеОтчеты.ПолучитьПараметрыРасшифровкиОтчета(ФормаОтчета.ДанныеРасшифровки, ИдентификаторОбъекта, Расшифровка);
	
	ЗаполняемыеНастройки = Новый Структура("Показатели, Группировка, Отбор", Ложь, Истина, Ложь);
	Если ПараметрыРасшифровки.ОткрытьЗначение Тогда
		ПоказатьЗначение(, ПараметрыРасшифровки.Значение);
	Иначе
		СписокПунктовМеню = ПараметрыРасшифровки.СписокПунктовМеню;
		Если СписокПунктовМеню.Количество() = 1 Тогда
			ИмяФормы = ПолучитьИмяФормыПоИДРасшифровки(СписокПунктовМеню[0].Значение);
			ПараметрыФормы = Новый Структура("ВидРасшифровки, АдресНастроек, СформироватьПриОткрытии, ИДРасшифровки, ЗаполняемыеНастройки",
			                                 1, ФормаОтчета.ДанныеРасшифровки, Истина, СписокПунктовМеню[0].Значение, ЗаполняемыеНастройки);
			ОткрытьФорму(ИмяФормы, ПараметрыФормы,, Истина);
		ИначеЕсли СписокПунктовМеню.Количество() > 0 Тогда
			ВыбранноеДействие = ФормаОтчета.ВыбратьИзМеню(СписокПунктовМеню, Элемент);
			Если ВыбранноеДействие <> Неопределено Тогда
				Если ТипЗнч(ВыбранноеДействие.Значение) = Тип("Строка") Тогда
					ИмяФормы = ПолучитьИмяФормыПоИДРасшифровки(ВыбранноеДействие.Значение);
					ПараметрыФормы = Новый Структура("ВидРасшифровки, АдресНастроек, СформироватьПриОткрытии, ИДРасшифровки, ЗаполняемыеНастройки",
			                                 1, ФормаОтчета.ДанныеРасшифровки, Истина, ВыбранноеДействие.Значение, ЗаполняемыеНастройки);
					ОткрытьФорму(ИмяФормы, ПараметрыФормы,, Истина);
				Иначе
					ПоказатьЗначение(, ВыбранноеДействие.Значение);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьИмяФормыПоИДРасшифровки(ИДРасшифровки)
	
	ИмяОбъекта = ИДРасшифровки;
	ШаблонИмениФормы = "Отчет.%ИмяОбъекта%.Форма.ФормаОтчета";
	
	Если ИДРасшифровки = "ОборотыСчетаПоДням" 
		Или ИДРасшифровки = "ОборотыСчетаПоМесяцам" Тогда
		ИмяОбъекта = "ОборотыСчета";
	КонецЕсли;
	
	Возврат СтрЗаменить(ШаблонИмениФормы, "%ИмяОбъекта%", ИмяОбъекта);
	
КонецФункции


////////////////////////////////////////////////////////////////////////////////
// ФУНКЦИИ И ПРОЦЕДУРЫ ОБЕСПЕЧЕНИЯ ВЫБОРА ПЕРИОДА

Функция ВыбратьПериодОтчета(Форма, Элемент, СтандартнаяОбработка, НачалоПериода)
	
	Список = СтандартныеОтчетыКлиентСервер.ПолучитьСписокПериодов(НачалоПериода, Форма.ВидПериода, Форма);
	Если Список.Количество() = 0 Тогда
		СтандартнаяОбработка = Ложь;
		Возврат Неопределено;
	КонецЕсли;
	
	ЭлементСписка = Список.НайтиПоЗначению(НачалоПериода);
	ВыбранныйПериод = Форма.ВыбратьИзСписка(Список, Элемент, ЭлементСписка);
	
	Если ВыбранныйПериод = Неопределено тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Индекс = Список.Индекс(ВыбранныйПериод);
	Если Индекс = 0 ИЛИ Индекс = Список.Количество() - 1 тогда
		ВыбранныйПериод = ВыбратьПериодОтчета(Форма, Элемент, СтандартнаяОбработка, ВыбранныйПериод.Значение);
	КонецЕсли;
	
	Возврат ВыбранныйПериод;
	
КонецФункции

// Процедура для обработки события при изменении периода 
//
// Параметры:
//  Элемент - элемент формы, из которого вызвана процедура
//  Период - значение периода
//  НачалоПериода - начало периода
//  КонецПериода - конец периода
//
// Возвращаемые значения:
//  если период е выбран, то начало и конец периода равны Неопределено
//
Процедура ПериодПриИзменении(Форма, НачалоПериода, КонецПериода, Элемент) Экспорт
	
	Если ПустаяСтрока(Форма.Период) Тогда
		НачалоПериода = Неопределено;
		КонецПериода  = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

// Процедура для обработки события выбора периода 
//
// Параметры:
//  Элемент - элемент формы, из которого вызвана процедура
//  ВыбранноеЗначение - выбранное в элементе значение
//  СтандартнаяОбработка - флаг использования стандартной обработки
//  ВидПериода - вид периода
//  Период - периода
//  НачалоПериода - начало периода
//  КонецПериода - конец периода
//
// Возвращаемые значения:
//  получает начало и конец периода, а так же представление периода
//
Процедура ПериодОбработкаВыбора(Форма, НачалоПериода, КонецПериода, Элемент, ВыбранноеЗначение, СтандартнаяОбработка) Экспорт
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Дата") Тогда
		НачалоПериода = СтандартныеОтчетыКлиентСервер.НачалоПериодаОтчета(Форма.ВидПериода, ВыбранноеЗначение, Форма);
		КонецПериода  = СтандартныеОтчетыКлиентСервер.КонецПериодаОтчета(Форма.ВидПериода, ВыбранноеЗначение, Форма);
		
		ВыбранноеЗначение = СтандартныеОтчетыКлиентСервер.ПолучитьПредставлениеПериодаОтчета(Форма.ВидПериода, 
			НачалоПериода, КонецПериода, Форма);
			
		Форма.Период = ВыбранноеЗначение;
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Процедура для обработки автоподбора при вводе периода 
//
// Параметры:
//  Элемент - элемент формы, из которого вызвана процедура
//  Текст - вводимый текст
//  ДанныеВыбора - даные для выбора
//  Ожидание - время ожидания
//  СтандартнаяОбработка - флаг использования стандартной обработки
//  ВидПериода - вид периода
//  Период - периода
//  НачалоПериода - начало периода
//  КонецПериода - конец периода
//
// Возвращаемые значения:
//  вызывает процедуру по подбору данных выбора, которая получает начало и конец периода, а так же представление периода
//
Процедура ПериодАвтоПодбор(Форма, НачалоПериода, КонецПериода, Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка) Экспорт
	
	ДанныеВыбора = СтандартныеОтчетыКлиентСервер.ПодобратьПериодОтчета(Форма.ВидПериода, Текст, 
		НачалоПериода, КонецПериода, Форма);
		
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

// Процедура для обработки события окончания ввода текста при вводе периода 
//
// Параметры:
//  Элемент - элемент формы, из которого вызвана процедура
//  Текст - введенный текст
//  ДанныеВыбора - даные для выбора
//  СтандартнаяОбработка - флаг использования стандартной обработки
//  ВидПериода - вид периода
//  Период - периода
//  НачалоПериода - начало периода
//  КонецПериода - конец периода
//
// Возвращаемые значения:
//  вызывает процедуру по подбору периода отчета, которая на основании введенного текста 
//  получает начало и конец периода, а так же представление периода
//
Процедура ПериодОкончаниеВводаТекста(Форма, НачалоПериода, КонецПериода, Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка) Экспорт
	
	Если ПустаяСтрока(Текст) Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеВыбора = СтандартныеОтчетыКлиентСервер.ПодобратьПериодОтчета(Форма.ВидПериода, Текст, 
		НачалоПериода, КонецПериода, Форма);
		
	СтандартнаяОбработка = Ложь;	
	
КонецПроцедуры
