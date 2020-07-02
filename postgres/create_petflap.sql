--
-- PostgreSQL database dump
--

-- Dumped from database version 11.7 (Raspbian 11.7-0+deb10u1)
-- Dumped by pg_dump version 12.2

-- Started on 2020-07-02 22:02:43

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
-- TOC entry 204 (class 1259 OID 16506)
-- Name: motion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.motion (
    event_id bigint NOT NULL,
    timestamp_local timestamp without time zone,
    timestamp_utc bigint,
    doc jsonb DEFAULT '{}'::jsonb
);


--
-- TOC entry 2942 (class 0 OID 0)
-- Dependencies: 204
-- Name: COLUMN motion.timestamp_utc; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.motion.timestamp_utc IS 'milliseconds';


--
-- TOC entry 203 (class 1259 OID 16485)
-- Name: motion_log; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 198 (class 1259 OID 16410)
-- Name: passage; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.passage (
    doc jsonb NOT NULL,
    id integer NOT NULL,
    pet integer
);


--
-- TOC entry 199 (class 1259 OID 16419)
-- Name: passage_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.passage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2943 (class 0 OID 0)
-- Dependencies: 199
-- Name: passage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.passage_id_seq OWNED BY public.passage.id;


--
-- TOC entry 197 (class 1259 OID 16399)
-- Name: pet; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pet (
    doc jsonb NOT NULL,
    id integer NOT NULL
);


--
-- TOC entry 200 (class 1259 OID 16430)
-- Name: pet_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pet_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2944 (class 0 OID 0)
-- Dependencies: 200
-- Name: pet_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pet_id_seq OWNED BY public.pet.id;


--
-- TOC entry 202 (class 1259 OID 16464)
-- Name: security; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.security (
    camera integer,
    filename character(80) NOT NULL,
    frame integer,
    file_type integer,
    time_stamp timestamp without time zone,
    event_time_stamp timestamp without time zone
);


--
-- TOC entry 196 (class 1259 OID 16388)
-- Name: user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."user" (
    doc jsonb NOT NULL,
    id integer NOT NULL
);


--
-- TOC entry 201 (class 1259 OID 16441)
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2945 (class 0 OID 0)
-- Dependencies: 201
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- TOC entry 2805 (class 2604 OID 16421)
-- Name: passage id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.passage ALTER COLUMN id SET DEFAULT nextval('public.passage_id_seq'::regclass);


--
-- TOC entry 2804 (class 2604 OID 16432)
-- Name: pet id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pet ALTER COLUMN id SET DEFAULT nextval('public.pet_id_seq'::regclass);


--
-- TOC entry 2803 (class 2604 OID 16443)
-- Name: user id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- TOC entry 2814 (class 2606 OID 16513)
-- Name: motion motion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motion
    ADD CONSTRAINT motion_pkey PRIMARY KEY (event_id);


--
-- TOC entry 2812 (class 2606 OID 16429)
-- Name: passage passage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.passage
    ADD CONSTRAINT passage_pkey PRIMARY KEY (id);


--
-- TOC entry 2810 (class 2606 OID 16440)
-- Name: pet pet_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pet
    ADD CONSTRAINT pet_pkey PRIMARY KEY (id);


--
-- TOC entry 2808 (class 2606 OID 16451)
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- TOC entry 2815 (class 2606 OID 16452)
-- Name: passage pet; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.passage
    ADD CONSTRAINT pet FOREIGN KEY (pet) REFERENCES public.pet(id) NOT VALID;


-- Completed on 2020-07-02 22:02:46

--
-- PostgreSQL database dump complete
--

