CREATE DATABASE appleMusicDB;
USE appleMusicDB;

SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS USER,PAYMENT, LIBRARY,PLAYLIST,LISTENS,MUSIC,ARTIST,HEARS,GENRE,CONTAINS,FOLLOWS;
SET FOREIGN_KEY_CHECKS=1;

CREATE TABLE IF NOT EXISTS
USER
(
  IdUser    	INT PRIMARY KEY AUTO_INCREMENT,
  BirthDate 	DATE NOT NULL,
  Name      	VARCHAR(128) NOT NULL,
  Sex			    ENUM('M','F') NOT NULL,
  Joined		  DATE NOT NULL,
  Email  	  	VARCHAR(64) NOT NULL,
  Phone 	  	INT DEFAULT NULL
);

INSERT INTO
  USER(IdUser, BirthDate, Name, Sex, Joined, Email, Phone)
VALUES
  ( 1, '1999-01-30' , 'Miguel Alves' , 'M' , '2014-02-17', 'miguel@bd.com' , 911111111);
INSERT INTO USER(BirthDate, Name, Sex , Joined, Email)
VALUES
  ( '1999-10-27' , 'Cláudio Moreira'  	, 'M' , '2016-07-13' , 'lau@bd.com'			    ),
  ( '1999-03-10' , 'João Fonseca'    	  , 'M' , '2015-09-21' , 'seca@bd.com'		    ),
  ( '1998-08-07' , 'Eduardo Macedo'   	, 'M' , '2015-02-02' , 'edu@bd.com'			    ),
  ( '1999-08-20' , 'Diogo Carvalho'  	  , 'M' , '2014-12-03' , 'metaleiro@bd.com'	  ),
  ( '1997-01-22' , 'Inês Alves'      	  , 'F' , '2018-10-30' , 'ines@bd.com' 		    ),
  ( '2020-07-25' , 'Marta da Silva'     , 'F' , '2017-07-27' , 'marta@bd.com' 		  ),
  ( '1999-05-12' , 'Bernardo Fonseca'  	, 'M' , '2013-01-15' , 'bemy@bd.com' 		    ),
  ( '1999-02-25' , 'João Jacob'         , 'M' , '2016-02-27' , 'jacob@bd.com'		    ),
  ( '1999-08-14' , 'João Silva'         , 'M' , '2017-12-03' , 'jsilva@bd.com'      ),
  ( '1998-01-01' , 'Tiago Santos'       , 'M' , '2016-01-01' , 'tiago@bd.com'       ),   /*doesn't create playlist*/
  ( '1999-03-03' , 'José Moreira'       , 'M' , '2016-04-05' , 'ze@bd.com'      	  ),
  ( '1995-01-07' , 'Quim Torpedo'       , 'M' , '2017-08-20' , 'quim@bd.com'      	);   /*doesn't do anything*/


CREATE TABLE IF NOT EXISTS
PAYMENT
(
  IdUser 			  INT NOT NULL,
  Method 			  ENUM('Paypal','MasterCard', 'Visa', 'American Express' , 'Discover', 'Bitcoin') NOT NULL,
  PaymentDate 	DATE NOT NULL,
  PRIMARY KEY(IdUser),
  FOREIGN KEY(IdUser) REFERENCES USER(IdUser) ON DELETE CASCADE
);

INSERT INTO
PAYMENT(IdUser, Method, PaymentDate)
VALUES
(1 , 'Bitcoin'         , '2014-02-17'),
(2 , 'American Express', '2016-07-13'),
(3 , 'MasterCard'      , '2015-09-21'),
(4 , 'Visa'            , '2015-02-02'),
(5 , 'Discover'        , '2014-12-03'),
(6 , 'MasterCard'      , '2018-10-30'),
(7 , 'Paypal'          , '2017-07-27'),
(8 , 'Paypal'          , '2013-01-15'),
(9 , 'MasterCard'      , '2016-02-27'),
(10, 'Visa'            , '2017-02-02'),
(11, 'American Express', '2016-01-01'),
(12, 'American Express', '2016-04-05'),
(13, 'Visa'            , '2017-08-20');

