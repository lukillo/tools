<img src="https://nodejs.org/static/images/logos/nodejs-new-pantone-black.ai" width="200px" align="right" />

# Creación de estructura básica para un microservicio.
Este script puede ser usado para generar la estructura de carpetas básica para un micorservicio, 
se genera un archivo index.js con un servidor de express y un archivo de events.js ya funcional,
para el resto de las carpetas podra encontrar un index.js, pero no se agrega contenido.

### Estructura generada:
Al ejecutar este script en la ubicación deseada, podrá encontrar la siguiente estructura:

```sh
__test__/
config/
├──index.js
├──...
node_modules/
├──...
src/
├──lib/
├────index.js
├────...
├──server/
├────constants/
├──────index.js
├──────...
├────controller/
├──────index.js
├──────...
├────middleware/
├──────index.js
├──────...
├────routes/
├──────index.js
├──────...
├────index.js
├────events.js
├────...
├──services/
├────index.js
├────...
├──...
.env
* create_project.sh
package-lock.json
package.json
```


### Ejecutar:
**Aviso:** Solo requiere copiar el archivo **create_project.sh** en la carpeta donde se almacenara el microservicio.

```bash
sh create_project.sh
```
