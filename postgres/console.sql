create schema actividad01;

create table actividad01.observacion_general
(
    numero           int4         not null,
    observacion      varchar(500) not null,
    jurado           varchar(500) not null,
    fecha            timestamp    not null,
    numero_documento varchar(50)  null,
    sigla            varchar(10)  null,
    numero_grupo     int4         not null,
    numero_ficha     varchar(100) not null,

    constraint pk_observacion_general primary key (numero,numero_grupo,numero_ficha),
    constraint fk_cliente foreign key (numero_documento, sigla) references cliente (numero_documento, sigla),
    constraint fk_grupo_proyecto foreign key (numero_grupo, numero_ficha)
        references actividad01.grupo_proyecto (numero_grupo, numero_ficha)
);

create table actividad01.grupo_proyecto (
    numero_grupo int4 not null,
    nombre_proyecto varchar (300) not null ,
    estado varchar(40) not null,
    numero_ficha varchar(100) not null,

    constraint pk_grupo_proyecto primary key (numero_grupo,numero_ficha),
    constraint fk_ficha foreign key (numero_ficha) references actividad01.ficha(numero_ficha)
);

create table actividad01.ficha
(
    numero_ficha  varchar(100) not null,
    fecha_inicio  date         not null,
    fecha_fin     date         not null,
    ruta          varchar(40)  not null,
    codigo        varchar(50)  not null,
    version       varchar(40)  not null,
    nombre_estado varchar(20)  not null,
    sigla_jornada varchar(20)  not null,

    constraint pk_ficha primary key (numero_ficha),
    constraint fk_programa foreign key (codigo, version) references programa (codigo, version),
    constraint fk_estado_ficha foreign key (nombre_estado) references estado_ficha (nombre_estado),
    constraint fk_jornada foreign key (sigla_jornada) references jornada (sigla_jornada)
);

 create table actividad01.estado_ficha (
     nombre_estado varchar(20) not null ,
     estado int2 not null,

     constraint pk_estad_ficha primary key (nombre_estado)
 );

 create table actividad01.jornada (
     sigla_jornada varchar (20) not null,
     nombre_jornada varchar (40) not null unique,
     descripcion varchar(100) not null,
     imagen_url varchar(1000) null ,
     estado varchar (40) not null,

     constraint pk_jornada primary key (sigla_jornada)
 );

create table actividad01.trimestre (
    nombre_trimestre int4 not null,
    nivel varchar (40) not null,
    sigla_jornada varchar (20) not null,
    estado varchar (40) not null,

    constraint pk_trimestre primary key (nombre_trimestre,nivel,sigla_jornada),
    constraint fk_nivel_formacion foreign key (nivel) references nivel_formacion(nivel),
    constraint fk_jornada foreign key (sigla_jornada) references jornada(sigla_jornada)

);

create table actividad01.ficha_has_trimestre (
    numero_ficha varchar(100) not null ,
    sigla_jornada varchar (20) not null ,
    nivel varchar (40) not null,
    nombre_trimestre int4 not null,

    constraint pk_ficha_has_trimestre primary key (numero_ficha,sigla_jornada,nivel,nombre_trimestre),
   constraint fk_fich foreign key(numero_ficha) references actividad01.ficha(numero_ficha),
   constraint fk_trimestre foreign key (sigla_jornada,nivel,nombre_trimestre)
        references actividad01.trimestre (sigla_jornada,nivel,nombre_trimestre)
        on update cascade on delete restrict
);


create table actividad01.ficha_planeacion (
    numero_ficha varchar (100) not null,
    codigo_planeacion varchar(40) not null,
    estado varchar(40) not null,

    constraint pk_ficha_planeacion primary key (numero_ficha,codigo_planeacion),
    constraint fk_ficha foreign key (numero_ficha) references ficha(numero_ficha),
    constraint fk_planeacion foreign key (codigo_planeacion) references planeacion(codigo)
);

