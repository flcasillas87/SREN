


SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE EXTENSION IF NOT EXISTS "pg_cron" WITH SCHEMA "pg_catalog";






COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "wrappers" WITH SCHEMA "extensions";






CREATE OR REPLACE FUNCTION "public"."actualizar_timestamp"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  NEW.actualizado_en := now();
  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."actualizar_timestamp"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."set_created_at_mx"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    IF NEW.created_at IS NULL THEN
        NEW.created_at := timezone('America/Mexico_City', now());
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."set_created_at_mx"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."set_fecha_vigencia_sig"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  IF NEW.fecha_vigencia IS NULL THEN
    NEW.fecha_vigencia := NEW.fecha_emision + INTERVAL '1 year';
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."set_fecha_vigencia_sig"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."set_updated_at_mx"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    NEW.updated_at := timezone('America/Mexico_City', now());
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."set_updated_at_mx"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."validar_tipo_punto_gas"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
    v_codigo_tipo TEXT;
BEGIN
    SELECT codigo
    INTO v_codigo_tipo
    FROM cat_tipo_punto_gas
    WHERE id_tipo_punto = NEW.tipo_punto_id;

    IF v_codigo_tipo = 'CENTRAL' AND NEW.central_id IS NULL THEN
        RAISE EXCEPTION 'Punto tipo CENTRAL requiere central_id';
    END IF;

    IF v_codigo_tipo = 'GASODUCTO' AND NEW.gasoducto_id IS NULL THEN
        RAISE EXCEPTION 'Punto tipo GASODUCTO requiere gasoducto_id';
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."validar_tipo_punto_gas"() OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."cat_combustibles" (
    "id_combustible" integer NOT NULL,
    "nombre" character varying(50) NOT NULL,
    "descripcion" "text",
    "tipo" "text",
    "es_activo" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone
);


ALTER TABLE "public"."cat_combustibles" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."cat_combustibles_id_combustible_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."cat_combustibles_id_combustible_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."cat_combustibles_id_combustible_seq" OWNED BY "public"."cat_combustibles"."id_combustible";



CREATE TABLE IF NOT EXISTS "public"."cat_estado_operativo" (
    "id_estado" integer NOT NULL,
    "estado" character varying(50) NOT NULL,
    "descripcion" "text",
    "es_activo" boolean DEFAULT true
);


ALTER TABLE "public"."cat_estado_operativo" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."cat_estado_operativo_id_estado_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."cat_estado_operativo_id_estado_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."cat_estado_operativo_id_estado_seq" OWNED BY "public"."cat_estado_operativo"."id_estado";



CREATE TABLE IF NOT EXISTS "public"."cat_gasoductos" (
    "id_gasoducto" integer NOT NULL,
    "codigo" character varying(50) NOT NULL,
    "nombre" character varying(150) NOT NULL,
    "operador" character varying(150),
    "propietario" character varying(150),
    "tipo" character varying(50),
    "diametro_pulgadas" numeric(5,2),
    "presion_maxima_psi" numeric(10,2),
    "longitud_km" numeric(10,2),
    "origen" character varying(150),
    "destino" character varying(150),
    "es_activo" boolean DEFAULT true,
    "created_at" timestamp without time zone DEFAULT "now"(),
    "updated_at" timestamp without time zone
);


ALTER TABLE "public"."cat_gasoductos" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."cat_gasoductos_id_gasoducto_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."cat_gasoductos_id_gasoducto_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."cat_gasoductos_id_gasoducto_seq" OWNED BY "public"."cat_gasoductos"."id_gasoducto";



CREATE TABLE IF NOT EXISTS "public"."cat_puntos_gas" (
    "id_punto_gas" integer NOT NULL,
    "codigo" character varying(50) NOT NULL,
    "nombre" character varying(150) NOT NULL,
    "tipo_punto_id" integer NOT NULL,
    "central_id" integer,
    "gasoducto_id" integer,
    "ubicacion" character varying(200),
    "descripcion" "text",
    "es_activo" boolean DEFAULT true,
    "created_at" timestamp without time zone DEFAULT "now"(),
    "updated_at" timestamp without time zone
);


ALTER TABLE "public"."cat_puntos_gas" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."cat_puntos_gas_id_punto_gas_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."cat_puntos_gas_id_punto_gas_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."cat_puntos_gas_id_punto_gas_seq" OWNED BY "public"."cat_puntos_gas"."id_punto_gas";



CREATE TABLE IF NOT EXISTS "public"."cat_tipo_punto_gas" (
    "id_tipo_punto" integer NOT NULL,
    "codigo" character varying(30) NOT NULL,
    "descripcion" character varying(150) NOT NULL
);


ALTER TABLE "public"."cat_tipo_punto_gas" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."cat_tipo_punto_gas_id_tipo_punto_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."cat_tipo_punto_gas_id_tipo_punto_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."cat_tipo_punto_gas_id_tipo_punto_seq" OWNED BY "public"."cat_tipo_punto_gas"."id_tipo_punto";



CREATE TABLE IF NOT EXISTS "public"."cat_tipo_punto_gas_natural" (
    "id_tipo_punto" integer NOT NULL,
    "codigo" character varying(30) NOT NULL,
    "descripcion" character varying(150) NOT NULL
);


ALTER TABLE "public"."cat_tipo_punto_gas_natural" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."cat_tipo_punto_gas_natural_id_tipo_punto_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."cat_tipo_punto_gas_natural_id_tipo_punto_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."cat_tipo_punto_gas_natural_id_tipo_punto_seq" OWNED BY "public"."cat_tipo_punto_gas_natural"."id_tipo_punto";



CREATE TABLE IF NOT EXISTS "public"."centrales_generacion" (
    "id_centrales_generacion" bigint NOT NULL,
    "nombre_central" "text" NOT NULL,
    "ubicacion_estado" "text" NOT NULL,
    "ubicacion_municipio" "text",
    "tipo_central" "text" NOT NULL,
    "estado_operacion" "text" NOT NULL,
    "capacidad_mw" numeric,
    "combustible_principal" "text",
    "combustible_secundario" "text",
    "created_at" timestamp with time zone DEFAULT ("now"() AT TIME ZONE 'America/Mexico_City'::"text"),
    "updated_at" timestamp with time zone
);


ALTER TABLE "public"."centrales_generacion" OWNER TO "postgres";


COMMENT ON TABLE "public"."centrales_generacion" IS 'Cat├ílogo de centrales de generaci├│n el├®ctrica';



COMMENT ON COLUMN "public"."centrales_generacion"."id_centrales_generacion" IS 'Identificador ├║nico de la central (clave primaria)';



