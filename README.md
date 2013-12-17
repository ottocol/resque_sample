resque_sample
=============

Ejemplo de uso de resque para ADI 2013-14. Implementa la "receta" 1.7 del libro "RESTful Web services cookbook" (O'Reilly) para procesar operaciones asíncronas. Si no está el libro accesible, ver por ejemplo [http://pablocantero.com/blog/2011/07/04/restful-how-to-use-post-for-asynchronous-operations/](http://pablocantero.com/blog/2011/07/04/restful-how-to-use-post-for-asynchronous-operations/)

Requerimientos
--------------

- [Redis](http://redis.io)
- Para las dependencias de Ruby, lo más sencillo es usar Bundler (`gem install bundler` si no está instalado. Al ejecutar `bundle install` instalará todas las dependencias)

Uso
---

Para ejecutar la aplicación de Sinatra: `ruby servidor.rb`. En otra terminal, poner en marcha los "workers" para procesar los trabajos de la cola con `QUEUE=jobs, rake resque:work`.

Abrir un navegador y acceder a `localhost:4567/index.html` (el número del puerto puede variar, dependiendo del servidor que se esté usando). Introducir algún dato en el formulario y pulsar sobre enviar. Se simula que se hará un trabajo asíncrono sobre los datos del formulario, y el servidor devuelve un JSON con el id de la tarea que está procesando los datos. Mientras se está procesando el trabajo, acceder a la URL `tareas/:id_de_la_tarea` para ver el estado.