create table actividad01.resultados_vistos (
    codigo_resultado varchar (40)not null,
    codigo_competencia varchar(50) not null ,
    codigo_programa varchar(50)not null ,
    version_programa varchar(40) not null ,
    numero_ficha varchar(100)not null,
    sigla_jornada varchar (20)not null,
    nivel varchar(40) not null,
    nombre_trimestre int4 not null ,
    codigo_planeacion varchar(40) not null,


    constraint pk_resultados_vistos
        primary key (codigo_resultado,codigo_competencia,codigo_programa,version_programa,numero_ficha,
                    sigla_jornada,nivel,nombre_trimestre,codigo_planeacion),
    constraint fk_resultado_aprendizaje
        foreign key (codigo_resultado,codigo_competencia,codigo_programa,version_programa)
        references resultado_aprendizaje(codigo_resultado,codigo_competencia,codigo_programa,version_programa),
    constraint fk_ficha_has_trimestre foreign key (numero_ficha,sigla_jornada,nivel, nombre_trimestre)
        references ficha_has_trimestre(numero_ficha,sigla_jornada,nivel,nombre_trimestre),
    constraint fk_planeacion foreign key (codigo_planeacion) references planeacion(codigo)

);

create table actividad01.nivel_formacion (
    nivel varchar(40) not null ,
    estado varchar(40) not null ,

    constraint pk_nivel_formacion primary key (nivel)
);

create table actividad01.programa (
    codigo varchar(50) not null,
    version varchar(40) not null,
    nombre varchar(500) not null ,
    sigla varchar(40)not null ,
    estado varchar(40)not null ,
    nivel varchar(40)not null ,

    constraint pk_programa primary key (codigo,version),
    constraint fk_nivel_formacion foreign key (nivel) references nivel_formacion(nivel)
);

create table actividad01.competencia (
    codigo_competencia varchar(50)not null,
    denominacion varchar(1000)not null,
    codigo_programa varchar(50) not null,
    version_programa varchar(40) not null ,

    constraint pk_competencia primary key (codigo_competencia,codigo_programa,version_programa),
    constraint fk_programa foreign key (codigo_programa,version_programa) references programa(codigo,version)
);

create table actividad01.planeacion(
    codigo varchar(40) not null ,
    estado varchar(40) not null,
    fecha date not null ,

    constraint pk_planeacion primary key (codigo)
);

create table actividad01.resultado_aprendizaje(
    codigo_resultado varchar(40) not null,
    denominacion varchar(1000) not null,
    codigo_competencia varchar(50) not null ,
    codigo_programa varchar(50) not null,
    version_programa varchar(40) not null ,

    constraint pk_resultado_aprendizaje
        primary key (codigo_resultado,codigo_competencia,codigo_programa,version_programa),
    constraint fk_competencia foreign key (codigo_competencia,codigo_programa,version_programa)
        references competencia(codigo_competencia,codigo_programa,version_programa)
);

create table actividad01.planeacion_trimestre(
    codigo_resultado varchar(40) not null,
    codigo_competencia varchar(50) not null ,
    codigo_programa varchar(50) not null,
    version_programa varchar(40) not null,
    sigla_jornada varchar(20) not null,
    nivel varchar (40) not null,
    nombre_trimestre int4 not null ,
    codigo_planeacion varchar(40) not null,

    constraint pk_planeacion_trimestre primary key (codigo_resultado,codigo_competencia,codigo_programa,
                                    version_programa,sigla_jornada,nivel,nombre_trimestre,codigo_planeacion),
    constraint fk_resultado_aprendizaje foreign key (codigo_resultado,codigo_competencia,codigo_programa,version_programa)
        references resultado_aprendizaje (codigo_resultado,codigo_competencia,codigo_programa,version_programa),
    constraint fk_trimestre foreign key (sigla_jornada,nivel,nombre_trimestre)
        references trimestre(sigla_jornada,nivel,nombre_trimestre),
    constraint fk_planeacion foreign key (codigo_planeacion) references planeacion(codigo)

);

create table actividad01.actividad_planeacion (
    codigo_resultado varchar(40) not null,
    codigo_competencia varchar(50)not null ,
    codigo_programa varchar (50) not null,
    version_programa varchar(40) not null,
    sigla_jornada varchar(20) not null ,
    nivel varchar(40)not null ,
    nombre_trimestre int4 not null,
    nombre_fase varchar(40) not null,
    codigo_proyecto varchar(40)not null ,
    numero_actividad int4 not null,
    codigo_planeacion varchar(40) not null,

    constraint pk_actividad_planeacion primary key (codigo_resultado,codigo_competencia,codigo_programa,
                    version_programa,sigla_jornada,nivel,nombre_trimestre,nombre_fase,codigo_proyecto,
                    numero_actividad,codigo_planeacion),
    constraint fk_planeacion_trimestre
        foreign key (codigo_resultado,codigo_competencia,codigo_programa,version_programa,sigla_jornada,nivel,nombre_trimestre,codigo_planeacion)
        references planeacion_trimestre(codigo_resultado,codigo_competencia,codigo_programa,version_programa,sigla_jornada,nivel,nombre_trimestre,codigo_planeacion),
    constraint fk_actividad_proyecto foreign key (nombre_fase,codigo_proyecto,numero_actividad)
        references actividad_proyecto (nombre_fase,codigo_proyecto,numero_actividad)
);

