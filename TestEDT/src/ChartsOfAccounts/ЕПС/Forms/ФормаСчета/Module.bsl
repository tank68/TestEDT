
#Область СОБЫТИЯ_ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗапретРедактирования = Объект.ЗапретРедактирования;
	ПодготовитьФормуНаСервере();
		
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Объект.Наименование = Объект.Описание;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Объект.Парный И ЗначениеЗаполнено(ПарныйСчет) Тогда 
		
		ПарныйСчетОбъект = ПарныйСчет.ПолучитьОбъект();
		ПарныйСчетОбъект.ВидыСубконто.Загрузить(Объект.Ссылка.ВидыСубконто.Выгрузить());
		ПарныйСчетОбъект.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Если ЭтаФорма.КлючУникальности = Неопределено И ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ЭтаФорма.КлючУникальности = Объект.Ссылка;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область КомндыФормы

&НаКлиенте
Процедура ВключитьВозможностьРедактирвания(Команда)
	
	ЗапретРедактирования = Ложь;
	ПодготовитьФормуНаСервере();
		
КонецПроцедуры

&НаСервере
Процедура НастройкиПоставщикаНаСервере(КолСубконто)
	
	Макет = ПланыСчетов.ЕПС.ПолучитьМакет("ПланСчетов");
	ОбластьПоставка = Макет.ПолучитьОбласть("Поставка");

	мЕстьИзменения = Ложь;
	КолСубконто = 0;
	
	Для инд = 1 по ОбластьПоставка.ВысотаТаблицы Цикл
		Если Объект.Код = СокрЛП(ОбластьПоставка.Область(инд,2).Текст) Тогда
			Родитель = СокрЛП(ОбластьПоставка.Область(инд,1).Текст);
			НаименованиеСчета = СокрЛП(ОбластьПоставка.Область(инд,3).Текст);
			Субконто1 = СокрЛП(ОбластьПоставка.Область(инд,4).Текст);
			Субконто2 = СокрЛП(ОбластьПоставка.Область(инд,5).Текст);
			Субконто3 = СокрЛП(ОбластьПоставка.Область(инд,6).Текст);
			Валютный = ?(ОбластьПоставка.Область(инд,7).Текст="Истина",Истина,Ложь);
			Количественный = ?(ОбластьПоставка.Область(инд,8).Текст="Истина",Истина,Ложь);
			НалоговыйУчет = ?(ОбластьПоставка.Область(инд,9).Текст="Истина",Истина,Ложь);			
			ПорядокСчета = ?(Объект.Код="000.00",Перечисления.ПорядокСчетаЕПС.СчетВторогоПорядка,
				?(ЗначениеЗаполнено(Родитель),Перечисления.ПорядокСчетаЕПС.СчетВторогоПорядка,
				Перечисления.ПорядокСчетаЕПС.СчетПервогоПорядка));
			НайдРодитель = ?(ЗначениеЗаполнено(Родитель),
				ПланыСчетов.ЕПС.НайтиПоКоду(Родитель),
				ПланыСчетов.ЕПС.ПустаяСсылка());
			ЗапретитьИспользоватьВПроводках = ?(Объект.Код="000.00",Ложь,?(ЗначениеЗаполнено(Родитель),Ложь,Истина));	
			КолСубконто = ?(ЗначениеЗаполнено(Субконто3),3,
				?(ЗначениеЗаполнено(Субконто2),2,
				?(ЗначениеЗаполнено(Субконто1),1,0)));	

			Если Объект.Наименование <> Лев(НаименованиеСчета,160)
				ИЛИ  Объект.Описание <> НаименованиеСчета Тогда
				Объект.Наименование = НаименованиеСчета;
				Объект.Описание = НаименованиеСчета;				
				мЕстьИзменения = Истина;
			КонецЕсли;  			
			Если Объект.ПорядокСчета <> ПорядокСчета Тогда
				мТестСообщения = СтрШаблон("Изменен ПорядокСчета с %1 на %2",
					СокрЛП(Объект.ПорядокСчета),
					СокрЛП(ПорядокСчета));
				Объект.ПорядокСчета =  ПорядокСчета;
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(мТестСообщения);
				мЗаписатьИзменения = Истина;
			КонецЕсли; 
			Если Объект.Родитель <> НайдРодитель Тогда
				мТестСообщения = СтрШаблон("Изменен Родитель с %1 на %2",
					СокрЛП(Объект.Родитель),
					СокрЛП(НайдРодитель));
				Объект.Родитель =  НайдРодитель;
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(мТестСообщения);
				мЗаписатьИзменения = Истина;
			КонецЕсли; 
			Если Объект.ЗапретитьИспользоватьВПроводках <> ЗапретитьИспользоватьВПроводках Тогда
				мТестСообщения = СтрШаблон("Изменен признак ЗапретитьИспользоватьВПроводках с %1 на %2",
					СокрЛП(Объект.ЗапретитьИспользоватьВПроводках),
					СокрЛП(ЗапретитьИспользоватьВПроводках));
				Объект.ЗапретитьИспользоватьВПроводках =  ЗапретитьИспользоватьВПроводках;
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(мТестСообщения);
				мЗаписатьИзменения = Истина;
			КонецЕсли; 
			Если Объект.Валютный <> Валютный Тогда
				мТестСообщения = СтрШаблон("Изменен признак Валютный с %1 на %2",
					СокрЛП(Объект.Валютный),
					СокрЛП(Валютный)); 
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(мТестСообщения);
				Объект.Валютный = Валютный;
				мЕстьИзменения = Истина;
			КонецЕсли; 
			Если Объект.Количественный <> Количественный Тогда
				мТестСообщения = СтрШаблон("Изменен признак Количественный с %1 на %2",
					СокрЛП(Объект.ВалКоличественныйютный),
					СокрЛП(Количественный)); 
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(мТестСообщения);
				Объект.Количественный = Количественный;
				мЕстьИзменения = Истина;
			КонецЕсли;
			Если Объект.НалоговыйУчет <> НалоговыйУчет Тогда
				мТестСообщения = СтрШаблон("Изменен признак НалоговыйУчет с %1 на %2",
					СокрЛП(Объект.НалоговыйУчет),
					СокрЛП(НалоговыйУчет)); 
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(мТестСообщения);
				Объект.Количественный = Количественный;
				Объект.НалоговыйУчет = НалоговыйУчет;
				мЕстьИзменения = Истина;
			КонецЕсли;
			Объект.ЗапретРедактирования = Истина;  
			
			Если ЗначениеЗаполнено(Субконто1) Тогда
				ВидСубконто1 = ПланыВидовХарактеристик.ВидыСубконтоЕПС[Субконто1];
				Если Объект.ВидыСубконто.Количество()=0 Тогда
					НовСубконто = Объект.ВидыСубконто.Добавить();
					НовСубконто.ВидСубконто = ВидСубконто1;
					НовСубконто.Суммовой = Истина;
					НовСубконто.Количественный = Истина;
					НовСубконто.Валютный = Истина;   
					мТестСообщения = СтрШаблон("В счет добавлен субконто1 %1",
						СокрЛП(Субконто1)); 
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(мТестСообщения); 
					мЕстьИзменения = Истина;
				ИначеЕсли Объект.ВидыСубконто.Количество() >= 1
					И Объект.ВидыСубконто[0].ВидСубконто <> ВидСубконто1 Тогда 
					мТестСообщения = СтрШаблон("В счет субконто1 изменен с %1 на %2",
						СокрЛП(Объект.ВидыСубконто[0].ВидСубконто),
						СокрЛП(Субконто1)); 
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(мТестСообщения); 
					Объект.ВидыСубконто[0].ВидСубконто = ВидСубконто1; 
					Объект.ВидыСубконто[0].Суммовой = Истина;
					Объект.ВидыСубконто[0].Количественный = Истина;
					Объект.ВидыСубконто[0].Валютный = Истина; 
					мЕстьИзменения = Истина;  
				КонецЕсли; 
				Если ЗначениеЗаполнено(Субконто2) Тогда
					ВидСубконто2 = ПланыВидовХарактеристик.ВидыСубконтоЕПС[Субконто2];
					Если Объект.ВидыСубконто.Количество() = 1 Тогда
						НовСубконто = Объект.ВидыСубконто.Добавить();
						НовСубконто.ВидСубконто = ВидСубконто2;
						НовСубконто.Суммовой = Истина;
						НовСубконто.Количественный = Истина;
						НовСубконто.Валютный = Истина;   
						мТестСообщения = СтрШаблон("В счет добавлен субконто2 %1",
							СокрЛП(Субконто2)); 
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(мТестСообщения); 
						мЕстьИзменения = Истина;
					ИначеЕсли Объект.ВидыСубконто.Количество() >= 2
						И Объект.ВидыСубконто[1].ВидСубконто <> ВидСубконто2 Тогда 
						мТестСообщения = СтрШаблон("В счет субконто2 изменен с %1 на %2",
							СокрЛП(Объект.ВидыСубконто[1].ВидСубконто),
							СокрЛП(Субконто2)); 
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(мТестСообщения);  
						Объект.ВидыСубконто[1].ВидСубконто = ВидСубконто2;
						Объект.ВидыСубконто[1].Суммовой = Истина;
						Объект.ВидыСубконто[1].Количественный = Истина;
						Объект.ВидыСубконто[1].Валютный = Истина;  
						мЕстьИзменения = Истина;
					Иначе
						мТестСообщения = СтрШаблон("Не добавлен субконто2 %1",
							СокрЛП(Субконто2)); 
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(мТестСообщения);
					КонецЕсли;
					Если ЗначениеЗаполнено(Субконто3) Тогда
						ВидСубконто3 = ПланыВидовХарактеристик.ВидыСубконтоЕПС[Субконто3];
						Если Объект.ВидыСубконто.Количество()=2 Тогда
							НовСубконто = Объект.ВидыСубконто.Добавить();
							НовСубконто.ВидСубконто = ВидСубконто3;
							НовСубконто.Суммовой = Истина;
							НовСубконто.Количественный = Истина;
							НовСубконто.Валютный = Истина;  
							мТестСообщения = СтрШаблон("В счет добавлен субконто3 %1",
								СокрЛП(Субконто3)); 
							ОбщегоНазначенияКлиентСервер.СообщитьПользователю(мТестСообщения);
							мЕстьИзменения = Истина;
						ИначеЕсли Объект.ВидыСубконто.Количество() = 3
							И Объект.ВидыСубконто[2].ВидСубконто <> ВидСубконто3 Тогда
							мТестСообщения = СтрШаблон("В счет субконто3 изменен с %1 на %2",
								СокрЛП(Объект.ВидыСубконто[2].ВидСубконто),
								СокрЛП(Субконто3)); 
							ОбщегоНазначенияКлиентСервер.СообщитьПользователю(мТестСообщения);  
							Объект.ВидыСубконто[2].ВидСубконто = ВидСубконто3;
							Объект.ВидыСубконто[2].Суммовой = Истина;
							Объект.ВидыСубконто[2].Количественный = Истина;
							Объект.ВидыСубконто[2].Валютный = Истина; 
							мЕстьИзменения = Истина;
						Иначе
							мТестСообщения = СтрШаблон("Не добавлен субконто3 %1",
								СокрЛП(Субконто3)); 
							ОбщегоНазначенияКлиентСервер.СообщитьПользователю(мТестСообщения); 
						КонецЕсли; 
					ИначеЕсли Объект.ВидыСубконто.Количество()= 3 Тогда
						ОбщегоНазначения.СообщитьПользователю("Cубконто 3 нужно удалить"); 						
					КонецЕсли; 
				ИначеЕсли Объект.ВидыСубконто.Количество()= 3 Тогда 
					ОбщегоНазначения.СообщитьПользователю("Cубконто 2,3 нужно удалить");
				ИначеЕсли Объект.ВидыСубконто.Количество()= 2 Тогда 
					ОбщегоНазначения.СообщитьПользователю("Cубконто 2 нужно удалить");
				КонецЕсли;
			Иначе
				ОбщегоНазначения.СообщитьПользователю("Все субконто нужно удалить");
			КонецЕсли;		
		КонецЕсли; 
	КонецЦикла;
	
	Если мЕстьИзменения Тогда
		ЭтаФорма.Модифицированность = Истина;		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиПоставщика(Команда)
	
	КолСубконто = Объект.ВидыСубконто.Количество();
	НастройкиПоставщикаНаСервере(КолСубконто);
	Если КолСубконто < Объект.ВидыСубконто.Количество() Тогда 		
		ОбщегоНазначенияКлиент.СообщитьПользователю("Нужно удалить все после Субконто"+СокрЛП(КолСубконто)); 
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область СОБЫТИЯ_ЭЛЕМЕНТОВ_ФОРМЫ

