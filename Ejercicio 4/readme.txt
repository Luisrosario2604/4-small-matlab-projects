La funcion barCodeDecoder tiene 3 parametros cofigurable :

           - show_for_debug (true o false) -> enseña todas las tapas del algoritmo
           - kernel_media -> Para eliminar ruido en la imagen de gradiente resultante, cuando se aplica el filtro media (he puesto 4x4 en vez de 9x9, para que sea mas sensible)

           - tresh_binary -> treshold de la etapa 5 (umbralizacion)


Tambien he decidido añadir un parametro a la funcion que es la rotacion de la imagen : eso permite a la operacion de cierre morfológico de hacerse con un kernel 7x21 o 29x7
           
