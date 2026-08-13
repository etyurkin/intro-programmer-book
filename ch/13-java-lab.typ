#import "../lib.typ": *

= Лаборатория: ещё Java руками

Спринг в этой главе не входить. Кто вошёл — выпроводить. Здесь консоль, файлы, текст, который притворяется данными, и одно письмо в сеть без фреймворка.

Лаборатория не заменяет месяц 1–2. Она для вечера, когда `TaskStore` уже зелёный, а хочется ещё раз потрогать плиту голыми руками. Папка: `java-basics/lab/`. Команды — как в книге: мак или Ubuntu в WSL. `javac`, `java`, JDK 21.

#rule[
  Каждую программу сначала сломай сам. Потом почини по тексту ошибки. Лаборатория, где всё сработало с первого копипаста — экскурсия, не лаборатория.
]

== Лаба 1. Дашборд станции, с ошибками как у людей

Хотим консоль:

```
МОДУЛЬ dashboard. energy=80 oxygen=40
> status
energy 80
oxygen 40
> set energy 55
ok
> save
wrote station.txt
> quit
```

После нового запуска — `load` поднимает числа с диска. Пока звучит как занятие 3. Сейчас мы дойдём *через ямы*.

=== Яма 0. Пустой main, чтобы было что запускать

`StationDash.java`:

```java
public class StationDash {
    public static void main(String[] args) {
        System.out.println("МОДУЛЬ dashboard");
    }
}
```

```
javac StationDash.java
java StationDash
```

Если `javac` «не является командой» — окно не то или PATH. Глава про компьютер, отсек PATH. Не эта лаборатория. Сначала плита.

=== Яма 1. Scanner и «оно съело строку»

Добавляем ввод. Типичный первый грех:

```java
import java.util.Scanner;

public class StationDash {
    public static void main(String[] args) {
        Scanner in = new Scanner(System.in);
        System.out.print("energy: ");
        int energy = in.nextInt();
        System.out.print("команда: ");
        String cmd = in.nextLine();
        System.out.println("ты сказал [" + cmd + "]");
        System.out.println("energy=" + energy);
    }
}
```

Запусти. Введи `80`, Enter. Курсор *не* ждёт команду. Печатает `ты сказал []`. Магия? Нет.

#slow[
  `nextInt` съел число, *оставил* конец строки в stdin. `nextLine` увидел этот конец и обрадовался: пустая команда. Это не баг Java «у меня». Это два способа есть поток: токенами и строками. Смешал — получи пустоту.
]

Починка, учебная, без религии:

```java
int energy = Integer.parseInt(in.nextLine().trim());
```

Всё через строки. Потом парси. Тогда Enter принадлежит тебе, не призраку.

Вторая починка: после `nextInt` вызвать лишний `nextLine()`, чтобы выбросить хвост. Работает. Легко забыть. Для дашборда бери `nextLine` всегда.

#exercise("J.L1", "Java")[
  Воспроизведи яму: `nextInt` + `nextLine`, посмотри пустые скобки. Потом перепиши на `parseInt(nextLine())`. В комментарии над `parseInt` одна строка: *зачем*. Не «так надо». Зачем.
]

=== Яма 2. Цикл, который умеет quit

```java
int energy = 80;
int oxygen = 40;
Scanner in = new Scanner(System.in);

System.out.println("МОДУЛЬ dashboard. energy=" + energy + " oxygen=" + oxygen);

while (true) {
    System.out.print("> ");
    String line = in.nextLine().trim();
    if (line.isEmpty()) {
        continue;
    }
    if (line.equals("quit")) {
        break;
    }
    if (line.equals("status")) {
        System.out.println("energy " + energy);
        System.out.println("oxygen " + oxygen);
        continue;
    }
    System.out.println("не знаю: " + line);
}
```

Пустая строка — не ошибка. Человек жмёт Enter от скуки. `continue`. `quit` — `break`, не `System.exit(0)` как из пушки по чайке.

Сравнивай строки через `equals`, не `==`. Иначе в одних запусках «сработает» (пул строк), в других — нет, и ты напишешь в чат «Java сломалась». Java не сломалась. Ты сравнил адреса мисок.

=== Яма 3. set energy 55 — пилим строку

