#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПРОГРАМНЫЙ_ИНТЕРФЕЙС 

// Функция ищет лицевой счет по переданным данным. 
//
// Параметры:
//  СчетЕПС - ПланСчетовСсылка.ЕПС - Владелец лицевого счета
//  Портфель - СправочникСсылка.Портфель - Портфель, для которого будет осуществлен поиск лицевого счета
//  Валюта - СправочникСсылка.Валюты - Валюта, для которой будет осуществлен поиск лицевого счета
//  КоллекцияАналитики - Структура со значениями аналитики по которой будет осуществлен поиск лицевого счета.
//
// Возвращаемое значение:
//	<Структура> - Возвращается структура значеий аналитики.
//- Если записи по переданной структуре отбора не найдено, то возвращается структура нужного вида со значениями неопределено.
//
Функция НайтиЛицевойСчетПоАналитике(СчетЕПС, Портфель, Валюта, КоллекцияАналитики, Дата, ЭтоСозданиеПарногоСчета, КэшПоискаЛицевыхСчетов) Экспорт 
	
	КлючКэшаЛС = КлючКэшаЛС(СчетЕПС, Портфель, Валюта, КоллекцияАналитики, Дата);
	ЗначениеИзКэша = КэшПоискаЛицевыхСчетов[КлючКэшаЛС];
	Если ЗначениеИзКэша <> Неопределено Тогда
		Возврат ЗначениеИзКэша;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
				"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ВложенныйЗапрос.ЛицевойСчетЕПС КАК ЛицевойСчетЕПС
		|ИЗ
		|	(ВЫБРАТЬ
		|		ДанныеЛицевыхСчетовЕПС.ЛицевойСчетЕПС КАК ЛицевойСчетЕПС,
		|		ДанныеЛицевыхСчетовЕПС.ЛицевойСчетЕПС.ДатаЗакрытия КАК ДатаЗакрытия,
		|		ВЫБОР
		|			КОГДА ДанныеЛицевыхСчетовЕПС.ЛицевойСчетЕПС.ДатаЗакрытия = &ПустаяДата
		|				ТОГДА 2
		|			ИНАЧЕ 1
		|		КОНЕЦ КАК Приоритет
		|	ИЗ
		|		РегистрСведений.ДанныеЛицевыхСчетовЕПС КАК ДанныеЛицевыхСчетовЕПС
		|			// Место вставки левых соединений
		|	ГДЕ
		|		ДанныеЛицевыхСчетовЕПС.СчетЕПС = &СчетЕПС
		|		И ДанныеЛицевыхСчетовЕПС.Портфель = &Портфель
		|		И ДанныеЛицевыхСчетовЕПС.Валюта = &Валюта
		|		И ДанныеЛицевыхСчетовЕПС.ЗначениеАналитики1 = &ЗначениеАналитики1
		|		И ДанныеЛицевыхСчетовЕПС.ЗначениеАналитики2 = &ЗначениеАналитики2
		|		И ДанныеЛицевыхСчетовЕПС.ЗначениеАналитики3 = &ЗначениеАналитики3
		|		И ДанныеЛицевыхСчетовЕПС.ЗначениеАналитики4 = &ЗначениеАналитики4
		|		И ДанныеЛицевыхСчетовЕПС.ЗначениеАналитики5 = &ЗначениеАналитики5
		|		И &УсловиеОтсутствияПарныхЛС) КАК ВложенныйЗапрос
		|ГДЕ
		|	(ВложенныйЗапрос.ДатаЗакрытия = &ПустаяДата
		|			ИЛИ ВложенныйЗапрос.ДатаЗакрытия > &Дата)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВложенныйЗапрос.Приоритет,
		|	ВложенныйЗапрос.ДатаЗакрытия";
	
	Запрос.УстановитьПараметр("ПустаяДата", ОбщегоНазначенияДУКлиентСервер.ПустаяДата());
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Портфель", Портфель);
	Запрос.УстановитьПараметр("Валюта", Валюта);
	Запрос.УстановитьПараметр("СчетЕПС", СчетЕПС);
	Запрос.УстановитьПараметр("ЗначениеАналитики1", КоллекцияАналитики.Аналитика1);
	Запрос.УстановитьПараметр("ЗначениеАналитики2", КоллекцияАналитики.Аналитика2);
	Запрос.УстановитьПараметр("ЗначениеАналитики3", КоллекцияАналитики.Аналитика3);
	Запрос.УстановитьПараметр("ЗначениеАналитики4", КоллекцияАналитики.Аналитика4);
	Запрос.УстановитьПараметр("ЗначениеАналитики5", КоллекцияАналитики.Аналитика5);
	Запрос.УстановитьПараметр("УсловиеОтсутствияПарныхЛС", Истина);
	
	Если ЭтоСозданиеПарногоСчета Тогда
		Если СтрНайти(Запрос.Текст, "// Место вставки левых соединений") = 0 Тогда
			ВызватьИсключение("В запросе отсутствует место вставки для левых соединений");
		КонецЕсли;
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеОтсутствияПарныхЛС", 
			"АктивныйПарныйЛС.СчетАктивный ЕСТЬ NULL
			|	И ПассивныйПарныйЛС.СчетПассивный ЕСТЬ NULL");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "// Место вставки левых соединений",
			"ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПарныеЛицевыеСчетаЕПС КАК АктивныйПарныйЛС
			|ПО ДанныеЛицевыхСчетовЕПС.ЛицевойСчетЕПС = АктивныйПарныйЛС.СчетАктивный
			|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПарныеЛицевыеСчетаЕПС КАК ПассивныйПарныйЛС
			|ПО ДанныеЛицевыхСчетовЕПС.ЛицевойСчетЕПС = ПассивныйПарныйЛС.СчетПассивный");
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда 
		Возврат Выборка.ЛицевойСчетЕПС;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Процедура создает запись в регистре ДанныеЛицевыхСчетовЕПС со значениями 
