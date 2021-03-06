// Функция получает свойства счета 
//
// Параметры:
//  Счет - переданный счет учета
//
// Возвращаемое  значение:
//  свойства счета из плана счетов ЕПС
//
Функция СвойстваСчета(Счет) Экспорт
	
	ДанныеСчета = Новый Структура;
	
	ДанныеСчета.Вставить("Ссылка"                         , Счет.Ссылка);
	ДанныеСчета.Вставить("Наименование"                   , Счет.Наименование);
	ДанныеСчета.Вставить("Код"                            , Счет.Код);
	ДанныеСчета.Вставить("Родитель"                       , Счет.Родитель);
	ДанныеСчета.Вставить("Описание"                   	  , Счет.Описание);
	ДанныеСчета.Вставить("Вид"                            , Счет.Вид);
	ДанныеСчета.Вставить("Забалансовый"                   , Счет.Забалансовый);
	ДанныеСчета.Вставить("Парный"                         , Счет.Парный);
	ДанныеСчета.Вставить("ЗапретитьИспользоватьВПроводках", Счет.ЗапретитьИспользоватьВПроводках);
	ДанныеСчета.Вставить("Валютный"                       , Счет.Валютный);
	ДанныеСчета.Вставить("Количественный"                 , Счет.Количественный);
	ДанныеСчета.Вставить("НалоговыйУчет"                  , Счет.НалоговыйУчет);
	ДанныеСчета.Вставить("КоличествоСубконто"             , Счет.ВидыСубконто.Количество());
	
	МаксКоличествоСубконто = ПолучитьМаксКоличествоСубконтоЕПС();
	Для Индекс = 1 По МаксКоличествоСубконто Цикл
		Если Индекс <= Счет.ВидыСубконто.Количество() Тогда
			ДанныеСчета.Вставить("ВидСубконто" + Индекс,                   Счет.ВидыСубконто[Индекс - 1].ВидСубконто);
			ДанныеСчета.Вставить("ВидСубконто" + Индекс + "Наименование",  Строка(Счет.ВидыСубконто[Индекс - 1].ВидСубконто));
			ДанныеСчета.Вставить("ВидСубконто" + Индекс + "ТипЗначения",   Счет.ВидыСубконто[Индекс - 1].ВидСубконто.ТипЗначения);
			ДанныеСчета.Вставить("ВидСубконто" + Индекс + "Суммовой",      Счет.ВидыСубконто[Индекс - 1].Суммовой);
			ДанныеСчета.Вставить("ВидСубконто" + Индекс + "ТолькоОбороты", Счет.ВидыСубконто[Индекс - 1].ТолькоОбороты);
		Иначе
			ДанныеСчета.Вставить("ВидСубконто" + Индекс,                   Неопределено);
			ДанныеСчета.Вставить("ВидСубконто" + Индекс + "Наименование",  Неопределено);
			ДанныеСчета.Вставить("ВидСубконто" + Индекс + "ТипЗначения",   Неопределено);
			ДанныеСчета.Вставить("ВидСубконто" + Индекс + "Суммовой",      Ложь);
			ДанныеСчета.Вставить("ВидСубконто" + Индекс + "ТолькоОбороты", Ложь);
		КонецЕсли;
	КонецЦикла;
		
	Возврат Новый ФиксированнаяСтруктура(ДанныеСчета);
	
КонецФункции

// Функция получает максимальное количество субконто
//
// Параметры:
//  Отсутствуют
//
// Возвращаемое  значение:
//  число - максимального количества субконто из плана счетов
//
Функция ПолучитьМаксКоличествоСубконтоЕПС() Экспорт
	
	Возврат Метаданные.ПланыСчетов.ЕПС.МаксКоличествоСубконто;
	
КонецФункции


Функция СчетаАктива(Период, Актив, ОценочнаяКатегория) Экспорт 
	РеквизитыАктива = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Актив, "КатегорияАктива,КлассификацияЦБ");
	
	Отбор = Новый Структура("КатегорияАктива,КлассификацияЦБ,ОценочнаяКатегория");
	Отбор.КатегорияАктива = Актив.КатегорияАктива;
	Отбор.КлассификацияЦБ = Актив.КлассификацияЦБ;
	Отбор.ОценочнаяКатегория = ОценочнаяКатегория;
	
	Структура = РегистрыСведений.уа_НастройкаЕПССчетаЦБ.ПолучитьПоследнее(НачалоДня(Период), Отбор);
		
	Возврат Новый ФиксированнаяСтруктура(Структура);	
КонецФункции
