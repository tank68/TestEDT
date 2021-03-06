
#Область ЗаполнениеПроводок

// Процедура устанавливает субконто на счете. Если такое субконто на счете
// отсутствует, то ничего не делается.
//
// Параметры:
//		Счет - Счет, к которому относится субконто
//      Субконто - набор субконто
//		Номер или имя устанавливаемого субконто
//      Значение субконто - значение устанавливаемого субконто
//
Процедура УстановитьСубконто(Счет, Субконто, ИмяСубконто, ЗначениеСубконто) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ИмяСубконто) Тогда
		Возврат;
	КонецЕсли;
	
	СвойстваСчета = уа_БухгалтерскийУчетПовтИсп.СвойстваСчета(Счет);
	
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
	
КонецПроцедуры

// Заполняет количества проводки, учитывая признаки учета счетов
//
// Параметры:
//  Проводка - РегистрБухгалтерииЗапись.ЕПС - заполняемая проводка.
//  Количество - Число - количество Дт.
//  КоличествоКор - Число - количество Кт, 
//                  если не указано будет подставлено количество Дт.
//
Процедура ЗаполнитьКоличестваПроводки(Проводка, Количество, КоличествоКор = Неопределено) Экспорт
	
	Если Не Проводка.СчетДт.Пустая() Тогда
		СвойстваДт = уа_БухгалтерскийУчетПовтИсп.СвойстваСчета(Проводка.СчетДт);
		Если СвойстваДт.Количественный Тогда
			Проводка.КоличествоДт = Количество;
		КонецЕсли;
	КонецЕсли;
	
	Если Не Проводка.СчетКт.Пустая() Тогда
		СвойстваКт = уа_БухгалтерскийУчетПовтИсп.СвойстваСчета(Проводка.СчетКт);
		Если СвойстваКт.Количественный Тогда
			Проводка.КоличествоКт = ?(КоличествоКор = Неопределено, 
				Количество, КоличествоКор);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Заполняет налоговые суммы проводки, учитавая признаки учета счетов.
//
// Параметры:
//  Проводка - РегистрБухгалтерииЗапись.ЕПС - заполняемая проводка.
//  СуммаНУ - Число - сумма НУ Дт.
//  СуммаНУКор - Число - сумма НУ Кт, 
//               если не указано будет подставлено сумман НУ Дт.
Процедура ЗаполнитьНалоговыеСуммыПроводки(Проводка, СуммаНУ, СуммаНУКор = Неопределено) Экспорт
	
	Если Не Проводка.СчетДт.Пустая() Тогда
		СвойстваДт = уа_БухгалтерскийУчетПовтИсп.СвойстваСчета(Проводка.СчетДт);
		Если СвойстваДт.НалоговыйУчет И Не СвойстваДт.Забалансовый Тогда
			Проводка.СуммаНУДт = СуммаНУ;
		КонецЕсли;
	КонецЕсли;
	
	Если Не Проводка.СчетКт.Пустая() Тогда
		СвойстваКт = уа_БухгалтерскийУчетПовтИсп.СвойстваСчета(Проводка.СчетКт);
		Если СвойстваКт.НалоговыйУчет И Не СвойстваКт.Забалансовый Тогда
			Проводка.СуммаНУКт = ?(СуммаНУКор = Неопределено, СуммаНУ, СуммаНУКор);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Заполняет валюту и валютную сумму проводки, учитавая признаки учета счетов.
//
// Параметры:
//  Проводка - РегистрБухгалтерииЗапись.ЕПС - заполняемая проводка.
//  Валюта - СправочникСсылка.Валюты - валюта Дт.
//  СуммаВал - Число - валютная сумма Дт.
//  ВалютаКор - СправочникСсылка.Валюты - валюта Кт,
//              если не указано будет подставлено валюта Дт.
//  СуммаВалКор - Число - валютная сумма Кт, 
//                если не указано будет подставлено валютная сумма Дт.
//
Процедура ЗаполнитьВалютыИСуммыВалПроводки(Проводка, Валюта, СуммаВал, 
	ВалютаКор = Неопределено, СуммаВалКор = Неопределено) Экспорт
	
	Если Не Проводка.СчетДт.Пустая() Тогда
		СвойстваДт = уа_БухгалтерскийУчетПовтИсп.СвойстваСчета(Проводка.СчетДт);
		Если СвойстваДт.Валютный Тогда
			Проводка.ВалютаДт = Валюта;
			Проводка.ВалютнаяСуммаДт = СуммаВал;
		КонецЕсли;
	КонецЕсли;
	
	Если Не Проводка.СчетКт.Пустая() Тогда
		СвойстваКт = уа_БухгалтерскийУчетПовтИсп.СвойстваСчета(Проводка.СчетКт);
		Если СвойстваКт.Валютный Тогда
			Проводка.ВалютаКт = ?(ВалютаКор = Неопределено, Валюта, ВалютаКор);
			Проводка.ВалютнаяСуммаКт = ?(СуммаВалКор = Неопределено, СуммаВал, СуммаВалКор);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ФормированиеИЗаполнениеЛицевыхСчетов

#КонецОбласти
