insert into persons values (7777, 'Diamond', 'Tiara', 'Richway, Ponyville', 'theperfectdiamond@gmail.com', 7777777777);
insert into persons values (4251, 'Dinky', 'Doo', 'Richway, Ponyville', 'goldenration@gmail.com', 7775436765);
insert into persons values (1213, 'Scootallo','D', 'St. Starswirl Orphanage', 'rainbowdashfan@gmail.com', 7772212151);
insert into persons values (9821, 'Pipsqueak' ,'Junior', '1414 63 Ave SE', 'pirates10@gmail.com', 7773231991);


insert into users values ('Crake', '883442F8094BF7BB387BC98199D68053', 's','7777', to_date('2042-12-25','yyyy-mm-dd'));
insert into salts values ('Crake','220B5EBE80237C18B55320FB2F376B08');

insert into sensors values (01, 'Trench Entrance, Mid', 'i', 'A visual sensor placed to watch for any motion of any creatures or objects that attempt to leave or enter the trench.');
insert into sensors values (12, 'Trench Interior, Mid', 'a', 'An audio recorder placed to listen for abnormal sounds that may occur inside the trench.');
insert into sensors values (21, 'Trench Entrance, Mid', 's', 'Provdes scalar data of the area around the entrance to the trench.');
insert into sensors values (22, 'Trench Interior, Mid', 's', 'Provdes scalar data of the area around the interior of the trench.');

/*Diamond subscribed to everything, Scoot to audio and visual, dinky to scalar data.*/
insert into subscriptions values (01, 7777);
insert into subscriptions values (12, 7777);
insert into subscriptions values (21, 7777);
insert into subscriptions values (22, 7777);

insert into subscriptions values (21, 4251);
insert into subscriptions values (22, 4251);

insert into subscriptions values (01, 1213);
insert into subscriptions values (12, 1213);
-- blob data has been commented out in setup until I know what to do with it.

insert into audio_recordings values (1221, 12, to_date('2052-11-1','yyyy-mm-dd'), 15, 'A loud, unidentified sound originating from the trench.', NULL);
insert into audio_recordings values (1217, 12, to_date('2052-10-19','yyyy-mm-dd') , 20, 'Nothing of note.', NULL);

insert into images values (0142, 01, to_date('2052-11-1','yyyy-mm-dd'), 'A blurry image of some sort of massive creature exiting the trench.',NULL,NULL);

insert into scalar_data values(2121, 21, to_date('2052-11-1','yyyy-mm-dd'), 42);
insert into scalar_data values(2207, 22, to_date('2051-11-1','yyyy-mm-dd'), 02);
commit;