COMMENT ON COLUMN "public"."centrales_generacion"."tipo_central" IS 'Tipo de tecnolog├¡a de generaci├│n (ej. T├®rmica, Hidroel├®ctrica, Solar, E├│lica).';



COMMENT ON COLUMN "public"."centrales_generacion"."capacidad_mw" IS 'Capacidad instalada de la central en Megawatts (MW).';



ALTER TABLE "public"."centrales_generacion" ALTER COLUMN "id_centrales_generacion" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."centrales_central_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."compras_combustible" (
    "id_centrales_generacion" bigint,
    "fecha_compra" "date" NOT NULL,
    "tipo_combustible" character varying(50) NOT NULL,
    "volumen_gj" numeric(12,2) NOT NULL,
    "precio_unitario" numeric(10,4) NOT NULL,
    "importe_total" numeric(14,2) GENERATED ALWAYS AS ((COALESCE("volumen_gj", (0)::numeric) * COALESCE("precio_unitario", (0)::numeric))) STORED,
    "proveedor" character varying(100) DEFAULT 'CFEnergia'::character varying,
    "documento_referencia" character varying(100),
    "observaciones" "text",
    "created_at" timestamp without time zone DEFAULT "now"(),
    "id_proveedor" integer,
    "id_compras_combustible" integer NOT NULL,
    "precio_servicio" numeric(10,4),
    "importe_servicio" numeric(14,2) GENERATED ALWAYS AS ((COALESCE("volumen_gj", (0)::numeric) * COALESCE("precio_servicio", (0)::numeric))) STORED,
    "precio_ponderado" numeric(14,4) GENERATED ALWAYS AS (
CASE
    WHEN (NULLIF("volumen_gj", (0)::numeric) IS NULL) THEN NULL::numeric
    ELSE (COALESCE("precio_unitario", (0)::numeric) + COALESCE("precio_servicio", (0)::numeric))
END) STORED,
    "updated_at" timestamp without time zone DEFAULT "now"()
);


ALTER TABLE "public"."compras_combustible" OWNER TO "postgres";


ALTER TABLE "public"."compras_combustible" ALTER COLUMN "id_compras_combustible" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."compras_combustible_id_compra_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."contratos_transporte" (
    "id_contrato" integer NOT NULL,
    "id_transportista" integer,
    "numero_contrato" character varying(50) NOT NULL,
    "fecha_inicio" "date" NOT NULL,
    "fecha_fin" "date",
    "tarifa_diaria_mxn" numeric(10,4) NOT NULL,
    "condiciones" "text",
    "created_at" timestamp without time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone
);


ALTER TABLE "public"."contratos_transporte" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."contratos_transporte_id_contrato_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."contratos_transporte_id_contrato_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."contratos_transporte_id_contrato_seq" OWNED BY "public"."contratos_transporte"."id_contrato";



CREATE TABLE IF NOT EXISTS "public"."gasoductos_info_general" (
    "gasoducto_id" integer NOT NULL,
    "gasoducto_ubicacion" "text" NOT NULL,
    "gasoducto_capacidad" numeric(12,2) NOT NULL,
    "gasoducto_longitud_km" numeric(10,2) NOT NULL,
    "gasoducto_diametro_pulgadas" numeric(6,2) NOT NULL,
    "gasoducto_fecha_inicio" "date",
    "gasoducto_fecha_conclusion" "date",
    "gasoducto_importe_contratado_usd" numeric(18,2),
    "gasoducto_puntos_entrega" "text",
    "transportistas" "text",
    "creado_en" timestamp with time zone DEFAULT "now"(),
    "actualizado_en" timestamp with time zone DEFAULT "now"(),
    "created_at" timestamp with time zone,
    "updated_at" timestamp with time zone
);


ALTER TABLE "public"."gasoductos_info_general" OWNER TO "postgres";


COMMENT ON TABLE "public"."gasoductos_info_general" IS 'Tabla que almacena informaci├│n general';



COMMENT ON COLUMN "public"."gasoductos_info_general"."gasoducto_ubicacion" IS 'Ubicaci├│n o regi├│n donde se encuentra el gasoducto.';



COMMENT ON COLUMN "public"."gasoductos_info_general"."gasoducto_capacidad" IS 'Capacidad m├íxima del gasoducto (ejemplo: millones de pies c├║bicos diarios).';



COMMENT ON COLUMN "public"."gasoductos_info_general"."gasoducto_longitud_km" IS 'Longitud total del gasoducto en kil├│metros.';



COMMENT ON COLUMN "public"."gasoductos_info_general"."gasoducto_diametro_pulgadas" IS 'Di├ímetro nominal del gasoducto en pulgadas.';



COMMENT ON COLUMN "public"."gasoductos_info_general"."gasoducto_fecha_inicio" IS 'Fecha de inicio de la obra o del contrato.';



COMMENT ON COLUMN "public"."gasoductos_info_general"."gasoducto_fecha_conclusion" IS 'Fecha de conclusi├│n o entrada en operaci├│n.';



COMMENT ON COLUMN "public"."gasoductos_info_general"."gasoducto_importe_contratado_usd" IS 'Importe total contratado en d├│lares estadounidenses.';



COMMENT ON COLUMN "public"."gasoductos_info_general"."gasoducto_puntos_entrega" IS 'Puntos o estaciones de entrega de gas asociadas al gasoducto.';



COMMENT ON COLUMN "public"."gasoductos_info_general"."transportistas" IS 'Empresas transportistas o contratistas responsables.';



COMMENT ON COLUMN "public"."gasoductos_info_general"."creado_en" IS 'Fecha y hora de creaci├│n del registro.';



COMMENT ON COLUMN "public"."gasoductos_info_general"."actualizado_en" IS 'Fecha y hora de la ├║ltima actualizaci├│n del registro.';



CREATE SEQUENCE IF NOT EXISTS "public"."gasoductos_info_general_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."gasoductos_info_general_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."gasoductos_info_general_id_seq" OWNED BY "public"."gasoductos_info_general"."gasoducto_id";



CREATE TABLE IF NOT EXISTS "public"."inspecciones_tanque" (
    "id_inspeccion" integer NOT NULL,
    "id_tanque" integer,
    "fecha_inspeccion" "date",
    "resultado" character varying(50),
    "acciones_recomendadas" "text",
    "created_at" timestamp with time zone,
    "updated_at" timestamp with time zone
);


ALTER TABLE "public"."inspecciones_tanque" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."inspecciones_tanque_id_inspeccion_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."inspecciones_tanque_id_inspeccion_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."inspecciones_tanque_id_inspeccion_seq" OWNED BY "public"."inspecciones_tanque"."id_inspeccion";



