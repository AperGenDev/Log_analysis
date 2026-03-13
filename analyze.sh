#!/bin/bash

if [ -z $1 ]; then
	echo передай файл лога  
	exit 1
fi

LOG_FILE=$1

if [ ! -f "$LOG_FILE" ]; then
	echo Файл $LOG_FILE не найден!
	exit 1
fi

echo Мой анализатор логов
echo Файл для анализа: $1
echo
echo Всего запросов: $(wc -l < $LOG_FILE)
ip=$(awk {'print $1'} $LOG_FILE | sort | uniq)
echo уникальные IP адреса: $(awk {'print $1'} $LOG_FILE | sort | uniq)
echo
echo $( awk {'print $1'} $LOG_FILE | sort  |  uniq -c )
echo Самые активные ip, топ 3:
awk {'print $1'} test.log | sort | uniq -c | sort -rn | head -3
echo -------------
echo Коды ответа:
awk {'print $1,$9'} test.log
echo ------------
echo топ страниц:
awk {'print $7'} test.log | sort | uniq -c | sort -rn | head -5 

echo \n Проблемы:
errors_4xx=$(awk '$9 ~ /^4[0-9][0-9]/' $LOG_FILE | wc -l)
errors_5xx=$(awk '$9 ~ /^5[0-9][0-9]/' $LOG_FILE | wc -l)

echo Ошибка клиента $errors_4xx
echo Ошибка сервера $errors_5xx
	
echo Откуда ip:
curl -s "http://ipinfo.io/$ip" | grep -E "city|country|org"

for i in $ip; do
	echo Информация для ip: $i
	curl -s "http://ipinfo.io/$ip" | grep -E "city|country|org" || echo Не удалось получить данные
	echo --------
done