// из структуры данных (по точному соответствию колонок)
// Параметры:
//  СтруктураДанных - Структура с значениями колонок таблицы регистра.
//
Процедура СоздатьЗапись(СтруктураДанных) Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДанныеЛицевыхСчетовЕПС.СчетЕПС,
		|	ДанныеЛицевыхСчетовЕПС.Портфель,
		|	ДанныеЛицевыхСчетовЕПС.Валюта,
		|	ДанныеЛицевыхСчетовЕПС.ЗначениеАналитики1,
		|	ДанныеЛицевыхСчетовЕПС.ЗначениеАналитики2,
		|	ДанныеЛицевыхСчетовЕПС.ЗначениеАналитики3,
		|	ДанныеЛицевыхСчетовЕПС.ЗначениеАналитики4,
		|	ДанныеЛицевыхСчетовЕПС.ЗначениеАналитики5,
		|	ДанныеЛицевыхСчетовЕПС.ЛицевойСчетЕПС
		|ИЗ
		|	РегистрСведений.ДанныеЛицевыхСчетовЕПС КАК ДанныеЛицевыхСчетовЕПС
		|ГДЕ
		|	ДанныеЛицевыхСчетовЕПС.ЛицевойСчетДляПоиска = &ЛицевойСчетДляПоиска";
	
	Запрос.УстановитьПараметр("ЛицевойСчетДляПоиска", СтруктураДанных.ЛицевойСчетЕПС);
	
	Выборка = Запрос.Выполнить().Выбрать();
	МенеджерЗаписи = РегистрыСведений.ДанныеЛицевыхСчетовЕПС.СоздатьМенеджерЗаписи();  
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Выборка);
		МенеджерЗаписи.Удалить();
	КонецЦикла;  
	
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, СтруктураДанных);
	МенеджерЗаписи.Записать();

КонецПроцедуры

// Фукция возвращает строку для ключа кэша для поиска лицевого счета
Функция КлючКэшаЛС(СчетЕПС, Портфель, Валюта, КоллекцияАналитики, Дата) Экспорт
	СтруктураКэша = Новый Структура("СчетЕПС, Портфель, Валюта, КоллекцияАналитики, Дата", СчетЕПС, Портфель, Валюта, КоллекцияАналитики, НачалоДня(Дата));
	Возврат ЗначениеВСтрокуВнутр(СтруктураКэша);
КонецФункции

#КонецОбласти

#Область ОБРАБОТЧИКИ_ОБНОВЛЕНИЯ

// Процедура создает предопределенные связи парных счетов, 
// которых еще нет в базе
Процедура ЗаполнитьПоДаннымЛицевыхСчетов() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЛицевыеСчетаЕПС.Ссылка КАК ЛицевойСчетЕПС,
	|	ЛицевыеСчетаЕПС.Ссылка КАК ЛицевойСчетДляПоиска,
	|	ЛицевыеСчетаЕПС.Владелец КАК СчетЕПС,
	|	ЛицевыеСчетаЕПС.Портфель,
	|	ЛицевыеСчетаЕПС.Валюта,
	|	ЛицевыеСчетаЕПС.ЗначениеАналитики1,
	|	ЛицевыеСчетаЕПС.ЗначениеАналитики2,
	|	ЛицевыеСчетаЕПС.ЗначениеАналитики3,
	|	ЛицевыеСчетаЕПС.ЗначениеАналитики4,
	|	ЛицевыеСчетаЕПС.ЗначениеАналитики5
	|ИЗ
	|	Справочник.уа_ЛицевыеСчетаЕПС КАК ЛицевыеСчетаЕПС";
	
	ОбщегоНазначенияДУ.ДобавитьВЛогОтладки(Запрос, "РегистрыСведений.ДанныеЛицевыхСчетовЕПС.МодульМенеджера.ЗаполнитьПоДаннымЛицевыхСчетов()");
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	НачатьТранзакцию();
	
	НаборЗаписей = РегистрыСведений.ДанныеЛицевыхСчетовЕПС.СоздатьНаборЗаписей();
	
	Пока Выборка.Следующий() Цикл 
		СтрокаНабора = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаНабора,Выборка);
	КонецЦикла;
	НаборЗаписей.Записать();
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли