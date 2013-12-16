# encoding: utf-8
#trabajo asíncrono con resque
class Worker
    @queue = 'jobs'

    def self.perform(id)
        #bajo este id hemos guardado los datos del trabajo
        datos = Resque.redis.get(id)
        puts "Voy a trabajar sobre #{datos}"
        #simulamos un trabajo costoso en tiempo
        sleep 5
        puts "Terminado el trabajo sobre #{datos}"
        #borramos el id en Redis, para que se sepa que el trabajo está terminado
        Resque.redis.del(id)
    end
end