create table actividad01.integrantes_grupo(
    numero_documento varchar(50)not null,
    sigla varchar(10)not null ,
    numero_ficha varchar(100)not null,
    numero_grupo int4 not null,
    numero_ficha2 varchar(100) not null,

    constraint pk_integrantes_grupo primary key (numero_documento,sigla,numero_ficha,numero_grupo,numero_ficha2),
    constraint fk_aprendiz foreign key (numero_documento,sigla,numero_ficha)
        references aprendiz(numero_documento,sigla,numero_ficha),
    constraint fk_grupo_proyecto foreign key (numero_grupo,numero_ficha2) references grupo_proyecto(numero_grupo,numero_ficha)

);

create table actividad01.lista_chequeo(
    lista varchar(50) not null,
    estado int4 not null ,
    codigo varchar(50)not null,
    version varchar(40) not null,

    constraint pk_lista_chequeo primary key (lista),
    constraint fk_programa foreign key (codigo,version) references programa(codigo,version)
);

create table actividad01.lista_ficha (
   numero_ficha varchar(100) not null,
   lista varchar(50) not null unique,

   constraint fk_ficha foreign key (numero_ficha) references ficha (numero_ficha),
   constraint fk_lista_chequeo foreign key (lista) references lista_chequeo(lista)
);

create table actividad01.valoracion(
    tipo_valoracion varchar(50) not null,
    estado varchar(40) not null,

    constraint pk_valoracion primary key (tipo_valoracion)
);

create table actividad01.item_lista (
    lista varchar(50)not null,
    numero_item int4 not null,
    pregunta varchar(1000) not null,
    id_resultado_aprendizaje int4 not null,
    codigo_resultado varchar(40) not null,
    codigo_competencia varchar(50) not null,
    codigo_programa varchar(50) not null,
    version_programa varchar(40)not null ,

    constraint pk_item_lista primary key (lista,numero_item),
    constraint fk_lista_chequeo foreign key (lista) references lista_chequeo (lista),
    constraint fk_resultado_aprendizaje foreign key
        (codigo_resultado,codigo_competencia,codigo_programa,version_programa)
        references resultado_aprendizaje (codigo_resultado,codigo_competencia, codigo_programa, version_programa)


);

create table actividad01.respuesta_grupo (
    fecha timestamp not null ,
    tipo_valoracion varchar(50) null,
    numero_grupo int4 not null ,
    numero_ficha varchar (100) not null,
    lista varchar(50) not null,
    numero_item int4 not null,

    constraint pk_respuesta_grupo primary key (numero_grupo,numero_ficha,lista,numero_item),
    constraint fk_valoracion foreign key (tipo_valoracion) references valoracion (tipo_valoracion),
    constraint fk_grupo_proyecto foreign key (numero_grupo, numero_ficha) references grupo_proyecto( numero_grupo,numero_ficha),
    constraint fk_item_lista foreign key ( lista,numero_item) references item_lista (lista,numero_item)
);

create table actividad01.observacion_respuesta (
    numero_observacion int4 not null ,
    observacion varchar(400) not null ,
    jurados varchar(400) not null,
    fecha timestamp not null,
    numero_documento varchar(50) null,
    sigla varchar(10) null ,
    numero_grupo int4 not null,
    numero_ficha varchar (100) not null ,
    lista varchar(50) not null ,
    numero_item int4 not null,

    constraint pk_observacion_respuesta primary key (numero_observacion,numero_grupo,numero_ficha,lista,numero_item),
    constraint fk_clien foreign key (numero_documento,sigla) references cliente(numero_documento, sigla),
    constraint fk_respuesta_grupo foreign key (numero_grupo,numero_ficha,lista, numero_item)
            references respuesta_grupo (numero_grupo, numero_ficha,lista,numero_item)
);

create index obserresp_numobs on observacion_respuesta(numero_observacion);

/*sede*/
 create table actividad01.tipo_ambiente (
     tipo varchar (50) not null ,
     descripcion varchar(100) not null,
     estado varchar(40) not null,

     constraint pk_tipo_ambiente primary key (tipo)
 );

create table actividad01.sede (
    nombre_sede varchar(50) not null,
    direccion varchar(400) not null,
    estado varchar(40) not null,

    constraint pk_sede primary key (nombre_sede)
);

create table actividad01.ambiente (
    numero_ambiente varchar (50) not null,
    nombre_sede varchar(50) not null,
    descripcion varchar(1000) not null ,
    estado varchar (40)not null,
    limitacion varchar(40)not null,
    tipo varchar(50) not null,

    constraint pk_ambiente primary key (numero_ambiente,nombre_sede),
    constraint fk_sede foreign key (nombre_sede) references sede(nombre_sede),
    constraint fk_tipo_ambiente foreign key (tipo) references tipo_ambiente (tipo)
);

create table actividad01.limitacion_ambiente (
    numero_ambiente varchar(50) not null,
    nombre_sede varchar (50) not null,
    codigo_resultado varchar(40)not null,
    codigo_competencia varchar(50) not null,
    codigo_programa varchar (50) not null,
    version_programa varchar(40) not null,

    constraint pk_limitacion_ambiente primary key (numero_ambiente,nombre_sede,
                codigo_resultado,codigo_competencia,codigo_programa, version_programa),
    constraint fk_ambiente foreign key (numero_ambiente, nombre_sede)
        references ambiente(numero_ambiente, nombre_sede),
    constraint fk_resultado_aprendizaje
        foreign key ( codigo_resultado,codigo_competencia,codigo_programa,version_programa)
        references resultado_aprendizaje (codigo_resultado,codigo_competencia,codigo_programa,version_programa)
);

/* proyectos*/

create table actividad01.proyecto (
    codigo varchar(40) not null ,
    nombre varchar(500)not null ,
    estado varchar(40) not null,
    codigo_programa varchar(50) not null,
    version varchar(40) not null,

    constraint pk_proyecto primary key (codigo),
    constraint fk_programa foreign key (codigo_programa,version) references programa(codigo,version)
);

create table actividad01.fase(
    nombre varchar(40) not null,
    estado varchar(40) not null,
    codigo_proyecto varchar(40),

    constraint pk_fase primary key (nombre,codigo_proyecto),
    constraint fk_proyecto foreign key (codigo_proyecto) references proyecto (codigo)
);

create table actividad01.actividad_proyecto(
    numero_actividad int4 not null,
    descripcion_actividad varchar(400) not null,
    estado varchar(40) not null,
    nombre_fase varchar(40) not null,
    codigo_proyecto varchar(40) not null,

    constraint pk_actividad_proyecto primary key (numero_actividad,nombre_fase,codigo_proyecto),
    constraint fk_fase foreign key (nombre_fase, codigo_proyecto) references fase(nombre,codigo_proyecto)
);

/* horrarios */

create table actividad01.dia(
    nombre_dia varchar(40) not null ,
    estado varchar(40) not null,

    constraint pk_dia primary key (nombre_dia)
);

create table actividad01.horario (
    hora_inicio time not null ,
    hora_fin time not null ,
    numero_documento varchar (50) not null,
    sigla varchar (10) not null,
    numero_ambiente varchar (50) not null,
    nombre_sede varchar(50) not null,
    numero_ficha varchar(100) not null,
    sigla_jornada varchar(20) not null,
    nivel varchar(40) not null,
    nombre_trimestre int4 not null ,
    nombre_dia varchar(40) not null,
    nombre_modalidad varchar(40) not null,
    numero_version varchar(40) not null,
    number_year int4 not null,
    trimestre_programado int4 not null,

    constraint pk_horario primary key (hora_inicio,numero_documento,sigla,numero_ambiente,nombre_sede,
                    numero_ficha,sigla_jornada,nivel,nombre_trimestre,nombre_dia,numero_version,
                    number_year,trimestre_programado),
    constraint fk_instructor foreign key (numero_documento,sigla) references instructor(numero_documento,sigla),
    constraint fk_ambiente foreign key (numero_ambiente,nombre_sede) references ambiente(numero_ambiente,nombre_sede),
    constraint fk_ficha_has_trimestre foreign key (numero_ficha,sigla_jornada,nivel,nombre_trimestre)
        references ficha_has_trimestre(numero_ficha,sigla_jornada,nivel,nombre_trimestre),
    constraint fk_dia foreign key (nombre_dia) references dia (nombre_dia),
    constraint fk_modalidad foreign key (nombre_modalidad) references modalidad(nombre_modalidad),
    constraint fk_version_horario foreign key (numero_version,number_year,trimestre_programado)
        references version_horario(numero_version,number_year,trimestre_programado)
);

