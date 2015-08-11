Status of Linux code as of 4/November/2011

Integration with XLog completed.  Now logs directly
into XLog (if enabled) AND writes ADIF file as
before -- consider this a backup.  :)  DO NOT USE
LOG DIRECT TO XLOG WITH YOUR PRIMARY LOG UNTIL YOU
ARE SURE IT WORKS AS EXPECTED!!!!!

Will pass along to alpha test group 5/November.

-----

Status of Linux code as of 2/November/2011

Looking good.  Can now resize main window vertically
giving more space to decoder output display.  Still
not thrilled with the hack to keep color coding in
the output display and set at top of scroll -- but,
it'll do for now.

Looking at adding direct communication to XLog. Then
Hamlib.

-----

Status of Linux code as of 1/November/2011

Mostly complete at this point.

Spectrum now working along with KV Decoder and color
coded decode display.

Still working on ListBox for decoder output as I'm
not happy with the current implementation.  In Win32
I still get normal highlight action even with the
custom color coding, but, with Linux+GTK2 I don't...
so I hacked an imperfect solution for now so you can
at least see what line you've selected.  Another
annoyance is that TListBox does not remain scrolled
to top as in Win32 so I've had to add another hack
to keep the list at top most scroll.  Still working
on this as I think I can do better.

Chasing a seemingly random core dump as well.  Not
sure where the issue is rooted but I have a feeling
it's in the compiler optimization settings or those
I passed to GFortran/GCC for the shared library.

All in all it's much better today than yesterday.  :)

-----

Status of Linux code as of 31/October/2011

It works.  Sort of.  :)

Spectrum display is currently not functional.

KV Decoder is not implemented so it's BM only.

Decoder output list box doesn't act exactly as expected.
First, it doesn't scroll to keep newest item in view as
it does under Win32 and secondly it doesn't show an item
as selected when clicked.

libJT65.so must be manually place in library search path,
should be /usr/local/lib then you must run ldconfig to
update library cache.

Requires fftw3, libsamplerate, portaudio19 (or portaudio2
depending on what you want to call it) and libgfortran3 to
be present.

Depends upon PulseAudio being present and operational as
I have relied upon PulseAudio to do most of the work for
sound device selection.

Probably will only work reasonably as expected with Ubuntu
10.04.  Ubuntu 11.xx is a nightmare, buttons don't work --
menu items work one second and not the next.  Seriously --
don't even think of playing with this on anything other than
Ubuntu 10.04 (using 10.04 LTS here).
