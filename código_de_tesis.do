clear all

use "C:\Users\Usuario\Downloads\Stata18\Código de Tesis\datos.dta"

// YA ESTA FILTRADO EN LA BASE PERO ESTO AYUDARÍA A FILTRAR POR LA FORMA DE TENENCIA DE LA VIVIENDA
//rename vi14 forma_de_tenencia_de_la_vivienda
//drop if forma_de_tenencia_de_la_vivienda != "En arriendo" //(o su equivalente numérico)

rename p03 edad
rename ingrl ingreso_laboral
// VARIABLE DEPENDIENTE
rename vi141 precio_de_alquiler

summarize edad ingreso_laboral precio_de_alquiler

// Como veo que ingreso tiene datos raros como valor minimo=-1 y valor máximo=999999, los analizo:
// ANALISIS DE VALOR MÍNIMO=-1
// Primero, cuento el numero de observaciones del dataset
count // El resultado es 5077, como era de esperarse
// Luego analizo la base visualmente buscando este valor(-1), para ello ordeno los datos de manera ascendente (esto lo hago en la interfaz gráfica, por el momento)
// No encuentro como tal -1, pero si veo que los primeros valores dice "gasta mas de lo que gana". como son pocos, los cuento y son 14. 
// Como las demás valores de acontinuación no son -1, intuyo que es un codigo que representa la etiqueta "gasta mas de lo que gana"
// para verificar eso, cuento cuantos "-1" hay en codigo y veo si son 14.
count if ingreso_laboral==-1 // Efectivamente, el resultado es 14, el mismo valor que conte oralmente de "gasta mas de lo que gana". Por lo tanto, intuyo que -1 representa esta etiqueta.
// ANALISIS DE VALOR MAXIMO 999999
// En la interfaz gráfica, al buscar los datos no encuentro este valor. 
// Después de "gasta más de lo que gana", empiezan valores numéricos desde cero en adelante, hasta 9250. Y desde el último 9250, continúa la etiqueta "no informa", y de luego del último "no informa" hay valores faltantes.
// Como no encuentro 999999, ya que el valor numerico maximo encontrado es 9250, intuyo que este otro codigo. En la base ordenada (en la interfaz), visualmente se ven solo dos etiquetas.
// La primera etiqueta es la que ya vi, el que se representa con -1. Pero la otra es "no informa". Como no hay 999999, supongo que es el codigo para esta etiqueta.
// Como son pocos cuento y veo que "no informa" aparece 8 veces. Entonces, en codigo cuento cuantos 999999 hay para ver si es el mismo numero.
count if ingreso_laboral==999999 // Efectivamente, el resultado es 8, por lo que 999999 es el código para "no informa"
// ANALISIS ADICIONAL, POR LOS HALLAZGOS ENCONTRADOS MIENTRAS ANALIZABA LOS DATOS ANTERIORES
// 1. Datos faltantes
// La base ordenada en la interfaz, los ultimos valores me mostró datos faltantes con un punto (.). 
// Cuento cuantos son:
count if ingreso_laboral==. // El resultado es 780 datos faltantes
// Hago un analisis mas profundo. Intuyo que el encuestador se saltó esa pregunta o los encuestados no reportaron sus ingresos, aunque antes ya encontré una etiqueta de "no informa".
// El primer supuesto no lo puedo comprobar pero el segundo si.
// Pienso en porque no reportaron sus ingresos. Quizas no trabajan o algo por el estilo.
// Busco variables relacionadas y encuentro una que es "condicion de actividad"
// Como la base ya esta ordenada, y los ultimos datos que se muestran son faltantes, solo me muevo por la interfaz y busco que datos de condicion de actividad tienen las observaciones con valores faltantes en el ingreso laboral
// A primera vista, todas esas observaciones tienen de condicion de actividad: poblacion economicamente inactiva, empleo no remunerado, desempleo abierto, desempleo oculto, etc
// La mayoría no reporta ingresos quizas por no tener trabajo. Por lo que en un inicio, el segundo suepuesto era cierto.
// Voy contando cuantos datos faltantes hay por cada condicion de actividad
// Veo la codificación de la variable condicion de actividad, pero primero la renombro
rename condact condicion_de_actividad
codebook condicion_de_actividad
// Los resultados son estos: 
// Numeric  Label
//                        2,536         1  Empleo Adecuado/Pleno
//                          669         2  Subempleo por insuficiencia de
//                                         tiempo de trabajo
//                          106         3  Subempleo por insuficiencia de
//                                         ingresos
//                          986         4  Otro empleo no pleno
//                           29         5  Empleo no remunerado
//                            8         6  Empleo no clasificado
//                          137         7  Desempleo abierto
//                            9         8  Desempleo oculto
//                          597         9  Población Económicamente
//                                       Inactiva
// Ahora con esto puedo contar los valores faltantes en base a la condicion de actividad
count if missing(ingreso_laboral) & condicion_de_actividad==1 // No hay observaciones con ingreso faltante, que tengan la condicion de actividad "Empleo Adecuado/Pleno"
count if missing(ingreso_laboral) & condicion_de_actividad==2 // Hay 8 observaciones con ingreso faltante, que tienen la condicion de actividad "Subempleo por insuficiencia de tiempo de trabajo"
count if missing(ingreso_laboral) & condicion_de_actividad==3 // No hay observaciones con ingreso faltante, que tengan la condicion de actividad "Subempleo por insuficiencia de ingresos"
count if missing(ingreso_laboral) & condicion_de_actividad==4 // No hay observaciones con ingreso faltante, que tengan la condicion de actividad "Otro empleo no pleno"
count if missing(ingreso_laboral) & condicion_de_actividad==5 // Hay 29 observaciones con ingreso faltante, que tengan la condicion de actividad "Empleo no remunerado"
count if missing(ingreso_laboral) & condicion_de_actividad==6 // No hay observaciones con ingreso faltante, que tengan la condicion de actividad "Empleo no clasificado"
count if missing(ingreso_laboral) & condicion_de_actividad==7 // Hay 137 observaciones con ingreso faltante, que tienen la condicion de actividad "Desempleo abierto"
count if missing(ingreso_laboral) & condicion_de_actividad==8 // Hay 9 observaciones con ingreso faltante, que tienen la condicion de actividad "Desempleo oculto"
count if missing(ingreso_laboral) & condicion_de_actividad==9 // Hay 597 observaciones con ingreso faltante, que tiene la condicion de actividad "Población Económicamente inactiva"
// Entonces tengo que de las observaciones que tienen ingreso faltante, hay:
// 8 observaciones en "Subempleo por insuficiencia de tiempo de trabajo", 
// 29 observaciones en "Empleo no remunerado",
// 137 observaciones en "Desempleo abierto",
// 9 observaciones en "Desempleo oculto",
// 597 obbservaciones en "Población Económicamente inactiva".

