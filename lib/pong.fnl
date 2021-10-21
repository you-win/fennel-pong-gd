(local PongFennel {:extends "StaticBody2D" :parent nil})

(fn PongFennel._ready []
    (print "hello world!"))

(fn PongFennel._process [delta]
    (print "ree"))

{: PongFennel}