Хочется `set energy 55`. Три куска.

```java
String[] parts = line.split(" ");
```

Яма: два пробела подряд. `set  energy 55` даст пустой кусок в массиве. Яма: `set energy`. Нет числа. Яма: `set energy много`.

Пишем честно:

```java
if (parts.length == 3 && parts[0].equals("set")) {
    String what = parts[1];
    int value;
    try {
        value = Integer.parseInt(parts[2]);
    } catch (NumberFormatException e) {
        System.out.println("это не число: " + parts[2]);
        continue;
    }
    if (value < 0 || value > 100) {
        System.out.println("диапазон 0..100");
        continue;
    }
    if (what.equals("energy")) {
        energy = value;
        System.out.println("ok");
    } else if (what.equals("oxygen")) {
        oxygen = value;
        System.out.println("ok");
    } else {
        System.out.println("датчик неизвестен: " + what);
    }
    continue;
}
```

#repl-note[
  Это не REPL Lisp, но жест тот же: прочитал строку, решил, ответил, снова `>`. Дашборд — REPL для бедных. Бедные мы сегодня.
]

Не глотай `NumberFormatException` молча. Напечатай кусок, который не число. Будущий ты скажет спасибо, когда вставишь неразрывный пробел из мессенджера.

#exercise("J.L2", "Java")[
  Команда `set` для `energy` и `oxygen`, границы 0..100, плохие числа не роняют процесс. Добавь датчик `temp` (температура коридора, пусть будет -20..40). Три проверки руками: ок, не число, вне диапазона.
]

=== Яма 4. Файл. Диск говорит нет

```java
import java.nio.file.Files;
import java.nio.file.Path;
import java.io.IOException;
import java.util.List;
```

Сейв в два строки — человеческий, не JSON пока:

```
energy=80
oxygen=40
```

```java
static void save(int energy, int oxygen, Path path) throws IOException {
    String text = "energy=" + energy + "\n" + "oxygen=" + oxygen + "\n";
    Files.writeString(path, text);
}
```

`throws IOException` — честно. Диск бывает занят, путь бывает в фантазии.

Загрузка:

```java
static int[] load(Path path) throws IOException {
    int energy = 80;
    int oxygen = 40;
    if (!Files.exists(path)) {
        return new int[] {energy, oxygen};
    }
    List<String> lines = Files.readAllLines(path);
    for (String raw : lines) {
        String s = raw.trim();
        if (s.startsWith("energy=")) {
            energy = Integer.parseInt(s.substring("energy=".length()));
        } else if (s.startsWith("oxygen=")) {
            oxygen = Integer.parseInt(s.substring("oxygen=".length()));
        }
    }
    return new int[] {energy, oxygen};
}
```

Яма: файла нет — *не падаем*. Дефолты. Яма: файл есть, внутри `energy=abc` — упадём на `parseInt`. Поймай:

```java
try {
    energy = Integer.parseInt(...);
} catch (NumberFormatException e) {
    System.err.println("битая строка: " + s);
}
```

В `main` команда `save` / `load`, путь `Path.of("station.txt")`. Это *текущая* папка процесса. Не «рядом с исходником в голове». `pwd` перед `java StationDash`. Если файл появился «не там» — ты стоял не там.

