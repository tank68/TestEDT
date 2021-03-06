
#Область СОБЫТИЯ_ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КонтрольИзмененияВЗакрытомПериоде = Истина;
	ТаблицаЛицевыхСчетов.Очистить();
	Если Параметры.Свойство("МассивЛицевыхСчетов") Тогда 
		Для Каждого ТекЛицевойСчет Из Параметры.МассивЛицевыхСчетов Цикл
			СтрокаТаблицы = ТаблицаЛицевыхСчетов.Добавить();
			СтрокаТаблицы.Обновлять = Истина;
			СтрокаТаблицы.ЛицевойСчет = ТекЛицевойСчет;
			СтрокаТаблицы.Портфель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТекЛицевойСчет, "Портфель");
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область КОМАНДЫ

&НаКлиенте
Процедура ОбновитьНомера(Команда)
	
	
	Если КонтрольИзмененияВЗакрытомПериоде Тогда 
		МассивПортфелей = МассивПортфелей();
		ОбщегоНазначенияБПВызовСервера.УдалитьПовторяющиесяЭлементыМассива(МассивПортфелей);
		
		ИнициализироватьИндикаторВыполнения(МассивПортфелей.Количество(), "Анализ использования лицевых счетов в закрытом периоде");
		Для Каждого ТекПортфель Из МассивПортфелей Цикл			
			ОбработатьТаблицуЛС_НаИспользованиеВЗакрытомПериоде(ТекПортфель);
			ОбработатьСобытиеВыполнения();
		КонецЦикла;
		
		Элементы.ИндикаторВыполнения.Видимость = Ложь;
	КонецЕсли;
	
	ИнициализироватьИндикаторВыполнения(ТаблицаЛицевыхСчетов.Количество(), "Обновление кодов в лицевых счетах");
	Для Каждого СтрокаТекущийЛицевойСчет Из ТаблицаЛицевыхСчетов Цикл 
		
		Если СтрокаТекущийЛицевойСчет.Обновлять Тогда 
			ОбновитьНомерЛицевогоСчета_Сервер(СтрокаТекущийЛицевойСчет.ЛицевойСчет);
		КонецЕсли;
		ОбработатьСобытиеВыполнения();
		
	КонецЦикла;
	Элементы.ИндикаторВыполнения.Видимость = Ложь;
	
	Элементы.КонтрольИзмененияВЗакрытомПериоде.Видимость = Ложь;
	Элементы.ФормаОбновитьНомера.Доступность = Ложь;
	
	Если ЕстьЛСВЗакрытомПериоде Тогда 
		КоличествоНеобновленныхЛС = КоличествоНеобновленныхЛС();
		Элементы.Декорация1.Заголовок = "Номера следующих лицевых счетов не обновлены, поскольку по ним есть движения в закрытом периоде";
		Элементы.Декорация1.Видимость = Истина;
		Элементы.Группа1.Видимость = Истина;
		
		МассивНеобновленныхСчетов = МассивНеобновленныхСчетов();
		Для Каждого ЛицевойСчет Из МассивНеобновленныхСчетов Цикл
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Строка(ЛицевойСчет), ЛицевойСчет);
		КонецЦикла;	
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Обновление кодов лицевых счетов завершено");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьНомераВЗакрытомПериоде(Команда)
	
	МассивНеобновленныхСчетов = МассивНеобновленныхСчетов();
	ИнициализироватьИндикаторВыполнения(МассивНеобновленныхСчетов.Количество(), "Обновление кодов в лицевых счетах");
	Для Каждого ЛицевойСчет Из МассивНеобновленныхСчетов Цикл 
		ОбновитьНомерЛицевогоСчета_Сервер(ЛицевойСчет);
		ОбработатьСобытиеВыполнения();
	КонецЦикла;
	Элементы.ИндикаторВыполнения.Видимость = Ложь;
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Обновление кодов лицевых счетов завершено");
	
КонецПроцедуры

#КонецОбласти


#Область ВСПОМОГАТЕЛЬНЫЕ_ПРОЦЕДУРЫ_ФУНКЦИИ

&НаСервере
Процедура ОбновитьНомерЛицевогоСчета_Сервер(ЛицевойСчет)
	
	Справочники.уа_ЛицевыеСчетаЕПС.ОбновитьКодНаименование(ЛицевойСчет);	
	
КонецПроцедуры

&НаКлиенте
Процедура ИнициализироватьИндикаторВыполнения(КоличествоОбъектов, Заголовок)
	
	Элементы.ИндикаторВыполнения.Видимость = Истина;
	Элементы.ИндикаторВыполнения.МаксимальноеЗначение = КоличествоОбъектов;
	Элементы.ИндикаторВыполнения.Заголовок = Заголовок;
	ИндикаторВыполнения = 0;
	Элементы.ИндикаторВыполнения.ЦветРамки = Новый Цвет(0, 174, 0); // Зеленый
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьСобытиеВыполнения()
	ИндикаторВыполнения = ИндикаторВыполнения + 1;
	ОбновитьОтображениеДанных();
КонецПроцедуры