CREATE TABLE IF NOT EXISTS "public"."operacion_gas_diaria" (
    "id_operacion" bigint NOT NULL,
    "fecha" "date" NOT NULL,
    "anio" integer GENERATED ALWAYS AS (EXTRACT(year FROM "fecha")) STORED,
    "mes" integer GENERATED ALWAYS AS (EXTRACT(month FROM "fecha")) STORED,
    "dia" integer GENERATED ALWAYS AS (EXTRACT(day FROM "fecha")) STORED,
    "gasoducto_id" integer NOT NULL,
    "punto_inyeccion" character varying(150) NOT NULL,
    "punto_extraccion" character varying(150) NOT NULL,
    "cmd_mmbtu_dia" numeric(14,4),
    "energia_gj" numeric(14,4),
    "energia_mmbtu" numeric(14,4),
    "volumen_m3" numeric(14,4),
    "presion_bar" numeric(10,4),
    "temperatura_c" numeric(10,4),
    "poder_calorifico_mj_m3" numeric(10,4),
    "fuente_datos" character varying(100),
    "observaciones" "text",
    "created_at" timestamp without time zone DEFAULT "now"(),
    "updated_at" timestamp without time zone,
    CONSTRAINT "chk_valores_no_negativos" CHECK ((("energia_gj" >= (0)::numeric) AND ("energia_mmbtu" >= (0)::numeric) AND ("volumen_m3" >= (0)::numeric)))
);


ALTER TABLE "public"."operacion_gas_diaria" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."operacion_gas_diaria_id_operacion_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."operacion_gas_diaria_id_operacion_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."operacion_gas_diaria_id_operacion_seq" OWNED BY "public"."operacion_gas_diaria"."id_operacion";



CREATE TABLE IF NOT EXISTS "public"."procedimientos_instructivos" (
    "proceso" "text",
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "tipo" "text",
    "codigo" "text",
    "titulo" "text",
    "descripcion" "text",
    "area_responsable" "text",
    "version" "text",
    "fecha_emision" "date",
    "fecha_vigencia" "date",
    "estado" "text" DEFAULT 'Vigente'::"text",
    "url_documento" "text",
    "marco_normativo" "text",
    "creado_por" "text",
    "creado_en" timestamp with time zone,
    "actualizado_en" timestamp with time zone,
    "Mecanismo de Control" "text",
    CONSTRAINT "procedimientos_instructivos_estado_check" CHECK (("estado" = ANY (ARRAY['Vigente'::"text", 'Obsoleto'::"text", 'En revisi├│n'::"text"]))),
    CONSTRAINT "procedimientos_instructivos_tipo_check" CHECK (("tipo" = ANY (ARRAY['Procedimiento'::"text", 'Instructivo'::"text"])))
);


ALTER TABLE "public"."procedimientos_instructivos" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."proveedores_combustible" (
    "id_proveedor" integer NOT NULL,
    "nombre_proveedor" character varying(100) NOT NULL,
    "created_at" timestamp with time zone,
    "updated_at" timestamp with time zone
);


ALTER TABLE "public"."proveedores_combustible" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."proveedores_combustible_id_proveedor_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."proveedores_combustible_id_proveedor_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."proveedores_combustible_id_proveedor_seq" OWNED BY "public"."proveedores_combustible"."id_proveedor";



CREATE TABLE IF NOT EXISTS "public"."staging_compras_combustible" (
    "central_id" bigint,
    "fecha_compra" "text",
    "tipo_combustible" "text",
    "volumen_gj" bigint,
    "precio_unitario" double precision,
    "importe_total" double precision,
    "proveedor" "text",
    "documento_referencia" "text",
    "observaciones" "text",
    "created_at" "text",
    "id_proveedor" "text",
    "id_compra" bigint,
    "precio_servicio" double precision,
    "importe_servicio" double precision,
    "precio_ponderado" double precision,
    "updated_at" "text"
);


ALTER TABLE "public"."staging_compras_combustible" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."staging_normalized" (
    "id_compra_num" bigint,
    "fecha_compra_date" "date",
    "central_id_num" integer,
    "tipo_combustible_text" "text",
    "volumen_gj_num" numeric,
    "precio_unitario_num" numeric,
    "precio_servicio_num" numeric,
    "proveedor_text" "text",
    "documento_referencia_text" "text",
    "observaciones_text" "text",
    "created_at" timestamp with time zone,
    "updated_at" timestamp with time zone
);


ALTER TABLE "public"."staging_normalized" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."tanques_almacenamiento" (
    "id_tanque" integer NOT NULL,
    "nombre_tanque" "text",
    "id_combustible" integer,
    "id_estado" integer,
    "fecha_instalacion" "date",
    "central_id" integer NOT NULL,
    "capacidad_nominal_l" numeric(12,2),
    "volumen_actual_l" numeric(12,2),
    "created_at" timestamp without time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone,
    "volumen_actual_m3" numeric,
    "instrumento_medicion" "text",
    "comentarios" "text",
    CONSTRAINT "chk_volumen_no_supera_capacidad" CHECK (("volumen_actual_l" <= "capacidad_nominal_l")),
    CONSTRAINT "tanques_almacenamiento_capacidad_nominal_l_check" CHECK (("capacidad_nominal_l" > (0)::numeric)),
    CONSTRAINT "tanques_almacenamiento_fecha_instalacion_check" CHECK (("fecha_instalacion" <= CURRENT_DATE)),
    CONSTRAINT "tanques_almacenamiento_volumen_actual_l_check" CHECK (("volumen_actual_l" >= (0)::numeric))
);


ALTER TABLE "public"."tanques_almacenamiento" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."tanques_almacenamiento_id_tanque_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."tanques_almacenamiento_id_tanque_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."tanques_almacenamiento_id_tanque_seq" OWNED BY "public"."tanques_almacenamiento"."id_tanque";



CREATE TABLE IF NOT EXISTS "public"."tarifas_contrato_mensual" (
    "id_tarifa" integer NOT NULL,
    "id_contrato" integer,
    "mes_servicio" "date" NOT NULL,
    "tarifa_mensual" numeric(12,4) NOT NULL,
    "moneda" character varying(10) NOT NULL,
    "unidad_energia" character varying(10) NOT NULL,
    "factor_conversion_gj" numeric(10,6),
    "observaciones" "text",
    "created_at" timestamp without time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone,
    CONSTRAINT "tarifas_contrato_mensual_moneda_check" CHECK ((("moneda")::"text" = ANY ((ARRAY['MXN'::character varying, 'USD'::character varying])::"text"[]))),
    CONSTRAINT "tarifas_contrato_mensual_unidad_energia_check" CHECK ((("unidad_energia")::"text" = ANY ((ARRAY['GJ'::character varying, 'MMBtu'::character varying])::"text"[])))
);