&НаКлиенте
Процедура ПарныйСчет(Команда)
	
	П = Новый Структура;
	П.Вставить("Ключ", ПарныйСчет);
	ОткрытьФорму("ПланСчетов.ЕПС.ФормаОбъекта", П,,ПарныйСчет,,);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыСубконтоПередНачаломИзменения(Элемент, Отказ)
	
	Если Элемент.ТекущиеДанные.Предопределенное Тогда
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВидыСубконтоПередУдалением(Элемент, Отказ)
	
	Если Элемент.ТекущиеДанные.Предопределенное Тогда
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КодПриИзменении(Элемент)
	
	Объект.КодБыстрогоВыбора = СокрЛП(СтрЗаменить(Объект.Код, ".", ""));
	
КонецПроцедуры

#КонецОбласти

#Область ВСПОМОГАТЕЛЬНЫЕ_ПРОЦЕДУРЫ_ФУНКЦИИ

&НаСервере
Процедура ПодготовитьФормуНаСервере()
			
	//Если Объект.Парный Тогда 
	//	ПарныйСчет = РегистрыСведений.ПарныеСчетаЕПС.ПарныйСчет(Объект.Ссылка);
	//	ПарныйСчетКод = ?(ЗначениеЗаполнено(ПарныйСчет), ПарныйСчет.Код, "");
	//КонецЕсли;
	
	Элементы.Вид.Доступность = Не ЗапретРедактирования;
	Элементы.Забалансовый.Доступность = Не ЗапретРедактирования;
	Элементы.Количественный.Доступность = Не ЗапретРедактирования;
	Элементы.Валютный.Доступность = Не ЗапретРедактирования;
	Элементы.НалоговыйУчет.Доступность = Не ЗапретРедактирования;
	Элементы.ЗапретитьИспользоватьВПроводках.Доступность = Не ЗапретРедактирования;
	Элементы.ВидыСубконто.Доступность = Не ЗапретРедактирования;

	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	
	Элементы.ОткрытьПарныйСчет.Видимость = Объект.Парный;		
	Элементы.ОткрытьПарныйСчет.Заголовок = "Парный счет "+ Форма.ПарныйСчетКод;		
	
КонецПроцедуры

#КонецОбласти