// Sumo y veo que sean en total 780 observaciones
count if missing(ingreso_laboral) & (condicion_de_actividad==1|condicion_de_actividad==2|condicion_de_actividad==3|condicion_de_actividad==4|condicion_de_actividad==5|condicion_de_actividad==6|condicion_de_actividad==7|condicion_de_actividad==8|condicion_de_actividad==9)
display "El resultado es " r(N) // El resultado es 780, el mismo que solo contar valores faltantes.
// Esto confirma que los datos faltantes en ingreso_laboral no son aleatorios. Por el contrario, siguen un patrón muy claro y lógico asociado a la condición de actividad de las personas.

// Vamos a tratar esta variable para volver hacer las estadísticas descriptivas, ya que los valores -1, 999999 y valores faltantes, distorsionan los resultados ya que los dos primeros son etiquetas y la otra tambien altera mis estadísticas

// 1. Tratamiento de -1 ("gasta mas de lo que gana")
// Para el valor -1 en la variable ingreso_laboral, optamos por recodificarlo a un valor faltante del sistema (.). Esta decisión se basa en que -1 no representa una cantidad monetaria de ingreso real. En lugar de ser un valor numérico que pueda ser sumado o promediado, es un código especial utilizado en la encuesta para indicar una situación cualitativa de desbalance financiero ("gasta más de lo que gana"). Mantenerlo como un número distorsionaría severamente cualquier cálculo estadístico del ingreso laboral, como promedios o desviaciones estándar, lo que resultaría en conclusiones engañosas. Al convertirlo a un valor faltante, nos aseguramos de que solo los datos numéricos verdaderamente significativos sean considerados en los análisis, preservando así la integridad y precisión de las medicación del ingreso laboral.
replace ingreso_laboral=. if ingreso_laboral==-1 // 14 valores fueron cambiados a .
display " Las observaciones con -1 se cambiaron a " r(replacements) "por ser de la etiqueta 'gasta mas de lo que gana' "

// 2. Tratamiento de 999999
// Para el valor 999999 en la variable ingreso_laboral, también los recodificamos a un valor faltante del sistema (.). Este 999999 no representa una cantidad monetaria real de ingreso; es un código especial que indica que el dato no fue informado o no pudo clasificarse, como confirmamos al ver que siempre está asociado con la condicion_de_actividad "empleo no clasificado". Mantener este valor como un número distorsionaría masivamente cualquier análisis estadístico de los ingresos, inflando artificialmente promedios, desviaciones estándar y otros cálculos, lo que resultaría en conclusiones engañosas e inválidas sobre la situación económica de la población. Al convertirlo a un valor faltante, nos aseguramos de que solo los datos numéricos que realmente representan un ingreso sean incluidos en los análisis, manteniendo la integridad y la precisión de tus mediciones.

replace ingreso_laboral=. if ingreso_laboral==999999 // 8 valores fueron cambiados a .
display "El valor de 999999 fue recodificado a " r(replacements)

// 3. Tratamiento de valores faltantes
// Para los valores faltantes en ingreso_laboral, se aplicó un enfoque diferenciado basado en la condicion_de_actividad de las observaciones. Para las 29 observaciones en "Empleo no remunerado", 137 en "Desempleo abierto", 9 en "Desempleo oculto", y las 597 observaciones en "Población Económicamente Inactiva", se imputó el ingreso_laboral a cero. Esta imputación se justifica plenamente, ya que para todos estos estados de actividad, la ausencia de un ingreso laboral es la expectativa lógica y fundamental: estas personas no están recibiendo una remuneración por su trabajo o no participan activamente en el mercado laboral. El total de observaciones imputadas a cero en este paso fue de [Suma de todas las observaciones imputadas a 0 en este paso, ej., 29+137+9+597 = 772]. Sin embargo, el caso de las 8 observaciones en "Subempleo por insuficiencia de tiempo de trabajo" con ingreso_laboral faltante se trató de manera distinta. Para este grupo, asumir un ingreso de cero sería menos preciso; una persona subempleada podría tener un ingreso bajo pero existente, no necesariamente nulo. Por lo tanto, para estas 8 observaciones, los valores se mantuvieron como faltantes (.), y su manejo en los análisis subsiguientes se realizará a través de la eliminación por lista (listwise deletion).

replace ingreso_laboral=0 if missing(ingreso_laboral) & (condicion_de_actividad==5|condicion_de_actividad==7|condicion_de_actividad==8|condicion_de_actividad==9)

// Ahora el ingreso laboral también es cero para algunos casos de "Empleo no remunerado", "Desempleo abierto", "Desempleo oculto", y "Población Económicamente Inactiva". Sin embargo, los cero iniciales (reportados desde el inicio) tenían otras condiciones de actividad. Si sería bueno saber la cantidad de observaciones de ingreso laboral=0 por cada condición de actividad.

count if ingreso_laboral==0 & (condicion_de_actividad==2) // 22 observaciones en "subempleo por insuficiencia de trabajo" con ingreso_laboral=0
count if ingreso_laboral==0 & (condicion_de_actividad==3) // 6 observaciones en "subempleo por insuficiencia de ingresos" con ingreso_laboral=0
count if ingreso_laboral==0 & (condicion_de_actividad==4) // 31 observaciones en "otro empleo no pleno" con ingreso_laboral=0

