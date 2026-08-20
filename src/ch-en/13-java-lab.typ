#import "../lib-en.typ": *

= Lab: more Java by hand

Spring does not enter this chapter. Anyone who entered — escort them out. Here: a console, files, text pretending to be data, and one letter into the network with no framework.

The lab doesn't replace months 1–2. It's for an evening when `TaskStore` is already green and you want to touch the stove with bare hands again. Folder: `java-basics/lab/`. Commands — like in the book: Mac or Ubuntu in WSL. `javac`, `java`, JDK 21.

#rule[
  Break every program yourself first. Then fix it from the error text. A lab where everything worked on the first copy-paste is a tour, not a lab.
]

== Lab 1. Station dashboard, with errors like people have

We want a console:

```
MODULE dashboard. energy=80 oxygen=40
> status
energy 80
oxygen 40
> set energy 55
ok
> save
wrote station.txt
> quit
```

After a new launch — `load` brings the numbers up from disk. So far it sounds like lesson 3. Now we'll get there *through the pits*.

=== Pit 0. An empty main, so there's something to run

`StationDash.java`:

```java
public class StationDash {
    public static void main(String[] args) {
        System.out.println("MODULE dashboard");
    }
}
```

```
javac StationDash.java
java StationDash
```

If `javac` "is not recognized as a command" — wrong window or PATH. That's the computer chapter, the PATH compartment. Not this lab. First the stove.

=== Pit 1. Scanner and "it ate the line"

We add input. The typical first sin:

```java
import java.util.Scanner;

public class StationDash {
    public static void main(String[] args) {
        Scanner in = new Scanner(System.in);
        System.out.print("energy: ");
        int energy = in.nextInt();
        System.out.print("command: ");
        String cmd = in.nextLine();
        System.out.println("you said [" + cmd + "]");
        System.out.println("energy=" + energy);
    }
}
```

Run it. Type `80`, Enter. The cursor does *not* wait for a command. It prints `you said []`. Magic? No.

#slow[
  `nextInt` ate the number and *left* the end of the line in stdin. `nextLine` saw that end and was delighted: an empty command. That isn't a Java bug "on my machine." That's two ways to eat a stream: by tokens and by lines. Mix them — get emptiness.
]

The fix, a teaching one, no religion:

```java
int energy = Integer.parseInt(in.nextLine().trim());
```

Everything through strings. Then parse. Then Enter belongs to you, not to a ghost.

Second fix: after `nextInt` call an extra `nextLine()` to throw away the tail. It works. Easy to forget. For the dashboard, take `nextLine` always.

#exercise("J.L1", "Java")[
  Reproduce the pit: `nextInt` + `nextLine`, see the empty brackets. Then rewrite to `parseInt(nextLine())`. In a comment above `parseInt`, one line: *why*. Not "that's how it's done." Why.
]

=== Pit 2. A loop that knows quit

```java
int energy = 80;
int oxygen = 40;
Scanner in = new Scanner(System.in);

System.out.println("MODULE dashboard. energy=" + energy + " oxygen=" + oxygen);

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
    System.out.println("unknown: " + line);
}
```

An empty line isn't an error. A person hits Enter out of boredom. `continue`. `quit` is `break`, not `System.exit(0)` like a cannon at a seagull.

Compare strings with `equals`, not `==`. Otherwise in some runs it "works" (the string pool), in others it doesn't, and you'll write in chat "Java broke." Java didn't break. You compared bowl addresses.

=== Pit 3. set energy 55 — splitting the line

We want `set energy 55`. Three pieces.

```java
String[] parts = line.split(" ");
```

Pit: two spaces in a row. `set  energy 55` will give an empty piece in the array. Pit: `set energy`. No number. Pit: `set energy lots`.

Write it honestly:

```java
if (parts.length == 3 && parts[0].equals("set")) {
    String what = parts[1];
    int value;
    try {
        value = Integer.parseInt(parts[2]);
    } catch (NumberFormatException e) {
        System.out.println("not a number: " + parts[2]);
        continue;
    }
    if (value < 0 || value > 100) {
        System.out.println("range 0..100");
        continue;
    }
    if (what.equals("energy")) {
        energy = value;
        System.out.println("ok");
    } else if (what.equals("oxygen")) {
        oxygen = value;
        System.out.println("ok");
    } else {
        System.out.println("unknown sensor: " + what);
    }
    continue;
}
```

