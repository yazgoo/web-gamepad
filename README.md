Goal
----

This projects aims to have a working web gamepad gateway for linux for remote gaming.
The goal is to reduce latency as much as possible,
    so the full state of the gamepad is not sent.


Current status
--------------

Only axes #0 and 1 are currently supported (with 3 states per axis (min, 0, max).

Architecture
------------

gamepad ======> web browser ======> server ====> uinput

The web browser gets gamepad events via gamepad API.
Then it sends those events via javascript to the server.
The server, in turn, sends it to the user level input subsystem.

Prerequisites
-------------

rubygems:

  *  net/yail
  *  cstruct
  *  sinatra


Running
-------

- Launch the web server:

```
$ cd server
$ web_gamepad.rb
```

- Launch the game you want to play to

On the client machine, connect to the webapp via your browser:
should be:

http://yourmachine:4567

Plug in the gamepad on the client machine.
