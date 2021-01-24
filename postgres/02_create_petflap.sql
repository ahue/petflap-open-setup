--
-- PostgreSQL database dump
--

-- Dumped from database version 11.9 (Raspbian 11.9-0+deb10u1)
-- Dumped by pg_dump version 12.2

-- Started on 2021-01-24 16:40:48

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

DROP DATABASE petflap;
--
-- TOC entry 2950 (class 1262 OID 16385)
-- Name: petflap; Type: DATABASE; Schema: -; Owner: petflap
--

CREATE DATABASE petflap WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_GB.UTF-8' LC_CTYPE = 'en_GB.UTF-8';


ALTER DATABASE petflap OWNER TO petflap;

\connect petflap

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

--
-- TOC entry 204 (class 1259 OID 24718)
-- Name: motion_id_seq; Type: SEQUENCE; Schema: public; Owner: pi
--

CREATE SEQUENCE public.motion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE public.motion_id_seq OWNER TO pi;

SET default_tablespace = '';

--
-- TOC entry 205 (class 1259 OID 24730)
-- Name: motion; Type: TABLE; Schema: public; Owner: pi
--

CREATE TABLE public.motion (
    id integer DEFAULT nextval('public.motion_id_seq'::regclass) NOT NULL,
    event_id bigint NOT NULL,
    timestamp_local timestamp without time zone,
    timestamp_utc bigint,
    doc jsonb DEFAULT '{}'::jsonb
);


ALTER TABLE public.motion OWNER TO pi;

--
-- TOC entry 2952 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN motion.timestamp_utc; Type: COMMENT; Schema: public; Owner: pi
--

COMMENT ON COLUMN public.motion.timestamp_utc IS 'milliseconds';


--
-- TOC entry 203 (class 1259 OID 16485)
-- Name: motion_log; Type: TABLE; Schema: public; Owner: pi
--

CREATE TABLE public.motion_log (
    event_id bigint NOT NULL,
    camera integer,
    filename character(80) NOT NULL,
    frame integer,
    file_type integer,
    time_stamp timestamp without time zone,
    changed_pixels integer,
    noise_level integer,
    motion_area_h integer,
    motion_area_w integer,
    motion_center_x integer,
    motion_center_y integer
);


ALTER TABLE public.motion_log OWNER TO pi;

--
-- TOC entry 206 (class 1259 OID 24745)
-- Name: motion_start_end; Type: VIEW; Schema: public; Owner: pi
--

CREATE VIEW public.motion_start_end AS
 WITH se AS (
         SELECT m.id,
            m.event_id,
            m.timestamp_local AS ts_start,
            max(ml.time_stamp) AS ts_end
           FROM (public.motion m
             JOIN public.motion_log ml ON ((ml.event_id = m.event_id)))
          GROUP BY m.id, m.event_id, m.timestamp_local
        )
 SELECT se.id,
    se.event_id,
    se.ts_start,
    se.ts_end,
    (se.ts_end - se.ts_start) AS duration
   FROM se
  ORDER BY se.event_id DESC;


ALTER TABLE public.motion_start_end OWNER TO pi;

--
-- TOC entry 198 (class 1259 OID 16410)
-- Name: passage; Type: TABLE; Schema: public; Owner: pi
--

CREATE TABLE public.passage (
    doc jsonb NOT NULL,
    id integer NOT NULL,
    pet integer,
    start integer NOT NULL
);


ALTER TABLE public.passage OWNER TO pi;

--
-- TOC entry 199 (class 1259 OID 16419)
-- Name: passage_id_seq; Type: SEQUENCE; Schema: public; Owner: pi
--

CREATE SEQUENCE public.passage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.passage_id_seq OWNER TO pi;

--
-- TOC entry 2957 (class 0 OID 0)
-- Dependencies: 199
-- Name: passage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pi
--

ALTER SEQUENCE public.passage_id_seq OWNED BY public.passage.id;


--
-- TOC entry 197 (class 1259 OID 16399)
-- Name: pet; Type: TABLE; Schema: public; Owner: pi
--

