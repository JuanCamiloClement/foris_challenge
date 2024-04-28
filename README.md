# Foris Challenge!

Este proyecto fue desarrollado usando Elixir (Mix).

## Características del proyecto:

El objetivo es procesar un archivo de texto línea por línea, con el fin de detectar los alumnos que más asisten a clase.

## Razonamiento:

Definimos una funcion `&ForisChallenge.run/0`, la cual corre el resto de funciones que definimos en el módulo (es decir, inicia recibiendo el input y genera el output).

Se decidió capturar la entrada estándar haciendo uso de `IO.stream(:stdio, :line)`:
- Esta función nos permite crear un stream a partir de lo recibido a través de la entrada estándar (que precisamos con el parámetro `:stdio`). El átomo `:line` como segundo parámetro nos ayuda a que el stream se cree a partir de cada línea, de lo contrario se crearía caracter por caracter.
- Siendo el stream un enumerable en Elixir, podemos ayudarnos de cualquier función del módulo `Enum` para procesarlo. En este caso, usamos `&Enum.reduce/3` para crear un mapa (parejas llave-valor: la llave corresponde al nombre del estudiante y el valor corresponde a la información de cada uno).
- El acumulador (inicializado como un mapa vacío) lo vamos entregando a `&ForisChallenge.process_line/2` hasta que generamos la información final que queremos incluir en el output, evitando ocupar memoria con información no requerida (e.g. comandos con presencias menores a 5 minutos).
- Cada línea será procesada por `ForisChallenge.handle_command/2`, la cual definimos dos veces, una para cada tipo de comando, utilizando pattern-matching en sus argumentos para procesar cada comando como corresponde.
- Fue necesario definir `&ForisChallenge.define_time/1`, la cual recibe cada string de los tiempos en formato `"HH:MM"` y las procesa y crea structs `%Time{}` (llamando `&Time.new/3`). Esto con el fin de realizar la diferencia de minutos aprovechando la existencia de `%Time.diff/3` en Elixir.
- Finalmente, construimos el resultado con `&ForisChallenge.build_result/2`, la cual se encarga de ordenar las presencias de cada estudiante en orden descendente según los minutos registrados. Además, genera cada línea del resultado final (llamando `&ForisChallenge.prepare_result/1`) a partir de cada pareja llave-valor recibida. Usamos `&String.trim/1` para eliminar el caracter `"\n"` de la última línea y entregamos el resultado a `&IO.puts/1` para generar nuestro reporte final.

### Prerequisites 📋

The things you will need to install the software are a computer that isn't too old and a text editor to help you read all the code with pretty colors.

### Installation 🔧

1. Clone the repository to your local machine: 
```
git clone git@github.com:JuanCamiloClement/bemaster_challenge.git
```
2. Change directory to /bemaster_app:
```
cd bemaster_app
```

3. Install the dependencies:

Make sure to have installed Node.js:
```
sudo apt install nodejs npm
```

Then, run npm install on each of the repositories:
```
npm install
```

4. Run the code!

Make sure to be in the repository:
```
cd bemaster_app
```
Once there, execute
```
npm run dev
```
5. Remember the data is mocked! You will find the registered users, with their emails and passwords in `./src/assets/data/index.ts`, in the `users` variable.

In case you don't want to look so deep into folders, we can show you one from here:
```
email: juan@test.com
password: juan12345
```

Enjoy!

## Built with 🛠️

- React: [https://es.react.dev/](https://es.react.dev/)
- React Router DOM: [https://reactrouter.com/en/main](https://reactrouter.com/en/main)
- Redux: [https://redux.js.org/](https://redux.js.org/)
- Redux Toolkit: [https://redux-toolkit.js.org/](https://redux-toolkit.js.org/)
- React Icons: [https://react-icons.github.io/react-icons/](https://react-icons.github.io/react-icons/)
- Sass: [https://sass-lang.com/](https://sass-lang.com/)
- Typescript: [https://www.typescriptlang.org/](https://www.typescriptlang.org/)
- Universal Cookie: [https://www.npmjs.com/package/universal-cookie](https://www.npmjs.com/package/universal-cookie)

## Author ✒️

- **Juan Camilo Clement** - _Developer_ - [https://github.com/JuanCamiloClement](https://github.com/JuanCamiloClement)