ALTER TABLE "public"."tarifas_contrato_mensual" OWNER TO "postgres";


COMMENT ON TABLE "public"."tarifas_contrato_mensual" IS 'Registro mensual de tarifas aplicadas por contrato de transporte, con moneda y unidad energ├®tica especificadas para trazabilidad SIG y POA.';



COMMENT ON COLUMN "public"."tarifas_contrato_mensual"."tarifa_mensual" IS 'Valor num├®rico de la tarifa mensual aplicada.';



COMMENT ON COLUMN "public"."tarifas_contrato_mensual"."moneda" IS 'Moneda en la que se expresa la tarifa: MXN (pesos) o USD (d├│lares).';



COMMENT ON COLUMN "public"."tarifas_contrato_mensual"."unidad_energia" IS 'Unidad energ├®tica de la tarifa: GJ o MMBtu.';



COMMENT ON COLUMN "public"."tarifas_contrato_mensual"."factor_conversion_gj" IS 'Factor de conversi├│n a GJ si la tarifa est├í en MMBtu (opcional).';



CREATE SEQUENCE IF NOT EXISTS "public"."tarifas_contrato_mensual_id_tarifa_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."tarifas_contrato_mensual_id_tarifa_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."tarifas_contrato_mensual_id_tarifa_seq" OWNED BY "public"."tarifas_contrato_mensual"."id_tarifa";



CREATE TABLE IF NOT EXISTS "public"."transportistas" (
    "id_transportista" integer NOT NULL,
    "nombre_transportista" character varying(100) NOT NULL,
    "rfc" character varying(13),
    "contacto" character varying(100),
    "created_at" timestamp without time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone
);


ALTER TABLE "public"."transportistas" OWNER TO "postgres";


COMMENT ON TABLE "public"."transportistas" IS 'Cat├ílogo de empresas transportistas vinculadas a contratos de suministro y reserva de capacidad.';



COMMENT ON COLUMN "public"."transportistas"."id_transportista" IS 'Identificador ├║nico del transportista (clave primaria).';



COMMENT ON COLUMN "public"."transportistas"."nombre_transportista" IS 'Nombre comercial o raz├│n social del transportista.';



COMMENT ON COLUMN "public"."transportistas"."rfc" IS 'Registro Federal de Contribuyentes del transportista.';



COMMENT ON COLUMN "public"."transportistas"."contacto" IS 'Persona o medio de contacto institucional (nombre, correo, tel├®fono).';



COMMENT ON COLUMN "public"."transportistas"."created_at" IS 'Fecha y hora de registro en el sistema (generada autom├íticamente).';



CREATE SEQUENCE IF NOT EXISTS "public"."transportistas_id_transportista_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."transportistas_id_transportista_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."transportistas_id_transportista_seq" OWNED BY "public"."transportistas"."id_transportista";



CREATE OR REPLACE VIEW "public"."vista_triggers_funciones" AS
 SELECT "tg"."tgname" AS "nombre_trigger",
    "c"."relname" AS "tabla_afectada",
    "p"."proname" AS "funcion_asociada",
    "l"."lanname" AS "lenguaje_funcion",
        CASE
            WHEN ((("tg"."tgtype")::integer & 1) = 1) THEN 'AFTER'::"text"
            WHEN ((("tg"."tgtype")::integer & 66) = 66) THEN 'INSTEAD OF'::"text"
            ELSE 'BEFORE'::"text"
        END AS "momento",
    (ARRAY[
        CASE
            WHEN ((("tg"."tgtype")::integer & 4) = 4) THEN 'INSERT'::"text"
            ELSE NULL::"text"
        END,
        CASE
            WHEN ((("tg"."tgtype")::integer & 8) = 8) THEN 'DELETE'::"text"
            ELSE NULL::"text"
        END,
        CASE
            WHEN ((("tg"."tgtype")::integer & 16) = 16) THEN 'UPDATE'::"text"
            ELSE NULL::"text"
        END,
        CASE
            WHEN ((("tg"."tgtype")::integer & 32) = 32) THEN 'TRUNCATE'::"text"
            ELSE NULL::"text"
        END] || '{}'::"text"[]) AS "eventos"
   FROM (((("pg_trigger" "tg"
     JOIN "pg_class" "c" ON (("tg"."tgrelid" = "c"."oid")))
     JOIN "pg_proc" "p" ON (("tg"."tgfoid" = "p"."oid")))
     JOIN "pg_namespace" "n" ON (("c"."relnamespace" = "n"."oid")))
     JOIN "pg_language" "l" ON (("p"."prolang" = "l"."oid")))
  WHERE ((NOT "tg"."tgisinternal") AND ("n"."nspname" = 'public'::"name"));


ALTER VIEW "public"."vista_triggers_funciones" OWNER TO "postgres";


ALTER TABLE ONLY "public"."cat_combustibles" ALTER COLUMN "id_combustible" SET DEFAULT "nextval"('"public"."cat_combustibles_id_combustible_seq"'::"regclass");



ALTER TABLE ONLY "public"."cat_estado_operativo" ALTER COLUMN "id_estado" SET DEFAULT "nextval"('"public"."cat_estado_operativo_id_estado_seq"'::"regclass");



ALTER TABLE ONLY "public"."cat_gasoductos" ALTER COLUMN "id_gasoducto" SET DEFAULT "nextval"('"public"."cat_gasoductos_id_gasoducto_seq"'::"regclass");



ALTER TABLE ONLY "public"."cat_puntos_gas" ALTER COLUMN "id_punto_gas" SET DEFAULT "nextval"('"public"."cat_puntos_gas_id_punto_gas_seq"'::"regclass");



ALTER TABLE ONLY "public"."cat_tipo_punto_gas" ALTER COLUMN "id_tipo_punto" SET DEFAULT "nextval"('"public"."cat_tipo_punto_gas_id_tipo_punto_seq"'::"regclass");



ALTER TABLE ONLY "public"."cat_tipo_punto_gas_natural" ALTER COLUMN "id_tipo_punto" SET DEFAULT "nextval"('"public"."cat_tipo_punto_gas_natural_id_tipo_punto_seq"'::"regclass");



ALTER TABLE ONLY "public"."contratos_transporte" ALTER COLUMN "id_contrato" SET DEFAULT "nextval"('"public"."contratos_transporte_id_contrato_seq"'::"regclass");