#warn[
  `C:\` и русские имена папок в учебном сейве не участвуют. `station.txt` в текущей. Хватит.
]

Типичная ошибка: сохранил, открыл файл в редакторе, видишь всё, программа грузит дефолты. Причина: запустил из IDEA с working directory в другом месте. Либо печатай `Path.of("station.txt").toAbsolutePath()` при сейве — и перестань гадать.

#exercise("J.L3", "Java")[
  `save` / `load` для трёх датчиков (с температурой, если делал). Нет файла — живые дефолты, сообщение `no station.txt, using defaults`. Битое число — строка в stderr, остальные датчики пусть живут. Не «весь load в одном catch Exception».
]

=== Яма 5. Разрезать main, пока не стыдно

Когда `main` длиннее экрана, вынеси:

- поля состояния — маленький класс `Station` с `energy`, `oxygen`, методами `statusText()`, `set(String, int)`;
- файл — `StationFile.save(Station, Path)`;
- цикл команд — `main` или `run()`.

Это не Spring. Это «чтобы не потеряться». Тот же инстинкт, что сервис и репозиторий, только без аннотаций и без резюме.

Сломай нарочно `set`: забудь верхнюю границу. Введи 10000. Посмотри, как врёт дашборд. Верни границу. Вот лабораторная работа. Отчёт — git diff, не эссе.

== Лаба 2. JSON руками и упоминание Jackson

Сервер в основном курсе будет плеваться JSON. До Спринга полезно один раз *собрать строку самим* и один раз *испугаться*.

Дано: энергия 80, кислород 40. Хотим:

```
{"energy":80,"oxygen":40}
```

```java
static String toJson(int energy, int oxygen) {
    return "{\"energy\":" + energy + ",\"oxygen\":" + oxygen + "}";
}
```

В Java кавычка внутри строки — `\"`. Красиво не будет. Зато видно: JSON — текст.

Яма: название отсека.

```java
static String roomJson(String room, int energy) {
    return "{\"room\":\"" + room + "\",\"energy\":" + energy + "}";
}
```

Введи комнату `corridor`. Ок. Введи комнату `cor"idor` с кавычкой. JSON сломается: строка кончится рано, едок на той стороне подавится. Введи обратный слэш. То же.

#slow[
  Руками JSON можно, пока данные — числа и слова без кавычек. Как только строка с улицы — ты пишешь экранирование или берёшь библиотеку. Иначе это не JSON, а костюм на Хэллоуин.
]

Мини-парсер для *своего* же формата, без претензий. Только плоский объект с двумя int, который *мы* только что написали:

```java
static int[] fromJsonEnergyOxygen(String json) {
    int e = grabInt(json, "energy");
    int o = grabInt(json, "oxygen");
    return new int[] {e, o};
}

static int grabInt(String json, String key) {
    String needle = "\"" + key + "\":";
    int i = json.indexOf(needle);
    if (i < 0) {
        throw new IllegalArgumentException("нет ключа " + key);
    }
    int start = i + needle.length();
    int end = start;
    while (end < json.length() && Character.isDigit(json.charAt(end))) {
        end++;
    }
    return Integer.parseInt(json.substring(start, end));
}
```

Это учебный нож. Он умрёт на пробеле после `:`, на отрицательном числе, на вложенности. *Пусть умрёт*. Ты увидишь границу ножа.

#warn[
  Не тащи этот `grabInt` в task-manager. Там Jackson / Gson / что даст Spring. Здесь нож, чтобы понять, *зачем* они.
]

Jackson — библиотека: объект ↔ JSON, экранирование, списки, даты. В Maven это зависимость. В лаборатории достаточно *знать имя* и причину: кавычки, юникод, вложенность, не изобретать. Когда дойдёшь до Spring, `@RestController` часто вообще спрячет Jackson под одеяло. Одеяло не отменяет, что под ним текст.

Попробуй руками в дашборде команду `json` — печатает `toJson`. Команду `json` после `load` — те же числа, другой костюм. Это не база. Это конверт.

#exercise("J.L4", "Java")[
  `toJson` для трёх датчиков. Проверь глазами: вставь вывод в https://jsonlint.com или в любой валидатор. Потом сломай: добавь кавычку в *имя* выдуманного поля комнаты без экрана — валидатор должен обидеться. Напиши в README одну фразу, почему Jackson существует.
]

== Лаба 3. HTTP без Спринга: HttpClient и чужая кухня

Сеть — письма. Письмо можно послать *из* Java, не только из браузера.

Пакет `java.net.http` в JDK 11+ есть сам. Не Maven. Не Spring. Плита уже умеет.

Сервис httpbin.org (или `https://httpbin.org/get`) отвечает на GET JSON-ом: какой URL пришёл, какие заголовки, откуда стучали. Учебная эхо-стенка. Если httpbin лежит (бывает) — любой простой GET на `https://example.com`: там HTML, не JSON, но письмо всё равно письмо.

