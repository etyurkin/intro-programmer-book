#import "../lib-en.typ": *

= If they won't take you for backend

Sometimes the backend market looks at a junior the way an airlock looks at a meteor: politely, but it doesn't open. Kafka in the posting, "a year of experience," silence after ten letters. That doesn't mean you threw six months away. Java didn't go anywhere. The door is just different: a *pocket*. A phone in your hand is the same computer, only without a server room and with a Back button.

Android apps have been written in Kotlin for a while, but Java is alive there, and Studio eats it. You already know classes, `if`, and "why is it underlined in red." That's enough to build a calculator and not die. If it goes well — you'll catch Kotlin in a couple of weeks: it's from the same family as Java, just less water.

You don't have to put Lisp on a phone. The forty minutes of parentheses can stay. Station MODULE doesn't care which screen you fix sensors from.

This isn't "drop backend." This is a spare hatch. A calculator in an evening is cheaper than another three months of "I'll tweak Kafka and then they'll definitely take me." People need phones every day. They need servers too, but server HR is fussier.

== Where to get Studio (and why the first evening is pain)

The site: #link("https://developer.android.com/studio")[developer.android.com/studio] — official, for Mac, Windows, and Linux. Don't download "android studio cracked" from page fourteen of search. That isn't savings, that's an adventure with a virus. The station is already on duct tape; it doesn't need a virus.

It takes a long time to install: Studio itself, the Android SDK, an emulator, system images. Disk space is gigabytes, not "one more VS Code." Twenty gigabytes is a normal bill, not a bug. If the disk is a hundred and ninety-eight are used — either clean, or a USB phone without an emulator. An emulator on a packed disk dies bashfully, with android-30 errors that aren't about android-30.

#os[
  On a Mac, Studio is native; Apple Silicon (M1/M2/M3) wants an *arm* emulator image, not an old x86 "because the 2019 guide said so." Studio usually hints itself. If you downloaded x86 onto an M-chip — it'll either be slow through translation, or not at all. Don't hero it.

  On Windows this is a *native* window, not WSL: the emulator needs Hyper-V or its own engine, and inside Ubuntu-in-Windows it often sulks. WSL runs your Spring beautifully. A phone emulator — no, don't mix up the doors.

  Linux: possible, but GPU drivers and KVM are a separate watch. If Linux is "so I have it" and the main laptop is Windows — put Studio on Windows. One pain is better than two.
]

First launch: a wizard, a Google login is optional for a calculator (you can skip it). Then SDK Manager will download another chunk of the internet. Tea. Not two teas and "I probably broke it" — that's how an Android progress bar breathes.

New Project → *Empty Views Activity* (not Compose, don't panic at the word Jetpack yet). Language: *Java*. Minimum SDK — whatever Studio suggests, not the most ancient and not the newest "pixels from the future only." A package name like `com.example.calc` — you'll replace it later if `example` is embarrassing. For study, `example` isn't embarrassing.

The project indexes for minutes the first time. The Gradle strip at the bottom wriggles. A red `R` in the first two minutes is often "hasn't woken up yet," not "you're an idiot." Build → Make Project. Wait. If after Make `R.id` is still red — Build → Clean Project, then Make again. Sometimes Studio just hasn't woken up. Like a sensor on MODULE.

=== Emulator versus a cable: two ways to see a button

Emulator: Device Manager → Create → some Pixel without a 16K screen and without folding wings. System image — a fresh stable one, with Google APIs, not "Android Canary from Mars." First start — tea. Sometimes two. A cold emulator start on a weak laptop is a small industry sin, not yours.

If the laptop is weak, the fan screams, the emulator draws a slideshow — *don't hero it*. Turn on USB debugging on your own phone and run on hardware:

1. Settings → About phone → seven taps on Build number. "You are now a developer" appears. Yes, seven. That isn't a 2012 joke, it's still like that.
2. Developer options → USB debugging.
3. A cable that *moves a file*, not "charge only" from a drawer.
4. Allow debugging on the phone screen when it asks. The "always from this computer" checkbox — to taste.
5. At the top of Studio the device should change name from the emulator to the phone model.

Not embarrassing. On a real station they also look at the sensor in the corridor first, they don't build a corridor simulator.

#warn[
  A work phone is a separate world: corporate profiles, "nope." For study, your own device is fine. Don't put debug on grandma's phone "for a minute." Grandma didn't sign up for this quest.
]

If Studio doesn't see the phone: another cable, another port, on Windows — the manufacturer's driver, File transfer / PTP mode, not Charge only. That's the dullest pain in the chapter. Dull pain is treated by trying things, not by a new textbook.

=== Licenses, a hypervisor, and Gradle that is "still downloading"

The first build can spend half an hour downloading the internet into `~/.gradle`. It isn't stuck if the bar is moving. If it hasn't moved in ten minutes — look at the network, a company proxy, a VPN that cuts dl.google.com. On Windows antivirus sometimes pets every jar in the Gradle cache — then the build is "eternal." An exclusion on the `.gradle` folder saves nerves. Don't turn antivirus off entirely "per a forum guide."

SDK licenses: Studio usually asks Accept. If the log says `You have not accepted the license agreements` — SDK Manager, checkboxes, Accept. On the command line you'll someday meet `sdkmanager --licenses`. Today a GUI button is enough.

An emulator on Windows without virtualization is a slideshow or a refusal. In BIOS/UEFI you turn on VT-x / AMD-V. On a home laptop that's sometimes "I don't know what BIOS is." Microsoft's docs on Hyper-V and WSL2 are already on the machine if you installed Docker Desktop: virtualization is often already on. If Docker is alive and the emulator isn't — it isn't necessarily BIOS; check whether Hyper-V ate everything, and which image you downloaded.

On a Mac "the emulator won't start" is often fixed by: download the system image, Cold Boot Now in Device Manager, don't panic at the first `Waiting for target device`. Cold boot is like restarting the station, not like "delete everything."

=== Red that doesn't mean "you're an idiot"

`SDK location not found` — Studio doesn't know where the SDK is. File → Settings → Appearance & Behavior → System Settings → Android SDK (on a Mac that's Android Studio → Settings). The path has to exist. If you moved to a new disk — the path is old, Studio screams. Point it at the new one, don't reinstall everything from scratch.

`Failed to install the following Android SDK packages` — network, license, or the disk ran out. Download through SDK Manager. Don't download a "sdk-tools" zip from page fourteen.

`INSTALL_FAILED_INSUFFICIENT_STORAGE` on the emulator — Wipe Data in Device Manager or a new, bigger AVD. Phone: clear the cache, that's daily life, not Java.

`Duplicate class` / Gradle conflict — you added a library Studio already pulls. For a calculator you barely need libraries. If you wandered into Firebase "for five minutes" — there it is. Throw it out until the calculator counts.

A red `R` after renaming an id in XML — Make Project. The name in XML and `R.id.name` have to match letter for letter. `plus` and `Plus` are different. Android doesn't forgive case, like Java classes, only meaner, because the error doesn't surface right away.

Invalidate Caches is the last button, not the first. First Make, Clean, "are you running the right module." Invalidate is like restarting the whole station: it helps when nothing makes sense anymore, and sometimes it doesn't help.

Also: you're running the wrong Run Configuration — the green arrow is on a library, not on `app`. On the left pick `app`. Or the device is "No devices": the emulator didn't wait, the phone fell off. That isn't Java. That's a plug in the wrong outlet.

== A calculator on the knee

Two numbers, plus and minus, then multiply and divide, the answer on the screen. Not a bank and not Telegram. But you'll see: a button → your Java code → digits. Like `Scanner` in the console, only with a finger.

In `activity_main.xml` (the Code tab, not just Preview):

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical"
    android:padding="24dp">

    <EditText
        android:id="@+id/a"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:hint="first number"
        android:inputType="numberDecimal|numberSigned" />

    <EditText
        android:id="@+id/b"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:hint="second number"
        android:inputType="numberDecimal|numberSigned" />

    <Button
        android:id="@+id/plus"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:text="+" />

    <Button
        android:id="@+id/minus"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:text="-" />

    <Button
        android:id="@+id/mul"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:text="×" />

    <Button
        android:id="@+id/div"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:text="÷" />

    <TextView
        android:id="@+id/out"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:textSize="24sp"
        android:text="?" />
</LinearLayout>
```

`LinearLayout` — boxes in a column. `orientation="vertical"` — like a list in a corridor. `EditText` — a field you poke. `inputType` hints to the keyboard "numbers, minus and a dot are ok," not a whole novel. `TextView` — only shows, you don't type there with a finger.

The Preview tab lies less often than it used to, but Code is the source of truth. If Preview is pretty and the phone has no button — you were looking at the wrong XML.

`dp` is "density," so a button isn't microscopic on one phone and huge on another. `sp` is the same for text, and it also respects "large font" in settings. Don't set text height in `dp` without a reason: a person with bad eyesight has a right to large letters. `match_parent` — take the parent's width/height. `wrap_content` — by contents. If everything is `wrap_content` in a column — the fields are fine. If a `ListView` is also `wrap`, it may shrink and you'll decide the list "doesn't work."

In `MainActivity.java` — the same Java, only the entrance isn't `Scanner`, it's fields on the screen:

```java
package com.example.calc;

import android.os.Bundle;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        EditText a = findViewById(R.id.a);
        EditText b = findViewById(R.id.b);
        TextView out = findViewById(R.id.out);
        Button plus = findViewById(R.id.plus);
        Button minus = findViewById(R.id.minus);
        Button mul = findViewById(R.id.mul);
        Button div = findViewById(R.id.div);

        plus.setOnClickListener(v -> show(out, num(a) + num(b)));
        minus.setOnClickListener(v -> show(out, num(a) - num(b)));
        mul.setOnClickListener(v -> show(out, num(a) * num(b)));
        div.setOnClickListener(v -> {
            double y = num(b);
            if (y == 0) {
                out.setText("can't");
                return;
            }
            show(out, num(a) / y);
        });
    }

    private void show(TextView out, double value) {
        out.setText(String.valueOf(value));
    }

    private double num(EditText field) {
        String s = field.getText().toString().trim();
        if (s.isEmpty()) {
            return 0;
        }
        try {
            return Double.parseDouble(s);
        } catch (NumberFormatException e) {
            return Double.NaN;
        }
    }
}
```

Replace the package `com.example.calc` with the one Studio picked itself. Green arrow. If `R.id` is red — Clean; sometimes Studio just hasn't woken up.

=== Empty field, letters, and divide by zero — this isn't "later"

Empty input: a person opened the app and immediately poked `+`. Without a check, `parseDouble("")` screams `NumberFormatException`, the activity dies, Android draws "the app has stopped." That isn't how you fix an oxygen sensor on the station: you don't blow the compartment because someone forgot a digit.

In the code above, empty → `0`. That's a teaching gesture, like in the console "zero if they stay quiet." You can do otherwise: write "enter two numbers" in `out` and don't compute. Pick one and stick to it. The main thing is *don't crash*.

`NumberFormatException`: `inputType` is not an iron curtain. Weird stuff still leaks from the keyboard sometimes, and from paste even more. `parseDouble` has a right to be offended. Catch it. `NaN` in the answer beats a crash; even better — the word "nope" on the screen. `Double.NaN` in `+` infects the sum, the user will see `NaN`. You can check `Double.isNaN` and write "not a number." Do that when the calculator already adds.

Divide by zero on a phone doesn't blow the station: `double` will be `Infinity`. The user is better off with "can't" than `Infinity` like in a math textbook they didn't ask for. We don't use integer division: the fields are decimal.

#slow[
  With a finger, not with eyes.

  1. Enter `2` and `3`, tap `+`. Should be `5.0` or `5`.
  2. Clear both fields, tap `+`. Must not crash. Either `0.0`, or your message.
  3. Enter `8` and `0`, tap `÷`. "can't", not a crash, not `Infinity`.
  4. Multiply `1.5` and `2`. If you got `2` — you cut the fraction to `int` somewhere. Go back to `double`.
]

#exercise("A.J1", "Java")[
  The `×` and `÷` buttons are alive. Divide by zero — the text "can't", the app is alive. A screenshot in the README of the `android-calc` repo.
]

#exercise("A.J2", "Java")[
  An empty field doesn't kill the activity. Catch `NumberFormatException`. Write in `out` that the input is bad, or carefully treat empty as zero — but then *write in the README* which rule. A hidden "empty is zero" with no words is a trap for future you.
]

You can be explicit, without NaN:

```java
private Double parseOrNull(EditText field) {
    String s = field.getText().toString().trim();
    if (s.isEmpty()) {
        return null;
    }
    try {
        return Double.parseDouble(s);
    } catch (NumberFormatException e) {
        return null;
    }
}
```

In the listener: if `null` — `out.setText("enter numbers")` and `return`. Empty and "asdf" behave equally honestly. Zero as "the human is silent" sometimes lies: `2+` empty became `2+0`. For a station calculator it's better to yell than to invent.

== Lifecycle: why an activity isn't "just main"

In the console there was `main`. You called it — it lives until it ends. On a phone the screen is longer-lived and fussier: the person minimized, someone called, they rotated the phone, the system is low on memory. An activity isn't an eternal process. It's a watch with a log "I'm on screen now / I'm not."

Roughly, no dissertation:

- `onCreate` — born. Here `setContentView`, here you find buttons. The first time, or after the system killed it.
- `onStart` — they *can* see me now.
- `onResume` — I'm in the foreground, they're poking me.
- `onPause` — something covered you: the shade, a call, another activity on top. Don't compute big sums here, here is "pause."
- `onStop` — I'm not visible (they went to another screen, they pressed Home).
- `onDestroy` — that's it, I'm off the watch. Not a fact that "the user pressed back": the system also kills when it's stingy with memory.

Screen rotation by default often *kills* the activity and creates it again. So a field you kept in an ordinary variable may forget the digit. For a five-minute calculator that's tolerable. For a task list — already insulting. Later there will be `ViewModel` and "state survives rotation." Today it's enough to know the name of the trouble: "I rotated the phone and the counter reset — that isn't magic, they recreated `onCreate`."

#slow[
  Put a log in every method:

  ```java
  Log.d("CALC", "onCreate");
  ```

  The same in `onStart`, `onResume`, `onPause`, `onStop`. Logcat at the bottom of Studio, filter `CALC`. Press Home. Come back. Rotate the phone. Read the tape. This isn't ritual for ritual's sake: you'll see that Home is not equal to "the process died," and rotation often is equal to "the activity died, a new one was born."

If Logcat is empty: Logcat tab on the right, the device is the same one as the green arrow, level Debug, not Error. The app package in the filter if there are too many logs: the emulator is chatty, like MODULE's sensors at a full moon. `Log.d` isn't visible at Error level — you're looking at the wrong shelf.
]

Officially and without our jokes: the #link("https://developer.android.com/guide/components/activities/activity-lifecycle")[lifecycle guide] in the Android docs. English. We warned you back in the preface.

Rotation and the death of an activity aren't the only trap. The system can kill the process when you've been in the background a long time, and then return you to `onCreate` with `savedInstanceState`. For the calculator: if you want the two fields not to wipe, put the strings in a `Bundle` in `onSaveInstanceState` and read them in `onCreate` if `savedInstanceState != null`. That's already "state survives the watch." Not required the first evening. Required to know that a class variable is not a safe.

#exercise("A.J3", "Java")[
  Logs on `onCreate` / `onStart` / `onResume` / `onPause` / `onStop`. README: what prints if you press Home and come back, and what — if you rotate the phone. In your own words, five sentences. Not a paste from the guide.
]

== A task list on the phone — a sketch, not a third textbook

The calculator counts. You already wrote a to-do list in the console and over HTTP. On a phone it's the same `ArrayList<String>`, only the list is *drawn*. Don't drag in Firebase, maps, and "like Instagram" right away. First a list that *shows*.

A sketch for one or two evenings, not for Google architecture:

1. A new screen or the same one: an `EditText` "title", an "add" button, a `ListView` or `RecyclerView`. The first time, `ListView` + `ArrayAdapter` is simpler. `RecyclerView` is more correct and meaner. If `ListView` worked — you already won. Then `RecyclerView`.
2. In memory, `ArrayList<String> tasks`. You added — `adapter.notifyDataSetChanged()`. You minimized the app — the list died. Like month 1. Familiar.
3. Want immortality — `SharedPreferences` (a small key-value pile) or a file, like `tasks.txt`. SQLite / Room — when the list is alive and you're angry at the file. Not the first evening.
4. Later you can tap an item and mark it done. Later — talk to *your* `task-manager` over HTTP. That's already "the phone as a client to your server." Pretty for a portfolio. First let the list live without a network: on the subway, server MODULE doesn't answer.

XML for the sketch (don't copy ids blindly if they're already taken):

```xml
<EditText
    android:id="@+id/title"
    android:hint="task"
    android:layout_width="match_parent"
    android:layout_height="wrap_content" />