// Adicionalmente a "Empleo no remunerado", "Desempleo abierto", "Desempleo oculto", y "Población Económicamente Inactiva", podemos agregar a "subempleo por insuficiencia de trabajo", "subempleo por insuficiencia de ingresos" y "otro empleo no pleno", para algunos casos de ingreso=0

// CONTAR CUANTOS DATOS FALTANTES QUEDAN
count if ingreso_laboral==.

// VALORES ATÍPICOS
graph box edad
graph box ingreso_laboral
graph box precio_de_alquiler

summarize precio_de_alquiler edad ingreso_laboral, detail

generate Ri_edad = 52 - 32
generate Li_edad = 32 - 1.5 * Ri_edad 
generate Ls_edad = 52 + 1.5 * Ri_edad

drop if edad < Li_edad
drop if edad > Ls_edad
summarize edad

generate Ri_ingreso_laboral = 743 - 180
generate Li_ingreso_laboral = 180 - 1.5 * Ri_ingreso_laboral
generate Ls_ingreso_laboral = 743 + 1.5 * Ri_ingreso_laboral

drop if ingreso_laboral < Li_ingreso_laboral
drop if ingreso_laboral > Ls_ingreso_laboral
summarize ingreso_laboral

// HAGO CASO LA FÓRMULA

// DATOS ATÍPICOS PARA LA VARIABLE DEPENDIENTE
generate Ri_precio_de_alquiler = 200 - 100
generate Li_precio_de_alquiler = 100 - 1.5 * Ri_precio_de_alquiler
generate Ls_precio_de_alquiler = 200 + 1.5 * Ri_precio_de_alquiler

drop if precio_de_alquiler < Li_precio_de_alquiler
drop if precio_de_alquiler > Ls_precio_de_alquiler

// graficos despues de quedar atípicos

graph box precio_de_alquiler
graph box edad
graph box ingreso_laboral

summarize precio_de_alquiler // VER CUANTOS REGISTROS TENGO FINALMENTE

rename p02 sexo
rename p06 estado_civil
rename p10a nivel_de_instruccion

// 4553 quedan limpiando datos atípicos y faltantes

////// TABLAS & GRÁFICOS //////

///// OBJETIVO 1 /////

//// CUANTITATIVAS ////

summarize edad ingreso_laboral, detail

graph box edad
histogram edad
kdensity edad

graph box ingreso_laboral
histogram ingreso_laboral
kdensity ingreso_laboral

// ANÁLISIS DE LOS VALORES CERO DEL INGRESO
count if ingreso_laboral==0 // 753 observaciones con ingreso de cero
//Contar en base a condición de actividad
codebook condicion_de_actividad
count if ingreso_laboral==0 & condicion_de_actividad==1 // No hay observaciones con ingreso cero, que tengan la condicion de actividad "Empleo Adecuado/Pleno"
count if ingreso_laboral==0 & condicion_de_actividad==2 // Hay 22 observaciones con ingreso cero, que tienen la condicion de actividad "Subempleo por insuficiencia de tiempo de trabajo"
count if ingreso_laboral==0 & condicion_de_actividad==3 // Hay 6 observaciones con ingreso cero, que tienen la condicion de actividad "Subempleo por insuficiencia de ingresos"
count if ingreso_laboral==0 & condicion_de_actividad==4 // Hay 29 observaciones con ingreso cero, que tienen la condicion de actividad "Otro empleo no pleno"
count if ingreso_laboral==0 & condicion_de_actividad==5 // Hay 28 observaciones con ingreso cero, que tengan la condicion de actividad "Empleo no remunerado"
count if ingreso_laboral==0 & condicion_de_actividad==6 // No hay observaciones con ingreso cero, que tengan la condicion de actividad "Empleo no clasificado"
count if ingreso_laboral==0 & condicion_de_actividad==7 // Hay 134 observaciones con ingreso cero, que tienen la condicion de actividad "Desempleo abierto"
count if ingreso_laboral==0 & condicion_de_actividad==8 // Hay 9 observaciones con ingreso cero, que tienen la condicion de actividad "Desempleo oculto"
count if ingreso_laboral==0 & condicion_de_actividad==9 // Hay 525 observaciones con ingreso cero, que tiene la condicion de actividad "Población Económicamente inactiva"
// El total de observaciones por condicion de actividad es: 525+9+134+28+29+6+22=753
// Entre lo que es lógico no tener ingreso como "Empleo no remunerado", "Desempleo abierto", "Desempleo oculto", "Población Económicamente inactiva" se tiene 28+134+9+525=696
// Tendría 753-696=57 observaciones debido a otras razones
// Tener en cuenta que se imputó a cero en algunas condiciones de actividad, pero no sale lo misma cantidad de observaciones porque este análisis se esta haciendo después de eliminar valores atípicos, y la imputación se realizó antes de eliminar valores atípicos.
// Recibió el bono de desarrollo humano (p75): De los 57, 3 reciben el bono de desarrollo humano 
// Recibió Ingreso del exterior (p74a): De los 57, 5 reciben dinero del exterior
// Recibe jubilación o pensión (p72a): De los 57, 5 reciben jubilación
// Ingreso por regalos o donaciones (p73a): De los 57, 24 reciben regalos o donaciones
// Ingresos patrono cuenta propia (p63): 25 mencionaron ingreso cuenta propia aunque solo 1 de ellos reporto un valor de 500 y los 24 restantes un valor de cero
// REPETICIONES
// 1 que recibe jubilacion o pension, tambien reicbe bono de desarrollo humano
// 1 que recibe regalos y donaciones, tambien recibe bono de dearrollo humano
// 3 que reciben dinero de regalos o donaciones, también reciben dinero del exterior

//// CUALITATIVAS ////

/// AREA ///
tabulate area
graph pie area, over(area)
///NIVEL_DE_INSTRUCCION///
tabulate nivel_de_instruccion
graph pie nivel_de_instruccion, over(nivel_de_instruccion)
codebook nivel_de_instruccion
recode nivel_de_instruccion (8 9 10=1) (1 2 4 5 6 7=2), generate(nivel_de_instruccion_reagrupado)
tabulate nivel_de_instruccion_reagrupado
graph pie nivel_de_instruccion_reagrupado, over(nivel_de_instruccion_reagrupado)
///ESTADO_CIVIL///
tabulate estado_civil
graph pie estado_civil, over(estado_civil)
codebook estado_civil
recode estado_civil (1 3 4=1) (2 5 6=2), generate(estado_civil_reagrupado)
tabulate estado_civil_reagrupado
graph pie estado_civil_reagrupado, over(estado_civil_reagrupado)
///SEXO///
tabulate sexo
graph pie sexo, over(sexo)

///ESTADO_CIVIL///
tabulate estado_civil
graph pie estado_civil, over(estado_civil)
codebook estado_civil
//recode estado_civil (1 3 4=1) (2 5 6=2), generate(estado_civil_reagrupado)
tabulate estado_civil_reagrupado
graph pie estado_civil_reagrupado, over(estado_civil_reagrupado)

///// OBJETIVO 2 /////
//// CUANTITATIVAS ////

// DATOS SIN VALORES ATÍPICOS (NO ASUSTARME QUE SALGA DIFERENTE COMO ARRIBA)
summarize precio_de_alquiler, detail

graph box precio_de_alquiler
histogram precio_de_alquiler,bin(14)
kdensity precio_de_alquiler

//// CUANTITATIVA DISCRETA ////

rename vi07 numero_de_dormitorios
tabulate numero_de_dormitorios
// ANALISIS MAS DETALLADO DEL NUMERO DE DORMITORIOS
codebook numero_de_dormitorios
count if numero_de_dormitorios==0 // 236 EN TOTAL SON DE CERO DORMITORIOS
// Numero de cuartos
rename vi06 numero_de_cuartos
count if numero_de_dormitorios==0 & numero_de_cuartos==1 // 235 de 236 tienen un solo cuarto en total
count if numero_de_dormitorios==0 & numero_de_cuartos==2 // 1 de 236 tienen dos cuartos y revisando esa observacion el tipo de vivienda es mediagua

// analisis por tipo de vivienda
rename vi02 tipo_de_vivienda
codebook tipo_de_vivienda
count if numero_de_dormitorios==0 & tipo_de_vivienda==1 // 7 viviendas con cero dormitorios que son Casa o villa (todas estas tienen 1 cuarto en total)
count if numero_de_dormitorios==0 & tipo_de_vivienda==2 // 54 viviendas con cero dormitorios que son Departamento (todas estas tienen 1 cuarto en total)
count if numero_de_dormitorios==0 & tipo_de_vivienda==3 // 150 viviendas con cero dormitorios que son Cuartos en casa de inquilinato (todas estas tienen 1 cuarto en total)
count if numero_de_dormitorios==0 & tipo_de_vivienda==4 // 15 viviendas con cero dormitorios que son Mediagua (14 de las 15 tienen 1 cuarto en total, y 1 de 15 tiene 2 cuartos en total)
count if numero_de_dormitorios==0 & tipo_de_vivienda==5 // 10 viviendas con cero dormitorios que son Rancho, covacha (todas estas tienen 1 cuarto en total)

//// CUALITATIVAS ////

/// VÍA DE ACCESO PRINCIPAL ///

rename vi01 via_de_acceso_principal
tabulate via_de_acceso_principal
graph pie via_de_acceso_principal, over(via_de_acceso_principal)
codebook via_de_acceso_principal
recode via_de_acceso_principal (1=1) (2 3 4 6=2), generate(via_de_acceso_principal_agrupado)
tabulate via_de_acceso_principal_agrupado
graph pie via_de_acceso_principal_agrupado,over(via_de_acceso_principal_agrupado)

/// TIPO DE VIVIENDA ///

tabulate tipo_de_vivienda
graph pie tipo_de_vivienda, over (tipo_de_vivienda)
codebook tipo_de_vivienda
recode tipo_de_vivienda (1 2=1) (3 4 5=2), generate(tipo_de_vivienda_agrupado)
tabulate tipo_de_vivienda_agrupado
graph pie tipo_de_vivienda_agrupado, over(tipo_de_vivienda_agrupado)

/// MATERIAL DE LAS PAREDES ///

rename vi05a material_de_las_paredes
tabulate material_de_las_paredes
graph pie material_de_las_paredes, over(material_de_las_paredes)
codebook material_de_las_paredes
recode material_de_las_paredes (1 2=1) (3 4 5 6 7=2), generate(material_de_las_paredes_agrupado)
tabulate material_de_las_paredes_agrupado
graph pie material_de_las_paredes_agrupado, over(material_de_las_paredes_agrupado)

/// CUARTO EXCLUSIVO PARA COCINAR ///

rename vi07b cuarto_exclusivo_para_cocinar
tabulate cuarto_exclusivo_para_cocinar
codebook cuarto_exclusivo_para_cocinar
graph pie cuarto_exclusivo_para_cocinar, over(cuarto_exclusivo_para_cocinar)

/// SERVICIO HIGIÉNICO ///

rename vi09 servicio_higienico
tabulate servicio_higienico
graph pie servicio_higienico, over(servicio_higienico)
codebook servicio_higienico
recode servicio_higienico (1=1) (2 3 5=2), generate(servicio_higienico_reagrupado)
tabulate servicio_higienico_reagrupado
graph pie servicio_higienico_reagrupado, over(servicio_higienico_reagrupado)

/// AGUA QUE RECIBE LA VIVIENDA ///

rename vi10a agua_que_recibe_la_vivienda
tabulate agua_que_recibe_la_vivienda
graph pie agua_que_recibe_la_vivienda, over(agua_que_recibe_la_vivienda)
codebook agua_que_recibe_la_vivienda
recode agua_que_recibe_la_vivienda (1=1) (2 4=2), generate(agua_recibe_vivienda_agrupado)
tabulate agua_recibe_vivienda_agrupado
graph pie agua_recibe_vivienda_agrupado, over(agua_recibe_vivienda_agrupado)