```java
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.io.IOException;

public class StationPing {
    public static void main(String[] args) throws IOException, InterruptedException {
        HttpClient client = HttpClient.newHttpClient();
        HttpRequest req = HttpRequest.newBuilder()
                .uri(URI.create("https://httpbin.org/get"))
                .GET()
                .build();
        HttpResponse<String> res = client.send(req, HttpResponse.BodyHandlers.ofString());
        System.out.println("status " + res.statusCode());
        System.out.println(res.body());
    }
}
```

#slow[
  `send` — синхронно: стоим у двери, ждём конверт. Поток Java на это время занят. Для дашборда ок. Для тысячи писем в секунду — уже другая вахта.

  `InterruptedException` — «нас ткнули, пока ждали». `IOException` — конверты, DNS, обрыв Wi‑Fi. Не лови их пустым catch. Напечатай `e.getMessage()`.
]

Яма: нет сети. Будет исключение, не JSON. Это правильное поведение. Поймай, напечатай «сеть не взяла трубку», не падай без текста.

Яма: опечатка в URL. `httpbin.org/gеt` с русской «е» — шедевр. Копируй латиницу.

Яма: http vs https. httpbin часто хочет https. `301` / редирект. HttpClient умеет ходить за редиректом, но статус надо смотреть. Если 301 и пустое тело — ты не «не получил JSON», ты получил указатель «ищи там».

Разбор крошечный, без полного JSON-парсера: найди в теле `"url"` глазами. Потом `indexOf`. Потом пойми, что руками стыдно, и остановись. Лаборатория про *письмо*, не про второй Jackson.

Добавь в дашборд команду `ping`: дергает httpbin, печатает только `statusCode`. Если не 200 — всё равно напечатай код. 503 чужой кухни — не твой баг. 404 — не та дверь. 0 у тебя не будет: статус всегда пришёл *если* `send` не кинул. Кинул — сети не было.

#os[
  *Мак / WSL.* Обычно просто работает.

  *Корпоративный прокси.* `send` умрёт таймаутом. Не лечи это десятью обходами в первую ночь. Сделай лабораторную на домашней сети.

  *Оффлайн.* Нормальный исход — пойманный IOException. Засчитано, если сообщение человеческое.
]

#exercise("J.L5", "Java")[
  Класс `StationPing` или команда `ping` в дашборде. Напечатай статус и *первые 200 символов* тела, не роман. Второй запрос: `https://httpbin.org/status/404` — увидь 404 и не называй это «у меня сломалось». Третий: неверный хост `https://no-such-module-xxxx.example` — поймай исключение, напечатай тип (имя класса) и сообщение.
]

== Лаба 4. Склеить: дашборд умеет сейв и письмо

Не обязательно. Если остались силы: команда `report` собирает JSON руками и… никуда не постит, если не хочешь регистрировать чужие API. Напечатай JSON. Рядом команда `ping`. Два мира: диск и сеть. Оба не магия.

Если хочется POST (не обязательно для зачёта журнала):

```java
HttpRequest req = HttpRequest.newBuilder()
        .uri(URI.create("https://httpbin.org/post"))
        .header("Content-Type", "application/json")
        .POST(HttpRequest.BodyPublishers.ofString(toJson(energy, oxygen)))
        .build();
```

httpbin вернёт тебе твой JSON внутри своего JSON. Зеркало. Увидишь, *что* улетело, включая кавычки. Если улетело криво — виноват `toJson`, не «HTTP».

#warn[
  Не пости свой дашборд на случайные чужие URL «для проверки». httpbin — для этого. Чужой прод — нет. Станция «МОДУЛЬ» и так на изоленте, давай без инцидентов.
]

== Сборка дашборда целиком, без геройства

Ниже — скелет, который можно набрать *после* ям, не вместо них. Если скопируешь сразу — ямы не случатся, пальцы ничего не получат.

`Station.java`:

```java
public class Station {
    int energy = 80;
    int oxygen = 40;
    int temp = 21;

    String statusText() {
        return "energy " + energy + "\n"
             + "oxygen " + oxygen + "\n"
             + "temp " + temp;
    }

    String set(String what, int value) {
        if (what.equals("energy") || what.equals("oxygen")) {
            if (value < 0 || value > 100) {
                return "диапазон 0..100";
            }
        } else if (what.equals("temp")) {
            if (value < -20 || value > 40) {
                return "диапазон -20..40";
            }
        } else {
            return "датчик неизвестен: " + what;
        }
        if (what.equals("energy")) energy = value;
        else if (what.equals("oxygen")) oxygen = value;
        else temp = value;
        return "ok";
    }

    String toJson() {
        return "{\"energy\":" + energy
             + ",\"oxygen\":" + oxygen
             + ",\"temp\":" + temp + "}";
    }
}
```