create table actividad01.modalidad (
    nombre_modalidad varchar(40) not null,
    color varchar(50) not null,
    estado varchar (40) not null ,

    constraint pk_modalidad primary key (nombre_modalidad)

);

create table actividad01.trimestre_vigente (
    trimestre_programado int4 not null,
    fecha_inicio date  not null,
    fecha_fin date not null,
    estado varchar (40) not null,
    number_year int4 not null,

    constraint pk_trimestre_vigente primary key (trimestre_programado,number_year),
    constraint fk_trimestre_vigente foreign key (number_year) references year (number_year)
);

create table actividad01.version_horario(
    numero_version varchar(40) not null,
    estado varchar(40) not null,
    number_year int4 not null,
    trimestre_programado int not null ,

    constraint pk_version_horario primary key (numero_version,number_year,trimestre_programado),
    constraint fk_trimestre_vigente foreign key (number_year,trimestre_programado)
        references trimestre_vigente(number_year,trimestre_programado)
);

create index verhor_numver on version_horario(numero_version);


/*...*/
create table actividad01.year(
    number_year int4 not null,
    estado varchar(40) not null,

    constraint pk_year primary key (number_year)

);

create table actividad01.vinculacion (
    tipo_vinculacion varchar(40) not null,
    horas int4 not null,
    estado varchar(40) not null,

    constraint pk_vinculacion primary key (tipo_vinculacion)

);

create table actividad01.jornada_instructor(
    nombre_jornada varchar (80) not null,
    descripcion varchar(200) not null,
    estado varchar(40) not null ,

    constraint pk_jornada_instructor primary key (nombre_jornada)
 );

create table actividad01.dia_jornada
(
    hora_inicio    int4        not null,
    hora_fin       int4        not null,
    nombre_jornada varchar(80) not null,
    nombre_dia     varchar(40) not null,

    constraint pk_dia_jornada primary key (hora_inicio, hora_fin,nombre_jornada,nombre_dia),
    constraint fk_jornada_instructor foreign key (nombre_jornada) references jornada_instructor (nombre_jornada),
    constraint fk_dia foreign key (nombre_dia) references dia (nombre_dia)
);

create table actividad01.vinculacion_intructor(
    fecha_inicio date not null,
    fecha_fin date not null,
    numero_documento varchar(50) not null,
    sigla varchar(10) not null,
    number_year int4 not null,
    tipo_vinculacion varchar(40) not null,

    constraint pk_vinculacion_instructor primary key (fecha_inicio,numero_documento,sigla,
                                                      number_year,tipo_vinculacion),
    constraint fk_instructor foreign key (numero_documento,sigla) references instructor(numero_documento,sigla),
    constraint fk_year foreign key (number_year) references year(number_year),
    constraint fk_vinculacion foreign key (tipo_vinculacion) references vinculacion(tipo_vinculacion)
);

create table actividad01.disponibilidad_horaria(
    numero_documento varchar(50) not null,
    sigla varchar(10) not null ,
    number_year int4 not null,
    tipo_vinculacion varchar(40) not null,
    fecha_inicio date not null,
    nombre_jornada varchar(80) not null,

    constraint pk_disponobilidad_horaria primary key (numero_documento,sigla,number_year,
                                                      tipo_vinculacion,fecha_inicio,nombre_jornada),
    constraint fk_vinculacion_instructor foreign key (numero_documento,sigla,number_year,tipo_vinculacion,fecha_inicio)
        references vinculacion_intructor(numero_documento,sigla,number_year,tipo_vinculacion,fecha_inicio),
    constraint fk_jornada_instructor foreign key (nombre_jornada) references jornada_instructor(nombre_jornada)

);

create table actividad01.area(
    nombre_area varchar(40) not null ,
    estado varchar(40) not null,
    url_logo varchar(1000) null ,

    constraint pk_area primary key (nombre_area)
);

create table actividad01.instructor(
    estado varchar(40) not null,
    numero_documento varchar(50) not null,
    sigla varchar(10) not null,

    constraint  pk_instructor primary key (numero_documento,sigla),
    constraint fk_cliente foreign key (numero_documento,sigla) references cliente(numero_documento,sigla)
);

create table actividad01.area_instructor(
    numero_documento varchar(50) not null,
    sigla varchar(10) not null,
    nombre_area varchar(40) not null,
    estado varchar(40) not null,

    constraint pk_area_instructor primary key (numero_documento,sigla,nombre_area),
    constraint fk_instructor foreign key (numero_documento,sigla) references instructor(numero_documento,sigla),
    constraint fk_area foreign key (nombre_area) references area(nombre_area)

);