CREATE TABLE public.pet (
    doc jsonb NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.pet OWNER TO pi;

--
-- TOC entry 200 (class 1259 OID 16430)
-- Name: pet_id_seq; Type: SEQUENCE; Schema: public; Owner: pi
--

CREATE SEQUENCE public.pet_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pet_id_seq OWNER TO pi;

--
-- TOC entry 2960 (class 0 OID 0)
-- Dependencies: 200
-- Name: pet_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pi
--

ALTER SEQUENCE public.pet_id_seq OWNED BY public.pet.id;


--
-- TOC entry 202 (class 1259 OID 16464)
-- Name: security; Type: TABLE; Schema: public; Owner: pi
--

CREATE TABLE public.security (
    camera integer,
    filename character(80) NOT NULL,
    frame integer,
    file_type integer,
    time_stamp timestamp without time zone,
    event_time_stamp timestamp without time zone
);


ALTER TABLE public.security OWNER TO pi;

--
-- TOC entry 196 (class 1259 OID 16388)
-- Name: user; Type: TABLE; Schema: public; Owner: pi
--

CREATE TABLE public."user" (
    doc jsonb NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public."user" OWNER TO pi;

--
-- TOC entry 201 (class 1259 OID 16441)
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: pi
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_id_seq OWNER TO pi;

--
-- TOC entry 2964 (class 0 OID 0)
-- Dependencies: 201
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pi
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- TOC entry 2811 (class 2604 OID 16421)
-- Name: passage id; Type: DEFAULT; Schema: public; Owner: pi
--

ALTER TABLE ONLY public.passage ALTER COLUMN id SET DEFAULT nextval('public.passage_id_seq'::regclass);


--
-- TOC entry 2810 (class 2604 OID 16432)
-- Name: pet id; Type: DEFAULT; Schema: public; Owner: pi
--

ALTER TABLE ONLY public.pet ALTER COLUMN id SET DEFAULT nextval('public.pet_id_seq'::regclass);


--
-- TOC entry 2809 (class 2604 OID 16443)
-- Name: user id; Type: DEFAULT; Schema: public; Owner: pi
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- TOC entry 2821 (class 2606 OID 24739)
-- Name: motion motion_pkey; Type: CONSTRAINT; Schema: public; Owner: pi
--

ALTER TABLE ONLY public.motion
    ADD CONSTRAINT motion_pkey PRIMARY KEY (id);


--
-- TOC entry 2819 (class 2606 OID 16429)
-- Name: passage passage_pkey; Type: CONSTRAINT; Schema: public; Owner: pi
--

ALTER TABLE ONLY public.passage
    ADD CONSTRAINT passage_pkey PRIMARY KEY (id);


--
-- TOC entry 2817 (class 2606 OID 16440)
-- Name: pet pet_pkey; Type: CONSTRAINT; Schema: public; Owner: pi
--

ALTER TABLE ONLY public.pet
    ADD CONSTRAINT pet_pkey PRIMARY KEY (id);


--
-- TOC entry 2815 (class 2606 OID 16451)
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: pi
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- TOC entry 2822 (class 2606 OID 16452)
-- Name: passage pet; Type: FK CONSTRAINT; Schema: public; Owner: pi
--

ALTER TABLE ONLY public.passage
    ADD CONSTRAINT pet FOREIGN KEY (pet) REFERENCES public.pet(id) NOT VALID;


--
-- TOC entry 2951 (class 0 OID 0)
-- Dependencies: 204
-- Name: SEQUENCE motion_id_seq; Type: ACL; Schema: public; Owner: pi
--

GRANT ALL ON SEQUENCE public.motion_id_seq TO petflap;


--
-- TOC entry 2953 (class 0 OID 0)
-- Dependencies: 205
-- Name: TABLE motion; Type: ACL; Schema: public; Owner: pi
--

GRANT ALL ON TABLE public.motion TO petflap;


--
-- TOC entry 2954 (class 0 OID 0)
-- Dependencies: 203
-- Name: TABLE motion_log; Type: ACL; Schema: public; Owner: pi
--

GRANT ALL ON TABLE public.motion_log TO petflap;


--
-- TOC entry 2955 (class 0 OID 0)
-- Dependencies: 206
-- Name: TABLE motion_start_end; Type: ACL; Schema: public; Owner: pi
--

GRANT SELECT ON TABLE public.motion_start_end TO petflap;


--
-- TOC entry 2956 (class 0 OID 0)
-- Dependencies: 198
-- Name: TABLE passage; Type: ACL; Schema: public; Owner: pi
--

GRANT ALL ON TABLE public.passage TO petflap;


--
-- TOC entry 2958 (class 0 OID 0)
-- Dependencies: 199
-- Name: SEQUENCE passage_id_seq; Type: ACL; Schema: public; Owner: pi
--

GRANT ALL ON SEQUENCE public.passage_id_seq TO petflap;


--
-- TOC entry 2959 (class 0 OID 0)
-- Dependencies: 197
-- Name: TABLE pet; Type: ACL; Schema: public; Owner: pi
--

GRANT ALL ON TABLE public.pet TO petflap;


--
-- TOC entry 2961 (class 0 OID 0)
-- Dependencies: 200
-- Name: SEQUENCE pet_id_seq; Type: ACL; Schema: public; Owner: pi
--

GRANT ALL ON SEQUENCE public.pet_id_seq TO petflap;


--
-- TOC entry 2962 (class 0 OID 0)
-- Dependencies: 202
-- Name: TABLE security; Type: ACL; Schema: public; Owner: pi
--

GRANT ALL ON TABLE public.security TO petflap;


--
-- TOC entry 2963 (class 0 OID 0)
-- Dependencies: 196
-- Name: TABLE "user"; Type: ACL; Schema: public; Owner: pi
--

GRANT ALL ON TABLE public."user" TO petflap;


--
-- TOC entry 2965 (class 0 OID 0)
-- Dependencies: 201
-- Name: SEQUENCE user_id_seq; Type: ACL; Schema: public; Owner: pi
--

GRANT ALL ON SEQUENCE public.user_id_seq TO petflap;


-- Completed on 2021-01-24 16:40:55

--
-- PostgreSQL database dump complete
--