`StationFile.java` — `save`/`load` как в яме 4, только три ключа. Имена полей совпадают с файлом: меньше фантазии, меньше багов.

`StationDash.java` — цикл `while (true)`, `split`, `quit` / `status` / `set` / `save` / `load` / `json` / `ping`.

Компиляция двух-трёх файлов в одной папке:

```
javac Station.java StationFile.java StationDash.java
java StationDash
```

IDEA делает это кнопкой. Терминал делает это явно. Явно полезнее один вечер.

Ошибка `cannot find symbol Station` — ты компилируешь не из той папки или забыл файл в списке. `pwd`. `ls *.java`.

#slow[
  Класс `Station` — состояние на стойке. `StationFile` — кладовая. `HttpClient` в `ping` — письма. Если через месяц кто-то скажет «контроллер, сервис, репозиторий», ты уже это нюхал. Только без аннотаций и без зарплаты.
]

=== Ещё одна яма: рабочая папка IDEA

Run → Edit Configurations → Working directory. Если там корень проекта, а ты думал «рядом с java-файлом», `station.txt` родится в корне. Git увидит лишний файл. Ты не увидишь его в `ls` учебной папки. Оба правы. Пути разные.

Печатай абсолютный путь при первом `save`. Один раз. Потом либо смирись, либо поправь конфигурацию. Не чини это копированием файла руками «ну вот же он».

=== Ещё одна яма: разделитель строк

`Files.writeString` на Windows может написать `\r\n`. `readAllLines` обычно прожуёт оба. Если парсишь байты сам — не парсь байты сам. Если открыл файл в старом блокноте и он в одну строку — виноваты `\n` и блокнот, не реактор.

=== HttpClient чуть аккуратнее

Таймаут, чтобы висеть не вечно:

```java
HttpRequest req = HttpRequest.newBuilder()
        .uri(URI.create("https://httpbin.org/get"))
        .timeout(java.time.Duration.ofSeconds(10))
        .GET()
        .build();
```

Заголовок `User-Agent` иногда просят вежливые серверы. httpbin не капризничает. Чужой прод капризничает. Для лаборатории не надо притворяться браузером.

Тело может быть огромным. `substring(0, Math.min(200, body.length()))` — первые 200. Без `Math.min` поймаешь `StringIndexOutOfBounds`, и это будет смешно ровно один раз.

#exercise("J.L6", "Java")[
  Вынеси состояние в `Station`, файл в `StationFile`, цикл оставь в `StationDash`. Три файла компилируются из терминала. README: три команды запуска и пример диалога на пять строк. Без README лаба не закрыта — как в неделе 4, только короче.
]

== Что должно остаться в пальцах

- Ввод: не мешай `nextInt` и `nextLine`.
- Команды: пили строку, проверяй длину массива.
- Файл: нет файла — дефолт; битая строка — сообщение, не немой вылет.
- JSON: текст; кавычки опасны; библиотека существует не из снобизма.
- HTTP: клиент, запрос, статус, тело, исключение на обрыве.

Это тот же камбуз, что в главе про компьютер: повар, стойка, кладовая, письма. Только теперь ты ещё и рецепты пишешь.

#sunday[
  Запусти дашборд из терминала, не из стрелки. Сохрани. Найди `station.txt` через `ls` в *той* папке, где `pwd`. Если файла нет в Finder «рядом с исходником» — поздравь себя: ты только что почувствовал процесс.
]

Лаборатория закрыта, когда: (1) яма с `Scanner` воспроизведена своими руками; (2) `station.txt` находится через `pwd`, не через молитву; (3) JSON хотя бы один раз проверили валидатором; (4) HTTP хотя бы один раз вернул не-200 и ты не запаниковал. Спринг подождёт. Он никуда не денется, к сожалению.