#repl-note[
  This isn't a Lisp REPL, but the gesture is the same: read a line, decide, answer, `>` again. The dashboard is a REPL for the poor. We're poor today.
]

Don't swallow `NumberFormatException` in silence. Print the piece that isn't a number. Future you will say thanks when you paste a non-breaking space from a messenger.

#exercise("J.L2", "Java")[
  A `set` command for `energy` and `oxygen`, bounds 0..100, bad numbers don't kill the process. Add a `temp` sensor (corridor temperature, let it be -20..40). Three checks by hand: ok, not a number, out of range.
]

=== Pit 4. A file. The disk says no

```java
import java.nio.file.Files;
import java.nio.file.Path;
import java.io.IOException;
import java.util.List;
```

Save in two lines — human, not JSON yet:

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

`throws IOException` — honest. The disk is sometimes busy, the path is sometimes fantasy.

Load:

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

Pit: no file — *don't crash*. Defaults. Pit: the file is there, inside `energy=abc` — we'll die on `parseInt`. Catch it:

```java
try {
    energy = Integer.parseInt(...);
} catch (NumberFormatException e) {
    System.err.println("bad line: " + s);
}
```

In `main`, commands `save` / `load`, path `Path.of("station.txt")`. That's the process's *current* folder. Not "next to the source in your head." `pwd` before `java StationDash`. If the file showed up "not there" — you were standing not there.

#warn[
  `C:\` and folder names with spaces in a study save don't participate. `station.txt` in the current one. Enough.
]

A typical miss: you saved, opened the file in an editor, you see everything, the program loads defaults. Cause: you launched from IDEA with the working directory somewhere else. Either print `Path.of("station.txt").toAbsolutePath()` on save — and stop guessing.

#exercise("J.L3", "Java")[
  `save` / `load` for three sensors (with temperature, if you did it). No file — live defaults, the message `no station.txt, using defaults`. A broken number — a line on stderr, the other sensors live. Not "the whole load in one catch Exception."
]

=== Pit 5. Cut main while it isn't embarrassing yet

When `main` is longer than the screen, pull out:

- state fields — a small class `Station` with `energy`, `oxygen`, methods `statusText()`, `set(String, int)`;
- the file — `StationFile.save(Station, Path)`;
- the command loop — `main` or `run()`.

This isn't Spring. This is "so you don't get lost." The same instinct as service and repository, only without annotations and without a résumé.

Break `set` on purpose: forget the upper bound. Type 10000. Watch the dashboard glitch. Put the bound back. That's lab work. The report is a git diff, not an essay.

== Lab 2. JSON by hand and a mention of Jackson

The server in the main course will spit JSON. Before Spring it's useful to *build a string yourself* once and *get scared* once.

Given: energy 80, oxygen 40. We want:

```
{"energy":80,"oxygen":40}
```

```java
static String toJson(int energy, int oxygen) {
    return "{\"energy\":" + energy + ",\"oxygen\":" + oxygen + "}";
}
```

In Java a quote inside a string is `\"`. It won't be pretty. But you can see: JSON is text.

Pit: a compartment name.

```java
static String roomJson(String room, int energy) {
    return "{\"room\":\"" + room + "\",\"energy\":" + energy + "}";
}
```

Enter room `corridor`. Fine. Enter room `cor"idor` with a quote. JSON breaks: the string ends early, the eater on the other side chokes. Enter a backslash. Same.

#slow[
  You can do JSON by hand while the data is numbers and words with no quotes. The moment a string comes in from the street — you write escaping or you take a library. Otherwise it isn't JSON, it's a Halloween costume.
]

A mini-parser for *our own* format, no pretensions. Only a flat object with two ints that *we* just wrote:

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
        throw new IllegalArgumentException("no key " + key);
    }
    int start = i + needle.length();
    int end = start;
    while (end < json.length() && Character.isDigit(json.charAt(end))) {
        end++;
    }
    return Integer.parseInt(json.substring(start, end));
}
```

This is a teaching knife. It will die on a space after `:`, on a negative number, on nesting. *Let it die*. You'll see the knife's edge.

#warn[
  Don't drag this `grabInt` into task-manager. There it's Jackson / Gson / whatever Spring gives. Here it's a knife, so you understand *why* they exist.
]

Jackson is a library: object ↔ JSON, escaping, lists, dates. In Maven that's a dependency. In the lab it's enough to *know the name* and the reason: quotes, unicode, nesting, don't invent. When you get to Spring, `@RestController` often hides Jackson under a blanket entirely. The blanket doesn't cancel that under it there's text.

Try by hand in the dashboard a `json` command — it prints `toJson`. A `json` command after `load` — the same numbers, a different costume. That isn't a database. That's an envelope.

#exercise("J.L4", "Java")[
  `toJson` for three sensors. Check with your eyes: paste the output into https://jsonlint.com or any validator. Then break it: add a quote to the *name* of a made-up room field with no escape — the validator should be offended. Write one sentence in the README about why Jackson exists.
]

== Lab 3. HTTP without Spring: HttpClient and someone else's kitchen

The network is letters. You can send a letter *from* Java, not only from a browser.

The package `java.net.http` is in JDK 11+ itself. Not Maven. Not Spring. The stove already can.

The service httpbin.org (or `https://httpbin.org/get`) answers GET with JSON: which URL arrived, which headers, where they knocked from. A teaching echo wall. If httpbin is down (happens) — any simple GET to `https://example.com`: that's HTML, not JSON, but a letter is still a letter.

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
  `send` is synchronous: we stand at the door, wait for the envelope. The Java thread is busy for that time. For a dashboard, fine. For a thousand letters a second — already a different watch.

  `InterruptedException` is "they poked us while we waited." `IOException` is envelopes, DNS, Wi‑Fi dropping. Don't catch them with an empty catch. Print `e.getMessage()`.
]

Pit: no network. There will be an exception, not JSON. That's correct behavior. Catch it, print "network didn't pick up," don't crash with no text.

Pit: a typo in the URL. `httpbin.org/gеt` with a Cyrillic "е" — a masterpiece. Copy Latin.

Pit: http vs https. httpbin often wants https. `301` / a redirect. HttpClient can follow a redirect, but you have to look at the status. If 301 and an empty body — you didn't "not get JSON," you got a pointer "look over there."

A tiny parse, no full JSON parser: find `"url"` in the body with your eyes. Then `indexOf`. Then understand that by hand is embarrassing, and stop. The lab is about a *letter*, not a second Jackson.

Add a `ping` command to the dashboard: hits httpbin, prints only `statusCode`. If it isn't 200 — print the code anyway. Someone else's kitchen's 503 is not your bug. 404 — wrong door. You won't get 0: a status always arrived *if* `send` didn't throw. It threw — there was no network.

#os[
  *Mac / WSL.* Usually just works.

  *Corporate proxy.* `send` will die on a timeout. Don't treat that with ten workarounds the first night. Do the lab on a home network.

  *Offline.* A normal outcome is a caught IOException. It counts if the message is human.
]

#exercise("J.L5", "Java")[
  A `StationPing` class or a `ping` command in the dashboard. Print the status and the *first 200 characters* of the body, not a novel. Second request: `https://httpbin.org/status/404` — see 404 and don't call it "it broke on my machine." Third: a bad host `https://no-such-module-xxxx.example` — catch the exception, print the type (class name) and the message.
]

== Lab 4. Glue it: the dashboard can save and send a letter

Not required. If you have energy left: a `report` command builds JSON by hand and… doesn't POST it anywhere, if you don't want to register for other people's APIs. Print the JSON. Next to it, a `ping` command. Two worlds: disk and network. Neither is magic.

If you want POST (not required to close the log):

```java
HttpRequest req = HttpRequest.newBuilder()
        .uri(URI.create("https://httpbin.org/post"))
        .header("Content-Type", "application/json")
        .POST(HttpRequest.BodyPublishers.ofString(toJson(energy, oxygen)))
        .build();
```

httpbin will return your JSON inside its JSON. A mirror. You'll see *what* flew, including the quotes. If it flew crooked — `toJson` is guilty, not "HTTP."

#warn[
  Don't POST your dashboard at random other people's URLs "to check." httpbin is for that. Someone else's prod is not. Station MODULE is already on duct tape; let's skip incidents.
]

== Assembling the dashboard whole, without heroics

Below is a skeleton you can type *after* the pits, not instead of them. If you copy it right away — the pits won't happen, the fingers will get nothing.

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
                return "range 0..100";
            }
        } else if (what.equals("temp")) {
            if (value < -20 || value > 40) {
                return "range -20..40";
            }
        } else {
            return "unknown sensor: " + what;
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

`StationFile.java` — `save`/`load` as in pit 4, only three keys. Field names match the file: less fantasy, fewer bugs.

`StationDash.java` — a `while (true)` loop, `split`, `quit` / `status` / `set` / `save` / `load` / `json` / `ping`.

Compiling two or three files in one folder:

```
javac Station.java StationFile.java StationDash.java
java StationDash
```

IDEA does this with a button. The terminal does it explicitly. Explicit is more useful for one evening.

Error `cannot find symbol Station` — you're compiling from the wrong folder or you forgot a file in the list. `pwd`. `ls *.java`.

#slow[
  Class `Station` is state on the counter. `StationFile` is the pantry. `HttpClient` in `ping` is letters. If in a month someone says "controller, service, repository," you've already smelled it. Only without annotations and without a paycheck.
]

=== One more pit: IDEA's working folder

Run → Edit Configurations → Working directory. If that's the project root and you thought "next to the java file," `station.txt` will be born at the root. Git will see an extra file. You won't see it in `ls` of the study folder. Both are right. The paths are different.

Print the absolute path on the first `save`. Once. Then either live with it, or fix the configuration. Don't fix this by copying the file by hand "well there it is."

=== One more pit: line separators

`Files.writeString` on Windows may write `\r\n`. `readAllLines` usually chews both. If you parse bytes yourself — don't parse bytes yourself. If you opened the file in old Notepad and it's one line — `\n` and Notepad are guilty, not the reactor.

=== HttpClient a bit more carefully

A timeout, so you don't hang forever:

```java
HttpRequest req = HttpRequest.newBuilder()
        .uri(URI.create("https://httpbin.org/get"))
        .timeout(java.time.Duration.ofSeconds(10))
        .GET()
        .build();
```

A `User-Agent` header is sometimes asked for by polite servers. httpbin doesn't fuss. Someone else's prod fusses. For the lab you don't need to pretend to be a browser.

The body can be huge. `substring(0, Math.min(200, body.length()))` — the first 200. Without `Math.min` you'll catch `StringIndexOutOfBounds`, and that'll be funny exactly once.

#exercise("J.L6", "Java")[
  Pull state into `Station`, the file into `StationFile`, leave the loop in `StationDash`. Three files compile from the terminal. README: three run commands and a five-line sample dialogue. Without a README the lab isn't closed — like in week 4, only shorter.
]

== What should stay in the fingers

- Input: don't mix `nextInt` and `nextLine`.
- Commands: split the line, check the array length.
- File: no file — a default; a broken line — a message, not a silent crash.
- JSON: text; quotes are dangerous; a library exists not out of snobbery.
- HTTP: a client, a request, a status, a body, an exception on a drop.

That's the same galley as in the computer chapter: cook, counter, pantry, letters. Only now you're writing the recipes too.

#sunday[
  Launch the dashboard from the terminal, not from the arrow. Save. Find `station.txt` via `ls` in *the* folder where `pwd` is. If the file isn't in Finder "next to the source" — congratulate yourself: you just felt a process.
]

The lab is closed when: (1) the `Scanner` pit is reproduced with your own hands; (2) `station.txt` is found via `pwd`, not via prayer; (3) JSON was checked in a validator at least once; (4) HTTP returned a non-200 at least once and you didn't panic. Spring can wait. It isn't going anywhere, unfortunately.
