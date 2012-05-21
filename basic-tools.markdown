% Basic Tools
% 120 hour epic
% sax marathon

## Synopis

- The development environment
- Shell
- Leiningen
- Clojure REPL
- Version control with Git

## The development environment

We have created a virtual machine running [Ubuntu] 12.04, with Clojure and
[Vim] configured as the editor.

The virtual machine can be found on the computers in U204. You can also
[download the virtual machine][vm] and run it on your own computer. You will
need to install [VirtualBox] to run it.

After you have booted the computer to Windows 7, the virtual machine can be
found in VirtualBox. If you do not see "Ubuntu 12.04" in the list of virtual
machines in VirtualBox, you can add it with the menu action "Machine" ->
"Add". The machine can be found under the path
`C:\Temp\VirtualBox\Machines\ClojureBox`. Select the `.vbox` file in that
directory to add the virtual machine to VirtualBox's list.

<a href="img/ClojureBox.png">

![Ubuntu 12.04 with the Vim editor.](img/ClojureBox.png)

</a>

Start the virtual machine with the "Start" button. After starting the virtual
machine, it should log you in automatically to the desktop. The user name is
`clojure` and the password is `iloveponies`, should you need them.

Please tell us if you have a problem launching the virtual machine.

## The shell game

While there is nothing that forces you to use the shell for Clojure
programming, it is extremely useful to know your way around in the shell, no
matter what kind of programming you do. We will use the shell as our primary
mechanism of working with Clojure projects, REPL interaction and other things.

The shell is used with a program called Terminal. You can launch it by
clicking on the Terminal button, shown in the picture below.

![Launcher icons](img/Terminal.png)

The icons shown in the screenshot are, in order:

<div class="dl-horizontal">
Dash
:   Program launcher.
Home Folder
:   File browser.
Terminal
:   Shell session.
Workspaces
:   Organize windows into multiple workspaces.
</div>

## sh

Your home directory is located under the path `/home/clojure/`. The shell
opens this directory by default. Its short name is `~`.

The shell's *prompt* to the left of the cursor shows your username, the
computer's name, and the current directory: `username@hostname:directory$`.
The `:` and `$` characters are separators. The commands you write are printed
after this prompt.

~~~
username   hostname    directory
   |          |            |
   V          V            V
clojure@clojure-VirtualBox:~$
~~~

You can use `ls` to list the files in the current directory.

~~~
clojure@clojure-VirtualBox:~$ ls
bin      Documents  example           Music     Public     Videos
Desktop  Downloads  examples.desktop  Pictures  Templates  workspace
~~~

`cd directory` changes directories:

~~~
clojure@clojure-VirtualBox:~$ cd Documents/
clojure@clojure-VirtualBox:~/Documents$ ls
clojure@clojure-VirtualBox:~/Documents$
~~~

The `Documents` directory is empty.

`..` is the name of the parent directory:

~~~
clojure@clojure-VirtualBox:~/example/directory$ cd ..
clojure@clojure-VirtualBox:~/example$ 
~~~

Just `cd` goes to the home directory:

~~~
clojure@clojure-VirtualBox:~/example/directory$ cd 
clojure@clojure-VirtualBox:~$
~~~

`mkdir` creates a new directory:

~~~
clojure@clojure-VirtualBox:~$ mkdir example
clojure@clojure-VirtualBox:~$ cd example/
~~~

## Editor

We have preconfigured the Vim editor for working with Clojure. You can launch
it from the shell with `evim`.

<a href="img/EvimLaunch.png">

![Launching EVim.](img/EvimLaunch.png)

</a>

We will use EVim to write Clojure programs in the next chapter. You can open a
file with EVim by giving the file name to the `evim` command:

~~~
clojure@clojure-VirtualBox:~/example$ evim example.clj
clojure@clojure-VirtualBox:~/example$
~~~

## Your very own butler

[Leiningen] is a project management tool for Clojure projects. It handles
various tasks related to projects, including building the project, declaring
and fetching dependencies, opening an interactive session inside the project,
and other such things.

We use Leiningen version 2 preview on this course. It is installed on the
virtual machine.

You can run Leiningen with the `lein` command. Leiningen will print a succinct
help listing about the commands it understands.

The table below contains some important Leiningen commands.

Command         Description
-------         -----------
compile         Compile the project and report any compilation errors.
midje           Run all [Midje] tests.
repl            Open an interactive Clojure session.
new             Create a new Clojure project.

Now that we have introduced the most basic tools, we can start programming.

[Proceed, young padawan. →][next]

[Git]: http://git-scm.com
[Leiningen]: https://github.com/technomancy/leiningen
[Midje]: https://github.com/marick/Midje
[Ubuntu]: http://ubuntu.com
[Vim]: http://vim.org
[next]: training-day.html
[vm]: http://cs.helsinki.fi/ilmari.vacklin/ClojureBox.zip
[VirtualBox]: http://virtualbox.org
