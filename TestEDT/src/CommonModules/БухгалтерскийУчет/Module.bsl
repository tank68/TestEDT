////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ РАБОТЫ  СО СЧЕТАМИ И СУБКОНТО

// Процедура устанавливает субконто на счете. Если такое субконто на счете
// отсутствует, то ничего не делается.
//
// Параметры:
//		Счет - Счет, к которому относится субконто
//      Субконто - набор субконто
//		Номер или имя устанавливаемого субконто
//      Значение субконто - значение устанавливаемого субконто
//      ПовтИсп - необходимо для ЮТ, нужно получать не кэшированные значения свойств счета
//
Процедура УстановитьСубконто(Счет, Субконто, ИмяСубконто, ЗначениеСубконто, ПовтИсп = Истина) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ИмяСубконто) Тогда
		Возврат;
	КонецЕсли;
	
	Если ПовтИсп Тогда
		СвойстваСчета = БухгалтерскийУчетПовтИсп.ПолучитьСвойстваСчета(Счет);
	Иначе	
		СвойстваСчета = ПланыСчетов.Хозрасчетный.СвойстваСчета(Счет)
	КонецЕсли;
	
	Если ТипЗнч(ИмяСубконто) = Тип("ПланВидовХарактеристикСсылка.ВидыСубконтоХозрасчетные") Тогда
		
		ВидСубконто = ИмяСубконто;
		
		Если СвойстваСчета.ВидСубконто1 <> ВидСубконто
			И СвойстваСчета.ВидСубконто2 <> ВидСубконто
			И СвойстваСчета.ВидСубконто3 <> ВидСубконто Тогда
			
			Возврат;
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ИмяСубконто) = Тип("Число") Тогда
		
		Если ИмяСубконто > СвойстваСчета.КоличествоСубконто Тогда
			Возврат;
		КонецЕсли;
		
		ВидСубконто = СвойстваСчета["ВидСубконто" + ИмяСубконто];
		
	Иначе
		
		ВидСубконто = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные[ИмяСубконто];
		
		Если СвойстваСчета.ВидСубконто1 <> ВидСубконто
			И СвойстваСчета.ВидСубконто2 <> ВидСубконто
			И СвойстваСчета.ВидСубконто3 <> ВидСубконто Тогда
			
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ВидСубконто.ТипЗначения.СодержитТип(ТипЗнч(ЗначениеСубконто)) Тогда
		
		Субконто.Вставить(ВидСубконто, ЗначениеСубконто);
		
	КонецЕсли;
	
КонецПроцедуры // УстановитьСубконто()

// Процедура устанавливает субконто на счете. Если такое субконто на счете
// отсутствует, то ничего не делается.
//
// Параметры:
//		Счет - Счет, к которому относится субконто
//      Субконто - набор субконто
//		Номер или имя устанавливаемого субконто
//      Значение субконто - значение устанавливаемого субконто
//
Процедура УстановитьСубконтоЕПС(Счет, Субконто, ИмяСубконто, ЗначениеСубконто) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ИмяСубконто) Тогда
		Возврат;
	КонецЕсли;
	
	СвойстваСчета = БухгалтерскийУчетПовтИсп.ПолучитьСвойстваСчетаЕПС(Счет);
	
	Если ТипЗнч(ИмяСубконто) = Тип("ПланВидовХарактеристикСсылка.ВидыСубконтоЕПС") Тогда
		
		ВидСубконто = ИмяСубконто;
		
		Если СвойстваСчета.ВидСубконто1 <> ВидСубконто
			И СвойстваСчета.ВидСубконто2 <> ВидСубконто
			И СвойстваСчета.ВидСубконто3 <> ВидСубконто Тогда
			
			Возврат;
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ИмяСубконто) = Тип("Число") Тогда
		
		Если ИмяСубконто > СвойстваСчета.КоличествоСубконто Тогда
			Возврат;
		КонецЕсли;
		
		ВидСубконто = СвойстваСчета["ВидСубконто" + ИмяСубконто];
		
	Иначе
		
		ВидСубконто = ПланыВидовХарактеристик.ВидыСубконтоЕПС[ИмяСубконто];
		
		Если СвойстваСчета.ВидСубконто1 <> ВидСубконто
			И СвойстваСчета.ВидСубконто2 <> ВидСубконто
			И СвойстваСчета.ВидСубконто3 <> ВидСубконто Тогда
			
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ВидСубконто.ТипЗначения.СодержитТип(ТипЗнч(ЗначениеСубконто)) Тогда
		
		Субконто.Вставить(ВидСубконто, ЗначениеСубконто);
		
	КонецЕсли;
	
