!say_hello.

+!say_hello
    <- .send(bob, tell, greeting("hola mundo")).
    
{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }
