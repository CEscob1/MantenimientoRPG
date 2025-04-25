# MantenimientoRPG
Programa de mantenimiento agenda de Empresas desarrollado en RPG IV Full Free, desarrollo de DMS, SDAS y programas de ayuda

Antes de desplegar el programa de mantenimiento es necesario primero crear las tablas necesarias, el maestro de empresas, el maestro de contacto y el maestro de giro de empresas
luego se realiza las pantallas sda donde el usuario tendrá interacción de las tablas. Por ultimo los programas de mantenimiento y ayuda que contendrán los valores tanto del giro del negocio como el programa de ayuda de representante para
listar todos las personas registradas como representante legal, los programas de ayuda hacen referencia a una ventana emergente que contiene toda esta información en las ventanas de modificación y creación de nuevos registros, adicionalmente, se incluye el pgm de mantenimiento de contacto y giro de empresa para realizar el CRUD.

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

Nota: Toda la codificación es en RPG FULL FREE pero es necesario respetar algunas columnas en su codificación, en caso del archivo AGE0001.RPGLE su codificación inició a partir de la columna 8, a excepción de la matriz que contiene los arreglos, dicha matriz debe ser codificada desde la columna #1 iniciando con sus ** y en la siguiente línea los 9 mensajes de error.


Pantalla inicial donde se despliega todos los registros de empresa
![image](https://github.com/user-attachments/assets/a0154525-7329-4ad9-8ed1-540cc65a6e2b)

