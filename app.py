import warnings

warnings.filterwarnings("ignore", category=FutureWarning)
import logging

from flask import Flask, abort, render_template

import db

APP = Flask(__name__)

# Start page
@APP.route('/')
def index():
    stats = {}
    x = db.execute('SELECT COUNT(*) AS music FROM MUSIC').fetchone()
    stats.update(x)
    x = db.execute('SELECT COUNT(*) AS artist FROM ARTIST').fetchone()
    stats.update(x)
    x = db.execute('SELECT COUNT(*) AS user FROM USER').fetchone()
    stats.update(x)
    logging.info(stats)
    return render_template('index.html',stats=stats)

# Initialize db
# It assumes a script called db.sql is stored in the sql folder
@APP.route('/init/')
def init(): 
    return render_template('init.html', init=db.init())
    
@APP.route('/music')
def	list_music():
		music	= db.execute(
					'''		
					SELECT MUSIC.IdMusic, MUSIC.Name, MUSIC.Album, ARTIST.Name AS ArtistName
					FROM MUSIC JOIN ARTIST ON (MUSIC.IdArtist = ARTIST.IdArtist)
					ORDER BY  ArtistName, MUSIC.Name	
					''' 
		).fetchall()
		
		return	render_template('music-list.html',	music=music)

		

@APP.route('/music/<int:id>/')
def get_music(id):
  music = db.execute(
      '''
      SELECT MUSIC.IdMusic,	MUSIC.Name,	MUSIC.Album, ARTIST.Name
	    FROM MUSIC JOIN ARTIST ON (MUSIC.IdArtist = ARTIST.IdArtist)
      WHERE IdMusic = %s
      ''', id).fetchone()

  if music is None:
     abort(404, 'Music id {} does not exist.'.format(id))

  artist = db.execute(
      '''
      SELECT ARTIST.IdArtist, ARTIST.Name
      FROM ARTIST JOIN MUSIC ON (MUSIC.IdArtist = ARTIST.IdArtist)
      WHERE IdMusic = %s 
      ORDER BY Name
      ''', id).fetchall()

  return render_template('music.html', 
           music=music, artist=artist)

@APP.route('/music/search/<expr>/')
def search_music(expr):
  search = { 'expr': expr }
  expr = '%' + expr + '%'
  music = db.execute(
      ''' 
      SELECT IdMusic, Name
      FROM MUSIC 
      WHERE Name LIKE %s
      ''', expr).fetchall()
  return render_template('music-search.html',
           search=search,music=music)

@APP.route('/artist')
def	list_artist():
		artist	= db.execute(
					'''		
					SELECT	IdArtist,	Name	
					FROM	ARTIST
					ORDER	BY  Name	
					'''
		).fetchall()
		return	render_template('artist-list.html',	artist=artist)


@APP.route('/artist/<int:id>/')
def view_music_by_artist(id):
  artist = db.execute(
    '''
    SELECT IdArtist, Name
    FROM ARTIST 
    WHERE IdArtist = %s
    ''', id).fetchone()

  if artist is None:
     abort(404, 'Artist id {} does not exist.'.format(id))

  music = db.execute(
    '''
    SELECT MUSIC.IdMusic, MUSIC.Name
    FROM MUSIC JOIN ARTIST ON (MUSIC.IdArtist = ARTIST.IdArtist)
    WHERE ARTIST.IdArtist = %s
    ORDER BY Name
    ''', id).fetchall()

  return render_template('artist.html', 
           artist=artist, music=music)
 

@APP.route('/artist/search/<expr>/')
def search_artist(expr):
  search = { 'expr': expr }
  
  artist = db.execute(
      ' SELECT IdArtist, Name'
      ' FROM ARTIST '
      ' WHERE NAME LIKE \'%' + expr + '%\''
    ).fetchall()
	

  return render_template('artist-search.html', 
           search=search,artist=artist)

@APP.route('/user/')
def	list_user():
		user	= db.execute(
					'''		
					SELECT Name, BirthDate, Sex, Email, Phone, Joined
					FROM USER
					ORDER BY  Joined 
					''' 
		).fetchall()
		return	render_template('user-list.html', user=user)

# Genres
@APP.route('/genres/')
def list_genres():
    genres = db.execute('''
     
	  SELECT DISTINCT GENRE.Type, ARTIST.Name, ARTIST.IdArtist AS Aux
	  FROM GENRE JOIN ARTIST ON (GENRE.IdArtist = ARTIST.IdArtist)
    ORDER BY GENRE.Type
    ''').fetchall()
    
    return render_template('genre-list.html', genres=genres)

# Album
@APP.route('/album/')
def list_album():
    album = db.execute('''
    SELECT DISTINCT Album, IdArtist
	  FROM MUSIC
	  ORDER BY Album
    ''').fetchall()
    return render_template('album-list.html', album=album)

@APP.route('/playlist/')
def list_playlist():
    playlist = db.execute('''
    SELECT LIBRARY.IdUser, PLAYLIST.Name AS PlaylistName, USER.Name AS UserName, PLAYLIST.IdPlaylist
    FROM LIBRARY JOIN PLAYLIST ON (PLAYLIST.IdLibrary = LIBRARY.IdLibrary)
    JOIN USER ON (LIBRARY.IdUser = USER.IdUser)
    ORDER BY PLAYLIST.NAME
    ''').fetchall()
    
    nmr = db.execute(
    '''
    SELECT PLAYLIST.Name, COUNT(MUSIC.IdMusic) AS NmrSongs
    FROM PLAYLIST JOIN CONTAINS ON (CONTAINS.IdPlaylist = PLAYLIST.IdPlaylist)
    JOIN MUSIC ON (CONTAINS.IdMusic = MUSIC.IdMusic)
    GROUP BY PLAYLIST.Name
    ''').fetchall()
    return render_template('playlist-list.html', playlist=playlist, nmr=nmr)

@APP.route('/playlist/<int:id>/')
def view_music_by_playlist(id):
  playlist = db.execute(
    '''
    SELECT IdPlaylist, Name
    FROM PLAYLIST 
    WHERE IdPlaylist = %s
    ''', id).fetchone()

  if playlist is None:
     abort(404, 'Playlist id {} does not exist.'.format(id))

  music = db.execute(
    '''
    SELECT MUSIC.IdMusic, MUSIC.Name
    FROM MUSIC JOIN CONTAINS ON (MUSIC.IdMusic = CONTAINS.IdMusic) 
    WHERE CONTAINS.IdPlaylist = %s
    ''', id).fetchall()

 
  return render_template('playlist.html', 
           playlist=playlist, music=music)

# TODO 
# ...