<Button
    android:id="@+id/add"
    android:text="add"
    android:layout_width="match_parent"
    android:layout_height="wrap_content" />

<ListView
    android:id="@+id/list"
    android:layout_width="match_parent"
    android:layout_height="0dp"
    android:layout_weight="1" />
```

`layout_weight` in a vertical `LinearLayout` is "take the rest of the screen." Without it the list sometimes shrinks to a strip and you think Android is broken. The layout is squashed, not Android.

In Java — a sketch, not sacred code:

```java
List<String> tasks = new ArrayList<>();
ArrayAdapter<String> adapter = new ArrayAdapter<>(
        this, android.R.layout.simple_list_item_1, tasks);
list.setAdapter(adapter);
add.setOnClickListener(v -> {
    String t = title.getText().toString().strip();
    if (t.isEmpty()) {
        return;
    }
    tasks.add(t);
    adapter.notifyDataSetChanged();
    title.setText("");
});
```

Don't put an empty task. You already set that rule in the service on the server. Same here: the watchstander doesn't take an empty note.

Want the list to survive the Back button — a sketch on `SharedPreferences`:

```java
prefs.edit().putString("tasks", String.join("\n", tasks)).apply();
```

Read on start: `getString`, `split`, into the list. That isn't a database. That's `tasks.txt` in a pocket. For ten items it's enough. For a thousand — Room, when you live that long. Don't write your own SQL "because on the backend it's Postgres": on a phone the daily life is different, the disk is different, "the process got killed" is different.

Network to your `task-manager`: on the emulator `localhost` is *the emulator itself*, not your Mac and not Docker. People often write `10.0.2.2` as "the host machine of the emulator." On a real phone on the same Wi‑Fi — the computer's LAN IP, and the server has to listen on more than `localhost`. That's the same trap as `db` versus `localhost` in Compose, only in a pocket. While the list has no network — you don't owe yourself that trap yet. When you go there — a README, not "well it's local."

Cleartext HTTP: Android by default doesn't like `http://` without TLS. A study server at `http://10.0.2.2:8080` may get `Cleartext HTTP traffic not permitted`. For study, `usesCleartextTraffic` or a network-security-config — yes, with a note in the README "local only." You don't take that to prod. Like the study password `task/task`: fine at home, not onto Earth.