create table actividad01.disponibilidad_competencias(
    codigo_competencia  varchar(50) not null,
    codigo_programa varchar(50)not null,
    version_programa varchar(40) not null,
    numero_documento varchar(50) not null,
    sigla varchar(10) not null,
    number_year int4 not null ,
    tipo_vinculacion varchar(40)not null,
    fecha_inicio date not null,


    constraint pk_dispo_compe primary key (codigo_competencia,codigo_programa,version_programa,
                    numero_documento,sigla, number_year,tipo_vinculacion,fecha_inicio),
    constraint fk_competencia foreign key (codigo_competencia,codigo_programa,version_programa)
        references competencia(codigo_competencia, codigo_programa,version_programa),
    constraint fk_vinculacion_instructor foreign key (numero_documento,sigla,number_year, tipo_vinculacion,fecha_inicio)
        references vinculacion_intructor (numero_documento,sigla,number_year,tipo_vinculacion,fecha_inicio)

);


/*primeras tablas*/


create table actividad01.tipo_documento
(
    sigla            varchar(10)  not null,
    nombre_documento varchar(100) not null,
    estado           varchar(40)  not null,

    constraint uc_nombre_documento unique (nombre_documento),
    constraint pk_tipo_documento primary key (sigla)
);

create table actividad01.user
(
    login          varchar(50)  not null,
    password       varchar(60)  not null,
    email          varchar(254) not null unique,
    activated      int          not null,
    lang_key       varchar(6)   not null,
    image_url      varchar(256),
    activation_key varchar(20),
    reset_key      varchar(20),
    reset_day      timestamp,
    constraint pk_user primary key (login)
);

create table actividad01.cliente
(
    numero_documento varchar(50) not null,
    primer_nombre    varchar(50) not null,
    segundo_nombre   varchar(50) null,
    primer_apellido  varchar(50) not null,
    segundo_apellido varchar(50) null,
    sigla            varchar(10) not null,
    login            varchar(50) not null,
    constraint pk_cliente primary key (sigla, numero_documento),
    constraint fk_tipo_documento foreign key (sigla) references actividad01.tipo_documento (sigla)
        on UPDATE cascade on DELETE restrict,
    constraint fk_user foreign key (login) references actividad01.user (login)
        on UPDATE CASCADE on DELETE RESTRICT,
    constraint uc_login unique (login)
);

create table actividad01.user_authority (
    name varchar (50)not null,
    login varchar (50)not null,

    constraint pk_user_authority primary key (name,login),
    constraint fk_rol foreign key (name) references actividad01.rol(name),
    constraint fk_user foreign key (login) references actividad01.user (login)
);

create table actividad01.rol (
    name varchar (50)not null,

    constraint pk_rol primary key (name)

);

create table actividad01.log_errores (
    id int4 not null,
    nivel varchar(400) not null,
    log_name varchar(400) not null,
    mensajes varchar(400) not null,
    fecha date not null,
    numero_documento varchar(50) not null,
    sigla varchar(10)not null,

    constraint pk_log_errores primary key (id),

    constraint fk_cliente foreign key (numero_documento,sigla) references actividad01.cliente (numero_documento,sigla)

);

create table actividad01.log_auditoria(
    id int4 not null,
    nivel varchar(400) not null,
    log_name varchar (400) not null,
    mensaje varchar(400) not null,
    fecha int4 not null,
    numero_documento varchar(50)not null,
    sigla varchar (10) not null,

    constraint pk_log_auditoria primary key (id),
    constraint fk_cliente foreign key (numero_documento,sigla) references cliente(numero_documento,sigla)

);

create table actividad01.estado_formacion (
    nombre_estado varchar (40) not null,
    estado varchar (40) not null,

    constraint pk_estado_ficha primary key (nombre_estado)
);

create table actividad01.aprendiz (
    numero_documento varchar (50) not null,
    sigla varchar(10) not null,
    numero_ficha varchar (100) not null ,
    nombre_estado varchar (40) not null,

    constraint pk_aprendiz primary key (numero_documento,sigla,numero_ficha),
    constraint fk_cliente foreign key (numero_documento,sigla) references cliente (numero_documento,sigla),
    constraint fk_ficha foreign key (numero_ficha) references ficha (numero_ficha),
    constraint fk_estado_formacion foreign key (nombre_estado) references estado_formacion(nombre_estado)
);