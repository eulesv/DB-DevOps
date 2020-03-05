# DB-DevOps
Repositorio público con contenido correspondiente a la serie de artículos [Devops y Bases de Datos](https://eulesv.github.io/devops/db/2020/02/26/db-devops.html).

## Estrategia de Versionamiento

Los archivos siempre son modificados manualmente durante los incrementos son:
- apply.sql
- sampledata.sql
- undo.sql

*apply.sql* y *undo.sql* contienen marcadores especiales que deben ser respetados, los cambios sólo deberán ser ingresados entre estos marcadores

```
--********************
-- BEGIN CHANGES CODE
--********************
--##!



--##!
--********************
-- END CHANGES CODE
--********************
```

Esta es una implementación basada en las [propiedades extendidas](https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-addextendedproperty-transact-sql?view=sql-server-ver15) de Microsoft SQL Server para el almacenamiento de la metadata, en otros motores de bases de datos es posible utilìzar tablas como repositorios de metadata. (Los objetos ``SetCurrentVersion`` y ``CheckVersion`` deberán ser modificados correspondientemente)

### DbVersionTool.ps1
Herramienta de actualización de versiones, procesa los archivos *sampledata.sql*, *model.sql*, *apply.sql* y *undo.sql*.

Uso:  
```
DbVersionTool [-update]

  -update: Switch para aplicar los cambios, si se omite se despliegan las versiones actuales.
```

Al aplicar los cambios se realizarán las siguientes acciones:

1. Se generará un nuevo GUID para identificar la próxima versión
2. Se moverán los cambios de apply.sql a model.sql, actualizando la versión del esquema y la próxima versión que será creada por apply.sql
3. Se eliminarán los cambios de undo.sql actualizando la versión de reversión y de verificación para concordar con la nueva versión de apply.sql
4. Se descartará el contenido de sampledata.sql

> En el release inicial DbVersionTool debe ejecutarse en la misma ruta donde se encuentran los demás archivos.

### apply.sql
Contiene los incrementos o cambios que serán introducidos en esta nueva versión. Este script sólo modificará la base de datos si encuentra la versión apropiada.

### undo.sql
Contiene las acciones necesarias para reversar de manera segura todos los cambios introducidos en la versión actual. Este script sólo modificará la base de datos si encuentra la versión apropiada.

*undo.sql* siempre contiene acciones contrarias a *apply.sql*, sentencias ``CREATE`` se convierten en ``DROP``, sentencias ``ALTER`` deben ser creadas con una contraparte similar que contrarreste los cambios.

### sampledata.sql
Contiene instrucciones para insertar datos ficticios que ayudaran en la validación como parte del proceso de calidad continua. Los datos de prueba corresponden al incremento actual y no precisan ser acumulados entre versiones; si los datos usados anteriormente son requeridos nuevamente deberán ser añadidos en cada versión.

## database.sql
Creación de la base de datos; utilizado en esquemas de automatización con aprovisionamiento automático. Este archivo no es actualizado bajo condiciones normales a menos que los incrementos en *apply.sql* requiera habilitar nuevas características en la base de datos.

### model.sql
Esquema o modelo de base de datos, este archivo contiene los objetos válidos para una versión específica de la base de datos. **Este archivo no debe ser editado manualmente**.

## Prueba Continua

Un simple proyecto de MSTest para mostrar cómo implementar una estrategia de pruebas que permita validar la estructura de una base de datos en cada cambio.

### Categories.cs
Código de nuestra prueba unitaria con validación basada en un esquema XSD.

### Tests.csproj
Archivo de proyecto con las referencias necesarias.

### DB-DevOps.sln
Archivo de solución. (opcional)
