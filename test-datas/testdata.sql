insert into persons values (7777, 'Diamond', 'Tiara', 'Richway, Ponyville', 'theperfectdiamond@gmail.com', 7777777777);
insert into persons values (4251, 'Dinky', 'Doo', 'Richway, Ponyville', 'goldenration@gmail.com', 7775436765);
insert into persons values (1213, 'Scootallo','D', 'St. Starswirl Orphanage', 'rainbowdashfan@gmail.com', 7772212151);
insert into persons values (9821, 'Pipsqueak' ,'Junior', '1414 63 Ave SE', 'pirates10@gmail.com', 7773231991);

insert into users values ('Order', '1AF0B7767D26CB02CD4CDA3F8B1D5555', 'a', '7777', to_date('2042-12-24 22:12:35','YYYY-MM-DD HH24:MI:SS')); 
insert into salts values ('Order','70DB04F5563B0127041A5EBADEE8DC13');

insert into users values ('Crake', '883442F8094BF7BB387BC98199D68053', 's','7777', to_date('2042-12-25 22:12:35','YYYY-MM-DD HH24:MI:SS'));
insert into salts values ('Crake','220B5EBE80237C18B55320FB2F376B08');

insert into users values ('Harmony', '8F4A3E83A47165DF73B2E043AE7C849D', 's', '4251', to_date('2042-12-27 22:12:35', 'YYYY-MM-DD HH24:MI:SS'));
insert into salts values ('Harmony','75F926BA841E3408AAF26DD289C6FCB6');

insert into users values ('Dr.Nope', 'B52827B8D377F77D56477BC0F6664274', 's', '1213', to_date('2042-12-27 22:12:35', 'YYYY-MM-DD HH24:MI:SS'));
insert into salts values ('Dr.Nope','6BA0FDE0AA900D9955B3AC6C54267038');

insert into users values ('Discord', 'EB1B9F543DF49650343C10F40A3C8FB5', 'd', '1213', to_date('2042-12-27 22:12:35', 'YYYY-MM-DD HH24:MI:SS'));
insert into salts values ('Discord','79FC6F378E81BDE445ACF4565E6F9873');

insert into users values ('Privateer', '04293F7A9257FFCF07BD4F66340C0414', 'd', '9821', to_date('2043-01-01 22:12:35', 'YYYY-MM-DD HH24:MI:SS'));
insert into salts values ('Privateer','82EE06A1B84BA3899188B8EAAA2067CE');

insert into sensors values (01, 'Trench Entrance, Mid', 'i', 'A visual sensor placed to watch for any motion of any creatures or objects that attempt to leave or enter the trench.');
insert into sensors values (12, 'Trench Interior, Mid', 'a', 'An audio recorder placed to listen for abnormal sounds that may occur inside the trench.');
insert into sensors values (21, 'Trench Entrance, Mid', 's', 'Provdes scalar data of the area around the entrance to the trench.');
insert into sensors values (22, 'Trench Interior, Mid', 's', 'Provdes scalar data of the area around the interior of the trench.');
insert into sensors values (02, 'Aerial Observation', 'i', 'Nothing of note.');

/*Diamond subscribed to everything, Scoot to audio and visual, dinky to scalar data.*/
insert into subscriptions values (01, 7777);
insert into subscriptions values (02, 7777);
insert into subscriptions values (12, 7777);
insert into subscriptions values (21, 7777);
insert into subscriptions values (22, 7777);

insert into subscriptions values (21, 4251);
insert into subscriptions values (22, 4251);

insert into subscriptions values (01, 1213);
insert into subscriptions values (02, 1213);
insert into subscriptions values (12, 1213);


--insert into audio_recordings values (1221, 12, to_date('2052-11-1 11:12:35','YYYY-MM-DD HH24:MI:SS'), 15, 'A loud, unidentified sound originating from the trench.', NULL);
--insert into audio_recordings values (1217, 12, to_date('2052-10-19 22:12:35','YYYY-MM-DD HH24:MI:SS') , 20, 'Nothing of note.', NULL);

--insert into images values (0142, 01, to_date('2052-11-1 11:12:35','YYYY-MM-DD HH24:MI:SS'), 'A blurry image of some sort of massive creature exiting the trench.',NULL,NULL);

--insert into images values (0251, 02, to_date('2052-7-11 22:12:35', 'YYYY-MM-DD HH24:MI:SS'), 'A small object hitting the water above the trench.',Null,Null);
--insert into scalar_data values(2121, 21, to_date('2052-11-01 22:12:35','YYYY-MM-DD HH24:MI:SS'), 42);

insert into scalar_data values(2207, 22, to_date('2051-11-01 00:12:15','YYYY-MM-DD HH24:MI:SS'), 02);
insert into scalar_data values(2209, 22, to_date('2051-11-02 01:15:15','YYYY-MM-DD HH24:MI:SS'), 04);
insert into scalar_data values(2213, 22, to_date('2051-11-04 02:18:15','YYYY-MM-DD HH24:MI:SS'), 01);
insert into scalar_data values(2222, 22, to_date('2051-12-12 03:21:15','YYYY-MM-DD HH24:MI:SS'), 05);
insert into scalar_data values(2225, 22, to_date('2051-11-16 04:24:15','YYYY-MM-DD HH24:MI:SS'), 06);
insert into scalar_data values(2229, 22, to_date('2051-11-25 05:27:15','YYYY-MM-DD HH24:MI:SS'), 10);
insert into scalar_data values(2233, 22, to_date('2051-12-01 06:30:15','YYYY-MM-DD HH24:MI:SS'), 15);
insert into scalar_data values(2251, 22, to_date('2051-12-20 07:33:15','YYYY-MM-DD HH24:MI:SS'), 12);
insert into scalar_data values(2259, 22, to_date('2052-05-01 08:36:15','YYYY-MM-DD HH24:MI:SS'), 10);
insert into scalar_data values(2266, 22, to_date('2052-09-20 09:39:15','YYYY-MM-DD HH24:MI:SS'), 15);
insert into scalar_data values(2273, 22, to_date('2052-11-01 10:42:15','YYYY-MM-DD HH24:MI:SS'), 17);
insert into scalar_data values(2274, 22, to_date('2052-11-01 11:45:15','YYYY-MM-DD HH24:MI:SS'), 20);
insert into scalar_data values(2275, 22, to_date('2052-11-01 12:48:15','YYYY-MM-DD HH24:MI:SS'), 50);
insert into scalar_data values(2276, 22, to_date('2052-11-01 13:51:15','YYYY-MM-DD HH24:MI:SS'), 42);
insert into scalar_data values(2280, 22, to_date('2053-09-20 14:54:15','YYYY-MM-DD HH24:MI:SS'), 25);
insert into scalar_data values(2285, 22, to_date('2054-09-20 15:57:15','YYYY-MM-DD HH24:MI:SS'), 10);
insert into scalar_data values(2290, 22, to_date('2055-11-01 16:40:15','YYYY-MM-DD HH24:MI:SS'), 05);
insert into scalar_data values(2295, 22, to_date('2056-09-20 17:33:15','YYYY-MM-DD HH24:MI:SS'), 35);


/*first week of december*/

insert into scalar_data values(2013, 21, to_date('2015-12-01 12:11:15', 'YYYY-MM-DD HH24:MI:SS'), 13);
insert into scalar_data values(2014, 21, to_date('2015-12-02 13:14:15', 'YYYY-MM-DD HH24:MI:SS'), 14);
insert into scalar_data values(2015, 21, to_date('2015-12-03 14:17:15', 'YYYY-MM-DD HH24:MI:SS'), 15);
insert into scalar_data values(2016, 21, to_date('2015-12-04 15:20:15', 'YYYY-MM-DD HH24:MI:SS'), 16);
insert into scalar_data values(2017, 21, to_date('2015-12-05 16:23:15', 'YYYY-MM-DD HH24:MI:SS'), 17);


/*last week of december*/
insert into scalar_data values(2051, 21, to_date('2015-12-27 02:11:11', 'YYYY-MM-DD HH24:MI:SS'), 51);
insert into scalar_data values(2052, 21, to_date('2015-12-28 05:14:14', 'YYYY-MM-DD HH24:MI:SS'), 52);
insert into scalar_data values(2053, 21, to_date('2015-12-29 08:17:17', 'YYYY-MM-DD HH24:MI:SS'), 53);
insert into scalar_data values(2054, 21, to_date('2015-12-30 11:20:20', 'YYYY-MM-DD HH24:MI:SS'), 54);
insert into scalar_data values(2055, 21, to_date('2015-12-31 14:23:23', 'YYYY-MM-DD HH24:MI:SS'), 55);

/*first week of january  3,31/08/2011 22:34:57,30.7*/
insert into scalar_data values(3016, 21, to_date('2016-01-01 12:12:23', 'YYYY-MM-DD HH24:MI:SS'), 16);
insert into scalar_data values(3017, 21, to_date('2016-01-02 14:42:25', 'YYYY-MM-DD HH24:MI:SS'), 17);

/*second week*/
insert into scalar_data values(3021, 21, to_date('2016-01-03 02:13:23', 'YYYY-MM-DD HH24:MI:SS'), 21);
insert into scalar_data values(3122, 21, to_date('2016-01-04 05:16:23', 'YYYY-MM-DD HH24:MI:SS'), 22);
insert into scalar_data values(3023, 21, to_date('2016-01-05 08:19:23', 'YYYY-MM-DD HH24:MI:SS'), 23);
insert into scalar_data values(3031, 21, to_date('2016-01-10 11:22:23', 'YYYY-MM-DD HH24:MI:SS'), 31);

/*13th of several months*/
insert into scalar_data values(4027, 21, to_date('2016-02-13 15:25:23', 'YYYY-MM-DD HH24:MI:SS'), 27);
insert into scalar_data values(4042, 21, to_date('2016-03-13 16:22:23', 'YYYY-MM-DD HH24:MI:SS'), 42);
insert into scalar_data values(4034, 21, to_date('2016-04-13 17:27:23', 'YYYY-MM-DD HH24:MI:SS'), 34);
insert into scalar_data values(4026, 21, to_date('2016-05-13 18:24:23', 'YYYY-MM-DD HH24:MI:SS'), 26);

/*last week of january... is only 1 day, checking a bit of the second last week*/
insert into scalar_data values(5056, 21, to_date('2016-01-29 01:21:23', 'YYYY-MM-DD HH24:MI:SS'), 56);
insert into scalar_data values(5057, 21, to_date('2016-01-30 22:12:23', 'YYYY-MM-DD HH24:MI:SS'), 57);
insert into scalar_data values(5061, 21, to_date('2016-01-31 00:15:23', 'YYYY-MM-DD HH24:MI:SS'), 61);

/*first week of feb.*/
insert into scalar_data values(5112, 21, to_date('2016-02-01 12:36:23', 'YYYY-MM-DD HH24:MI:SS'), 12);
insert into scalar_data values(5113, 21, to_date('2016-02-02 20:46:23', 'YYYY-MM-DD HH24:MI:SS'), 13);
insert into scalar_data values(5114, 21, to_date('2016-02-03 17:36:23', 'YYYY-MM-DD HH24:MI:SS'), 14);
commit;