КонецПроцедуры // УстановитьСубконто()

// Функция получает счета учета неденежных активов
//
// Параметры:
//  Отсутствуют
//
// Возвращаемое  значение:
//  МассивСчетов - массив, содержащий счета учета неденежных активов
//
Функция ПолучитьСчетаУчетаНеденежныхАктивов() Экспорт
	
	Возврат БухгалтерскийУчетПовтИсп.СчетаУчетаНеденежныхАктивов();
	
КонецФункции // ПолучитьСчетаУчетаНеденежныхАктивов()

// Функция получает счета учета всех активов
//
// Параметры:
//  Развернуть - признак добавления субсчетов в результирующий массив счетов
//
// Возвращаемое значение:
//  МассивСчетов - массив, содержащий счета учета неденежных активов
//
Функция ПолучитьСчетаУчетаВсехАктивов(Развернуть = Ложь) Экспорт
	
	Возврат БухгалтерскийУчетПовтИсп.СчетаУчетаНеденежныхАктивов();
	
КонецФункции // ПолучитьСчетаУчетаВсехАктивов()

// Функция получает список счетов переоценки 
//
// Параметры:
//  Отсутствуют
//
// Возвращаемое значение:
//  список, содержащий счета учета переоценки
//
Функция СписокСчетовПереоценки() Экспорт
	
	Возврат БухгалтерскийУчетПовтИсп.СписокСчетовПереоценки();
	
КонецФункции

// Функция получает список счетов учета купонного дохода 
//
// Параметры:
//  Отсутствуют
//
// Возвращаемое значение:
//  список, содержащий счета учета купонного дохода
//
Функция СписокСчетовУчетаКупонногоДохода() Экспорт
	
	Возврат БухгалтерскийУчетПовтИсп.СписокСчетовУчетаКупонногоДохода();
	
КонецФункции

// Функция получает список субсчетов затрат на приобретение активов 
//
// Параметры:
//  Отсутствуют
//
// Возвращаемое значение:
//  список, содержащий счета учета доп.затрат активов
//
Функция СписокСчетовДополнительныхЗатрат() Экспорт
	
	Возврат БухгалтерскийУчетПовтИсп.СписокСчетовДополнительныхЗатрат();
	
КонецФункции

// Функция получает счета учета актива
//
// Входные параметры:
//  Портфель - Портфель, по которому определяются счета  учета
//  ВидАктива - вид актива, по которому определяются счета учета
//  Счет - счет актива
//  Актив - актив, для которого определяются счета учета
//
// Возвращаемое значение:
//  СтруктураВозврата - структура, содержащая Портфель, ВидАктива, Счет, Актив
//
Функция ПолучитьСчетаАктива(Портфель = Неопределено ,Знач ВидАктива = Неопределено, Счет = Неопределено, Актив = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	
	Ресурсы = "";
	
	СтруктураВозврата = "";
	Для Каждого ТекРесурс из Метаданные.РегистрыСведений.СчетаУчетаАктивов.Ресурсы Цикл
		СтруктураВозврата = СтруктураВозврата + ", " + ТекРесурс.Имя;	
		Ресурсы = Ресурсы + ", " + "ТаблицаСоответствия." + ТекРесурс.Имя;
	конеццикла;
	
	
	Ресурсы				 = СокрЛП(Сред(Ресурсы,1));
	СтруктураВозврата	 = СокрЛП(Сред(СтруктураВозврата,2));
	СтруктураВозврата	 = Новый Структура(СтруктураВозврата);
	
	//МассивПортфелей		= Новый Массив;
	//МассивВидовАктивов	= Новый Массив;
	//МассивСчетов		= Новый Массив;
	//МассивАктивов		= Новый Массив;
	//
	//МассивПортфелей.Добавить(Справочники.ДУ_Портфели.ПустаяСсылка());
	//МассивВидовАктивов.Добавить(ПланыВидовХарактеристик.ВидыАктивов.ПустаяСсылка());
	//МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.ФинансовыеВложения);
	//МассивАктивов.Добавить(Справочники.Активы.ПустаяСсылка());
	//
	//Если Портфель <> Неопределено тогда
	//	МассивПортфелей.Добавить(Портфель);
	//конецесли;
	//
	//
	//Если Счет <> Неопределено тогда
	//	МассивСчетов.Добавить(Счет);
	//КонецЕсли;
	//
	//Если ЗначениеЗаполнено(Актив) тогда
	//	
	//	Если НЕ ЗначениеЗаполнено(ВидАктива) тогда
	//		ВидАктива = Актив.ВидАктива;
	//	КонецЕсли;
	//	
	//	МассивАктивов.Добавить(Актив);
	//	
	//	СписокГрупп = Новый("СписокЗначений");
	//	УправлениеВзаиморасчетами.ПолучитьСписокВышестоящихГрупп(СписокГрупп, Актив);
	//	Для каждого Элемент Из СписокГрупп Цикл
	//		МассивАктивов.Добавить(Элемент.Значение);
	//	КонецЦикла;
	//	
	//КонецЕсли;
	//
	//Если ЗначениеЗаполнено(ВидАктива) тогда
	//	
	//	МассивВидовАктивов.Добавить(ВидАктива);
	//	
	//	СписокГрупп = Новый("СписокЗначений");
	//	УправлениеВзаиморасчетами.ПолучитьСписокВышестоящихГрупп(СписокГрупп, ВидАктива);
	//	Для Каждого Элемент Из СписокГрупп Цикл
	//		МассивВидовАктивов.Добавить(Элемент.Значение);
	//	КонецЦикла;
	//	
	//КонецЕсли;
	//
	//
	//Запрос.УстановитьПараметр("МассивПортфелей"	, МассивПортфелей);
	//Запрос.УстановитьПараметр("МассивВидовАктивов"	, МассивВидовАктивов);
	//Запрос.УстановитьПараметр("МассивСчетов"		, МассивСчетов);
	//Запрос.УстановитьПараметр("МассивАктивов"		, МассивАктивов);
	//
	//Запрос.Текст = "ВЫБРАТЬ
	//|	ТаблицаСоответствия.Портфель КАК Портфель,
	//|	ТаблицаСоответствия.ВидАктива КАК ВидАктива,
	//|	ТаблицаСоответствия.Счет КАК Счет,
	//|	ТаблицаСоответствия.ТранзитныйСчет КАК ТранизитныйСчет,
	//|	ТаблицаСоответствия.СчетВнеоборотногоАктива КАК СчетВнеоборотногоАктива,
	//|	ТаблицаСоответствия.Актив КАК Актив " + Ресурсы + "
	//|ИЗ
	//|	РегистрСведений.СчетаУчетаАктивов КАК ТаблицаСоответствия
	//|ГДЕ
	//|	ТаблицаСоответствия.Портфель В(&МассивПортфелей)
	//|	И ТаблицаСоответствия.ВидАктива В (&МассивВидовАктивов)
	//|	И ТаблицаСоответствия.Актив В(&МассивАктивов)"+ ?(Счет <> Неопределено," И ТаблицаСоответствия.Счет В(&МассивСчетов)","");
	//
	//Результат = Запрос.Выполнить();
	//
	//ТаблицаЗапроса = Результат.Выгрузить();
	//ТаблицаЗапроса.Колонки.Добавить("Глубина");
	//ТаблицаЗапроса.Колонки.Добавить("ГлубинаВидаАктива");
	//
	//Для Каждого Строка Из ТаблицаЗапроса Цикл
	//	
	//	Если Строка.Актив = Справочники.Активы.ПустаяСсылка() Тогда
	//		Строка.Глубина = 0;
	//	Иначе
	//		Строка.Глубина = Строка.Актив.Уровень() + 1;
	//	КонецЕсли;
	//	
	//	Если Строка.ВидАктива = ПланыВидовХарактеристик.ВидыАктивов.ПустаяСсылка() Тогда
	//		Строка.ГлубинаВидаАктива = 0;
	//	Иначе
	//		Строка.ГлубинаВидаАктива = Строка.ВидАктива.Уровень() + 1;
	//	КонецЕсли;
	//	
	//КонецЦикла;
	//
	//ТаблицаЗапроса.Сортировать("Глубина Убыв, ГлубинаВидаАктива Убыв, Актив Убыв " + ?(Счет <> Неопределено,", Счет Убыв","") + ", ВидАктива Убыв, Портфель Убыв"); 
	//
	//Если ТаблицаЗапроса.Количество() > 0 Тогда
	//	
	//	ЗаполнитьЗначенияСвойств(СтруктураВозврата,ТаблицаЗапроса[0]);
	//	
	//КонецЕсли;
	
	Возврат СтруктураВозврата;
	
КонецФункции // ПолучитьСчетаАктива()

// Процедура выполняет запись счетов учета активов в регистр сведений
//
// Параметры:
//		Портфель - договор Доверительного управления
//      ВидАктива - вид актива
//		Актив - ценная бумага
//      СтруктураСчетов - структура счетов учета актива
//
Процедура ЗаписатьСчетУчетаАктивов(Портфель, ВидАктива, Актив, СтруктураСчетов) Экспорт
	
	//РегистрироватьСчетаУчета = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(ПланыВидовХарактеристик.НастройкиПользователей.РегистрироватьСчетаУчета);
	
	//Если Не РегистрироватьСчетаУчета Тогда
	//	Возврат;
	//КонецЕсли;	
	
	НаборЗаписей = РегистрыСведений.СчетаУчетаАктивов.СоздатьНаборЗаписей();
	
	НаборЗаписей.Отбор.Портфель.Установить(Портфель);
	НаборЗаписей.Отбор.ВидАктива.Установить(ВидАктива);
	НаборЗаписей.Отбор.Актив.Установить(Актив);
	
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() = 0 Тогда
		ЗаписьНабора = НаборЗаписей.Добавить();
		
		ЗаписьНабора.Портфель = Портфель;
		ЗаписьНабора.ВидАктива = ВидАктива;
		ЗаписьНабора.Актив = Актив;
		
	Иначе
		ЗаписьНабора = НаборЗаписей[0];
	КонецЕсли;
	
	Если СтруктураСчетов.Свойство("СчетУчета") Тогда
		ЗаписьНабора.СчетУчета = СтруктураСчетов.СчетУчета;
	КонецЕсли;
	
	Если СтруктураСчетов.Свойство("СчетВнеоборотногоАктива") Тогда
		ЗаписьНабора.СчетВнеоборотногоАктива = СтруктураСчетов.СчетВнеоборотногоАктива;
	КонецЕсли;			
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Процедура снимает/устанавливает активность проводок документа (бух. учет).
//
// Параметры:
//		Документ - переданный документ
//
Процедура ПереключитьАктивностьПроводокБУ(Документ) Экспорт
	
	Если Документ.ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;
	
	ПроводкиДокумента = РегистрыБухгалтерии.Хозрасчетный.СоздатьНаборЗаписей();
	ПроводкиДокумента.Отбор.Регистратор.Установить(Документ);
	ПроводкиДокумента.Прочитать();
	
	КоличествоПроводок = ПроводкиДокумента.Количество();
	Если НЕ (КоличествоПроводок = 0) Тогда
		
		// Определяем текущую активность проводок по первой проводке
		ТекущаяАктивностьПроводок = ПроводкиДокумента[0].Активность;
		
		// Инвертируем текущую активность проводок
		ПроводкиДокумента.УстановитьАктивность(НЕ ТекущаяАктивностьПроводок);
		ПроводкиДокумента.Записать();
		
	КонецЕсли;
	
КонецПроцедуры // ПереключитьАктивностьПроводокБУ()

Функция ПолучитьМаксКоличествоСубконто() Экспорт
	
	Возврат Метаданные.ПланыСчетов.Хозрасчетный.МаксКоличествоСубконто;
	
КонецФункции

Функция ПолучитьМаксКоличествоСубконтоЕПС() Экспорт
	
	Возврат Метаданные.ПланыСчетов.ЕПС.МаксКоличествоСубконто;
	
КонецФункции

// Функция возвращает ИСТИНА, если документ считается проведенным.
//
Функция ДокументПроведен(ДокументСсылка) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ДокументСсылка) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.уа_ОперацияБух") Тогда
		
		РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылка, "ПометкаУдаления");
		Возврат НЕ РеквизитыДокумента.ПометкаУдаления;
		
	Иначе
		
		РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылка, "Проведен");
		Возврат РеквизитыДокумента.Проведен;
		
	КонецЕсли;	
	
