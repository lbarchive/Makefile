=====
Notes
=====


.. contents:: **Contents**
   :local:


Compilation
===========

Respect ``CC``, ``CFLAGS``, ``CPPFLAGS``, and ``LDLIBS``.

* ``CC`` defaults to ``gcc``
* ``CFLAGS`` defaults to ``-std=c99 -g -O2``, appended by ``-Wall -Wextra -pedantic``


Variables
=========

* ``PACKAGE``, ``VERSION``, and ``PROGRAM``
* ``PREFIX`` defaults to ``/usr/local``, and ``DESTDIR``


Switches
========

* ``debug`` defaults to ``0``, ``1`` to add ``-DDEBUG -O0`` to ``CPPFLAGS``


Targets
=======

* ``clean`` and ``clobber``
* ``install``, ``install-strip``, and ``uninstall``

``.PHONY`` declaration
----------------------

I don't like the following fashion for declaring phony targets, they all squeeze into a single line, it's messy.

.. code:: make

  .PHONY: all clean install

It's very likely that you would forget to add to the list or take one off if you remove a target. However, I did use it for some time until I discovered another, which I couldn't remember where I first saw this:

.. code:: make

  .PHONY: all
  all: main
  	# do something

  .PHONY: clean
  clean:
  	$(RM) *.o

It's cleaner in my opinion, nothing wrong about it, but when I saw cmake generated in this way, I jumped the ship right away:

.. code:: make

  all: main
  	# do something
  .PHONY: all

  clean:
  	$(RM) *.o
  .PHONY: clean

Truly, there is nothing particularly special about it, it simply moves all the declarations right after the ends of respective targets. To me, it's like closing tag of HTML, the targets line is the opening tag. It's kind of like what you see some people would add a comment after ``}`` to indicate which block to end in C:

.. code:: c

  int
  foobar(void)
  {
    /* something */
    if (dummy == c)
    {
      /* something */
    }  /* dummy == c */
  }  /* foobar */

This is why I feel it's like closing tag. 
