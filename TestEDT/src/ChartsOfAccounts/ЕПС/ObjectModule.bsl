#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОБРАБОТЧИКИ_СОБЫТИЙ

Процедура ПередЗаписью(Отказ)
	
	//УстановитьПорядокСчета(Отказ);
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Предопределенный И ПоменялсяПризнакПарный() Тогда 
		ТекстСообщения = НСтр("ru = 'Нельзя изменить парность у предопределенного счета'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);
	КонецЕсли;
	
	Если НельзяМенятьРодителя() Тогда
		ТекстСообщения = НСтр("ru = 'Нельзя менять состав предопределенных групп'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);
	КонецЕсли;
	
	Порядок = ПолучитьПорядокКода();
		
	Если НЕ ЗначениеЗаполнено(КодБыстрогоВыбора) Тогда
		КодБыстрогоВыбора = СокрЛП(СтрЗаменить(Код, ".", ""));
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область СЛУЖЕБНЫЕ_ПРОЦЕДУРЫ_И_ФУНКЦИИ

Функция ПоменялсяПризнакПарный()
	
	Поменялся = Ложь;
	Если ЗначениеЗаполнено(Ссылка) Тогда 
		Если Парный <> Ссылка.Парный Тогда 
			Поменялся = Истина;
		КонецЕсли;
	КонецЕсли;
			
	Возврат Поменялся;
	
КонецФункции

Функция НельзяМенятьРодителя()
	НельзяМенятьРодителя = Ложь;
	
	Если ЗначениеЗаполнено(Ссылка) Тогда 
		ПоменялсяРодитель = Родитель <> Ссылка.Родитель;
		ПереносСчетаВПредопределенныйСчет = ЗначениеЗаполнено(Родитель) И Родитель.Предопределенный;
		ПереносПредопределенногоСчетаИзДругогоПредопределенногоСчета = Предопределенный И ЗначениеЗаполнено(Ссылка.Родитель) И Ссылка.Родитель.Предопределенный;
		НельзяМенятьРодителя = ПоменялсяРодитель И (ПереносСчетаВПредопределенныйСчет ИЛИ ПереносПредопределенногоСчетаИзДругогоПредопределенногоСчета);
	Иначе
		СозданиеСчетаВПредопределенномСчете = ЗначениеЗаполнено(Родитель) И Родитель.Предопределенный;
		НельзяМенятьРодителя = СозданиеСчетаВПредопределенномСчете;
	КонецЕсли;
			
	Возврат НельзяМенятьРодителя;
КонецФункции

Процедура УстановитьПорядокСчета(Отказ)
	
	ДлинаКода=СтрДлина(Код);
	
	Если ДлинаКода=1 Тогда
		ПорядокСчета=ПредопределенноеЗначение("Перечисление.ПорядокСчетаЕПС.Раздел");
	ИначеЕсли ДлинаКода=3 Тогда
		ПорядокСчета=ПредопределенноеЗначение("Перечисление.ПорядокСчетаЕПС.СчетПервогоПорядка");
	ИначеЕсли ДлинаКода=5 Тогда
		ПорядокСчета=ПредопределенноеЗначение("Перечисление.ПорядокСчетаЕПС.СчетВторогоПорядка");
	ИначеЕсли ДлинаКода=8 Тогда
		ПорядокСчета=ПредопределенноеЗначение("Перечисление.ПорядокСчетаЕПС.СчетТретьегоПорядка");	
	Иначе
		Отказ=Истина;

		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Невозможно определить порядок счета. Укажите корректный код!";
		Сообщение.Поле  = "Код";
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Сообщить(); 
	КонецЕсли;
	
КонецПроцедуры
 
#КонецОбласти

#КонецЕсли