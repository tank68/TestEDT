
#Область ПРОГРАММНЫЙ_ИНТЕРФЕЙС

Процедура ПриСозданииНаСервере(Форма) Экспорт

	Объект = Форма.Объект;
	МетаданныеОбъекта = Объект.Ссылка.Метаданные();
	ЕстьРеквизитЕПС = ОбщегоНазначения.ЕстьРеквизитОбъекта("ЕПС", МетаданныеОбъекта);
	Если ЕстьРеквизитЕПС Тогда
		ЕстьРеквизитФормыВестиУчетПоЕдиномуПлануСчетов = ЕстьРеквизитФормы(Форма, "ВестиУчетПоЕдиномуПлануСчетов");
		УстановитьПараметрФункциональнойОпцииПортфель(Форма, Объект, МетаданныеОбъекта);
		ВестиУчетЕПС = ВедетсяУчетЕПС(Форма);
		Если Объект.Ссылка.Пустая() Тогда
			Объект.ЕПС = ВестиУчетЕПС;		
		КонецЕсли; 
		Если ЕстьРеквизитФормыВестиУчетПоЕдиномуПлануСчетов Тогда
			Форма.ВестиУчетПоЕдиномуПлануСчетов = ВестиУчетЕПС;
		КонецЕсли; 	
	КонецЕсли; 

КонецПроцедуры

Процедура ПриИзмененииПортфеля(Форма) Экспорт

	Объект = Форма.Объект;
	МетаданныеОбъекта = Объект.Ссылка.Метаданные();
	ЕстьРеквизитЕПС = ОбщегоНазначения.ЕстьРеквизитОбъекта("ЕПС", МетаданныеОбъекта);
	Если ЕстьРеквизитЕПС Тогда
		ЕстьРеквизитФормыВестиУчетПоЕдиномуПлануСчетов = ЕстьРеквизитФормы(Форма, "ВестиУчетПоЕдиномуПлануСчетов");
		УстановитьПараметрФункциональнойОпцииПортфель(Форма, Объект, МетаданныеОбъекта);
		ВестиУчетЕПС = ВедетсяУчетЕПС(Форма);
		Объект.ЕПС = ВестиУчетЕПС;
		Если ЕстьРеквизитФормыВестиУчетПоЕдиномуПлануСчетов Тогда
			Форма.ВестиУчетПоЕдиномуПлануСчетов = ВестиУчетЕПС;
		КонецЕсли; 	
	КонецЕсли; 

КонецПроцедуры

Функция ПодсказкаДляСчетаЕПС(СчетЕПС) Экспорт 
	
	Если ЗначениеЗаполнено(СчетЕПС) Тогда
		СвойстваСчета = УчетЕПСПовтИсп.СвойстваСчета(СчетЕПС);
		Подсказка = СвойстваСчета.Описание;
	Иначе	
		Подсказка = "";
	КонецЕсли;	
	
	Возврат Подсказка;
	
КонецФункции // ПодсказкаДляСчетаЕПС()

Функция СписокДоступныхБанковскихСчетов(Портфель) Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.Текст = ПолучитьТекстЗапросаБанковскихСчетов();	
	
	Запрос.УстановитьПараметр("Портфель", Портфель);
	Запрос.УстановитьПараметр("УчетДСНаЕдиномРС", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Портфель, "УчетДСНаЕдиномРС"));
	
	ОбщегоНазначенияДУ.ДобавитьВЛогОтладки(Запрос, "СписокДоступныхБанковскихСчетов()");
	
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
	Возврат СписокЗначений;
	
КонецФункции

Функция СвойстваСчета(Счет) Экспорт
	Возврат УчетЕПСПовтИсп.СвойстваСчета(Счет);
КонецФункции

#КонецОбласти

#Область СЛУЖЕБНЫЕ_ПРОЦЕДУРЫ_И_ФУНКЦИИ

Функция ВедетсяУчетЕПС(Форма)

	Возврат ОбщегоНазначенияДУПовтИсп.ПолучитьЗначениеКонстанты("ВестиУчетЕПС") 
		И Форма.ПолучитьФункциональнуюОпциюФормы("ВестиУчетЕПС_ПоПортфелю");
			
КонецФункции

Процедура УстановитьПараметрФункциональнойОпцииПортфель(Форма, Объект, МетаданныеОбъекта)
	
	ЕстьРеквизитПортфель 	= ОбщегоНазначения.ЕстьРеквизитОбъекта("Портфель", МетаданныеОбъекта);
	ПараметрыФункциональнойОпции = Новый Структура();
	Если ЕстьРеквизитПортфель Тогда
		ПараметрыФункциональнойОпции.Вставить("Организация", Объект.Портфель);
	КонецЕсли; 
	Форма.УстановитьПараметрыФункциональныхОпцийФормы(ПараметрыФункциональнойОпции);
	
КонецПроцедуры
 
Функция ЕстьРеквизитФормы(Форма, ИмяРеквизита)
	
	ЕстьРеквизит = Ложь;
	РеквизитыФормы = Форма.ПолучитьРеквизиты();
	Для Каждого РеквизитФормы Из РеквизитыФормы Цикл
		Если РеквизитФормы.Имя = ИмяРеквизита Тогда
			ЕстьРеквизит = Истина;
			Прервать;
		КонецЕсли; 
	КонецЦикла; 
	Возврат ЕстьРеквизит;

КонецФункции

Функция ПолучитьТекстЗапросаБанковскихСчетов()
	
	ТекстЗапроса = "";
	Если Константы.НастраиватьОтборыЕдиныхСчетовПортфеля.Получить() Тогда
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	БанковскиеСчета.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.БанковскиеСчета КАК БанковскиеСчета
		|ГДЕ
		|	БанковскиеСчета.Портфель = &Портфель
		|	И БанковскиеСчета.ТипСчета = ЗНАЧЕНИЕ(Перечисление.ТипРасчетногоСчета.Индивидуальный)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	НастройкиОтборовЕдиныхСчетовПортфеля.Счет
		|ИЗ
		|	РегистрСведений.НастройкиОтборовЕдиныхСчетовПортфеля КАК НастройкиОтборовЕдиныхСчетовПортфеля
		|ГДЕ
		|	&УчетДСНаЕдиномРС <> ЗНАЧЕНИЕ(Перечисление.УчетДСНаЕдиномРС.Неразрешен)
		|	И НастройкиОтборовЕдиныхСчетовПортфеля.Портфель = &Портфель";
		
	Иначе      
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	БанковскиеСчета.Ссылка
		|ИЗ
		|	Справочник.БанковскиеСчета КАК БанковскиеСчета
		|ГДЕ
		|	БанковскиеСчета.Портфель = &Портфель
		|	И БанковскиеСчета.ТипСчета = ЗНАЧЕНИЕ(Перечисление.ТипРасчетногоСчета.Индивидуальный)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	БанковскиеСчета.Ссылка
		|ИЗ
		|	Справочник.БанковскиеСчета КАК БанковскиеСчета
		|ГДЕ
		|	БанковскиеСчета.Портфель = ЗНАЧЕНИЕ(Справочник.Портфели.ПустаяСсылка)
		|	И БанковскиеСчета.ТипСчета = ЗНАЧЕНИЕ(Перечисление.ТипРасчетногоСчета.Единый)
		|	И &УчетДСНаЕдиномРС <> ЗНАЧЕНИЕ(Перечисление.УчетДСНаЕдиномРС.Неразрешен)";
		
	КонецЕсли;
		
	Возврат ТекстЗапроса;
КонецФункции 

#КонецОбласти