&НаСервере
Процедура ОбработатьТаблицуЛС_НаИспользованиеВЗакрытомПериоде(ПортфельЛС)
	
	ДатаЗакрытияПортфеля = ДатаЗакрытияПортфеля(ПортфельЛС);
	Если Не ЗначениеЗаполнено(ДатаЗакрытияПортфеля) Тогда
		Возврат;	
	КонецЕсли;
	
	НайденныеСтрокиПоПортфелю = ТаблицаЛицевыхСчетов.НайтиСтроки(Новый Структура("Портфель", ПортфельЛС));
	СписокЛС = ТаблицаЛицевыхСчетов.Выгрузить(НайденныеСтрокиПоПортфелю, "ЛицевойСчет");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЕПС.ЛицевойСчетДт КАК ЛицевойСчет
		|ПОМЕСТИТЬ ВремТабОборотов
		|ИЗ
		|	РегистрБухгалтерии.ЕПС КАК ЕПС
		|ГДЕ
		|	ЕПС.Период <= &ДатаЗакрытия
		|	И ЕПС.ЛицевойСчетДт В(&СписокЛС)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЕПС.ЛицевойСчетКт
		|ИЗ
		|	РегистрБухгалтерии.ЕПС КАК ЕПС
		|ГДЕ
		|	ЕПС.Период <= &ДатаЗакрытия
		|	И ЕПС.ЛицевойСчетКт В(&СписокЛС)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВремТабОборотов.ЛицевойСчет
		|ИЗ
		|	ВремТабОборотов КАК ВремТабОборотов
		|
		|СГРУППИРОВАТЬ ПО
		|	ВремТабОборотов.ЛицевойСчет";
	
	Запрос.УстановитьПараметр("ДатаЗакрытия", ДатаЗакрытияПортфеля);
	Запрос.УстановитьПараметр("СписокЛС", СписокЛС);
	
	ОбщегоНазначенияДУ.ДобавитьВЛогОтладки(Запрос, "ИспользуемыеЛицевыеСчетаВЗакрытомПериоде() по Портфелю " + ПортфельЛС);	
	
	МассивЛС_ВЗакрытомПериоде = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ЛицевойСчет");
	Для Каждого СтрокаПоПортфелю Из НайденныеСтрокиПоПортфелю Цикл
		Если МассивЛС_ВЗакрытомПериоде.Найти(СтрокаПоПортфелю.ЛицевойСчет) <> Неопределено Тогда 
			СтрокаПоПортфелю.Обновлять = Ложь;
			ЕстьЛСВЗакрытомПериоде = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ДатаЗакрытияПортфеля(ПортфельЛС)
	
	ДатаЗакрытияПортфеля = '00010101';	
	
	//Запрос = Новый Запрос;
	//Запрос.Текст = 
	//	"ВЫБРАТЬ
	//	|	ДатыЗапретаИзменения.ДатаЗапрета КАК ДатаЗапрета
	//	|ИЗ
	//	|	РегистрСведений.ДатыЗапретаИзменения КАК ДатыЗапретаИзменения
	//	|ГДЕ
	//	|	ДатыЗапретаИзменения.Объект = &Объект
	//	|	И ДатыЗапретаИзменения.Раздел = &Раздел";
	//
	//Запрос.УстановитьПараметр("Раздел", ПланыВидовХарактеристик.РазделыДатЗапретаИзменения.Портфель);
	//Запрос.УстановитьПараметр("Объект", ПортфельЛС);

	//ОбщегоНазначенияДУ.ДобавитьВЛогОтладки(Запрос, "ДатаЗакрытияПортфеля "+ ПортфельЛС);
	//
	//Выборка = Запрос.Выполнить().Выбрать();
	//Если Выборка.Следующий() Тогда 
	//	ДатаЗакрытияПортфеля =  Выборка.ДатаЗапрета;	
	//Иначе
	//	Запрос.УстановитьПараметр("Раздел", ПланыВидовХарактеристик.РазделыДатЗапретаИзменения.ПустаяСсылка());
	//	Запрос.УстановитьПараметр("Объект", ПланыВидовХарактеристик.РазделыДатЗапретаИзменения.ПустаяСсылка());
	//	
	//	ОбщегоНазначенияДУ.ДобавитьВЛогОтладки(Запрос, "ДатаЗакрытияПортфеля по пустому портфелю для "+ ПортфельЛС);
	//	Выборка = Запрос.Выполнить().Выбрать();
	//    Если Выборка.Следующий() Тогда
	//		ДатаЗакрытияПортфеля =  Выборка.ДатаЗапрета;
	//	КонецЕсли;
	//КонецЕсли;
	
	Возврат ДатаЗакрытияПортфеля;
	
КонецФункции

&НаСервере
Функция МассивПортфелей()	
	Возврат ТаблицаЛицевыхСчетов.Выгрузить().ВыгрузитьКолонку("Портфель");
КонецФункции

&НаСервере
Функция МассивНеобновленныхСчетов()	
	НеобновленныеСтроки = ТаблицаЛицевыхСчетов.НайтиСтроки(Новый Структура("Обновлять", Ложь));
	Возврат ТаблицаЛицевыхСчетов.Выгрузить(НеобновленныеСтроки).ВыгрузитьКолонку("ЛицевойСчет");
КонецФункции

&НаСервере
Функция КоличествоНеобновленныхЛС()	
	НеобновленныеСтроки = ТаблицаЛицевыхСчетов.НайтиСтроки(Новый Структура("Обновлять", Ложь));
	Возврат ТаблицаЛицевыхСчетов.Выгрузить(НеобновленныеСтроки).Количество();
КонецФункции

#КонецОбласти

