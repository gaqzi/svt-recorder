== Summary
This is a program that given a URL to SVT Play or Play Rapport can
record a video in the highest available resolution into a file on
your harddrive. Also known as "dowloading".

I made this program because I wanted to watch a couple of
documentaries from SVT Play on my TV, but since my TV isn't connected
to a computer I needed a way to get the documentary to my TV.

== Homepage and other contact information
The Github repository for this project: http://github.com/gaqzi/svt-recorder

RDoc courtesy of rdoc.info: http://rdoc.info/github/gaqzi/svt-recorder/

If you have any suggestions or have found a bug please log it at the
issue tracker: http://github.com/gaqzi/svt-recorder/issues

Wiki: http://github.com/gaqzi/svt-recorder/wiki


== Dependencies
- Ruby 1.8.7 or later
- Rubygems

== Installation
To be able to use this program you'll have to have Ruby and Rubygems
installed.

Please look at the project wiki if these instrucations won't get you
started! http://github.com/gaqzi/svt-recorder/wiki

=== Debian/Ubuntu
If you're using Ubuntu remember to prefix the commands with sudo

  # aptitude install rubygems

=== Fedora / RPM-based
  # yum install rubygems

=== Final for Linux
When Ruby and Rubygems has finished installing type:
  # gem install svt-recorder
(somtimes gem is known under another name, try gem1.8 or gem1.9)


=== Windows
Download Ruby from http://www.ruby-lang.org/en/downloads/.
I tested this with Ruby 1.9.2 RubyInstaller.

IMPORTANT! Check the box "Add Ruby executables to your PATH" when the
installation program asks you where you want to install Ruby!

Open Run and type in: cmd

In the new command prompt type:
  > gem install svt-recorder
  [... the program is downloaded and installed ...]

You can now use the svt-recorder from the command prompt, se below for
usage.

IMPORTANT! Readline isn't working all that great in Windows so please
name the file on the command line or just press ENTER when asked to
accept the default.

== Usage
  svt-recorder <SVT URL> [output filename]
If no name is given on the command line a name will be suggested based
on the videos title.