/// SERVICIO DE DUCHA ///

rename vi11 servicio_de_ducha
tabulate servicio_de_ducha
graph pie servicio_de_ducha, over(servicio_de_ducha)
codebook servicio_de_ducha
recode servicio_de_ducha (1=1) (2 3=2), generate(servicio_de_ducha_reagrupado)
tabulate servicio_de_ducha_reagrupado
graph pie servicio_de_ducha_reagrupado, over(servicio_de_ducha_reagrupado)

///// OBJETIVO 3 /////

//// Matriz de correlación ////

correlate area sexo edad estado_civil_reagrupado nivel_de_instruccion_reagrupado ingreso_laboral numero_de_dormitorios via_de_acceso_principal_agrupado tipo_de_vivienda_agrupado material_de_las_paredes_agrupado cuarto_exclusivo_para_cocinar servicio_higienico_reagrupado agua_recibe_vivienda_agrupado servicio_de_ducha_reagrupado

//// REGRESIÓN LIN - LIN ////

regress precio_de_alquiler area sexo edad estado_civil_reagrupado nivel_de_instruccion_reagrupado ingreso_laboral numero_de_dormitorios via_de_acceso_principal_agrupado tipo_de_vivienda_agrupado material_de_las_paredes_agrupado cuarto_exclusivo_para_cocinar servicio_higienico_reagrupado agua_recibe_vivienda_agrupado servicio_de_ducha_reagrupado

//// REGRESIÓN LOG - LIN ////

generate ln_precio_de_alquiler = ln(precio_de_alquiler)
regress ln_precio_de_alquiler i.area i.sexo edad i.estado_civil_reagrupado i.nivel_de_instruccion_reagrupado ingreso_laboral numero_de_dormitorios i.via_de_acceso_principal_agrupado i.tipo_de_vivienda_agrupado i.material_de_las_paredes_agrupado i.cuarto_exclusivo_para_cocinar i.servicio_higienico_reagrupado i.agua_recibe_vivienda_agrupado i.servicio_de_ducha_reagrupado

vif

estat hettest
hettest

// CON ROBUST: regress ln_precio_de_alquiler area sexo edad estado_civil_reagrupado nivel_de_instruccion_reagrupado ingreso_laboral numero_de_dormitorios via_de_acceso_principal_agrupado tipo_de_vivienda_agrupado material_de_las_paredes_agrupado cuarto_exclusivo_para_cocinar servicio_higienico_reagrupado agua_recibe_vivienda_agrupado servicio_de_ducha_reagrupado, robust

/// SIN SEXO, ESTADO CIVIL Y CUARTO EXCLUSIVO PARA COCINAR ///
//regress ln_precio_de_alquiler area edad nivel_de_instruccion_reagrupado ingreso_laboral numero_de_dormitorios via_de_acceso_principal_agrupado tipo_de_vivienda_agrupado material_de_las_paredes_agrupado servicio_higienico_reagrupado agua_recibe_vivienda_agrupado servicio_de_ducha_reagrupado

// ANÁLISIS POSTMODELO 1

predict residuals, residuals

// o	Verificación de la normalidad de los residuos (prueba de Jarque-Bera o gráfico de residuos).
jb residuals // CONCLUSIÓN: Los residuos del modelo NO están distribuidos normalmente.
histogram residuals, normal // Gráfico
//qnorm residuals // Gráfico 2

// o	Gráficos de residuos vs. predichos para evidenciar heterocedasticidad visual.
// valores predichos
predict yhat, xb 
// gráfico de residuos vs. predichos
scatter resid yhat, yline(0)
title("Residuos vs. Valores Predichos")
xlabel(,grid) ylabel(,grid)

predict cooksd, cooksd        // Distancia de Cook
//Graficar Cook's Distance
generate id = _n
scatter cooksd id, ///
title("Cook's Distance por Observación") ///
yline(1, lcolor(red)) ///
ylabel(, grid) xlabel(, grid)

predict leverage, hat         // Leverage (valores altos indican potencial influencia)
predict rstudent, rstudent // residuos estudentizados
twoway (scatter rstudent leverage), ///
title("Leverage vs. Residuos Estudentizados") ///
xlabel(, grid) ylabel(, grid)

//// Prueba: con una sola eliminación
//drop if cooksd > 1 | leverage > ((3*(14+1))/4553) | rstudent > 3 | rstudent < -3
//regress ln_precio_de_alquiler i.area i.sexo edad i.estado_civil_reagrupado i.nivel_de_instruccion_reagrupado ingreso_laboral numero_de_dormitorios i.via_de_acceso_principal_agrupado i.tipo_de_vivienda_agrupado i.material_de_las_paredes_agrupado i.cuarto_exclusivo_para_cocinar i.servicio_higienico_reagrupado i.agua_recibe_vivienda_agrupado i.servicio_de_ducha_reagrupado

// NUMERO DE OBSERVACIONES ANTES DE LAS ELIMINACIONES
count // 4553 observaciones en total

// predict rstudent, rstudent --- CARGADO ARRIBA
sort cooksd
// CONTEMOS CADA CRITERIO ANTES DE LA PRIMERA ELIMINACIÓN
count if cooksd > (4/(4553-14-1)) // 325 observaciones
count if leverage > ((3*(14+1))/4553) // 235 observaciones
count if rstudent > 2 | rstudent < -2 // 217 observaciones

// PRIMERA ELIMINACIÓN
list id cooksd leverage rstudent if rstudent > 2 | rstudent < -2 , sep(0)
list id cooksd leverage rstudent if cooksd > (4/(4553-14-1)) & leverage > ((3*(14+1))/4553) & rstudent > 3 | rstudent < -3
drop if cooksd > (4/(4553-14-1)) & leverage > ((3*(14+1))/4553) & rstudent > 3 | rstudent < -3
regress ln_precio_de_alquiler i.area i.sexo edad i.estado_civil_reagrupado i.nivel_de_instruccion_reagrupado ingreso_laboral numero_de_dormitorios i.via_de_acceso_principal_agrupado i.tipo_de_vivienda_agrupado i.material_de_las_paredes_agrupado i.cuarto_exclusivo_para_cocinar i.servicio_higienico_reagrupado i.agua_recibe_vivienda_agrupado i.servicio_de_ducha_reagrupado //0.4957