CREATE TABLE IF NOT EXISTS
LIBRARY
(
  IdLibrary       INT PRIMARY KEY AUTO_INCREMENT,
  IdUser          INT NOT NULL,
  FOREIGN KEY(IdUser) REFERENCES USER(IdUser) ON DELETE CASCADE
);

INSERT INTO
  LIBRARY(IdLibrary, IdUser)
VALUES
  (1, 1);
INSERT INTO
  LIBRARY(IdUser)
VALUES
  ( 2  ), 
  ( 3  ),
  ( 4  ),
  ( 5  ),
  ( 6  ),
  ( 7  ),
  ( 8  ),
  ( 9  ),
  ( 10 ),
  ( 11 ),
  ( 12 ),
  ( 13 );




CREATE TABLE IF NOT EXISTS
PLAYLIST
(
  IdPlaylist      INT PRIMARY KEY AUTO_INCREMENT,
  IdLibrary          INT NOT NULL,
  Name            VARCHAR(128) NOT NULL,
  FOREIGN KEY(IdLibrary) REFERENCES LIBRARY(IdLibrary) ON DELETE CASCADE
);

INSERT INTO
  PLAYLIST( IdPlaylist, IdLibrary, Name)
VALUES
  (1, 1 , 'Chill'); /* Playlist Chill by Miguel Alves*/
INSERT INTO
  PLAYLIST( IdLibrary, Name)
VALUES
  ( 1 , '***core'			  ), /*Playlist '***core' by Miguel Alves*/
  ( 2 , 'Eminem'			  ), /* etc*/
  ( 3 , 'Rap'				    ),
  ( 4 , 'Trap'				  ),
  ( 5 , 'Death Metal'	  ),
  ( 6 , 'Brasileirada'  ),
  ( 7 , 'Rock'				  ),
  ( 8 , 'Classic Piano' ),
  ( 9 , 'Portugal'  	  ),
  ( 10, 'Eletrónica'		);   /*Created by ana but no user listens to this playlist*/


CREATE TABLE IF NOT EXISTS
LISTENS
(
  IdUser       INT NOT NULL,
  IdPlaylist   INT NOT NULL,
  PRIMARY KEY(IdUser,IdPlaylist),
  FOREIGN KEY(IdUser) REFERENCES USER(IdUser) ON DELETE CASCADE,
  FOREIGN KEY(IdPlaylist) REFERENCES PLAYLIST(IdPlaylist) ON DELETE CASCADE
);

INSERT INTO
  LISTENS(IdUser, IdPlaylist)
VALUES
  (1, 1), /*USER Miguel Alves listens to Playlist Chill*/
  (1, 2), /* USER Miguel Alves listens to Playlist ***core*/
  (2, 3), /*etc*/
  (3, 4),
  (4, 5),
  (5, 6),
  (6, 7),
  (7, 8),
  (7, 1),
  (8, 9),
  (9,10);


CREATE TABLE IF NOT EXISTS
ARTIST
(
  Name          VARCHAR(64) NOT NULL,
  IdArtist      INT PRIMARY KEY AUTO_INCREMENT
);

INSERT INTO
  ARTIST(Name, IdArtist)
VALUES
  ('Cuco' ,1 );
INSERT INTO
  ARTIST(Name)
VALUES
  ('Eminem'                     ),
  ('Kendrick Lamar'             ),
  ('Behemoth'                   ),
  ('Joji'                       ),
  ('Avenged Sevenfold'          ),
  ('Veil of Maya'               ),
  ('Yuzi'                       ),
  ('MC Kevinho'                 ),
  ('MC Livinho'                 ),
  ('TK from Ling tosite sigure' ),
  ('J. Cole'                    ),
  ('Ski Mask The Slump God'     ),
  ('Arch Enemy'                 ),
  ('Nirvana'                    ),
  ('Jack White'                 ),
  ('Frédéric Chopin'            ),
  ('Claude Debussy'             ),
  ('Blasted Mechanism'          ),
  ('Diabos na Cruz'             ),
  ('Mac Miller'                 ),
  ('Aries '                     ); 

CREATE TABLE IF NOT EXISTS
MUSIC
(
  IdMusic      INT PRIMARY KEY AUTO_INCREMENT,
  Name         VARCHAR(128) NOT NULL,
  Album        VARCHAR(128) DEFAULT NULL,
  IdArtist     INT NOT NULL,
  FOREIGN KEY(IdArtist) REFERENCES ARTIST(IdArtist) ON DELETE CASCADE
);

