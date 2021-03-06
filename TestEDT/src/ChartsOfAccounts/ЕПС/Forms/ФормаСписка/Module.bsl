
#Область ОбработчикиСобытийФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаСервере
Процедура ОбработатьПланСчетовНаСервере()
	
	ПланыСчетов.ЕПС.УстановитьЗапретИспользованияВПроводках();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьПланСчетов(Команда)
	
	Состояние("Обработка плана счетов",,,БиблиотекаКартинок.ДлительнаяОперация48);
	ОбработатьПланСчетовНаСервере();
	Элементы.Список.Обновить(); 
	Состояние("Выполнена обработка плана счетов",,,БиблиотекаКартинок.ДлительнаяОперация48);
	
КонецПроцедуры

&НаСервере
Процедура НастройкиПоставщикаНаСервере(ТабДокИзменения)
	
	ПланыСчетов.ЕПС.ЗаполнитьНастройкиПоставщика(ТабДокИзменения);
		
КонецПроцедуры

&НаКлиенте
Процедура НастройкиПоставщика(Команда)
	
	Состояние("Обновление плана счетов",,,БиблиотекаКартинок.ДлительнаяОперация48);
	ТабДокИзм = Неопределено;
	НастройкиПоставщикаНаСервере(ТабДокИзм);
	Если ТипЗнч(ТабДокИзм) = Тип("ТабличныйДокумент") Тогда
		СтруктураДанныхДляПечати = УА_ПечатьКлиент.ПолучитьСтруктуруДляПечати();
		КоллекцияПечатныхФорм = УправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм("ТабДокИзм");    
		// Добавляем в коллекцию (тип массив) сформированный Табличный документ
		КоллекцияПечатныхФорм[0].ТабличныйДокумент = ТабДокИзм; 
		// если требуется устанавливаем параметры печати
		КоллекцияПечатныхФорм[0].Экземпляров=1;
		КоллекцияПечатныхФорм[0].СинонимМакета = "Счета требующие изменения";  // используется для формирования имени файла при сохранении из общей формы печати документов
		КоллекцияПечатныхФорм[0].ИмяФайлаПечатнойФормы = "Счета требующие изменения";
		СтруктураДанныхДляПечати.КоллекцияПечатныхФорм = КоллекцияПечатныхФорм;
		СтруктураДанныхДляПечати.ВладелецФормы = ЭтаФорма;
		СтруктураДанныхДляПечати.Заголовок = "Счета требующие изменения";
		// .. и выводим стандартной процедурой БСП
		УА_ПечатьКлиент.ПечатьДокументов(СтруктураДанныхДляПечати); 		
	КонецЕсли; 
	Элементы.Список.Обновить();
	Состояние("Выполнено обновление плана счетов",,,БиблиотекаКартинок.ДлительнаяОперация48);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