// CONTEMOS CADA CRITERIO DESPUES DE LA PRIMERA ELIMINACIÓN
count if cooksd > (4/(4553-14-1)) // 287 observaciones
count if leverage > ((3*(14+1))/4553) // 229 observaciones
count if rstudent > 2 | rstudent < -2 // 176 observaciones

//SEGUNDA ELIMINACIÓN
drop if cooksd > (4/(4553-14-1)) & leverage > ((3*(14+1))/4553) & rstudent > 2 | rstudent < -2
regress ln_precio_de_alquiler i.area i.sexo edad i.estado_civil_reagrupado i.nivel_de_instruccion_reagrupado ingreso_laboral numero_de_dormitorios i.via_de_acceso_principal_agrupado i.tipo_de_vivienda_agrupado i.material_de_las_paredes_agrupado i.cuarto_exclusivo_para_cocinar i.servicio_higienico_reagrupado i.agua_recibe_vivienda_agrupado i.servicio_de_ducha_reagrupado //0.5432

// CONTEMOS CADA CRITERIO DESPUES DE LA SEGUNDA ELIMINACIÓN
count if cooksd > (4/(4553-14-1)) // 205 observaciones
count if leverage > ((3*(14+1))/4553) // 211 observaciones
count if rstudent > 2 | rstudent < -2 // 45 observaciones

// TERCERA ELIMINACIÓN
list id cooksd leverage rstudent if rstudent > 2 | rstudent < -2 , sep(0)
drop if rstudent > 2 | rstudent < -2
regress ln_precio_de_alquiler i.area i.sexo edad i.estado_civil_reagrupado i.nivel_de_instruccion_reagrupado ingreso_laboral numero_de_dormitorios i.via_de_acceso_principal_agrupado i.tipo_de_vivienda_agrupado i.material_de_las_paredes_agrupado i.cuarto_exclusivo_para_cocinar i.servicio_higienico_reagrupado i.agua_recibe_vivienda_agrupado i.servicio_de_ducha_reagrupado //0.5688

// CONTEMOS CADA CRITERIO DESPUES DE LA TERCERA ELIMINACIÓN
count if cooksd > (4/(4553-14-1)) // 180 observaciones
count if leverage > ((3*(14+1))/4553) // 211 observaciones
count if rstudent > 2 | rstudent < -2 // 0 observaciones

// CUARTA ELIMINACIÓN 
list id cooksd leverage rstudent if cooksd > (4/(4553-14-1))
drop if cooksd > (4/(4553-14-1))

// CONTEMOS CADA CRITERIO DESPUES DE LA CUARTA ELIMINACIÓN
count if cooksd > (4/(4553-14-1)) // 0 observaciones
count if leverage > ((3*(14+1))/4553) // 130 observaciones
count if rstudent > 2 | rstudent < -2 // 0 observaciones

regress ln_precio_de_alquiler i.area i.sexo edad i.estado_civil_reagrupado i.nivel_de_instruccion_reagrupado ingreso_laboral numero_de_dormitorios i.via_de_acceso_principal_agrupado i.tipo_de_vivienda_agrupado i.material_de_las_paredes_agrupado i.cuarto_exclusivo_para_cocinar i.servicio_higienico_reagrupado i.agua_recibe_vivienda_agrupado i.servicio_de_ducha_reagrupado //0.5810

// Recuerdo los TRES CRITERIOS:
// Para el primer criterio, cooksd > (4/(N-p-1)), al principio, antes de las cuatros eliminaciones, tenía 325 observaciones, y al final me quedé con 0 observaciones por lo que, por este criterio eliminé 325(inicial)-0(final)=325 observaciones.
// Por el segundo criterio uso la misma lógica, leverage > ((3*(p+1))/N), eliminé 235(incial)-130(final)=105 observaciones.
// Por el tercero, rstudent > 2 | rstudent < -2, eliminé 217(inicial)-0(final)=217 observaciones.
// LO PRIMERO QUE PENSARÍA ES QUE SI SUMO ESAS ELIMINACIONES POR CADA CRITERIO, OBTENDRÍA EL VALOR TOTAL DE ELIMINACIONES, 325+105+217=647 observaciones.
// Sin embargo, eso no es así. Recordemos que empezamos con 4553 observaciones, así que contamos con cuantos nos quedamos después de las cuatro eliminaciones.
// NUMERO DE OBSERVACIONES DESPUÉS DE LAS CUATRO ELIMINACIONES
count //4156 observaciones en total
// Nos quedamos con 4156, si resto el total antes de las cuatro eliminaciones y el después de las cuatro (4553-4156) obtendría que eliminé solo 397 observaciones.
// Así que esto es porque muchas de esas observaciones cumplían con más de un criterio antes de cada eliminación (no son mutuamente exluyentes)

estat hettest
hettest

regress ln_precio_de_alquiler i.area i.sexo edad i.estado_civil_reagrupado i.nivel_de_instruccion_reagrupado ingreso_laboral numero_de_dormitorios i.via_de_acceso_principal_agrupado i.tipo_de_vivienda_agrupado i.material_de_las_paredes_agrupado i.cuarto_exclusivo_para_cocinar i.servicio_higienico_reagrupado i.agua_recibe_vivienda_agrupado i.servicio_de_ducha_reagrupado, robust //
// SIN VARIABLES NO SIGNIFICATIVAS (sexo)
regress ln_precio_de_alquiler i.area edad i.estado_civil_reagrupado i.nivel_de_instruccion_reagrupado ingreso_laboral numero_de_dormitorios i.via_de_acceso_principal_agrupado i.tipo_de_vivienda_agrupado i.material_de_las_paredes_agrupado i.cuarto_exclusivo_para_cocinar i.servicio_higienico_reagrupado i.agua_recibe_vivienda_agrupado i.servicio_de_ducha_reagrupado, robust //
avplot edad