INSERT INTO
  MUSIC(IdMusic, Name, Album, IdArtist)
VALUES
  (1, 'Hydrocodone', 'Para Mi', 1 ); /* Music 'Hydrocodone' from 'Para Mi' by 'Cuco'*/
INSERT INTO
  MUSIC( Name, Album, IdArtist)
VALUES
  ('Without Me'                 						            , 'The Eminem Show'                               	, 2),
  ('untitled 02 | 06.23.2014.'      				            , 'untitled unmasterd'                            	, 3),
  ('O Father O Satan O Sun!'     						            , 'The Satanist'                                  	, 4),
  ('SLOW DANCING IN THE DARK'    						            , 'BALLADS1'                                      	, 5),
  ('TEST DRIVE'                	  					            , 'BALLADS1'                                      	, 5),
  ('Gimme Love'                 	                      ,  NULL                                           	, 5),
  ('Second Heartbeat'     	    						            , 'Waking The Fallen'                             	, 6),
  ('God Hates Us'       	                              , 'Nightmare'                           						, 6),
  ('Ellie'                      						            , 'Matriarch'                                     	, 7),
  ('Tsubasa'                    						            ,  NULL                                           	, 8),
  ('Eterna Sacanagem'           						            ,  NULL                                           	, 9),
  ('Ela Vem'                    						            ,  NULL                                           	,10),
  ('Unravel'                    						            , 'Fantastic Magic'                   					  	,11),	 /*Music isn't in any playlist*/
  ('´Till I Collapse'		    						                , 'The Eminem Show'          	         			      	, 2),
  ('Foldin Clothes'              						            , '4 Your Eyez Only'          			        		  	,12),
  ('Faucet Failure'              						            , 'Stokeley'                    				           	,13),
  ('The Eagle Flies Alone - edit'	 					            , 'Will To Power'              				             	,14),    
  ('Polly'                      						            , 'Nevermind'                   				          	,15),
  ('Freedom at 21'               	 					            , 'Blunderbuss'                 				          	,16),
  ('Études, Op.25: No.11 in A Minor'		  	            , 'Chopin: Etudes - Lang Lang'                	  	,17),
  ('Rêverie'                     						            , 'Debussy: Estampes, Pour le piano, Piano Works' 	,18),
  ('Karkov (Nadabrovitchka mix) - radio edit by DJ Dim'	, 'Mix 00'											                    ,19),
  ('Luzia'												                      , 'Roque Popular'							                  		,20),
  ('Right'                                              , 'Circles'                                         ,21), 	/*No one listens to this song*/
  ('BOUNTY HUNTER'                                      , 'BELIVE IN ME, WHO BELIEVES IN YOU'               ,22),
  ('FOOLS GOLD'                                         , 'BELIVE IN ME, WHO BELIEVES IN YOU'               ,22),
  ('RIDING'                                             , 'BELIVE IN ME, WHO BELIEVES IN YOU'               ,22),
  ('ETA'                                                , 'BELIVE IN ME, WHO BELIEVES IN YOU'               ,22),
  ('ONE PUNCH'                                          , 'BELIVE IN ME, WHO BELIEVES IN YOU'               ,22),
  ('EASY'                                               , 'BELIVE IN ME, WHO BELIEVES IN YOU'               ,22),
  ('KIDS ON MOLLY'                                      , 'BELIVE IN ME, WHO BELIEVES IN YOU'               ,22),
  ('HOW RUDE'                                           , 'BELIVE IN ME, WHO BELIEVES IN YOU'               ,22),
  ('DITTO'                                              , 'BELIVE IN ME, WHO BELIEVES IN YOU'               ,22),
  ('DESPERADO'                                          , 'BELIVE IN ME, WHO BELIEVES IN YOU'               ,22),
  ('OUTDATED'                                           , 'BELIVE IN ME, WHO BELIEVES IN YOU'               ,22),
  ('WHEN THE LIGHTS GO OUT'                             , 'BELIVE IN ME, WHO BELIEVES IN YOU'               ,22);



