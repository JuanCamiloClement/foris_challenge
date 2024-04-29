# Foris Challenge!

Este proyecto fue desarrollado usando Elixir (Mix).

## Características del proyecto:

El objetivo es procesar un archivo de texto línea por línea, con el fin de detectar los alumnos que más asisten a clase.

El código con la lógica principal lo encontrarás en `/lib/foris_challenge.ex`. Por otro lado, el archivo con las pruebas unitarias lo encontrarás en `/test/foris_challenge_test.exs`.

El archivo de texto que vamos a procesar lo llamamos `commands.txt` y lo encontrarás en la raíz del repositorio.

## Razonamiento:

Definimos una funcion `&ForisChallenge.run/0`, la cual corre el resto de funciones que definimos en el módulo (es decir, inicia recibiendo el input y genera el output).

Entre el input y el output, esta función utiliza `&ForisChallenge.run_logic/1`, la cual contiene las funciones puras que creamos para manejar la lógica del reto. Se realizó de esta manera con el objetivo de poder crear pruebas unitarias que cubrieran toda la lógica de las funciones creadas y utilizadas.

Se decidió capturar la entrada estándar haciendo uso de `IO.stream(:stdio, :line)`:
- Esta función nos permite crear un stream a partir de lo recibido a través de la entrada estándar (que precisamos con el parámetro `:stdio`). El átomo `:line` como segundo parámetro nos ayuda a que el stream se cree a partir de cada línea, de lo contrario se crearía caracter por caracter.
- Siendo el stream un enumerable en Elixir, podemos ayudarnos de cualquier función del módulo `Enum` para procesarlo. En este caso, en `&ForisChallenge.run_logic/1` usamos `&Enum.reduce/3` para crear un mapa (parejas llave-valor: la llave corresponde al nombre del estudiante y el valor corresponde a la información de cada uno).
- El acumulador (inicializado como un mapa vacío) lo vamos entregando a `&ForisChallenge.process_line/2` hasta que generamos la información final que queremos incluir en el output, evitando ocupar memoria con información no requerida (e.g. comandos con presencia menor a 5 minutos).
- Cada línea será procesada por `ForisChallenge.handle_command/2`, la cual definimos dos veces, una para cada tipo de comando, utilizando pattern-matching en sus argumentos para procesar cada comando como corresponde.
- Fue necesario definir `&ForisChallenge.define_time/1`, la cual recibe cada string de los tiempos en formato `"HH:MM"` y la procesa y crea un struct `%Time{}` (llamando `&Time.new/3`). Esto con el fin de realizar la diferencia de minutos aprovechando la existencia de `&Time.diff/3` en Elixir.
- Finalmente, de nuevo en `&ForisChallenge.run_logic/1` recibimos el acumulador y construimos el resultado con `&ForisChallenge.build_result/1`, la cual, primero, se encarga de ordenar las presencias de cada estudiante en orden descendente según los minutos registrados. Segundo, genera cada línea del resultado final (llamando `&ForisChallenge.prepare_result/1`) a partir de cada pareja llave-valor recibida. Usamos `&String.trim/1` para eliminar el caracter `"\n"` de la última línea y entregamos el resultado a `&IO.puts/1` para generar nuestro reporte final.

## Corre el proyecto 🚀

### Instalación 🔧

1. Clona el repositorio a tu máquina local: 
```
git clone git@github.com:JuanCamiloClement/foris_challenge.git
```

2. Cambia directorio a /foris_challenge:
```
cd foris_challenge
```

3. Instala las dependencias y compila el proyecto:

Asegúrate de tener instalado Elixir, luego corre:
```
mix setup
```

4. Corre el proyecto con el siguiente comando:
```
cat commands.txt | elixir -r lib/foris_challenge.ex -e ForisChallenge.run
```

### Tests

Para correr las pruebas unitarias, es tan sencillo como ubicarte sobre la raíz del repositorio y correr:
```
mix test
```

## Construido con 🛠️

- Elixir: [https://elixir-lang.org/](https://elixir-lang.org/)
- Mix: [https://hexdocs.pm/mix/1.15/Mix.html](https://hexdocs.pm/mix/1.15/Mix.html)

## Autor ✒️

- **Juan Camilo Clement** - _Desarrollador_ - [https://github.com/JuanCamiloClement](https://github.com/JuanCamiloClement)