#exercise("A.J4", "Java")[
  A list sketch: a field, a button, a `ListView`, three tasks with a finger. A screenshot. Doesn't have to survive rotation and disk. In the README, honestly: "memory only for now." Honesty is again prettier than a checkbox "almost like Todoist."
]

#github[
  Repo `android-calc`. README: how to open it in Android Studio, which API, a screenshot. That's a portfolio too — "I didn't only poke JSON in Postman." If you got to the list — either a second repo `android-tasks`, or a folder in the same one. Don't mix calculator and list in one chaos without words unless you have to.
]

#warn[
  Don't drag in Firebase, maps, and "like Instagram" right away. First a calculator that *counts*. Then a task list on the phone — you already wrote it in the console.
]

== Manifest, strings, and a second door

`AndroidManifest.xml` is the app's passport. Without it the system doesn't know what the activity is called and which one to start. Studio writes it itself. You go in there when:

- you add a *second* activity — you have to declare it, or "activity not found";
- you need the internet: `<uses-permission android:name="android.permission.INTERNET" />`;
- you want the icon and the name on the home screen to not be `com.example.calc`.

Don't hardcode the home-screen name as a string in the manifest. Put it in `res/values/strings.xml`:

```xml
<resources>
    <string name="app_name">MODULE calculator</string>
    <string name="hint_a">first number</string>
</resources>
```

On the screen XML: `android:hint="@string/hint_a"`. Why: tomorrow a translation, the day after a large font, and you aren't crawling through every layout. For study, two strings are already an adult gesture. For Instagram — required. We aren't Instagram. Two strings are still worth it.

A second activity is a second watch. New → Activity → Empty Views Activity, name `AboutActivity`. Studio usually writes it into the manifest itself. The jump:

```java
startActivity(new Intent(this, AboutActivity.class));
```

`Intent` is a note: "open this class." You can put extra data:

```java
Intent i = new Intent(this, AboutActivity.class);
i.putExtra("last", out.getText().toString());
startActivity(i);
```

On the other side: `getIntent().getStringExtra("last")`. That isn't HTTP. That's a note in a pocket while both screens are in one process. The process got killed — the note died. For "about the app" it's enough. For a task list that has to survive rotation — `onSaveInstanceState` or ViewModel, not Intent.

#slow[
  An "about the station" button on the calculator. Second screen: two sentences and the last computed number. Back — the system arrow, you don't program it the first evening. If the number on the second screen is empty — you forgot `putExtra` or typo'd the key. Keys are strings, Java won't check them. A `last` / `Last` typo is a classic, like `R.id.plus` and `Plus`.
]

#exercise("A.J5", "Java")[
  A second activity, Intent, `putExtra` with the calculator's last answer. A screenshot of both screens. If the system Back doesn't return to the calculator — you probably wandered into some weird launchMode in the manifest. Put it back the way Studio set it.
]

== Gradle: why the green arrow sometimes thinks for half an hour

An Android project isn't one `javac Hello.java`. It's Gradle: a script that downloads the SDK, dependencies, resources, glues an APK. Two files you touch:

- `build.gradle.kts` (or `.gradle`) of the `app` *module* — `minSdk`, `targetSdk`, dependencies;
- sometimes the root one — repositories to download from.

`minSdk` is the oldest Android you'll agree to. The lower it is, the more grandma phones, the more "this API isn't there." For study, leave what Studio suggested. Don't set 14 "to cover everyone": you won't cover them, but `HttpURLConnection` will suddenly be from 2009.

Dependencies for a calculator are almost unneeded. `implementation(...)` shows up when you go into the network or into Room. Each line is a promise to download the internet and someday catch a version conflict. An empty calculator with twenty libraries is a station with no walls but a spare-parts catalog.

The first build downloads the world. The second is faster. `Build → Clean` — when Studio is losing its mind, not every time "just in case." Clean every time is like rebuilding the reactor before every sensor check.

#os[
  The Gradle cache lives in the home folder: `~/.gradle` on a Mac and in WSL, `C:\Users\<you>\.gradle` on native Windows. Android Studio is a native Windows window, not WSL: don't look for the cache inside Ubuntu, it isn't there. The disk ran out — most often it's `.gradle` that bloated, plus emulators in `Android/Sdk`.
]

== Rotation memory and SharedPreferences without mysticism

Rotation kills the activity. Class variables die. An `ArrayList` in a `MainActivity` field — too. So a "three tasks with a finger" list empty after rotation isn't an Android bug, it's you storing daily life in a creature the system has a right to kill.

A minimal safe for one screen:

```java
@Override
protected void onSaveInstanceState(Bundle outState) {
    super.onSaveInstanceState(outState);
    outState.putString("a", a.getText().toString());
    outState.putString("b", b.getText().toString());
}
```

In `onCreate`:

```java
if (savedInstanceState != null) {
    a.setText(savedInstanceState.getString("a", ""));
    b.setText(savedInstanceState.getString("b", ""));
}
```

A `Bundle` is a key-value bag the system *may* return on recreation. Not a database. Not a file. Rotation and "not enough memory in the background" — yes. You reinstalled the app — no.

To survive being closed — `SharedPreferences`:

```java
SharedPreferences prefs = getSharedPreferences("station", MODE_PRIVATE);
prefs.edit().putString("tasks", String.join("\n", tasks)).apply();
```

Read: `getString("tasks", "")`, `split`, into the list. `apply()` is async, doesn't block the finger. `commit()` waits for disk, rarely needed for study. Don't put passwords in there "like in Spring Security." That's a note on the fridge, not a safe.

ViewModel is a pocket that survives rotation but doesn't survive process death. For an evening list you can skip it. For an Android-junior interview the word is useful to know: "screen state is in the ViewModel, disk is in the repository, the activity only draws." You've already heard this as controller / service. Same gesture, different hatch.