КонецФункции // ДокументПроведен()

// Функция возвращает счет учета по виду счета и признакам счета.
//
// Параметры:
// ВидСчета 	- ПеречислениеСсылка.ВидБанковскогоСчета
// Валютный 	- тип: Булево - признак валютного счета
// Транзитный 	- тип: Булево - признак банковского счета "Транзитный"
//
// Возвращаемое значение:
//	СчетУчета - ПланСчетовСсылка.Хозрасчетный
//
Функция ПолучитьСчетУчетаПоПризнакамСчета(ВидСчета, Валютный = Ложь, Транзитный = Ложь) Экспорт
	
	//51
	СчетУчета = ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.РасчетныеСчета");
	
	Если ВидСчета = ПредопределенноеЗначение("Перечисление.ВидБанковскогоСчета.Депозитный") Тогда 
		Если НЕ Валютный Тогда 
			//55.01
			СчетУчета = ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.ДепозитныеСчетаВРублях");
		Иначе 
			//55.02
			СчетУчета = ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.ДепозитныеСчетаВВалюте");
		КонецЕсли;
	ИначеЕсли ВидСчета = ПредопределенноеЗначение("Перечисление.ВидБанковскогоСчета.Биржевой") Тогда 
		//55.04.1
		СчетУчета = ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.РасчетыСБиржейПоОперациямНаФондовомРынке");
	ИначеЕсли Транзитный Тогда
		//52.01
		СчетУчета = ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.ТранзитныеСчета");
	ИначеЕсли Валютный Тогда
		//52.02
		СчетУчета = ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.ТекущиеСчета");
	КонецЕсли; 
	
	Возврат СчетУчета
	
