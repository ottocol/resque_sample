# encoding: utf-8
require 'sinatra'
require 'redis'
require 'resque'
require 'securerandom'
require 'json'
require_relative 'worker'

use Rack::Session::Pool

configure do
  Resque.redis = Redis.new
end

#simulamos la petición de procesamiento de un recurso asíncrono porque puede tardar un tiempo considerable
#por ejemplo: generación de un pdf
post '/asinc' do
    #generamos un id único para el recurso
    id = SecureRandom.uuid
    #supongamos que en el parámetro HTTP "datos" está la información que necesitamos para trabajar
    Resque.redis.set(id, params[:datos])
    #ponemos el trabajo en la cola de resque
    Resque.enqueue(Worker, id)
    #202 significa que el recurso todavía no está accesible
    status 202
    headers 'Content-Location' => "http://#{request.host}:#{request.port}/tareas/#{id}"
    {:estado => "pendiente",
     :mensaje => "Su petición está pendiente",
     :id_tarea => id}.to_json
end


#a esta URL haría periódicamente polling el cliente para ver si el recurso está listo
get '/tareas/:id_tarea' do
   id = params[:id_tarea]
   #si el trabajo está terminado, el id del recurso estará borrado de Redis
   if Resque.redis.get(id).nil?
     status 303
     headers 'Location' => "http://#{request.host}:#{request.port}/resources/#{id}"
   else
     status 200
     {:estado => "pendiente",
      :mensaje => "Su petición está pendiente"}.to_json
   end
end

get '/resources/:id_resource' do
   "Aquí debería estar el recurso con id:#{params[:id_resource]}. Pero ya se sabe que esto es un ejemplo de mentira"
end