#exercise("A.J6", "Java")[
  Calculator: two fields survive rotation through a `Bundle`. README: what happens if you kill the app from Recents and open it again (the fields are *not* required to survive — that's honest). Then, if you want — a task list in SharedPreferences, so Recents no longer wipes it.
]

== The phone as a client to your server

When a list in memory gets boring, you can visit *your* `task-manager`. That's pretty for a portfolio: "here's the backend, here's the pocket." Read the traps first, then write `HttpURLConnection`.

- Emulator: `localhost` is the emulator itself, not the Mac and not Docker. The host machine is often `10.0.2.2`. A real phone on Wi‑Fi — the computer's LAN IP, the server listens on `0.0.0.0`, not only `127.0.0.1`.
- HTTP without TLS Android cuts. A study cleartext flag — in the README "local only."
- You can't do network from the UI thread: `NetworkOnMainThreadException`. Either `new Thread`, or (better) an executor. Otherwise the calculator "froze" on slow Wi‑Fi, and that's you going to the network from `onClick`.
- JSON: the same text curl printed in month 2. `org.json.JSONObject` is built in. Dragging Jackson onto a phone for two fields is greed.

A sketch, not a sacred client:

```java
new Thread(() -> {
    try {
        URL url = new URL("http://10.0.2.2:8080/health");
        HttpURLConnection c = (HttpURLConnection) url.openConnection();
        c.setConnectTimeout(3000);
        int code = c.getResponseCode();
        runOnUiThread(() -> out.setText("health " + code));
    } catch (Exception e) {
        runOnUiThread(() -> out.setText(e.getMessage()));
    }
}).start();
```

`runOnUiThread` — back to the screen: you can touch a `TextView` only from the UI watch. Otherwise a rare crash that on the emulator is "sometimes." The station doesn't like those "sometimes."

#exercise("A.J7", "Java")[
  A "ping" button: GET `/health` of your server from the emulator *or* from the phone. In the README — which URL and why not `localhost`. If the server isn't running — an error on the screen, not a crash. That's a client.
]

== Kotlin from the same button, not from a new textbook

Studio can mix Java and Kotlin in one module. Don't. But seeing once what a listener looks like is useful — so "Kotlin required" in a posting doesn't sound like another language from Mars.

```kotlin
plus.setOnClickListener {
    out.text = (num(a) + num(b)).toString()
}
```

The same `setOnClickListener`, fewer letters, `text` instead of `setText`. Old ideas. New syntax. Learn it when the Java calculator *counts*, the list *shows*, rotation *doesn't wipe* the fields. Earlier — three magics, zero fixes.

Official courses: #link("https://developer.android.com/courses")[developer.android.com/courses] — often Kotlin right away. You can watch them like subtitles: "aha, that's my `onCreate`." Not as an order to throw Java out.

== An interview from a phone, if the hatch became a door

They won't ask Kafka. They'll ask:

- how an activity isn't `main`, what happens on rotation;
- why `strings.xml`, why the manifest;
- why network isn't from the UI thread;
- how a study `ListView` differs from a "proper" `RecyclerView` (`RecyclerView` reuses cards, a list of a thousand doesn't draw a thousand views at once);
- where to put state: screen / ViewModel / disk.

The answers are already in this chapter plus month 1 (the list) and month 2 (HTTP). Don't learn "Android Architecture Components" as a pack before the first screen. A screen that opens, plus an honest README — again stronger than a certificate.

An APK onto your phone without the store: Build → Build APK(s). The file is in `app/build/outputs/apk/`. On the phone, allow installs from this source. That isn't publishing to Google Play. Play is a console, a signature, fees, moderation. For a junior, "here's an APK and here's a screenshot" is enough. The store can wait for an offer or for stubbornness.

=== `RecyclerView` in two words, when ListView is no longer embarrassing

`ListView` for study is honest. In an interview they'll say "why not RecyclerView?" Short answer: RecyclerView doesn't draw a thousand rows at once — it keeps about ten cards on screen and *reuses* them when you scroll. For three tasks that's theater. For a feed like the grown-ups — a necessity.

It's meaner to write: your own `Adapter`, your own `ViewHolder`, `onCreateViewHolder` / `onBindViewHolder`. Studio can scaffold it. Don't copy the first 2016 guide with `android.support` — that's a dead package. Now it's `androidx.recyclerview`.

Hatch rule: ListView alive → then RecyclerView. Not the other way around. Otherwise you'll spend a week befriending a holder, and the plus button still won't add.

=== When the app "has stopped"

A red dialog on the phone isn't mysticism. In Logcat look for `FATAL EXCEPTION` and the first line of *your* package, not three screens of `android.view`. Then ordinary Java: NPE, the wrong id, network from the UI thread, `findViewById` returned null because the layout is different.

`NullPointerException` on `plus.setOnClickListener` — the button isn't in *this* XML. You're looking at `activity_main`, and `setContentView` pulls another layout. Or the id `plus` is in Preview, and in Code there's a typo. Match `R.id` and XML letter for letter.

`CalledFromWrongThreadException` — you touched a `TextView` from `new Thread`. Bring it back through `runOnUiThread`. That isn't "Android is hard." That's two watches: network and screen, and they aren't the same.

Read the stack top-down, like in Spring: the first *your* line matters more than `Handler.dispatchMessage`. Paste it into search without the package name `com.example.calc` if that's embarrassing. The error doesn't change from that.

== Next — the docs, not a third textbook

Official and to the point:

- #link("https://developer.android.com/docs")[developer.android.com/docs] — how an activity, a layout, a lifecycle are built. English. We warned you.
- #link("https://developer.android.com/courses")[developer.android.com/courses] — Google's courses, often with Kotlin. Don't panic: new syntax, old ideas.
- Search in Studio: double Shift, the name `findViewById` — you'll jump into the sources. That isn't magic, that's Java.

If backend took you after all — you can leave Android alone. If it didn't — a calculator in an evening is cheaper than another three months of "I'll tweak Kafka and then they'll definitely take me." People need phones every day. They need servers too, but server HR is fussier.

Kotlin, when the calculator gets boring: the same `onCreate`, the same ids, fewer words around them. Don't learn Kotlin *instead of* the first screen. The screen matters more than the dialect.

View Binding and Jetpack Compose are words Studio whispers from the doorstep. Binding — so you don't write `findViewById` by hand. Compose — another way to draw a screen, without XML. Both can wait until `findViewById` and XML make sense to you. Otherwise you'll learn three magics at once and fix none. The station likes one sensor per evening.

Dark theme: a `Theme` in `themes.xml`, or just a dark background on the `LinearLayout` and light text. For a portfolio, a "light / dark" screenshot looks more grown-up than one more dependency. Don't install a theme library for two colors.

#sunday[
  Add a `×` and `÷` button if somehow they still aren't there. Then a darker theme. Then "hey, this could be a station calculator: watts and oxygen." If you slip into a game — that's normal. That's how Barski meant it, only he had orcs and we have orbit.
]

#rule[
  A spare hatch isn't shame. Shame is a year of pretending "just a little more backend" and not having a single screen that opens without you. A green arrow on a phone counts. Even if it only computes `2+2`.
]

If in a week the calculator is boring and backend is still silent — it isn't embarrassing to stay on the phone longer. Same Java. An Android-junior interview also asks about lists, lifecycle, and "why it crashed." You already know what to say about empty input. That's more than "I downloaded Studio."

Forty minutes of Lisp fit this hatch too. Parentheses don't compete with XML. Evening: XML and buttons. Morning: `ev` or an oxygen sensor. Station MODULE isn't jealous of a Pixel.

A screenshot in the README isn't vanity. It's proof that you *had* a green arrow, not "well it kind of launched." A phone on the desk, a calculator with `2+2`, a date. Like curl in month 2. Same gesture, different porthole.

If Studio is still downloading the SDK while you read this — let it download. Tea. Then Empty Views Activity, Java, two buttons. Not a third textbook. Not Firebase. Two buttons. Station MODULE also once started with one sensor that lied, and a person who noticed.

Hatch checklist, if you forgot:

- Studio from developer.android.com, not "cracked";
- Empty Views Activity, Java;
- emulator or USB debugging;
- plus, minus, multiply, divide, empty doesn't crash;
- a screenshot in `android-calc`.
- a second door (`AboutActivity`) — if it isn't scary anymore;
- fields survive rotation — if it really isn't scary anymore.

Next, Google's docs, not a third textbook and not Firebase "for five minutes." Station MODULE also once started with one sensor.