CREATE TABLE IF NOT EXISTS
HEARS
(
  IdUser      INT NOT NULL,
  IdMusic   	INT NOT NULL,
  PRIMARY KEY(IdUser,IdMusic),
  FOREIGN KEY(IdUser) REFERENCES USER(IdUser) ON DELETE CASCADE,
  FOREIGN KEY(IdMusic) REFERENCES MUSIC(IdMusic) ON DELETE CASCADE
);

INSERT INTO
	HEARS(IdUser, IdMusic)
VALUES
	(11,14),                  /*Tiago doesn't have a playlist so he listens directly from the album*/
	(12,14),				          /*Ze and tiago are listening to the same song*/
  (1 , 5),
  (2 ,10),
  (3 , 4),
  (4 , 1),
  (5 ,20);


CREATE TABLE IF NOT EXISTS
GENRE
(
  IdArtist         INT NOT NULL,
  Type             VARCHAR(128) NOT NULL,
  PRIMARY KEY(IdArtist,Type),
  FOREIGN KEY(IdArtist) REFERENCES ARTIST(IdArtist) ON DELETE CASCADE
);

INSERT INTO
  GENRE(IdArtist,Type)
VALUES
  (1 , 'Indie-Pop'    		   ),
  (1 , 'lo-fi'        		   ),
  (2 , 'Hip Hop'      		   ),
  (3 , 'Hip Hop'      		   ),
  (4 , 'Death Metal'  		   ),
  (5 , 'R&B'          		   ),
  (5 , 'lo-fi'        		   ),
  (6 , 'Metal-core'   		   ),
  (6 , 'Heavy-Metal'  		   ),
  (7 , 'Metal-core'   		   ),
  (8 , 'Trap'         		   ),
  (9 , 'Funk'      			     ),
  (10, 'Funk'         		   ),
  (11, 'Post-Hardcore'		   ),
  (12, 'Hip Hop'      		   ),
  (13, 'Trap'         		   ),
  (14, 'Melodic Death Metal' ),
  (15, 'Alternative Rock'	   ),
  (16, 'Blues Rock'          ),
  (17, 'Classical Music'	   ),
  (18, 'Classical Music'	   ),
  (19, 'World Music'		     ),
  (19, 'Alternative rock'	   ),
  (20, 'Rock'				         ),
  (21, 'R&B'                 ),
  (21, 'Hip Hop'             );

CREATE TABLE IF NOT EXISTS
CONTAINS
(
  IdMusic     INT NOT NULL,
  IdPlaylist  INT NOT NULL,
  FOREIGN KEY(IdMusic) REFERENCES MUSIC(IdMusic) ON DELETE CASCADE,
  FOREIGN KEY(IdPlaylist) REFERENCES PLAYLIST(IdPlaylist) ON DELETE CASCADE
);

INSERT INTO
  CONTAINS(IdMusic,IdPlaylist)
VALUES
(1 , 1),  	/*MUSIC HYDROCODONE IS CONTAINED IN CHILL PLAYLIST*/
(2 , 3),
(2 , 4),
(3 , 4),
(4 , 6),
(5 , 1),
(6 , 1),
(7 , 1),
(8 , 2),
(9 , 2),
(10, 2),
(11, 5),
(12, 7),
(13, 7),
(14, 3),
(16, 4),
(17, 5),
(18, 6),
(19, 8),
(20, 8),
(21, 9),
(22, 9),
(23,10),
(24,10);      

CREATE TABLE IF NOT EXISTS
FOLLOWS
(
  IdUser1 INT NOT NULL,
  IdUser2 INT NOT NULL,
  PRIMARY KEY(IdUser1,IDUser2),
  FOREIGN KEY(IdUser1) REFERENCES USER(IdUser) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(IdUser2) REFERENCES USER(IdUser) ON DELETE CASCADE ON UPDATE CASCADE
);


INSERT INTO
  FOLLOWS(IdUser1,IdUser2)
VALUES
(1 , 2),    /*User 1 (Miguel) FOLLOWS Uer 2 (Cláudio)*/
(1 , 3),
(1 , 4),
(2 , 1),    /*User 2 follows user 1 back */
(4 , 5),
(3 , 6),
(5 , 8),
(10 , 9),
(11 , 7);