//// ANÁLISIS POSTMODELO 2 ////
// o	Verificación de la normalidad de los residuos (prueba de Jarque-Bera o gráfico de residuos).
predict residuals2, residuals
jb residuals2 // CONCLUSIÓN: Los residuos del modelo NO están distribuidos normalmente.
histogram residuals, normal // Gráfico
// o	Gráficos de residuos vs. predichos para evidenciar heterocedasticidad visual.
predict yhat2, xb // valores predichos
// gráfico de residuos vs. predichos
scatter residuals2 yhat2, yline(0)
title("Residuos vs. Valores Predichos")
xlabel(,grid) ylabel(,grid)


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////




// o	Influencia de observaciones individuales (como leverage y Cook's distance).
//predict leverage, hat         // Leverage (valores altos indican potencial influencia)
//predict cooksd, cooksd        // Distancia de Cook



//// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ////



rvfplot

swilk resid
// GRÁFICO
qnorm resid

/// BOX COX ///

boxcox ln_precio_de_alquiler area nivel_de_instruccion_reagrupado ingreso_laboral edad via_de_acceso_principal_agrupado tipo_de_vivienda_agrupado material_de_las_paredes_agrupado numero_de_dormitorios servicio_higienico_reagrupado agua_recibe_vivienda_agrupado servicio_de_ducha_reagrupado

// MÁXIMA VEROSIMILITUD //

