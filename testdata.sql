insert into persons values (7777, 'Diamond', 'Tiara', 'Richway, Ponyville', 'theperfectdiamond@gmail.com', 7777777777);
insert into persons values (4251, 'Dinky', 'Doo', 'Richway, Ponyville', 'goldenration@gmail.com', 7775436765);
insert into persons values (1213, 'Scootallo','D', 'St. Starswirl Orphanage', 'rainbowdashfan@gmail.com', 7772212151);
insert into persons values (9821, 'Pipsqueak' ,'Junior', '1414 63 Ave SE', 'pirates10@gmail.com', 7773231991);

insert into users values ('Order', '1AF0B7767D26CB02CD4CDA3F8B1D5555', 'a', '7777', to_date('2042-12-24','yyyy-mm-dd')); 
insert into salts values ('Order','70DB04F5563B0127041A5EBADEE8DC13');

insert into users values ('Crake', '883442F8094BF7BB387BC98199D68053', 's','7777', to_date('2042-12-25','yyyy-mm-dd'));
insert into salts values ('Crake','220B5EBE80237C18B55320FB2F376B08');

insert into users values ('Harmony', '8F4A3E83A47165DF73B2E043AE7C849D', 's', '4251', to_date('2042-12-27', 'yyyy-mm-dd'));
insert into salts values ('Crake','75F926BA841E3408AAF26DD289C6FCB6');

insert into users values ('Dr.Nope', 'B52827B8D377F77D56477BC0F6664274', 's', '1213', to_date('2042-12-27', 'yyyy-mm-dd'));
insert into salts values ('Dr.Nope','6BA0FDE0AA900D9955B3AC6C54267038');

insert into users values ('Discord', 'EB1B9F543DF49650343C10F40A3C8FB5', 'd', '1213', to_date('2042-12-27', 'yyyy-mm-dd'));
insert into salts values ('Discord','79FC6F378E81BDE445ACF4565E6F9873');

insert into users values ('Privateer', '04293F7A9257FFCF07BD4F66340C0414', 'd', '9821', to_date('2043-01-01', 'yyyy-mm-dd'));
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


insert into audio_recordings values (1221, 12, to_date('2052-11-1','yyyy-mm-dd'), 15, 'A loud, unidentified sound originating from the trench.', NULL);
insert into audio_recordings values (1217, 12, to_date('2052-10-19','yyyy-mm-dd') , 20, 'Nothing of note.', NULL);

insert into images values (0142, 01, to_date('2052-11-1','yyyy-mm-dd'), 'A blurry image of some sort of massive creature exiting the trench.',NULL,NULL);

insert into images values (0251, 02, to_date('2052-7-11', 'yyyy-mm-dd'), 'A small object hitting the water above the trench.',Null,Null);
insert into scalar_data values(2121, 21, to_date('2052-11-01','yyyy-mm-dd'), 42);

insert into scalar_data values(2207, 22, to_date('2051-11-01','yyyy-mm-dd'), 02);
insert into scalar_data values(2209, 22, to_date('2051-11-02','yyyy-mm-dd'), 04);
insert into scalar_data values(2213, 22, to_date('2051-11-04','yyyy-mm-dd'), 01);
insert into scalar_data values(2222, 22, to_date('2051-12-12','yyyy-mm-dd'), 05);
insert into scalar_data values(2225, 22, to_date('2051-11-16','yyyy-mm-dd'), 06);
insert into scalar_data values(2229, 22, to_date('2051-11-25','yyyy-mm-dd'), 10);
insert into scalar_data values(2233, 22, to_date('2051-12-01','yyyy-mm-dd'), 15);
insert into scalar_data values(2251, 22, to_date('2051-12-20','yyyy-mm-dd'), 12);
insert into scalar_data values(2259, 22, to_date('2052-05-01','yyyy-mm-dd'), 10);
insert into scalar_data values(2266, 22, to_date('2052-09-20','yyyy-mm-dd'), 15);
insert into scalar_data values(2275, 22, to_date('2052-11-01','yyyy-mm-dd'), 50);
insert into scalar_data values(2280, 22, to_date('2053-09-20','yyyy-mm-dd'), 25);
insert into scalar_data values(2285, 22, to_date('2054-09-20','yyyy-mm-dd'), 10);
insert into scalar_data values(2290, 22, to_date('2055-11-01','yyyy-mm-dd'), 05);
insert into scalar_data values(2295, 22, to_date('2056-09-20','yyyy-mm-dd'), 35);
commit;