ALTER TABLE ONLY "public"."gasoductos_info_general" ALTER COLUMN "gasoducto_id" SET DEFAULT "nextval"('"public"."gasoductos_info_general_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."inspecciones_tanque" ALTER COLUMN "id_inspeccion" SET DEFAULT "nextval"('"public"."inspecciones_tanque_id_inspeccion_seq"'::"regclass");



ALTER TABLE ONLY "public"."operacion_gas_diaria" ALTER COLUMN "id_operacion" SET DEFAULT "nextval"('"public"."operacion_gas_diaria_id_operacion_seq"'::"regclass");



ALTER TABLE ONLY "public"."proveedores_combustible" ALTER COLUMN "id_proveedor" SET DEFAULT "nextval"('"public"."proveedores_combustible_id_proveedor_seq"'::"regclass");



ALTER TABLE ONLY "public"."tanques_almacenamiento" ALTER COLUMN "id_tanque" SET DEFAULT "nextval"('"public"."tanques_almacenamiento_id_tanque_seq"'::"regclass");



ALTER TABLE ONLY "public"."tarifas_contrato_mensual" ALTER COLUMN "id_tarifa" SET DEFAULT "nextval"('"public"."tarifas_contrato_mensual_id_tarifa_seq"'::"regclass");



ALTER TABLE ONLY "public"."transportistas" ALTER COLUMN "id_transportista" SET DEFAULT "nextval"('"public"."transportistas_id_transportista_seq"'::"regclass");



ALTER TABLE ONLY "public"."cat_combustibles"
    ADD CONSTRAINT "cat_combustibles_nombre_key" UNIQUE ("nombre");



ALTER TABLE ONLY "public"."cat_combustibles"
    ADD CONSTRAINT "cat_combustibles_pkey" PRIMARY KEY ("id_combustible");



ALTER TABLE ONLY "public"."cat_estado_operativo"
    ADD CONSTRAINT "cat_estado_operativo_estado_key" UNIQUE ("estado");



ALTER TABLE ONLY "public"."cat_estado_operativo"
    ADD CONSTRAINT "cat_estado_operativo_pkey" PRIMARY KEY ("id_estado");



ALTER TABLE ONLY "public"."cat_gasoductos"
    ADD CONSTRAINT "cat_gasoductos_codigo_key" UNIQUE ("codigo");



ALTER TABLE ONLY "public"."cat_gasoductos"
    ADD CONSTRAINT "cat_gasoductos_pkey" PRIMARY KEY ("id_gasoducto");



ALTER TABLE ONLY "public"."cat_puntos_gas"
    ADD CONSTRAINT "cat_puntos_gas_codigo_key" UNIQUE ("codigo");



ALTER TABLE ONLY "public"."cat_puntos_gas"
    ADD CONSTRAINT "cat_puntos_gas_pkey" PRIMARY KEY ("id_punto_gas");



ALTER TABLE ONLY "public"."cat_tipo_punto_gas"
    ADD CONSTRAINT "cat_tipo_punto_gas_codigo_key" UNIQUE ("codigo");



ALTER TABLE ONLY "public"."cat_tipo_punto_gas_natural"
    ADD CONSTRAINT "cat_tipo_punto_gas_natural_codigo_key" UNIQUE ("codigo");



ALTER TABLE ONLY "public"."cat_tipo_punto_gas_natural"
    ADD CONSTRAINT "cat_tipo_punto_gas_natural_pkey" PRIMARY KEY ("id_tipo_punto");



ALTER TABLE ONLY "public"."cat_tipo_punto_gas"
    ADD CONSTRAINT "cat_tipo_punto_gas_pkey" PRIMARY KEY ("id_tipo_punto");



ALTER TABLE ONLY "public"."centrales_generacion"
    ADD CONSTRAINT "centrales_pkey" PRIMARY KEY ("id_centrales_generacion");



ALTER TABLE ONLY "public"."compras_combustible"
    ADD CONSTRAINT "compras_combustible_pkey" PRIMARY KEY ("id_compras_combustible");



ALTER TABLE ONLY "public"."contratos_transporte"
    ADD CONSTRAINT "contratos_transporte_pkey" PRIMARY KEY ("id_contrato");



ALTER TABLE ONLY "public"."gasoductos_info_general"
    ADD CONSTRAINT "gasoductos_info_general_pkey" PRIMARY KEY ("gasoducto_id");



ALTER TABLE ONLY "public"."inspecciones_tanque"
    ADD CONSTRAINT "inspecciones_tanque_pkey" PRIMARY KEY ("id_inspeccion");



ALTER TABLE ONLY "public"."operacion_gas_diaria"
    ADD CONSTRAINT "operacion_gas_diaria_pkey" PRIMARY KEY ("id_operacion");



ALTER TABLE ONLY "public"."procedimientos_instructivos"
    ADD CONSTRAINT "procedimientos_instructivos_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."proveedores_combustible"
    ADD CONSTRAINT "proveedores_combustible_pkey" PRIMARY KEY ("id_proveedor");



ALTER TABLE ONLY "public"."tanques_almacenamiento"
    ADD CONSTRAINT "tanques_almacenamiento_pkey" PRIMARY KEY ("id_tanque");



ALTER TABLE ONLY "public"."tarifas_contrato_mensual"
    ADD CONSTRAINT "tarifas_contrato_mensual_id_contrato_mes_servicio_key" UNIQUE ("id_contrato", "mes_servicio");



ALTER TABLE ONLY "public"."tarifas_contrato_mensual"
    ADD CONSTRAINT "tarifas_contrato_mensual_pkey" PRIMARY KEY ("id_tarifa");



ALTER TABLE ONLY "public"."transportistas"
    ADD CONSTRAINT "transportistas_pkey" PRIMARY KEY ("id_transportista");



CREATE INDEX "idx_centrales_estado" ON "public"."centrales_generacion" USING "btree" ("ubicacion_estado");



CREATE INDEX "idx_centrales_estado_operacion" ON "public"."centrales_generacion" USING "btree" ("estado_operacion");



CREATE INDEX "idx_centrales_tipo" ON "public"."centrales_generacion" USING "btree" ("tipo_central");



CREATE INDEX "idx_op_gas_fecha" ON "public"."operacion_gas_diaria" USING "btree" ("fecha");



CREATE INDEX "idx_op_gas_fecha_gasoducto" ON "public"."operacion_gas_diaria" USING "btree" ("fecha", "gasoducto_id");



CREATE INDEX "idx_op_gas_gasoducto" ON "public"."operacion_gas_diaria" USING "btree" ("gasoducto_id");



CREATE INDEX "idx_procedimientos_area" ON "public"."procedimientos_instructivos" USING "btree" ("area_responsable");



CREATE INDEX "idx_procedimientos_estado" ON "public"."procedimientos_instructivos" USING "btree" ("estado");



CREATE INDEX "idx_tanques_central" ON "public"."tanques_almacenamiento" USING "btree" ("central_id");



CREATE INDEX "idx_tanques_combustible" ON "public"."tanques_almacenamiento" USING "btree" ("id_combustible");



CREATE INDEX "idx_tanques_estado" ON "public"."tanques_almacenamiento" USING "btree" ("id_estado");



CREATE OR REPLACE TRIGGER "trg_actualizado_en" BEFORE UPDATE ON "public"."procedimientos_instructivos" FOR EACH ROW EXECUTE FUNCTION "public"."actualizar_timestamp"();



CREATE OR REPLACE TRIGGER "trg_set_created_at_mx_centrales_generacion" BEFORE INSERT ON "public"."centrales_generacion" FOR EACH ROW EXECUTE FUNCTION "public"."set_created_at_mx"();



CREATE OR REPLACE TRIGGER "trg_set_created_at_mx_compras_combustible" BEFORE INSERT ON "public"."compras_combustible" FOR EACH ROW EXECUTE FUNCTION "public"."set_created_at_mx"();



CREATE OR REPLACE TRIGGER "trg_set_created_at_mx_contratos_transporte" BEFORE INSERT ON "public"."contratos_transporte" FOR EACH ROW EXECUTE FUNCTION "public"."set_created_at_mx"();



CREATE OR REPLACE TRIGGER "trg_set_created_at_mx_gasoductos_info_general" BEFORE INSERT ON "public"."gasoductos_info_general" FOR EACH ROW EXECUTE FUNCTION "public"."set_created_at_mx"();



CREATE OR REPLACE TRIGGER "trg_set_created_at_mx_inspecciones_tanque" BEFORE INSERT ON "public"."inspecciones_tanque" FOR EACH ROW EXECUTE FUNCTION "public"."set_created_at_mx"();



CREATE OR REPLACE TRIGGER "trg_set_created_at_mx_operacion_gas" BEFORE INSERT ON "public"."operacion_gas_diaria" FOR EACH ROW EXECUTE FUNCTION "public"."set_created_at_mx"();



CREATE OR REPLACE TRIGGER "trg_set_created_at_mx_proveedores_combustible" BEFORE INSERT ON "public"."proveedores_combustible" FOR EACH ROW EXECUTE FUNCTION "public"."set_created_at_mx"();



CREATE OR REPLACE TRIGGER "trg_set_created_at_mx_staging_compras_combustible" BEFORE INSERT ON "public"."staging_compras_combustible" FOR EACH ROW EXECUTE FUNCTION "public"."set_created_at_mx"();



CREATE OR REPLACE TRIGGER "trg_set_created_at_mx_staging_normalized" BEFORE INSERT ON "public"."staging_normalized" FOR EACH ROW EXECUTE FUNCTION "public"."set_created_at_mx"();



CREATE OR REPLACE TRIGGER "trg_set_created_at_mx_tanques" BEFORE INSERT ON "public"."tanques_almacenamiento" FOR EACH ROW EXECUTE FUNCTION "public"."set_created_at_mx"();



CREATE OR REPLACE TRIGGER "trg_set_created_at_mx_tarifas_contrato_mensual" BEFORE INSERT ON "public"."tarifas_contrato_mensual" FOR EACH ROW EXECUTE FUNCTION "public"."set_created_at_mx"();



CREATE OR REPLACE TRIGGER "trg_set_created_at_mx_transportistas" BEFORE INSERT ON "public"."transportistas" FOR EACH ROW EXECUTE FUNCTION "public"."set_created_at_mx"();



CREATE OR REPLACE TRIGGER "trg_set_fecha_vigencia_sig" BEFORE INSERT OR UPDATE ON "public"."procedimientos_instructivos" FOR EACH ROW EXECUTE FUNCTION "public"."set_fecha_vigencia_sig"();



CREATE OR REPLACE TRIGGER "trg_set_updated_at_mx_centrales_generacion" BEFORE INSERT OR UPDATE ON "public"."centrales_generacion" FOR EACH ROW EXECUTE FUNCTION "public"."set_updated_at_mx"();



CREATE OR REPLACE TRIGGER "trg_set_updated_at_mx_compras_combustible" BEFORE INSERT OR UPDATE ON "public"."compras_combustible" FOR EACH ROW EXECUTE FUNCTION "public"."set_updated_at_mx"();



CREATE OR REPLACE TRIGGER "trg_set_updated_at_mx_contratos_transporte" BEFORE INSERT OR UPDATE ON "public"."contratos_transporte" FOR EACH ROW EXECUTE FUNCTION "public"."set_updated_at_mx"();



CREATE OR REPLACE TRIGGER "trg_set_updated_at_mx_gasoductos_info_general" BEFORE INSERT OR UPDATE ON "public"."gasoductos_info_general" FOR EACH ROW EXECUTE FUNCTION "public"."set_updated_at_mx"();



CREATE OR REPLACE TRIGGER "trg_set_updated_at_mx_inspecciones_tanque" BEFORE INSERT OR UPDATE ON "public"."inspecciones_tanque" FOR EACH ROW EXECUTE FUNCTION "public"."set_updated_at_mx"();



CREATE OR REPLACE TRIGGER "trg_set_updated_at_mx_operacion_gas" BEFORE INSERT OR UPDATE ON "public"."operacion_gas_diaria" FOR EACH ROW EXECUTE FUNCTION "public"."set_updated_at_mx"();



CREATE OR REPLACE TRIGGER "trg_set_updated_at_mx_proveedores_combustible" BEFORE INSERT OR UPDATE ON "public"."proveedores_combustible" FOR EACH ROW EXECUTE FUNCTION "public"."set_updated_at_mx"();



CREATE OR REPLACE TRIGGER "trg_set_updated_at_mx_staging_compras_combustible" BEFORE INSERT OR UPDATE ON "public"."staging_compras_combustible" FOR EACH ROW EXECUTE FUNCTION "public"."set_updated_at_mx"();



CREATE OR REPLACE TRIGGER "trg_set_updated_at_mx_staging_normalized" BEFORE INSERT OR UPDATE ON "public"."staging_normalized" FOR EACH ROW EXECUTE FUNCTION "public"."set_updated_at_mx"();



CREATE OR REPLACE TRIGGER "trg_set_updated_at_mx_tanques" BEFORE INSERT OR UPDATE ON "public"."tanques_almacenamiento" FOR EACH ROW EXECUTE FUNCTION "public"."set_updated_at_mx"();



CREATE OR REPLACE TRIGGER "trg_set_updated_at_mx_tarifas_contrato_mensual" BEFORE INSERT OR UPDATE ON "public"."tarifas_contrato_mensual" FOR EACH ROW EXECUTE FUNCTION "public"."set_updated_at_mx"();



CREATE OR REPLACE TRIGGER "trg_set_updated_at_mx_transportistas" BEFORE INSERT OR UPDATE ON "public"."transportistas" FOR EACH ROW EXECUTE FUNCTION "public"."set_updated_at_mx"();



ALTER TABLE ONLY "public"."compras_combustible"
    ADD CONSTRAINT "compras_combustible_id_centrales_generacion_fkey" FOREIGN KEY ("id_centrales_generacion") REFERENCES "public"."centrales_generacion"("id_centrales_generacion") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."compras_combustible"
    ADD CONSTRAINT "compras_combustible_id_proveedor_fkey" FOREIGN KEY ("id_proveedor") REFERENCES "public"."proveedores_combustible"("id_proveedor");



ALTER TABLE ONLY "public"."contratos_transporte"
    ADD CONSTRAINT "contratos_transporte_id_transportista_fkey" FOREIGN KEY ("id_transportista") REFERENCES "public"."transportistas"("id_transportista");



ALTER TABLE ONLY "public"."operacion_gas_diaria"
    ADD CONSTRAINT "fk_operacion_gasoducto" FOREIGN KEY ("gasoducto_id") REFERENCES "public"."cat_gasoductos"("id_gasoducto") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."cat_puntos_gas"
    ADD CONSTRAINT "fk_punto_central" FOREIGN KEY ("central_id") REFERENCES "public"."centrales_generacion"("id_centrales_generacion") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."cat_puntos_gas"
    ADD CONSTRAINT "fk_punto_gasoducto" FOREIGN KEY ("gasoducto_id") REFERENCES "public"."cat_gasoductos"("id_gasoducto") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."tanques_almacenamiento"
    ADD CONSTRAINT "fk_tanque_central" FOREIGN KEY ("central_id") REFERENCES "public"."centrales_generacion"("id_centrales_generacion") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."tanques_almacenamiento"
    ADD CONSTRAINT "fk_tanque_combustible" FOREIGN KEY ("id_combustible") REFERENCES "public"."cat_combustibles"("id_combustible");



ALTER TABLE ONLY "public"."tanques_almacenamiento"
    ADD CONSTRAINT "fk_tanque_estado_operativo" FOREIGN KEY ("id_estado") REFERENCES "public"."cat_estado_operativo"("id_estado");



ALTER TABLE ONLY "public"."cat_puntos_gas"
    ADD CONSTRAINT "fk_tipo_punto_gas" FOREIGN KEY ("tipo_punto_id") REFERENCES "public"."cat_tipo_punto_gas"("id_tipo_punto");



ALTER TABLE ONLY "public"."tarifas_contrato_mensual"
    ADD CONSTRAINT "tarifas_contrato_mensual_id_contrato_fkey" FOREIGN KEY ("id_contrato") REFERENCES "public"."contratos_transporte"("id_contrato");



CREATE POLICY "Allow public read access to centrales" ON "public"."centrales_generacion" FOR SELECT USING (true);



ALTER TABLE "public"."cat_combustibles" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."cat_estado_operativo" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."centrales_generacion" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."compras_combustible" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."contratos_transporte" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."gasoductos_info_general" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."inspecciones_tanque" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."procedimientos_instructivos" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."proveedores_combustible" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."staging_compras_combustible" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."tanques_almacenamiento" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."tarifas_contrato_mensual" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."transportistas" ENABLE ROW LEVEL SECURITY;




ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";









GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";





















































































































































































































































































































GRANT ALL ON FUNCTION "public"."actualizar_timestamp"() TO "anon";
GRANT ALL ON FUNCTION "public"."actualizar_timestamp"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."actualizar_timestamp"() TO "service_role";



GRANT ALL ON FUNCTION "public"."set_created_at_mx"() TO "anon";
GRANT ALL ON FUNCTION "public"."set_created_at_mx"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."set_created_at_mx"() TO "service_role";



GRANT ALL ON FUNCTION "public"."set_fecha_vigencia_sig"() TO "anon";
GRANT ALL ON FUNCTION "public"."set_fecha_vigencia_sig"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."set_fecha_vigencia_sig"() TO "service_role";



GRANT ALL ON FUNCTION "public"."set_updated_at_mx"() TO "anon";
GRANT ALL ON FUNCTION "public"."set_updated_at_mx"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."set_updated_at_mx"() TO "service_role";



GRANT ALL ON FUNCTION "public"."validar_tipo_punto_gas"() TO "anon";
GRANT ALL ON FUNCTION "public"."validar_tipo_punto_gas"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."validar_tipo_punto_gas"() TO "service_role";



























GRANT ALL ON TABLE "public"."cat_combustibles" TO "anon";
GRANT ALL ON TABLE "public"."cat_combustibles" TO "authenticated";
GRANT ALL ON TABLE "public"."cat_combustibles" TO "service_role";



GRANT ALL ON SEQUENCE "public"."cat_combustibles_id_combustible_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."cat_combustibles_id_combustible_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."cat_combustibles_id_combustible_seq" TO "service_role";



GRANT ALL ON TABLE "public"."cat_estado_operativo" TO "anon";
GRANT ALL ON TABLE "public"."cat_estado_operativo" TO "authenticated";
GRANT ALL ON TABLE "public"."cat_estado_operativo" TO "service_role";



GRANT ALL ON SEQUENCE "public"."cat_estado_operativo_id_estado_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."cat_estado_operativo_id_estado_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."cat_estado_operativo_id_estado_seq" TO "service_role";



GRANT ALL ON TABLE "public"."cat_gasoductos" TO "anon";
GRANT ALL ON TABLE "public"."cat_gasoductos" TO "authenticated";
GRANT ALL ON TABLE "public"."cat_gasoductos" TO "service_role";



GRANT ALL ON SEQUENCE "public"."cat_gasoductos_id_gasoducto_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."cat_gasoductos_id_gasoducto_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."cat_gasoductos_id_gasoducto_seq" TO "service_role";



GRANT ALL ON TABLE "public"."cat_puntos_gas" TO "anon";
GRANT ALL ON TABLE "public"."cat_puntos_gas" TO "authenticated";
GRANT ALL ON TABLE "public"."cat_puntos_gas" TO "service_role";



GRANT ALL ON SEQUENCE "public"."cat_puntos_gas_id_punto_gas_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."cat_puntos_gas_id_punto_gas_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."cat_puntos_gas_id_punto_gas_seq" TO "service_role";



GRANT ALL ON TABLE "public"."cat_tipo_punto_gas" TO "anon";
GRANT ALL ON TABLE "public"."cat_tipo_punto_gas" TO "authenticated";
GRANT ALL ON TABLE "public"."cat_tipo_punto_gas" TO "service_role";



GRANT ALL ON SEQUENCE "public"."cat_tipo_punto_gas_id_tipo_punto_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."cat_tipo_punto_gas_id_tipo_punto_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."cat_tipo_punto_gas_id_tipo_punto_seq" TO "service_role";



GRANT ALL ON TABLE "public"."cat_tipo_punto_gas_natural" TO "anon";
GRANT ALL ON TABLE "public"."cat_tipo_punto_gas_natural" TO "authenticated";
GRANT ALL ON TABLE "public"."cat_tipo_punto_gas_natural" TO "service_role";



GRANT ALL ON SEQUENCE "public"."cat_tipo_punto_gas_natural_id_tipo_punto_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."cat_tipo_punto_gas_natural_id_tipo_punto_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."cat_tipo_punto_gas_natural_id_tipo_punto_seq" TO "service_role";



GRANT ALL ON TABLE "public"."centrales_generacion" TO "anon";
GRANT ALL ON TABLE "public"."centrales_generacion" TO "authenticated";
GRANT ALL ON TABLE "public"."centrales_generacion" TO "service_role";



GRANT ALL ON SEQUENCE "public"."centrales_central_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."centrales_central_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."centrales_central_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."compras_combustible" TO "anon";
GRANT ALL ON TABLE "public"."compras_combustible" TO "authenticated";
GRANT ALL ON TABLE "public"."compras_combustible" TO "service_role";



GRANT ALL ON SEQUENCE "public"."compras_combustible_id_compra_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."compras_combustible_id_compra_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."compras_combustible_id_compra_seq" TO "service_role";



GRANT ALL ON TABLE "public"."contratos_transporte" TO "anon";
GRANT ALL ON TABLE "public"."contratos_transporte" TO "authenticated";
GRANT ALL ON TABLE "public"."contratos_transporte" TO "service_role";



GRANT ALL ON SEQUENCE "public"."contratos_transporte_id_contrato_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."contratos_transporte_id_contrato_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."contratos_transporte_id_contrato_seq" TO "service_role";



GRANT ALL ON TABLE "public"."gasoductos_info_general" TO "anon";
GRANT ALL ON TABLE "public"."gasoductos_info_general" TO "authenticated";
GRANT ALL ON TABLE "public"."gasoductos_info_general" TO "service_role";



GRANT ALL ON SEQUENCE "public"."gasoductos_info_general_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."gasoductos_info_general_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."gasoductos_info_general_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."inspecciones_tanque" TO "anon";
GRANT ALL ON TABLE "public"."inspecciones_tanque" TO "authenticated";
GRANT ALL ON TABLE "public"."inspecciones_tanque" TO "service_role";



GRANT ALL ON SEQUENCE "public"."inspecciones_tanque_id_inspeccion_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."inspecciones_tanque_id_inspeccion_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."inspecciones_tanque_id_inspeccion_seq" TO "service_role";



GRANT ALL ON TABLE "public"."operacion_gas_diaria" TO "anon";
GRANT ALL ON TABLE "public"."operacion_gas_diaria" TO "authenticated";
GRANT ALL ON TABLE "public"."operacion_gas_diaria" TO "service_role";



GRANT ALL ON SEQUENCE "public"."operacion_gas_diaria_id_operacion_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."operacion_gas_diaria_id_operacion_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."operacion_gas_diaria_id_operacion_seq" TO "service_role";



GRANT ALL ON TABLE "public"."procedimientos_instructivos" TO "anon";
GRANT ALL ON TABLE "public"."procedimientos_instructivos" TO "authenticated";
GRANT ALL ON TABLE "public"."procedimientos_instructivos" TO "service_role";



GRANT ALL ON TABLE "public"."proveedores_combustible" TO "anon";
GRANT ALL ON TABLE "public"."proveedores_combustible" TO "authenticated";
GRANT ALL ON TABLE "public"."proveedores_combustible" TO "service_role";



GRANT ALL ON SEQUENCE "public"."proveedores_combustible_id_proveedor_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."proveedores_combustible_id_proveedor_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."proveedores_combustible_id_proveedor_seq" TO "service_role";



GRANT ALL ON TABLE "public"."staging_compras_combustible" TO "anon";
GRANT ALL ON TABLE "public"."staging_compras_combustible" TO "authenticated";
GRANT ALL ON TABLE "public"."staging_compras_combustible" TO "service_role";



GRANT ALL ON TABLE "public"."staging_normalized" TO "anon";
GRANT ALL ON TABLE "public"."staging_normalized" TO "authenticated";
GRANT ALL ON TABLE "public"."staging_normalized" TO "service_role";



GRANT ALL ON TABLE "public"."tanques_almacenamiento" TO "anon";
GRANT ALL ON TABLE "public"."tanques_almacenamiento" TO "authenticated";
GRANT ALL ON TABLE "public"."tanques_almacenamiento" TO "service_role";



GRANT ALL ON SEQUENCE "public"."tanques_almacenamiento_id_tanque_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."tanques_almacenamiento_id_tanque_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."tanques_almacenamiento_id_tanque_seq" TO "service_role";



GRANT ALL ON TABLE "public"."tarifas_contrato_mensual" TO "anon";
GRANT ALL ON TABLE "public"."tarifas_contrato_mensual" TO "authenticated";
GRANT ALL ON TABLE "public"."tarifas_contrato_mensual" TO "service_role";



GRANT ALL ON SEQUENCE "public"."tarifas_contrato_mensual_id_tarifa_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."tarifas_contrato_mensual_id_tarifa_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."tarifas_contrato_mensual_id_tarifa_seq" TO "service_role";



GRANT ALL ON TABLE "public"."transportistas" TO "anon";
GRANT ALL ON TABLE "public"."transportistas" TO "authenticated";
GRANT ALL ON TABLE "public"."transportistas" TO "service_role";



GRANT ALL ON SEQUENCE "public"."transportistas_id_transportista_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."transportistas_id_transportista_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."transportistas_id_transportista_seq" TO "service_role";



GRANT ALL ON TABLE "public"."vista_triggers_funciones" TO "anon";
GRANT ALL ON TABLE "public"."vista_triggers_funciones" TO "authenticated";
GRANT ALL ON TABLE "public"."vista_triggers_funciones" TO "service_role";









ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";