// FUNCIÓN
program define myloglin9
    args lnf beta
    tempvar yhat resid
    // Calcular el valor ajustado
    generate double `yhat' = `beta'[1] + `beta'[2] * area + `beta'[3] * nivel_de_instruccion_reagrupado + `beta'[4] * ingreso_laboral + `beta'[5] * edad + `beta'[6] * via_de_acceso_principal_agrupado + `beta'[7] * tipo_de_vivienda_agrupado + `beta'[8] * material_de_las_paredes_agrupado + `beta'[9] * numero_de_dormitorios + `beta'[10] * servicio_higienico_reagrupado + `beta'[11] * agua_recibe_vivienda_agrupado + `beta'[12] * servicio_de_ducha_reagrupado
    // Calcular el residuo
    generate double `resid' = log(ln_precio_de_alquiler) - `yhat'
    // Calcular la log-verosimilitud para cada observación
    generate double _lnf2 = ln(normalden(`resid', 0, 1))
    // Sumar la log-verosimilitud para obtener el total
    //summarize _lnf
    //return scalar `lnf' = r(sum)
end

// Maximizar la función de verosimilitud
ml model lf myloglin9 (ln_precio_de_alquiler = area nivel_de_instruccion_reagrupado ingreso_laboral edad via_de_acceso_principal_agrupado tipo_de_vivienda_agrupado material_de_las_paredes_agrupado numero_de_dormitorios servicio_higienico_reagrupado agua_recibe_vivienda_agrupado servicio_de_ducha_reagrupado)

// Especificar valores iniciales para los parámetros
ml maximize, startvalues(beta1 1, beta2 2, beta3 3, beta4 4, beta5 5, beta6 6, beta7 7, beta8 8, beta9 9, beta10 10, beta11 11, beta12 12) // PREGUNTAR A PROFE



// ........................................................................................................................ //




// PRUEBA CON MÁS VARIABLES

// Variable 1: "ESTADO DEL TECHO > ELEGIDO"

rename vi03b estado_del_techo
tabulate estado_del_techo
graph pie estado_del_techo, over(estado_del_techo)
codebook estado_del_techo
// Bueno = 1, regular, malo = 2
recode estado_del_techo (1=1) (2 3=2), generate(estado_del_techo_agrupado)
tabulate estado_del_techo_agrupado
graph pie estado_del_techo_agrupado, over(estado_del_techo_agrupado)
// REGRESION CON ESTA VARIABLE: "ESTADO DEL TECHO"
regress ln_precio_de_alquiler area sexo edad estado_civil_reagrupado nivel_de_instruccion_reagrupado ingreso_laboral numero_de_dormitorios via_de_acceso_principal_agrupado tipo_de_vivienda_agrupado material_de_las_paredes_agrupado cuarto_exclusivo_para_cocinar servicio_higienico_reagrupado agua_recibe_vivienda_agrupado servicio_de_ducha_reagrupado estado_del_techo_agrupado

// Variable 2: "ESTADO DEL PISO > ELEGIDO"

rename vi04b estado_del_piso
tabulate estado_del_piso
graph pie estado_del_piso, over(estado_del_piso)
codebook estado_del_piso
// Bueno = 1, regular, malo = 2
recode estado_del_piso (1=1) (2 3=2), generate(estado_del_piso_agrupado)
tabulate estado_del_piso_agrupado
graph pie estado_del_piso_agrupado, over(estado_del_piso_agrupado)
// REGRESION CON ESTA VARIABLE: "ESTADO DEL PISO"
regress ln_precio_de_alquiler area sexo edad estado_civil_reagrupado nivel_de_instruccion_reagrupado ingreso_laboral numero_de_dormitorios via_de_acceso_principal_agrupado tipo_de_vivienda_agrupado material_de_las_paredes_agrupado cuarto_exclusivo_para_cocinar servicio_higienico_reagrupado agua_recibe_vivienda_agrupado servicio_de_ducha_reagrupado estado_del_techo_agrupado

// Variable 3: "MATERIAL DEL PISO > ELEGIDO"

rename vi04a material_del_piso
tabulate material_del_piso
graph pie material_del_piso, over(material_del_piso)
codebook material_del_piso
// 2 3 4=1 son materiales modernos/de lujo (Ceramica/baldosa/vinil/porcelanato,mármol/marmetón,ladrillo o cemento), 1 5 7 8=2 son materiales tradicionales/... (Duela/ parquet/tablón tratado o piso flotante, tabla/tablón no tratado, tierra, otro material)
recode material_del_piso (2 3 4=1) (1 5 7 8=2), generate(material_del_piso_agrupado)
tabulate material_del_piso_agrupado
graph pie material_del_piso_agrupado, over(material_del_piso_agrupado)
// REGRESION CON ESTA VARIABLE: "MATERIAL DEL PISO"
regress ln_precio_de_alquiler area sexo edad estado_civil_reagrupado nivel_de_instruccion_reagrupado ingreso_laboral numero_de_dormitorios via_de_acceso_principal_agrupado tipo_de_vivienda_agrupado material_de_las_paredes_agrupado cuarto_exclusivo_para_cocinar servicio_higienico_reagrupado agua_recibe_vivienda_agrupado servicio_de_ducha_reagrupado estado_del_techo_agrupado estado_del_piso_agrupado material_del_piso_agrupado

// Variable 4: "ESTADO DE LAS PAREDES"

rename vi05b estado_de_las_paredes
tabulate estado_de_las_paredes
graph pie estado_de_las_paredes, over(estado_de_las_paredes)
codebook estado_de_las_paredes
// Bueno = 1, regular, malo = 2
recode estado_de_las_paredes (1=1) (2 3=2), generate(estado_de_las_paredes_agrupado)
tabulate estado_de_las_paredes_agrupado
graph pie estado_de_las_paredes_agrupado, over(estado_de_las_paredes_agrupado)
// REGRESION CON ESTA VARIABLE: "ESTADO DE LAS PAREDES"
regress ln_precio_de_alquiler area sexo edad estado_civil_reagrupado nivel_de_instruccion_reagrupado ingreso_laboral numero_de_dormitorios via_de_acceso_principal_agrupado tipo_de_vivienda_agrupado material_de_las_paredes_agrupado cuarto_exclusivo_para_cocinar servicio_higienico_reagrupado agua_recibe_vivienda_agrupado servicio_de_ducha_reagrupado estado_del_techo_agrupado estado_del_piso_agrupado material_del_piso_agrupado estado_de_las_paredes_agrupado


// Variable 5: "MATERIAL DEL TECHO O CUBIERTA"

rename vi03a material_del_techo_o_cubierta
tabulate material_del_techo_o_cubierta
graph pie material_del_techo_o_cubierta, over(material_del_techo_o_cubierta)
codebook material_del_techo_o_cubierta
// 1 2 3=1 son materiales modernos (Hormigón(losa,cemento),Fibrocemento/asbesto(eternit,eurolit),Zinc/Aluminio), 4 6=2 son materiales tradicionales (teja, otro material)
recode material_del_techo_o_cubierta (1 2 3=1) (4 6=2), generate(material_techocubierta_agrupado)
tabulate material_techocubierta_agrupado
graph pie material_techocubierta_agrupado, over(material_techocubierta_agrupado)
// REGRESION CON ESTA VARIABLE: "MATERIAL DEL TECHO O CUBIERTA"
regress ln_precio_de_alquiler area sexo edad estado_civil_reagrupado nivel_de_instruccion_reagrupado ingreso_laboral numero_de_dormitorios via_de_acceso_principal_agrupado tipo_de_vivienda_agrupado material_de_las_paredes_agrupado cuarto_exclusivo_para_cocinar servicio_higienico_reagrupado agua_recibe_vivienda_agrupado servicio_de_ducha_reagrupado estado_del_techo_agrupado estado_del_piso_agrupado material_del_piso_agrupado estado_de_las_paredes_agrupado material_techocubierta_agrupado 

// Variable 6: "TIPO DE ALUMBRADO"

rename vi12 tipo_de_alumbrado
tabulate tipo_de_alumbrado
graph pie tipo_de_alumbrado, over(tipo_de_alumbrado)
codebook tipo_de_alumbrado
// REGRESIÓN LOG-LIN NORMAL CON ESTA VARIABLE
regress ln_precio_de_alquiler area sexo edad estado_civil_reagrupado nivel_de_instruccion_reagrupado ingreso_laboral numero_de_dormitorios via_de_acceso_principal_agrupado tipo_de_vivienda_agrupado material_de_las_paredes_agrupado cuarto_exclusivo_para_cocinar servicio_higienico_reagrupado agua_recibe_vivienda_agrupado servicio_de_ducha_reagrupado estado_del_techo_agrupado estado_del_piso_agrupado material_del_piso_agrupado estado_de_las_paredes_agrupado material_techocubierta_agrupado tipo_de_alumbrado

// Variable 7: "COMO ELIMINAN LA BASURA"

rename vi13 como_eliminan_la_basura
tabulate como_eliminan_la_basura
graph pie como_eliminan_la_basura, over(como_eliminan_la_basura)
codebook como_eliminan_la_basura
// 2=1 (Servicio Municipal), 1 3 4=2 (Otras opciones: Contratan el servicio, Botan a la calle/quebrada/río, la queman/entierran, entre otras(ver formulario, ahi pueden haber más))
recode como_eliminan_la_basura (2=1) (1 3 4=2), generate(como_eliminan_basura_reagrupado)
tabulate como_eliminan_basura_reagrupado
graph pie como_eliminan_basura_reagrupado, over(como_eliminan_basura_reagrupado)
// REGRESIÓN LOG-LIN NORMAL CON ESTA VARIABLE
regress ln_precio_de_alquiler area sexo edad estado_civil_reagrupado nivel_de_instruccion_reagrupado ingreso_laboral numero_de_dormitorios via_de_acceso_principal_agrupado tipo_de_vivienda_agrupado material_de_las_paredes_agrupado cuarto_exclusivo_para_cocinar servicio_higienico_reagrupado agua_recibe_vivienda_agrupado servicio_de_ducha_reagrupado estado_del_techo_agrupado estado_del_piso_agrupado material_del_piso_agrupado estado_de_las_paredes_agrupado material_techocubierta_agrupado tipo_de_alumbrado como_eliminan_basura_reagrupado, robust

rvfplot










