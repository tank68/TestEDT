///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "_ДемоИнтернетПоддержкаПользователей._ДемоРаботаСКлассификаторами".
// ОбщийМодуль._ДемоРаботаСКлассификаторами.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка, ОбщиеДанные = Истина) Экспорт
	
	// Обновление данных по требования не поддерживается
	// при работе в модели сервиса и если у пользователя
	// отсутствуют права на обновление.
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Если ОбщиеДанные И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
			НеДоступнаЗагрузка = Истина;
		ИначеЕсли Не ОбщиеДанные И Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
			НеДоступнаЗагрузка = Истина;
		Иначе
			НеДоступнаЗагрузка = Не ЗагрузкаКлассификаторовДоступна();
		КонецЕсли;
	Иначе
		НеДоступнаЗагрузка = Не ЗагрузкаКлассификаторовДоступна();
	КонецЕсли;
	
	Если НеДоступнаЗагрузка Тогда
		Форма.Элементы.ФормаПроверитьОбновление.Видимость = Ложь;
		Форма.Элементы.ФормаОбновитьДанные.Видимость      = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Определяет доступность использования версий классификаторов
// загруженных в область данных.
//
// Возвращаемое значение:
//  Булево - если Истина, для определения версий необходимо использовать
//           регистр сведений ВерсииКлассификаторовОбластейДанных.
//
Функция ИспользоватьДанныеОбласти()
	
	Возврат (ОбщегоНазначения.РазделениеВключено()
		И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных());
	
КонецФункции

// Проверяет права доступа на обновление данных классификаторов.
// Обновление может быть недоступно если:
//  - у пользователя нет прав на получение обновлений,
//  - при работе в модели сервиса обновления загружаются из поставляемых данных.
//
// Возвращаемое значение:
//  Булево - Истина, загрузка классификаторов доступна, если ложь
//           прав на загрузку не достаточно.
//
Функция ЗагрузкаКлассификаторовДоступна()
	
	ОбъектМетаданных = ?(ИспользоватьДанныеОбласти(),
		Метаданные.РегистрыСведений.ВерсииКлассификаторовОбластейДанных,
		Метаданные.РегистрыСведений.ВерсииКлассификаторов);
	
	Если ПравоДоступа("Чтение", ОбъектМетаданных) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти