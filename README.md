# MantenimientoRPG
Programa de mantenimiento agenda de Empresas desarrollado en RPG IV Full Free, desarrollo de DMS, SDAS y programas de ayuda

Antes de desplegar el programa de mantenimiento es necesario primero crear las tablas necesarias, el maestro de empresas, el maestro de contacto y el maestro de giro de empresas
luego se realiza las pantallas sda donde el usuario tendrá interacción de las tablas. Por ultimo los programas de mantenimiento y ayuda que contendrán toda la logica de negocio para realizar el CRUD de las empresas,
se crea un programa de mantenimiento respectivamente a empresa, contacto y giro de negocio de empresa.

DDS - MAEEMP 
Tabla que contiene los datos de la empresa

DDS - MAEGRO
Tabla que contiene los datos de los giros de negocio 

DDS - MAECON
Tabla que contiene las personas de contacto de las empresas

PGM AGE0001
Mantenimiento de empresas, en este programa se encuentra toda la logica de negocios para realizar el CRUD de la empresa, se encuentra integrado los PGM HLP0001, programa de ayuda que despliega el listado de giro de empresa permitiendo al usuario poder ingresar los valores validos al momento de editar o crear una nueva empresa; PGM HLP0002, programa de ayuda que despliega el listado de personas de contacto de las empresas permitiendo al usuario poder ingresar los valores validos al momento de editar o crear una nueva empresa.

Se integra los mantenimientos de Giro y de Contacto de Persona, para giro es el pgm GR0001, donde se encuentra contenida la logica para realizar el CRUD y el GR0001FM su respectiva pantalla.
El pgm CON0001 contiene la logica de negocio para realizar el CRUD, se encuentra anexado con su pantalla SDA CON0001FM,

Por último, se encuentra el PGM REP0001 que genera la impresión de un reporte con la información mas importante para el detalle del cliente ( codigo de empresa, nombre de la empresa,
giro, descripcion de giro, representante y fecha de apertura)