КонецФункции // ()


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ РАБОТЫ С ФОРМАМИ ДОКУМЕНТОВ ПО ДВИЖЕНИЮ ДЕНЕЖНЫХ СРЕДСТВ

// Функция получает массив счетов учета денежных средств
//
// Параметры:
//  МассивСчетовОтбора - массив счетов отбора
//  ОтборПоПризнакуВалютный - флаг отбора по валютным счетам
//  СчетОтбораПоПризнакуВалютный - включает счета отбора по признаку Валютный
//  МассивСчетовИсключений - массив счетов исключений из итогового результата
//
// Возвращаемое значение:
//  МассивСчетов - массив, содержащий счета учета денежных активов
//
Функция ПолучитьМассивСчетовДенежныхСредств(МассивСчетовОтбора, ОтборПоПризнакуВалютный = Ложь, СчетОтбораПоПризнакуВалютный = Неопределено, МассивСчетовИсключений = Неопределено) Экспорт
	
	МассивСчетов = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивСчетовОтбора"    , МассивСчетовОтбора);
	Запрос.УстановитьПараметр("МассивСчетовИсключений", МассивСчетовИсключений);
	
	Запрос.УстановитьПараметр("ОтбиратьПоПризнакуВалютный", ОтборПоПризнакуВалютный);
	
	Если ТипЗнч(СчетОтбораПоПризнакуВалютный) = Тип("ПланСчетовСсылка.Хозрасчетный") Тогда
		Запрос.УстановитьПараметр("Валютный", СчетОтбораПоПризнакуВалютный.Валютный);
	Иначе
		Запрос.УстановитьПараметр("Валютный", Ложь);
	КонецЕсли;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Хозрасчетный.Ссылка КАК Счет,
	|	Хозрасчетный.Код КАК Код,
	|	Хозрасчетный.Наименование КАК Наименование
	|ИЗ
	|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
	|ГДЕ
	|	Хозрасчетный.Ссылка В ИЕРАРХИИ (&МассивСчетовОтбора)
	|	И (НЕ Хозрасчетный.ЗапретитьИспользоватьВПроводках)
	|	И (НЕ &ОтбиратьПоПризнакуВалютный
	|			ИЛИ Хозрасчетный.Валютный = &Валютный)
	|   И Хозрасчетный.Ссылка Не В (&МассивСчетовИсключений)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Код";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		МассивСчетов.Добавить(Выборка.Счет);
	КонецЦикла;
	
	Возврат МассивСчетов;
	
КонецФункции

// Дополняет переданные счета их субсчетами. После первого вызова запоминает субсчета
// и при последующих вызовах не обращается к СУБД.
//
// Параметры:
//  МассивСчетов - Массив - список счетов, которые нужно дополнить субсчетами.
//
// Возвращаемое значение:
//   Массив      - список исходных счетов плюс их субсчета.
//
Функция СформироватьМассивСубсчетов(МассивСчетов) Экспорт
	
	МассивСубсчетов = Новый Массив;
	Для каждого СчетВерхнегоУровня Из МассивСчетов Цикл
		
		Субсчета = БухгалтерскийУчетВызовСервераПовтИсп.СчетаВИерархии(СчетВерхнегоУровня);
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивСубсчетов, Субсчета);
		
	КонецЦикла; 
	
	Возврат МассивСубсчетов;
	
КонецФункции // СформироватьМассивСубсчетов()

// Дополняет переданные счета их субсчетами. После первого вызова запоминает субсчета
// и при последующих вызовах не обращается к СУБД.
//
// Параметры:
//  МассивСчетов - Массив - список счетов, которые нужно дополнить субсчетами.
//
// Возвращаемое значение:
//   Массив      - список исходных счетов плюс их субсчета.
//
Функция СформироватьМассивСубсчетовЕПС(МассивСчетов) Экспорт
	
	МассивСубсчетов = Новый Массив;
	Для каждого СчетВерхнегоУровня Из МассивСчетов Цикл
		
		Субсчета = БухгалтерскийУчетВызовСервераПовтИсп.СчетаВИерархииЕПС(СчетВерхнегоУровня);
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивСубсчетов, Субсчета);
		
	КонецЦикла; 
	
	Возврат МассивСубсчетов;
	
КонецФункции 

////////////////////////////////////////////////////////////////////////////////
// ПРОЧИИ ПРОЦЕДУРЫ И ФУНКЦИИ 

// Возвращает коэффициент процентов налоговой суммы по РЕПО
// и при последующих вызовах не обращается к СУБД.
//
// Параметры:
//  Валюта - СправочникСсылка.Валюты - валюта в зависимости от которой будет получен коэффициент
//
// Возвращаемое значение:
//   Число      - коэффициент.
//
Функция КоэффициентНУРЕПО(Валюта) Экспорт
	
	Если Валюта = Справочники.Валюты.RUB Тогда
	    Возврат 1.8;
	Иначе
		Возврат 0.8;	
	КонецЕсли;
	
КонецФункции 
 

